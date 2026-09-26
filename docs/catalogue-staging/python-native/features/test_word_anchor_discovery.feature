@captured @python_candidate
Feature: word anchor discovery native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-anchor-discovery-932c8bfff6
  # Native: tests/test_word_anchor_discovery.py::TestWordAnchorDiscovery::test_headings_and_paragraphs_surface_as_anchors
  Scenario: Native check: headings and paragraphs surface as anchors [TestWordAnchorDiscovery]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "anchors.docx"
    And path is prepared as temp dir under "anchors.docx"
    And doc is prepared as the result of Document with no arguments
    When WordAdvancedTools().tool word list anchors using str representation of temp dir under "anchors.docx"
    Then result at "count" is at least 4
    And at least one item satisfies item at "type" equals "section_heading" and item at "anchor_text" equals "Introduction" for each item in result at "anchors"
    And at least one item satisfies item at "type" equals "paragraph" and "Customer context" occurs in item at "anchor_text" for each item in result at "anchors"

  @candidate-python-word-anchor-discovery-4e2d730967
  # Native: tests/test_word_anchor_discovery.py::TestWordAnchorDiscovery::test_anchor_text_filtering_works
  Scenario: Native check: anchor text filtering works [TestWordAnchorDiscovery]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "anchors.docx"
    And path is prepared as temp dir under "anchors.docx"
    And doc is prepared as the result of Document with no arguments
    When WordAdvancedTools().tool word list anchors using str representation of temp dir under "anchors.docx"; query "delivery"
    Then result at "count" is at least 1
    And every item satisfies "delivery" occurs in item at "anchor_text" in lowercase for each item in result at "anchors"

  @candidate-python-word-anchor-discovery-fd46fd482b
  # Native: tests/test_word_anchor_discovery.py::TestWordAnchorDiscovery::test_document_map_includes_sections_tables_placeholders_and_anchors
  Scenario: Native check: document map includes sections tables placeholders and anchors [TestWordAnchorDiscovery]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "map.docx"
    And path is prepared as temp dir under "map.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of doc.add table with rows 2; cols 2 rows at 0 cells at 0 text is set to "Role"
    And the result of doc.add table with rows 2; cols 2 rows at 0 cells at 1 text is set to "Count"
    And the result of doc.add table with rows 2; cols 2 rows at 1 cells at 0 text is set to "Architect"
    And the result of doc.add table with rows 2; cols 2 rows at 1 cells at 1 text is set to "1"
    When WordAdvancedTools().tool word document map using str representation of temp dir under "map.docx"
    Then result at "counts" at "sections" equals 1
    And result at "counts" at "tables" equals 1
    And result at "counts" at "placeholders" is at least 1
    And result at "counts" at "anchors" is at least 2
    And result at "anchors" is non-empty or true

  @candidate-python-word-anchor-discovery-c6740fa993
  # Native: tests/test_word_anchor_discovery.py::TestWordAnchorDiscovery::test_discover_anchor_then_insert
  Scenario: Native check: discover anchor then insert [TestWordAnchorDiscovery]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "insert.docx"
    And path is prepared as temp dir under "insert.docx"
    And doc is prepared as the result of Document with no arguments
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word list anchors using str representation of temp dir under "insert.docx"; query "delivery"
    And tools.tool word insert at anchor using file path str representation of temp dir under "insert.docx"; anchor text the result of next with item for each item in anchors at "anchors" where item at "anchor_text" equals "Delivery approach" at "anchor_text"; content "Inserted after discovered anchor"; position "after"
    Then result at "success" is true
    And the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "insert.docx" paragraphs at the result of texts.index with "Delivery approach" joined with 1 equals "Inserted after discovered anchor"

  @candidate-python-word-anchor-discovery-de120f6192
  # Native: tests/test_word_anchor_discovery.py::TestWordAnchorDiscovery::test_section_listing_points_to_anchor_discovery
  Scenario: Native check: section listing points to anchor discovery [TestWordAnchorDiscovery]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And path is prepared as temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    When WordAdvancedTools().tool word list sections using str representation of temp dir under "sections.docx"
    Then "word_list_anchors" occurs in result at "next_tools"
    And "word_document_map" occurs in result at "next_tools"
