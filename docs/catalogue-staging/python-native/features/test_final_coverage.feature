@captured @python_candidate
Feature: final coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-final-coverage-a8cc3f3708
  # Native: tests/test_final_coverage.py::TestWordFromMarkdown::test_from_markdown_basic
  Scenario: Native check: from markdown basic [TestWordFromMarkdown]
    Given an isolated writable temporary directory
    And md is prepared as "# Document Title\n\n## Introduction\n\nThis is the introduction section.\n\n## Main Content\n\n- First point\n- Second point\n- Third point\n\n## Conclusion\n\nFinal thoughts here.\n"
    And path is prepared as temp dir under "from_md.docx"
    And tools is prepared as the result of WordTools with no arguments
    When tools.tool word from markdown using str representation of temp dir under "from_md.docx"; "# Document Title\n\n## Introduction\n\nThis is the introduction section.\n\n## Main Content\n\n- First point\n- Second point\n- Third point\n\n## Conclusion\n\nFinal thoughts here.\n"
    Then the result of Path with temp dir under "from_md.docx" exists is non-empty or true

  @candidate-python-final-coverage-5670a16bed
  # Native: tests/test_final_coverage.py::TestWordFromMarkdown::test_from_markdown_with_table
  Scenario: Native check: from markdown with table [TestWordFromMarkdown]
    Given an isolated writable temporary directory
    And md is prepared as "# Report\n\n## Data\n\n| Name | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And path is prepared as temp dir under "with_table.docx"
    And tools is prepared as the result of WordTools with no arguments
    When tools.tool word from markdown using str representation of temp dir under "with_table.docx"; "# Report\n\n## Data\n\n| Name | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    Then the result of Path with temp dir under "with_table.docx" exists is non-empty or true

  @candidate-python-final-coverage-a280940185
  # Native: tests/test_final_coverage.py::TestWordListOperations::test_list_sections_multiple
  Scenario: Native check: list sections multiple [TestWordListOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word list sections using str representation of temp dir under "sections.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 4

  @candidate-python-final-coverage-d02704f96a
  # Native: tests/test_final_coverage.py::TestPptxFromMarkdown::test_from_markdown_bullets
  Scenario: Native check: from markdown bullets [TestPptxFromMarkdown]
    Given an isolated writable temporary directory
    And md is prepared as "# Presentation\n\n## Overview\n\n- Key point 1\n- Key point 2\n- Key point 3\n\n---\n\n## Details\n\n- **Important:** Detail text\n- Regular bullet\n"
    And path is prepared as temp dir under "bullets.pptx"
    And tools is prepared as the result of PowerPointTools with no arguments
    When tools.tool pptx from markdown using str representation of temp dir under "bullets.pptx"; "# Presentation\n\n## Overview\n\n- Key point 1\n- Key point 2\n- Key point 3\n\n---\n\n## Details\n\n- **Important:** Detail text\n- Regular bullet\n"
    Then the result of Path with temp dir under "bullets.pptx" exists is non-empty or true

  @candidate-python-final-coverage-a2acfb218e
  # Native: tests/test_final_coverage.py::TestPptxFromMarkdown::test_from_markdown_with_subtitle
  Scenario: Native check: from markdown with subtitle [TestPptxFromMarkdown]
    Given an isolated writable temporary directory
    And md is prepared as "# Main Title\n**Context:** This is the subtitle context\n\n---\n\n## Content Slide\n\nSome content here.\n"
    And path is prepared as temp dir under "subtitle.pptx"
    And tools is prepared as the result of PowerPointTools with no arguments
    When tools.tool pptx from markdown using str representation of temp dir under "subtitle.pptx"; "# Main Title\n**Context:** This is the subtitle context\n\n---\n\n## Content Slide\n\nSome content here.\n"
    Then the result of Path with temp dir under "subtitle.pptx" exists is non-empty or true

  @candidate-python-final-coverage-7a3f1e5670
  # Native: tests/test_final_coverage.py::TestMoreSlideOperations::test_delete_and_verify
  Scenario: Native check: delete and verify [TestMoreSlideOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "delete_test.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "delete_test.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And output is prepared as temp dir under "deleted.pptx"
    When tools.tool pptx delete slide using str representation of temp dir under "delete_test.pptx"; slide number 2; output path str representation of temp dir under "deleted.pptx"
    Then result field "success" is true

  @candidate-python-final-coverage-14104a3818
  # Native: tests/test_final_coverage.py::TestWordPatchOperations::test_patch_section_content
  Scenario: Native check: patch section content [TestWordPatchOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "patch.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "patch.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And output is prepared as temp dir under "patched.docx"
    When tools.tool word patch section using str representation of temp dir under "patch.docx"; "Target Section"; "New replacement content that is different"; output path str representation of temp dir under "patched.docx"
    Then result has type dict

  @candidate-python-final-coverage-bfe23ca1c7
  # Native: tests/test_final_coverage.py::TestAuditFunctions::test_audit_completion_clean
  Scenario: Native check: audit completion clean [TestAuditFunctions]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "clean_audit.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "clean_audit.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word audit completion using str representation of temp dir under "clean_audit.docx"
    Then result has type dict

  @candidate-python-final-coverage-b057955611
  # Native: tests/test_final_coverage.py::TestAuditFunctions::test_audit_sow_with_issues
  Scenario: Native check: audit sow with issues [TestAuditFunctions]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_audit.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sow_audit.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word audit sow using str representation of temp dir under "sow_audit.docx"
    Then result has type dict

  @candidate-python-final-coverage-27a6c52a4c
  # Native: tests/test_final_coverage.py::TestMorePptxShapeOperations::test_list_shapes_with_textbox
  Scenario: Shape listing returns at least two entries for a generated 1-inch-high text box
    Given an isolated writable temporary directory and a newly constructed PresentationAdvancedTools object
    And python-pptx creates a presentation with one slide using slide_layouts[5] and title text "Title"
    And setup adds a text box at left 1 inch, top 2 inches, width 4 inches and height 1 inches
    And its text frame is set to "Textbox" and the presentation is saved as shapes.pptx
    When tool_pptx_list_shapes reads the saved file with slide_number 1
    Then len of result.get("shapes", []) is at least 2

  @candidate-python-final-coverage-bfd772eea9
  # Native: tests/test_final_coverage.py::TestWordSectionGuidance::test_get_section_guidance_missing
  Scenario: Native check: get section guidance missing [TestWordSectionGuidance]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "no_guidance.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_guidance.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word get section guidance using str representation of temp dir under "no_guidance.docx"; "Plain Section"
    Then result has type dict

  @candidate-python-final-coverage-2913ba6f71
  # Native: tests/test_final_coverage.py::TestDuplicateTableOperations::test_duplicate_table_structure
  Scenario: Native check: duplicate table structure [TestDuplicateTableOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "source_table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And the result of table.cell with 0; 0 text is set to "H1"
    And the result of table.cell with 0; 1 text is set to "H2"
    And the result of table.cell with 0; 2 text is set to "H3"
    And the result of table.cell with 1; 0 text is set to "Data1"
    And path is prepared as temp dir under "source_table.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And output is prepared as temp dir under "dup_table.docx"
    When tools.tool word duplicate table structure using str representation of temp dir under "source_table.docx"; "0"; output path str representation of temp dir under "dup_table.docx"
    Then result has type dict

  @candidate-python-final-coverage-fc5bf62336
  # Native: tests/test_final_coverage.py::TestReplaceTextOperations::test_replace_text_single_slide
  Scenario: Native check: replace text single slide [TestReplaceTextOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "replace_test.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Replace Me>"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And path is prepared as temp dir under "replace_test.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And output is prepared as temp dir under "replaced.pptx"
    When tools.tool pptx replace text using str representation of temp dir under "replace_test.pptx"; find text "<Replace Me>"; replace text "New Title"; slide number 1; output path str representation of temp dir under "replaced.pptx"
    Then result has type dict

  @candidate-python-final-coverage-529ef57b68
  # Native: tests/test_final_coverage.py::TestExcelOperations::test_extract_specific_sheet
  Scenario: Native check: extract specific sheet [TestExcelOperations]
    Given an isolated writable temporary directory
    And wb.save with temp dir under "sheets.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws1 is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Sheet1"
    And the result of Workbook with no arguments active at "A1" is set to "Data1"
    And ws2 is prepared as the result of wb.create sheet with "Sheet2"
    And the result of wb.create sheet with "Sheet2" at "A1" is set to "Data2"
    And path is prepared as temp dir under "sheets.xlsx"
    And tools is prepared as the result of ExcelTools with no arguments
    When tools.tool excel extract using str representation of temp dir under "sheets.xlsx"; sheet name "Sheet2"
    Then result has type dict

  @candidate-python-final-coverage-66cad29192
  # Native: tests/test_final_coverage.py::TestExcelOperations::test_to_markdown_specific_sheet
  Scenario: Native check: to markdown specific sheet [TestExcelOperations]
    Given an isolated writable temporary directory
    And wb.save with temp dir under "convert.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Data"
    And the result of Workbook with no arguments active at "A1" is set to "Col1"
    And the result of Workbook with no arguments active at "B1" is set to "Col2"
    And the result of Workbook with no arguments active at "A2" is set to "V1"
    And the result of Workbook with no arguments active at "B2" is set to "V2"
    And path is prepared as temp dir under "convert.xlsx"
    And tools is prepared as the result of ExcelTools with no arguments
    When tools.tool excel to markdown using str representation of temp dir under "convert.xlsx"; sheet name "Data"
    Then "Col1" occurs in result

  @candidate-python-final-coverage-f069c41941
  # Native: tests/test_final_coverage.py::TestCheckTracking::test_check_tracking_disabled
  Scenario: Native check: check tracking disabled [TestCheckTracking]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "no_tracking.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_tracking.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.tool word check tracking using str representation of temp dir under "no_tracking.docx"
    Then result has type dict

  @candidate-python-final-coverage-b38f6c951a
  # Native: tests/test_final_coverage.py::TestLogChanges::test_log_changes
  Scenario: Native check: log changes [TestLogChanges]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "log_test.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "log_test.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And output is prepared as temp dir under "with_log.pptx"
    When tools.tool pptx log changes using str representation of temp dir under "log_test.pptx"; changes [{"slide": 1, "action": "Updated", "detail": "Changed title"}]; output path str representation of temp dir under "with_log.pptx"
    Then result has type dict

  @candidate-python-final-coverage-6b26a79545
  # Native: tests/test_final_coverage.py::TestAnalyzeLayouts::test_analyze_layouts
  Scenario: Native check: analyze layouts [TestAnalyzeLayouts]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "layouts.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "layouts.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    When tools.tool pptx analyze layouts using str representation of temp dir under "layouts.pptx"
    Then result has type dict

  @candidate-python-final-coverage-566afb2f80
  # Native: tests/test_final_coverage.py::TestReorderSlides::test_reorder_valid
  Scenario: Native check: reorder valid [TestReorderSlides]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "reorder.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "First"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Second"
    And slide3 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Third"
    And path is prepared as temp dir under "reorder.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And output is prepared as temp dir under "reordered.pptx"
    When tools.tool pptx reorder slides using str representation of temp dir under "reorder.pptx"; new order [3, 1, 2]; output path str representation of temp dir under "reordered.pptx"
    Then result has type dict
