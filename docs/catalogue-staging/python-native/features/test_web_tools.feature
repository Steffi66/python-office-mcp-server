@captured @python_candidate
Feature: web tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-web-tools-d893b82a90
  # Native: tests/test_web_tools.py::TestWebFetch::test_fetch_invalid_urls
  Scenario: Native check: fetch invalid urls [TestWebFetch]
    Given Create an instance of WebTools.
    And a prepared invalid url input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [not-a-url] | {"invalid_url": "'not-a-url'"} |
      | [ftp://example.com] | {"invalid_url": "'ftp://example.com'"} |
      | [://missing-scheme] | {"invalid_url": "'://missing-scheme'"} |
    When web tools.tool web fetch using invalid url
    Then "error" occurs in result

  @candidate-python-web-tools-2fbf49b747
  # Native: tests/test_web_tools.py::TestWebFetch::test_fetch_valid_url
  Scenario: Native check: fetch valid url [TestWebFetch]
    Given Create an instance of WebTools.
    When web tools.tool web fetch using "https://example.com"
    Then result field "success" is true
    And "title" occurs in result
    And "content" occurs in result
    And result at "word_count" exceeds 0

  @candidate-python-web-tools-724c1af91f
  # Native: tests/test_web_tools.py::TestWebSearch::test_search_empty_query
  Scenario: Native check: search empty query [TestWebSearch]
    Given Create an instance of WebTools.
    When web tools.tool web search using ""
    Then "error" occurs in result

  @candidate-python-web-tools-303db5f285
  # Native: tests/test_web_tools.py::TestWebSearch::test_search_valid_query
  Scenario: Native check: search valid query [TestWebSearch]
    Given Create an instance of WebTools.
    When web tools.tool web search using "python programming"; max results 2
    Then result field "success" is true
    And "results" occurs in result
    And when result at "result_count" exceeds 0, "title" occurs in result at "results" at 0
    And when result at "result_count" exceeds 0, "url" occurs in result at "results" at 0

  @candidate-python-web-tools-3bc8674f1c
  # Native: tests/test_web_tools.py::TestWebExtractLinks::test_extract_links_invalid_url
  Scenario: Native check: extract links invalid url [TestWebExtractLinks]
    Given Create an instance of WebTools.
    When web tools.tool web extract links using "not-a-url"
    Then "error" occurs in result

  @candidate-python-web-tools-9364e050d2
  # Native: tests/test_web_tools.py::TestWebExtractLinks::test_extract_links_valid_url
  Scenario: Native check: extract links valid url [TestWebExtractLinks]
    Given Create an instance of WebTools.
    When web tools.tool web extract links using "https://example.com"
    Then result field "success" is true
    And "links" occurs in result
    And "link_count" occurs in result

  @candidate-python-web-tools-5df4fece94
  # Native: tests/test_web_tools.py::TestWebExtractTables::test_extract_tables_invalid_url
  Scenario: Native check: extract tables invalid url [TestWebExtractTables]
    Given Create an instance of WebTools.
    When web tools.tool web extract tables using "not-a-url"
    Then "error" occurs in result

  @candidate-python-web-tools-bc1dba0020
  # Native: tests/test_web_tools.py::TestWebExtractTables::test_extract_tables_valid_url
  Scenario: Native check: extract tables valid url [TestWebExtractTables]
    Given Create an instance of WebTools.
    When web tools.tool web extract tables using "https://example.com"
    Then result field "success" is true
    And "tables" occurs in result
    And result at "table_count" equals 0

  @candidate-python-web-tools-e216a9d503
  # Native: tests/test_web_tools.py::TestWebCheckUrl::test_check_invalid_urls
  Scenario: Native check: check invalid urls [TestWebCheckUrl]
    Given Create an instance of WebTools.
    And a prepared invalid url input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [not-a-url] | {"invalid_url": "'not-a-url'"} |
      | [ftp://example.com] | {"invalid_url": "'ftp://example.com'"} |
      | [://missing-scheme] | {"invalid_url": "'://missing-scheme'"} |
    When web tools.tool web check url using invalid url
    Then result at "exists" is false
    And "error" occurs in result

  @candidate-python-web-tools-d9cb43d837
  # Native: tests/test_web_tools.py::TestWebCheckUrl::test_check_valid_url
  Scenario: Native check: check valid url [TestWebCheckUrl]
    Given Create an instance of WebTools.
    When web tools.tool web check url using "https://example.com"
    Then result at "exists" is true
    And result at "status_code" equals 200
    And "content_type" occurs in result

  @candidate-python-web-tools-c5ac73a54a
  # Native: tests/test_web_tools.py::TestWebCheckUrl::test_check_nonexistent_url
  Scenario: Native check: check nonexistent url [TestWebCheckUrl]
    Given Create an instance of WebTools.
    When web tools.tool web check url using "https://example.com/this-page-does-not-exist-12345"
    Then result at "exists" is false
    And result at "status_code" equals 404

  @candidate-python-web-tools-8cf5d991c6
  # Native: tests/test_web_tools.py::TestWebCheckUrl::test_check_url_with_redirect
  Scenario: Native check: check url with redirect [TestWebCheckUrl]
    Given Create an instance of WebTools.
    When web tools.tool web check url using "http://example.com"; follow redirects true
    Then result at "exists" is true
    And when result field "redirected", result at "final_url" differs from result at "url"
