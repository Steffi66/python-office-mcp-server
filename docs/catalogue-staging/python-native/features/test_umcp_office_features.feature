@captured @python_candidate
Feature: umcp office features native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-umcp-office-features-3c91b85f24
  # Native: tests/test_umcp_office_features.py::test_object_schemas_and_conservative_annotations
  Scenario: Native check: object schemas and conservative annotations
    Given tools is prepared as t for each t in the result of OfficeServer().discover tools with no arguments at "tools"
    When OfficeServer().discover tools using the prepared inputs
    And tools.values using the prepared inputs
    Then tool field "outputSchema", defaulting to {"type": "object"} at "type" equals "object"
    And "outputSchema" does not occur in t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at "office_read"
    And t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at name at "annotations" at "readOnlyHint" is true
    And t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at name at "annotations" at "readOnlyHint" is false
    And t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at name at "annotations" at "destructiveHint" is true
    And t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at "office_patch" at "inputSchema" at "properties" at "changes" at "items" at "required" equals ["target"]
    And t for each t in the result of OfficeServer().discover tools with no arguments at "tools" at "office_patch" at "inputSchema" at "properties" at "changes" at "items" at "properties" at "value" equals {}

  @candidate-python-umcp-office-features-1f021bcb45
  # Native: tests/test_umcp_office_features.py::test_tool_failures_are_structured_errors_without_losing_legacy_text
  Scenario: Native check: tool failures are structured errors without losing legacy text
    Given the native tool failures are structured errors without losing legacy text inputs and isolated test state
    When server.process request async using the result of request with "tools/call"; {"name": "office_help", "arguments": {"goal": "nonexistent"}}
    And server.process request async using the result of request with "tools/call"; {"name": "office_help", "arguments": {}}
    Then response at "result" at "isError" is true
    And response at "result" at "structuredContent" equals the result of json.loads with response at "result" at "content" at 0 at "text"
    And ok at "result" at "isError" is false

  @candidate-python-umcp-office-features-6d38cf3c2a
  # Native: tests/test_umcp_office_features.py::test_prompts_resources_completion_are_guidance_only
  Scenario: Native check: prompts resources completion are guidance only
    Given an isolated writable temporary directory
    When server.process request async using the result of request with "resources/list"
    And server.process request async using the result of request with "resources/read"; {"uri": "office://guidance/workflows"}
    And server.process request async using the result of request with "resources/read"; {"uri": "file:///etc/passwd"}
    And server.process request async using the result of request with "prompts/get"; the fields "name" set to "review_document", "arguments" set to the fields "file_path" set to str representation of tmp path under "does-not-exist.docx"
    And server.process request async using the result of request with "completion/complete"; {"ref": {"type": "ref/prompt", "name": "review_document"}, "argument": {"name": "document_type", "value": "po"}}
    Then the result of server.get config with no arguments at "serverInfo" at "name" equals "office-mcp-server"
    And "completions" occurs in the result of server.get config with no arguments at "capabilities"
    And r at "uri" for each r in listed at "result" at "resources" equals ["office://guidance/workflows"]
    And "office_patch" occurs in content at "result" at "contents" at 0 at "text"
    And denied at "error" at "code" equals -32002
    And prompt at "result" at "messages" at 0 at "role" equals "user"
    And "strict" occurs in prompt at "result" at "messages" at 0 at "content" at "text"
    And not tmp path under "does-not-exist.docx" exists
    And completion at "result" at "completion" at "values" equals ["powerpoint"]

  @candidate-python-umcp-office-features-246e8859a8
  # Native: tests/test_umcp_office_features.py::test_progress_requires_token_and_context_is_reset
  Scenario: Native check: progress requires token and context is reset
    Given the native progress requires token and context is reset inputs and isolated test state
    When server.process request async using the result of request with "tools/call"; {"name": "office_help"}
    And server.process request async using the result of request with "tools/call"; {"name": "office_help", "_meta": {"progressToken": "progress-1"}}
    Then not []
    And p at "progress" for each the entries , p in [] equals [0, 1]
    And every item satisfies p at "progressToken" equals "progress-1" for each the entries , p in []
    And the result of get request context with no arguments request id is null

  @candidate-python-umcp-office-features-a335d2f7cb
  # Native: tests/test_umcp_office_features.py::test_sync_worker_cancellation_prevents_publication
  Scenario: Native check: sync worker cancellation prevents publication
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And wb.save with source
    And output.write bytes with "b'previous destination'"
    And wb is prepared as the result of Workbook with no arguments
    And the result of Workbook with no arguments active at "A1" is set to "original"
    And original bytes is prepared as saved bytes of source
    And real validate is prepared as mutation validate staged document
    And real stage is prepared as mutation stage patch locked
    And observed is prepared as []
    When server.process request async using the result of request with "tools/call"; the fields "name" set to "office_patch", "arguments" set to the fields "file_path" set to str representation of source, "output_path" set to str representation of output, "mode" set to "strict", "changes" set to [{"target": "A1", "value": "changed"}]; ident 41; context the result of MCPRequestContext with transport "stdio"; principal "local-test"
    Then the result of release.wait with 5 is non-empty or true
    And the result of asyncio.to thread with stopped wait; 5
    And the result of get request context with no arguments request id is null
    And the result of asyncio.to thread with entered wait; 5
    And the result of server.process request async with the result of json.dumps with {"jsonrpc": "2.0", "method": "notifications/cancelled", "params": {"requestId": 41}}; context the result of MCPRequestContext with transport "stdio"; principal "local-test" is null
    And task at "error" at "code" equals -32800
    And [] at 0 request id equals 41 and [] at 0 principal equals "local-test"
    And saved bytes of source equals saved bytes of source
    And saved bytes of output equals "b'previous destination'"
    And not mutation path locks
    And not at least one item satisfies the result of p.is dir with no arguments for each p in the result of tmp path.iterdir with no arguments

  @candidate-python-umcp-office-features-5c5fbc7b2e
  # Native: tests/test_umcp_office_features.py::test_cancellation_ids_are_isolated_between_http_sessions
  Scenario: Native check: cancellation ids are isolated between http sessions
    Given the native cancellation ids are isolated between http sessions inputs and isolated test state
    When server.process request async using the result of request with "tools/call"; the fields "name" set to "blocked", "arguments" set to the fields "which" set to i; ident 7; context ctx
    And server.process request async using the result of json.dumps with {"jsonrpc": "2.0", "method": "notifications/cancelled", "params": {"requestId": 7}}; context the result of MCPRequestContext with transport "streamable-http"; session id s; principal "same-principal" for each s in ["session-a", "session-b"] at 0
    Then the result of asyncio.wait for with tasks at 0; 3 at "error" at "code" equals -32800
    And not the result of tasks[1].done with no arguments
    And the result of asyncio.wait for with tasks at 1; 3 at "result" at "structuredContent" equals {"which": 1}
    And not the result of OfficeServer with no arguments active requests by id

  @candidate-python-umcp-office-features-54e7a2946e
  # Native: tests/test_umcp_office_features.py::test_http_progress_routes_only_to_originating_session
  Scenario: Native check: http progress routes only to originating session
    Given the native http progress routes only to originating session inputs and isolated test state
    When server.process request async using the result of request with "tools/call"; {"name": "office_help", "_meta": {"progressToken": "private"}}; ident 9; context the result of MCPRequestContext with transport "streamable-http"; session id "a"; principal "same"
    And server.process request async using the result of request with "tools/call"; {"name": "office_help", "_meta": {"progressToken": "stateless"}}; ident 10; context the result of MCPRequestContext with transport "streamable-http"; principal "same"
    Then the result of sessions['a'].queue.qsize with no arguments equals 2
    And the result of sessions['b'].queue.empty with no arguments is non-empty or true
