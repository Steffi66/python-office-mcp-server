@captured @python_candidate
Feature: office unified tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-office-unified-tools-3cac4f6635
  # Native: tests/test_office_unified_tools.py::TestFormatDetection::test_detect_format
  Scenario: Native check: detect format [TestFormatDetection]
    Given a prepared filename input or fixture
    And a prepared expected input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [file.xlsx-excel] | {"filename": "'file.xlsx'", "expected": "'excel'"} |
      | [file.xlsm-excel] | {"filename": "'file.xlsm'", "expected": "'excel'"} |
      | [file.docx-word] | {"filename": "'file.docx'", "expected": "'word'"} |
      | [file.pptx-powerpoint] | {"filename": "'file.pptx'", "expected": "'powerpoint'"} |
      | [FILE.XLSX-excel] | {"filename": "'FILE.XLSX'", "expected": "'excel'"} |
      | [File.Docx-word] | {"filename": "'File.Docx'", "expected": "'word'"} |
      | [file.txt-None] | {"filename": "'file.txt'", "expected": "None"} |
      | [file.pdf-None] | {"filename": "'file.pdf'", "expected": "None"} |
    When the detect format behavior is exercised with its prepared inputs
    Then the result of detect format with filename equals expected

  @candidate-python-office-unified-tools-dbcfca7ad2
  # Native: tests/test_office_unified_tools.py::TestHasToolHelper::test_has_tool_true
  Scenario: Native check: has tool true [TestHasToolHelper]
    Given Provide a combined tools instance for helper tests.
    When the has tool true behavior is exercised with its prepared inputs
    Then the result of has tool with combined tools; "excel_extract" is true

  @candidate-python-office-unified-tools-a8b3a26575
  # Native: tests/test_office_unified_tools.py::TestHasToolHelper::test_has_tool_false
  Scenario: Native check: has tool false [TestHasToolHelper]
    Given Provide a combined tools instance for helper tests.
    When the has tool false behavior is exercised with its prepared inputs
    Then the result of has tool with combined tools; "nonexistent_tool" is false

  @candidate-python-office-unified-tools-5de4ce721e
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcel::test_read_excel_json
  Scenario: Native check: read excel json [TestOfficeReadExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office read using sample xlsx
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-86290a5fbd
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcel::test_read_excel_markdown
  Scenario: Native check: read excel markdown [TestOfficeReadExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office read using sample xlsx; output format "markdown"
    Then result has type str
    And "Name" occurs in result
    And "Value" occurs in result

  @candidate-python-office-unified-tools-25ce1aa9b4
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcel::test_read_excel_range
  Scenario: Native check: read excel range [TestOfficeReadExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office read using sample xlsx; scope "A1:B2"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-caa08f2d7c
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcel::test_read_excel_with_include_formulas
  Scenario: Native check: read excel with include formulas [TestOfficeReadExcel]
    Given tools
    And an isolated writable temporary directory
    And wb.save with temp dir under "office_read_formulas.xlsx"
    And path is prepared as temp dir under "office_read_formulas.xlsx"
    And wb is prepared as the result of openpyxl.Workbook with no arguments
    And ws is prepared as the result of openpyxl.Workbook with no arguments active
    And the result of openpyxl.Workbook with no arguments active title is set to "Calc"
    And the result of openpyxl.Workbook with no arguments active at "A1" is set to "Value"
    And the result of openpyxl.Workbook with no arguments active at "A2" is set to 10
    And the result of openpyxl.Workbook with no arguments active at "B1" is set to "Formula"
    And the result of openpyxl.Workbook with no arguments active at "B2" is set to "=A2*2"
    When tools.tool office read using str representation of temp dir under "office_read_formulas.xlsx"; include formulas true
    Then result has type dict
    And result at "sheets" at "Calc" at 1 at 1 equals "=A2*2"

  @candidate-python-office-unified-tools-94602555e5
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcel::test_read_excel_file_not_found
  Scenario: Native check: read excel file not found [TestOfficeReadExcel]
    Given tools
    When tools.tool office read using "/nonexistent/file.xlsx"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-f2aac8f19e
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectExcel::test_inspect_sheets
  Scenario: Native check: inspect sheets [TestOfficeInspectExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office inspect using sample xlsx; what "sheets"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-60b7e659d5
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectExcel::test_inspect_structure
  Scenario: Native check: inspect structure [TestOfficeInspectExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office inspect using sample xlsx; what "structure"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-9852e1dc6a
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectExcel::test_inspect_merged_cells
  Scenario: Native check: inspect merged cells [TestOfficeInspectExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office inspect using sample xlsx; what "merged_cells"
    Then result has type dict
    And "error" does not occur in result
    And result field "total_merged_regions", defaulting to 0 exceeds 0

  @candidate-python-office-unified-tools-5e9d2ff81a
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectExcel::test_inspect_comments
  Scenario: Native check: inspect comments [TestOfficeInspectExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office inspect using sample xlsx; what "comments"
    Then result has type dict
    And "error" does not occur in result
    And result field "total_comments", defaulting to 0 exceeds 0

  @candidate-python-office-unified-tools-706d58974f
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectExcel::test_inspect_unsupported_type
  Scenario: Native check: inspect unsupported type [TestOfficeInspectExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office inspect using sample xlsx; what "slides"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-0d93e72171
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_add_comment
  Scenario: Native check: add comment [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "add"; target "A1"; text "Test comment"
    Then result field "success" is true

  @candidate-python-office-unified-tools-8563901a1f
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_get_comments
  Scenario: Native check: get comments [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "add"; target "A1"; text "Test comment"
    And tools.tool office comment using file path sample xlsx; operation "get"
    Then "error" does not occur in result
    And result field "total_comments", defaulting to 0 exceeds 0

  @candidate-python-office-unified-tools-3422562b0f
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_add_comment_missing_target
  Scenario: Native check: add comment missing target [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "add"; text "Test comment"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-d8c99f3dda
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_add_comment_missing_text
  Scenario: Native check: add comment missing text [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "add"; target "A1"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-039146ab96
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_delete_comment
  Scenario: Native check: delete comment [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "add"; target "A1"; text "Delete me"
    And tools.tool office comment using file path sample xlsx; operation "delete"; target "A1"
    And tools.tool office comment using file path sample xlsx; operation "get"
    Then result field "success" is true
    And check field "total_comments", defaulting to 0 equals 0

  @candidate-python-office-unified-tools-28474f484f
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcel::test_set_identity_used_for_excel_comments
  Scenario: Native check: set identity used for excel comments [TestOfficeCommentExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office set comment identity using name "Alex Reviewer"; identity "alex.reviewer@contoso.com"; initials "AR"
    And tools.tool office comment using file path sample xlsx; operation "add"; target "A1"; text "Identity test"
    Then configured field "success" is true
    And added field "success" is true
    And added field "author" equals "Alex Reviewer"

  @candidate-python-office-unified-tools-e00a5308c0
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentWord::test_reply_comment
  Scenario: Native check: reply comment [TestOfficeCommentWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office comment using file path sample docx; operation "add"; target "Delete this note target"; text "Word comment"
    And tools.tool office comment using file path sample docx; operation "get"
    And tools.tool office comment using file path sample docx; operation "reply"; target str representation of got at "comments" at 0 at "id"; text "Acknowledged"; author "Rui Carmo"
    Then add field "success" is true
    And got field "comment_count", defaulting to 0 is at least 1
    And reply field "success" is true
    And reply field "parent_comment_id" equals str representation of got at "comments" at 0 at "id"
    And got after field "comment_count", defaulting to 0 is at least 2
    And at least one item satisfies c field "text" equals "Acknowledged" for each c in got after field "comments", defaulting to []
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{got at "comments" at 0 at "id"}'] is not null
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{reply field "reply_comment_id"}'] is not null
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{got at "comments" at 0 at "id"}'] first match for text {{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}p is not null
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{reply field "reply_comment_id"}'] first match for text {{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}p is not null
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{got at "comments" at 0 at "id"}'] first match for text {{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}p field text {{"http://schemas.microsoft.com/office/word/2010/wordml"}}paraId is non-empty or true
    And the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{reply field "reply_comment_id"}'] first match for text {{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}p field text {{"http://schemas.microsoft.com/office/word/2010/wordml"}}paraIdParent equals the result of etree.fromstring with zf saved payload for "word/comments.xml" first match for text .//{{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}comment[@w:id='{got at "comments" at 0 at "id"}'] first match for text {{"http://schemas.openxmlformats.org/wordprocessingml/2006/main"}}p field text {{"http://schemas.microsoft.com/office/word/2010/wordml"}}paraId

  @candidate-python-office-unified-tools-386ec60642
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentWord::test_reply_comment_invalid_id
  Scenario: Native check: reply comment invalid id [TestOfficeCommentWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office comment using file path sample docx; operation "add"; target "Delete this note target"; text "Word comment"
    And tools.tool office comment using file path sample docx; operation "reply"; target "999"; text "No-op"
    Then add field "success" is true
    And "error" occurs in reply
    And "Valid IDs" occurs in reply field "error", defaulting to ""

  @candidate-python-office-unified-tools-b4489fc007
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentWord::test_delete_comment
  Scenario: Native check: delete comment [TestOfficeCommentWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office comment using file path sample docx; operation "add"; target "Delete this note target"; text "Word comment"
    And tools.tool office comment using file path sample docx; operation "get"
    And tools.tool office comment using file path sample docx; operation "delete"; target str representation of got at "comments" at 0 at "id"
    Then add field "success" is true
    And got field "comment_count", defaulting to 0 is at least 1
    And deleted field "success" is true

  @candidate-python-office-unified-tools-e58d1ec132
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentWord::test_get_comments_threaded_format
  Scenario: Native check: get comments threaded format [TestOfficeCommentWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office comment using file path sample docx; operation "add"; target "Delete this note target"; text "Word comment"
    And tools.tool office comment using file path sample docx; operation "get"
    And tools.tool office comment using file path sample docx; operation "reply"; target str representation of flat at "comments" at 0 at "id"; text "Follow-up"
    And tools.tool office comment using file path sample docx; operation "get"; format "threaded"
    Then add field "success" is true
    And reply field "success" is true
    And threaded field "comment_count", defaulting to 0 is at least 2
    And "threads" occurs in threaded
    And threaded field "thread_count", defaulting to 0 is at least 1
    And "root" occurs in threaded at "threads" at 0
    And "replies" occurs in threaded at "threads" at 0

  @candidate-python-office-unified-tools-949a810e94
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentWord::test_resolve_and_reopen_comment
  Scenario: Native check: resolve and reopen comment [TestOfficeCommentWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office comment using file path sample docx; operation "add"; target "Delete this note target"; text "Word comment"
    And tools.tool office comment using file path sample docx; operation "get"
    And tools.tool office comment using file path sample docx; operation "resolve"; target str representation of got at "comments" at 0 at "id"
    And tools.tool office comment using file path sample docx; operation "get"; filter "resolved"
    And tools.tool office comment using file path sample docx; operation "reopen"; target str representation of got at "comments" at 0 at "id"
    And tools.tool office comment using file path sample docx; operation "get"; filter "open"
    Then add field "success" is true
    And resolved field "success" is true
    And resolved field "done" is true
    And at least one item satisfies c at "id" equals str representation of got at "comments" at 0 at "id" and c field "done" is true for each c in after resolve field "comments", defaulting to []
    And reopened field "success" is true
    And reopened field "done" is false
    And at least one item satisfies c at "id" equals str representation of got at "comments" at 0 at "id" and c field "done" is false for each c in after reopen field "comments", defaulting to []

  @candidate-python-office-unified-tools-00faac914d
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentExcelResolveUnsupported::test_resolve_not_supported
  Scenario: Native check: resolve not supported [TestOfficeCommentExcelResolveUnsupported]
    Given tools
    And Create a sample Excel template.
    When tools.tool office comment using file path sample xlsx; operation "resolve"; target "A1"
    Then "error" occurs in result
    And "not supported" occurs in result at "error" in lowercase

  @candidate-python-office-unified-tools-49308bf3ca
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPptxResolveUnsupported::test_resolve_not_supported
  Scenario: Native check: resolve not supported [TestOfficeCommentPptxResolveUnsupported]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office comment using file path sample pptx; operation "resolve"; target "slide:1"
    Then "error" occurs in result
    And "not supported" occurs in result at "error" in lowercase

  @candidate-python-office-unified-tools-ad8fb0428f
  # Native: tests/test_office_unified_tools.py::TestUnsupportedFormats::test_read_unsupported_format
  Scenario: Native check: read unsupported format [TestUnsupportedFormats]
    Given tools
    When tools.tool office read using "/path/to/file.txt"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-dce3c723fb
  # Native: tests/test_office_unified_tools.py::TestUnsupportedFormats::test_inspect_unsupported_format
  Scenario: Native check: inspect unsupported format [TestUnsupportedFormats]
    Given tools
    When tools.tool office inspect using "/path/to/file.pdf"; what "structure"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-b6f5b3ee58
  # Native: tests/test_office_unified_tools.py::TestUnsupportedFormats::test_comment_unsupported_format
  Scenario: Native check: comment unsupported format [TestUnsupportedFormats]
    Given tools
    When tools.tool office comment using "/path/to/file.csv"; operation "get"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-5ef265efbf
  # Native: tests/test_office_unified_tools.py::TestOfficeReadWord::test_read_word_json
  Scenario: Native check: read word json [TestOfficeReadWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office read using sample docx
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-cd763f2948
  # Native: tests/test_office_unified_tools.py::TestOfficeReadWord::test_read_word_markdown
  Scenario: Native check: read word markdown [TestOfficeReadWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office read using sample docx; output format "markdown"
    Then result has type str
    And "Test Document" occurs in result

  @candidate-python-office-unified-tools-bbb59c83b2
  # Native: tests/test_office_unified_tools.py::TestOfficeReadPowerPoint::test_read_pptx_json
  Scenario: Native check: read pptx json [TestOfficeReadPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office read using sample pptx
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-793a81bd10
  # Native: tests/test_office_unified_tools.py::TestOfficeReadPowerPoint::test_read_pptx_markdown
  Scenario: Native check: read pptx markdown [TestOfficeReadPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office read using sample pptx; output format "markdown"
    Then result has type str

  @candidate-python-office-unified-tools-04fcd6286a
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectPowerPoint::test_inspect_slides
  Scenario: Native check: inspect slides [TestOfficeInspectPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office inspect using sample pptx; what "slides"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-dad6824135
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectPowerPoint::test_inspect_shapes
  Scenario: Native check: inspect shapes [TestOfficeInspectPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office inspect using sample pptx; what "shapes"; target "1"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-office-unified-tools-03e015b8a4
  # Native: tests/test_office_unified_tools.py::TestOfficeInspectPowerPoint::test_inspect_shapes_missing_target
  Scenario: Native check: inspect shapes missing target [TestOfficeInspectPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office inspect using sample pptx; what "shapes"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-d5da4e99b7
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPowerPoint::test_add_comment_slide_target
  Scenario: Native check: add comment slide target [TestOfficeCommentPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office comment using file path sample pptx; operation "add"; target "slide:1"; text "Check this slide"
    Then result field "success" is true

  @candidate-python-office-unified-tools-d2ae028ac1
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPowerPoint::test_add_comment_shape_target_error
  Scenario: Native check: add comment shape target error [TestOfficeCommentPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office comment using file path sample pptx; operation "add"; target "slide:1/Title 1"; text "Not supported"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-2752484514
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPowerPoint::test_get_comment_with_target_error
  Scenario: Native check: get comment with target error [TestOfficeCommentPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office comment using file path sample pptx; operation "get"; target "1"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-85c227e74f
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPowerPoint::test_delete_comment
  Scenario: Native check: delete comment [TestOfficeCommentPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office comment using file path sample pptx; operation "add"; target "slide:1"; text "Delete this PPTX comment"
    And tools.tool office comment using file path sample pptx; operation "delete"; target "slide:1"
    Then add field "success" is true
    And result field "success" is true

  @candidate-python-office-unified-tools-14e0944940
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentPowerPoint::test_set_identity_used_for_powerpoint_comments
  Scenario: Native check: set identity used for powerpoint comments [TestOfficeCommentPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office set comment identity using name "Jamie Architect"; identity "jamie.architect@contoso.com"; initials "JA"
    And tools.tool office comment using file path sample pptx; operation "add"; target "slide:1"; text "PPT identity test"
    And tools.tool office comment using file path sample pptx; operation "get"
    Then configured field "success" is true
    And added field "success" is true
    And added field "author" equals "Jamie Architect"
    And comments field "total_comments", defaulting to 0 is at least 1
    And comments at "comments" at 1 at 0 field "author" equals "Jamie Architect"

  @candidate-python-office-unified-tools-4c505ce91c
  # Native: tests/test_office_unified_tools.py::TestOfficeCommentIdentity::test_set_comment_identity
  Scenario: Native check: set comment identity [TestOfficeCommentIdentity]
    Given tools
    When tools.tool office set comment identity using name "Morgan Reviewer"; identity "morgan.reviewer@contoso.com"; initials "MR"
    Then result field "success" is true
    And result field "comment_author" equals "Morgan Reviewer"
    And result field "comment_identity" equals "morgan.reviewer@contoso.com"
    And result field "comment_initials" equals "MR"

  @candidate-python-office-unified-tools-f4917d5d7a
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_single_cell
  Scenario: Native check: patch single cell [TestOfficePatchExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office patch using file path sample xlsx; changes [{"target": "A2", "value": "Updated"}]
    Then result field "changes_applied" equals 1
    And result field "errors" equals 0

  @candidate-python-office-unified-tools-57351c5f0d
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_multiple_cells
  Scenario: Native check: patch multiple cells [TestOfficePatchExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office patch using file path sample xlsx; changes [{"target": "A2", "value": "Updated"}, {"target": "B2", "value": 200}]
    Then result field "changes_applied" equals 2
    And result field "errors" equals 0

  @candidate-python-office-unified-tools-dea690a2f2
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_with_formula
  Scenario: Native check: patch with formula [TestOfficePatchExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office patch using file path sample xlsx; changes [{"target": "C2", "value": "=B2*2"}]
    Then result field "changes_applied" equals 1

  @candidate-python-office-unified-tools-9caed84099
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_no_changes
  Scenario: Native check: patch no changes [TestOfficePatchExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office patch using file path sample xlsx; changes []
    Then "error" occurs in result

  @candidate-python-office-unified-tools-215fd0cdc5
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_missing_target
  Scenario: Native check: patch missing target [TestOfficePatchExcel]
    Given tools
    And Create a sample Excel template.
    When tools.tool office patch using file path sample xlsx; changes [{"value": "NoTarget"}]
    Then result field "errors" equals 1

  @candidate-python-office-unified-tools-7d1e375a12
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_preserves_custom_package_parts
  Scenario: Native check: patch preserves custom package parts [TestOfficePatchExcel]
    Given tools
    And Create a workbook with non-openpyxl package parts that must survive patching.
    And original path is prepared as the result of Path with complex xlsx with custom parts
    And output path is prepared as the result of original path.with name with "office_patch_complex_out.xlsx"
    When tools.tool office patch using file path str representation of the result of Path with complex xlsx with custom parts; output path str representation of the result of original path.with name with "office_patch_complex_out.xlsx"; changes [{"target": "'General Inputs'!D6", "value": "Test"}]
    Then result field "changes_applied" equals 1
    And result field "errors" equals 0
    And "xl/worksheets/sheet2.xml" does not occur in set representation of patched zip ZIP member names
    And name occurs in set representation of patched zip ZIP member names
    And patched zip saved payload for name equals payload
    And the result of openpyxl.load workbook with the result of original path.with name with "office_patch_complex_out.xlsx" at "General Inputs" at "D6" value equals "Test"
    And the result of openpyxl.load workbook with the result of original path.with name with "office_patch_complex_out.xlsx" at "General Inputs" at "A2" value equals "Keep me"
    And the result of original names.issubset with set representation of patched zip ZIP member names is non-empty or true

  @candidate-python-office-unified-tools-3a93da3749
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_range_preserves_custom_package_parts
  Scenario: Native check: patch range preserves custom package parts [TestOfficePatchExcel]
    Given tools
    And Create a workbook with non-openpyxl package parts that must survive patching.
    And original path is prepared as the result of Path with complex xlsx with custom parts
    And output path is prepared as the result of original path.with name with "office_patch_complex_range.xlsx"
    When tools.tool office patch using file path str representation of the result of Path with complex xlsx with custom parts; output path str representation of the result of original path.with name with "office_patch_complex_range.xlsx"; changes [{"target": "'General Inputs'!A1:B1", "value": [["One", "Two"]]}]
    Then result field "changes_applied" equals 1
    And result field "errors" equals 0
    And "customXml/item1.xml" occurs in patched zip ZIP member names
    And "docMetadata/LabelInfo.xml" occurs in patched zip ZIP member names
    And the result of openpyxl.load workbook with the result of original path.with name with "office_patch_complex_range.xlsx" at "General Inputs" at "A1" value equals "One"
    And the result of openpyxl.load workbook with the result of original path.with name with "office_patch_complex_range.xlsx" at "General Inputs" at "B1" value equals "Two"

  @candidate-python-office-unified-tools-1841a06bbc
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_preserves_shared_strings_and_sheet_relationships
  Scenario: Native check: patch preserves shared strings and sheet relationships [TestOfficePatchExcel]
    Given tools
    And an isolated writable temporary directory
    And source is prepared as TEMPLATES under "testdata/excel/comments.xlsx"
    And original path is prepared as temp dir under "comments.xlsx"
    And output path is prepared as temp dir under "comments_patched.xlsx"
    When tools.tool office patch using file path str representation of temp dir under "comments.xlsx"; output path str representation of temp dir under "comments_patched.xlsx"; changes [{"target": "A1", "value": "Patched comment fixture"}]
    Then result field "changes_applied" equals 1
    And result field "errors" equals 0
    And name occurs in set representation of patched zip ZIP member names
    And patched zip saved payload for name equals payload
    And the result of openpyxl.load workbook with temp dir under "comments_patched.xlsx" active at "A1" value equals "Patched comment fixture"
    And the result of openpyxl.load workbook with temp dir under "comments_patched.xlsx" active at "A2" comment is not null
    And the result of openpyxl.load workbook with temp dir under "comments_patched.xlsx" active at "A2" comment text is non-empty or true

  @candidate-python-office-unified-tools-8b0abf08bb
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcel::test_patch_preserves_content_types_for_related_excel_parts
  Scenario: Native check: patch preserves content types for related excel parts [TestOfficePatchExcel]
    Given tools
    And an isolated writable temporary directory
    And source is prepared as TEMPLATES under "testdata/excel/comments.xlsx"
    And original path is prepared as temp dir under "comments_types.xlsx"
    And output path is prepared as temp dir under "comments_types_patched.xlsx"
    When tools.tool office patch using file path str representation of temp dir under "comments_types.xlsx"; output path str representation of temp dir under "comments_types_patched.xlsx"; changes [{"target": "A1", "value": "Content types patch"}]
    Then result field "changes_applied" equals 1
    And "/xl/worksheets/sheet1.xml" occurs in el attrib field "PartName" for each el in the result of ET.fromstring with patched zip saved payload for "[Content_Types].xml" matches for "ct:Override", {"ct": "http://schemas.openxmlformats.org/package/2006/content-types"}
    And "/xl/sharedStrings.xml" occurs in el attrib field "PartName" for each el in the result of ET.fromstring with patched zip saved payload for "[Content_Types].xml" matches for "ct:Override", {"ct": "http://schemas.openxmlformats.org/package/2006/content-types"}
    And "/xl/comments1.xml" occurs in el attrib field "PartName" for each el in the result of ET.fromstring with patched zip saved payload for "[Content_Types].xml" matches for "ct:Override", {"ct": "http://schemas.openxmlformats.org/package/2006/content-types"}
    And el attrib field "ContentType" for each el in the result of ET.fromstring with patched zip saved payload for "[Content_Types].xml" matches for "ct:Default", {"ct": "http://schemas.openxmlformats.org/package/2006/content-types"} field "vml" equals "application/vnd.openxmlformats-officedocument.vmlDrawing"

  @candidate-python-office-unified-tools-9a65a3d951
  # Native: tests/test_office_unified_tools.py::TestOfficeTableExcel::test_get_table
  Scenario: Native check: get table [TestOfficeTableExcel]
    Given tools
    And Create a sample Excel file with a named table.
    When tools.tool office table using file path sample xlsx with table; operation "get"; table id "TestTable"
    Then "error" does not occur in result

  @candidate-python-office-unified-tools-ba25c08666
  # Native: tests/test_office_unified_tools.py::TestOfficeTableExcel::test_add_row_to_table
  Scenario: Native check: add row to table [TestOfficeTableExcel]
    Given tools
    And Create a sample Excel file with a named table.
    When tools.tool office table using file path sample xlsx with table; operation "add_row"; table id "TestTable"; data {"Name": "Gamma", "Value": 300}
    Then "error" does not occur in result

  @candidate-python-office-unified-tools-41d3c4731b
  # Native: tests/test_office_unified_tools.py::TestOfficeTableExcel::test_table_missing_id
  Scenario: Native check: table missing id [TestOfficeTableExcel]
    Given tools
    And Create a sample Excel file with a named table.
    When tools.tool office table using file path sample xlsx with table; operation "get"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-ae968d6f9a
  # Native: tests/test_office_unified_tools.py::TestOfficeTableExcel::test_add_row_missing_data
  Scenario: Native check: add row missing data [TestOfficeTableExcel]
    Given tools
    And Create a sample Excel file with a named table.
    When tools.tool office table using file path sample xlsx with table; operation "add_row"; table id "TestTable"
    Then "error" occurs in result

  @candidate-python-office-unified-tools-d9b29dfe6e
  # Native: tests/test_office_unified_tools.py::TestOfficeTableWord::test_create_word_table
  Scenario: Native check: create word table [TestOfficeTableWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office table using file path sample docx; operation "create"; data {"headers": ["Phase", "Owner"], "rows": [{"Phase": "Discovery", "Owner": "PM"}], "insert_after_section": "Delivery Plan"}
    And tools.tool office inspect using file path sample docx; what "tables"
    Then "error" does not occur in result
    And result field "success" is true
    And "error" does not occur in inspected
    And inspected field "count", defaulting to 0 is at least 1
    And "Phase" occurs in inspected field "tables", defaulting to [] at 0 field "header", defaulting to []

  @candidate-python-office-unified-tools-98c1037a1b
  # Native: tests/test_office_unified_tools.py::TestOfficeTableWord::test_create_word_table_missing_headers
  Scenario: Native check: create word table missing headers [TestOfficeTableWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office table using file path sample docx; operation "create"; data {"rows": [{"Phase": "Discovery"}]}
    Then "error" occurs in result

  @candidate-python-office-unified-tools-6fe6cb5e8e
  # Native: tests/test_office_unified_tools.py::TestOfficePatchWord::test_patch_placeholder
  Scenario: Native check: patch placeholder [TestOfficePatchWord]
    Given tools
    And Create a sample Word file with placeholder.
    When tools.tool office patch using file path sample docx with placeholder; changes [{"target": "<Customer Name>", "value": "Acme Corp"}]
    Then "error" does not occur in result or result field "changes_applied", defaulting to 0 is at least 0

  @candidate-python-office-unified-tools-eb4e95aeb0
  # Native: tests/test_office_unified_tools.py::TestOfficePatchWord::test_patch_placeholder_no_match_does_not_save
  Scenario: Native check: patch placeholder no match does not save [TestOfficePatchWord]
    Given tools
    And an isolated writable temporary directory
    And doc.save with temp dir under "office_patch_no_match.docx"
    And path is prepared as temp dir under "office_patch_no_match.docx"
    And doc is prepared as the result of docx.Document with no arguments
    And before is prepared as the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments
    When tools.tool office patch using file path str representation of temp dir under "office_patch_no_match.docx"; changes [{"target": "<Does Not Exist>", "value": "Ignored"}]
    Then "error" does not occur in result
    And the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments equals the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments

  @candidate-python-office-unified-tools-9a6f505304
  # Native: tests/test_office_unified_tools.py::TestOfficePatchWord::test_patch_section_target_inserts_into_empty_section
  Scenario: Native check: patch section target inserts into empty section [TestOfficePatchWord]
    Given tools
    And Create a Word file with an empty section body.
    When tools.tool office patch using file path sample docx with empty section; changes [{"target": "section:Delivery approach", "value": "Microsoft will undertake an iterative delivery approach."}]
    Then result field "changes_applied" equals 1
    And result field "errors" equals 0
    And "Delivery approach" occurs in the result of get text with track changes with para with boundary whitespace removed for each para in the result of docx.Document with sample docx with empty section paragraphs where the result of get text with track changes with para with boundary whitespace removed
    And "Next Section" occurs in the result of get text with track changes with para with boundary whitespace removed for each para in the result of docx.Document with sample docx with empty section paragraphs where the result of get text with track changes with para with boundary whitespace removed
    And the result of paragraphs.index with "Delivery approach" is below the result of paragraphs.index with "Next Section"
    And "Microsoft will undertake an iterative delivery approach." occurs in a slice of the result of get text with track changes with para with boundary whitespace removed for each para in the result of docx.Document with sample docx with empty section paragraphs where the result of get text with track changes with para with boundary whitespace removed

  @candidate-python-office-unified-tools-938d291eec
  # Native: tests/test_office_unified_tools.py::TestOfficePatchWord::test_patch_word_ignores_deleted_content_when_matching
  Scenario: Native check: patch word ignores deleted content when matching [TestOfficePatchWord]
    Given tools
    And an isolated writable temporary directory
    And doc.save with temp dir under "office_patch_deleted_only.docx"
    And path is prepared as temp dir under "office_patch_deleted_only.docx"
    And doc is prepared as the result of docx.Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Before "
    When tools.tool office patch using file path str representation of temp dir under "office_patch_deleted_only.docx"; changes [{"target": "[TBD]", "value": "replacement text"}]
    Then result field "errors" equals 0
    And result field "changes_applied" equals 0
    And the result of xml.count with "replacement text" equals 1

  @candidate-python-office-unified-tools-0a03115d67
  # Native: tests/test_office_unified_tools.py::TestOfficePatchWord::test_patch_word_skips_already_applied_insertion
  Scenario: Native check: patch word skips already applied insertion [TestOfficePatchWord]
    Given tools
    And an isolated writable temporary directory
    And doc.save with temp dir under "office_patch_already_applied.docx"
    And path is prepared as temp dir under "office_patch_already_applied.docx"
    And doc is prepared as the result of docx.Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Work Order (WO) "
    When tools.tool office patch using file path str representation of temp dir under "office_patch_already_applied.docx"; changes [{"target": "[TBD]", "value": "to be assigned at signature"}]
    Then result field "errors" equals 0
    And result field "changes_applied" equals 0
    And the result of xml.count with "to be assigned at signature" equals 1

  @candidate-python-office-unified-tools-4014f68a7c
  # Native: tests/test_office_unified_tools.py::TestOfficeReadExcelScope::test_reads_sheet_name_scope
  Scenario: Native check: reads sheet name scope [TestOfficeReadExcelScope]
    Given tools
    And an isolated writable temporary directory
    And wb.save with temp dir under "sheet_scope.xlsx"
    And path is prepared as temp dir under "sheet_scope.xlsx"
    And wb is prepared as the result of openpyxl.Workbook with no arguments
    And ws is prepared as the result of openpyxl.Workbook with no arguments active
    And the result of openpyxl.Workbook with no arguments active title is set to "ECIF Work Scope (E)"
    And the result of openpyxl.Workbook with no arguments active at "A1" is set to "Header"
    And the result of openpyxl.Workbook with no arguments active at "A2" is set to "Value"
    When tools.tool office read using file path str representation of temp dir under "sheet_scope.xlsx"; scope "ECIF Work Scope (E)"
    Then "error" does not occur in result
    And "sheets" occurs in result
    And "ECIF Work Scope (E)" occurs in result at "sheets"

  @candidate-python-office-unified-tools-f9b82a4780
  # Native: tests/test_office_unified_tools.py::TestOfficePatchExcelBatch::test_batch_patch_loads_workbook_once
  Scenario: Native check: batch patch loads workbook once [TestOfficePatchExcelBatch]
    Given tools
    And an isolated writable temporary directory
    And isolated dependency/environment overrides
    And wb.save with temp dir under "batch_patch.xlsx"
    And monkeypatch.setattr with office unified tools module; "load_workbook"; counted load
    And path is prepared as temp dir under "batch_patch.xlsx"
    And wb is prepared as the result of openpyxl.Workbook with no arguments
    And ws is prepared as the result of openpyxl.Workbook with no arguments active
    And the result of openpyxl.Workbook with no arguments active at "A1" is set to "Old"
    And call count is prepared as 0
    And real load is prepared as office unified tools module load workbook
    When tools.tool office patch using file path str representation of temp dir under "batch_patch.xlsx"; changes [{"target": "A1", "value": "New"}, {"target": "A2", "value": "Next"}]
    Then "error" does not occur in result
    And 0 equals 1

  @candidate-python-office-unified-tools-be11a24f7d
  # Native: tests/test_office_unified_tools.py::TestOfficeAuditExcelExtras::test_audit_empty_cells_dates_totals
  Scenario: Native check: audit empty cells dates totals [TestOfficeAuditExcelExtras]
    Given tools
    And an isolated writable temporary directory
    And wb.save with temp dir under "audit_extras.xlsx"
    And path is prepared as temp dir under "audit_extras.xlsx"
    And wb is prepared as the result of openpyxl.Workbook with no arguments
    And ws is prepared as the result of openpyxl.Workbook with no arguments active
    And the result of openpyxl.Workbook with no arguments active title is set to "ECIF Work Scope (E)"
    And the result of openpyxl.Workbook with no arguments active at "A1" is set to 10
    And the result of openpyxl.Workbook with no arguments active at "A2" is set to 20
    And the result of openpyxl.Workbook with no arguments active at "B1" is set to 40
    And the result of openpyxl.Workbook with no arguments active at "C1" is set to "2026-03-01"
    And audit config is prepared as {"required_cells": ["'ECIF Work Scope (E)'!D1"], "date_cells": ["'ECIF Work Scope (E)'!C1"], "totals": [{"sum_range": "'ECIF Work Scope (E)'!A1:A2", "target": "'ECIF Work Scope (E)'!B1", "tolerance": 0.01}]}
    When tools.tool office audit using file path str representation of temp dir under "audit_extras.xlsx"; checks ["empty_cells", "dates", "totals"]; audit config {"required_cells": ["'ECIF Work Scope (E)'!D1"], "date_cells": ["'ECIF Work Scope (E)'!C1"], "totals": [{"sum_range": "'ECIF Work Scope (E)'!A1:A2", "target": "'ECIF Work Scope (E)'!B1", "tolerance": 0.01}]}
    Then "error" does not occur in result
    And result field "results", defaulting to {} field "empty_cells", defaulting to {} field "count" equals 1
    And result field "results", defaulting to {} field "dates", defaulting to {} field "count" equals 1
    And result field "results", defaulting to {} field "totals", defaulting to {} field "count" equals 1

  @candidate-python-office-unified-tools-ed496ad9b9
  # Native: tests/test_office_unified_tools.py::TestOfficePatchPowerPoint::test_patch_shape_by_slide
  Scenario: Native check: patch shape by slide [TestOfficePatchPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office inspect using sample pptx; what "shapes"; target "1"
    And if "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, tools.tool office patch using file path sample pptx; changes the entries the fields "target" set to text slide:1/{inspect result at "shapes" at 0 field "name", defaulting to "Title 1"}, "value" set to "New Title"
    Then when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, "file" occurs in result
    And when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, result field "results", defaulting to [] at 0 field "value_preview" equals "New Title"

  @candidate-python-office-unified-tools-8517534c31
  # Native: tests/test_office_unified_tools.py::TestOfficePatchPowerPoint::test_patch_global_text
  Scenario: Native check: patch global text [TestOfficePatchPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    When tools.tool office patch using file path sample pptx; changes [{"target": "Original", "value": "Updated"}]
    Then "file" occurs in result

  @candidate-python-office-unified-tools-df4b205caf
  # Native: tests/test_office_unified_tools.py::TestOfficePatchPowerPoint::test_patch_soft_return
  Scenario: Native check: patch soft return [TestOfficePatchPowerPoint]
    Given tools
    And Create a sample PowerPoint file.
    And an isolated writable temporary directory
    And output path is prepared as temp dir under "office_patch_soft_return.pptx"
    When tools.tool office inspect using sample pptx; what "shapes"; target "1"
    And if "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, tools.tool office patch using file path sample pptx; changes the entries the fields "target" set to text slide:1/{inspect result at "shapes" at 0 field "name", defaulting to "Title 1"}, "value" set to "Line1{br}Line2"; output path str representation of temp dir under "office_patch_soft_return.pptx"
    Then when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, the result of pptx.Presentation with temp dir under "office_patch_soft_return.pptx" slides at 0 shapes title is not null
    And when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, "Line1" occurs in the result of pptx.Presentation with temp dir under "office_patch_soft_return.pptx" slides at 0 shapes title text
    And when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, "Line2" occurs in the result of pptx.Presentation with temp dir under "office_patch_soft_return.pptx" slides at 0 shapes title text
    And when "shapes" occurs in inspect result and the number of entries in inspect result at "shapes" exceeds 0, "{br}" does not occur in the result of pptx.Presentation with temp dir under "office_patch_soft_return.pptx" slides at 0 shapes title text

  @candidate-python-office-unified-tools-7a1ba8f3cb
  # Native: tests/test_office_unified_tools.py::TestOfficeTemplateExcel::test_copy_template
  Scenario: Native check: copy template [TestOfficeTemplateExcel]
    Given tools
    And Create a sample Excel template.
    And an isolated writable temporary directory
    And dest path is prepared as temp dir under "office_template_copy.xlsx"
    When tools.tool office template using source path sample xlsx; destination path str representation of temp dir under "office_template_copy.xlsx"; operation "copy"
    Then "error" does not occur in result or result field "success" is true

  @candidate-python-office-unified-tools-b8c883a370
  # Native: tests/test_office_unified_tools.py::TestOfficeAuditExcel::test_audit_placeholders
  Scenario: Native check: audit placeholders [TestOfficeAuditExcel]
    Given tools
    And Create a sample Excel file with placeholders.
    When tools.tool office audit using file path sample xlsx with placeholders; checks ["placeholders"]
    Then "results" occurs in result
    And "placeholders" occurs in result field "results", defaulting to {}

  @candidate-python-office-unified-tools-a9b98e18e7
  # Native: tests/test_office_unified_tools.py::TestOfficeAuditExcel::test_audit_default_check
  Scenario: Native check: audit default check [TestOfficeAuditExcel]
    Given tools
    And Create a sample Excel file with placeholders.
    When tools.tool office audit using file path sample xlsx with placeholders
    Then "results" occurs in result

  @candidate-python-office-unified-tools-dda4f43db0
  # Native: tests/test_office_unified_tools.py::TestOfficeTemplateWord::test_copy_template
  Scenario: Native check: copy template [TestOfficeTemplateWord]
    Given tools
    And Create a sample Word template.
    And an isolated writable temporary directory
    And dest path is prepared as temp dir under "office_template_copy.docx"
    When tools.tool office template using source path sample docx; destination path str representation of temp dir under "office_template_copy.docx"; operation "copy"
    Then "error" does not occur in result

  @candidate-python-office-unified-tools-e4014b415c
  # Native: tests/test_office_unified_tools.py::TestOfficeTemplateWord::test_analyze_template
  Scenario: Native check: analyze template [TestOfficeTemplateWord]
    Given tools
    And Create a sample Word template.
    When tools.tool office template using source path sample docx; destination path ""; operation "analyze"
    Then "error" does not occur in result

  @candidate-python-office-unified-tools-491d93e95f
  # Native: tests/test_office_unified_tools.py::TestOfficeAuditPowerPoint::test_audit_placeholders
  Scenario: Native check: audit placeholders [TestOfficeAuditPowerPoint]
    Given tools
    And Create a sample PowerPoint file with placeholder text.
    When tools.tool office audit using file path sample pptx with placeholders; checks ["placeholders"]
    Then "results" occurs in result
    And "placeholders" occurs in result field "results", defaulting to {}
