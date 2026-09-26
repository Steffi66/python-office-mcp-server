@captured @python_candidate
Feature: transport dependency native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-transport-dependency-b170ddf54d
  # Native: tests/test_transport_dependency.py::test_transport_comes_from_pinned_dependency_not_application_source
  Scenario: Native check: transport comes from pinned dependency not application source
    Given dependency is prepared as the result of distribution with "umcp"
    When distribution using "umcp"
    And json.loads using saved text of the result of distribution with "umcp"
    And dependency.read text using "direct_url.json"
    Then the result of distribution with "umcp" version equals "0.2.2"
    And the result of json.loads with saved text of the result of distribution with "umcp" at "url" equals "https://github.com/rcarmo/umcp.git"
    And the result of json.loads with saved text of the result of distribution with "umcp" at "vcs_info" at "commit_id" equals "30cce7dfe08c6ee63de235f7d81754ba286dafbb"
    And at least one item satisfies str representation of path ends with "licenses/LICENSE" for each path in the result of distribution with "umcp" files
    And the result of Path(module. file ).resolve with no arguments equals the result of Path(dependency.locate file(filename)).resolve with no arguments
    And not ROOT under the result of Path with module file name exists

  @candidate-python-transport-dependency-0a63a3fe37
  # Native: tests/test_transport_dependency.py::test_pagination_filters_legacy_tools_before_paging
  Scenario: Native check: pagination filters legacy tools before paging
    Given the native pagination filters legacy tools before paging inputs and isolated test state
    When server.process request async using the result of json.dumps with the fields "jsonrpc" set to "2.0", "id" set to 1, "method" set to "tools/list", "params" set to {"pageSize": 7}
    Then names equals t at "name" for each t in the result of server.discover tools with no arguments at "tools" and t at "name" for each t in the result of server.discover tools with no arguments at "tools" equals sorted representation of t at "name" for each t in the result of server.discover tools with no arguments at "tools"
    And not the result of DEPRECATED TOOLS.intersection with names

  @candidate-python-transport-dependency-629d9ff3f8
  # Native: tests/test_transport_dependency.py::test_mapping_result_keeps_text_and_exposes_structured_content
  Scenario: Native check: mapping result keeps text and exposes structured content
    Given response is prepared as the result of asyncio.run with the result of OfficeServer().handle tools call async with 1; {"name": "office_help", "arguments": {}}
    And result is prepared as the result of asyncio.run with the result of OfficeServer().handle tools call async with 1; {"name": "office_help", "arguments": {}} at "result"
    When OfficeServer().handle tools call async using 1; {"name": "office_help", "arguments": {}}
    Then the result of asyncio.run with the result of OfficeServer().handle tools call async with 1; {"name": "office_help", "arguments": {}} at "result" at "structuredContent" equals the result of json.loads with the result of asyncio.run with the result of OfficeServer().handle tools call async with 1; {"name": "office_help", "arguments": {}} at "result" at "content" at 0 at "text"
    And the result of asyncio.run with the result of OfficeServer().handle tools call async with 1; {"name": "office_help", "arguments": {}} at "result" at "structuredContent" at "success" is true

  @candidate-python-transport-dependency-6e7d7c2e46
  # Native: tests/test_transport_dependency.py::test_supported_initialize_versions_are_negotiated
  Scenario: Native check: supported initialize versions are negotiated
    Given the native supported initialize versions are negotiated inputs and isolated test state
    When OfficeServer().process request async using the result of json.dumps with the fields "jsonrpc" set to "2.0", "id" set to 1, "method" set to "initialize", "params" set to the fields "protocolVersion" set to requested
    Then response at "result" at "protocolVersion" equals expected
