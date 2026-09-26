@captured @python_candidate
Feature: advanced edge cases native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-advanced-edge-cases-753e4b3c5b
  # Native: tests/test_advanced_edge_cases.py::TestWordPatchSectionEdgeCases::test_patch_section_with_special_chars
  Scenario: Native check: patch section with special chars [TestWordPatchSectionEdgeCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "special_sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "special_sections.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "special_sections.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-advanced-edge-cases-1a0e847794
  # Native: tests/test_advanced_edge_cases.py::TestPptxBulletLevelVariations::test_add_deeply_nested_bullet
  Scenario: Native check: add deeply nested bullet [TestPptxBulletLevelVariations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "nested_bullets.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Nested Bullets"
    And path is prepared as temp dir under "nested_bullets.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 0"; level 0
    And pptx advanced tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 1"; level 1
    And pptx advanced tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 2"; level 2
    And pptx advanced tools.tool pptx add bullet using str representation of temp dir under "nested_bullets.pptx"; 1; "Level 3"; level 3
    Then result has type dict

  @candidate-python-advanced-edge-cases-9274b5b532
  # Native: tests/test_advanced_edge_cases.py::TestWordFixSplitPlaceholdersComplex::test_fix_split_across_many_runs
  Scenario: Native check: fix split across many runs [TestWordFixSplitPlaceholdersComplex]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "multi_split.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "multi_split.docx"
    When word advanced tools.tool word fix split placeholders using str representation of temp dir under "multi_split.docx"; {"<Customer Name>": "Acme Corp"}
    Then result has type dict

  @candidate-python-advanced-edge-cases-b75660928b
  # Native: tests/test_advanced_edge_cases.py::TestPptxHideUnhideOperations::test_hide_then_unhide
  Scenario: Native check: hide then unhide [TestPptxHideUnhideOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "toggle.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Toggleable"
    And path is prepared as temp dir under "toggle.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of temp dir under "toggle.pptx"; 1; hidden true
    And pptx advanced tools.tool pptx get hidden slides using str representation of temp dir under "toggle.pptx"
    And pptx advanced tools.tool pptx hide slide using str representation of temp dir under "toggle.pptx"; 1; hidden false
    Then result has type dict

  @candidate-python-advanced-edge-cases-a4e4000456
  # Native: tests/test_advanced_edge_cases.py::TestWordCommentVariations::test_add_comment_target_not_found
  Scenario: Native check: add comment target not found [TestWordCommentVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_target.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_target.docx"
    When word advanced tools.tool word add comment using str representation of temp dir under "no_target.docx"; "nonexistent text"; "Comment for missing text"
    Then result has type dict

  @candidate-python-advanced-edge-cases-71489eefde
  # Native: tests/test_advanced_edge_cases.py::TestWordDuplicateTableOperations::test_duplicate_table_structure_with_styling
  Scenario: Native check: duplicate table structure with styling [TestWordDuplicateTableOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "styled_table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And the result of table.cell with 0; 2 text is set to "C"
    And the result of table.cell with 1; 0 text is set to "D"
    And the result of table.cell with 1; 1 text is set to "E"
    And the result of table.cell with 1; 2 text is set to "F"
    And path is prepared as temp dir under "styled_table.docx"
    When word advanced tools.tool word duplicate table structure using str representation of temp dir under "styled_table.docx"; "0"
    Then result has type dict

  @candidate-python-advanced-edge-cases-13eb18c28b
  # Native: tests/test_advanced_edge_cases.py::TestPptxSlideNumberEdgeCases::test_slide_number_zero
  Scenario: Native check: slide number zero [TestPptxSlideNumberEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "zero_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "zero_slide.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "zero_slide.pptx"; 0
    Then result has type dict

  @candidate-python-advanced-edge-cases-86e857acbf
  # Native: tests/test_advanced_edge_cases.py::TestPptxSlideNumberEdgeCases::test_negative_slide_number
  Scenario: Native check: negative slide number [TestPptxSlideNumberEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "neg_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "neg_slide.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "neg_slide.pptx"; -1
    Then result has type dict

  @candidate-python-advanced-edge-cases-6e80c040e4
  # Native: tests/test_advanced_edge_cases.py::TestWordGetSectionVariations::test_get_section_fuzzy_match
  Scenario: Native check: get section fuzzy match [TestWordGetSectionVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "long_sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "long_sections.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "long_sections.docx"; "Introduction"
    Then result has type dict

  @candidate-python-advanced-edge-cases-96f554baf9
  # Native: tests/test_advanced_edge_cases.py::TestPptxSlideContentReading::test_get_slide_with_multiple_shapes
  Scenario: Native check: get slide with multiple shapes [TestPptxSlideContentReading]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "multi_shapes.pptx"
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
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "multi_shapes.pptx"; 1
    Then result has type dict

  @candidate-python-advanced-edge-cases-d9ccef09ee
  # Native: tests/test_advanced_edge_cases.py::TestWordReplaceGlobalVariablesComplex::test_replace_in_tables
  Scenario: Native check: replace in tables [TestWordReplaceGlobalVariablesComplex]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "table_replace.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "Customer"
    And the result of table.cell with 0; 1 text is set to "<Customer Name>"
    And the result of table.cell with 1; 0 text is set to "Project"
    And the result of table.cell with 1; 1 text is set to "<Project Name>"
    And path is prepared as temp dir under "table_replace.docx"
    When word advanced tools.tool word replace global variables using str representation of temp dir under "table_replace.docx"; {"<Customer Name>": "Contoso", "<Project Name>": "Migration"}
    Then result has type dict

  @candidate-python-advanced-edge-cases-8ea12f8352
  # Native: tests/test_advanced_edge_cases.py::TestPptxExtractContent::test_extract_with_all_content_types
  Scenario: Native check: extract with all content types [TestPptxExtractContent]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "full_extract.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0 shapes title text is set to "Main Title"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Content"
    And path is prepared as temp dir under "full_extract.pptx"
    When pptx tools.tool pptx extract using str representation of temp dir under "full_extract.pptx"
    Then result has type dict
    And "slides" occurs in result
