@captured @python_candidate
Feature: Python comment resolution, metadata and threaded readback

  These ten native checks use generated DOCX files in a writable temporary directory.
  Candidate descriptions need central reconciliation and grant no execution credit.
  Resolution through a reply targets the root; metadata fallback and creation are Python behaviours.

  @candidate-python-word-comment-resolution-be256c979c
  # Native: tests/test_word_comment_resolution.py::test_t1_get_comments_includes_mixed_done_state
  Scenario: Resolving the first of two comments leaves mixed readback states
    Given a saved document with paragraphs "Alpha target" and "Beta target"
    And adding "Comment alpha" by "Manuel" and "Comment beta" by "Rui Carmo" to their respective targets succeeds
    And the first and second comment IDs are captured from unfiltered readback
    When the first comment is resolved with resolved true
    Then the resolution result has success true
    When comments are read again without a filter
    Then the first captured comment has done true
    And the second captured comment has done false

  @candidate-python-word-comment-resolution-a31be46775
  # Native: tests/test_word_comment_resolution.py::test_t2_resolve_comment_sets_done_and_rereads_true
  Scenario: Resolution returns done true and the resolved filter contains the target
    Given a saved document with paragraphs "Alpha target" and "Beta target"
    And adding "Comment alpha" by "Manuel" and "Comment beta" by "Rui Carmo" to their respective targets succeeds
    And the first comment ID is captured from unfiltered readback
    When that comment is resolved with resolved true
    Then the resolution result has success true and done true
    When comments are read with filter "resolved"
    Then at least one returned comment has the captured ID and done true

  @candidate-python-word-comment-resolution-d243f1fea2
  # Native: tests/test_word_comment_resolution.py::test_t3_reopen_comment_sets_done_false
  Scenario: Reopening a resolved comment returns done false and makes it visible in the open filter
    Given a saved document with paragraphs "Alpha target" and "Beta target"
    And adding "Comment alpha" by "Manuel" and "Comment beta" by "Rui Carmo" to their respective targets succeeds
    And the first comment ID is captured from unfiltered readback
    When that comment is resolved with resolved true
    Then the resolution result has success true
    When the same comment is reopened with resolved false
    Then the reopening result has success true and done false
    When comments are read with filter "open"
    Then at least one returned comment has the captured ID and done false

  @candidate-python-word-comment-resolution-78d1a129df
  # Native: tests/test_word_comment_resolution.py::test_t4_resolve_reply_updates_root_thread_state
  Scenario: Resolving a reply reports its root and marks the root done on readback
    Given a saved document containing the paragraph "Resolve this thread"
    And adding "Root comment" to that target succeeds
    And the root comment ID is captured from unfiltered readback
    When replying to the root with "Reply comment" succeeds and returns a reply_comment_id
    And the returned reply ID is resolved with resolved true
    Then the resolution result has success true
    And its thread_root_comment_id equals the captured root ID
    When comments are read again without a filter
    Then the comment with the root ID has done true

  @candidate-python-word-comment-resolution-2e2621a412
  # Native: tests/test_word_comment_resolution.py::test_t5_fallback_to_comments_ids_when_paraid_missing
  Scenario: A crafted commentsIds mapping supplies a missing first-paragraph ID
    Given a saved document containing the paragraph "Legacy mapping target"
    And adding "Legacy style comment" to that target succeeds
    And the comment ID is captured from unfiltered readback
    And the saved comment's first w:p supplies the expected w14:paraId or the fallback "0F0E0D0C"
    And w14:paraId is removed from that first paragraph in word/comments.xml
    And word/commentsIds.xml is written with a w16cid:commentId mapping the captured ID to the expected paraId
    And the modified package parts are written back to the document
    When comments are read again without a filter
    Then the comment with the captured ID has para_id equal to the mapped value

  @candidate-python-word-comment-resolution-8d2f1be135
  # Native: tests/test_word_comment_resolution.py::test_t6_create_comments_extended_entry_when_missing
  Scenario: Resolution creates an absent commentsExtended part with a matching done entry
    Given a saved document containing the paragraph "No commentsExtended yet"
    And adding "Needs follow-up" to that target succeeds
    And the comment ID is captured from unfiltered readback
    And the saved package is checked to have no word/commentsExtended.xml part
    When that comment is resolved with resolved true
    Then the resolution result has success true
    When comments and saved package parts are read again
    Then the comment with the captured ID has a truthy para_id
    And the saved package contains word/commentsExtended.xml
    And parsing that part finds a w15:commentEx for that para_id with w15:done equal to "1"

  @candidate-python-word-comment-resolution-6e862657a6
  # Native: tests/test_word_comment_resolution.py::test_t7_roundtrip_resolve_then_reopen
  Scenario: A resolve and reopen sequence has a nonzero resolved count and returns the target as open
    Given a saved document with paragraphs "Alpha target" and "Beta target"
    And adding "Comment alpha" by "Manuel" and "Comment beta" by "Rui Carmo" to their respective targets succeeds
    And the first comment ID is captured from unfiltered readback
    When that comment is resolved with resolved true
    Then the resolution result has success true
    When comments are read with filter "resolved"
    Then comment_count is at least 1
    When the same captured comment is reopened with resolved false
    Then the reopening result has success true
    When comments are read with filter "open"
    Then at least one returned comment has the captured ID and done false

  @candidate-python-word-comment-resolution-53363ffd9d
  # Native: tests/test_word_comment_resolution.py::test_word_get_comments_exposes_new_metadata_and_filters
  Scenario: Metadata keys are present and any filtered entries satisfy their predicates
    Given a saved document with paragraphs "Alpha target" and "Beta target"
    And adding "Comment alpha" by "Manuel" and "Comment beta" by "Rui Carmo" to their respective targets succeeds
    When comments are read without a filter
    Then the first entry contains the keys done, is_reply, parent_id and para_id
    When that first entry's ID is resolved with resolved true
    Then the resolution result has success true
    When comments are read with filter "open"
    Then every returned entry has done false, allowing an empty list
    When comments are read with filter "resolved"
    Then every returned entry has done true, allowing an empty list
    When comments are read with filter "mine" and author "Rui Carmo"
    Then every returned entry's author lowercases to "rui carmo", allowing an empty list

  @candidate-python-word-comment-resolution-6940bf041d
  # Native: tests/test_word_comment_resolution.py::test_word_get_comments_threaded_format_groups_replies
  Scenario: Threaded output places the created reply under the first thread's root
    Given a saved document containing the paragraph "Thread me"
    And adding "Root" to that target succeeds
    And the root comment ID is captured from unfiltered readback
    When replying to the root with "Reply" succeeds and returns a reply_comment_id
    And comments are read with format "threaded"
    Then thread_count is at least 1 and the response contains threads
    And the first thread's root ID equals the captured root ID
    And at least one entry in that thread's replies has the returned reply_comment_id

  @candidate-python-word-comment-resolution-18ccc72cf3
  # Native: tests/test_word_comment_resolution.py::test_word_reply_auto_resolve_marks_thread_done
  Scenario: Reply auto-resolution reports resolved true and returns the root in the resolved filter
    Given a saved document containing the paragraph "Auto resolve target"
    And adding "Needs action" to that target succeeds
    And the root comment ID is captured from unfiltered readback
    When replying to the root with "Done now" and auto_resolve true
    Then the reply result has success true and resolved true
    When comments are read with filter "resolved"
    Then at least one returned comment has the captured root ID and done true
