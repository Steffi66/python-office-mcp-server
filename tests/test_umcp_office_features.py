"""Application-specific use of upgraded schemas, metadata, progress and cancellation."""

import asyncio
import json
import threading
import time

from openpyxl import Workbook

from office_server import OfficeServer
from tools import mutation
from umcp_shared import MCPRequestCancelled, MCPRequestContext, get_request_context


def request(method, params=None, ident=1):
    return json.dumps({"jsonrpc": "2.0", "id": ident, "method": method, "params": params or {}})


def test_object_schemas_and_conservative_annotations():
    tools = {t["name"]: t for t in OfficeServer().discover_tools()["tools"]}
    for tool in tools.values():
        assert tool.get("outputSchema", {"type": "object"})["type"] == "object"
    assert "outputSchema" not in tools["office_read"]
    for name in ["office_help", "office_read", "office_inspect", "word_list_anchors"]:
        assert tools[name]["annotations"]["readOnlyHint"] is True
    for name in ["office_patch", "office_table", "office_comment", "office_template", "word_generate_sow", "restart_server"]:
        assert tools[name]["annotations"]["readOnlyHint"] is False
        assert tools[name]["annotations"]["destructiveHint"] is True
    item = tools["office_patch"]["inputSchema"]["properties"]["changes"]["items"]
    assert item["required"] == ["target"]
    assert item["properties"]["value"] == {}


def test_tool_failures_are_structured_errors_without_losing_legacy_text():
    async def check():
        server = OfficeServer()
        response = await server.process_request_async(request("tools/call", {"name": "office_help", "arguments": {"goal": "nonexistent"}}))
        result = response["result"]
        assert result["isError"] is True
        assert result["structuredContent"] == json.loads(result["content"][0]["text"])
        ok = await server.process_request_async(request("tools/call", {"name": "office_help", "arguments": {}}))
        assert ok["result"]["isError"] is False
    asyncio.run(check())


def test_prompts_resources_completion_are_guidance_only(tmp_path):
    async def check():
        server = OfficeServer()
        config = server.get_config()
        assert config["serverInfo"]["name"] == "office-mcp-server"
        assert "completions" in config["capabilities"]
        listed = await server.process_request_async(request("resources/list"))
        assert [r["uri"] for r in listed["result"]["resources"]] == ["office://guidance/workflows"]
        content = await server.process_request_async(request("resources/read", {"uri": "office://guidance/workflows"}))
        assert "office_patch" in content["result"]["contents"][0]["text"]
        denied = await server.process_request_async(request("resources/read", {"uri": "file:///etc/passwd"}))
        assert denied["error"]["code"] == -32002
        path = tmp_path / "does-not-exist.docx"
        prompt = await server.process_request_async(request("prompts/get", {"name": "review_document", "arguments": {"file_path": str(path)}}))
        assert prompt["result"]["messages"][0]["role"] == "user"
        assert "strict" in prompt["result"]["messages"][0]["content"]["text"]
        assert not path.exists()
        completion = await server.process_request_async(request("completion/complete", {
            "ref": {"type": "ref/prompt", "name": "review_document"},
            "argument": {"name": "document_type", "value": "po"},
        }))
        assert completion["result"]["completion"]["values"] == ["powerpoint"]
    asyncio.run(check())


def test_progress_requires_token_and_context_is_reset():
    async def check():
        server = OfficeServer()
        notes = []
        async def capture(method, params):
            notes.append((method, params))
        server._send_notification_async = capture
        await server.process_request_async(request("tools/call", {"name": "office_help"}))
        assert not notes
        await server.process_request_async(request("tools/call", {"name": "office_help", "_meta": {"progressToken": "progress-1"}}))
        assert [p["progress"] for _, p in notes] == [0, 1]
        assert all(p["progressToken"] == "progress-1" for _, p in notes)
        assert get_request_context().request_id is None
    asyncio.run(check())


def test_sync_worker_cancellation_prevents_publication(tmp_path, monkeypatch):
    source, output = tmp_path / "input.xlsx", tmp_path / "output.xlsx"
    wb = Workbook()
    wb.active["A1"] = "original"
    wb.save(source)
    output.write_bytes(b"previous destination")
    original_bytes = source.read_bytes()
    entered, release, stopped = threading.Event(), threading.Event(), threading.Event()
    real_validate = mutation.validate_staged_document
    real_stage = mutation._stage_patch_locked
    observed = []

    def validation(path):
        observed.append(get_request_context())
        entered.set()
        assert release.wait(5)
        real_validate(path)

    def stage(*args, **kwargs):
        try:
            return real_stage(*args, **kwargs)
        except MCPRequestCancelled:
            stopped.set()
            raise

    monkeypatch.setattr(mutation, "validate_staged_document", validation)
    monkeypatch.setattr(mutation, "_stage_patch_locked", stage)

    async def check():
        server = OfficeServer()
        task = asyncio.create_task(server.process_request_async(request("tools/call", {
            "name": "office_patch", "arguments": {"file_path": str(source), "output_path": str(output),
            "mode": "strict", "changes": [{"target": "A1", "value": "changed"}]},
        }, ident=41), context=MCPRequestContext(transport="stdio", principal="local-test")))
        try:
            assert await asyncio.to_thread(entered.wait, 5)
            notification = json.dumps({"jsonrpc": "2.0", "method": "notifications/cancelled", "params": {"requestId": 41}})
            assert await server.process_request_async(notification, context=MCPRequestContext(transport="stdio", principal="local-test")) is None
            response = await task
            assert response["error"]["code"] == -32800
        finally:
            release.set()
        assert await asyncio.to_thread(stopped.wait, 5)
        assert get_request_context().request_id is None
    asyncio.run(check())
    assert observed[0].request_id == 41 and observed[0].principal == "local-test"
    assert source.read_bytes() == original_bytes
    assert output.read_bytes() == b"previous destination"
    assert not mutation._path_locks
    assert not any(p.is_dir() for p in tmp_path.iterdir())


def test_cancellation_ids_are_isolated_between_http_sessions():
    async def check():
        server = OfficeServer()
        entered = [asyncio.Event(), asyncio.Event()]
        release = asyncio.Event()

        async def blocked(which: int) -> dict:
            entered[which].set()
            await release.wait()
            return {"which": which}

        server.register_tool("blocked", blocked)
        contexts = [MCPRequestContext(transport="streamable-http", session_id=s, principal="same-principal") for s in ["session-a", "session-b"]]
        tasks = [asyncio.create_task(server.process_request_async(request("tools/call", {"name": "blocked", "arguments": {"which": i}}, ident=7), context=ctx)) for i, ctx in enumerate(contexts)]
        try:
            await asyncio.wait_for(asyncio.gather(*(event.wait() for event in entered)), 3)
            await server.process_request_async(json.dumps({"jsonrpc": "2.0", "method": "notifications/cancelled", "params": {"requestId": 7}}), context=contexts[0])
            first = await asyncio.wait_for(tasks[0], 3)
            assert first["error"]["code"] == -32800
            assert not tasks[1].done()
            release.set()
            second = await asyncio.wait_for(tasks[1], 3)
            assert second["result"]["structuredContent"] == {"which": 1}
            assert not server._active_requests_by_id
        finally:
            release.set()
            for task in tasks:
                if not task.done():
                    task.cancel()
            await asyncio.gather(*tasks, return_exceptions=True)
    asyncio.run(check())


def test_http_progress_routes_only_to_originating_session():
    from aioumcp import _AsyncStreamableHTTPSession

    async def check():
        server = OfficeServer()
        server._streamable_http_active = True
        sessions = {}
        for sid in ['a', 'b']:
            session = _AsyncStreamableHTTPSession('same', '2025-03-26', time.monotonic(), time.monotonic(), asyncio.Event(), asyncio.Queue())
            session.writer = object()
            sessions[sid] = session
        server._streamable_http_sessions.update(sessions)
        await server.process_request_async(request('tools/call', {'name': 'office_help', '_meta': {'progressToken': 'private'}}, ident=9), context=MCPRequestContext(transport='streamable-http', session_id='a', principal='same'))
        assert sessions['a'].queue.qsize() == 2
        assert sessions['b'].queue.empty()
        await server.process_request_async(request('tools/call', {'name': 'office_help', '_meta': {'progressToken': 'stateless'}}, ident=10), context=MCPRequestContext(transport='streamable-http', principal='same'))
        assert sessions['a'].queue.qsize() == 2
        assert sessions['b'].queue.empty()
    asyncio.run(check())
