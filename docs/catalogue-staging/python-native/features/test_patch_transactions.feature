@captured @python_candidate
Feature: Native Python patch transactions and saved-document observations

  Seven native definitions retain 30 recorded parameter cases.
  Parameter tables describe native variants; they are not executable catalogue bindings.
  Candidate descriptions need central reconciliation and grant no execution credit.

  @candidate-python-patch-transactions-ae7eee373d
  # Native: tests/test_patch_transactions.py::test_preview_never_modifies_source_or_destination
  Scenario: Dry-run plans one change and preserves saved files and directory entries
    Given an isolated writable directory and a generated input file for the recorded suffix
    And XLSX inputs have active-sheet A1 "before", DOCX inputs have paragraph "<Present>", and PPTX inputs have slide-1 title "Original title" and subtitle "Original subtitle"
    And destination "source" is the input path, "absent" is a missing distinct output path, and "existing" is that distinct path containing bytes "existing output must survive failure"
    And all immediate regular-file names and bytes are captured before the call
    And all immediate directory-entry names are separately captured before the call
    And the recorded native parameter variants are
      | variant | parameter values |
      | [source-.xlsx-A1] | {"destination": "'source'", "suffix": "'.xlsx'", "target": "'A1'"} |
      | [source-.docx-<Present>] | {"destination": "'source'", "suffix": "'.docx'", "target": "'<Present>'"} |
      | [source-.pptx-slide:1/title] | {"destination": "'source'", "suffix": "'.pptx'", "target": "'slide:1/title'"} |
      | [absent-.xlsx-A1] | {"destination": "'absent'", "suffix": "'.xlsx'", "target": "'A1'"} |
      | [absent-.docx-<Present>] | {"destination": "'absent'", "suffix": "'.docx'", "target": "'<Present>'"} |
      | [absent-.pptx-slide:1/title] | {"destination": "'absent'", "suffix": "'.pptx'", "target": "'slide:1/title'"} |
      | [existing-.xlsx-A1] | {"destination": "'existing'", "suffix": "'.xlsx'", "target": "'A1'"} |
      | [existing-.docx-<Present>] | {"destination": "'existing'", "suffix": "'.docx'", "target": "'<Present>'"} |
      | [existing-.pptx-slide:1/title] | {"destination": "'existing'", "suffix": "'.pptx'", "target": "'slide:1/title'"} |
    When OfficeServer.tool_office_patch receives the recorded target with value "changed", mode "dry_run" and the selected output_path
    Then success is truthy, changes_applied equals 0 and changes_planned equals 1
    And the first result's applied value is falsey
    And the post-call file-name-to-bytes snapshot equals the captured pre-call snapshot
    And the sorted post-call directory-entry names equal the captured pre-call names

  @candidate-python-patch-transactions-d45a22b5f7
  # Native: tests/test_patch_transactions.py::test_strict_refusal_is_atomic
  Scenario: Strict batches refuse a later unmatched target without changing saved files
    Given an isolated writable directory and a generated input file for the recorded suffix
    And XLSX inputs have active-sheet A1 "before", DOCX inputs have paragraph "<Present>", and PPTX inputs have slide-1 title "Original title" and subtitle "Original subtitle"
    And destination "source" is the input path, "absent" is a missing distinct output path, and "existing" is that distinct path containing bytes "existing output must survive failure"
    And all immediate regular-file names and bytes are captured before the call
    And the recorded native parameter variants are
      | variant | parameter values |
      | [.xlsx-A1-Missing!B1-source] | {"suffix": "'.xlsx'", "good": "'A1'", "bad": "'Missing!B1'", "destination": "'source'"} |
      | [.xlsx-A1-Missing!B1-absent] | {"suffix": "'.xlsx'", "good": "'A1'", "bad": "'Missing!B1'", "destination": "'absent'"} |
      | [.xlsx-A1-Missing!B1-existing] | {"suffix": "'.xlsx'", "good": "'A1'", "bad": "'Missing!B1'", "destination": "'existing'"} |
      | [.docx-<Present>-<Missing>-source] | {"suffix": "'.docx'", "good": "'<Present>'", "bad": "'<Missing>'", "destination": "'source'"} |
      | [.docx-<Present>-<Missing>-absent] | {"suffix": "'.docx'", "good": "'<Present>'", "bad": "'<Missing>'", "destination": "'absent'"} |
      | [.docx-<Present>-<Missing>-existing] | {"suffix": "'.docx'", "good": "'<Present>'", "bad": "'<Missing>'", "destination": "'existing'"} |
      | [.pptx-slide:1/title-slide:1/absent shape-source] | {"suffix": "'.pptx'", "good": "'slide:1/title'", "bad": "'slide:1/absent shape'", "destination": "'source'"} |
      | [.pptx-slide:1/title-slide:1/absent shape-absent] | {"suffix": "'.pptx'", "good": "'slide:1/title'", "bad": "'slide:1/absent shape'", "destination": "'absent'"} |
      | [.pptx-slide:1/title-slide:1/absent shape-existing] | {"suffix": "'.pptx'", "good": "'slide:1/title'", "bad": "'slide:1/absent shape'", "destination": "'existing'"} |
    When OfficeServer.tool_office_patch receives good with value "changed" followed by bad with value "missing", mode "strict" and the selected output_path
    Then success is false and changes_applied equals 0
    And every returned result has a falsey applied value, allowing a missing or empty results list
    And the post-call file-name-to-bytes snapshot equals the captured pre-call snapshot
    And no immediate entry in the temporary directory is a directory

  @candidate-python-patch-transactions-69c7d57f18
  # Native: tests/test_patch_transactions.py::test_presentation_batch_accumulates_at_distinct_output
  Scenario: A safe PPTX batch saves both edits to a distinct output and preserves source bytes
    Given a generated presentation with slide-1 title "Original title" and subtitle "Original subtitle"
    And its source bytes are captured before the call
    And destination "absent" is a missing distinct output path and "existing" is that path containing bytes "existing output must survive failure"
    And the recorded native parameter variants are
      | variant | parameter values |
      | [absent] | {"destination": "'absent'"} |
      | [existing] | {"destination": "'existing'"} |
    When OfficeServer.tool_office_patch receives slide:1/title "Changed title" followed by slide:1/subtitle "Changed subtitle", mode "safe" and the distinct output_path
    Then changes_applied equals 2
    When the output is reopened with Presentation
    Then slide 1 has title "Changed title" and placeholder 1 text "Changed subtitle"
    And source bytes equal the captured pre-call source bytes

  @candidate-python-patch-transactions-86b17c8885
  # Native: tests/test_patch_transactions.py::test_word_best_effort_counts_each_placeholder
  Scenario: Default-mode Word patch reports one applied placeholder and saves changed text
    Given a generated document with the single paragraph "<Present>"
    When OfficeServer.tool_office_patch receives <Present> with value "changed" followed by <Missing> with value "absent", omitting mode and output_path
    Then status equals "partial_success" and changes_applied equals 1
    And the ordered per-result applied values equal [true, false]
    When the source is reopened with Document and paragraph text is read through _get_text_with_track_changes
    Then concatenating those paragraph strings equals "changed"

  @candidate-python-patch-transactions-6a9d778173
  # Native: tests/test_patch_transactions.py::test_invalid_range_does_not_leak_partial_rows_in_best_effort
  Scenario: Invalid range inputs leave observed first-row cells intact while a separate edit saves
    Given a generated workbook with active-sheet A1 "before"
    And the recorded native parameter variants are
      | variant | parameter values |
      | [value0] | {"value": "[['bad', 'partial'], ['short']]"} |
      | [value1] | {"value": "[['bad', 'partial'], None]"} |
      | [value2] | {"value": "[['bad', 'partial'], [1, {}]]"} |
    When OfficeServer.tool_office_patch receives A1:B2 with the recorded value followed by D1 with value "valid", omitting mode and output_path
    Then changes_applied equals 1
    When the source is reopened with load_workbook
    Then active-sheet A1 equals "before", B1 is null and D1 equals "valid"

  @candidate-python-patch-transactions-b2522e469b
  # Native: tests/test_patch_transactions.py::test_missing_pptx_placeholder_is_not_applied
  Scenario: An absent PPTX target applies nothing and preserves source bytes
    Given a generated presentation with slide-1 title "Original title" and subtitle "Original subtitle"
    And its source bytes are captured before the call
    When OfficeServer.tool_office_patch receives target "absent" with value "changed", omitting mode and output_path
    Then changes_applied equals 0
    And source bytes equal the captured pre-call source bytes

  @candidate-python-patch-transactions-ccdfa52bb0
  # Native: tests/test_patch_transactions.py::test_invalid_excel_address_preserves_source
  Scenario: Five invalid Excel addresses apply nothing and preserve source bytes
    Given a generated workbook with active-sheet A1 "before"
    And its source bytes are captured before the call
    And the replacement is [[1, 2]] when bad_target contains a colon and "new" otherwise
    And the recorded native parameter variants are
      | variant | parameter values |
      | [A0] | {"bad_target": "'A0'"} |
      | [XFE1] | {"bad_target": "'XFE1'"} |
      | [A1junk] | {"bad_target": "'A1junk'"} |
      | [A2:A1] | {"bad_target": "'A2:A1'"} |
      | [A0:B1] | {"bad_target": "'A0:B1'"} |
    When OfficeServer.tool_office_patch receives the recorded bad_target and replacement, omitting mode and output_path
    Then changes_applied equals 0
    And source bytes equal the captured pre-call source bytes
