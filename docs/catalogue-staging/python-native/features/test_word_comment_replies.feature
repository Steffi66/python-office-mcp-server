@captured @python_candidate
Feature: word comment replies native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-comment-replies-634c069b81
  # Native: tests/test_word_comment_replies.py::test_reply_to_existing_comment
  Scenario: Native check: reply to existing comment
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "Reply in thread"; author "Rui Carmo"
    Then res field "success" is true
    And res field "parent_comment_id" equals word doc with comment at "parent_id"
    And res field "reply_comment_id" is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{res field "reply_comment_id"}'] is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{res field "reply_comment_id"}'] first match for text {{W NS}}p is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraId is non-empty or true
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{res field "reply_comment_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraIdParent equals the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraId

  @candidate-python-word-comment-replies-aa375068b3
  # Native: tests/test_word_comment_replies.py::test_reply_invalid_comment_id_returns_valid_ids
  Scenario: Native check: reply invalid comment id returns valid ids
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id "999"; text "No-op"
    Then "error" occurs in res
    And "Valid IDs" occurs in res at "error"
    And res field "valid_comment_ids" has type list

  @candidate-python-word-comment-replies-450fd39171
  # Native: tests/test_word_comment_replies.py::test_reply_preserves_existing_replies
  Scenario: Native check: reply preserves existing replies
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "First reply"
    And word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "Second reply"
    And word tools.tool word get comments using word doc with comment at "path"
    Then r1 field "success" is true
    And r2 field "success" is true
    And r1 field "reply_comment_id" differs from r2 field "reply_comment_id"
    And "First reply" occurs in c field "text" for each c in comments field "comments", defaulting to []
    And "Second reply" occurs in c field "text" for each c in comments field "comments", defaulting to []

  @candidate-python-word-comment-replies-93084aabed
  # Native: tests/test_word_comment_replies.py::test_reply_adds_parent_paraid_when_missing
  Scenario: Native check: reply adds parent paraid when missing
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    And root is prepared as the result of load comments root with word doc with comment at "path"
    And parent is prepared as the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}']
    And parent para is prepared as the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] is not null
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p is not null
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "Reply after synthetic paraId"
    Then res field "success" is true
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraId is non-empty or true
    And the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{res field "reply_comment_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraIdParent equals the result of load comments root with word doc with comment at "path" first match for text .//{{W NS}}comment[@w:id='{word doc with comment at "parent_id"}'] first match for text {{W NS}}p field text {{W14 NS}}paraId

  @candidate-python-word-comment-replies-b01d533716
  # Native: tests/test_word_comment_replies.py::test_multiple_replies_have_unique_ids_and_paraids
  Scenario: Native check: multiple replies have unique ids and paraids
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    And ids is prepared as []
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text text Reply #{i joined with 1}
    Then res field "success" is true
    And the number of entries in [] equals the number of entries in set representation of []

  @candidate-python-word-comment-replies-f0ffd6d6a9
  # Native: tests/test_word_comment_replies.py::test_reply_author_fallback_from_identity
  Scenario: Native check: reply author fallback from identity
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And file path is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    And word tools comment author is set to "Fixture Reviewer"
    When word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "Author fallback reply"
    Then res field "success" is true
    And res field "author" occurs in the entries "Fixture Reviewer", DEFAULT COMMENT AUTHOR

  @candidate-python-word-comment-replies-73beff4b9c
  # Native: tests/test_word_comment_replies.py::test_reply_to_output_path_leaves_source_unchanged
  Scenario: Native check: reply to output path leaves source unchanged
    Given Create a DOCX with one base comment and return metadata.
    And Create an instance of WordTools.
    And an isolated writable temporary directory
    And source is prepared as word doc with comment at "path"
    And parent id is prepared as word doc with comment at "parent_id"
    And output is prepared as temp dir under "reply_out.docx"
    When word tools.tool word get comments using word doc with comment at "path"
    And word tools.tool word reply to comment using file path word doc with comment at "path"; comment id word doc with comment at "parent_id"; text "Reply in output copy"; output path str representation of temp dir under "reply_out.docx"
    And word tools.tool word get comments using str representation of temp dir under "reply_out.docx"
    Then res field "success" is true
    And temp dir under "reply_out.docx" exists is non-empty or true
    And after source field "comment_count", defaulting to 0 equals before field "comment_count", defaulting to 0
    And after output field "comment_count", defaulting to 0 equals before field "comment_count", defaulting to 0 joined with 1
