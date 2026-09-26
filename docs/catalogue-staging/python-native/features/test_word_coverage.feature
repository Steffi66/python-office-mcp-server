@captured @python_candidate
Feature: word coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-coverage-08173e1b44
  # Native: tests/test_word_coverage.py::TestPromptFunctions::test_prompt_word_get_section_guidance
  Scenario: Native check: prompt word get section guidance [TestPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "guidance.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "guidance.docx"
    When word advanced tools.tool word get section guidance using str representation of temp dir under "guidance.docx"; "Executive Summary"
    Then result has type dict

  @candidate-python-word-coverage-2367403030
  # Native: tests/test_word_coverage.py::TestTrackChangesOperations::test_enable_track_changes
  Scenario: Native check: enable track changes [TestTrackChangesOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "track.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track.docx"
    And output is prepared as temp dir under "tracked.docx"
    When word advanced tools.tool word enable track changes using str representation of temp dir under "track.docx"; output path str representation of temp dir under "tracked.docx"
    Then result has type dict

  @candidate-python-word-coverage-c4c1f50efd
  # Native: tests/test_word_coverage.py::TestTrackChangesOperations::test_patch_with_track_changes
  Scenario: Native check: patch with track changes [TestTrackChangesOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "track_patch.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track_patch.docx"
    And output is prepared as temp dir under "patched_tracked.docx"
    When word advanced tools.tool word patch with track changes using str representation of temp dir under "track_patch.docx"; replacements {"<Customer Name>": "Contoso Corp"}; output path str representation of temp dir under "patched_tracked.docx"
    Then result has type dict

  @candidate-python-word-coverage-6403208de7
  # Native: tests/test_word_coverage.py::TestCleanupSow::test_cleanup_sow
  Scenario: Native check: cleanup sow [TestCleanupSow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "cleanup_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "cleanup_sow.docx"
    And output is prepared as temp dir under "cleaned.docx"
    When word advanced tools.tool word cleanup sow using str representation of temp dir under "cleanup_sow.docx"; output path str representation of temp dir under "cleaned.docx"
    Then result has type dict

  @candidate-python-word-coverage-396217e4f7
  # Native: tests/test_word_coverage.py::TestParseSowTemplate::test_parse_sow_template
  Scenario: Native check: parse sow template [TestParseSowTemplate]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "template.docx"
    When word advanced tools.tool word parse sow template using str representation of temp dir under "template.docx"
    Then result has type dict

  @candidate-python-word-coverage-3cc72ff9ad
  # Native: tests/test_word_coverage.py::TestAnalyzeTemplateFormatting::test_analyze_template_formatting
  Scenario: Placeholder formatting analysis returns a dictionary without content assertions
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved document with level-0 heading "Template"
    And paragraphs "Boilerplate text here", "<Placeholder>" and "[TBD]"
    When tool_word_analyze_template_formatting reads that saved document
    Then the result is a dictionary, including an error dictionary

  @candidate-python-word-coverage-c040cdc236
  # Native: tests/test_word_coverage.py::TestPatchTableRow::test_patch_table_row
  Scenario: Native check: patch table row [TestPatchTableRow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "patch_table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 1; 0 text is set to "Value1"
    And the result of table.cell with 1; 1 text is set to "Value2"
    And path is prepared as temp dir under "patch_table.docx"
    And output is prepared as temp dir under "patched_table.docx"
    When word advanced tools.tool word patch table row using str representation of temp dir under "patch_table.docx"; "0"; 1; {"A": "NewValue1", "B": "NewValue2"}; output path str representation of temp dir under "patched_table.docx"
    Then result has type dict

  @candidate-python-word-coverage-57bbed7db5
  # Native: tests/test_word_coverage.py::TestReplaceGlobalVariables::test_replace_global_variables
  Scenario: Native check: replace global variables [TestReplaceGlobalVariables]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "globals.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "globals.docx"
    And output is prepared as temp dir under "replaced.docx"
    When word advanced tools.tool word replace global variables using str representation of temp dir under "globals.docx"; replacements {"<Customer Name>": "Contoso Corp", "<Project Name>": "Cloud Migration"}; output path str representation of temp dir under "replaced.docx"
    Then result has type dict

  @candidate-python-word-coverage-55d71b1fda
  # Native: tests/test_word_coverage.py::TestSowGeneration::test_generate_sow_minimal
  Scenario: Native check: generate sow minimal [TestSowGeneration]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template doc.save with temp dir under "template.docx"
    And template doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "template.docx"
    And output path is prepared as temp dir under "generated_sow.docx"
    And sow data is prepared as {"customer_name": "Test Corp", "project_name": "Test Project", "executive_summary": "This is a test project."}
    When word advanced tools.tool word generate sow using str representation of temp dir under "template.docx"; str representation of temp dir under "generated_sow.docx"; {"customer_name": "Test Corp", "project_name": "Test Project", "executive_summary": "This is a test project."}
    Then result has type dict

  @candidate-python-word-coverage-4270c4d4fd
  # Native: tests/test_word_coverage.py::TestCopyTemplate::test_copy_template_creates_copy
  Scenario: Native check: copy template creates copy [TestCopyTemplate]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "source_template.docx"
    And doc is prepared as the result of Document with no arguments
    And source is prepared as temp dir under "source_template.docx"
    And dest is prepared as temp dir under "dest_template.docx"
    When word advanced tools.tool word copy template using str representation of temp dir under "source_template.docx"; str representation of temp dir under "dest_template.docx"
    Then temp dir under "dest_template.docx" exists or result field "success" is true

  @candidate-python-word-coverage-532bfe384b
  # Native: tests/test_word_coverage.py::TestAddComment::test_add_comment
  Scenario: Native check: add comment [TestAddComment]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "comment_doc.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "comment_doc.docx"
    And output is prepared as temp dir under "with_comment.docx"
    When word advanced tools.tool word add comment using str representation of temp dir under "comment_doc.docx"; target text "target text"; comment text "This is a review comment"; output path str representation of temp dir under "with_comment.docx"
    Then result has type dict

  @candidate-python-word-coverage-41b17db361
  # Native: tests/test_word_coverage.py::TestMoreTableOperations::test_list_tables_empty_doc
  Scenario: Native check: list tables empty doc [TestMoreTableOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_tables.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_tables.docx"
    When word advanced tools.tool word list tables using str representation of temp dir under "no_tables.docx"
    Then the number of entries in result field "tables", defaulting to [] equals 0

  @candidate-python-word-coverage-49fcdf62eb
  # Native: tests/test_word_coverage.py::TestMoreTableOperations::test_create_new_table_with_rows
  Scenario: Native check: create new table with rows [TestMoreTableOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "create_table.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "create_table.docx"
    And output is prepared as temp dir under "with_new_table.docx"
    When word advanced tools.tool word create new table using str representation of temp dir under "create_table.docx"; ["Column A", "Column B", "Column C"]; rows [{"Column A": "1", "Column B": "2", "Column C": "3"}, {"Column A": "4", "Column B": "5", "Column C": "6"}]; output path str representation of temp dir under "with_new_table.docx"
    Then result field "success" is true

  @candidate-python-word-coverage-374ee8dcd5
  # Native: tests/test_word_coverage.py::TestErrorPaths::test_get_section_nonexistent
  Scenario: Native check: get section nonexistent [TestErrorPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "sections.docx"; "Nonexistent"
    Then "error" occurs in result or result field "content" is null or result field "content" equals ""

  @candidate-python-word-coverage-e90b0415b3
  # Native: tests/test_word_coverage.py::TestErrorPaths::test_file_not_found
  Scenario: Native check: file not found [TestErrorPaths]
    Given Create an instance of WordAdvancedTools.
    When word advanced tools.tool word list sections using "/nonexistent/path.docx"
    Then "error" occurs in result

  @candidate-python-word-coverage-f91c648fb1
  # Native: tests/test_word_coverage.py::TestErrorPaths::test_get_table_invalid_index
  Scenario: Native check: get table invalid index [TestErrorPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "one_table.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "one_table.docx"
    When word advanced tools.tool word get table using str representation of temp dir under "one_table.docx"; "999"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase
