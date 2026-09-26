@captured @python_candidate
Feature: comprehensive paths native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-comprehensive-paths-7418e79b0c
  # Native: tests/test_comprehensive_paths.py::TestPptxAddTableOperations::test_add_table_with_many_rows
  Scenario: Native check: add table with many rows [TestPptxAddTableOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "many_rows.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Data Table"
    And path is prepared as temp dir under "many_rows.pptx"
    When tools.tool pptx add table using str representation of temp dir under "many_rows.pptx"; 1; ["A", "B", "C"]; [["R1A", "R1B", "R1C"], ["R2A", "R2B", "R2C"], ["R3A", "R3B", "R3C"], ["R4A", "R4B", "R4C"]]
    Then result has type dict

  @candidate-python-comprehensive-paths-3aad820238
  # Native: tests/test_comprehensive_paths.py::TestPptxAddTableOperations::test_add_table_single_column
  Scenario: Native check: add table single column [TestPptxAddTableOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "single_col.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "single_col.pptx"
    When tools.tool pptx add table using str representation of temp dir under "single_col.pptx"; 1; ["Item"]; [["First"], ["Second"], ["Third"]]
    Then result has type dict

  @candidate-python-comprehensive-paths-141cd1b49e
  # Native: tests/test_comprehensive_paths.py::TestWordInsertTableRowVariations::test_insert_row_specific_position
  Scenario: Native check: insert row specific position [TestWordInsertTableRowVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "insert_pos.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 4; cols 2
    And the result of table.cell with 0; 0 text is set to "Name"
    And the result of table.cell with 0; 1 text is set to "Value"
    And path is prepared as temp dir under "insert_pos.docx"
    When tools.tool word insert table row using str representation of temp dir under "insert_pos.docx"; "0"; {"Name": "New Item", "Value": "New Val"}
    Then result has type dict

  @candidate-python-comprehensive-paths-aa5940326e
  # Native: tests/test_comprehensive_paths.py::TestWordInsertTableRowVariations::test_insert_row_empty_dict
  Scenario: Native check: insert row empty dict [TestWordInsertTableRowVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "empty_row.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "empty_row.docx"
    When tools.tool word insert table row using str representation of temp dir under "empty_row.docx"; "0"; {}
    Then result has type dict

  @candidate-python-comprehensive-paths-ec31a8fbcd
  # Native: tests/test_comprehensive_paths.py::TestPptxReplaceTextVariations::test_replace_in_table_cells
  Scenario: Native check: replace in table cells [TestPptxReplaceTextVariations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "table_replace.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5
    And tbl is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5 table
    And the result of tbl.cell with 0; 0 text is set to "<Customer>"
    And the result of tbl.cell with 0; 1 text is set to "Value"
    And the result of tbl.cell with 1; 0 text is set to "Contact <Customer>"
    And the result of tbl.cell with 1; 1 text is set to "Data"
    And path is prepared as temp dir under "table_replace.pptx"
    When tools.tool pptx replace text using str representation of temp dir under "table_replace.pptx"; "<Customer>"; "Contoso"
    Then result has type dict

  @candidate-python-comprehensive-paths-b596d9d0d8
  # Native: tests/test_comprehensive_paths.py::TestWordCopyTemplateVariations::test_copy_to_existing_location
  Scenario: Native check: copy to existing location [TestWordCopyTemplateVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc2.save with temp dir under "output.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template is prepared as temp dir under "template.docx"
    And doc2 is prepared as the result of Document with no arguments
    And output is prepared as temp dir under "output.docx"
    When tools.tool word copy template using str representation of temp dir under "template.docx"; str representation of temp dir under "output.docx"
    Then result has type dict

  @candidate-python-comprehensive-paths-a93ba77d3d
  # Native: tests/test_comprehensive_paths.py::TestPptxClearBulletsVariations::test_clear_bullets_no_body
  Scenario: Native check: clear bullets no body [TestPptxClearBulletsVariations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "no_body.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title Only"
    And path is prepared as temp dir under "no_body.pptx"
    When tools.tool pptx clear bullets using str representation of temp dir under "no_body.pptx"; slide number 1
    Then result has type dict

  @candidate-python-comprehensive-paths-f80b00f905
  # Native: tests/test_comprehensive_paths.py::TestWordListTablesVariations::test_list_tables_multiple
  Scenario: Native check: list tables multiple [TestWordListTablesVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "three_tables.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And t1 is prepared as the result of doc.add table with rows 2; cols 2
    And the result of t1.cell with 0; 0 text is set to "T1A"
    And the result of t1.cell with 0; 1 text is set to "T1B"
    And t2 is prepared as the result of doc.add table with rows 3; cols 4
    And the result of t2.cell with 0; 0 text is set to "T2A"
    And t3 is prepared as the result of doc.add table with rows 4; cols 2
    And the result of t3.cell with 0; 0 text is set to "T3A"
    And path is prepared as temp dir under "three_tables.docx"
    When tools.tool word list tables using str representation of temp dir under "three_tables.docx"
    Then result has type dict
    And the number of entries in result field "tables", defaulting to [] equals 3

  @candidate-python-comprehensive-paths-8387d31c91
  # Native: tests/test_comprehensive_paths.py::TestPptxGetTableVariations::test_get_table_multiple_tables
  Scenario: Native check: get table multiple tables [TestPptxGetTableVariations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "two_tables.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And t1 is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 1; the result of PptxInches with 3; the result of PptxInches with 1
    And the result of t1.table.cell with 0; 0 text is set to "Table1"
    And t2 is prepared as the result of slide.shapes.add table with 3; 3; the result of PptxInches with 5; the result of PptxInches with 1; the result of PptxInches with 4; the result of PptxInches with 1.5
    And the result of t2.table.cell with 0; 0 text is set to "Table2"
    And path is prepared as temp dir under "two_tables.pptx"
    When tools.tool pptx get table using str representation of temp dir under "two_tables.pptx"; 1; table index 1
    Then result has type dict

  @candidate-python-comprehensive-paths-3a728e4d84
  # Native: tests/test_comprehensive_paths.py::TestWordPatchTableRowVariations::test_patch_table_row_partial_columns
  Scenario: Native check: patch table row partial columns [TestWordPatchTableRowVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "partial_patch.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 4
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 0; 2 text is set to "C"
    And the result of table.cell with 0; 3 text is set to "D"
    And path is prepared as temp dir under "partial_patch.docx"
    When tools.tool word patch table row using str representation of temp dir under "partial_patch.docx"; "0"; 1; {"A": "Updated", "C": "Changed"}
    Then result has type dict

  @candidate-python-comprehensive-paths-755195ae74
  # Native: tests/test_comprehensive_paths.py::TestPptxAddCommentPositions::test_add_comment_edge_position
  Scenario: Native check: add comment edge position [TestPptxAddCommentPositions]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "edge_comment.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Edge Comment"
    And path is prepared as temp dir under "edge_comment.pptx"
    When tools.tool pptx add comment using str representation of temp dir under "edge_comment.pptx"; 1; "Edge comment"; x inches 12.0; y inches 6.0
    Then result has type dict

  @candidate-python-comprehensive-paths-590d974a84
  # Native: tests/test_comprehensive_paths.py::TestWordSectionGuidanceVariations::test_get_section_guidance_no_guidance
  Scenario: Native check: get section guidance no guidance [TestWordSectionGuidanceVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "no_guidance.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_guidance.docx"
    When tools.tool word get section guidance using str representation of temp dir under "no_guidance.docx"; "Section"
    Then result has type dict

  @candidate-python-comprehensive-paths-fd6e526568
  # Native: tests/test_comprehensive_paths.py::TestPptxNotesAppend::test_append_to_existing_notes
  Scenario: Native check: append to existing notes [TestPptxNotesAppend]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "append_notes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Notes Test"
    And notes is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Original notes"
    And path is prepared as temp dir under "append_notes.pptx"
    When tools.tool pptx set notes using str representation of temp dir under "append_notes.pptx"; 1; "\n\nAppended notes"; append true
    Then result has type dict

  @candidate-python-comprehensive-paths-e1152e18c0
  # Native: tests/test_comprehensive_paths.py::TestWordCleanupSowVariations::test_cleanup_sow_no_placeholders
  Scenario: Native check: cleanup sow no placeholders [TestWordCleanupSowVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "clean_sow.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "clean_sow.docx"
    When tools.tool word cleanup sow using str representation of temp dir under "clean_sow.docx"
    Then result has type dict

  @candidate-python-comprehensive-paths-def6c7f9ea
  # Native: tests/test_comprehensive_paths.py::TestPptxSlideReorderVariations::test_reorder_reverse_all
  Scenario: Native check: reorder reverse all [TestPptxSlideReorderVariations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "reverse.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "reverse.pptx"
    When tools.tool pptx reorder slides using str representation of temp dir under "reverse.pptx"; [5, 4, 3, 2, 1]
    Then result has type dict

  @candidate-python-comprehensive-paths-72af322e4c
  # Native: tests/test_comprehensive_paths.py::TestWordCreateNewTableVariations::test_create_table_before_section
  Scenario: Native check: create table before section [TestWordCreateNewTableVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "before_section.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "before_section.docx"
    When tools.tool word create new table using str representation of temp dir under "before_section.docx"; ["X", "Y", "Z"]; [{"X": "1", "Y": "2", "Z": "3"}]; insert before section "Section B"
    Then result has type dict

  @candidate-python-comprehensive-paths-5f1831dad8
  # Native: tests/test_comprehensive_paths.py::TestExcelMultiSheetOperations::test_from_markdown_multiple_tables
  Scenario: Native check: from markdown multiple tables [TestExcelMultiSheetOperations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| Header A | Header B |\n|----------|----------|\n| Data A1 | Data B1 |\n| Data A2 | Data B2 |\n\nSome text between tables\n\n| Col 1 | Col 2 | Col 3 |\n|-------|-------|-------|\n| X | Y | Z |\n"
    And path is prepared as temp dir under "multi_sheet.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "multi_sheet.xlsx"; "| Header A | Header B |\n|----------|----------|\n| Data A1 | Data B1 |\n| Data A2 | Data B2 |\n\nSome text between tables\n\n| Col 1 | Col 2 | Col 3 |\n|-------|-------|-------|\n| X | Y | Z |\n"
    Then result has type dict

  @candidate-python-comprehensive-paths-9da15f1a23
  # Native: tests/test_comprehensive_paths.py::TestExcelMultiSheetOperations::test_to_markdown_multi_sheet
  Scenario: Native check: to markdown multi sheet [TestExcelMultiSheetOperations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| A | B |\n|---|---|\n| 1 | 2 |\n\n| C | D |\n|---|---|\n| 3 | 4 |\n"
    And path is prepared as temp dir under "multi_md.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "multi_md.xlsx"; "| A | B |\n|---|---|\n| 1 | 2 |\n\n| C | D |\n|---|---|\n| 3 | 4 |\n"
    And tools.tool excel to markdown using str representation of temp dir under "multi_md.xlsx"
    Then result has type str

  @candidate-python-comprehensive-paths-139e672403
  # Native: tests/test_comprehensive_paths.py::TestPptxLayoutAnalysis::test_analyze_layouts_standard_deck
  Scenario: Native check: analyze layouts standard deck [TestPptxLayoutAnalysis]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "analyze_layouts.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "analyze_layouts.pptx"
    When tools.tool pptx analyze layouts using str representation of temp dir under "analyze_layouts.pptx"
    Then result has type dict

  @candidate-python-comprehensive-paths-239c2b4873
  # Native: tests/test_comprehensive_paths.py::TestWordPatchPlaceholderCases::test_patch_placeholder_in_header
  Scenario: Native check: patch placeholder in header [TestWordPatchPlaceholderCases]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "header_ph.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "header_ph.docx"
    When tools.tool word patch placeholder using str representation of temp dir under "header_ph.docx"; "<Project Title>"; "Cloud Migration Project"
    Then result has type dict
