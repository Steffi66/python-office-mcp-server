@captured @python_candidate
Feature: workflows native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-workflows-4d414298ae
  # Native: tests/test_workflows.py::TestWordSowWorkflow::test_sow_workflow_basic
  Scenario: Native check: sow workflow basic [TestWordSowWorkflow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "workflow_template.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "workflow_template.docx"
    When word advanced tools.tool word parse sow template using str representation of temp dir under "workflow_template.docx"
    And word advanced tools.tool word list sections using str representation of temp dir under "workflow_template.docx"
    Then result has type dict
    And the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-workflows-4d9c9fb744
  # Native: tests/test_workflows.py::TestWordSowWorkflow::test_sow_from_markdown
  Scenario: Native check: sow from markdown [TestWordSowWorkflow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template doc.save with temp dir under "sow_template.docx"
    And template doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "sow_template.docx"
    And md is prepared as "# Statement of Work\n\n## Executive Summary\n\nThis project will deliver a comprehensive cloud migration solution.\n\n## Scope\n\n### In Scope\n- Application migration\n- Infrastructure setup\n\n### Out of Scope\n- Hardware procurement\n"
    And output is prepared as temp dir under "md_sow.docx"
    When word advanced tools.tool word create sow from markdown using str representation of temp dir under "md_sow.docx"; "# Statement of Work\n\n## Executive Summary\n\nThis project will deliver a comprehensive cloud migration solution.\n\n## Scope\n\n### In Scope\n- Application migration\n- Infrastructure setup\n\n### Out of Scope\n- Hardware procurement\n"; str representation of temp dir under "sow_template.docx"
    Then result has type dict

  @candidate-python-workflows-f06d04e1fb
  # Native: tests/test_workflows.py::TestPptxCompleteWorkflow::test_create_and_edit_presentation
  Scenario: Native check: create and edit presentation [TestPptxCompleteWorkflow]
    Given Create an instance of PresentationAdvancedTools.
    And Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Proposal\n\n## Overview\n\n- Key point 1\n- Key point 2\n\n---\n\n## Details\n\n| Item | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And path is prepared as temp dir under "workflow.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "workflow.pptx"; "# Proposal\n\n## Overview\n\n- Key point 1\n- Key point 2\n\n---\n\n## Details\n\n| Item | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And pptx advanced tools.tool pptx list slides using str representation of temp dir under "workflow.pptx"
    And pptx advanced tools.tool pptx get slide using str representation of temp dir under "workflow.pptx"; slide number 1
    Then the result of Path with temp dir under "workflow.pptx" exists is non-empty or true
    And result field "slide_count", defaulting to 0 is at least 2
    And result has type dict

  @candidate-python-workflows-1cf066ff38
  # Native: tests/test_workflows.py::TestPptxCompleteWorkflow::test_add_slide_with_bullets
  Scenario: Native check: add slide with bullets [TestPptxCompleteWorkflow]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "bullet_workflow.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "bullet_workflow.pptx"
    And output1 is prepared as temp dir under "with_slide.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of temp dir under "bullet_workflow.pptx"; layout index 1; title "New Content"; output path str representation of temp dir under "with_slide.pptx"
    And pptx advanced tools.tool pptx clear bullets using str representation of temp dir under "with_slide.pptx"; slide number 2; output path str representation of temp dir under "cleared.pptx"
    And pptx advanced tools.tool pptx add bullet using str representation of temp dir under "cleared.pptx"; slide number 2; text "First point"; output path str representation of temp dir under "with_bullets.pptx"
    Then result field "success" is true

  @candidate-python-workflows-50cd6acf94
  # Native: tests/test_workflows.py::TestExcelCompleteWorkflow::test_excel_roundtrip
  Scenario: Native check: excel roundtrip [TestExcelCompleteWorkflow]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And md is prepared as "| Name | Score | Grade |\n|------|-------|-------|\n| Alice | 95 | A |\n| Bob | 87 | B |\n| Carol | 92 | A |\n"
    And path is prepared as temp dir under "grades.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "grades.xlsx"; "| Name | Score | Grade |\n|------|-------|-------|\n| Alice | 95 | A |\n| Bob | 87 | B |\n| Carol | 92 | A |\n"
    And excel tools.tool excel extract using str representation of temp dir under "grades.xlsx"
    And excel tools.tool excel to markdown using str representation of temp dir under "grades.xlsx"
    Then the result of Path with temp dir under "grades.xlsx" exists is non-empty or true
    And the number of entries in result field "sheets", defaulting to [] is at least 1
    And "Alice" occurs in md result

  @candidate-python-workflows-15c6fe1305
  # Native: tests/test_workflows.py::TestWordTableWorkflow::test_table_operations
  Scenario: Native check: table operations [TestWordTableWorkflow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "table_workflow.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "table_workflow.docx"
    And output1 is prepared as temp dir under "with_table.docx"
    When word advanced tools.tool word create new table using str representation of temp dir under "table_workflow.docx"; ["Phase", "Start", "End"]; rows [{"Phase": "Phase 1", "Start": "Week 1", "End": "Week 4"}]; insert after section "Project Timeline"; output path str representation of temp dir under "with_table.docx"
    And word advanced tools.tool word list tables using str representation of temp dir under "with_table.docx"
    Then the number of entries in result field "tables", defaulting to [] is at least 1

  @candidate-python-workflows-11eee5a07c
  # Native: tests/test_workflows.py::TestPptxCommentWorkflow::test_comment_workflow
  Scenario: Native check: comment workflow [TestPptxCommentWorkflow]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "comment_workflow.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Review Slide"
    And path is prepared as temp dir under "comment_workflow.pptx"
    And output1 is prepared as temp dir under "with_comment.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of temp dir under "comment_workflow.pptx"; slide number 1; comment text "Please review this slide"; x inches 2.0; y inches 2.0; author "Reviewer"; output path str representation of temp dir under "with_comment.pptx"
    And pptx advanced tools.tool pptx get comments using str representation of temp dir under "with_comment.pptx"
    Then result field "success" is true
    And result has type dict

  @candidate-python-workflows-819e988ac4
  # Native: tests/test_workflows.py::TestMoreEdgeCases::test_word_empty_doc
  Scenario: Native check: word empty doc [TestMoreEdgeCases]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "empty.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "empty.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "empty.docx"
    And word advanced tools.tool word list tables using str representation of temp dir under "empty.docx"
    Then result has type dict
    And the number of entries in result field "tables", defaulting to [] equals 0

  @candidate-python-workflows-7422e7ef45
  # Native: tests/test_workflows.py::TestMoreEdgeCases::test_pptx_single_slide_ops
  Scenario: Native check: pptx single slide ops [TestMoreEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "single.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Only Slide"
    And path is prepared as temp dir under "single.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "single.pptx"; slide number 1
    And pptx advanced tools.tool pptx list shapes using str representation of temp dir under "single.pptx"; slide number 1
    Then result has type dict
    And "shapes" occurs in result

  @candidate-python-workflows-980faaa900
  # Native: tests/test_workflows.py::TestMoreEdgeCases::test_pptx_with_textbox
  Scenario: Native check: pptx with textbox [TestMoreEdgeCases]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "textbox.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title"
    And txBox is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5
    And tf is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5 text frame
    And the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5 text frame text is set to "Textbox content"
    And path is prepared as temp dir under "textbox.pptx"
    When pptx advanced tools.tool pptx list shapes using str representation of temp dir under "textbox.pptx"; slide number 1
    Then the number of entries in result field "shapes", defaulting to [] is at least 2

  @candidate-python-workflows-f0fa151177
  # Native: tests/test_workflows.py::TestWordSectionEditing::test_patch_section_with_content
  Scenario: Native check: patch section with content [TestWordSectionEditing]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    And output is prepared as temp dir under "patched.docx"
    When word advanced tools.tool word patch section using str representation of temp dir under "sections.docx"; "Section A"; "New content for section A"; output path str representation of temp dir under "patched.docx"
    Then result has type dict

  @candidate-python-workflows-c12d707b5c
  # Native: tests/test_workflows.py::TestPptxReplacement::test_replace_placeholders_comprehensive
  Scenario: Native check: replace placeholders comprehensive [TestPptxReplacement]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "placeholders.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> - <Project>"
    And path is prepared as temp dir under "placeholders.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When pptx advanced tools.tool pptx replace placeholders using str representation of temp dir under "placeholders.pptx"; replacements {"<Customer>": "Contoso", "<Project>": "Migration"}; output path str representation of temp dir under "replaced.pptx"
    Then result has type dict

  @candidate-python-workflows-b4b6486edc
  # Native: tests/test_workflows.py::TestWordTrackChanges::test_enable_and_check_tracking
  Scenario: Native check: enable and check tracking [TestWordTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "track.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track.docx"
    And output is prepared as temp dir under "tracking_enabled.docx"
    When word advanced tools.tool word enable track changes using str representation of temp dir under "track.docx"; output path str representation of temp dir under "tracking_enabled.docx"
    And word advanced tools.tool word check tracking using str representation of temp dir under "tracking_enabled.docx"
    Then result has type dict

  @candidate-python-workflows-b3e718fcbc
  # Native: tests/test_workflows.py::TestPptxNotes::test_notes_workflow
  Scenario: Native check: notes workflow [TestPptxNotes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Slide with Notes"
    And path is prepared as temp dir under "notes.pptx"
    And output1 is prepared as temp dir under "with_notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of temp dir under "notes.pptx"; slide number 1; notes text "Initial speaker notes"; output path str representation of temp dir under "with_notes.pptx"
    And pptx advanced tools.tool pptx get notes using str representation of temp dir under "with_notes.pptx"; slide number 1
    And pptx advanced tools.tool pptx set notes using str representation of temp dir under "with_notes.pptx"; slide number 1; notes text "\nAdditional notes"; append true; output path str representation of temp dir under "appended_notes.pptx"
    Then result has type dict
    And result field "success" is true

  @candidate-python-workflows-2c621f808a
  # Native: tests/test_workflows.py::TestAuditOperations::test_word_audit_complete
  Scenario: Native check: word audit complete [TestAuditOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "complete.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "complete.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "complete.docx"
    Then result has type dict

  @candidate-python-workflows-bf1e74a2fc
  # Native: tests/test_workflows.py::TestAuditOperations::test_pptx_audit_clean
  Scenario: Native check: pptx audit clean [TestAuditOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "clean.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Clean Title"
    And path is prepared as temp dir under "clean.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "clean.pptx"
    Then result has type dict

  @candidate-python-workflows-2b4937f7f0
  # Native: tests/test_workflows.py::TestListSupportedFormats::test_tool_classes_available
  Scenario: Native check: tool classes available [TestListSupportedFormats]
    Given Import TOOL_CLASSES from tools.
    When Evaluate len(TOOL_CLASSES).
    Then len(TOOL_CLASSES) is greater than or equal to 1.
