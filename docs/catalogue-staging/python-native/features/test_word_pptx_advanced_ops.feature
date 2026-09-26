@captured @python_candidate
Feature: word pptx advanced ops native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-pptx-advanced-ops-05aaca33c9
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordPromptFunctions::test_prompt_helpers
  Scenario: Native check: prompt helpers [TestWordPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And a prepared method input or fixture
    And a prepared args input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [prompt_sow_data-args0] | {"method": "'prompt_sow_data'", "args": "[]"} |
      | [prompt_sow_section-args1] | {"method": "'prompt_sow_section'", "args": "['Test Section']"} |
    When getattr(word advanced tools, method) using expanded args
    Then when word advanced tools has attribute method, the result of getattr(word advanced tools, method) with expanded args is not null

  @candidate-python-word-pptx-advanced-ops-387d59acdc
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordTrackChangesOperations::test_enable_track_changes_output
  Scenario: Native check: enable track changes output [TestWordTrackChangesOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "track_input.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track_input.docx"
    And output is prepared as temp dir under "track_output.docx"
    When word advanced tools.tool word enable track changes using str representation of temp dir under "track_input.docx"; output path str representation of temp dir under "track_output.docx"
    Then result has type dict
    And the result of Path with temp dir under "track_output.docx" exists is non-empty or true

  @candidate-python-word-pptx-advanced-ops-efec4d6606
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordTrackChangesOperations::test_patch_with_track_changes_complex
  Scenario: Native check: patch with track changes complex [TestWordTrackChangesOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "multi_patch.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "multi_patch.docx"
    And output is prepared as temp dir under "patched_output.docx"
    When word advanced tools.tool word patch with track changes using str representation of temp dir under "multi_patch.docx"; {"<Customer Name>": "Contoso Ltd", "<Project Name>": "Cloud Migration"}; author "Test Author"; output path str representation of temp dir under "patched_output.docx"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-a8b526daf3
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordTableCreation::test_create_table_after_section
  Scenario: Native check: create table after section [TestWordTableCreation]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "with_section.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "with_section.docx"
    When word advanced tools.tool word create new table using str representation of temp dir under "with_section.docx"; ["Item", "Description", "Status"]; [{"Item": "A", "Description": "First", "Status": "Done"}]; insert after section "Data Section"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-3c7ded046e
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxSlideOperations::test_add_slide_with_layout_index
  Scenario: Native check: add slide with layout index [TestPptxSlideOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "layout_test.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "layout_test.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of temp dir under "layout_test.pptx"; layout index 5; title "Custom Layout"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-216ff648d3
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxSlideOperations::test_duplicate_slide_position_after
  Scenario: Native check: duplicate slide position after [TestPptxSlideOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "dup_after.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "First"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Second"
    And path is prepared as temp dir under "dup_after.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of temp dir under "dup_after.pptx"; 1; position "after"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-40518414fa
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxShapeOperations::test_list_shapes_with_table
  Scenario: Native check: list shapes with table [TestPptxShapeOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "with_table.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Title"
    And path is prepared as temp dir under "with_table.pptx"
    When pptx advanced tools.tool pptx list shapes using str representation of temp dir under "with_table.pptx"; 1
    Then result has type dict
    And at least one item satisfies s field "has_table" for each s in result field "shapes", defaulting to [] or the number of entries in result field "shapes", defaulting to [] exceeds 0

  @candidate-python-word-pptx-advanced-ops-4032a94685
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxShapeOperations::test_patch_shape_body
  Scenario: Native check: patch shape body [TestPptxShapeOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "patch_body.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "patch_body.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of temp dir under "patch_body.pptx"; slide number 1; shape identifier "body"; new text "Updated body content"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-01d0e211dc
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxReplaceOperations::test_replace_text_specific_slide
  Scenario: Native check: replace text specific slide [TestPptxReplaceOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "specific_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> Slide 1"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> Slide 2"
    And path is prepared as temp dir under "specific_slide.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "specific_slide.pptx"; "<Customer>"; "Contoso"; slide number 1
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-964eed398a
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxReplaceOperations::test_replace_placeholders_multiple
  Scenario: Native check: replace placeholders multiple [TestPptxReplaceOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "multi_replace.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Company> - <Project>"
    And path is prepared as temp dir under "multi_replace.pptx"
    When pptx advanced tools.tool pptx replace placeholders using str representation of temp dir under "multi_replace.pptx"; {"<Company>": "Contoso", "<Project>": "Migration"}
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-895995c6d6
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxLayoutOperations::test_recommend_layout
  Scenario: Native check: recommend layout [TestPptxLayoutOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And a prepared layout name input or fixture
    And prs.save with temp dir under text rec_{layout name}.pptx
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under text rec_{layout name}.pptx
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [comparison] | {"layout_name": "'comparison'"} |
      | [blank] | {"layout_name": "'blank'"} |
    When pptx advanced tools.tool pptx recommend layout using str representation of temp dir under text rec_{layout name}.pptx; layout name
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-8ba3f4f594
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordSowOperations::test_extract_sow_structure_complex
  Scenario: Native check: extract sow structure complex [TestWordSowOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "complex_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And the result of table.cell with 0; 0 text is set to "Phase"
    And the result of table.cell with 0; 1 text is set to "Duration"
    And the result of table.cell with 0; 2 text is set to "Deliverable"
    And path is prepared as temp dir under "complex_sow.docx"
    When word advanced tools.tool word extract sow structure using str representation of temp dir under "complex_sow.docx"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-d7e13faae4
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordSowOperations::test_analyze_template_formatting
  Scenario: Formatting analysis of blue guidance text returns a dictionary without classification assertions
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved document with level-1 heading "<Project Name>"
    And a paragraph containing "[Guidance: Fill in project details]" in a run coloured RGB 0, 0, 255
    And paragraphs "Standard content here" and "<Customer Name> is the customer"
    When tool_word_analyze_template_formatting reads that saved document
    Then the result is a dictionary, including an error dictionary

  @candidate-python-word-pptx-advanced-ops-b86a4362b4
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxNotesOperations::test_get_notes_no_slide_number
  Scenario: Native check: get notes no slide number [TestPptxNotesOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "all_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "all_notes.pptx"
    When pptx advanced tools.tool pptx get notes using str representation of temp dir under "all_notes.pptx"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-be648375fd
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordComplexOperations::test_generate_sow_with_data
  Scenario: Native check: generate sow with data [TestWordComplexOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sow_template.docx"
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "sow_template.docx"
    And output is prepared as temp dir under "generated.docx"
    When word advanced tools.tool word generate sow using str representation of temp dir under "sow_template.docx"; str representation of temp dir under "generated.docx"; {"customer_name": "Contoso", "customer_short_name": "Contoso", "project_name": "Cloud Migration", "provider_name": "Microsoft", "business_objectives": [{"objective": "Migrate", "activities": "Assessment", "assumptions": "Cloud ready"}]}
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-fec4e66cb4
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxCommentOperations::test_add_comment_custom_author
  Scenario: Native check: add comment custom author [TestPptxCommentOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "comment_author.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Review Slide"
    And path is prepared as temp dir under "comment_author.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of temp dir under "comment_author.pptx"; 1; "Please review this content"; author "Custom Reviewer"; x inches 2.0; y inches 2.0
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-c076e208ac
  # Native: tests/test_word_pptx_advanced_ops.py::TestWordAuditOperations::test_audit_completion_empty
  Scenario: Native check: audit completion empty [TestWordAuditOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "audit_empty.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "audit_empty.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "audit_empty.docx"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-992fcd90d5
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxSetTextAutofit::test_set_autofit_shrink
  Scenario: Native check: set autofit shrink [TestPptxSetTextAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "autofit_shrink.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Long title that might need shrinking to fit properly in the space"
    And path is prepared as temp dir under "autofit_shrink.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of temp dir under "autofit_shrink.pptx"; slide number 1; shape identifier "title"; autofit type "shrink"
    Then result has type dict

  @candidate-python-word-pptx-advanced-ops-4f2f75dc5f
  # Native: tests/test_word_pptx_advanced_ops.py::TestPptxSetTextAutofit::test_set_autofit_none
  Scenario: Native check: set autofit none [TestPptxSetTextAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "autofit_none.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "autofit_none.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of temp dir under "autofit_none.pptx"; slide number 1; shape identifier "title"; autofit type "none"
    Then result has type dict
