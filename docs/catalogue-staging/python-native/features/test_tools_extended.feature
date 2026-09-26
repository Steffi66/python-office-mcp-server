@captured @python_candidate
Feature: tools extended native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-tools-extended-1017a7995e
  # Native: tests/test_tools_extended.py::TestExcelToolsMoreCoverage::test_extract_empty_workbook
  Scenario: Native check: extract empty workbook [TestExcelToolsMoreCoverage]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "empty.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And path is prepared as temp dir under "empty.xlsx"
    When excel tools.tool excel extract using str representation of temp dir under "empty.xlsx"
    Then result has type dict

  @candidate-python-tools-extended-25af77e5d0
  # Native: tests/test_tools_extended.py::TestExcelToolsMoreCoverage::test_extract_multiple_sheets
  Scenario: Native check: extract multiple sheets [TestExcelToolsMoreCoverage]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "multi.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws1 is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Sheet1"
    And the result of Workbook with no arguments active at "A1" is set to "Data 1"
    And ws2 is prepared as the result of wb.create sheet with "Sheet2"
    And the result of wb.create sheet with "Sheet2" at "A1" is set to "Data 2"
    And path is prepared as temp dir under "multi.xlsx"
    When excel tools.tool excel extract using str representation of temp dir under "multi.xlsx"
    Then the number of entries in result field "sheets", defaulting to [] is at least 2

  @candidate-python-tools-extended-a62a4f8bc5
  # Native: tests/test_tools_extended.py::TestExcelToolsMoreCoverage::test_to_markdown_with_numbers
  Scenario: Native check: to markdown with numbers [TestExcelToolsMoreCoverage]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "numbers.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "Amount"
    And the result of Workbook with no arguments active at "B1" is set to "Percentage"
    And the result of Workbook with no arguments active at "A2" is set to 1000.5
    And the result of Workbook with no arguments active at "B2" is set to 0.15
    And path is prepared as temp dir under "numbers.xlsx"
    When excel tools.tool excel to markdown using str representation of temp dir under "numbers.xlsx"
    Then "Amount" occurs in result
    And "1000" occurs in result or "1,000" occurs in result

  @candidate-python-tools-extended-78542a36c5
  # Native: tests/test_tools_extended.py::TestWordToolsMoreCoverage::test_extract_with_lists
  Scenario: Native check: extract with lists [TestWordToolsMoreCoverage]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "lists.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "lists.docx"
    When word tools.tool word extract using str representation of temp dir under "lists.docx"
    Then "Item A" occurs in str representation of result

  @candidate-python-tools-extended-fa8ee21778
  # Native: tests/test_tools_extended.py::TestWordToolsMoreCoverage::test_to_markdown_with_headers
  Scenario: Native check: to markdown with headers [TestWordToolsMoreCoverage]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "headers.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "headers.docx"
    When word tools.tool word to markdown using str representation of temp dir under "headers.docx"
    Then "# " occurs in result or "## " occurs in result

  @candidate-python-tools-extended-91fbfdce79
  # Native: tests/test_tools_extended.py::TestPowerPointToolsMoreCoverage::test_extract_with_shapes
  Scenario: Native check: extract with shapes [TestPowerPointToolsMoreCoverage]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "shapes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Shape Test"
    And txBox is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1
    And tf is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1 text frame
    And the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1 text frame text is set to "Textbox content"
    And path is prepared as temp dir under "shapes.pptx"
    When pptx tools.tool pptx extract using str representation of temp dir under "shapes.pptx"
    Then "Shape Test" occurs in str representation of result or "Textbox" occurs in str representation of result

  @candidate-python-tools-extended-dd25a12e05
  # Native: tests/test_tools_extended.py::TestPowerPointToolsMoreCoverage::test_from_markdown_complex
  Scenario: Native check: from markdown complex [TestPowerPointToolsMoreCoverage]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Main Presentation\n\n## First Section\n\n- **Point 1:** Detail about first point\n- **Point 2:** Detail about second point\n- Sub-point here\n\n---\n\n## Second Section\n\n| Col A | Col B | Col C |\n|-------|-------|-------|\n| 1 | 2 | 3 |\n| 4 | 5 | 6 |\n\n---\n\n## Summary\n\nFinal thoughts and conclusions.\n"
    And path is prepared as temp dir under "complex.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "complex.pptx"; "# Main Presentation\n\n## First Section\n\n- **Point 1:** Detail about first point\n- **Point 2:** Detail about second point\n- Sub-point here\n\n---\n\n## Second Section\n\n| Col A | Col B | Col C |\n|-------|-------|-------|\n| 1 | 2 | 3 |\n| 4 | 5 | 6 |\n\n---\n\n## Summary\n\nFinal thoughts and conclusions.\n"
    Then the result of Path with temp dir under "complex.pptx" exists is non-empty or true
    And result field "slides", defaulting to 0 is at least 3 or result field "slide_count", defaulting to 0 is at least 3
