@captured @python_candidate
Feature: word comment roundtrip fixture native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-comment-roundtrip-fixture-96e109e5b6
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_comment_roundtrip_direct_tools
  Scenario: Native check: word comment roundtrip direct tools
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And path is prepared as the result of build roundtrip doc with temp dir
    When word advanced tools.tool word add comment using file path str representation of the result of build roundtrip doc with temp dir; target text "Roundtrip scope item"; comment text "Please confirm scope wording"; author "Manuel"
    And word tools.tool word get comments using str representation of the result of build roundtrip doc with temp dir; format "threaded"
    And word tools.tool word reply to comment using file path str representation of the result of build roundtrip doc with temp dir; comment id initial at "threads" at 0 at "root" at "id"; text "Done — wording updated"; author "Rui Carmo"; auto resolve true
    And word tools.tool word resolve comment using file path str representation of the result of build roundtrip doc with temp dir; comment id reply field "reply_comment_id"; resolved false
    And word tools.tool word get comments using str representation of the result of build roundtrip doc with temp dir; filter "open"
    Then add field "success" is true
    And initial field "thread_count", defaulting to 0 equals 1
    And initial at "threads" at 0 at "root" field "done" is false
    And reply field "success" is true
    And reply field "resolved" is true
    And after reply at "threads" at 0 at "root" at "id" equals initial at "threads" at 0 at "root" at "id"
    And after reply at "threads" at 0 at "root" at "done" is true
    And at least one item satisfies r at "id" equals reply field "reply_comment_id" for each r in after reply at "threads" at 0 at "replies"
    And reopen field "success" is true
    And reopen field "thread_root_comment_id" equals initial at "threads" at 0 at "root" at "id"
    And at least one item satisfies c at "id" equals initial at "threads" at 0 at "root" at "id" and c field "done" is false for each c in open only field "comments", defaulting to []

  @candidate-python-word-comment-roundtrip-fixture-cf0e06a82a
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_comment_roundtrip_unified_tool
  Scenario: Native check: word comment roundtrip unified tool
    Given an isolated writable temporary directory
    And combined tools
    And path is prepared as the result of build roundtrip doc with temp dir
    When combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "add"; target "Roundtrip scope item"; text "Initial review note"; author "Reviewer"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "get"; format "threaded"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "reply"; target str representation of got at "threads" at 0 at "root" at "id"; text "Acknowledged"; author "Rui Carmo"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "resolve"; target str representation of got at "threads" at 0 at "root" at "id"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "get"; filter "resolved"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "reopen"; target str representation of got at "threads" at 0 at "root" at "id"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "get"; filter "open"
    And combined tools.tool office comment using file path str representation of the result of build roundtrip doc with temp dir; operation "delete"; target str representation of got at "threads" at 0 at "root" at "id"
    Then add field "success" is true
    And got field "thread_count", defaulting to 0 equals 1
    And reply field "success" is true
    And resolved field "success" is true
    And resolved field "done" is true
    And at least one item satisfies c at "id" equals str representation of got at "threads" at 0 at "root" at "id" and c field "done" is true for each c in resolved view field "comments", defaulting to []
    And reopened field "success" is true
    And reopened field "done" is false
    And at least one item satisfies c at "id" equals str representation of got at "threads" at 0 at "root" at "id" and c field "done" is false for each c in open view field "comments", defaulting to []
    And deleted field "success" is true

  @candidate-python-word-comment-roundtrip-fixture-ec40884570
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_resolve_roundtrip_with_output_path
  Scenario: Native check: word resolve roundtrip with output path
    Given an isolated writable temporary directory
    And Create an instance of WordAdvancedTools.
    And Create an instance of WordTools.
    And source is prepared as the result of build roundtrip doc with temp dir
    And output is prepared as temp dir under "comment_roundtrip_out.docx"
    When word advanced tools.tool word add comment using file path str representation of the result of build roundtrip doc with temp dir; target text "Roundtrip scope item"; comment text "Track this"
    And word tools.tool word get comments using str representation of the result of build roundtrip doc with temp dir
    And word tools.tool word resolve comment using file path str representation of the result of build roundtrip doc with temp dir; comment id source get at "comments" at 0 at "id"; resolved true; output path str representation of temp dir under "comment_roundtrip_out.docx"
    And word tools.tool word get comments using str representation of temp dir under "comment_roundtrip_out.docx"
    And word tools.tool word resolve comment using file path str representation of temp dir under "comment_roundtrip_out.docx"; comment id source get at "comments" at 0 at "id"; resolved false
    And word tools.tool word get comments using str representation of temp dir under "comment_roundtrip_out.docx"; filter "open"
    Then add field "success" is true
    And source get at "comments" at 0 at "done" is false
    And resolved field "success" is true
    And at least one item satisfies c at "id" equals source get at "comments" at 0 at "id" and c field "done" is false for each c in source after field "comments", defaulting to []
    And at least one item satisfies c at "id" equals source get at "comments" at 0 at "id" and c field "done" is true for each c in output after field "comments", defaulting to []
    And reopened field "success" is true
    And at least one item satisfies c at "id" equals source get at "comments" at 0 at "id" and c field "done" is false for each c in output reopen field "comments", defaulting to []
