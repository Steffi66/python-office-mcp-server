@captured @python_candidate
Feature: aioumcp validation native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-aioumcp-validation-c308666e93
  # Native: tests/test_aioumcp_validation.py::test_tool_schema_disallows_unknown_properties
  Scenario: Native check: tool schema disallows unknown properties
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "office_comment"
    Then schema field "additionalProperties" is false

  @candidate-python-aioumcp-validation-d7f062d0aa
  # Native: tests/test_aioumcp_validation.py::test_rejects_unknown_parameters
  Scenario: Native check: rejects unknown parameters
    Given server is prepared as the result of OfficeServer with no arguments
    And response is prepared as the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_comment", "arguments": {"file_path": "dummy.pptx", "comment": "invalid"}}
    And error is prepared as the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_comment", "arguments": {"file_path": "dummy.pptx", "comment": "invalid"}} field "error", defaulting to {}
    When server.handle tools call async using request id 1; params {"name": "office_comment", "arguments": {"file_path": "dummy.pptx", "comment": "invalid"}}
    Then "Unrecognized parameter" occurs in the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_comment", "arguments": {"file_path": "dummy.pptx", "comment": "invalid"}} field "error", defaulting to {} field "message", defaulting to ""

  @candidate-python-aioumcp-validation-8c27f37793
  # Native: tests/test_aioumcp_validation.py::test_markdown_tools_expose_markdown_file_and_oneof
  Scenario: Native check: markdown tools expose markdown file and oneof
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; tool name
    Then "markdown" occurs in schema field "properties", defaulting to {}
    And "markdown_file" occurs in schema field "properties", defaulting to {}
    And "oneOf" occurs in schema
    And {"required": ["markdown"]} occurs in schema at "oneOf"
    And {"required": ["markdown_file"]} occurs in schema at "oneOf"

  @candidate-python-aioumcp-validation-5601bb6ef3
  # Native: tests/test_aioumcp_validation.py::test_word_create_sow_schema_marks_template_required
  Scenario: Native check: word create sow schema marks template required
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_create_sow_from_markdown"
    Then "output_path" occurs in schema field "required", defaulting to []
    And "template_path" occurs in schema field "required", defaulting to []

  @candidate-python-aioumcp-validation-745f8ba268
  # Native: tests/test_aioumcp_validation.py::test_office_comment_supports_reply_resolve_and_reopen_operations
  Scenario: Native check: office comment supports reply resolve and reopen operations
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "office_comment"
    Then "reply" occurs in schema field "properties", defaulting to {} field "operation", defaulting to {} field "enum", defaulting to []
    And "resolve" occurs in schema field "properties", defaulting to {} field "operation", defaulting to {} field "enum", defaulting to []
    And "reopen" occurs in schema field "properties", defaulting to {} field "operation", defaulting to {} field "enum", defaulting to []

  @candidate-python-aioumcp-validation-45b735e5cc
  # Native: tests/test_aioumcp_validation.py::test_word_comment_tools_expose_resolution_and_threading_parameters
  Scenario: Native check: word comment tools expose resolution and threading parameters
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_get_comments"
    And get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_reply_to_comment"
    And get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_resolve_comment"
    Then "filter" occurs in get schema field "properties", defaulting to {}
    And "format" occurs in get schema field "properties", defaulting to {}
    And "author" occurs in get schema field "properties", defaulting to {}
    And "auto_resolve" occurs in reply schema field "properties", defaulting to {}
    And "file_path" occurs in resolve schema field "properties", defaulting to {}
    And "comment_id" occurs in resolve schema field "properties", defaulting to {}
    And "resolved" occurs in resolve schema field "properties", defaulting to {}

  @candidate-python-aioumcp-validation-b1ae33ab51
  # Native: tests/test_aioumcp_validation.py::test_word_insert_at_anchor_schema_present
  Scenario: Native check: word insert at anchor schema present
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_insert_at_anchor"
    Then "file_path" occurs in schema field "required", defaulting to []
    And "content" occurs in schema field "required", defaulting to []
    And "anchor_text" occurs in schema field "properties", defaulting to {}
    And "paragraph_index" occurs in schema field "properties", defaulting to {}
    And "position" occurs in schema field "properties", defaulting to {}

  @candidate-python-aioumcp-validation-ee8eac3719
  # Native: tests/test_aioumcp_validation.py::test_office_help_schema_present
  Scenario: Native check: office help schema present
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "office_help"
    Then "goal" occurs in schema field "properties", defaulting to {}
    And "document_type" occurs in schema field "properties", defaulting to {}
    And "constraints" occurs in schema field "properties", defaulting to {}
    And "task" occurs in schema field "properties", defaulting to {}
    And "format" occurs in schema field "properties", defaulting to {}

  @candidate-python-aioumcp-validation-762c1bcabb
  # Native: tests/test_aioumcp_validation.py::test_mutation_tools_expose_mode_parameter
  Scenario: Native check: mutation tools expose mode parameter
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; tool name
    Then "mode" occurs in schema field "properties", defaulting to {}

  @candidate-python-aioumcp-validation-398a4d3852
  # Native: tests/test_aioumcp_validation.py::test_anchor_discovery_tools_schema_present
  Scenario: Native check: anchor discovery tools schema present
    Given server is prepared as the result of OfficeServer with no arguments
    And tools is prepared as the result of server.discover tools with no arguments field "tools", defaulting to []
    When get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; tool name
    And get tool schema using the result of server.discover tools with no arguments field "tools", defaulting to []; "word_list_anchors"
    Then schema is non-empty or true
    And "query" occurs in anchor schema field "properties", defaulting to {}
    And "include_paragraphs" occurs in anchor schema field "properties", defaulting to {}

  @candidate-python-aioumcp-validation-d6379c7a99
  # Native: tests/test_aioumcp_validation.py::test_server_instructions_mention_core_first_discovery_guidance_and_word_insertion
  Scenario: Native check: server instructions mention core first discovery guidance and word insertion
    Given server is prepared as the result of OfficeServer with no arguments
    And instructions is prepared as the result of server.get instructions with no arguments
    When server.get instructions using the prepared inputs
    Then "core-first" occurs in the result of server.get instructions with no arguments
    And "office_help" occurs in the result of server.get instructions with no arguments
    And "office_read" occurs in the result of server.get instructions with no arguments
    And "word_insert_at_anchor" occurs in the result of server.get instructions with no arguments
    And "fallback" occurs in the result of server.get instructions with no arguments
    And "section:" occurs in the result of server.get instructions with no arguments
    And "word_audit_completion" occurs in the result of server.get instructions with no arguments

  @candidate-python-aioumcp-validation-cd4ea4040d
  # Native: tests/test_aioumcp_validation.py::test_word_insert_at_anchor_runtime_via_mcp_handler
  Scenario: Native check: word insert at anchor runtime via mcp handler
    Given an isolated writable temporary directory
    And doc.save with temp dir under "anchor_runtime.docx"
    And server is prepared as the result of OfficeServer with no arguments
    And path is prepared as temp dir under "anchor_runtime.docx"
    And out is prepared as temp dir under "anchor_runtime_out.docx"
    And doc is prepared as the result of Document with no arguments
    And response is prepared as the result of asyncio.run with the result of server.handle tools call async with request id 1; params the fields "name" set to "word_insert_at_anchor", "arguments" set to the fields "file_path" set to str representation of temp dir under "anchor_runtime.docx", "output_path" set to str representation of temp dir under "anchor_runtime_out.docx", "anchor_text" set to "Anchor paragraph", "position" set to "after", "content" set to ["Inserted via MCP handler"]
    When server.handle tools call async using request id 1; params the fields "name" set to "word_insert_at_anchor", "arguments" set to the fields "file_path" set to str representation of temp dir under "anchor_runtime.docx", "output_path" set to str representation of temp dir under "anchor_runtime_out.docx", "anchor_text" set to "Anchor paragraph", "position" set to "after", "content" set to ["Inserted via MCP handler"]
    Then "error" does not occur in the result of asyncio.run with the result of server.handle tools call async with request id 1; params the fields "name" set to "word_insert_at_anchor", "arguments" set to the fields "file_path" set to str representation of temp dir under "anchor_runtime.docx", "output_path" set to str representation of temp dir under "anchor_runtime_out.docx", "anchor_text" set to "Anchor paragraph", "position" set to "after", "content" set to ["Inserted via MCP handler"]
    And "Inserted 1 paragraph" occurs in the result of ''.join with block field "text", defaulting to "" for each block in the result of asyncio.run with the result of server.handle tools call async with request id 1; params the fields "name" set to "word_insert_at_anchor", "arguments" set to the fields "file_path" set to str representation of temp dir under "anchor_runtime.docx", "output_path" set to str representation of temp dir under "anchor_runtime_out.docx", "anchor_text" set to "Anchor paragraph", "position" set to "after", "content" set to ["Inserted via MCP handler"] at "result" field "content", defaulting to []
    And the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "anchor_runtime_out.docx" paragraphs where the result of get text with track changes with p with boundary whitespace removed equals ["Intro", "Anchor paragraph", "Inserted via MCP handler"]
