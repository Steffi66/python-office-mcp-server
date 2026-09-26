"""Pinned installed transport dependency and application protocol behaviour."""

import asyncio
import json
from importlib.metadata import distribution
from pathlib import Path

from office_server import DEPRECATED_TOOLS, OfficeServer

ROOT = Path(__file__).parents[1]


def test_transport_comes_from_pinned_dependency_not_application_source():
    import aioumcp
    import umcp_shared

    dependency = distribution("umcp")
    assert dependency.version == "0.2.2"
    source = json.loads(dependency.read_text("direct_url.json"))
    assert source["url"] == "https://github.com/rcarmo/umcp.git"
    assert source["vcs_info"]["commit_id"] == "30cce7dfe08c6ee63de235f7d81754ba286dafbb"
    assert any(str(path).endswith("licenses/LICENSE") for path in dependency.files)
    for module in (aioumcp, umcp_shared):
        filename = Path(module.__file__).name
        assert Path(module.__file__).resolve() == Path(dependency.locate_file(filename)).resolve()
        assert not (ROOT / filename).exists()


def test_pagination_filters_legacy_tools_before_paging():
    async def check():
        server = OfficeServer()
        expected = [t["name"] for t in server.discover_tools()["tools"]]
        names, cursor = [], None
        while True:
            params = {"pageSize": 7}
            if cursor:
                params["cursor"] = cursor
            response = await server.process_request_async(json.dumps({"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": params}))
            result = response["result"]
            names.extend(t["name"] for t in result["tools"])
            cursor = result.get("nextCursor")
            if not cursor:
                break
        assert names == expected == sorted(expected)
        assert not DEPRECATED_TOOLS.intersection(names)
    asyncio.run(check())


def test_mapping_result_keeps_text_and_exposes_structured_content():
    response = asyncio.run(OfficeServer().handle_tools_call_async(1, {"name": "office_help", "arguments": {}}))
    result = response["result"]
    assert result["structuredContent"] == json.loads(result["content"][0]["text"])
    assert result["structuredContent"]["success"] is True


def test_supported_initialize_versions_are_negotiated():
    async def check():
        for requested, expected in [("2024-11-05", "2024-11-05"), ("2025-03-26", "2025-03-26"), ("unknown", "2025-03-26")]:
            response = await OfficeServer().process_request_async(json.dumps({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": requested}}))
            assert response["result"]["protocolVersion"] == expected
    asyncio.run(check())
