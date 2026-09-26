@captured @python_candidate
Feature: path variations native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-path-variations-74c3fa7ca4
  # Native: tests/test_path_variations.py::TestPptxAddTableOperations::test_add_table_with_many_rows
  Scenario: Native check: add table with many rows [TestPptxAddTableOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "many_rows.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Data Table"
    And path is prepared as temp dir under "many_rows.pptx"
    When pptx advanced tools.tool pptx add table using str representation of temp dir under "many_rows.pptx"; 1; ["A", "B", "C"]; [["R1A", "R1B", "R1C"], ["R2A", "R2B", "R2C"], ["R3A", "R3B", "R3C"], ["R4A", "R4B", "R4C"]]
    Then result has type dict

  @candidate-python-path-variations-2387d1f08f
  # Native: tests/test_path_variations.py::TestPptxAddTableOperations::test_add_table_single_column
  Scenario: Native check: add table single column [TestPptxAddTableOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "single_col.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "single_col.pptx"
    When pptx advanced tools.tool pptx add table using str representation of temp dir under "single_col.pptx"; 1; ["Item"]; [["First"], ["Second"], ["Third"]]
    Then result has type dict

  @candidate-python-path-variations-849c58a485
  # Native: tests/test_path_variations.py::TestWordInsertTableRowVariations::test_insert_row_specific_position
  Scenario: Native check: insert row specific position [TestWordInsertTableRowVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "insert_pos.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 4; cols 2
    And the result of table.cell with 0; 0 text is set to "Name"
    And the result of table.cell with 0; 1 text is set to "Value"
    And path is prepared as temp dir under "insert_pos.docx"
    When word advanced tools.tool word insert table row using str representation of temp dir under "insert_pos.docx"; "0"; {"Name": "New Item", "Value": "New Val"}
    Then result has type dict

  @candidate-python-path-variations-d5036f531b
  # Native: tests/test_path_variations.py::TestWordInsertTableRowVariations::test_insert_row_empty_dict
  Scenario: Native check: insert row empty dict [TestWordInsertTableRowVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "empty_row.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "empty_row.docx"
    When word advanced tools.tool word insert table row using str representation of temp dir under "empty_row.docx"; "0"; {}
    Then result has type dict

  @candidate-python-path-variations-fc9fde3bc0
  # Native: tests/test_path_variations.py::TestPptxReplaceTextVariations::test_replace_in_table_cells
  Scenario: Native check: replace in table cells [TestPptxReplaceTextVariations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "table_replace.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5
    And tbl is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 1.5 table
    And the result of tbl.cell with 0; 0 text is set to "<Customer>"
    And the result of tbl.cell with 0; 1 text is set to "Value"
    And the result of tbl.cell with 1; 0 text is set to "Contact <Customer>"
    And the result of tbl.cell with 1; 1 text is set to "Data"
    And path is prepared as temp dir under "table_replace.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "table_replace.pptx"; "<Customer>"; "Contoso"
    Then result has type dict

  @candidate-python-path-variations-231d1032f8
  # Native: tests/test_path_variations.py::TestWordCopyTemplateVariations::test_copy_to_existing_location
  Scenario: Native check: copy to existing location [TestWordCopyTemplateVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And doc2.save with temp dir under "output.docx"
    And doc is prepared as the result of Document with no arguments
    And template is prepared as temp dir under "template.docx"
    And doc2 is prepared as the result of Document with no arguments
    And output is prepared as temp dir under "output.docx"
    When word advanced tools.tool word copy template using str representation of temp dir under "template.docx"; str representation of temp dir under "output.docx"
    Then result has type dict

  @candidate-python-path-variations-88df39b233
  # Native: tests/test_path_variations.py::TestPptxClearBulletsVariations::test_clear_bullets_no_body
  Scenario: Native check: clear bullets no body [TestPptxClearBulletsVariations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_body.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title Only"
    And path is prepared as temp dir under "no_body.pptx"
    When pptx advanced tools.tool pptx clear bullets using str representation of temp dir under "no_body.pptx"; slide number 1
    Then result has type dict

  @candidate-python-path-variations-bcfd5d25f4
  # Native: tests/test_path_variations.py::TestWordListTablesVariations::test_list_tables_multiple
  Scenario: Native check: list tables multiple [TestWordListTablesVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "three_tables.docx"
    And doc is prepared as the result of Document with no arguments
    And t1 is prepared as the result of doc.add table with rows 2; cols 2
    And the result of t1.cell with 0; 0 text is set to "T1A"
    And the result of t1.cell with 0; 1 text is set to "T1B"
    And t2 is prepared as the result of doc.add table with rows 3; cols 4
    And the result of t2.cell with 0; 0 text is set to "T2A"
    And t3 is prepared as the result of doc.add table with rows 4; cols 2
    And the result of t3.cell with 0; 0 text is set to "T3A"
    And path is prepared as temp dir under "three_tables.docx"
    When word advanced tools.tool word list tables using str representation of temp dir under "three_tables.docx"
    Then result has type dict
    And the number of entries in result field "tables", defaulting to [] equals 3

  @candidate-python-path-variations-ca4e71f6e2
  # Native: tests/test_path_variations.py::TestPptxGetTableVariations::test_get_table_multiple_tables
  Scenario: Native check: get table multiple tables [TestPptxGetTableVariations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "two_tables.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And t1 is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 1; the result of PptxInches with 1; the result of PptxInches with 3; the result of PptxInches with 1
    And the result of t1.table.cell with 0; 0 text is set to "Table1"
    And t2 is prepared as the result of slide.shapes.add table with 3; 3; the result of PptxInches with 5; the result of PptxInches with 1; the result of PptxInches with 4; the result of PptxInches with 1.5
    And the result of t2.table.cell with 0; 0 text is set to "Table2"
    And path is prepared as temp dir under "two_tables.pptx"
    When pptx advanced tools.tool pptx get table using str representation of temp dir under "two_tables.pptx"; 1; table index 1
    Then result has type dict

  @candidate-python-path-variations-7dbbf3befb
  # Native: tests/test_path_variations.py::TestWordPatchTableRowVariations::test_patch_table_row_partial_columns
  Scenario: Native check: patch table row partial columns [TestWordPatchTableRowVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "partial_patch.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 4
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 0; 2 text is set to "C"
    And the result of table.cell with 0; 3 text is set to "D"
    And path is prepared as temp dir under "partial_patch.docx"
    When word advanced tools.tool word patch table row using str representation of temp dir under "partial_patch.docx"; "0"; 1; {"A": "Updated", "C": "Changed"}
    Then result has type dict

  @candidate-python-path-variations-517617e52d
  # Native: tests/test_path_variations.py::TestPptxAddCommentPositions::test_add_comment_edge_position
  Scenario: Native check: add comment edge position [TestPptxAddCommentPositions]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "edge_comment.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Edge Comment"
    And path is prepared as temp dir under "edge_comment.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of temp dir under "edge_comment.pptx"; 1; "Edge comment"; x inches 12.0; y inches 6.0
    Then result has type dict

  @candidate-python-path-variations-61881c5459
  # Native: tests/test_path_variations.py::TestWordSectionGuidanceVariations::test_get_section_guidance_no_guidance
  Scenario: Native check: get section guidance no guidance [TestWordSectionGuidanceVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_guidance.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_guidance.docx"
    When word advanced tools.tool word get section guidance using str representation of temp dir under "no_guidance.docx"; "Section"
    Then result has type dict

  @candidate-python-path-variations-cf65a28998
  # Native: tests/test_path_variations.py::TestPptxNotesAppend::test_append_to_existing_notes
  Scenario: Native check: append to existing notes [TestPptxNotesAppend]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "append_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Notes Test"
    And notes is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Original notes"
    And path is prepared as temp dir under "append_notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of temp dir under "append_notes.pptx"; 1; "\n\nAppended notes"; append true
    Then result has type dict

  @candidate-python-path-variations-1768b439bf
  # Native: tests/test_path_variations.py::TestWordCleanupSowVariations::test_cleanup_sow_no_placeholders
  Scenario: Native check: cleanup sow no placeholders [TestWordCleanupSowVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "clean_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "clean_sow.docx"
    When word advanced tools.tool word cleanup sow using str representation of temp dir under "clean_sow.docx"
    Then result has type dict

  @candidate-python-path-variations-449e576006
  # Native: tests/test_path_variations.py::TestPptxSlideReorderVariations::test_reorder_reverse_all
  Scenario: Native check: reorder reverse all [TestPptxSlideReorderVariations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "reverse.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "reverse.pptx"
    When pptx advanced tools.tool pptx reorder slides using str representation of temp dir under "reverse.pptx"; [5, 4, 3, 2, 1]
    Then result has type dict

  @candidate-python-path-variations-2c63034ce9
  # Native: tests/test_path_variations.py::TestWordCreateNewTableVariations::test_create_table_before_section
  Scenario: Native check: create table before section [TestWordCreateNewTableVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "before_section.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "before_section.docx"
    When word advanced tools.tool word create new table using str representation of temp dir under "before_section.docx"; ["X", "Y", "Z"]; [{"X": "1", "Y": "2", "Z": "3"}]; insert before section "Section B"
    Then result has type dict

  @candidate-python-path-variations-fd018208e2
  # Native: tests/test_path_variations.py::TestExcelMultiSheetOperations::test_from_markdown_multiple_tables
  Scenario: Native check: from markdown multiple tables [TestExcelMultiSheetOperations]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "| Header A | Header B |\n|----------|----------|\n| Data A1 | Data B1 |\n| Data A2 | Data B2 |\n\nSome text between tables\n\n| Col 1 | Col 2 | Col 3 |\n|-------|-------|-------|\n| X | Y | Z |\n"
    And path is prepared as temp dir under "multi_sheet.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "multi_sheet.xlsx"; "| Header A | Header B |\n|----------|----------|\n| Data A1 | Data B1 |\n| Data A2 | Data B2 |\n\nSome text between tables\n\n| Col 1 | Col 2 | Col 3 |\n|-------|-------|-------|\n| X | Y | Z |\n"
    Then result has type dict

  @candidate-python-path-variations-cc5d48182f
  # Native: tests/test_path_variations.py::TestExcelMultiSheetOperations::test_to_markdown_multi_sheet
  Scenario: Native check: to markdown multi sheet [TestExcelMultiSheetOperations]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "| A | B |\n |---|---|\n | 1 | 2 |\n\n | C | D |\n |---|---|\n | 3 | 4 |\n "
    And path is prepared as temp dir under "multi_md.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "multi_md.xlsx"; "| A | B |\n |---|---|\n | 1 | 2 |\n\n | C | D |\n |---|---|\n | 3 | 4 |\n "
    And excel tools.tool excel to markdown using str representation of temp dir under "multi_md.xlsx"
    Then result has type str

  @candidate-python-path-variations-f8b17fc943
  # Native: tests/test_path_variations.py::TestPptxLayoutAnalysis::test_analyze_layouts_standard_deck
  Scenario: Native check: analyze layouts standard deck [TestPptxLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "analyze_layouts.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "analyze_layouts.pptx"
    When pptx advanced tools.tool pptx analyze layouts using str representation of temp dir under "analyze_layouts.pptx"
    Then result has type dict

  @candidate-python-path-variations-75bb139ab2
  # Native: tests/test_path_variations.py::TestWordPatchPlaceholderCases::test_patch_placeholder_in_header
  Scenario: Native check: patch placeholder in header [TestWordPatchPlaceholderCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "header_ph.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "header_ph.docx"
    When word advanced tools.tool word patch placeholder using str representation of temp dir under "header_ph.docx"; "<Project Title>"; "Cloud Migration Project"
    Then result has type dict
