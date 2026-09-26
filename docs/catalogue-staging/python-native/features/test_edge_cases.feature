@captured @python_candidate
Feature: edge cases native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-edge-cases-ba6eb17a57
  # Native: tests/test_edge_cases.py::TestExcelEdgeCases::test_extract_with_formulas
  Scenario: Native check: extract with formulas [TestExcelEdgeCases]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "formulas.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to 10
    And the result of Workbook with no arguments active at "A2" is set to 20
    And the result of Workbook with no arguments active at "A3" is set to "=SUM(A1:A2)"
    And path is prepared as temp dir under "formulas.xlsx"
    When excel tools.tool excel extract using str representation of temp dir under "formulas.xlsx"
    Then result has type dict

  @candidate-python-edge-cases-8c87909b87
  # Native: tests/test_edge_cases.py::TestExcelEdgeCases::test_extract_with_empty_cells
  Scenario: Native check: extract with empty cells [TestExcelEdgeCases]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "sparse.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "Start"
    And the result of Workbook with no arguments active at "C3" is set to "End"
    And path is prepared as temp dir under "sparse.xlsx"
    When excel tools.tool excel extract using str representation of temp dir under "sparse.xlsx"
    Then result has type dict

  @candidate-python-edge-cases-6b00c1102b
  # Native: tests/test_edge_cases.py::TestExcelEdgeCases::test_from_markdown_single_table
  Scenario: Native check: from markdown single table [TestExcelEdgeCases]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "| Name | Age |\n|------|-----|\n| Alice | 30 |\n| Bob | 25 |\n"
    And path is prepared as temp dir under "single.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "single.xlsx"; "| Name | Age |\n|------|-----|\n| Alice | 30 |\n| Bob | 25 |\n"
    Then the result of Path with temp dir under "single.xlsx" exists is non-empty or true

  @candidate-python-edge-cases-d644b4a321
  # Native: tests/test_edge_cases.py::TestPresentationEdgeCases::test_list_masters_empty_presentation
  Scenario: Native check: list masters empty presentation [TestPresentationEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And Create an empty PowerPoint presentation.
    When pptx advanced tools.tool pptx list masters using str representation of empty pptx
    Then "default_layouts" occurs in result or "layouts" occurs in result

  @candidate-python-edge-cases-9ff6747f2f
  # Native: tests/test_edge_cases.py::TestPresentationEdgeCases::test_list_shapes_blank_slide
  Scenario: Native check: list shapes blank slide [TestPresentationEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "blank.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "blank.pptx"
    When pptx advanced tools.tool pptx list shapes using str representation of temp dir under "blank.pptx"; slide number 1
    Then "shapes" occurs in result

  @candidate-python-edge-cases-347f4a1216
  # Native: tests/test_edge_cases.py::TestPresentationEdgeCases::test_patch_shape_nonexistent
  Scenario: Native check: patch shape nonexistent [TestPresentationEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_shapes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "no_shapes.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of temp dir under "no_shapes.pptx"; slide number 1; shape identifier "nonexistent"; new text "test"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase

  @candidate-python-edge-cases-b5580064dc
  # Native: tests/test_edge_cases.py::TestWordEdgeCases::test_list_sections_empty_doc
  Scenario: Native check: list sections empty doc [TestWordEdgeCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_headings.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_headings.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "no_headings.docx"
    Then result has type dict

  @candidate-python-edge-cases-8c49e4c481
  # Native: tests/test_edge_cases.py::TestWordEdgeCases::test_patch_section_invalid
  Scenario: Native check: patch section invalid [TestWordEdgeCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    When word advanced tools.tool word patch section using str representation of temp dir under "sections.docx"; "Nonexistent Section"; "New content"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase

  @candidate-python-edge-cases-349da7b2d8
  # Native: tests/test_edge_cases.py::TestWordEdgeCases::test_fix_split_placeholders
  Scenario: Native check: fix split placeholders [TestWordEdgeCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "split.docx"
    And doc is prepared as the result of Document with no arguments
    And p is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "split.docx"
    And output is prepared as temp dir under "fixed.docx"
    When word advanced tools.tool word fix split placeholders using str representation of temp dir under "split.docx"; replacements {"<Customer Name>": "Contoso"}; output path str representation of temp dir under "fixed.docx"
    Then result has type dict

  @candidate-python-edge-cases-0443a50d3c
  # Native: tests/test_edge_cases.py::TestOutputPathHandling::test_word_copy_template
  Scenario: Native check: word copy template [TestOutputPathHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc is prepared as the result of Document with no arguments
    And source is prepared as temp dir under "template.docx"
    And dest is prepared as temp dir under "copy.docx"
    When word advanced tools.tool word copy template using str representation of temp dir under "template.docx"; str representation of temp dir under "copy.docx"
    Then temp dir under "copy.docx" exists or result field "success" is true

  @candidate-python-edge-cases-695d01f44c
  # Native: tests/test_edge_cases.py::TestOutputPathHandling::test_add_slide_with_title
  Scenario: Native check: add slide with title [TestOutputPathHandling]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "add_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "add_slide.pptx"
    And output is prepared as temp dir under "added.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of temp dir under "add_slide.pptx"; layout index 1; title "New Slide Title"; output path str representation of temp dir under "added.pptx"
    Then result field "success" is true or result field "slide_number" is not null

  @candidate-python-edge-cases-950bea0088
  # Native: tests/test_edge_cases.py::TestMarkdownConversions::test_excel_to_markdown
  Scenario: Native check: excel to markdown [TestMarkdownConversions]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "convert.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Data"
    And the result of Workbook with no arguments active at "A1" is set to "Header1"
    And the result of Workbook with no arguments active at "B1" is set to "Header2"
    And the result of Workbook with no arguments active at "A2" is set to "Value1"
    And the result of Workbook with no arguments active at "B2" is set to "Value2"
    And path is prepared as temp dir under "convert.xlsx"
    When excel tools.tool excel to markdown using str representation of temp dir under "convert.xlsx"
    Then "Header1" occurs in result
    And "|" occurs in result

  @candidate-python-edge-cases-b96c46e36d
  # Native: tests/test_edge_cases.py::TestMarkdownConversions::test_word_to_markdown
  Scenario: Native check: word to markdown [TestMarkdownConversions]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "convert.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "convert.docx"
    When word tools.tool word to markdown using str representation of temp dir under "convert.docx"
    Then "Main Title" occurs in result
    And "#" occurs in result

  @candidate-python-edge-cases-82349ea4c6
  # Native: tests/test_edge_cases.py::TestTableInsertion::test_insert_table_row
  Scenario: Native check: insert table row [TestTableInsertion]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 0; 2 text is set to "C"
    And the result of table.cell with 1; 0 text is set to "1"
    And the result of table.cell with 1; 1 text is set to "2"
    And the result of table.cell with 1; 2 text is set to "3"
    And path is prepared as temp dir under "table.docx"
    And output is prepared as temp dir under "with_row.docx"
    When word advanced tools.tool word insert table row using str representation of temp dir under "table.docx"; "0"; {"A": "X", "B": "Y", "C": "Z"}; output path str representation of temp dir under "with_row.docx"
    Then result field "success" is true or temp dir under "with_row.docx" exists
