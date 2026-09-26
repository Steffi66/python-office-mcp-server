@captured @python_candidate
Feature: workflow coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-workflow-coverage-cf798db0a1
  # Native: tests/test_workflow_coverage.py::TestWordSowWorkflow::test_end_to_end_generation_cleanup_audit_workflow
  Scenario: Native check: end to end generation cleanup audit workflow [TestWordSowWorkflow]
    Given an isolated writable temporary directory
    And template.save with temp dir under "workflow_complete_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And template is prepared as the result of Document with no arguments
    And staffing is prepared as the result of template.add table with rows 2; cols 2
    And the result of staffing.cell with 0; 0 text is set to "Role"
    And the result of staffing.cell with 0; 1 text is set to "Hours"
    And template path is prepared as temp dir under "workflow_complete_template.docx"
    And markdown is prepared as "# Statement of Work\n\nCustomer: Contoso\nProject: Migration\nProvider: Microsoft\n\n## Executive Summary\n\nExecutive summary content.\n\n## Delivery approach\n\nDelivery approach content.\n\n## Customer responsibilities and project assumptions\n\nCustomer responsibilities content.\n\n## Staffing\n\n| Role | Hours |\n|------|-------|\n| Architect | 40 |\n"
    And generated is prepared as temp dir under "workflow_generated.docx"
    When tools.tool word create sow from markdown using str representation of temp dir under "workflow_generated.docx"; "# Statement of Work\n\nCustomer: Contoso\nProject: Migration\nProvider: Microsoft\n\n## Executive Summary\n\nExecutive summary content.\n\n## Delivery approach\n\nDelivery approach content.\n\n## Customer responsibilities and project assumptions\n\nCustomer responsibilities content.\n\n## Staffing\n\n| Role | Hours |\n|------|-------|\n| Architect | 40 |\n"; str representation of temp dir under "workflow_complete_template.docx"
    And tools.tool word cleanup sow using str representation of temp dir under "workflow_generated.docx"; output path str representation of temp dir under "workflow_cleaned.docx"
    And tools.tool word audit completion using str representation of temp dir under "workflow_cleaned.docx"
    Then generation field "success" is true
    And generation field "status" occurs in "{'partial_success', 'success'}"
    And cleanup field "success" is true
    And audit field "success" is true
    And audit field "score", defaulting to 0 is at least 95
    And audit field "summary", defaulting to {} field "placeholders_found" equals 0
    And audit field "summary", defaulting to {} field "empty_sections" equals 0
    And audit field "summary", defaulting to {} field "empty_table_cells" equals 0
    And audit field "summary", defaulting to {} field "instruction_remnants" equals 0

  @candidate-python-workflow-coverage-6f088cc294
  # Native: tests/test_workflow_coverage.py::TestWordSowWorkflow::test_sow_workflow_basic
  Scenario: Native check: sow workflow basic [TestWordSowWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "workflow_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "workflow_template.docx"
    When tools.tool word parse sow template using str representation of temp dir under "workflow_template.docx"
    And tools.tool word list sections using str representation of temp dir under "workflow_template.docx"
    Then result has type dict
    And the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-workflow-coverage-a03c3e46ac
  # Native: tests/test_workflow_coverage.py::TestWordSowWorkflow::test_sow_from_markdown
  Scenario: Native check: sow from markdown [TestWordSowWorkflow]
    Given an isolated writable temporary directory
    And template doc.save with temp dir under "sow_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And template doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "sow_template.docx"
    And md is prepared as "# Statement of Work\n\n## Executive Summary\n\nThis project will deliver a comprehensive cloud migration solution.\n\n## Scope\n\n### In Scope\n- Application migration\n- Infrastructure setup\n\n### Out of Scope\n- Hardware procurement\n"
    And output is prepared as temp dir under "md_sow.docx"
    When tools.tool word create sow from markdown using str representation of temp dir under "md_sow.docx"; "# Statement of Work\n\n## Executive Summary\n\nThis project will deliver a comprehensive cloud migration solution.\n\n## Scope\n\n### In Scope\n- Application migration\n- Infrastructure setup\n\n### Out of Scope\n- Hardware procurement\n"; str representation of temp dir under "sow_template.docx"
    Then result has type dict

  @candidate-python-workflow-coverage-89c907fca1
  # Native: tests/test_workflow_coverage.py::TestWordSowWorkflow::test_end_to_end_generation_handles_split_placeholders
  Scenario: Native check: end to end generation handles split placeholders [TestWordSowWorkflow]
    Given an isolated writable temporary directory
    And template.save with temp dir under "split_placeholder_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And template is prepared as the result of Document with no arguments
    And para is prepared as the result of template.add paragraph with no arguments
    And para2 is prepared as the result of template.add paragraph with no arguments
    And para3 is prepared as the result of template.add paragraph with no arguments
    And template path is prepared as temp dir under "split_placeholder_template.docx"
    And markdown is prepared as "# Statement of Work\n\nCustomer: Contoso\nProject: Migration Factory\nProvider: Microsoft\n\n## Executive Summary\n\nExecutive summary content.\n"
    And generated is prepared as temp dir under "split_placeholder_generated.docx"
    When tools.tool word create sow from markdown using str representation of temp dir under "split_placeholder_generated.docx"; "# Statement of Work\n\nCustomer: Contoso\nProject: Migration Factory\nProvider: Microsoft\n\n## Executive Summary\n\nExecutive summary content.\n"; str representation of temp dir under "split_placeholder_template.docx"
    And tools.tool word audit completion using str representation of temp dir under "split_placeholder_generated.docx"
    Then result field "success" is true
    And result field "replacements", defaulting to 0 is at least 3
    And audit field "summary", defaulting to {} field "placeholders_found" equals 0
    And "<Customer Name>" does not occur in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs
    And "<Project Name>" does not occur in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs
    And "<Provider Name>" does not occur in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs
    And "Contoso" occurs in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs
    And "Migration Factory" occurs in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs
    And "Microsoft" occurs in the result of '\n'.join with the result of get text with track changes with p for each p in the result of Document with temp dir under "split_placeholder_generated.docx" paragraphs

  @candidate-python-workflow-coverage-9df5e81358
  # Native: tests/test_workflow_coverage.py::TestPptxCompleteWorkflow::test_create_and_edit_presentation
  Scenario: Native check: create and edit presentation [TestPptxCompleteWorkflow]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And basic tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Proposal\n\n## Overview\n\n- Key point 1\n- Key point 2\n\n---\n\n## Details\n\n| Item | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And path is prepared as temp dir under "workflow.pptx"
    When basic tools.tool pptx from markdown using str representation of temp dir under "workflow.pptx"; "# Proposal\n\n## Overview\n\n- Key point 1\n- Key point 2\n\n---\n\n## Details\n\n| Item | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And tools.tool pptx list slides using str representation of temp dir under "workflow.pptx"
    And tools.tool pptx get slide using str representation of temp dir under "workflow.pptx"; slide number 1
    Then the result of Path with temp dir under "workflow.pptx" exists is non-empty or true
    And result field "slide_count", defaulting to 0 is at least 2
    And result has type dict

  @candidate-python-workflow-coverage-69c0918551
  # Native: tests/test_workflow_coverage.py::TestPptxCompleteWorkflow::test_add_slide_with_bullets
  Scenario: Native check: add slide with bullets [TestPptxCompleteWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "bullet_workflow.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "bullet_workflow.pptx"
    And output1 is prepared as temp dir under "with_slide.pptx"
    When tools.tool pptx add slide using str representation of temp dir under "bullet_workflow.pptx"; layout index 1; title "New Content"; output path str representation of temp dir under "with_slide.pptx"
    And tools.tool pptx clear bullets using str representation of temp dir under "with_slide.pptx"; slide number 2; output path str representation of temp dir under "cleared.pptx"
    And tools.tool pptx add bullet using str representation of temp dir under "cleared.pptx"; slide number 2; text "First point"; output path str representation of temp dir under "with_bullets.pptx"
    Then result field "success" is true

  @candidate-python-workflow-coverage-0873168a5b
  # Native: tests/test_workflow_coverage.py::TestExcelCompleteWorkflow::test_excel_roundtrip
  Scenario: Native check: excel roundtrip [TestExcelCompleteWorkflow]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| Name | Score | Grade |\n|------|-------|-------|\n| Alice | 95 | A |\n| Bob | 87 | B |\n| Carol | 92 | A |\n"
    And path is prepared as temp dir under "grades.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "grades.xlsx"; "| Name | Score | Grade |\n|------|-------|-------|\n| Alice | 95 | A |\n| Bob | 87 | B |\n| Carol | 92 | A |\n"
    And tools.tool excel extract using str representation of temp dir under "grades.xlsx"
    And tools.tool excel to markdown using str representation of temp dir under "grades.xlsx"
    Then the result of Path with temp dir under "grades.xlsx" exists is non-empty or true
    And the number of entries in result field "sheets", defaulting to [] is at least 1
    And "Alice" occurs in md result

  @candidate-python-workflow-coverage-d360e35863
  # Native: tests/test_workflow_coverage.py::TestWordTableWorkflow::test_table_operations
  Scenario: Native check: table operations [TestWordTableWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "table_workflow.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "table_workflow.docx"
    And output1 is prepared as temp dir under "with_table.docx"
    When tools.tool word create new table using str representation of temp dir under "table_workflow.docx"; ["Phase", "Start", "End"]; rows [{"Phase": "Phase 1", "Start": "Week 1", "End": "Week 4"}]; insert after section "Project Timeline"; output path str representation of temp dir under "with_table.docx"
    And tools.tool word list tables using str representation of temp dir under "with_table.docx"
    Then the number of entries in result field "tables", defaulting to [] is at least 1

  @candidate-python-workflow-coverage-11c293da99
  # Native: tests/test_workflow_coverage.py::TestPptxCommentWorkflow::test_comment_workflow
  Scenario: Native check: comment workflow [TestPptxCommentWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "comment_workflow.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Review Slide"
    And path is prepared as temp dir under "comment_workflow.pptx"
    And output1 is prepared as temp dir under "with_comment.pptx"
    When tools.tool pptx add comment using str representation of temp dir under "comment_workflow.pptx"; slide number 1; comment text "Please review this slide"; x inches 2.0; y inches 2.0; author "Reviewer"; output path str representation of temp dir under "with_comment.pptx"
    And tools.tool pptx get comments using str representation of temp dir under "with_comment.pptx"
    Then result field "success" is true
    And result has type dict

  @candidate-python-workflow-coverage-86b95e763e
  # Native: tests/test_workflow_coverage.py::TestMoreEdgeCases::test_word_empty_doc
  Scenario: Native check: word empty doc [TestMoreEdgeCases]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "empty.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "empty.docx"
    When tools.tool word list sections using str representation of temp dir under "empty.docx"
    And tools.tool word list tables using str representation of temp dir under "empty.docx"
    Then result has type dict
    And the number of entries in result field "tables", defaulting to [] equals 0

  @candidate-python-workflow-coverage-db8e0242b2
  # Native: tests/test_workflow_coverage.py::TestMoreEdgeCases::test_pptx_single_slide_ops
  Scenario: Native check: pptx single slide ops [TestMoreEdgeCases]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "single.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Only Slide"
    And path is prepared as temp dir under "single.pptx"
    When tools.tool pptx get slide using str representation of temp dir under "single.pptx"; slide number 1
    And tools.tool pptx list shapes using str representation of temp dir under "single.pptx"; slide number 1
    Then result has type dict
    And "shapes" occurs in result

  @candidate-python-workflow-coverage-eaec7e7f6d
  # Native: tests/test_workflow_coverage.py::TestMoreEdgeCases::test_pptx_with_textbox
  Scenario: Native check: pptx with textbox [TestMoreEdgeCases]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "textbox.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title"
    And txBox is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5
    And tf is prepared as the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5 text frame
    And the result of slide.shapes.add textbox with the result of Inches with 1; the result of Inches with 2; the result of Inches with 4; the result of Inches with 1.5 text frame text is set to "Textbox content"
    And path is prepared as temp dir under "textbox.pptx"
    When tools.tool pptx list shapes using str representation of temp dir under "textbox.pptx"; slide number 1
    Then the number of entries in result field "shapes", defaulting to [] is at least 2

  @candidate-python-workflow-coverage-92b2dab77e
  # Native: tests/test_workflow_coverage.py::TestWordSectionEditing::test_patch_section_with_content
  Scenario: Native check: patch section with content [TestWordSectionEditing]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    And output is prepared as temp dir under "patched.docx"
    When tools.tool word patch section using str representation of temp dir under "sections.docx"; "Section A"; "New content for section A"; output path str representation of temp dir under "patched.docx"
    Then result has type dict

  @candidate-python-workflow-coverage-523e96313c
  # Native: tests/test_workflow_coverage.py::TestPptxReplacement::test_replace_placeholders_comprehensive
  Scenario: Native check: replace placeholders comprehensive [TestPptxReplacement]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "placeholders.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> - <Project>"
    And path is prepared as temp dir under "placeholders.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When tools.tool pptx replace placeholders using str representation of temp dir under "placeholders.pptx"; replacements {"<Customer>": "Contoso", "<Project>": "Migration"}; output path str representation of temp dir under "replaced.pptx"
    Then result has type dict

  @candidate-python-workflow-coverage-587f73466c
  # Native: tests/test_workflow_coverage.py::TestWordTrackChanges::test_enable_and_check_tracking
  Scenario: Native check: enable and check tracking [TestWordTrackChanges]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "track.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track.docx"
    And output is prepared as temp dir under "tracking_enabled.docx"
    When tools.tool word enable track changes using str representation of temp dir under "track.docx"; output path str representation of temp dir under "tracking_enabled.docx"
    And tools.tool word check tracking using str representation of temp dir under "tracking_enabled.docx"
    Then result has type dict

  @candidate-python-workflow-coverage-f2e1fbf64a
  # Native: tests/test_workflow_coverage.py::TestPptxNotes::test_notes_workflow
  Scenario: Native check: notes workflow [TestPptxNotes]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "notes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Slide with Notes"
    And path is prepared as temp dir under "notes.pptx"
    And output1 is prepared as temp dir under "with_notes.pptx"
    When tools.tool pptx set notes using str representation of temp dir under "notes.pptx"; slide number 1; notes text "Initial speaker notes"; output path str representation of temp dir under "with_notes.pptx"
    And tools.tool pptx get notes using str representation of temp dir under "with_notes.pptx"; slide number 1
    And tools.tool pptx set notes using str representation of temp dir under "with_notes.pptx"; slide number 1; notes text "\nAdditional notes"; append true; output path str representation of temp dir under "appended_notes.pptx"
    Then result has type dict
    And result field "success" is true

  @candidate-python-workflow-coverage-ff3e87288d
  # Native: tests/test_workflow_coverage.py::TestAuditOperations::test_word_audit_complete
  Scenario: Native check: word audit complete [TestAuditOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "complete.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "complete.docx"
    When tools.tool word audit completion using str representation of temp dir under "complete.docx"
    Then result has type dict

  @candidate-python-workflow-coverage-819dbb0c61
  # Native: tests/test_workflow_coverage.py::TestAuditOperations::test_pptx_audit_clean
  Scenario: Native check: pptx audit clean [TestAuditOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "clean.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Clean Title"
    And path is prepared as temp dir under "clean.pptx"
    When tools.tool pptx audit placeholders using str representation of temp dir under "clean.pptx"
    Then result has type dict

  @candidate-python-workflow-coverage-ddad2d0e41
  # Native: tests/test_workflow_coverage.py::TestListSupportedFormats::test_tool_classes_available
  Scenario: Native check: tool classes available [TestListSupportedFormats]
    Given the native tool classes available inputs and isolated test state
    When the tool classes available behavior is exercised with its prepared inputs
    Then the number of entries in TOOL CLASSES is at least 1
