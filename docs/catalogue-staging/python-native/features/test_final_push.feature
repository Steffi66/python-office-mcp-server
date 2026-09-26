@captured @python_candidate
Feature: final push native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-final-push-93e23c2357
  # Native: tests/test_final_push.py::TestExcelExtendedMethods::test_excel_extract_multi_sheet
  Scenario: Native check: excel extract multi sheet [TestExcelExtendedMethods]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| A | B |\n|---|---|\n| 1 | 2 |\n\n| C | D |\n|---|---|\n| 3 | 4 |\n"
    And path is prepared as temp dir under "multi.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "multi.xlsx"; "| A | B |\n|---|---|\n| 1 | 2 |\n\n| C | D |\n|---|---|\n| 3 | 4 |\n"
    And tools.tool excel extract using str representation of temp dir under "multi.xlsx"
    Then result has type dict

  @candidate-python-final-push-0f254b2118
  # Native: tests/test_final_push.py::TestExcelExtendedMethods::test_excel_to_markdown
  Scenario: Native check: excel to markdown [TestExcelExtendedMethods]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| Name | Value |\n|------|-------|\n| Test | 100 |\n"
    And path is prepared as temp dir under "to_md.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "to_md.xlsx"; "| Name | Value |\n|------|-------|\n| Test | 100 |\n"
    And tools.tool excel to markdown using str representation of temp dir under "to_md.xlsx"
    Then "Name" occurs in result
    And "Value" occurs in result

  @candidate-python-final-push-ebf87c661e
  # Native: tests/test_final_push.py::TestWordExtendedOps::test_word_list_sections_with_subsections
  Scenario: Native check: word list sections with subsections [TestWordExtendedOps]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "subsections.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "subsections.docx"
    When tools.tool word list sections using str representation of temp dir under "subsections.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-final-push-25110f35c8
  # Native: tests/test_final_push.py::TestWordExtendedOps::test_word_patch_section_append
  Scenario: Native check: word patch section append [TestWordExtendedOps]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "append_section.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "append_section.docx"
    When tools.tool word patch section using str representation of temp dir under "append_section.docx"; "Section"; "Appended content"
    Then result has type dict

  @candidate-python-final-push-a0fef5e008
  # Native: tests/test_final_push.py::TestWordExtendedOps::test_word_get_table_with_headers
  Scenario: Native check: word get table with headers [TestWordExtendedOps]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "headers_table.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And headers is prepared as ["Header A", "Header B", "Header C"]
    And path is prepared as temp dir under "headers_table.docx"
    When tools.tool word get table using str representation of temp dir under "headers_table.docx"; "0"
    Then result has type dict

  @candidate-python-final-push-096bb9db36
  # Native: tests/test_final_push.py::TestPptxExtendedOps::test_pptx_list_masters
  Scenario: Native check: pptx list masters [TestPptxExtendedOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "masters.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "masters.pptx"
    When tools.tool pptx list masters using str representation of temp dir under "masters.pptx"
    Then result has type dict
    And "default_layouts" occurs in result

  @candidate-python-final-push-fbb556cf0a
  # Native: tests/test_final_push.py::TestPptxExtendedOps::test_pptx_reorder_slides
  Scenario: Native check: pptx reorder slides [TestPptxExtendedOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "reorder.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "reorder.pptx"
    And output is prepared as temp dir under "reordered.pptx"
    When tools.tool pptx reorder slides using str representation of temp dir under "reorder.pptx"; [1, 4, 2, 3]; output path str representation of temp dir under "reordered.pptx"
    Then result has type dict

  @candidate-python-final-push-6d59958042
  # Native: tests/test_final_push.py::TestPptxExtendedOps::test_pptx_log_changes
  Scenario: Native check: pptx log changes [TestPptxExtendedOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "changes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "changes.pptx"
    When tools.tool pptx log changes using str representation of temp dir under "changes.pptx"; [{"slide": 1, "action": "Updated title", "detail": "Changed from draft to final"}, {"slide": 1, "action": "Added bullet", "detail": "New point about benefits"}]
    Then result has type dict

  @candidate-python-final-push-f860edb13b
  # Native: tests/test_final_push.py::TestWordComplexPatching::test_replace_global_variables
  Scenario: Native check: replace global variables [TestWordComplexPatching]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "globals.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "globals.docx"
    When tools.tool word replace global variables using str representation of temp dir under "globals.docx"; {"<Customer Name>": "Contoso", "<Project Name>": "Migration", "<Provider Name>": "Microsoft"}
    Then result has type dict

  @candidate-python-final-push-31a5059f57
  # Native: tests/test_final_push.py::TestPptxComplexOps::test_pptx_add_table
  Scenario: Native check: pptx add table [TestPptxComplexOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "for_table.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Data"
    And path is prepared as temp dir under "for_table.pptx"
    When tools.tool pptx add table using str representation of temp dir under "for_table.pptx"; 1; ["Name", "Role", "Hours"]; [["Alice", "Dev", "40"], ["Bob", "QA", "30"]]
    Then result has type dict

  @candidate-python-final-push-7d09ce5a23
  # Native: tests/test_final_push.py::TestPptxComplexOps::test_pptx_update_table_cell
  Scenario: Native check: pptx update table cell [TestPptxComplexOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "update_cell.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table is prepared as the result of slide.shapes.add table with 3; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 2
    And tbl is prepared as the result of slide.shapes.add table with 3; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 2 table
    And the result of tbl.cell with 0; 0 text is set to "A"
    And the result of tbl.cell with 0; 1 text is set to "B"
    And the result of tbl.cell with 1; 0 text is set to "C"
    And the result of tbl.cell with 1; 1 text is set to "D"
    And path is prepared as temp dir under "update_cell.pptx"
    When tools.tool pptx patch table cell using str representation of temp dir under "update_cell.pptx"; slide number 1; row index 1; col index 1; new text "Updated"
    Then result has type dict

  @candidate-python-final-push-671fac91aa
  # Native: tests/test_final_push.py::TestPptxComplexOps::test_pptx_patch_table_cell_string
  Scenario: Native check: pptx patch table cell string [TestPptxComplexOps]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "patch_cell.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5
    And tbl is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5 table
    And the result of tbl.cell with 0; 0 text is set to "Col1"
    And the result of tbl.cell with 0; 1 text is set to "Col2"
    And the result of tbl.cell with 1; 0 text is set to "Row1"
    And the result of tbl.cell with 1; 1 text is set to "Data1"
    And path is prepared as temp dir under "patch_cell.pptx"
    When tools.tool pptx patch table cell using str representation of temp dir under "patch_cell.pptx"; slide number 1; row index 1; col index 0; new text "UpdatedRow1"
    Then result has type dict

  @candidate-python-final-push-4ae8394556
  # Native: tests/test_final_push.py::TestWordTableOperations::test_insert_table_row_at_end
  Scenario: Native check: insert table row at end [TestWordTableOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "insert_end.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 2
    And the result of table.cell with 0; 0 text is set to "Name"
    And the result of table.cell with 0; 1 text is set to "Value"
    And path is prepared as temp dir under "insert_end.docx"
    When tools.tool word insert table row using str representation of temp dir under "insert_end.docx"; "0"; {"Name": "NewItem", "Value": "NewVal"}
    Then result has type dict

  @candidate-python-final-push-1b8f1d08f3
  # Native: tests/test_final_push.py::TestPptxFromMarkdownVariations::test_with_code_blocks
  Scenario: Native check: with code blocks [TestPptxFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Code Examples\n\n## Python Code\n\n```python\ndef hello():\n print(\"Hello\")\n```\n\n## Usage\n- Import the module\n- Call hello()\n"
    And path is prepared as temp dir under "code.pptx"
    When tools.tool pptx from markdown using str representation of temp dir under "code.pptx"; "# Code Examples\n\n## Python Code\n\n```python\ndef hello():\n print(\"Hello\")\n```\n\n## Usage\n- Import the module\n- Call hello()\n"
    Then the result of Path with temp dir under "code.pptx" exists is non-empty or true

  @candidate-python-final-push-84df8d1b9e
  # Native: tests/test_final_push.py::TestPptxFromMarkdownVariations::test_with_emphasis
  Scenario: Native check: with emphasis [TestPptxFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Emphasis Test\n\n## Points\n- **Bold text** is important\n- *Italic text* adds emphasis\n- ***Both*** for extra effect\n"
    And path is prepared as temp dir under "emphasis.pptx"
    When tools.tool pptx from markdown using str representation of temp dir under "emphasis.pptx"; "# Emphasis Test\n\n## Points\n- **Bold text** is important\n- *Italic text* adds emphasis\n- ***Both*** for extra effect\n"
    Then the result of Path with temp dir under "emphasis.pptx" exists is non-empty or true

  @candidate-python-final-push-38fdd9b34e
  # Native: tests/test_final_push.py::TestWordFromMarkdownVariations::test_with_links
  Scenario: Native check: with links [TestWordFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of WordTools with no arguments
    And md is prepared as "# Document with Links\n\nVisit [our website](https://example.com) for more info.\n\n## Resources\n- [Resource 1](https://example.com/1)\n- [Resource 2](https://example.com/2)\n"
    And path is prepared as temp dir under "links.docx"
    When tools.tool word from markdown using str representation of temp dir under "links.docx"; "# Document with Links\n\nVisit [our website](https://example.com) for more info.\n\n## Resources\n- [Resource 1](https://example.com/1)\n- [Resource 2](https://example.com/2)\n"
    Then the result of Path with temp dir under "links.docx" exists is non-empty or true

  @candidate-python-final-push-e76141e5fe
  # Native: tests/test_final_push.py::TestPptxSlideManipulation::test_delete_middle_slide
  Scenario: Native check: delete middle slide [TestPptxSlideManipulation]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "delete_middle.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "delete_middle.pptx"
    When tools.tool pptx delete slide using str representation of temp dir under "delete_middle.pptx"; 2
    Then result has type dict

  @candidate-python-final-push-e69af6d7a7
  # Native: tests/test_final_push.py::TestPptxSlideManipulation::test_add_slide_at_start
  Scenario: Native check: add slide at start [TestPptxSlideManipulation]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "add_start.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Original First"
    And path is prepared as temp dir under "add_start.pptx"
    When tools.tool pptx add slide using str representation of temp dir under "add_start.pptx"; position "start"; title "New First"
    Then result has type dict

  @candidate-python-final-push-e58b3d7527
  # Native: tests/test_final_push.py::TestWordAuditPaths::test_audit_sow_with_placeholders
  Scenario: Native check: audit sow with placeholders [TestWordAuditPaths]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_placeholders.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sow_placeholders.docx"
    When tools.tool word audit sow using str representation of temp dir under "sow_placeholders.docx"
    Then result has type dict

  @candidate-python-final-push-79cf22b5cf
  # Native: tests/test_final_push.py::TestPptxBulletOperations::test_add_multiple_bullets
  Scenario: Native check: add multiple bullets [TestPptxBulletOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "multi_bullets.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Bullet Test"
    And path is prepared as temp dir under "multi_bullets.pptx"
    When tools.tool pptx add bullet using str representation of temp dir under "multi_bullets.pptx"; 1; "First point"; level 0
    And tools.tool pptx add bullet using str representation of temp dir under "multi_bullets.pptx"; 1; "Sub-point"; level 1
    And tools.tool pptx add bullet using str representation of temp dir under "multi_bullets.pptx"; 1; "Second point"; level 0
    Then result has type dict

  @candidate-python-final-push-0f6aec1e34
  # Native: tests/test_final_push.py::TestPptxBulletOperations::test_add_bullet_with_bold_label
  Scenario: Native check: add bullet with bold label [TestPptxBulletOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "bold_label.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Key Points"
    And path is prepared as temp dir under "bold_label.pptx"
    When tools.tool pptx add bullet using str representation of temp dir under "bold_label.pptx"; 1; "18 months to complete"; bold label "Duration"
    Then result has type dict

  @candidate-python-final-push-10039a362f
  # Native: tests/test_final_push.py::TestSupportFunctions::test_word_extract
  Scenario: Native check: word extract [TestSupportFunctions]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "extract.docx"
    And tools is prepared as the result of WordTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "extract.docx"
    When tools.tool word extract using str representation of temp dir under "extract.docx"
    Then result has type dict
