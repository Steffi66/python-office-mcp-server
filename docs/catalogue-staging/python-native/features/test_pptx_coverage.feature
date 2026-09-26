@captured @python_candidate
Feature: pptx coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-pptx-coverage-c8b3a3643d
  # Native: tests/test_pptx_coverage.py::TestAddSlideVariations::test_add_slide_at_start
  Scenario: Native check: add slide at start [TestAddSlideVariations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "start_slide.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of basic presentation; layout index 1; title "First Slide"; position "start"; output path str representation of temp dir under "start_slide.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-93b49d5212
  # Native: tests/test_pptx_coverage.py::TestAddSlideVariations::test_add_slide_at_position
  Scenario: Native check: add slide at position [TestAddSlideVariations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "positioned.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of basic presentation; layout index 1; title "Middle Slide"; position "1"; output path str representation of temp dir under "positioned.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-e2c3038259
  # Native: tests/test_pptx_coverage.py::TestPatchShapeVariations::test_patch_title
  Scenario: Native check: patch title [TestPatchShapeVariations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched_title.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of basic presentation; slide number 1; shape identifier "title"; new text "New Title Text"; output path str representation of temp dir under "patched_title.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-d416dd3f35
  # Native: tests/test_pptx_coverage.py::TestPatchShapeVariations::test_patch_subtitle
  Scenario: Native check: patch subtitle [TestPatchShapeVariations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched_subtitle.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of basic presentation; slide number 1; shape identifier "subtitle"; new text "New Subtitle"; output path str representation of temp dir under "patched_subtitle.pptx"
    Then result has type dict

  @candidate-python-pptx-coverage-eaffd532fb
  # Native: tests/test_pptx_coverage.py::TestPatchShapeVariations::test_patch_with_append
  Scenario: Native check: patch with append [TestPatchShapeVariations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "appended.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of basic presentation; slide number 1; shape identifier "title"; new text " - Appended"; append true; output path str representation of temp dir under "appended.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-107f971923
  # Native: tests/test_pptx_coverage.py::TestClearAndAddBullets::test_clear_bullets
  Scenario: Native check: clear bullets [TestClearAndAddBullets]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "cleared.pptx"
    When pptx advanced tools.tool pptx clear bullets using str representation of basic presentation; slide number 2; output path str representation of temp dir under "cleared.pptx"
    Then result has type dict

  @candidate-python-pptx-coverage-574504134e
  # Native: tests/test_pptx_coverage.py::TestClearAndAddBullets::test_add_multiple_bullets
  Scenario: Native check: add multiple bullets [TestClearAndAddBullets]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output1 is prepared as temp dir under "bullet1.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of basic presentation; slide number 2; text "First bullet"; output path str representation of temp dir under "bullet1.pptx"
    And pptx advanced tools.tool pptx add bullet using str representation of temp dir under "bullet1.pptx"; slide number 2; text "Second bullet"; output path str representation of temp dir under "bullet2.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-7aed956186
  # Native: tests/test_pptx_coverage.py::TestNotesOperations::test_get_notes_all_slides
  Scenario: Native check: get notes all slides [TestNotesOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx get notes using str representation of basic presentation
    Then result has type dict

  @candidate-python-pptx-coverage-6c1a01c0a5
  # Native: tests/test_pptx_coverage.py::TestNotesOperations::test_set_and_get_notes
  Scenario: Native check: set and get notes [TestNotesOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "with_notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of basic presentation; slide number 1; notes text "Speaker notes content"; output path str representation of temp dir under "with_notes.pptx"
    And pptx advanced tools.tool pptx get notes using str representation of temp dir under "with_notes.pptx"; slide number 1
    Then result has type dict

  @candidate-python-pptx-coverage-6d09578623
  # Native: tests/test_pptx_coverage.py::TestTableCreation::test_create_table_slide
  Scenario: Native check: create table slide [TestTableCreation]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "with_table.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Data"
    And table is prepared as the result of slide.shapes.add table with rows 2; cols 2; left the result of Inches with 1; top the result of Inches with 2; width the result of Inches with 4; height the result of Inches with 1 table
    And the result of table.cell with 0; 0 text is set to "H1"
    And the result of table.cell with 0; 1 text is set to "H2"
    And the result of table.cell with 1; 0 text is set to "V1"
    And the result of table.cell with 1; 1 text is set to "V2"
    And path is prepared as temp dir under "with_table.pptx"
    When pptx advanced tools.tool pptx get table using str representation of temp dir under "with_table.pptx"; slide number 1
    Then result has type dict

  @candidate-python-pptx-coverage-a39cc97b92
  # Native: tests/test_pptx_coverage.py::TestSlideContent::test_get_slide_content
  Scenario: Native check: get slide content [TestSlideContent]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx get slide using str representation of basic presentation; slide number 1
    Then "title" occurs in result or result has type dict

  @candidate-python-pptx-coverage-2d5df6e2d5
  # Native: tests/test_pptx_coverage.py::TestSlideContent::test_get_slide_second
  Scenario: Native check: get slide second [TestSlideContent]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx get slide using str representation of basic presentation; slide number 2
    Then result has type dict

  @candidate-python-pptx-coverage-d08b1c1736
  # Native: tests/test_pptx_coverage.py::TestLayoutOperations::test_list_masters
  Scenario: Native check: list masters [TestLayoutOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx list masters using str representation of basic presentation
    Then "default_layouts" occurs in result

  @candidate-python-pptx-coverage-259459c490
  # Native: tests/test_pptx_coverage.py::TestLayoutOperations::test_recommend_blank_layout
  Scenario: Native check: recommend blank layout [TestLayoutOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx recommend layout using str representation of basic presentation; "blank"
    Then result has type dict

  @candidate-python-pptx-coverage-f62ebcfead
  # Native: tests/test_pptx_coverage.py::TestLayoutOperations::test_recommend_comparison_layout
  Scenario: Native check: recommend comparison layout [TestLayoutOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx recommend layout using str representation of basic presentation; "comparison"
    Then result has type dict

  @candidate-python-pptx-coverage-92a42b08ae
  # Native: tests/test_pptx_coverage.py::TestCommentAddition::test_add_comment_default_position
  Scenario: Native check: add comment default position [TestCommentAddition]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "comment.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of basic presentation; slide number 1; comment text "Review this slide"; output path str representation of temp dir under "comment.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-2682244a90
  # Native: tests/test_pptx_coverage.py::TestCommentAddition::test_add_comment_custom_position
  Scenario: Native check: add comment custom position [TestCommentAddition]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "comment_pos.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of basic presentation; slide number 1; comment text "Check this area"; x inches 5.0; y inches 3.0; author "Reviewer"; output path str representation of temp dir under "comment_pos.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-3bbbdbd737
  # Native: tests/test_pptx_coverage.py::TestSlideHiding::test_unhide_slide
  Scenario: Native check: unhide slide [TestSlideHiding]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output1 is prepared as temp dir under "hidden.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of basic presentation; slide number 2; hidden true; output path str representation of temp dir under "hidden.pptx"
    And pptx advanced tools.tool pptx hide slide using str representation of temp dir under "hidden.pptx"; slide number 2; hidden false; output path str representation of temp dir under "unhidden.pptx"
    Then result has type dict

  @candidate-python-pptx-coverage-19ee72b28b
  # Native: tests/test_pptx_coverage.py::TestTextAutofit::test_autofit_none
  Scenario: Native check: autofit none [TestTextAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "autofit_none.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of basic presentation; slide number 1; shape identifier "title"; autofit type "none"; output path str representation of temp dir under "autofit_none.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-2196c941f8
  # Native: tests/test_pptx_coverage.py::TestTextAutofit::test_autofit_resize
  Scenario: Native check: autofit resize [TestTextAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "autofit_resize.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of basic presentation; slide number 1; shape identifier "title"; autofit type "resize"; output path str representation of temp dir under "autofit_resize.pptx"
    Then result field "success" is true

  @candidate-python-pptx-coverage-9b23933a6a
  # Native: tests/test_pptx_coverage.py::TestAuditPlaceholderPatterns::test_audit_with_custom_patterns
  Scenario: Native check: audit with custom patterns [TestAuditPlaceholderPatterns]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "custom_patterns.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "ACME Corp - {{date}}"
    And path is prepared as temp dir under "custom_patterns.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "custom_patterns.pptx"; patterns ["\\{\\{.*?\\}\\}"]
    Then result has type dict

  @candidate-python-pptx-coverage-1b6e7a7be0
  # Native: tests/test_pptx_coverage.py::TestErrorCases::test_invalid_layout_index
  Scenario: Native check: invalid layout index [TestErrorCases]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "invalid_layout.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of basic presentation; layout index 999; output path str representation of temp dir under "invalid_layout.pptx"
    Then result has type dict

  @candidate-python-pptx-coverage-0465739e7b
  # Native: tests/test_pptx_coverage.py::TestErrorCases::test_get_nonexistent_table
  Scenario: Native check: get nonexistent table [TestErrorCases]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx get table using str representation of basic presentation; slide number 1; table index 0
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase or "tables" does not occur in str representation of result

  @candidate-python-pptx-coverage-9bf0e074ad
  # Native: tests/test_pptx_coverage.py::TestListOperations::test_list_slides
  Scenario: Native check: list slides [TestListOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx list slides using str representation of basic presentation
    Then result field "slide_count", defaulting to 0 is at least 2

  @candidate-python-pptx-coverage-95cd2e9e04
  # Native: tests/test_pptx_coverage.py::TestListOperations::test_list_shapes
  Scenario: Native check: list shapes [TestListOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create a basic presentation.
    When pptx advanced tools.tool pptx list shapes using str representation of basic presentation; slide number 1
    Then "shapes" occurs in result

  @candidate-python-pptx-coverage-d9d3ac2b19
  # Native: tests/test_pptx_coverage.py::TestExtractAndConvert::test_extract_presentation
  Scenario: Native check: extract presentation [TestExtractAndConvert]
    Given Create an instance of PowerPointTools.
    And Create a basic presentation.
    When pptx tools.tool pptx extract using str representation of basic presentation
    Then result has type dict
    And "slides" occurs in result

  @candidate-python-pptx-coverage-5537fcd4e0
  # Native: tests/test_pptx_coverage.py::TestExtractAndConvert::test_to_markdown
  Scenario: Native check: to markdown [TestExtractAndConvert]
    Given Create an instance of PowerPointTools.
    And Create a basic presentation.
    When pptx tools.tool pptx to markdown using str representation of basic presentation
    Then "Main Title" occurs in result
