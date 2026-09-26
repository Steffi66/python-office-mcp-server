@captured @python_candidate
Feature: comment tools e2e native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-comment-tools-e2e-87e7f9fd1d
  # Native: tests/test_comment_tools_e2e.py::test_excel_comments_unified_read_write_delete
  Scenario: Native check: excel comments unified read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create an Excel workbook prepared for comment operations.
    When tools.tool office comment using file path excel comment file; operation "add"; target "A1"; text "Validate this number with Finance"
    And tools.tool office comment using file path excel comment file; operation "get"
    And tools.tool office comment using file path excel comment file; operation "delete"; target "A1"
    Then add field "success" is true
    And "error" does not occur in got
    And got field "total_comments", defaulting to 0 equals 1
    And the number of entries in got field "by_sheet", defaulting to {} field "Data", defaulting to [] equals 1
    And got field "by_sheet", defaulting to {} field "Data", defaulting to [] at 0 field "cell" equals "A1"
    And "Finance" occurs in got field "by_sheet", defaulting to {} field "Data", defaulting to [] at 0 field "text", defaulting to ""
    And deleted field "success" is true
    And after field "total_comments", defaulting to 0 equals 0

  @candidate-python-comment-tools-e2e-f0bcc3a2a3
  # Native: tests/test_comment_tools_e2e.py::test_excel_comments_direct_read_write_delete
  Scenario: Native check: excel comments direct read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create an Excel workbook prepared for comment operations.
    When tools.tool excel add comment using file path excel comment file; cell ref "A1"; text "Direct Excel comment"
    And tools.tool excel get comments using file path excel comment file
    And tools.tool excel delete comment using file path excel comment file; cell ref "A1"
    Then add field "success" is true
    And got field "total_comments", defaulting to 0 equals 1
    And deleted field "success" is true
    And after field "total_comments", defaulting to 0 equals 0

  @candidate-python-comment-tools-e2e-20ece7957e
  # Native: tests/test_comment_tools_e2e.py::test_word_comments_unified_read_write_delete
  Scenario: Native check: word comments unified read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create a Word document prepared for comment operations.
    When tools.tool office comment using file path word comment file; operation "add"; target "comment target"; text "Please verify this claim"
    And tools.tool office comment using file path word comment file; operation "get"
    And tools.tool office comment using file path word comment file; operation "delete"; target str representation of got field "comments", defaulting to [] at 0 at "id"
    Then add field "success" is true
    And "error" does not occur in got
    And got field "comment_count", defaulting to 0 is at least 1
    And got field "comments", defaulting to [] is non-empty or true
    And "verify" occurs in got field "comments", defaulting to [] at 0 field "text", defaulting to "" in lowercase
    And deleted field "success" is true
    And after field "comment_count", defaulting to 0 equals 0

  @candidate-python-comment-tools-e2e-676e3b50ad
  # Native: tests/test_comment_tools_e2e.py::test_word_comments_direct_read_write_delete
  Scenario: Native check: word comments direct read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create a Word document prepared for comment operations.
    When tools.tool word add comment using file path word comment file; target text "comment target"; comment text "Direct Word comment"
    And tools.tool word get comments using file path word comment file
    And tools.tool word delete comment using file path word comment file; comment id str representation of got at "comments" at 0 at "id"
    Then add field "success" is true
    And got field "comment_count", defaulting to 0 is at least 1
    And deleted field "success" is true
    And after field "comment_count", defaulting to 0 equals 0

  @candidate-python-comment-tools-e2e-de1d579a0b
  # Native: tests/test_comment_tools_e2e.py::test_pptx_comments_unified_read_write_delete
  Scenario: Native check: pptx comments unified read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create a PowerPoint deck prepared for comment operations.
    When tools.tool office comment using file path pptx comment file; operation "add"; target "slide:1"; text "Please update this title"
    And tools.tool office comment using file path pptx comment file; operation "get"
    And tools.tool office comment using file path pptx comment file; operation "delete"; target text slide:1/comment:{got field "comments", defaulting to {} field 1, defaulting to [] at 0 at "index"}
    Then add field "success" is true
    And "error" does not occur in got
    And got field "total_comments", defaulting to 0 is at least 1
    And got field "comments", defaulting to {} field 1, defaulting to [] is non-empty or true
    And "update" occurs in got field "comments", defaulting to {} field 1, defaulting to [] at 0 field "text", defaulting to "" in lowercase
    And deleted field "success" is true
    And after field "total_comments", defaulting to 0 equals 0

  @candidate-python-comment-tools-e2e-846a41e278
  # Native: tests/test_comment_tools_e2e.py::test_pptx_comments_direct_read_write_delete
  Scenario: Native check: pptx comments direct read write delete
    Given Provide a full tool instance similar to the dynamic server composition.
    And Create a PowerPoint deck prepared for comment operations.
    When tools.tool pptx add comment using file path pptx comment file; slide number 1; comment text "Direct PPTX comment"
    And tools.tool pptx get comments using file path pptx comment file; slide number 1
    And tools.tool pptx delete comment using file path pptx comment file; slide number 1; comment index int representation of got at "comments" at 1 at 0 at "index"
    Then add field "success" is true
    And got field "total_comments", defaulting to 0 is at least 1
    And deleted field "success" is true
    And after field "total_comments", defaulting to 0 equals 0
