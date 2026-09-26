@captured @python_candidate
Feature: excel tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-excel-tools-fbb833c698
  # Native: tests/test_excel_tools.py::TestExcelExtract::test_extracts_data
  Scenario: Native check: extracts data [TestExcelExtract]
    Given Create an instance of ExcelTools.
    And Create a simple test Excel file.
    When excel tools.tool excel extract using str representation of sample xlsx
    Then "sheets" occurs in result
    And the number of entries in result at "sheets" is at least 1

  @candidate-python-excel-tools-face7f3edc
  # Native: tests/test_excel_tools.py::TestExcelExtract::test_extracts_headers
  Scenario: Native check: extracts headers [TestExcelExtract]
    Given Create an instance of ExcelTools.
    And Create a simple test Excel file.
    When excel tools.tool excel extract using str representation of sample xlsx
    Then when result field "sheets", defaulting to {}, "Name" occurs in list representation of result field "sheets", defaulting to {} values at 0 at 0 when list representation of result field "sheets", defaulting to {} values at 0 otherwise []

  @candidate-python-excel-tools-a59650d22a
  # Native: tests/test_excel_tools.py::TestExcelExtract::test_file_not_found
  Scenario: Native check: file not found [TestExcelExtract]
    Given Create an instance of ExcelTools.
    When excel tools.tool excel extract using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-tools-36756a962f
  # Native: tests/test_excel_tools.py::TestExcelToMarkdown::test_converts_to_markdown
  Scenario: Native check: converts to markdown [TestExcelToMarkdown]
    Given Create an instance of ExcelTools.
    And Create a simple test Excel file.
    When excel tools.tool excel to markdown using str representation of sample xlsx
    Then result has type str
    And "|" occurs in result
    And "Name" occurs in result

  @candidate-python-excel-tools-1a876d2f89
  # Native: tests/test_excel_tools.py::TestExcelToMarkdown::test_includes_all_columns
  Scenario: Native check: includes all columns [TestExcelToMarkdown]
    Given Create an instance of ExcelTools.
    And Create a simple test Excel file.
    When excel tools.tool excel to markdown using str representation of sample xlsx
    Then "Name" occurs in result
    And "Value" occurs in result
    And "Status" occurs in result

  @candidate-python-excel-tools-2179db4b91
  # Native: tests/test_excel_tools.py::TestExcelToMarkdown::test_file_not_found
  Scenario: Native check: file not found [TestExcelToMarkdown]
    Given Create an instance of ExcelTools.
    When excel tools.tool excel to markdown using "/nonexistent.xlsx"
    Then "Error" occurs in result or "not found" occurs in result in lowercase

  @candidate-python-excel-tools-68a8f3d106
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_creates_excel
  Scenario: Native check: creates excel [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n| Name | Value | Status |\n|------|-------|--------|\n| A | 100 | Active |\n| B | 200 | Done |\n"
    And output is prepared as temp dir under "created.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "created.xlsx"; "\n| Name | Value | Status |\n|------|-------|--------|\n| A | 100 | Active |\n| B | 200 | Done |\n"
    Then result field "success" is true
    And temp dir under "created.xlsx" exists is non-empty or true

  @candidate-python-excel-tools-2c14349318
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_creates_excel_from_markdown_file
  Scenario: Native check: creates excel from markdown file [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md file.write text with "\n| Name | Value |\n|------|-------|\n| A | 100 |\n"
    And md file is prepared as temp dir under "input.md"
    And output is prepared as temp dir under "from_file.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "from_file.xlsx"; markdown file str representation of temp dir under "input.md"
    Then result field "success" is true
    And temp dir under "from_file.xlsx" exists is non-empty or true

  @candidate-python-excel-tools-50c9d3e299
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_preserves_headers
  Scenario: Native check: preserves headers [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    And output is prepared as temp dir under "headers.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "headers.xlsx"; "\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    Then wb active at "A1" value equals "Col1"
    And wb active at "B1" value equals "Col2"

  @candidate-python-excel-tools-db67826504
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_multiple_tables
  Scenario: Native check: multiple tables [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n| Table1 | Data |\n|--------|------|\n| A | 1 |\n\n| Table2 | Info |\n|--------|------|\n| X | Y |\n"
    And output is prepared as temp dir under "multi.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "multi.xlsx"; "\n| Table1 | Data |\n|--------|------|\n| A | 1 |\n\n| Table2 | Info |\n|--------|------|\n| X | Y |\n"
    Then result field "success" is true

  @candidate-python-excel-tools-caa5fee62d
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_sheet_names_from_headings
  Scenario: Native check: sheet names from headings [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n## First Section\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n\n## Second Section\n\n| Col1 | Col2 |\n|------|------|\n| C | D |\n"
    And output is prepared as temp dir under "headings.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "headings.xlsx"; "\n## First Section\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n\n## Second Section\n\n| Col1 | Col2 |\n|------|------|\n| C | D |\n"
    Then the result of load workbook with temp dir under "headings.xlsx" sheetnames at 0 equals "First Section"
    And the result of load workbook with temp dir under "headings.xlsx" sheetnames at 1 equals "Second Section"

  @candidate-python-excel-tools-77cd16bf4e
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_formula_cells
  Scenario: Native check: formula cells [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n| Value | Calc |\n|-------|------|\n| 10 | =A2*2 |\n"
    And output is prepared as temp dir under "formula.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "formula.xlsx"; "\n| Value | Calc |\n|-------|------|\n| 10 | =A2*2 |\n"
    Then the result of load workbook with temp dir under "formula.xlsx"; data only false active at "B2" value equals "=A2*2"

  @candidate-python-excel-tools-3c94f331c7
  # Native: tests/test_excel_tools.py::TestExcelFromMarkdown::test_sheet_name_parameter
  Scenario: Native check: sheet name parameter [TestExcelFromMarkdown]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "\n| Col1 | Col2 |\n|------|------|\n| A | B |\n\n| Col1 | Col2 |\n|------|------|\n| C | D |\n"
    And output is prepared as temp dir under "named.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "named.xlsx"; "\n| Col1 | Col2 |\n|------|------|\n| A | B |\n\n| Col1 | Col2 |\n|------|------|\n| C | D |\n"; sheet name "Primary"
    Then the result of load workbook with temp dir under "named.xlsx" sheetnames at 0 equals "Primary"

  @candidate-python-excel-tools-fb5db0083e
  # Native: tests/test_excel_tools.py::TestListSupportedFormats::test_tool_exists
  Scenario: Native check: tool exists [TestListSupportedFormats]
    Given Use the excel_tools fixture instance.
    When Evaluate hasattr(excel_tools, 'tool_excel_extract').
    And Evaluate hasattr(excel_tools, 'tool_excel_to_markdown').
    And Evaluate hasattr(excel_tools, 'tool_excel_from_markdown').
    Then excel_tools exposes tool_excel_extract.
    And excel_tools exposes tool_excel_to_markdown.
    And excel_tools exposes tool_excel_from_markdown.
