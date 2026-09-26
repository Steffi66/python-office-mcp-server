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
  Scenario: Native check: replacement preserves surrounding text [TestTrackChangesPositioning]
    Given Create an instance of WordAdvancedTools.
    And Create a document with multiple paragraphs for track changes testing.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_positioning.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of multi paragraph docx; replacements {"PLACEHOLDER": "REPLACED"}; author "Test"; output path str representation of temp dir under "test_positioning.docx"
    Then result field "success" is non-empty or true
    And the number of entries in the result of Document with temp dir under "test_positioning.docx" paragraphs is at least 4

  @candidate-python-track-changes-a26bfce76d
  # Native: tests/test_track_changes.py::TestTrackChangesPositioning::test_changes_appear_in_correct_paragraph
  Scenario: Native check: changes appear in correct paragraph [TestTrackChangesPositioning]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_correct_para.docx"
    And doc is prepared as the result of Document with no arguments
    And input path is prepared as temp dir under "test_correct_para.docx"
    And output is prepared as temp dir under "test_correct_para_out.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of temp dir under "test_correct_para.docx"; replacements {"MARKER": "CHANGED"}; author "Test"; output path str representation of temp dir under "test_correct_para_out.docx"
    Then result field "success" is non-empty or true
    And result field "total_changes" equals 2

  @candidate-python-track-changes-28bf7b827a
  # Native: tests/test_track_changes.py::TestTrackChangesPositioning::test_replacement_across_split_runs
  Scenario: Native check: replacement across split runs [TestTrackChangesPositioning]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "split_runs.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And input path is prepared as temp dir under "split_runs.docx"
    And output is prepared as temp dir under "split_runs_out.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of temp dir under "split_runs.docx"; replacements {"Microsoft Teams Contact Center, Dynamics 365": "Unified Platform"}; author "Test"; output path str representation of temp dir under "split_runs_out.docx"
    Then result field "success" is non-empty or true
    And result field "total_changes" equals 1

  @candidate-python-track-changes-88c3d25f1c
  # Native: tests/test_track_changes.py::TestTrackChangesInTables::test_changes_in_table_cells
  Scenario: Native check: changes in table cells [TestTrackChangesInTables]
    Given Create an instance of WordAdvancedTools.
    And Create a simple test document with placeholder text.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_table_changes.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of simple docx; replacements {"<Customer Name>": "Contoso"}; author "Test"; output path str representation of temp dir under "test_table_changes.docx"
    Then result field "success" is non-empty or true
    And result field "total_changes" is at least 2

  @candidate-python-track-changes-54c2ca5d3c
  # Native: tests/test_track_changes.py::TestAcceptAllChanges::test_accept_removes_del_elements
  Scenario: Native check: accept removes del elements [TestAcceptAllChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_accept_input.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And input path is prepared as temp dir under "test_accept_input.docx"
    And output path is prepared as temp dir under "test_accept_output.docx"
    When word advanced tools.tool word accept all changes using file path str representation of temp dir under "test_accept_input.docx"; output path str representation of temp dir under "test_accept_output.docx"
    Then result field "success" is true
    And result field "deletions_removed" equals 1
    And result field "insertions_accepted" equals 1
    And not the result of ET.fromstring with zf saved payload for "word/document.xml" matches for text .//{{WORD NS}}del
    And not the result of ET.fromstring with zf saved payload for "word/document.xml" matches for text .//{{WORD NS}}ins
    And "inserted text" occurs in the result of ''.join with the result of xml content.itertext with no arguments
    And "deleted text" does not occur in the result of ''.join with the result of xml content.itertext with no arguments

  @candidate-python-track-changes-19f5e586ed
  # Native: tests/test_track_changes.py::TestAcceptAllChanges::test_accept_preserves_inserted_text
  Scenario: Native check: accept preserves inserted text [TestAcceptAllChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_preserve_ins.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Before "
    And input path is prepared as temp dir under "test_preserve_ins.docx"
    And output path is prepared as temp dir under "test_preserve_ins_out.docx"
    When word advanced tools.tool word accept all changes using file path str representation of temp dir under "test_preserve_ins.docx"; output path str representation of temp dir under "test_preserve_ins_out.docx"
    Then result field "success" is true
    And p text for each p in the result of Document with temp dir under "test_preserve_ins_out.docx" paragraphs where p text equals ["Before INSERTED After"]

  @candidate-python-track-changes-d650cc1bac
  # Native: tests/test_track_changes.py::TestEnableTrackChanges::test_enable_sets_trackRevisions
  Scenario: Native check: enable sets trackRevisions [TestEnableTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And Create a simple test document with placeholder text.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_enabled.docx"
    When word advanced tools.tool word enable track changes using file path str representation of simple docx; output path str representation of temp dir under "test_enabled.docx"
    Then result field "success" is non-empty or true
    And "trackRevisions" occurs in the result of zf.read('word/settings.xml').decode with no arguments

  @candidate-python-track-changes-81b9044a8f
  # Native: tests/test_track_changes.py::TestPatchWithTrackChangesEnablesRevisions::test_patch_enables_trackRevisions_in_settings
  Scenario: Native check: patch enables trackRevisions in settings [TestPatchWithTrackChangesEnablesRevisions]
    Given Create an instance of WordAdvancedTools.
    And Create a simple test document with placeholder text.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_patch_enables.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of simple docx; replacements {"<Customer Name>": "Test Corp"}; author "Test Author"; output path str representation of temp dir under "test_patch_enables.docx"
    Then result field "success" is non-empty or true
    And "trackRevisions" occurs in the result of zf.read('word/settings.xml').decode with no arguments
    And "trackRevisions w:val=\"false\"" does not occur in the result of zf.read('word/settings.xml').decode with no arguments
    And "trackRevisions w:val=\"0\"" does not occur in the result of zf.read('word/settings.xml').decode with no arguments

  @candidate-python-track-changes-2c61301c0a
  # Native: tests/test_track_changes.py::TestWordCompatibility::test_document_opens_without_corruption
  Scenario: Native check: document opens without corruption [TestWordCompatibility]
    Given Create an instance of WordAdvancedTools.
    And Create a simple test document with placeholder text.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_word_compat.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of simple docx; replacements {"<Customer Name>": "Test Corp"}; author "Automated Test"; output path str representation of temp dir under "test_word_compat.docx"
    Then result field "success" is non-empty or true

  @candidate-python-track-changes-ed6f1a7b5a
  # Native: tests/test_track_changes.py::TestWordCompatibility::test_xml_is_well_formed
  Scenario: Native check: xml is well formed [TestWordCompatibility]
    Given Create an instance of WordAdvancedTools.
    And Create a simple test document with placeholder text.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "test_xml_wellformed.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of simple docx; replacements {"<Customer Name>": "Test"}; author "Test"; output path str representation of temp dir under "test_xml_wellformed.docx"
    Then the resulting document or diagnostic output is available for manual inspection
