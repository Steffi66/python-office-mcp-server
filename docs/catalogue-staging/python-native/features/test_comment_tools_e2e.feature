@captured @python_candidate
Feature: Python direct and unified comment operation observations across formats

  Six native definitions exercise generated Office files when their dependencies are available.
  Candidate descriptions need central reconciliation and grant no execution credit.
  Post-delete counts default to zero if missing; no final error or empty-collection assertion is made.

  Background:
    Given a combined tools object composed from TOOL_CLASSES
    And an isolated writable temporary directory

  @candidate-python-comment-tools-e2e-87e7f9fd1d
  # Native: tests/test_comment_tools_e2e.py::test_excel_comments_unified_read_write_delete
  Scenario: Unified Excel comments expose the target and text before deleting A1
    Given openpyxl is importable or the native check is skipped
    And a saved workbook with sheet "Data", A1 "Revenue" and B1 equal to 1000
    When tool_office_comment adds "Validate this number with Finance" to target "A1"
    Then the add result has success true
    When tool_office_comment gets comments
    Then the response has no error and total_comments equals 1
    And by_sheet for "Data" contains exactly one entry with cell "A1" and text containing "Finance"
    When tool_office_comment deletes target "A1"
    Then the delete result has success true
    When tool_office_comment gets comments again
    Then total_comments, defaulting to 0 if missing, equals 0

  @candidate-python-comment-tools-e2e-f0bcc3a2a3
  # Native: tests/test_comment_tools_e2e.py::test_excel_comments_direct_read_write_delete
  Scenario: Direct Excel tools report one comment before deletion and a zero-or-missing count afterwards
    Given openpyxl is importable or the native check is skipped
    And a saved workbook with sheet "Data", A1 "Revenue" and B1 equal to 1000
    When tool_excel_add_comment adds "Direct Excel comment" to cell_ref "A1"
    Then the add result has success true
    When tool_excel_get_comments reads the workbook
    Then total_comments equals 1
    When tool_excel_delete_comment deletes cell_ref "A1"
    Then the delete result has success true
    When tool_excel_get_comments reads the workbook again
    Then total_comments, defaulting to 0 if missing, equals 0

  @candidate-python-comment-tools-e2e-20ece7957e
  # Native: tests/test_comment_tools_e2e.py::test_word_comments_unified_read_write_delete
  Scenario: Unified Word comments expose text and delete the first returned ID
    Given python-docx and lxml are importable or the native check is skipped
    And a saved document with "This sentence is the comment target." and "Another paragraph for context."
    When tool_office_comment adds "Please verify this claim" to target "comment target"
    Then the add result has success true
    When tool_office_comment gets comments
    Then the response has no error and comment_count is at least 1
    And comments is nonempty and its first entry's text lowercases to a string containing "verify"
    And the first entry's ID is captured
    When tool_office_comment deletes that ID as a string target
    Then the delete result has success true
    When tool_office_comment gets comments again
    Then comment_count, defaulting to 0 if missing, equals 0

  @candidate-python-comment-tools-e2e-676e3b50ad
  # Native: tests/test_comment_tools_e2e.py::test_word_comments_direct_read_write_delete
  Scenario: Direct Word tools delete the first returned ID after a positive count
    Given python-docx and lxml are importable or the native check is skipped
    And a saved document with "This sentence is the comment target." and "Another paragraph for context."
    When tool_word_add_comment adds "Direct Word comment" to target_text "comment target"
    Then the add result has success true
    When tool_word_get_comments reads the document
    Then comment_count is at least 1 and the first returned comment ID is captured
    When tool_word_delete_comment deletes that ID as a string comment_id
    Then the delete result has success true
    When tool_word_get_comments reads the document again
    Then comment_count, defaulting to 0 if missing, equals 0

  @candidate-python-comment-tools-e2e-de1d579a0b
  # Native: tests/test_comment_tools_e2e.py::test_pptx_comments_unified_read_write_delete
  Scenario: Unified PowerPoint comments expose slide-1 text and delete its returned index
    Given python-pptx is importable or the native check is skipped
    And a saved deck with one title-layout slide whose title is set to "Comment Test Slide" if a title shape exists
    When tool_office_comment adds "Please update this title" to target "slide:1"
    Then the add result has success true
    When tool_office_comment gets comments
    Then the response has no error and total_comments is at least 1
    And comments at integer slide key 1 is nonempty and its first entry's text lowercases to a string containing "update"
    And that entry's index is captured
    When tool_office_comment deletes target "slide:1/comment:" followed by the captured index
    Then the delete result has success true
    When tool_office_comment gets comments again
    Then total_comments, defaulting to 0 if missing, equals 0

  @candidate-python-comment-tools-e2e-846a41e278
  # Native: tests/test_comment_tools_e2e.py::test_pptx_comments_direct_read_write_delete
  Scenario: Direct PowerPoint tools delete the first slide-1 comment index after a positive count
    Given python-pptx is importable or the native check is skipped
    And a saved deck with one title-layout slide whose title is set to "Comment Test Slide" if a title shape exists
    When tool_pptx_add_comment adds "Direct PPTX comment" to slide_number 1
    Then the add result has success true
    When tool_pptx_get_comments reads slide_number 1
    Then total_comments is at least 1 and the first comment's index at integer slide key 1 is captured
    When tool_pptx_delete_comment deletes slide_number 1 with comment_index converted from the captured index to an integer
    Then the delete result has success true
    When tool_pptx_get_comments reads slide_number 1 again
    Then total_comments, defaulting to 0 if missing, equals 0
