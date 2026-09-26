@captured @python_candidate
Feature: track changes native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-track-changes-ef6e5bd3a7
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_insertion_has_required_attributes
  Scenario: Saved insertion exposes non-null metadata and the requested author
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_insertion adds "inserted text" to that paragraph with author "Test Author"
    And the document is saved to a temporary output and word/document.xml is parsed
    Then at least one descendant w:ins exists
    And the last insertion has non-null w:id, w:author and w:date attributes
    And its w:author equals "Test Author"

  @candidate-python-track-changes-12023074dc
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_insertion_contains_run_with_text
  Scenario: The first run of the last saved insertion contains the expected text
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_insertion adds "test insertion" with author "Test"
    And the document is saved to a temporary output and word/document.xml is parsed
    Then at least one descendant w:ins exists
    And the last insertion has at least one direct w:r child
    And its first run has at least one direct w:t child whose first text equals "test insertion"

  @candidate-python-track-changes-095d85b1f1
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_deletion_has_required_attributes
  Scenario: Saved deletion exposes non-null metadata attributes
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_deletion adds "deleted text" with author "Test Author"
    And the document is saved to a temporary output and word/document.xml is parsed
    Then at least one descendant w:del exists
    And the last deletion has non-null w:id, w:author and w:date attributes

  @candidate-python-track-changes-9f6d5aa0cf
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_deletion_uses_delText_not_text
  Scenario: The first run of the last saved deletion uses delText and has no direct t child
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_deletion adds "deleted content" with author "Test"
    And the document is saved to a temporary output and word/document.xml is parsed
    Then at least one descendant w:del exists
    And the last deletion has at least one direct w:r child
    And that first run has at least one direct w:delText child whose first text equals "deleted content"
    And that first run has zero direct w:t children

  @candidate-python-track-changes-c8394a6706
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_date_format_is_iso8601
  Scenario: The last insertion date matches a numeric date-time prefix
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_insertion adds "text" with author "Test"
    And the document is saved to a temporary output and word/document.xml is parsed
    And the last descendant w:ins date is read
    Then re.match with pattern "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}" succeeds on that date

  @candidate-python-track-changes-68da4f2809
  # Native: tests/test_track_changes.py::TestTrackChangesXMLStructure::test_unique_ids_across_document
  Scenario: Collected insertion and deletion IDs contain no duplicate values
    Given simple_docx contains paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    And Document loads that fixture and appends an empty paragraph
    When _add_tracked_insertion adds "first" and then "second", both with author "Test"
    And _add_tracked_deletion adds "third" with author "Test"
    And _add_tracked_insertion adds "fourth" with author "Test"
    And the document is saved to a temporary output and word/document.xml is parsed
    And w:id values are collected from every descendant w:ins and then every descendant w:del
    Then the collected list length equals its set cardinality

  @candidate-python-track-changes-c3917b3be8
  # Native: tests/test_track_changes.py::TestTrackChangesPositioning::test_replacement_preserves_surrounding_text
  Scenario: A tracked replacement output reopens with at least four paragraphs
    Given an isolated writable directory and a WordAdvancedTools instance
    And multi_paragraph_docx has heading "Test Document" and paragraphs "First paragraph with PLACEHOLDER text.", "Second paragraph with PLACEHOLDER and more PLACEHOLDER content.", "Third paragraph without any placeholders." and "Fourth paragraph with single PLACEHOLDER."
    When tool_word_patch_with_track_changes replaces PLACEHOLDER with REPLACED using author "Test" and a distinct output_path
    Then result.success is truthy
    When python-docx opens the output
    Then its paragraph count is at least 4

  @candidate-python-track-changes-a26bfce76d
  # Native: tests/test_track_changes.py::TestTrackChangesPositioning::test_changes_appear_in_correct_paragraph
  Scenario: Two separated marker occurrences produce a reported count of two
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved document has paragraphs "Paragraph ONE has MARKER here.", "Paragraph TWO is clean." and "Paragraph THREE has MARKER too."
    When tool_word_patch_with_track_changes replaces MARKER with CHANGED using author "Test" and a distinct output_path
    Then result.success is truthy and result.total_changes equals 2

  @candidate-python-track-changes-28bf7b827a
  # Native: tests/test_track_changes.py::TestTrackChangesPositioning::test_replacement_across_split_runs
  Scenario: A split-run target produces one reported change
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved paragraph has runs "Microsoft Teams Contact Center" and ", Dynamics 365" in sequence
    When tool_word_patch_with_track_changes replaces "Microsoft Teams Contact Center, Dynamics 365" with "Unified Platform" using author "Test" and a distinct output_path
    Then result.success is truthy and result.total_changes equals 1

  @candidate-python-track-changes-88c3d25f1c
  # Native: tests/test_track_changes.py::TestTrackChangesInTables::test_changes_in_table_cells
  Scenario: A fixture with body and table placeholders produces at least two reported changes
    Given an isolated writable directory and a WordAdvancedTools instance
    And simple_docx is saved with paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    When tool_word_patch_with_track_changes replaces <Customer Name> with Contoso using author "Test" and a distinct output_path
    Then result.success is truthy and result.total_changes is at least 2

  @candidate-python-track-changes-54c2ca5d3c
  # Native: tests/test_track_changes.py::TestAcceptAllChanges::test_accept_removes_del_elements
  Scenario: Accept-all removes insertion and deletion wrappers from saved document XML
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved document has one initially empty paragraph containing helper-added tracked deletion "deleted text" followed by tracked insertion "inserted text", both by "Test"
    When tool_word_accept_all_changes writes to a distinct output_path
    Then result.success is true, deletions_removed equals 1 and insertions_accepted equals 1
    When output word/document.xml is parsed
    Then it has no descendant w:del or w:ins elements
    And its concatenated itertext contains "inserted text" and does not contain "deleted text"

  @candidate-python-track-changes-19f5e586ed
  # Native: tests/test_track_changes.py::TestAcceptAllChanges::test_accept_preserves_inserted_text
  Scenario: Accept-all retains the exact nonempty paragraph text around an insertion
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved paragraph has ordinary text "Before ", helper-added tracked insertion "INSERTED" by "Test", then ordinary run " After"
    When tool_word_accept_all_changes writes to a distinct output_path
    Then result.success is true
    When python-docx reopens the output and empty paragraph texts are filtered out
    Then the remaining text list equals ["Before INSERTED After"]

  @candidate-python-track-changes-d650cc1bac
  # Native: tests/test_track_changes.py::TestEnableTrackChanges::test_enable_sets_trackRevisions
  Scenario: Enabling tracking places a literal token in saved settings
    Given an isolated writable directory and a WordAdvancedTools instance
    And simple_docx is saved with paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    When tool_word_enable_track_changes writes to a distinct output_path
    Then result.success is truthy
    When word/settings.xml is read from the output ZIP and decoded
    Then the text contains "trackRevisions"

  @candidate-python-track-changes-81b9044a8f
  # Native: tests/test_track_changes.py::TestPatchWithTrackChangesEnablesRevisions::test_patch_enables_trackRevisions_in_settings
  Scenario: Tracked patch settings contain the token and omit two literal disabled spellings
    Given an isolated writable directory and a WordAdvancedTools instance
    And simple_docx is saved with paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    When tool_word_patch_with_track_changes replaces <Customer Name> with "Test Corp" using author "Test Author" and a distinct output_path
    Then result.success is truthy
    When word/settings.xml is read from the output ZIP and decoded
    Then the text contains "trackRevisions"
    And it contains neither the literal trackRevisions w:val="false" nor the literal trackRevisions w:val="0"

  @candidate-python-track-changes-2c61301c0a
  # Native: tests/test_track_changes.py::TestWordCompatibility::test_document_opens_without_corruption
  Scenario: A tracked patch output opens and exposes paragraph text through python-docx
    Given an isolated writable directory and a WordAdvancedTools instance
    And simple_docx is saved with paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    When tool_word_patch_with_track_changes replaces <Customer Name> with "Test Corp" using author "Automated Test" and a distinct output_path
    Then result.success is truthy
    When python-docx opens the output and reads every paragraph text
    Then those operations finish without an exception

  @candidate-python-track-changes-ed6f1a7b5a
  # Native: tests/test_track_changes.py::TestWordCompatibility::test_xml_is_well_formed
  Scenario: Each saved ZIP member whose name ends in .xml parses with ElementTree
    Given an isolated writable directory and a WordAdvancedTools instance
    And simple_docx is saved with paragraphs "Hello <Customer Name>, welcome to <Project Name>." and "This is a test document for <Customer Name>."
    And its 2-by-2 table has rows ["Header 1", "Header 2"] and ["<Customer Name>", "Value"]
    When tool_word_patch_with_track_changes replaces <Customer Name> with "Test" using author "Test" and a distinct output_path
    And the output ZIP is opened and every member ending in .xml is read
    Then ElementTree.fromstring parses every such member without ParseError
