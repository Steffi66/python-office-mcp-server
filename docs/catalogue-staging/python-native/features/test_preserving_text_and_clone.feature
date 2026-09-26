@captured @python_candidate
Feature: Native Python saved text, revision and slide-clone observations

  Five native definitions use generated documents in writable temporary directories.
  Candidate descriptions need central reconciliation and grant no execution credit.
  Intermediate reopened observations remain separate from later edits and acceptance.

  @candidate-python-preserving-text-and-clone-a58e306927
  # Native: tests/test_preserving_text_and_clone.py::test_word_split_span_preserves_boundary_fonts_and_revisions
  Scenario: Split Word replacement retains boundary formatting and the first deletion before acceptance
    Given a saved document with one paragraph whose first run is "prefix <Cus" with bold true
    And its second run is "tomer> suffix" with italic true
    When OfficeServer.tool_office_patch replaces <Customer> with "Acme", omitting mode and output_path
    Then changes_applied equals 1
    When the source is reopened and its first paragraph with nonempty _get_text_with_track_changes output is selected
    Then that helper returns "prefix Acme suffix"
    And the first ordinary run has text "prefix " and truthy bold
    And the last ordinary run has text " suffix" and truthy italic
    And concatenated w:delText values in the first direct w:del equal "<Customer>"
    And that first deletion contains exactly two direct w:r children
    When OfficeServer.tool_word_accept_all_changes is called on the same file
    And the source is reopened again
    Then one paragraph's ordinary text equals "prefix Acme suffix"

  @candidate-python-preserving-text-and-clone-ee17cf0d07
  # Native: tests/test_preserving_text_and_clone.py::test_word_span_cannot_cross_field_barrier
  Scenario: A strict Word replacement across an empty simple-field barrier applies nothing
    Given a saved paragraph containing run "<Cus", an empty w:fldSimple element and run "tomer>" in that order
    And the saved source bytes are captured before the call
    When OfficeServer.tool_office_patch replaces <Customer> with "Acme" in strict mode
    Then changes_applied equals 0
    And the post-call source bytes equal the captured pre-call bytes

  @candidate-python-preserving-text-and-clone-fbd36c3e12
  # Native: tests/test_preserving_text_and_clone.py::test_slide_split_run_replacement_preserves_properties
  Scenario: One PPTX patch entry replaces two occurrences and retains boundary run flags
    Given a saved presentation with one title-layout slide and a cleared title paragraph
    And that paragraph has run "pre <Cus" with bold true followed by run "tomer> post <Customer>" with italic true
    When OfficeServer.tool_office_patch receives one <Customer> replacement entry with value "Acme", omitting mode and output_path
    Then changes_applied equals 1
    When the source is reopened and the first title paragraph is read
    Then its text equals "pre Acme post Acme"
    And its first run has truthy bold and its last run has truthy italic

  @candidate-python-preserving-text-and-clone-eda3af4e39
  # Native: tests/test_preserving_text_and_clone.py::test_duplicate_chart_has_independent_workbook_and_chart_part
  Scenario: Editing a duplicated chart leaves the original series values unchanged
    Given a saved presentation with one blank-layout slide
    And the slide contains a clustered column chart at left 1 inch, top 1 inch, width 5 inches and height 3 inches
    And chart categories are ["A", "B"] with series "Series" values [1, 2]
    When OfficeServer.tool_pptx_duplicate_slide duplicates slide 1 in the file
    Then success is truthy
    When the file is reopened and the first shapes on slides 1 and 2 are read as charts
    Then their chart part names differ
    And their embedded XLSX workbook part names differ
    When python-pptx replaces the clone's data with categories ["A", "B"] and series "Series" values [9, 8]
    And the presentation is saved and reopened again
    Then the first chart series on slide 1 has values [1, 2]
    And the first chart series on slide 2 has values [9, 8]

  @candidate-python-preserving-text-and-clone-f60f9a0596
  # Native: tests/test_preserving_text_and_clone.py::test_import_existing_notes_is_explicit_and_donor_unchanged
  Scenario: Explicit notes import leaves donor bytes intact and exposes the note in the receiver
    Given a saved donor presentation with one title-layout slide titled "Donor" and notes text "Private note"
    And a separate saved receiver with one title-layout slide
    And the saved donor bytes are captured before the call
    When OfficeServer.tool_pptx_import_slide imports donor slide 1 into the receiver with include_notes true
    Then success is truthy
    And the post-call donor bytes equal the captured pre-call bytes
    When the receiver is reopened and its last slide's notes are read
    Then its notes text contains "Private note"
