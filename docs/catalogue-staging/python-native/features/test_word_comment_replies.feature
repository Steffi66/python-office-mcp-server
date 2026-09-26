@captured @python_candidate
Feature: Python comment replies and their observed identifiers

  These seven native checks use generated DOCX files in a writable temporary directory.
  Candidate descriptions need central reconciliation and grant no execution credit.

  Background:
    Given a saved document containing "Please review this section."
    And adding "Initial reviewer comment" by "Reviewer" to "review this section" succeeds
    And comment readback has comment_count at least 1
    And the first returned comment ID is captured as the parent ID

  @candidate-python-word-comment-replies-634c069b81
  # Native: tests/test_word_comment_replies.py::test_reply_to_existing_comment
  Scenario: A reply links its first paragraph to the parent's paragraph ID
    When replying to the captured parent with "Reply in thread" by "Rui Carmo"
    Then the result has success true and parent_comment_id equal to the captured ID
    And the returned reply_comment_id is not null
    When word/comments.xml is read from the saved document
    Then comments with the parent and reply IDs both exist and each has a first w:p
    And the parent's first paragraph has a truthy w14:paraId
    And the reply's first paragraph has w14:paraIdParent equal to that parent paraId

  @candidate-python-word-comment-replies-aa375068b3
  # Native: tests/test_word_comment_replies.py::test_reply_invalid_comment_id_returns_valid_ids
  Scenario: A reply to ID 999 returns an error and a list-shaped ID field
    When replying to comment ID "999" with "No-op"
    Then the result contains an error field whose text contains "Valid IDs"
    And valid_comment_ids has type list

  @candidate-python-word-comment-replies-450fd39171
  # Native: tests/test_word_comment_replies.py::test_reply_preserves_existing_replies
  Scenario: Two successful replies return different IDs and both texts remain readable
    When replying to the captured parent with "First reply"
    And replying again to the same parent with "Second reply"
    Then both reply results have success true
    And their returned reply_comment_id values differ
    When comments are read from the document
    Then the returned text values include "First reply" and "Second reply"

  @candidate-python-word-comment-replies-93084aabed
  # Native: tests/test_word_comment_replies.py::test_reply_adds_parent_paraid_when_missing
  Scenario: Replying after removing the parent's paragraph ID restores a linkable ID
    Given the saved parent comment and its first w:p are checked to exist in word/comments.xml
    And w14:paraId is removed from that paragraph and the modified comments XML is written back
    When replying to the captured parent with "Reply after synthetic paraId"
    Then the reply result has success true
    When saved comments XML is read and the parent and returned reply ID are located
    Then the parent's first paragraph has a truthy w14:paraId
    And the reply's first paragraph has w14:paraIdParent equal to that new parent paraId

  @candidate-python-word-comment-replies-b01d533716
  # Native: tests/test_word_comment_replies.py::test_multiple_replies_have_unique_ids_and_paraids
  Scenario: Three sequential replies have pairwise distinct returned IDs and paragraph-ID values
    When replying to the captured parent in sequence with "Reply #1", "Reply #2" and "Reply #3"
    Then each reply result has success true
    And the three collected reply_comment_id values are pairwise distinct
    When each returned ID is used to locate a saved comment and read its first paragraph's w14:paraId
    Then the three collected paraId values are pairwise distinct

  @candidate-python-word-comment-replies-f0ffd6d6a9
  # Native: tests/test_word_comment_replies.py::test_reply_author_fallback_from_identity
  Scenario: An omitted reply author permits either the configured identity or the default
    Given the Word tools object's _comment_author is set to "Fixture Reviewer"
    When replying to the captured parent with "Author fallback reply" without an author argument
    Then the reply result has success true
    And its author is either "Fixture Reviewer" or DEFAULT_COMMENT_AUTHOR

  @candidate-python-word-comment-replies-73beff4b9c
  # Native: tests/test_word_comment_replies.py::test_reply_to_output_path_leaves_source_unchanged
  Scenario: Replying to an output copy preserves the source count and increases the output count
    Given the source comment_count is recorded before the reply
    When replying to the captured parent with "Reply in output copy" and output_path set to a distinct reply_out.docx
    Then the reply result has success true and the output file exists
    When comments are read separately from the source and output
    Then the source comment_count equals its recorded count
    And the output comment_count equals that count plus 1
