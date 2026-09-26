@captured @python_candidate
Feature: Python direct and unified comment roundtrip observations

  These three native checks use generated DOCX files in a writable temporary directory.
  Candidate descriptions need central reconciliation and grant no execution credit.

  Background:
    Given a saved document with paragraphs "Roundtrip scope item" and "Secondary note"

  @candidate-python-word-comment-roundtrip-fixture-96e109e5b6
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_comment_roundtrip_direct_tools
  Scenario: Direct tools auto-resolve a root and reopen it through the reply ID
    When the direct add-comment tool adds "Please confirm scope wording" by "Manuel" to "Roundtrip scope item"
    Then the add result has success true
    When the direct get-comments tool reads format "threaded"
    Then thread_count equals 1 and that thread's root has done false
    And that root ID is captured
    When the direct reply tool replies to the root with "Done — wording updated" by "Rui Carmo" and auto_resolve true
    Then the reply result has success true and resolved true
    When the direct get-comments tool reads format "threaded" again
    Then the first thread's root has the captured ID and done true
    And at least one entry in that thread's replies has the returned reply_comment_id
    When the direct resolve tool reopens the returned reply ID with resolved false
    Then the reopening result has success true and thread_root_comment_id equal to the captured root ID
    When the direct get-comments tool reads filter "open"
    Then at least one returned comment has the captured root ID and done false

  @candidate-python-word-comment-roundtrip-fixture-cf0e06a82a
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_comment_roundtrip_unified_tool
  Scenario: The unified comment tool resolves and reopens a root then reports deletion success
    Given a combined tools object composed from TOOL_CLASSES
    When tool_office_comment adds "Initial review note" by "Reviewer" to "Roundtrip scope item"
    Then the add result has success true
    When tool_office_comment gets format "threaded"
    Then thread_count equals 1 and the first thread's root ID is captured
    When tool_office_comment replies to that root with "Acknowledged" by "Rui Carmo"
    Then the reply result has success true
    When tool_office_comment resolves that root
    Then the resolution result has success true and done true
    When tool_office_comment gets filter "resolved"
    Then at least one returned comment has the captured root ID as a string and done true
    When tool_office_comment reopens that root
    Then the reopening result has success true and done false
    When tool_office_comment gets filter "open"
    Then at least one returned comment has the captured root ID as a string and done false
    When tool_office_comment deletes that root
    Then the deletion result has success true

  @candidate-python-word-comment-roundtrip-fixture-ec40884570
  # Native: tests/test_word_comment_roundtrip_fixture.py::test_word_resolve_roundtrip_with_output_path
  Scenario: Resolve to a copy leaves the source comment open and allows the copy to reopen
    When the direct add-comment tool adds "Track this" to "Roundtrip scope item"
    Then the add result has success true
    When source comments are read without a filter
    Then the first returned comment has done false and its ID is captured
    When the direct resolve tool resolves that ID to a distinct comment_roundtrip_out.docx
    Then the resolution result has success true
    When source and output comments are read separately without filters
    Then at least one source comment has the captured ID and done false
    And at least one output comment has the captured ID and done true
    When the direct resolve tool reopens that ID in the output file with resolved false
    Then the reopening result has success true
    When output comments are read with filter "open"
    Then at least one returned comment has the captured ID and done false
