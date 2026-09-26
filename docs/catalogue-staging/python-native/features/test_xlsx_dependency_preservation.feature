@captured @python_candidate
Feature: xlsx dependency preservation native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-xlsx-dependency-preservation-b4cbe8ef34
  # Native: tests/test_xlsx_dependency_preservation.py::test_multiline_edit_saves_style_dependency_and_retains_opaque_parts
  Scenario: Native check: multiline edit saves style dependency and retains opaque parts
    Given an isolated writable temporary directory
    And source is prepared as tmp path under "source.xlsx"
    And output is prepared as tmp path under "out.xlsx"
    And before is prepared as the result of parts with tmp path under "source.xlsx"
    When OfficeServer().tool office patch using str representation of tmp path under "source.xlsx"; [{"target": "A1", "value": "first\nsecond"}]; mode "safe"; output path str representation of tmp path under "out.xlsx"
    Then result at "changes_applied" equals 1
    And the result of parts with tmp path under "out.xlsx" keys equals the result of parts with tmp path under "source.xlsx" keys
    And when name does not occur in "{'xl/styles.xml', 'xl/worksheets/sheet1.xml'}", the result of parts with tmp path under "out.xlsx" at name equals the result of parts with tmp path under "source.xlsx" at name
    And the result of load workbook with tmp path under "out.xlsx" active at "A1" value equals "first\nsecond"
    And the result of load workbook with tmp path under "out.xlsx" active at "A1" alignment wrap text is non-empty or true
    And 0 is at most int representation of c field "s", defaulting to "0" and int representation of c field "s", defaulting to "0" is below the number of entries in the result of ET.fromstring with the result of parts with tmp path under "out.xlsx" at "xl/styles.xml" first match for S joined with "cellXfs"

  @candidate-python-xlsx-dependency-preservation-06aa509d55
  # Native: tests/test_xlsx_dependency_preservation.py::test_cross_sheet_formula_cache_is_invalidated_without_calculation
  Scenario: Native check: cross sheet formula cache is invalidated without calculation
    Given an isolated writable temporary directory
    And source is prepared as tmp path under "source.xlsx"
    And output is prepared as tmp path under "out.xlsx"
    And before is prepared as the result of parts with tmp path under "source.xlsx"
    When OfficeServer().tool office patch using str representation of tmp path under "source.xlsx"; [{"target": "Input!A1", "value": 10}]; mode "safe"; output path str representation of tmp path under "out.xlsx"
    Then result at "changes_applied" equals 1
    And result at "calculation_state" equals "recalculation-required"
    And result at "preservation" at "cache_policy" equals "invalidate-all-formula-caches"
    And the result of load workbook with tmp path under "out.xlsx"; data only data only at "Input" at "A1" value equals 10
    And the result of load workbook with tmp path under "out.xlsx"; data only data only at "Calc" at "A1" value equals expected
    And when name does not occur in "{'xl/workbook.xml', 'xl/worksheets/sheet1.xml', 'xl/worksheets/sheet2.xml'}", the result of parts with tmp path under "source.xlsx" at name equals the result of parts with tmp path under "out.xlsx" at name
    And the result of ET.fromstring with the result of parts with tmp path under "out.xlsx" at "xl/workbook.xml" first match for S joined with "calcPr" field "forceFullCalc" equals "1"

  @candidate-python-xlsx-dependency-preservation-232a6f4854
  # Native: tests/test_xlsx_dependency_preservation.py::test_existing_custom_style_indices_remain_valid
  Scenario: Native check: existing custom style indices remain valid
    Given an isolated writable temporary directory
    And wb.save with tmp path under "source.xlsx"
    And source is prepared as tmp path under "source.xlsx"
    And wb active at "B1" is set to 1.25
    And wb active at "B1" number format is set to "#,##0.0000\" units\""
    And wb active at "B1" alignment is set to the result of Alignment with horizontal "right"
    When OfficeServer().tool office patch using str representation of tmp path under "source.xlsx"; [{"target": "A1", "value": "a\nb"}]
    Then result at "changes_applied" equals 1
    And wb active at "B1" number format equals "#,##0.0000\" units\""
    And wb active at "B1" alignment horizontal equals "right"
    And wb active at "A1" alignment wrap text is non-empty or true

  @candidate-python-xlsx-dependency-preservation-4ce21ae4f6
  # Native: tests/test_xlsx_dependency_preservation.py::test_style_reindexing_is_refused
  Scenario: Native check: style reindexing is refused
    Given original is prepared as the result of f'<styleSheet xmlns="{S[1:-1]}"><cellXfs count="1"><xf fontId="0"/></cellXfs></styleSheet>'.encode with no arguments
    And rewritten is prepared as the result of original.replace with "b'fontId=\"0\"'"; "b'fontId=\"1\"'"
    When merge styles using the result of f'<styleSheet xmlns="{S[1:-1]}"><cellXfs count="1"><xf fontId="0"/></cellXfs></styleSheet>'.encode with no arguments; the result of original.replace with "b'fontId=\"0\"'"; "b'fontId=\"1\"'"
    Then the operation raises ValueError with a message matching "registry rewrite"

  @candidate-python-xlsx-dependency-preservation-5587a2b78e
  # Native: tests/test_xlsx_dependency_preservation.py::test_calculation_chain_relationship_and_content_type_are_removed
  Scenario: Native check: calculation chain relationship and content type are removed
    Given an isolated writable temporary directory
    And source is prepared as tmp path under "source.xlsx"
    And entries is prepared as the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx"
    And rel ns is prepared as "{http://schemas.openxmlformats.org/package/2006/relationships}"
    And rels is prepared as the result of ET.fromstring with the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "xl/_rels/workbook.xml.rels"
    And the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "xl/_rels/workbook.xml.rels" is set to the result of ET.tostring with the result of ET.fromstring with the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "xl/_rels/workbook.xml.rels"
    And types is prepared as the result of ET.fromstring with the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "[Content_Types].xml"
    And the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "[Content_Types].xml" is set to the result of ET.tostring with the result of ET.fromstring with the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "[Content_Types].xml"
    And the result of parts with the result of shared fixture with "cross-sheet-cache.xlsx" at "xl/calcChain.xml" is set to the result of f'<calcChain xmlns="{S[1:-1]}"><c r="A1" i="2"/></calcChain>'.encode with no arguments
    When OfficeServer().tool office patch using str representation of tmp path under "source.xlsx"; [{"target": "Input!A1", "value": 10}]
    Then result at "changes_applied" equals 1
    And "xl/calcChain.xml" does not occur in the result of parts with tmp path under "source.xlsx"
    And "b'calcChain'" does not occur in the result of parts with tmp path under "source.xlsx" at "xl/_rels/workbook.xml.rels"
    And "b'calcChain'" does not occur in the result of parts with tmp path under "source.xlsx" at "[Content_Types].xml"
