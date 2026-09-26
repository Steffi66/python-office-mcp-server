@captured @python_candidate
Feature: coverage boost native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-coverage-boost-5dfb87a2de
  # Native: tests/test_coverage_boost.py::TestWordPromptFunctions::test_prompt_sow_data
  Scenario: Native check: prompt sow data [TestWordPromptFunctions]
    Given tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.prompt sow data using the prepared inputs
    Then when the result of WordAdvancedTools with no arguments has attribute "prompt_sow_data", the result of tools.prompt sow data with no arguments is not null

  @candidate-python-coverage-boost-61a7cafa32
  # Native: tests/test_coverage_boost.py::TestWordPromptFunctions::test_prompt_sow_section
  Scenario: Native check: prompt sow section [TestWordPromptFunctions]
    Given tools is prepared as the result of WordAdvancedTools with no arguments
    When tools.prompt sow section using "Test Section"
    Then when the result of WordAdvancedTools with no arguments has attribute "prompt_sow_section", the result of tools.prompt sow section with "Test Section" is not null

  @candidate-python-coverage-boost-f0b73face4
  # Native: tests/test_coverage_boost.py::TestWordTrackChangesOperations::test_enable_track_changes_output
  Scenario: Native check: enable track changes output [TestWordTrackChangesOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "track_input.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track_input.docx"
    And output is prepared as temp dir under "track_output.docx"
    When tools.tool word enable track changes using str representation of temp dir under "track_input.docx"; output path str representation of temp dir under "track_output.docx"
    Then result has type dict
    And the result of Path with temp dir under "track_output.docx" exists is non-empty or true

  @candidate-python-coverage-boost-5a537db44c
  # Native: tests/test_coverage_boost.py::TestWordTrackChangesOperations::test_patch_with_track_changes_complex
  Scenario: Native check: patch with track changes complex [TestWordTrackChangesOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "multi_patch.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "multi_patch.docx"
    And output is prepared as temp dir under "patched_output.docx"
    When tools.tool word patch with track changes using str representation of temp dir under "multi_patch.docx"; {"<Customer Name>": "Contoso Ltd", "<Project Name>": "Cloud Migration"}; author "Test Author"; output path str representation of temp dir under "patched_output.docx"
    Then result has type dict

  @candidate-python-coverage-boost-670ade6c08
  # Native: tests/test_coverage_boost.py::TestWordTableCreation::test_create_table_after_section
  Scenario: Native check: create table after section [TestWordTableCreation]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "with_section.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "with_section.docx"
    When tools.tool word create new table using str representation of temp dir under "with_section.docx"; ["Item", "Description", "Status"]; [{"Item": "A", "Description": "First", "Status": "Done"}]; insert after section "Data Section"
    Then result has type dict

  @candidate-python-coverage-boost-1d61946eb8
  # Native: tests/test_coverage_boost.py::TestPptxSlideOperations::test_add_slide_with_layout_index
  Scenario: Native check: add slide with layout index [TestPptxSlideOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "layout_test.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "layout_test.pptx"
    When tools.tool pptx add slide using str representation of temp dir under "layout_test.pptx"; layout index 5; title "Custom Layout"
    Then result has type dict

  @candidate-python-coverage-boost-453db94749
  # Native: tests/test_coverage_boost.py::TestPptxSlideOperations::test_duplicate_slide_position_after
  Scenario: Native check: duplicate slide position after [TestPptxSlideOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "dup_after.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "First"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Second"
    And path is prepared as temp dir under "dup_after.pptx"
    When tools.tool pptx duplicate slide using str representation of temp dir under "dup_after.pptx"; 1; position "after"
    Then result has type dict

  @candidate-python-coverage-boost-5aa8f92e3d
  # Native: tests/test_coverage_boost.py::TestPptxShapeOperations::test_list_shapes_with_table
  Scenario: Native check: list shapes with table [TestPptxShapeOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "with_table.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title"
    And path is prepared as temp dir under "with_table.pptx"
    When tools.tool pptx list shapes using str representation of temp dir under "with_table.pptx"; 1
    Then result has type dict
    And at least one item satisfies s field "has_table" for each s in result field "shapes", defaulting to [] or the number of entries in result field "shapes", defaulting to [] exceeds 0

  @candidate-python-coverage-boost-acdc3229b5
  # Native: tests/test_coverage_boost.py::TestPptxShapeOperations::test_patch_shape_body
  Scenario: Native check: patch shape body [TestPptxShapeOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "patch_body.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "patch_body.pptx"
    When tools.tool pptx patch shape using str representation of temp dir under "patch_body.pptx"; slide number 1; shape identifier "body"; new text "Updated body content"
    Then result has type dict

  @candidate-python-coverage-boost-a6b2ec025c
  # Native: tests/test_coverage_boost.py::TestPptxReplaceOperations::test_replace_text_specific_slide
  Scenario: Native check: replace text specific slide [TestPptxReplaceOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "specific_slide.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> Slide 1"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> Slide 2"
    And path is prepared as temp dir under "specific_slide.pptx"
    When tools.tool pptx replace text using str representation of temp dir under "specific_slide.pptx"; "<Customer>"; "Contoso"; slide number 1
    Then result has type dict

  @candidate-python-coverage-boost-5edb18538c
  # Native: tests/test_coverage_boost.py::TestPptxReplaceOperations::test_replace_placeholders_multiple
  Scenario: Native check: replace placeholders multiple [TestPptxReplaceOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "multi_replace.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Company> - <Project>"
    And path is prepared as temp dir under "multi_replace.pptx"
    When tools.tool pptx replace placeholders using str representation of temp dir under "multi_replace.pptx"; {"<Company>": "Contoso", "<Project>": "Migration"}
    Then result has type dict

  @candidate-python-coverage-boost-867d1be1ac
  # Native: tests/test_coverage_boost.py::TestPptxLayoutOperations::test_recommend_layout_comparison
  Scenario: Native check: recommend layout comparison [TestPptxLayoutOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "rec_comparison.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "rec_comparison.pptx"
    When tools.tool pptx recommend layout using str representation of temp dir under "rec_comparison.pptx"; "comparison"
    Then result has type dict

  @candidate-python-coverage-boost-51adfcc56f
  # Native: tests/test_coverage_boost.py::TestPptxLayoutOperations::test_recommend_layout_blank
  Scenario: Native check: recommend layout blank [TestPptxLayoutOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "rec_blank.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "rec_blank.pptx"
    When tools.tool pptx recommend layout using str representation of temp dir under "rec_blank.pptx"; "blank"
    Then result has type dict

  @candidate-python-coverage-boost-64dfb4955c
  # Native: tests/test_coverage_boost.py::TestWordSowOperations::test_extract_sow_structure_complex
  Scenario: Native check: extract sow structure complex [TestWordSowOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "complex_sow.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And the result of table.cell with 0; 0 text is set to "Phase"
    And the result of table.cell with 0; 1 text is set to "Duration"
    And the result of table.cell with 0; 2 text is set to "Deliverable"
    And path is prepared as temp dir under "complex_sow.docx"
    When tools.tool word extract sow structure using str representation of temp dir under "complex_sow.docx"
    Then result has type dict

  @candidate-python-coverage-boost-bbd3f73c3e
  # Native: tests/test_coverage_boost.py::TestWordSowOperations::test_analyze_template_formatting
  Scenario: Native check: analyze template formatting [TestWordSowOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "template_format.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And run is prepared as the result of para.add run with "[Guidance: Fill in project details]"
    And the result of para.add run with "[Guidance: Fill in project details]" font color rgb is set to the result of RGBColor with 0; 0; 255
    And path is prepared as temp dir under "template_format.docx"
    When tools.tool word analyze template formatting using str representation of temp dir under "template_format.docx"
    Then result has type dict

  @candidate-python-coverage-boost-6622246cdd
  # Native: tests/test_coverage_boost.py::TestPptxNotesOperations::test_get_notes_no_slide_number
  Scenario: Native check: get notes no slide number [TestPptxNotesOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "all_notes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "all_notes.pptx"
    When tools.tool pptx get notes using str representation of temp dir under "all_notes.pptx"
    Then result has type dict

  @candidate-python-coverage-boost-1ee37d3843
  # Native: tests/test_coverage_boost.py::TestWordComplexOperations::test_generate_sow_with_data
  Scenario: Native check: generate sow with data [TestWordComplexOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "sow_template.docx"
    And output is prepared as temp dir under "generated.docx"
    When tools.tool word generate sow using str representation of temp dir under "sow_template.docx"; str representation of temp dir under "generated.docx"; {"customer_name": "Contoso", "customer_short_name": "Contoso", "project_name": "Cloud Migration", "provider_name": "Microsoft", "business_objectives": [{"objective": "Migrate", "activities": "Assessment", "assumptions": "Cloud ready"}]}
    Then result has type dict

  @candidate-python-coverage-boost-5cf87cac47
  # Native: tests/test_coverage_boost.py::TestPptxCommentOperations::test_add_comment_custom_author
  Scenario: Native check: add comment custom author [TestPptxCommentOperations]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "comment_author.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Review Slide"
    And path is prepared as temp dir under "comment_author.pptx"
    When tools.tool pptx add comment using str representation of temp dir under "comment_author.pptx"; 1; "Please review this content"; author "Custom Reviewer"; x inches 2.0; y inches 2.0
    Then result has type dict

  @candidate-python-coverage-boost-cf3491e43e
  # Native: tests/test_coverage_boost.py::TestWordAuditOperations::test_audit_completion_empty
  Scenario: Native check: audit completion empty [TestWordAuditOperations]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "audit_empty.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "audit_empty.docx"
    When tools.tool word audit completion using str representation of temp dir under "audit_empty.docx"
    Then result has type dict

  @candidate-python-coverage-boost-927485be10
  # Native: tests/test_coverage_boost.py::TestPptxSetTextAutofit::test_set_autofit_shrink
  Scenario: Native check: set autofit shrink [TestPptxSetTextAutofit]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "autofit_shrink.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Long title that might need shrinking to fit properly in the space"
    And path is prepared as temp dir under "autofit_shrink.pptx"
    When tools.tool pptx set text autofit using str representation of temp dir under "autofit_shrink.pptx"; slide number 1; shape identifier "title"; autofit type "shrink"
    Then result has type dict

  @candidate-python-coverage-boost-4a8e5cb2d9
  # Native: tests/test_coverage_boost.py::TestPptxSetTextAutofit::test_set_autofit_none
  Scenario: Native check: set autofit none [TestPptxSetTextAutofit]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "autofit_none.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "autofit_none.pptx"
    When tools.tool pptx set text autofit using str representation of temp dir under "autofit_none.pptx"; slide number 1; shape identifier "title"; autofit type "none"
    Then result has type dict
