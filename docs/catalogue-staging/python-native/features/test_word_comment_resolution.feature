@captured @python_candidate
Feature: word comment resolution native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-comment-resolution-be256c979c
  # Native: tests/test_word_comment_resolution.py::test_t1_get_comments_includes_mixed_done_state
  Scenario: Native check: t1 get comments includes mixed done state
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of create two comment doc with temp dir; word advanced tools
    When word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools
    And word tools.tool word resolve comment using file path str representation of the result of create two comment doc with temp dir; word advanced tools; comment id c at "id" for each c in initial at "comments" at 0; resolved true
    Then resolved field "success" is true
    And c at "done" for each c in got at "comments" at c at "id" for each c in initial at "comments" at 0 is true
    And c at "done" for each c in got at "comments" at c at "id" for each c in initial at "comments" at 1 is false

  @candidate-python-word-comment-resolution-a31be46775
  # Native: tests/test_word_comment_resolution.py::test_t2_resolve_comment_sets_done_and_rereads_true
  Scenario: Native check: t2 resolve comment sets done and rereads true
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of create two comment doc with temp dir; word advanced tools
    When word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools
    And word tools.tool word resolve comment using str representation of the result of create two comment doc with temp dir; word advanced tools; comment id got at "comments" at 0 at "id"; resolved true
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "resolved"
    Then res field "success" is true
    And res field "done" is true
    And at least one item satisfies c at "id" equals got at "comments" at 0 at "id" and c field "done" is true for each c in reread field "comments", defaulting to []

  @candidate-python-word-comment-resolution-d243f1fea2
  # Native: tests/test_word_comment_resolution.py::test_t3_reopen_comment_sets_done_false
  Scenario: Native check: t3 reopen comment sets done false
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of create two comment doc with temp dir; word advanced tools
    When word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools
    And word tools.tool word resolve comment using str representation of the result of create two comment doc with temp dir; word advanced tools; got at "comments" at 0 at "id"; false
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "open"
    Then the result of word tools.tool word resolve comment with str representation of the result of create two comment doc with temp dir; word advanced tools; got at "comments" at 0 at "id"; true field "success" is true
    And reopened field "success" is true
    And reopened field "done" is false
    And at least one item satisfies c at "id" equals got at "comments" at 0 at "id" and c field "done" is false for each c in reread field "comments", defaulting to []

  @candidate-python-word-comment-resolution-78d1a129df
  # Native: tests/test_word_comment_resolution.py::test_t4_resolve_reply_updates_root_thread_state
  Scenario: Native check: t4 resolve reply updates root thread state
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And doc.save with temp dir under "resolve_reply.docx"
    And path is prepared as temp dir under "resolve_reply.docx"
    And doc is prepared as the result of Document with no arguments
    When word advanced tools.tool word add comment using file path str representation of temp dir under "resolve_reply.docx"; target text "Resolve this thread"; comment text "Root comment"
    And word tools.tool word get comments using str representation of temp dir under "resolve_reply.docx"
    And word tools.tool word reply to comment using file path str representation of temp dir under "resolve_reply.docx"; comment id comments at "comments" at 0 at "id"; text "Reply comment"
    And word tools.tool word resolve comment using str representation of temp dir under "resolve_reply.docx"; comment id reply at "reply_comment_id"; resolved true
    Then add field "success" is true
    And reply field "success" is true
    And resolved field "success" is true
    And resolved field "thread_root_comment_id" equals comments at "comments" at 0 at "id"
    And c for each c in got at "comments" at comments at "comments" at 0 at "id" at "done" is true

  @candidate-python-word-comment-resolution-2e2621a412
  # Native: tests/test_word_comment_resolution.py::test_t5_fallback_to_comments_ids_when_paraid_missing
  Scenario: Native check: t5 fallback to comments ids when paraid missing
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And doc.save with temp dir under "comments_ids_fallback.docx"
    And path is prepared as temp dir under "comments_ids_fallback.docx"
    And doc is prepared as the result of Document with no arguments
    When word advanced tools.tool word add comment using file path str representation of temp dir under "comments_ids_fallback.docx"; target text "Legacy mapping target"; comment text "Legacy style comment"
    And word tools.tool word get comments using str representation of temp dir under "comments_ids_fallback.docx"
    Then add field "success" is true
    And the result of next with c for each c in got at "comments" where c at "id" equals current at "comments" at 0 at "id" field "para_id" equals the result of comment para id with the result of etree.fromstring with the result of read parts with temp dir under "comments_ids_fallback.docx" at "word/comments.xml"; current at "comments" at 0 at "id" or "0F0E0D0C"

  @candidate-python-word-comment-resolution-8d2f1be135
  # Native: tests/test_word_comment_resolution.py::test_t6_create_comments_extended_entry_when_missing
  Scenario: Native check: t6 create comments extended entry when missing
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And doc.save with temp dir under "create_comments_extended.docx"
    And path is prepared as temp dir under "create_comments_extended.docx"
    And doc is prepared as the result of Document with no arguments
    When word advanced tools.tool word add comment using file path str representation of temp dir under "create_comments_extended.docx"; target text "No commentsExtended yet"; comment text "Needs follow-up"
    And word tools.tool word get comments using str representation of temp dir under "create_comments_extended.docx"
    And word tools.tool word resolve comment using str representation of temp dir under "create_comments_extended.docx"; got at "comments" at 0 at "id"; true
    Then add field "success" is true
    And "word/commentsExtended.xml" does not occur in the result of read parts with temp dir under "create_comments_extended.docx"
    And resolved field "success" is true
    And the result of next with c for each c in refreshed at "comments" where c at "id" equals got at "comments" at 0 at "id" at "para_id" is non-empty or true
    And "word/commentsExtended.xml" occurs in the result of read parts with temp dir under "create_comments_extended.docx"
    And the result of comment ex done with the result of etree.fromstring with the result of read parts with temp dir under "create_comments_extended.docx" at "word/commentsExtended.xml"; the result of next with c for each c in refreshed at "comments" where c at "id" equals got at "comments" at 0 at "id" at "para_id" equals "1"

  @candidate-python-word-comment-resolution-6e862657a6
  # Native: tests/test_word_comment_resolution.py::test_t7_roundtrip_resolve_then_reopen
  Scenario: Native check: t7 roundtrip resolve then reopen
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of create two comment doc with temp dir; word advanced tools
    When word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "open"
    Then the result of word tools.tool word resolve comment with str representation of the result of create two comment doc with temp dir; word advanced tools; got at "comments" at 0 at "id"; true field "success" is true
    And the result of word tools.tool word get comments with str representation of the result of create two comment doc with temp dir; word advanced tools; filter "resolved" field "comment_count", defaulting to 0 is at least 1
    And the result of word tools.tool word resolve comment with str representation of the result of create two comment doc with temp dir; word advanced tools; got at "comments" at 0 at "id"; false field "success" is true
    And at least one item satisfies c at "id" equals got at "comments" at 0 at "id" and c field "done" is false for each c in reopened field "comments", defaulting to []

  @candidate-python-word-comment-resolution-53363ffd9d
  # Native: tests/test_word_comment_resolution.py::test_word_get_comments_exposes_new_metadata_and_filters
  Scenario: Native check: word get comments exposes new metadata and filters
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of create two comment doc with temp dir; word advanced tools
    When word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "open"
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "resolved"
    And word tools.tool word get comments using str representation of the result of create two comment doc with temp dir; word advanced tools; filter "mine"; author "Rui Carmo"
    Then the result of {'done', 'is reply', 'parent id', 'para id'}.issubset with got at "comments" at 0 keys is non-empty or true
    And the result of word tools.tool word resolve comment with str representation of the result of create two comment doc with temp dir; word advanced tools; got at "comments" at 0 at "id"; true field "success" is true
    And every item satisfies c field "done" is false for each c in open only field "comments", defaulting to []
    And every item satisfies c field "done" is true for each c in resolved only field "comments", defaulting to []
    And every item satisfies str representation of c field "author", defaulting to "" in lowercase equals "rui carmo" for each c in mine field "comments", defaulting to []

  @candidate-python-word-comment-resolution-6940bf041d
  # Native: tests/test_word_comment_resolution.py::test_word_get_comments_threaded_format_groups_replies
  Scenario: Native check: word get comments threaded format groups replies
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And doc.save with temp dir under "threaded_format.docx"
    And path is prepared as temp dir under "threaded_format.docx"
    And doc is prepared as the result of Document with no arguments
    When word advanced tools.tool word add comment using file path str representation of temp dir under "threaded_format.docx"; target text "Thread me"; comment text "Root"
    And word tools.tool word get comments using str representation of temp dir under "threaded_format.docx"
    And word tools.tool word reply to comment using str representation of temp dir under "threaded_format.docx"; root; "Reply"
    And word tools.tool word get comments using str representation of temp dir under "threaded_format.docx"; format "threaded"
    Then add field "success" is true
    And reply field "success" is true
    And threaded field "thread_count", defaulting to 0 is at least 1
    And "threads" occurs in threaded
    And threaded at "threads" at 0 at "root" at "id" equals root
    And at least one item satisfies item at "id" equals reply at "reply_comment_id" for each item in threaded at "threads" at 0 at "replies"

  @candidate-python-word-comment-resolution-18ccc72cf3
  # Native: tests/test_word_comment_resolution.py::test_word_reply_auto_resolve_marks_thread_done
  Scenario: Native check: word reply auto resolve marks thread done
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And doc.save with temp dir under "reply_auto_resolve.docx"
    And path is prepared as temp dir under "reply_auto_resolve.docx"
    And doc is prepared as the result of Document with no arguments
    When word advanced tools.tool word add comment using file path str representation of temp dir under "reply_auto_resolve.docx"; target text "Auto resolve target"; comment text "Needs action"
    And word tools.tool word get comments using str representation of temp dir under "reply_auto_resolve.docx"
    And word tools.tool word reply to comment using file path str representation of temp dir under "reply_auto_resolve.docx"; comment id root id; text "Done now"; auto resolve true
    And word tools.tool word get comments using str representation of temp dir under "reply_auto_resolve.docx"; filter "resolved"
    Then add field "success" is true
    And reply field "success" is true
    And reply field "resolved" is true
    And at least one item satisfies c at "id" equals root id and c field "done" is true for each c in refreshed field "comments", defaulting to []
