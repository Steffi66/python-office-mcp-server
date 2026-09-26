@captured @python_candidate
Feature: track change reading native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-track-change-reading-af092cf5e8
  # Native: tests/test_track_change_reading.py::TestGetTextWithTrackChanges::test_reads_regular_text
  Scenario: Native check: reads regular text [TestGetTextWithTrackChanges]
    Given doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Regular text without changes."
    And text is prepared as the result of get text with track changes with the result of doc.add paragraph with "Regular text without changes."
    When doc.add paragraph using "Regular text without changes."
    And get text with track changes using the result of doc.add paragraph with "Regular text without changes."
    Then the result of get text with track changes with the result of doc.add paragraph with "Regular text without changes." equals "Regular text without changes."

  @candidate-python-track-change-reading-7791aa8d3a
  # Native: tests/test_track_change_reading.py::TestGetTextWithTrackChanges::test_reads_inserted_text
  Scenario: Native check: reads inserted text [TestGetTextWithTrackChanges]
    Given doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Before "
    And text is prepared as the result of get text with track changes with the result of doc.add paragraph with "Before "
    When doc.add paragraph using "Before "
    And add tracked insertion using the result of doc.add paragraph with "Before "; "INSERTED"
    And para.add run using " after"
    And get text with track changes using the result of doc.add paragraph with "Before "
    Then "INSERTED" occurs in the result of get text with track changes with the result of doc.add paragraph with "Before "
    And "Before" occurs in the result of get text with track changes with the result of doc.add paragraph with "Before "
    And "after" occurs in the result of get text with track changes with the result of doc.add paragraph with "Before "

  @candidate-python-track-change-reading-c6d4a9a469
  # Native: tests/test_track_change_reading.py::TestGetTextWithTrackChanges::test_excludes_deleted_text
  Scenario: Native check: excludes deleted text [TestGetTextWithTrackChanges]
    Given doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Visible "
    And text is prepared as the result of get text with track changes with the result of doc.add paragraph with "Visible "
    When doc.add paragraph using "Visible "
    And add tracked deletion using the result of doc.add paragraph with "Visible "; "DELETED"
    And para.add run using " text"
    And get text with track changes using the result of doc.add paragraph with "Visible "
    Then "DELETED" does not occur in the result of get text with track changes with the result of doc.add paragraph with "Visible "
    And "Visible" occurs in the result of get text with track changes with the result of doc.add paragraph with "Visible "
    And "text" occurs in the result of get text with track changes with the result of doc.add paragraph with "Visible "

  @candidate-python-track-change-reading-03d2af3c75
  # Native: tests/test_track_change_reading.py::TestGetTextWithTrackChanges::test_reads_replacement_correctly
  Scenario: Native check: reads replacement correctly [TestGetTextWithTrackChanges]
    Given doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Customer: "
    And text is prepared as the result of get text with track changes with the result of doc.add paragraph with "Customer: "
    When doc.add paragraph using "Customer: "
    And add tracked deletion using the result of doc.add paragraph with "Customer: "; "<Customer Name>"
    And add tracked insertion using the result of doc.add paragraph with "Customer: "; "Contoso Ltd"
    And get text with track changes using the result of doc.add paragraph with "Customer: "
    Then "Contoso Ltd" occurs in the result of get text with track changes with the result of doc.add paragraph with "Customer: "
    And "<Customer Name>" does not occur in the result of get text with track changes with the result of doc.add paragraph with "Customer: "

  @candidate-python-track-change-reading-541579b5b3
  # Native: tests/test_track_change_reading.py::TestGetSectionWithTrackChanges::test_get_section_reads_inserted_content
  Scenario: Native check: get section reads inserted content [TestGetSectionWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_section_track.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "test_section_track.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "test_section_track.docx"; "Introduction"
    Then "error" does not occur in result
    And "new introduction content" occurs in the result of ' '.join with result field "content", defaulting to []

  @candidate-python-track-change-reading-c496cb2753
  # Native: tests/test_track_change_reading.py::TestGetSectionWithTrackChanges::test_get_section_excludes_deleted_content
  Scenario: Native check: get section excludes deleted content [TestGetSectionWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_section_del.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Current summary. "
    And path is prepared as temp dir under "test_section_del.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "test_section_del.docx"; "Summary"
    Then "OLD DELETED TEXT" does not occur in the result of ' '.join with result field "content", defaulting to []
    And "Current summary" occurs in the result of ' '.join with result field "content", defaulting to []

  @candidate-python-track-change-reading-496189cd94
  # Native: tests/test_track_change_reading.py::TestListSectionsWithTrackChanges::test_list_sections_reads_inserted_heading
  Scenario: Native check: list sections reads inserted heading [TestListSectionsWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_list_sections.docx"
    And doc is prepared as the result of Document with no arguments
    And heading is prepared as the result of doc.add heading with ""; level 1
    And path is prepared as temp dir under "test_list_sections.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "test_list_sections.docx"
    Then "New Section Title" occurs in s at "title" for each s in result field "sections", defaulting to []

  @candidate-python-track-change-reading-f013e7c709
  # Native: tests/test_track_change_reading.py::TestPatchSectionWithTrackChanges::test_patch_section_finds_inserted_heading
  Scenario: Native check: patch section finds inserted heading [TestPatchSectionWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_patch_find.docx"
    And doc is prepared as the result of Document with no arguments
    And heading is prepared as the result of doc.add heading with ""; level 1
    And path is prepared as temp dir under "test_patch_find.docx"
    When word advanced tools.tool word patch section using file path str representation of temp dir under "test_patch_find.docx"; section title "Target Section"; new content ["New paragraph content."]
    Then result field "success" is non-empty or true

  @candidate-python-track-change-reading-51d502c3b7
  # Native: tests/test_track_change_reading.py::TestAuditSowWithTrackChanges::test_audit_sow_finds_placeholder_in_insertion
  Scenario: Native check: audit sow finds placeholder in insertion [TestAuditSowWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_audit_ins.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Customer: "
    And path is prepared as temp dir under "test_audit_ins.docx"
    When word advanced tools.tool word audit sow using str representation of temp dir under "test_audit_ins.docx"
    Then result field "summary", defaulting to {} field "total_placeholders", defaulting to 0 is at least 1 or the number of entries in result field "placeholders_split_runs", defaulting to [] is at least 1

  @candidate-python-track-change-reading-da292fd43b
  # Native: tests/test_track_change_reading.py::TestCleanupSowWithTrackChanges::test_cleanup_reads_inserted_instruction_text
  Scenario: Native check: cleanup reads inserted instruction text [TestCleanupSowWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_cleanup_ins.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "test_cleanup_ins.docx"
    When word advanced tools.tool word cleanup sow using str representation of temp dir under "test_cleanup_ins.docx"
    Then result field "success" is non-empty or true

  @candidate-python-track-change-reading-7e3a6a0701
  # Native: tests/test_track_change_reading.py::TestNextToolsSuggestions::test_copy_template_suggests_generate_sow
  Scenario: Native check: copy template suggests generate sow [TestNextToolsSuggestions]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "template.docx"
    When word advanced tools.tool word copy template using template name "template.docx"; output path str representation of temp dir under "output.docx"; template dir str representation of temp dir
    Then result field "success" is non-empty or true
    And "word_parse_sow_template" occurs in result field "next_tools", defaulting to []

  @candidate-python-track-change-reading-94de0ee648
  # Native: tests/test_track_change_reading.py::TestNextToolsSuggestions::test_generate_sow_suggests_patch_section
  Scenario: Native check: generate sow suggests patch section [TestNextToolsSuggestions]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "template.docx"
    When word advanced tools.tool word generate sow using template path str representation of temp dir under "template.docx"; output path str representation of temp dir under "output.docx"; sow data {"customer_name": "Test Corp"}
    Then result field "success" is non-empty or true
    And "word_get_section_guidance" occurs in result field "next_tools", defaulting to []

  @candidate-python-track-change-reading-cc5c475d1f
  # Native: tests/test_track_change_reading.py::TestNextToolsSuggestions::test_audit_completion_suggests_based_on_issues
  Scenario: Native check: audit completion suggests based on issues [TestNextToolsSuggestions]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "test_audit.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "test_audit.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "test_audit.docx"
    Then "next_tools" occurs in result
    And the number of entries in result field "next_tools", defaulting to [] exceeds 0
