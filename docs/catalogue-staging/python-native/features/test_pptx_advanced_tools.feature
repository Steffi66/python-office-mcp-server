@captured @python_candidate
Feature: pptx advanced tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-pptx-advanced-tools-e06a775e6b
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_get_shape_info
  Scenario: Native check: get shape info [TestHelperFunctions]
    Given Create a test presentation with multiple slides.
    And prs is prepared as the result of Presentation with sample pptx
    And slide is prepared as the result of Presentation with sample pptx slides at 0
    When get shape info using shape
    Then "name" occurs in the result of get shape info with shape
    And "shape_id" occurs in the result of get shape info with shape
    And "is_placeholder" occurs in the result of get shape info with shape

  @candidate-python-pptx-advanced-tools-169e230ad8
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_find_shape_by_title
  Scenario: Native check: find shape by title [TestHelperFunctions]
    Given Create a test presentation with multiple slides.
    And prs is prepared as the result of Presentation with sample pptx
    And slide is prepared as the result of Presentation with sample pptx slides at 0
    And shape is prepared as the result of find shape by identifier with the result of Presentation with sample pptx slides at 0; "title"
    When find shape by identifier using the result of Presentation with sample pptx slides at 0; "title"
    Then the result of find shape by identifier with the result of Presentation with sample pptx slides at 0; "title" is not null

  @candidate-python-pptx-advanced-tools-0b6f2f823e
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_find_shape_by_body
  Scenario: Native check: find shape by body [TestHelperFunctions]
    Given Create a test presentation with multiple slides.
    And prs is prepared as the result of Presentation with sample pptx
    And slide is prepared as the result of Presentation with sample pptx slides at 1
    And shape is prepared as the result of find shape by identifier with the result of Presentation with sample pptx slides at 1; "body"
    When find shape by identifier using the result of Presentation with sample pptx slides at 1; "body"
    Then the result of find shape by identifier with the result of Presentation with sample pptx slides at 1; "body" is not null

  @candidate-python-pptx-advanced-tools-1379349dbd
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_find_shape_by_index
  Scenario: Native check: find shape by index [TestHelperFunctions]
    Given Create a test presentation with multiple slides.
    And prs is prepared as the result of Presentation with sample pptx
    And slide is prepared as the result of Presentation with sample pptx slides at 0
    And shape is prepared as the result of find shape by identifier with the result of Presentation with sample pptx slides at 0; "0"
    When find shape by identifier using the result of Presentation with sample pptx slides at 0; "0"
    Then the result of find shape by identifier with the result of Presentation with sample pptx slides at 0; "0" is not null

  @candidate-python-pptx-advanced-tools-e8a065f158
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_find_table_in_slide
  Scenario: Native check: find table in slide [TestHelperFunctions]
    Given Create a test presentation with multiple slides.
    And prs is prepared as the result of Presentation with sample pptx
    And slide is prepared as the result of Presentation with sample pptx slides at 2
    When find table in slide using the result of Presentation with sample pptx slides at 2
    Then table is not null
    And table shape is not null

  @candidate-python-pptx-advanced-tools-bf9cfe728c
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_classify_layout
  Scenario: Native check: classify layout [TestHelperFunctions]
    Given the native classify layout inputs and isolated test state
    When the classify layout behavior is exercised with its prepared inputs
    Then the result of classify layout with ["CENTER_TITLE (3)", "SUBTITLE (4)"]; "Title Slide" equals "title_slide"
    And the result of classify layout with ["TITLE (1)", "BODY (2)"]; "Title and Content" equals "title_and_content"
    And the result of classify layout with []; "Blank" equals "blank"

  @candidate-python-pptx-advanced-tools-71db233f56
  # Native: tests/test_pptx_advanced_tools.py::TestHelperFunctions::test_get_layout_recommendations
  Scenario: Native check: get layout recommendations [TestHelperFunctions]
    Given recs is prepared as the result of get layout recommendations with "title_slide"
    When get layout recommendations using "title_slide"
    Then the result of get layout recommendations with "title_slide" has type list
    And the number of entries in the result of get layout recommendations with "title_slide" exceeds 0

  @candidate-python-pptx-advanced-tools-e2b37ba237
  # Native: tests/test_pptx_advanced_tools.py::TestListSlides::test_lists_all_slides
  Scenario: Native check: lists all slides [TestListSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx list slides using str representation of sample pptx
    Then result field "slide_count" equals 3
    And the number of entries in result field "slides", defaulting to [] equals 3

  @candidate-python-pptx-advanced-tools-b89864d914
  # Native: tests/test_pptx_advanced_tools.py::TestListSlides::test_includes_slide_titles
  Scenario: Native check: includes slide titles [TestListSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx list slides using str representation of sample pptx
    Then "Test Presentation" occurs in s field "title" for each s in result field "slides", defaulting to []

  @candidate-python-pptx-advanced-tools-f6216541fa
  # Native: tests/test_pptx_advanced_tools.py::TestListSlides::test_file_not_found
  Scenario: Native check: file not found [TestListSlides]
    Given Create an instance of PresentationAdvancedTools.
    When pptx advanced tools.tool pptx list slides using "/nonexistent.pptx"
    Then "error" occurs in result

  @candidate-python-pptx-advanced-tools-ff96617cda
  # Native: tests/test_pptx_advanced_tools.py::TestListShapes::test_lists_shapes
  Scenario: Native check: lists shapes [TestListShapes]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx list shapes using str representation of sample pptx; 1
    Then "shapes" occurs in result
    And the number of entries in result at "shapes" exceeds 0

  @candidate-python-pptx-advanced-tools-be148180a2
  # Native: tests/test_pptx_advanced_tools.py::TestListShapes::test_invalid_slide_number
  Scenario: Native check: invalid slide number [TestListShapes]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx list shapes using str representation of sample pptx; 100
    Then "error" occurs in result

  @candidate-python-pptx-advanced-tools-a63d6852c9
  # Native: tests/test_pptx_advanced_tools.py::TestGetSlide::test_gets_slide_content
  Scenario: Native check: gets slide content [TestGetSlide]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx get slide using str representation of sample pptx; 1
    Then result field "slide", defaulting to result field "title" equals "Test Presentation" or "Test Presentation" occurs in str representation of result

  @candidate-python-pptx-advanced-tools-03f44e4316
  # Native: tests/test_pptx_advanced_tools.py::TestGetSlide::test_gets_table_content
  Scenario: Native check: gets table content [TestGetSlide]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx get slide using str representation of sample pptx; 3
    Then "tables" occurs in result field "slide", defaulting to result

  @candidate-python-pptx-advanced-tools-2978ea684e
  # Native: tests/test_pptx_advanced_tools.py::TestPatchShape::test_updates_title
  Scenario: Native check: updates title [TestPatchShape]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of sample pptx; 1; "title"; new text "New Title"; output path str representation of temp dir under "patched.pptx"
    Then result field "success" is true
    And the result of Presentation with temp dir under "patched.pptx" slides at 0 shapes title text equals "New Title"

  @candidate-python-pptx-advanced-tools-6b32b859c7
  # Native: tests/test_pptx_advanced_tools.py::TestPatchShape::test_updates_body
  Scenario: Native check: updates body [TestPatchShape]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched_body.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of sample pptx; 2; "body"; new text "Updated bullet"; output path str representation of temp dir under "patched_body.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-fa6b261e45
  # Native: tests/test_pptx_advanced_tools.py::TestNotes::test_set_notes
  Scenario: Native check: set notes [TestNotes]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of sample pptx; 1; "These are speaker notes"; output path str representation of temp dir under "notes.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-5b581cb115
  # Native: tests/test_pptx_advanced_tools.py::TestNotes::test_get_notes
  Scenario: Native check: get notes [TestNotes]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "notes2.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of sample pptx; 1; "Test notes content"; output path str representation of temp dir under "notes2.pptx"
    And pptx advanced tools.tool pptx get notes using str representation of temp dir under "notes2.pptx"; 1
    Then "Test notes content" occurs in result field "notes", defaulting to ""

  @candidate-python-pptx-advanced-tools-e7ef612a7d
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_add_comment
  Scenario: Native check: add comment [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "commented.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "This is a test comment"; x inches 1.0; y inches 1.0; output path str representation of temp dir under "commented.pptx"
    Then result field "success" is true
    And result field "position", defaulting to {} field "x_inches" equals 1.0
    And result field "position", defaulting to {} field "y_inches" equals 1.0

  @candidate-python-pptx-advanced-tools-c177c04bb4
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_comment_default_position
  Scenario: Native check: comment default position [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "comment_default.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "Test comment"; output path str representation of temp dir under "comment_default.pptx"
    Then result field "success" is true
    And result field "position", defaulting to {} field "x_inches" equals 1.0
    And result field "position", defaulting to {} field "y_inches" equals 1.0

  @candidate-python-pptx-advanced-tools-c51b25dfed
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_get_comments
  Scenario: Native check: get comments [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "get_comments.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "Retrievable comment"; output path str representation of temp dir under "get_comments.pptx"
    And pptx advanced tools.tool pptx get comments using str representation of temp dir under "get_comments.pptx"; 1
    Then result field "total_comments" is at least 1

  @candidate-python-pptx-advanced-tools-aa2138504c
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_get_comments_from_fixture_comments_pptx
  Scenario: Native check: get comments from fixture comments pptx [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And file.write bytes with saved bytes of TEMPLATES under "testdata/pptx/comments.pptx"
    And fixture path is prepared as TEMPLATES under "testdata/pptx/comments.pptx"
    And file is prepared as temp dir under "fixture_comments.pptx"
    When pptx advanced tools.tool pptx get comments using str representation of temp dir under "fixture_comments.pptx"; 1
    Then "error" does not occur in result
    And result field "total_comments", defaulting to 0 is at least 1
    And result field "comments", defaulting to {} field 1, defaulting to [] is non-empty or true
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "format" equals "modern"
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "author" equals "Rui Carmo"
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "text" equals "I don't remember it having yellow eyes"

  @candidate-python-pptx-advanced-tools-9d9dedb121
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_add_comment_with_none_author
  Scenario: Native check: add comment with none author [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "comment_none_author.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "Author fallback"; author null; output path str representation of temp dir under "comment_none_author.pptx"
    Then "error" does not occur in result

  @candidate-python-pptx-advanced-tools-c8e8f2951a
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_delete_comment_by_index
  Scenario: Native check: delete comment by index [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "delete_comment_one.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "Delete one"; output path str representation of temp dir under "delete_comment_one.pptx"
    And pptx advanced tools.tool pptx get comments using str representation of temp dir under "delete_comment_one.pptx"; 1
    And pptx advanced tools.tool pptx delete comment using str representation of temp dir under "delete_comment_one.pptx"; 1; comment index int representation of comments at "comments" at 1 at 0 at "index"
    Then comments field "total_comments", defaulting to 0 is at least 1
    And result field "success" is true

  @candidate-python-pptx-advanced-tools-849b9e0c40
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_delete_all_comments_on_slide
  Scenario: Native check: delete all comments on slide [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "delete_comment_all.pptx"
    When pptx advanced tools.tool pptx add comment using str representation of sample pptx; 1; "Delete all"; output path str representation of temp dir under "delete_comment_all.pptx"
    And pptx advanced tools.tool pptx delete comment using str representation of temp dir under "delete_comment_all.pptx"; 1
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-99da920c63
  # Native: tests/test_pptx_advanced_tools.py::TestComments::test_get_modern_comments
  Scenario: Native check: get modern comments [TestComments]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "modern_comments.pptx"
    When pptx advanced tools.tool pptx get comments using str representation of temp dir under "modern_comments.pptx"; 1
    Then result field "total_comments", defaulting to 0 is at least 1
    And result field "comments", defaulting to {} field 1, defaulting to [] is non-empty or true
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "author" equals "GLASSON, Emma"
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "text" equals "modern comment text"
    And result field "comments", defaulting to {} field 1, defaulting to [] at 0 field "format" equals "modern"

  @candidate-python-pptx-advanced-tools-e624e5e15f
  # Native: tests/test_pptx_advanced_tools.py::TestTables::test_get_table
  Scenario: Native check: get table [TestTables]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx get table using str representation of sample pptx; 3
    Then "header" occurs in result or "data" occurs in result

  @candidate-python-pptx-advanced-tools-dec2108fa9
  # Native: tests/test_pptx_advanced_tools.py::TestTables::test_add_table
  Scenario: Native check: add table [TestTables]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "new_table.pptx"
    When pptx advanced tools.tool pptx add table using str representation of sample pptx; 2; headers ["Col1", "Col2", "Col3"]; rows [["A", "B", "C"], ["D", "E", "F"]]; output path str representation of temp dir under "new_table.pptx"
    Then result field "success" is true
    And result field "rows" equals 3
    And result field "columns" equals 3

  @candidate-python-pptx-advanced-tools-f082c66869
  # Native: tests/test_pptx_advanced_tools.py::TestTables::test_table_positioning
  Scenario: Native check: table positioning [TestTables]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "table_pos.pptx"
    When pptx advanced tools.tool pptx add table using str representation of sample pptx; 2; headers ["A", "B"]; left 1.0; top 2.0; width 11.0; height 3.0; output path str representation of temp dir under "table_pos.pptx"
    Then result field "success" is true
    And when shape has table, shape left joined with shape width is at most the result of Presentation with temp dir under "table_pos.pptx" slide width
    And when shape has table, shape top joined with shape height is at most the result of Presentation with temp dir under "table_pos.pptx" slide height

  @candidate-python-pptx-advanced-tools-393c492050
  # Native: tests/test_pptx_advanced_tools.py::TestSlideManipulation::test_add_slide
  Scenario: Native check: add slide [TestSlideManipulation]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "added.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of sample pptx; title "New Slide"; output path str representation of temp dir under "added.pptx"
    Then result field "success" is true
    And the number of entries in the result of Presentation with temp dir under "added.pptx" slides equals 4

  @candidate-python-pptx-advanced-tools-3179e286a5
  # Native: tests/test_pptx_advanced_tools.py::TestSlideManipulation::test_delete_slide
  Scenario: Native check: delete slide [TestSlideManipulation]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "deleted.pptx"
    When pptx advanced tools.tool pptx delete slide using str representation of sample pptx; 2; output path str representation of temp dir under "deleted.pptx"
    Then result field "success" is true or "remaining" occurs in result or temp dir under "deleted.pptx" exists

  @candidate-python-pptx-advanced-tools-ecc98fcb4d
  # Native: tests/test_pptx_advanced_tools.py::TestSlideManipulation::test_duplicate_slide
  Scenario: Native check: duplicate slide [TestSlideManipulation]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "duplicated.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of sample pptx; 1; output path str representation of temp dir under "duplicated.pptx"
    Then result field "success" is true
    And the number of entries in the result of Presentation with temp dir under "duplicated.pptx" slides equals 4

  @candidate-python-pptx-advanced-tools-f8284125fc
  # Native: tests/test_pptx_advanced_tools.py::TestBullets::test_add_bullet
  Scenario: Native check: add bullet [TestBullets]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "bullet.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of sample pptx; 2; "New bullet point"; output path str representation of temp dir under "bullet.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-0f9590288c
  # Native: tests/test_pptx_advanced_tools.py::TestBullets::test_clear_bullets
  Scenario: Native check: clear bullets [TestBullets]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "cleared.pptx"
    When pptx advanced tools.tool pptx clear bullets using str representation of sample pptx; 2; output path str representation of temp dir under "cleared.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-ea8d7064e3
  # Native: tests/test_pptx_advanced_tools.py::TestLayoutAnalysis::test_list_masters
  Scenario: Native check: list masters [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx list masters using str representation of sample pptx
    Then "default_layouts" occurs in result
    And the number of entries in result at "default_layouts" exceeds 0

  @candidate-python-pptx-advanced-tools-e3b05ca5af
  # Native: tests/test_pptx_advanced_tools.py::TestLayoutAnalysis::test_analyze_layouts
  Scenario: Native check: analyze layouts [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx analyze layouts using str representation of sample pptx
    Then "layouts" occurs in result

  @candidate-python-pptx-advanced-tools-dfedc3c751
  # Native: tests/test_pptx_advanced_tools.py::TestLayoutAnalysis::test_recommend_layout
  Scenario: Native check: recommend layout [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    When pptx advanced tools.tool pptx recommend layout using str representation of sample pptx; "bullets"
    Then "recommended" occurs in result or "layout_index" occurs in result

  @candidate-python-pptx-advanced-tools-f5585c238a
  # Native: tests/test_pptx_advanced_tools.py::TestPlaceholders::test_audit_placeholders
  Scenario: Native check: audit placeholders [TestPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "placeholders.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And layout is prepared as the result of Presentation with no arguments slide layouts at 1
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And path is prepared as temp dir under "placeholders.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "placeholders.pptx"
    Then result field "total_placeholders", defaulting to 0 is at least 1 or "status" occurs in result or "findings" occurs in result

  @candidate-python-pptx-advanced-tools-27c9dea75a
  # Native: tests/test_pptx_advanced_tools.py::TestPlaceholders::test_replace_placeholders
  Scenario: Native check: replace placeholders [TestPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "replace.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And layout is prepared as the result of Presentation with no arguments slide layouts at 1
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And path is prepared as temp dir under "replace.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When pptx advanced tools.tool pptx replace placeholders using str representation of temp dir under "replace.pptx"; {"<Customer Name>": "Contoso Corp"}; output path str representation of temp dir under "replaced.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-f9cafe54ad
  # Native: tests/test_pptx_advanced_tools.py::TestReplaceText::test_replace_text
  Scenario: Native check: replace text [TestReplaceText]
    Given Create an instance of PresentationAdvancedTools.
    And Create a test presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "replaced_text.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of sample pptx; "Test Presentation"; "Updated Presentation"; output path str representation of temp dir under "replaced_text.pptx"
    Then result field "success" is true
    And the result of Presentation with temp dir under "replaced_text.pptx" slides at 0 shapes title text equals "Updated Presentation"
