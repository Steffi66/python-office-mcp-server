@captured @python_candidate
Feature: office help native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-office-help-d5eb3bbdf1
  # Native: tests/test_office_help.py::TestOfficeHelp::test_summary_returns_compact_word_sow_guidance
  Scenario: Native check: summary returns compact word sow guidance [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using goal "fill_sow_from_markdown"; document type "word"; format "summary"
    Then result at "success" is true
    And result at "goal" equals "fill_sow_from_markdown"
    And result at "document_type" equals "word"
    And result at "recommended" at 0 at "tool" equals "word_create_sow_from_markdown"
    And "word_generate_sow" occurs in result at "fallbacks"
    And "unmapped_sections" occurs in result at "watch_for"
    And result at "tool_model" at "primary" equals "core_first"
    And "office_help" occurs in result at "tool_model" at "core_tools"
    And result at "notes" is non-empty or true
    And the number of entries in result at "notes" equals 1
    And "workflow_steps" does not occur in result

  @candidate-python-office-help-83b6ff8b41
  # Native: tests/test_office_help.py::TestOfficeHelp::test_detailed_returns_fallbacks_and_workflow_steps
  Scenario: Native check: detailed returns fallbacks and workflow steps [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using goal "patch_estimate_workbook"; document type "excel"; format "detailed"
    Then result at "success" is true
    And result at "goal" equals "patch_estimate_workbook"
    And result at "document_type" equals "excel"
    And result at "recommended" at 0 at "tool" equals "office_patch"
    And "package-preservation warnings" occurs in result at "watch_for"
    And "workflow_steps" occurs in result
    And the number of entries in result at "notes" is at least 2

  @candidate-python-office-help-c22e31290a
  # Native: tests/test_office_help.py::TestOfficeHelp::test_task_mapping_resolves_common_consulting_phrase
  Scenario: Native check: task mapping resolves common consulting phrase [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using task "Fill a Word SOW template from markdown and preserve template structure"; format "summary"
    Then result at "success" is true
    And result at "goal" equals "fill_sow_from_markdown"
    And result at "task_interpreted_as" equals "fill_sow_from_markdown"
    And result at "document_type" equals "word"

  @candidate-python-office-help-b08ab098a6
  # Native: tests/test_office_help.py::TestOfficeHelp::test_additive_narrative_constraint_prioritizes_anchor_insertion
  Scenario: Native check: additive narrative constraint prioritizes anchor insertion [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using goal "insert_architecture_narrative"; constraints ["additive_narrative_edits"]; format "summary"
    Then result at "success" is true
    And result at "recommended" at 0 at "tool" equals "word_insert_at_anchor"

  @candidate-python-office-help-bfe1d1d20c
  # Native: tests/test_office_help.py::TestOfficeHelp::test_powerpoint_goal_supported
  Scenario: Native check: powerpoint goal supported [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using goal "create_review_deck"; document type "powerpoint"; format "summary"
    Then result at "success" is true
    And result at "document_type" equals "powerpoint"
    And result at "recommended" at 0 at "tool" equals "pptx_from_markdown"
    And "pptx_add_slide" occurs in result at "fallbacks"

  @candidate-python-office-help-eb0e9e4f56
  # Native: tests/test_office_help.py::TestOfficeHelp::test_no_goal_returns_core_overview
  Scenario: Native check: no goal returns core overview [TestOfficeHelp]
    Given tool is prepared as the result of DiscoveryTools with no arguments
    When tool.tool office help using the prepared inputs
    Then result at "success" is true
    And "office_help" occurs in result at "core_tools"
    And "fill_sow_from_markdown" occurs in result at "common_goals"
    And "fallback" occurs in result at "advanced_tool_classes"
    And "goal" does not occur in result

  @candidate-python-office-help-c1cfd336e7
  # Native: tests/test_office_help.py::TestOfficeHelp::test_mcp_server_exposes_office_help_and_returns_recommendations
  Scenario: Native check: mcp server exposes office help and returns recommendations [TestOfficeHelp]
    Given server is prepared as the result of OfficeServer with no arguments
    And response is prepared as the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}}
    And payload is prepared as the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}} field "result", defaulting to {} field "content", defaulting to [] at 0 at "text"
    And result is prepared as the result of json.loads with the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}} field "result", defaulting to {} field "content", defaulting to [] at 0 at "text"
    When server.handle tools call async using request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}}
    Then the result of json.loads with the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}} field "result", defaulting to {} field "content", defaulting to [] at 0 at "text" field "success" is true
    And the result of json.loads with the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}} field "result", defaulting to {} field "content", defaulting to [] at 0 at "text" field "goal" equals "fill_sow_from_markdown"
    And the result of json.loads with the result of asyncio.run with the result of server.handle tools call async with request id 1; params {"name": "office_help", "arguments": {"goal": "fill_sow_from_markdown", "document_type": "word", "format": "summary"}} field "result", defaulting to {} field "content", defaulting to [] at 0 at "text" field "recommended", defaulting to [] at 0 at "tool" equals "word_create_sow_from_markdown"
