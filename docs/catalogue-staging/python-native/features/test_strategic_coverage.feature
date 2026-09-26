@captured @python_candidate
Feature: strategic coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-strategic-coverage-a03279abe0
  # Native: tests/test_strategic_coverage.py::TestModuleLevelErrors::test_word_tools_instance
  Scenario: Native check: word tools instance [TestModuleLevelErrors]
    Given tools is prepared as the result of WordTools with no arguments
    When the word tools instance behavior is exercised with its prepared inputs
    Then the result of WordTools with no arguments is not null

  @candidate-python-strategic-coverage-80e1ab6456
  # Native: tests/test_strategic_coverage.py::TestModuleLevelErrors::test_pptx_tools_instance
  Scenario: Native check: pptx tools instance [TestModuleLevelErrors]
    Given tools is prepared as the result of PowerPointTools with no arguments
    When the pptx tools instance behavior is exercised with its prepared inputs
    Then the result of PowerPointTools with no arguments is not null

  @candidate-python-strategic-coverage-3563aa0c95
  # Native: tests/test_strategic_coverage.py::TestModuleLevelErrors::test_excel_tools_instance
  Scenario: Native check: excel tools instance [TestModuleLevelErrors]
    Given tools is prepared as the result of ExcelTools with no arguments
    When the excel tools instance behavior is exercised with its prepared inputs
    Then the result of ExcelTools with no arguments is not null

  @candidate-python-strategic-coverage-5857fa9cfd
  # Native: tests/test_strategic_coverage.py::TestModuleLevelErrors::test_word_advanced_tools_instance
  Scenario: Native check: word advanced tools instance [TestModuleLevelErrors]
    Given tools is prepared as the result of WordAdvancedTools with no arguments
    When the word advanced tools instance behavior is exercised with its prepared inputs
    Then the result of WordAdvancedTools with no arguments is not null

  @candidate-python-strategic-coverage-d61f293345
  # Native: tests/test_strategic_coverage.py::TestModuleLevelErrors::test_pptx_advanced_tools_instance
  Scenario: Native check: pptx advanced tools instance [TestModuleLevelErrors]
    Given tools is prepared as the result of PresentationAdvancedTools with no arguments
    When the pptx advanced tools instance behavior is exercised with its prepared inputs
    Then the result of PresentationAdvancedTools with no arguments is not null

  @candidate-python-strategic-coverage-418166d099
  # Native: tests/test_strategic_coverage.py::TestWordToMarkdownEdgeCases::test_to_markdown_with_complex_formatting
  Scenario: Native check: to markdown with complex formatting [TestWordToMarkdownEdgeCases]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "complex_format.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And bold run is prepared as the result of para.add run with "bold"
    And the result of para.add run with "bold" bold is set to true
    And italic run is prepared as the result of para.add run with "italic"
    And the result of para.add run with "italic" italic is set to true
    And path is prepared as temp dir under "complex_format.docx"
    And tools is prepared as the result of WordTools with no arguments
    When tools.tool word to markdown using str representation of temp dir under "complex_format.docx"
    Then "Title" occurs in result

  @candidate-python-strategic-coverage-2485e7c863
  # Native: tests/test_strategic_coverage.py::TestWordToMarkdownEdgeCases::test_to_markdown_with_table
  Scenario: Native check: to markdown with table [TestWordToMarkdownEdgeCases]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "with_table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 2
    And the result of table.cell with 0; 0 text is set to "Header A"
    And the result of table.cell with 0; 1 text is set to "Header B"
    And the result of table.cell with 1; 0 text is set to "Row 1 A"
    And the result of table.cell with 1; 1 text is set to "Row 1 B"
    And the result of table.cell with 2; 0 text is set to "Row 2 A"
    And the result of table.cell with 2; 1 text is set to "Row 2 B"
    And path is prepared as temp dir under "with_table.docx"
    And tools is prepared as the result of WordTools with no arguments
    When tools.tool word to markdown using str representation of temp dir under "with_table.docx"
    Then "Header A" occurs in result

  @candidate-python-strategic-coverage-7f3219a835
  # Native: tests/test_strategic_coverage.py::TestPptxToMarkdownEdgeCases::test_to_markdown_with_notes
  Scenario: Native check: to markdown with notes [TestPptxToMarkdownEdgeCases]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "with_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title Slide"
    And notes is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Speaker notes here"
    And path is prepared as temp dir under "with_notes.pptx"
    And tools is prepared as the result of PowerPointTools with no arguments
    When tools.tool pptx to markdown using str representation of temp dir under "with_notes.pptx"
    Then "Title Slide" occurs in result

  @candidate-python-strategic-coverage-9dfd33c583
  # Native: tests/test_strategic_coverage.py::TestExcelEdgeCases::test_extract_empty_cells
  Scenario: Native check: extract empty cells [TestExcelEdgeCases]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| A | B | C |\n|---|---|---|\n| 1 | | 3 |\n| | 2 | |\n"
    And path is prepared as temp dir under "empty_cells.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "empty_cells.xlsx"; "| A | B | C |\n|---|---|---|\n| 1 | | 3 |\n| | 2 | |\n"
    And tools.tool excel extract using str representation of temp dir under "empty_cells.xlsx"
    Then result has type dict

  @candidate-python-strategic-coverage-9bc0e4c230
  # Native: tests/test_strategic_coverage.py::TestWordPatchSectionEdgeCases::test_patch_section_with_special_chars
  Scenario: Native check: patch section with special chars [TestWordPatchSectionEdgeCases]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "special_sections.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "special_sections.docx"
    When tools.tool word list sections using str representation of temp dir under "special_sections.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-strategic-coverage-d0b0ca07cc
  # Native: tests/test_strategic_coverage.py::TestPptxBulletLevelVariations::test_add_deeply_nested_bullet
  Scenario: Native check: add deeply nested bullet [TestPptxBulletLevelVariations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "nested_bullets.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Nested Bullets"
    And path is prepared as temp dir under "nested_bullets.pptx"
    When tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 0"; level 0
    And tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 1"; level 1
    And tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 2"; level 2
    And tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 3"; level 3
    Then result has type dict

  @candidate-python-strategic-coverage-bf800a9cb9
  # Native: tests/test_strategic_coverage.py::TestWordFixSplitPlaceholdersComplex::test_fix_split_across_many_runs
  Scenario: Native check: fix split across many runs [TestWordFixSplitPlaceholdersComplex]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "multi_split.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "multi_split.docx"
    When tools.tool word fix split placeholders using str representation of temp dir under "multi_split.docx"; {"<Customer Name>": "Acme Corp"}
    Then result has type dict

  @candidate-python-strategic-coverage-79f315db09
  # Native: tests/test_strategic_coverage.py::TestPptxHideUnhideOperations::test_hide_then_unhide
  Scenario: Native check: hide then unhide [TestPptxHideUnhideOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "toggle.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Toggleable"
    And path is prepared as temp dir under "toggle.pptx"
    When tools.tool pptx hide slide using str representation of temp dir under "toggle.pptx"; 1; hidden true
    And tools.tool pptx get hidden slides using str representation of temp dir under "toggle.pptx"
    And tools.tool pptx hide slide using str representation of temp dir under "toggle.pptx"; 1; hidden false
    Then result has type dict

  @candidate-python-strategic-coverage-d52d766ced
  # Native: tests/test_strategic_coverage.py::TestWordCommentVariations::test_add_comment_target_not_found
  Scenario: Native check: add comment target not found [TestWordCommentVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "no_target.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_target.docx"
    When tools.tool word add comment using str representation of temp dir under "no_target.docx"; "nonexistent text"; "Comment for missing text"
    Then result has type dict

  @candidate-python-strategic-coverage-45a94963da
  # Native: tests/test_strategic_coverage.py::TestPptxFromMarkdownSpecialContent::test_with_table_content
  Scenario: Native check: with table content [TestPptxFromMarkdownSpecialContent]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Data Presentation\n\n## Statistics\n\n| Metric | Value |\n|--------|-------|\n| Users | 1000 |\n| Revenue| $50K |\n\n## Summary\n- Good performance\n- Growth expected\n"
    And path is prepared as temp dir under "table_slides.pptx"
    When tools.tool pptx from markdown using str representation of temp dir under "table_slides.pptx"; "# Data Presentation\n\n## Statistics\n\n| Metric | Value |\n|--------|-------|\n| Users | 1000 |\n| Revenue| $50K |\n\n## Summary\n- Good performance\n- Growth expected\n"
    Then the result of Path with temp dir under "table_slides.pptx" exists is non-empty or true

  @candidate-python-strategic-coverage-f99598f958
  # Native: tests/test_strategic_coverage.py::TestWordFromMarkdownSpecialContent::test_with_blockquotes
  Scenario: Native check: with blockquotes [TestWordFromMarkdownSpecialContent]
    Given an isolated writable temporary directory
    And tools is prepared as the result of WordTools with no arguments
    And md is prepared as "# Document\n\n## Quote Section\n\n> This is a blockquote\n> spanning multiple lines\n\n## Regular Content\nNormal paragraph here.\n"
    And path is prepared as temp dir under "blockquotes.docx"
    When tools.tool word from markdown using str representation of temp dir under "blockquotes.docx"; "# Document\n\n## Quote Section\n\n> This is a blockquote\n> spanning multiple lines\n\n## Regular Content\nNormal paragraph here.\n"
    Then the result of Path with temp dir under "blockquotes.docx" exists is non-empty or true

  @candidate-python-strategic-coverage-581bbae47a
  # Native: tests/test_strategic_coverage.py::TestWordDuplicateTableOperations::test_duplicate_table_structure_with_styling
  Scenario: Native check: duplicate table structure with styling [TestWordDuplicateTableOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "styled_table.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 0; 2 text is set to "C"
    And the result of table.cell with 1; 0 text is set to "D"
    And the result of table.cell with 1; 1 text is set to "E"
    And the result of table.cell with 1; 2 text is set to "F"
    And path is prepared as temp dir under "styled_table.docx"
    When tools.tool word duplicate table structure using str representation of temp dir under "styled_table.docx"; "0"
    Then result has type dict

  @candidate-python-strategic-coverage-ad0a064cbf
  # Native: tests/test_strategic_coverage.py::TestPptxSlideNumberEdgeCases::test_slide_number_zero
  Scenario: Native check: slide number zero [TestPptxSlideNumberEdgeCases]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "zero_slide.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "zero_slide.pptx"
    When tools.tool pptx get slide using str representation of temp dir under "zero_slide.pptx"; 0
    Then result has type dict

  @candidate-python-strategic-coverage-35d16a0b4f
  # Native: tests/test_strategic_coverage.py::TestPptxSlideNumberEdgeCases::test_negative_slide_number
  Scenario: Native check: negative slide number [TestPptxSlideNumberEdgeCases]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "neg_slide.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "neg_slide.pptx"
    When tools.tool pptx get slide using str representation of temp dir under "neg_slide.pptx"; -1
    Then result has type dict

  @candidate-python-strategic-coverage-16676b1a96
  # Native: tests/test_strategic_coverage.py::TestWordGetSectionVariations::test_get_section_fuzzy_match
  Scenario: Native check: get section fuzzy match [TestWordGetSectionVariations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "long_sections.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "long_sections.docx"
    When tools.tool word get section using str representation of temp dir under "long_sections.docx"; "Introduction"
    Then result has type dict

  @candidate-python-strategic-coverage-2e81543425
  # Native: tests/test_strategic_coverage.py::TestPptxSlideContentReading::test_get_slide_with_multiple_shapes
  Scenario: Native check: get slide with multiple shapes [TestPptxSlideContentReading]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "multi_shapes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title"
    And txBox is prepared as the result of slide.shapes.add textbox with the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 3; the result of PptxInches with 1
    And the result of slide.shapes.add textbox with the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 3; the result of PptxInches with 1 text frame text is set to "Textbox content"
    And table is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 5; the result of PptxInches with 2; the result of PptxInches with 3; the result of PptxInches with 1.5
    And tbl is prepared as the result of slide.shapes.add table with 2; 2; the result of PptxInches with 5; the result of PptxInches with 2; the result of PptxInches with 3; the result of PptxInches with 1.5 table
    And the result of tbl.cell with 0; 0 text is set to "A"
    And the result of tbl.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "multi_shapes.pptx"
    When tools.tool pptx get slide using str representation of temp dir under "multi_shapes.pptx"; 1
    Then result has type dict

  @candidate-python-strategic-coverage-c2cd03d427
  # Native: tests/test_strategic_coverage.py::TestWordReplaceGlobalVariablesComplex::test_replace_in_tables
  Scenario: Native check: replace in tables [TestWordReplaceGlobalVariablesComplex]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "table_replace.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "Customer"
    And the result of table.cell with 0; 1 text is set to "<Customer Name>"
    And the result of table.cell with 1; 0 text is set to "Project"
    And the result of table.cell with 1; 1 text is set to "<Project Name>"
    And path is prepared as temp dir under "table_replace.docx"
    When tools.tool word replace global variables using str representation of temp dir under "table_replace.docx"; {"<Customer Name>": "Contoso", "<Project Name>": "Migration"}
    Then result has type dict

  @candidate-python-strategic-coverage-8fce18d7af
  # Native: tests/test_strategic_coverage.py::TestPptxExtractContent::test_extract_with_all_content_types
  Scenario: Native check: extract with all content types [TestPptxExtractContent]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "full_extract.pptx"
    And tools is prepared as the result of PowerPointTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0 shapes title text is set to "Main Title"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Content"
    And path is prepared as temp dir under "full_extract.pptx"
    When tools.tool pptx extract using str representation of temp dir under "full_extract.pptx"
    Then result has type dict
    And "slides" occurs in result
