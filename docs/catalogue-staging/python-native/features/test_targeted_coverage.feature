@captured @python_candidate
Feature: targeted coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-targeted-coverage-ec01354887
  # Native: tests/test_targeted_coverage.py::TestWordExtractMethods::test_extract_sow_structure_detailed
  Scenario: Native check: extract sow structure detailed [TestWordExtractMethods]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "detailed_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "Objective"
    And the result of table.cell with 0; 1 text is set to "Activity"
    And the result of table.cell with 0; 2 text is set to "Assumption"
    And path is prepared as temp dir under "detailed_sow.docx"
    When word advanced tools.tool word extract sow structure using str representation of temp dir under "detailed_sow.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-2f3b83809a
  # Native: tests/test_targeted_coverage.py::TestWordExtractMethods::test_get_section_with_table
  Scenario: Native check: get section with table [TestWordExtractMethods]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "section_table.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "section_table.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "section_table.docx"; "Data Section"
    Then result has type dict

  @candidate-python-targeted-coverage-bb72a9fae4
  # Native: tests/test_targeted_coverage.py::TestPptxAdvancedSlideOps::test_duplicate_slide_preserve_content
  Scenario: Native check: duplicate slide preserve content [TestPptxAdvancedSlideOps]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "to_dup.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Original Title"
    And path is prepared as temp dir under "to_dup.pptx"
    And output is prepared as temp dir under "duplicated.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of temp dir under "to_dup.pptx"; slide number 1; position "after"; output path str representation of temp dir under "duplicated.pptx"
    Then result has type dict

  @candidate-python-targeted-coverage-d4e07c62e4
  # Native: tests/test_targeted_coverage.py::TestPptxAdvancedSlideOps::test_hide_multiple_slides
  Scenario: Native check: hide multiple slides [TestPptxAdvancedSlideOps]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "multi.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "multi.pptx"
    And output is prepared as temp dir under "hidden.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of temp dir under "multi.pptx"; slide number 2; hidden true; output path str representation of temp dir under "hidden.pptx"
    And pptx advanced tools.tool pptx get hidden slides using str representation of temp dir under "hidden.pptx"
    Then result field "success" is true or result field "hidden" is true
    And result has type dict

  @candidate-python-targeted-coverage-9000da47fd
  # Native: tests/test_targeted_coverage.py::TestWordTableAdvanced::test_patch_table_row_multiple_cols
  Scenario: Native check: patch table row multiple cols [TestWordTableAdvanced]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "multi_col.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 4
    And the result of table.cell with 1; 0 text is set to "1"
    And the result of table.cell with 1; 1 text is set to "Item A"
    And the result of table.cell with 1; 2 text is set to "Pending"
    And the result of table.cell with 1; 3 text is set to "2024-01-01"
    And path is prepared as temp dir under "multi_col.docx"
    And output is prepared as temp dir under "patched.docx"
    When word advanced tools.tool word patch table row using str representation of temp dir under "multi_col.docx"; "0"; 1; {"Status": "Complete", "Date": "2024-02-01"}; output path str representation of temp dir under "patched.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-eddd174003
  # Native: tests/test_targeted_coverage.py::TestWordTableAdvanced::test_duplicate_table_add_row
  Scenario: Native check: duplicate table add row [TestWordTableAdvanced]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "dup_add.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "Col1"
    And the result of table.cell with 0; 1 text is set to "Col2"
    And path is prepared as temp dir under "dup_add.docx"
    And output1 is prepared as temp dir under "dup_struct.docx"
    When word advanced tools.tool word duplicate table structure using str representation of temp dir under "dup_add.docx"; "0"; output path str representation of temp dir under "dup_struct.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-9282c7cb75
  # Native: tests/test_targeted_coverage.py::TestPptxLayoutsAdvanced::test_analyze_all_layouts
  Scenario: Native check: analyze all layouts [TestPptxLayoutsAdvanced]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "layouts.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "layouts.pptx"
    When pptx advanced tools.tool pptx analyze layouts using str representation of temp dir under "layouts.pptx"
    Then "layouts" occurs in result

  @candidate-python-targeted-coverage-027042f021
  # Native: tests/test_targeted_coverage.py::TestPptxLayoutsAdvanced::test_recommend_layout_two_column
  Scenario: Native check: recommend layout two column [TestPptxLayoutsAdvanced]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "two_col.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "two_col.pptx"
    When pptx advanced tools.tool pptx recommend layout using str representation of temp dir under "two_col.pptx"; "two_column"
    Then result has type dict

  @candidate-python-targeted-coverage-6e7f329283
  # Native: tests/test_targeted_coverage.py::TestWordReplacement::test_replace_global_in_headers
  Scenario: Native check: replace global in headers [TestWordReplacement]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "headers.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "headers.docx"
    And output is prepared as temp dir under "replaced.docx"
    When word advanced tools.tool word replace global variables using str representation of temp dir under "headers.docx"; replacements {"<Customer>": "ACME Corp"}; output path str representation of temp dir under "replaced.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-40d65e27cd
  # Native: tests/test_targeted_coverage.py::TestPptxBulletAdvanced::test_bullet_with_all_options
  Scenario: Native check: bullet with all options [TestPptxBulletAdvanced]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "bullet_opts.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Content"
    And path is prepared as temp dir under "bullet_opts.pptx"
    And output is prepared as temp dir under "with_bullets.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of temp dir under "bullet_opts.pptx"; slide number 1; text "Detail text here"; level 0; bold label "Key Point"; output path str representation of temp dir under "with_bullets.pptx"
    Then result field "success" is true

  @candidate-python-targeted-coverage-593cc9ee37
  # Native: tests/test_targeted_coverage.py::TestWordCommentAdvanced::test_add_comment_with_author
  Scenario: Native check: add comment with author [TestWordCommentAdvanced]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "for_comment.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "for_comment.docx"
    And output is prepared as temp dir under "commented.docx"
    When word advanced tools.tool word add comment using str representation of temp dir under "for_comment.docx"; target text "needs review"; comment text "Please verify this section"; author "Reviewer A"; output path str representation of temp dir under "commented.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-d4dad35829
  # Native: tests/test_targeted_coverage.py::TestPptxAutofit::test_autofit_all_types
  Scenario: Native check: autofit all types [TestPptxAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "autofit.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Test Title"
    And path is prepared as temp dir under "autofit.pptx"
    And output1 is prepared as temp dir under "shrink.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of temp dir under "autofit.pptx"; slide number 1; shape identifier "title"; autofit type "shrink"; output path str representation of temp dir under "shrink.pptx"
    And pptx advanced tools.tool pptx set text autofit using str representation of temp dir under "shrink.pptx"; slide number 1; shape identifier "title"; autofit type "none"; output path str representation of temp dir under "none.pptx"
    Then result field "success" is true

  @candidate-python-targeted-coverage-e5147e362f
  # Native: tests/test_targeted_coverage.py::TestWordAuditAdvanced::test_audit_sow_comprehensive
  Scenario: Native check: audit sow comprehensive [TestWordAuditAdvanced]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "audit_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "Phase"
    And the result of table.cell with 0; 1 text is set to "Start"
    And the result of table.cell with 0; 2 text is set to "End"
    And path is prepared as temp dir under "audit_sow.docx"
    When word advanced tools.tool word audit sow using str representation of temp dir under "audit_sow.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-dbf846dc39
  # Native: tests/test_targeted_coverage.py::TestWordAuditAdvanced::test_audit_completion_mixed
  Scenario: Native check: audit completion mixed [TestWordAuditAdvanced]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "mixed.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "mixed.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "mixed.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-0d1b8658e3
  # Native: tests/test_targeted_coverage.py::TestPptxReorderAdvanced::test_reorder_complex
  Scenario: Native check: reorder complex [TestPptxReorderAdvanced]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "complex_order.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "complex_order.pptx"
    And output is prepared as temp dir under "reordered.pptx"
    When pptx advanced tools.tool pptx reorder slides using str representation of temp dir under "complex_order.pptx"; new order [4, 2, 1, 3]; output path str representation of temp dir under "reordered.pptx"
    Then result has type dict

  @candidate-python-targeted-coverage-988c5f82f4
  # Native: tests/test_targeted_coverage.py::TestWordCleanup::test_cleanup_comprehensive
  Scenario: Native check: cleanup comprehensive [TestWordCleanup]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "cleanup.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "cleanup.docx"
    And output is prepared as temp dir under "cleaned.docx"
    When word advanced tools.tool word cleanup sow using str representation of temp dir under "cleanup.docx"; output path str representation of temp dir under "cleaned.docx"
    Then result has type dict

  @candidate-python-targeted-coverage-e595cac221
  # Native: tests/test_targeted_coverage.py::TestPptxLogChanges::test_log_multiple_changes
  Scenario: Native check: log multiple changes [TestPptxLogChanges]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "for_log.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "for_log.pptx"
    And output is prepared as temp dir under "with_log.pptx"
    When pptx advanced tools.tool pptx log changes using str representation of temp dir under "for_log.pptx"; changes [{"slide": 1, "action": "Updated title", "detail": "Changed from placeholder"}, {"slide": 2, "action": "Added content", "detail": "Added bullet points"}, {"slide": 1, "action": "Fixed formatting", "detail": "Adjusted font size"}]; output path str representation of temp dir under "with_log.pptx"
    Then result has type dict
