@captured @python_candidate
Feature: stdio mutation workflows native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-stdio-mutation-workflows-2fb0496806
  # Native: tests/test_stdio_mutation_workflows.py::test_inspect_preview_patch_read_over_stdio
  Scenario: Native check: inspect preview patch read over stdio
    Given client
    And an isolated writable temporary directory
    And a prepared suffix input or fixture
    And a prepared target input or fixture
    And a prepared value input or fixture
    And a prepared inspect input or fixture
    And document.save with tmp path under "input" joined with suffix
    And source is prepared as tmp path under "input" joined with suffix
    And output is prepared as tmp path under "output" joined with suffix
    And before is prepared as saved bytes of tmp path under "input" joined with suffix
    And args is prepared as the fields "file_path" set to str representation of tmp path under "input" joined with suffix, "output_path" set to str representation of tmp path under "output" joined with suffix, "changes" set to the entries the fields "target" set to target, "value" set to value
    And "error" does not occur in the result of client.call with "office_inspect"; file path str representation of tmp path under "input" joined with suffix; what inspect
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [.xlsx-A1-first\nsecond-sheets] | {"suffix": "'.xlsx'", "target": "'A1'", "value": "'first\\\\nsecond'", "inspect": "'sheets'"} |
      | [.docx-<Present>-Changed-sections] | {"suffix": "'.docx'", "target": "'<Present>'", "value": "'Changed'", "inspect": "'sections'"} |
      | [.pptx-slide:1/title-Changed-slides] | {"suffix": "'.pptx'", "target": "'slide:1/title'", "value": "'Changed'", "inspect": "'slides'"} |
    When document.add paragraph using "<Present>"
    And document.slides.add slide using document slide layouts at 0
    And source.read bytes using the prepared inputs
    And client.call using "office_patch"
    Then preview at "success" and preview at "changes_applied" equals 0
    And saved bytes of tmp path under "input" joined with suffix equals saved bytes of tmp path under "input" joined with suffix and not tmp path under "output" joined with suffix exists
    And result at "changes_applied" equals 1
    And saved bytes of tmp path under "input" joined with suffix equals saved bytes of tmp path under "input" joined with suffix
    And "error" does not occur in read
    And value occurs in the result of json.dumps(read, ensure ascii=False).replace with "\\n"; "\n"
    And when suffix equals ".xlsx", the result of load workbook with tmp path under "output" joined with suffix active at "A1" value equals value
    And when suffix equals ".xlsx", the result of load workbook with tmp path under "output" joined with suffix active at "A1" alignment wrap text is non-empty or true

  @candidate-python-stdio-mutation-workflows-7a260301e1
  # Native: tests/test_stdio_mutation_workflows.py::test_strict_refusal_over_stdio_preserves_existing_files
  Scenario: Native check: strict refusal over stdio preserves existing files
    Given client
    And an isolated writable temporary directory
    And wb.save with source
    And output.write bytes with "b'original destination'"
    And wb is prepared as the result of Workbook with no arguments
    And the result of Workbook with no arguments active at "A1" is set to "before"
    And before is prepared as saved bytes of source
    When source.read bytes using the prepared inputs
    And client.call using "office_patch"
    Then result at "success" is false and result at "changes_applied" equals 0
    And saved bytes of source equals saved bytes of source
    And saved bytes of output equals "b'original destination'"
