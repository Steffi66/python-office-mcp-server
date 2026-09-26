@captured @python_candidate
Feature: high volume native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-high-volume-46f24d601c
  # Native: tests/test_high_volume.py::TestWordGetSection::test_get_first_section
  Scenario: Native check: get first section [TestWordGetSection]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sections.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "sections.docx"; "Introduction"
    Then result has type dict
    And "content" occurs in result or "error" does not occur in result

  @candidate-python-high-volume-4ec69e882d
  # Native: tests/test_high_volume.py::TestWordGetSection::test_get_last_section
  Scenario: Native check: get last section [TestWordGetSection]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "last_section.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "last_section.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "last_section.docx"; "Last Section"
    Then result has type dict

  @candidate-python-high-volume-ee68b27866
  # Native: tests/test_high_volume.py::TestWordGetSection::test_get_nonexistent_section
  Scenario: Native check: get nonexistent section [TestWordGetSection]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_section.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_section.docx"
    When word advanced tools.tool word get section using str representation of temp dir under "no_section.docx"; "NonexistentSection"
    Then result has type dict

  @candidate-python-high-volume-7b02ad3a33
  # Native: tests/test_high_volume.py::TestWordPatchTableRow::test_patch_first_data_row
  Scenario: Native check: patch first data row [TestWordPatchTableRow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "patch_row.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 2
    And the result of table.cell with 0; 0 text is set to "Name"
    And the result of table.cell with 0; 1 text is set to "Value"
    And the result of table.cell with 1; 0 text is set to "Original"
    And the result of table.cell with 1; 1 text is set to "Data"
    And the result of table.cell with 2; 0 text is set to "More"
    And the result of table.cell with 2; 1 text is set to "Data2"
    And path is prepared as temp dir under "patch_row.docx"
    And output is prepared as temp dir under "patched.docx"
    When word advanced tools.tool word patch table row using str representation of temp dir under "patch_row.docx"; "0"; 1; {"Name": "Updated", "Value": "NewData"}; output path str representation of temp dir under "patched.docx"
    Then result has type dict

  @candidate-python-high-volume-e5001bb26e
  # Native: tests/test_high_volume.py::TestWordPatchTableRow::test_patch_last_row
  Scenario: Native check: patch last row [TestWordPatchTableRow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "last_row.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 4; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "last_row.docx"
    When word advanced tools.tool word patch table row using str representation of temp dir under "last_row.docx"; "0"; 3; {"A": "Z1", "B": "Z2"}
    Then result has type dict

  @candidate-python-high-volume-818558dc52
  # Native: tests/test_high_volume.py::TestWordListTables::test_list_multiple_tables
  Scenario: Native check: list multiple tables [TestWordListTables]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "multi_table.docx"
    And doc is prepared as the result of Document with no arguments
    And t1 is prepared as the result of doc.add table with rows 2; cols 2
    And the result of t1.cell with 0; 0 text is set to "T1A"
    And the result of t1.cell with 0; 1 text is set to "T1B"
    And t2 is prepared as the result of doc.add table with rows 3; cols 3
    And the result of t2.cell with 0; 0 text is set to "T2X"
    And the result of t2.cell with 0; 1 text is set to "T2Y"
    And the result of t2.cell with 0; 2 text is set to "T2Z"
    And path is prepared as temp dir under "multi_table.docx"
    When word advanced tools.tool word list tables using str representation of temp dir under "multi_table.docx"
    Then result has type dict
    And "tables" occurs in result or "table_count" occurs in result

  @candidate-python-high-volume-ff464af15e
  # Native: tests/test_high_volume.py::TestWordListTables::test_list_tables_empty_doc
  Scenario: Native check: list tables empty doc [TestWordListTables]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_tables.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_tables.docx"
    When word advanced tools.tool word list tables using str representation of temp dir under "no_tables.docx"
    Then result has type dict

  @candidate-python-high-volume-f617b75c5c
  # Native: tests/test_high_volume.py::TestPptxGetSlide::test_get_slide_with_all_content
  Scenario: Native check: get slide with all content [TestPptxGetSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "full_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And title is prepared as the result of slide.shapes.add textbox with the result of PptxInches with 0.5; the result of PptxInches with 0.3; the result of PptxInches with 9; the result of PptxInches with 1
    And the result of slide.shapes.add textbox with the result of PptxInches with 0.5; the result of PptxInches with 0.3; the result of PptxInches with 9; the result of PptxInches with 1 text frame paragraphs at 0 text is set to "Test Title"
    And table is prepared as the result of slide.shapes.add table with 3; 2; the result of PptxInches with 0.5; the result of PptxInches with 1.5; the result of PptxInches with 5; the result of PptxInches with 2
    And tbl is prepared as the result of slide.shapes.add table with 3; 2; the result of PptxInches with 0.5; the result of PptxInches with 1.5; the result of PptxInches with 5; the result of PptxInches with 2 table
    And the result of tbl.cell with 0; 0 text is set to "H1"
    And the result of tbl.cell with 0; 1 text is set to "H2"
    And the result of tbl.cell with 1; 0 text is set to "R1C1"
    And the result of tbl.cell with 1; 1 text is set to "R1C2"
    And path is prepared as temp dir under "full_slide.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "full_slide.pptx"; 1
    Then result has type dict

  @candidate-python-high-volume-5444e1de33
  # Native: tests/test_high_volume.py::TestPptxGetSlide::test_get_slide_beyond_range
  Scenario: Native check: get slide beyond range [TestPptxGetSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "one_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "one_slide.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "one_slide.pptx"; 99
    Then "error" occurs in result

  @candidate-python-high-volume-0ca02f27d9
  # Native: tests/test_high_volume.py::TestPptxListShapes::test_list_shapes_various_types
  Scenario: Native check: list shapes various types [TestPptxListShapes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "shapes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 6
    And path is prepared as temp dir under "shapes.pptx"
    When pptx advanced tools.tool pptx list shapes using str representation of temp dir under "shapes.pptx"; 1
    Then result has type dict
    And "shapes" occurs in result

  @candidate-python-high-volume-7f771095ed
  # Native: tests/test_high_volume.py::TestPptxReplaceText::test_replace_text_in_shapes
  Scenario: Native check: replace text in shapes [TestPptxReplaceText]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "replace.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Hello <NAME>"
    And path is prepared as temp dir under "replace.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "replace.pptx"; "<NAME>"; "John"; output path str representation of temp dir under "replaced.pptx"
    Then result has type dict

  @candidate-python-high-volume-6268369d17
  # Native: tests/test_high_volume.py::TestPptxReplaceText::test_replace_text_not_found
  Scenario: Native check: replace text not found [TestPptxReplaceText]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_match.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "No placeholder here"
    And path is prepared as temp dir under "no_match.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "no_match.pptx"; "<NONEXISTENT>"; "Value"
    Then result has type dict

  @candidate-python-high-volume-1cb6f8a895
  # Native: tests/test_high_volume.py::TestPptxSetNotes::test_set_notes_new
  Scenario: Native check: set notes new [TestPptxSetNotes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Slide Title"
    And path is prepared as temp dir under "notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of temp dir under "notes.pptx"; 1; "These are the speaker notes.\nWith multiple lines."
    Then result has type dict

  @candidate-python-high-volume-676b50d2a5
  # Native: tests/test_high_volume.py::TestPptxSetNotes::test_append_notes
  Scenario: Native check: append notes [TestPptxSetNotes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "append_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And notes slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Existing notes"
    And path is prepared as temp dir under "append_notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of temp dir under "append_notes.pptx"; 1; "Additional notes"; append true
    Then result has type dict

  @candidate-python-high-volume-bb97d27c5c
  # Native: tests/test_high_volume.py::TestPptxGetNotes::test_get_notes_single_slide
  Scenario: Native check: get notes single slide [TestPptxGetNotes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "get_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And notes slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Test notes content"
    And path is prepared as temp dir under "get_notes.pptx"
    When pptx advanced tools.tool pptx get notes using str representation of temp dir under "get_notes.pptx"; slide number 1
    Then result has type dict

  @candidate-python-high-volume-68bcd8d447
  # Native: tests/test_high_volume.py::TestPptxGetNotes::test_get_notes_all_slides
  Scenario: Native check: get notes all slides [TestPptxGetNotes]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "all_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "all_notes.pptx"
    When pptx advanced tools.tool pptx get notes using str representation of temp dir under "all_notes.pptx"
    Then result has type dict

  @candidate-python-high-volume-d325261ee6
  # Native: tests/test_high_volume.py::TestPptxGetTable::test_get_table_content
  Scenario: Native check: get table content [TestPptxGetTable]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "table_content.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table shape is prepared as the result of slide.shapes.add table with 4; 3; the result of PptxInches with 1; the result of PptxInches with 1.5; the result of PptxInches with 8; the result of PptxInches with 3
    And tbl is prepared as the result of slide.shapes.add table with 4; 3; the result of PptxInches with 1; the result of PptxInches with 1.5; the result of PptxInches with 8; the result of PptxInches with 3 table
    And the result of tbl.cell with 0; 0 text is set to "Name"
    And the result of tbl.cell with 0; 1 text is set to "Role"
    And the result of tbl.cell with 0; 2 text is set to "Hours"
    And the result of tbl.cell with 1; 0 text is set to "Alice"
    And the result of tbl.cell with 1; 1 text is set to "Dev"
    And the result of tbl.cell with 1; 2 text is set to "40"
    And the result of tbl.cell with 2; 0 text is set to "Bob"
    And the result of tbl.cell with 2; 1 text is set to "QA"
    And the result of tbl.cell with 2; 2 text is set to "30"
    And path is prepared as temp dir under "table_content.pptx"
    When pptx advanced tools.tool pptx get table using str representation of temp dir under "table_content.pptx"; 1
    Then result has type dict

  @candidate-python-high-volume-e88fbed526
  # Native: tests/test_high_volume.py::TestPptxHideSlide::test_hide_slide
  Scenario: Native check: hide slide [TestPptxHideSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "hide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "hide.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of temp dir under "hide.pptx"; 2; hidden true
    Then result has type dict

  @candidate-python-high-volume-e2953ae3e9
  # Native: tests/test_high_volume.py::TestPptxHideSlide::test_unhide_slide
  Scenario: Native check: unhide slide [TestPptxHideSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "unhide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Hidden Slide"
    And path is prepared as temp dir under "unhide.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of temp dir under "unhide.pptx"; 1; hidden false
    Then result has type dict

  @candidate-python-high-volume-475009b747
  # Native: tests/test_high_volume.py::TestPptxGetHiddenSlides::test_get_hidden_slides
  Scenario: Native check: get hidden slides [TestPptxGetHiddenSlides]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "mixed_hidden.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "mixed_hidden.pptx"
    When pptx advanced tools.tool pptx get hidden slides using str representation of temp dir under "mixed_hidden.pptx"
    Then result has type dict

  @candidate-python-high-volume-0e9e634556
  # Native: tests/test_high_volume.py::TestPptxDuplicateSlide::test_duplicate_slide_after
  Scenario: Native check: duplicate slide after [TestPptxDuplicateSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "dup.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Original Slide"
    And path is prepared as temp dir under "dup.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of temp dir under "dup.pptx"; 1; position "after"
    Then result has type dict

  @candidate-python-high-volume-08c20d18b5
  # Native: tests/test_high_volume.py::TestPptxDuplicateSlide::test_duplicate_slide_end
  Scenario: Native check: duplicate slide end [TestPptxDuplicateSlide]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "dup_end.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "dup_end.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of temp dir under "dup_end.pptx"; 1; position "end"
    Then result has type dict

  @candidate-python-high-volume-f8b122f030
  # Native: tests/test_high_volume.py::TestPptxAnalyzeLayouts::test_analyze_layouts
  Scenario: Native check: analyze layouts [TestPptxAnalyzeLayouts]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "layouts.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "layouts.pptx"
    When pptx advanced tools.tool pptx analyze layouts using str representation of temp dir under "layouts.pptx"
    Then result has type dict

  @candidate-python-high-volume-5465e20c3f
  # Native: tests/test_high_volume.py::TestPptxRecommendLayout::test_recommend_layout
  Scenario: Native check: recommend layout [TestPptxRecommendLayout]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And a prepared layout name input or fixture
    And prs.save with temp dir under text rec_{layout name}.pptx
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under text rec_{layout name}.pptx
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [title] | {"layout_name": "'title'"} |
      | [bullets] | {"layout_name": "'bullets'"} |
      | [table] | {"layout_name": "'table'"} |
    When pptx advanced tools.tool pptx recommend layout using str representation of temp dir under text rec_{layout name}.pptx; layout name
    Then result has type dict

  @candidate-python-high-volume-c161b80ce2
  # Native: tests/test_high_volume.py::TestPptxAddComment::test_add_comment_default_position
  Scenario: Native check: add comment default position [TestPptxAddComment]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "comment_default.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Slide with comment"
    And path is prepared as temp dir under "comment_default.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of temp dir under "comment_default.pptx"; 1; "This is a review comment."
    Then result has type dict

  @candidate-python-high-volume-f8e43db61c
  # Native: tests/test_high_volume.py::TestPptxAddComment::test_add_comment_custom_position
  Scenario: Native check: add comment custom position [TestPptxAddComment]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "comment_pos.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Positioned comment"
    And path is prepared as temp dir under "comment_pos.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of temp dir under "comment_pos.pptx"; 1; "Comment at custom location"; x inches 5.0; y inches 3.0; author "Test Author"
    Then result has type dict

  @candidate-python-high-volume-f3b0814d36
  # Native: tests/test_high_volume.py::TestPptxGetComments::test_get_comments_empty
  Scenario: Native check: get comments empty [TestPptxGetComments]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_comments.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "No comments"
    And path is prepared as temp dir under "no_comments.pptx"
    When pptx advanced tools.tool pptx get comments using str representation of temp dir under "no_comments.pptx"
    Then result has type dict

  @candidate-python-high-volume-8e8c9bb784
  # Native: tests/test_high_volume.py::TestPptxAuditPlaceholders::test_audit_with_placeholders
  Scenario: Native check: audit with placeholders [TestPptxAuditPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "audit.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Hello <Customer Name>"
    And path is prepared as temp dir under "audit.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "audit.pptx"
    Then result has type dict

  @candidate-python-high-volume-34f9894ecb
  # Native: tests/test_high_volume.py::TestPptxAuditPlaceholders::test_audit_no_placeholders
  Scenario: Native check: audit no placeholders [TestPptxAuditPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "clean_audit.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Clean Title"
    And path is prepared as temp dir under "clean_audit.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "clean_audit.pptx"
    Then result has type dict
