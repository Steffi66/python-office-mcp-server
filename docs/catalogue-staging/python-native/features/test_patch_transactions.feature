@captured @python_candidate
Feature: patch transactions native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-patch-transactions-ae7eee373d
  # Native: tests/test_patch_transactions.py::test_preview_never_modifies_source_or_destination
  Scenario: Native check: preview never modifies source or destination
    Given an isolated writable temporary directory
    And a prepared suffix input or fixture
    And a prepared target input or fixture
    And a prepared destination input or fixture
    And source is prepared as tmp path under "input" joined with suffix
    And output is prepared as the result of destination for with tmp path under "input" joined with suffix; destination
    And before is prepared as the result of snapshot with tmp path
    And entries is prepared as sorted representation of p name for each p in the result of tmp path.iterdir with no arguments
    And each of these native parameter variants is exercised independently
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
    When OfficeServer().tool office patch using str representation of tmp path under "input" joined with suffix; the entries the fields "target" set to target, "value" set to "changed"; mode "dry_run"; output path str representation of the result of destination for with tmp path under "input" joined with suffix; destination
    Then result at "success" is non-empty or true
    And result at "changes_applied" equals 0
    And result at "changes_planned" equals 1
    And not result at "results" at 0 at "applied"
    And the result of snapshot with tmp path equals the result of snapshot with tmp path
    And sorted representation of p name for each p in the result of tmp path.iterdir with no arguments equals sorted representation of p name for each p in the result of tmp path.iterdir with no arguments

  @candidate-python-patch-transactions-d45a22b5f7
  # Native: tests/test_patch_transactions.py::test_strict_refusal_is_atomic
  Scenario: Native check: strict refusal is atomic
    Given an isolated writable temporary directory
    And a prepared destination input or fixture
    And a prepared suffix input or fixture
    And a prepared good input or fixture
    And a prepared bad input or fixture
    And source is prepared as tmp path under "input" joined with suffix
    And output is prepared as the result of destination for with tmp path under "input" joined with suffix; destination
    And before is prepared as the result of snapshot with tmp path
    And each of these native parameter variants is exercised independently
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
    When OfficeServer().tool office patch using str representation of tmp path under "input" joined with suffix; the entries the fields "target" set to good, "value" set to "changed", the fields "target" set to bad, "value" set to "missing"; mode "strict"; output path str representation of the result of destination for with tmp path under "input" joined with suffix; destination
    Then result at "success" is false
    And result at "changes_applied" equals 0
    And every item satisfies not r at "applied" for each r in result field "results", defaulting to []
    And the result of snapshot with tmp path equals the result of snapshot with tmp path
    And not at least one item satisfies the result of p.is dir with no arguments for each p in the result of tmp path.iterdir with no arguments

  @candidate-python-patch-transactions-69c7d57f18
  # Native: tests/test_patch_transactions.py::test_presentation_batch_accumulates_at_distinct_output
  Scenario: Native check: presentation batch accumulates at distinct output
    Given an isolated writable temporary directory
    And a prepared destination input or fixture
    And source is prepared as tmp path under "input.pptx"
    And original is prepared as saved bytes of tmp path under "input.pptx"
    And output is prepared as the result of destination for with tmp path under "input.pptx"; destination
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [absent] | {"destination": "'absent'"} |
      | [existing] | {"destination": "'existing'"} |
    When OfficeServer().tool office patch using str representation of tmp path under "input.pptx"; [{"target": "slide:1/title", "value": "Changed title"}, {"target": "slide:1/subtitle", "value": "Changed subtitle"}]; output path str representation of the result of destination for with tmp path under "input.pptx"; destination; mode "safe"
    Then result at "changes_applied" equals 2
    And the result of Presentation with the result of destination for with tmp path under "input.pptx"; destination slides at 0 shapes title text equals "Changed title"
    And the result of Presentation with the result of destination for with tmp path under "input.pptx"; destination slides at 0 placeholders at 1 text equals "Changed subtitle"
    And saved bytes of tmp path under "input.pptx" equals saved bytes of tmp path under "input.pptx"

  @candidate-python-patch-transactions-86b17c8885
  # Native: tests/test_patch_transactions.py::test_word_best_effort_counts_each_placeholder
  Scenario: Native check: word best effort counts each placeholder
    Given an isolated writable temporary directory
    And source is prepared as tmp path under "input.docx"
    When OfficeServer().tool office patch using str representation of tmp path under "input.docx"; [{"target": "<Present>", "value": "changed"}, {"target": "<Missing>", "value": "absent"}]
    Then result at "status" equals "partial_success"
    And result at "changes_applied" equals 1
    And r at "applied" for each r in result at "results" equals [true, false]
    And the result of ''.join with the result of get text with track changes with p for each p in the result of Document with tmp path under "input.docx" paragraphs equals "changed"

  @candidate-python-patch-transactions-6a9d778173
  # Native: tests/test_patch_transactions.py::test_invalid_range_does_not_leak_partial_rows_in_best_effort
  Scenario: Native check: invalid range does not leak partial rows in best effort
    Given an isolated writable temporary directory
    And a prepared value input or fixture
    And source is prepared as tmp path under "input.xlsx"
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [value0] | {"value": "[['bad', 'partial'], ['short']]"} |
      | [value1] | {"value": "[['bad', 'partial'], None]"} |
      | [value2] | {"value": "[['bad', 'partial'], [1, {}]]"} |
    When OfficeServer().tool office patch using str representation of tmp path under "input.xlsx"; the entries the fields "target" set to "A1:B2", "value" set to value, {"target": "D1", "value": "valid"}
    Then result at "changes_applied" equals 1
    And the result of load workbook with tmp path under "input.xlsx" active at "A1" value equals "before"
    And the result of load workbook with tmp path under "input.xlsx" active at "B1" value is null
    And the result of load workbook with tmp path under "input.xlsx" active at "D1" value equals "valid"

  @candidate-python-patch-transactions-b2522e469b
  # Native: tests/test_patch_transactions.py::test_missing_pptx_placeholder_is_not_applied
  Scenario: Native check: missing pptx placeholder is not applied
    Given an isolated writable temporary directory
    And source is prepared as tmp path under "input.pptx"
    And before is prepared as saved bytes of tmp path under "input.pptx"
    When OfficeServer().tool office patch using str representation of tmp path under "input.pptx"; [{"target": "absent", "value": "changed"}]
    Then result at "changes_applied" equals 0
    And saved bytes of tmp path under "input.pptx" equals saved bytes of tmp path under "input.pptx"

  @candidate-python-patch-transactions-ccdfa52bb0
  # Native: tests/test_patch_transactions.py::test_invalid_excel_address_preserves_source
  Scenario: Native check: invalid excel address preserves source
    Given an isolated writable temporary directory
    And a prepared bad target input or fixture
    And source is prepared as tmp path under "input.xlsx"
    And before is prepared as saved bytes of tmp path under "input.xlsx"
    And value is prepared as [[1, 2]] when ":" occurs in bad target otherwise "new"
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [A0] | {"bad_target": "'A0'"} |
      | [XFE1] | {"bad_target": "'XFE1'"} |
      | [A1junk] | {"bad_target": "'A1junk'"} |
      | [A2:A1] | {"bad_target": "'A2:A1'"} |
      | [A0:B1] | {"bad_target": "'A0:B1'"} |
    When OfficeServer().tool office patch using str representation of tmp path under "input.xlsx"; the entries the fields "target" set to bad target, "value" set to [[1, 2]] when ":" occurs in bad target otherwise "new"
    Then result at "changes_applied" equals 0
    And saved bytes of tmp path under "input.xlsx" equals saved bytes of tmp path under "input.xlsx"
