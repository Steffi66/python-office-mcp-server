@captured @python_candidate
Feature: Native Python XLSX value-edit dependencies and calculation metadata

  Five native definitions describe saved-package or merge-helper observations.
  Shared fixture references remain central; no fixture bytes are copied here.
  Candidate descriptions need reconciliation and grant no execution credit.

  @candidate-python-xlsx-dependency-preservation-b4cbe8ef34
  # Native: tests/test_xlsx_dependency_preservation.py::test_multiline_edit_saves_style_dependency_and_retains_opaque_parts
  Scenario: A multiline value edit saves wrap text and valid worksheet style references
    Given shared_fixture("default-style.xlsx") is copied to a temporary source.xlsx
    And the source ZIP member names and payloads are captured before the call
    When OfficeServer.tool_office_patch sets A1 to "first\nsecond" in safe mode with distinct out.xlsx output
    Then changes_applied equals 1
    When output ZIP members are read
    Then output member keys equal the captured source member keys
    And every member except xl/worksheets/sheet1.xml and xl/styles.xml has its captured source payload
    When the output is reopened with load_workbook
    Then active-sheet A1 has value "first\nsecond" and truthy alignment.wrap_text
    When output xl/styles.xml and xl/worksheets/sheet1.xml are parsed
    Then every cell's integer s value, defaulting to 0, is nonnegative and below the number of cellXfs children

  @candidate-python-xlsx-dependency-preservation-06aa509d55
  # Native: tests/test_xlsx_dependency_preservation.py::test_cross_sheet_formula_cache_is_invalidated_without_calculation
  Scenario: A cross-sheet input edit clears the observed formula cache and requests recalculation
    Given shared_fixture("cross-sheet-cache.xlsx") is copied to a temporary source.xlsx
    And the source ZIP member names and payloads are captured before the call
    When OfficeServer.tool_office_patch sets Input!A1 to 10 in safe mode with distinct out.xlsx output
    Then changes_applied equals 1 and calculation_state equals "recalculation-required"
    And preservation.cache_policy equals "invalidate-all-formula-caches"
    When the output is reopened first with data_only true and then with data_only false
    Then Input!A1 equals 10 in both reads
    And Calc!A1 is null with data_only true and "=Input!A1*2" with data_only false
    When output ZIP members and xl/workbook.xml are read
    Then each captured source member except xl/worksheets/sheet1.xml, xl/worksheets/sheet2.xml and xl/workbook.xml has an equal output payload
    And the workbook calcPr element has forceFullCalc equal to "1"

  @candidate-python-xlsx-dependency-preservation-232a6f4854
  # Native: tests/test_xlsx_dependency_preservation.py::test_existing_custom_style_indices_remain_valid
  Scenario: A multiline edit retains B1 custom formatting and enables A1 wrap text
    Given a saved generated workbook with B1 value 1.25
    And B1 number_format is '#,##0.0000" units"' and horizontal alignment is "right"
    When OfficeServer.tool_office_patch sets A1 to "a\nb", omitting mode and output_path
    Then changes_applied equals 1
    When the source is reopened with load_workbook
    Then B1 number_format remains '#,##0.0000" units"' and horizontal alignment remains "right"
    And A1 alignment.wrap_text is truthy

  @candidate-python-xlsx-dependency-preservation-4ce21ae4f6
  # Native: tests/test_xlsx_dependency_preservation.py::test_style_reindexing_is_refused
  Scenario: The style merge helper refuses changing an existing XF font reference
    Given SpreadsheetML styleSheet bytes with one cellXfs child xf whose fontId is "0" and count is "1"
    And rewritten bytes differ only by replacing fontId "0" with fontId "1"
    When merge_styles receives the original and rewritten bytes
    Then it raises ValueError with a message matching "registry rewrite"

  @candidate-python-xlsx-dependency-preservation-5587a2b78e
  # Native: tests/test_xlsx_dependency_preservation.py::test_calculation_chain_relationship_and_content_type_are_removed
  Scenario: An input edit removes the injected calculation chain and its metadata tokens
    Given ZIP members are read from shared_fixture("cross-sheet-cache.xlsx")
    And xl/_rels/workbook.xml.rels gains an internal calcChain relationship with Id "rIdCalcChain" and Target "calcChain.xml"
    And [Content_Types].xml gains an override for /xl/calcChain.xml with the SpreadsheetML calcChain content type
    And xl/calcChain.xml contains a SpreadsheetML calcChain with cell r="A1" and i="2"
    And all prepared entries are written as a temporary source.xlsx archive
    When OfficeServer.tool_office_patch sets Input!A1 to 10, omitting mode and output_path
    Then changes_applied equals 1
    When saved source ZIP members are read
    Then xl/calcChain.xml is absent
    And the bytes "calcChain" occur in neither xl/_rels/workbook.xml.rels nor [Content_Types].xml
