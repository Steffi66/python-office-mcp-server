@captured @python_candidate
Feature: bugfix round2 native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-bugfix-round2-6eb46cf678
  # Native: tests/test_bugfix_round2.py::TestDuplicateSlideDeepCopy::test_duplicate_preserves_table
  Scenario: Native check: duplicate preserves table [TestDuplicateSlideDeepCopy]
    Given pptx tools
    And Create a presentation with a table on slide 1.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "dup_table.pptx"
    When pptx tools.tool pptx duplicate slide using file path str representation of pptx with table; slide number 1; position "after"; output path str representation of temp dir under "dup_table.pptx"
    Then result field "success" is true
    And result at "new_slide_number" equals 2
    And the number of entries in the result of Presentation with str representation of temp dir under "dup_table.pptx" slides equals 2
    And the number of entries in s for each s in the result of Presentation with str representation of temp dir under "dup_table.pptx" slides at slide idx shapes where s has table is at least 1
    And the result of tbl.cell with 0; 0 text equals "Name"
    And the result of tbl.cell with 1; 0 text equals "Alpha"
    And the result of tbl.cell with 2; 1 text equals "200"

  @candidate-python-bugfix-round2-33ca955f18
  # Native: tests/test_bugfix_round2.py::TestDuplicateSlideDeepCopy::test_duplicate_position_end
  Scenario: Native check: duplicate position end [TestDuplicateSlideDeepCopy]
    Given pptx tools
    And Create a presentation with a table on slide 1.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "dup_end.pptx"
    When pptx tools.tool pptx duplicate slide using file path str representation of pptx with table; slide number 1; position "end"; output path str representation of temp dir under "dup_end.pptx"
    Then result field "success" is true
    And the number of entries in the result of Presentation with str representation of temp dir under "dup_end.pptx" slides equals 2

  @candidate-python-bugfix-round2-47fa5072ad
  # Native: tests/test_bugfix_round2.py::TestDuplicateSlideDeepCopy::test_duplicate_preserves_title
  Scenario: Native check: duplicate preserves title [TestDuplicateSlideDeepCopy]
    Given pptx tools
    And Create a presentation with a table on slide 1.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "dup_title.pptx"
    When pptx tools.tool pptx duplicate slide using file path str representation of pptx with table; slide number 1; position "after"; output path str representation of temp dir under "dup_title.pptx"
    Then when slide shapes title, slide shapes title text equals "Table Slide"

  @candidate-python-bugfix-round2-db7b8831ab
  # Native: tests/test_bugfix_round2.py::TestDuplicateSlideDeepCopy::test_duplicate_invalid_slide_number
  Scenario: Native check: duplicate invalid slide number [TestDuplicateSlideDeepCopy]
    Given pptx tools
    And Create a presentation with a table on slide 1.
    When pptx tools.tool pptx duplicate slide using file path str representation of pptx with table; slide number 99
    Then "error" occurs in result

  @candidate-python-bugfix-round2-2e0873c8bb
  # Native: tests/test_bugfix_round2.py::TestDuplicateSlideDeepCopy::test_duplicate_file_not_found
  Scenario: Native check: duplicate file not found [TestDuplicateSlideDeepCopy]
    Given pptx tools
    When pptx tools.tool pptx duplicate slide using file path "/nonexistent/file.pptx"; slide number 1
    Then "error" occurs in result
    And "not found" occurs in result at "error" in lowercase

  @candidate-python-bugfix-round2-aacabed56b
  # Native: tests/test_bugfix_round2.py::TestTableIdQuoteParsing::test_quoted_table_id_pptx
  Scenario: Native check: quoted table id pptx [TestTableIdQuoteParsing]
    Given combined tools
    And Create a presentation with a table on slide 1.
    When combined tools.tool office table using file path str representation of pptx with table; operation "get"; table id "\"1\""
    Then "error" does not occur in result or "No table" does not occur in result field "error", defaulting to ""

  @candidate-python-bugfix-round2-b5255462dd
  # Native: tests/test_bugfix_round2.py::TestTableIdQuoteParsing::test_single_quoted_table_id
  Scenario: Native check: single quoted table id [TestTableIdQuoteParsing]
    Given combined tools
    And Create a presentation with a table on slide 1.
    When combined tools.tool office table using file path str representation of pptx with table; operation "get"; table id "'1'"
    Then "error" does not occur in result or "No table" does not occur in result field "error", defaulting to ""

  @candidate-python-bugfix-round2-8eab8b3490
  # Native: tests/test_bugfix_round2.py::TestTableIdQuoteParsing::test_unquoted_table_id
  Scenario: Native check: unquoted table id [TestTableIdQuoteParsing]
    Given combined tools
    And Create a presentation with a table on slide 1.
    When combined tools.tool office table using file path str representation of pptx with table; operation "get"; table id "1"
    Then "error" does not occur in result or "No table" does not occur in result field "error", defaulting to ""

  @candidate-python-bugfix-round2-533d711fb5
  # Native: tests/test_bugfix_round2.py::TestPptxAddRowDictMapping::test_add_row_dict_maps_by_header
  Scenario: Native check: add row dict maps by header [TestPptxAddRowDictMapping]
    Given combined tools
    And pptx tools
    And Create a presentation with a table on slide 1.
    When combined tools.tool office table using file path str representation of pptx with table; operation "add_row"; table id "1"; data {"Value": "300", "Name": "Gamma"}
    And pptx tools.tool pptx get table using file path str representation of pptx with table; slide number 1
    Then "error" does not occur in result
    And "error" does not occur in table
    And table field "data" is non-empty or true
    And table at "data" at -1 equals ["Gamma", "300"]

  @candidate-python-bugfix-round2-68ebdd520a
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_detect_format_returns_none_for_pdf
  Scenario: Native check: detect format returns none for pdf [TestUnsupportedFormatError]
    Given the native detect format returns none for pdf inputs and isolated test state
    When the detect format returns none for pdf behavior is exercised with its prepared inputs
    Then the result of detect format with "report.pdf" is null

  @candidate-python-bugfix-round2-14e0ec8202
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_detect_format_returns_none_for_txt
  Scenario: Native check: detect format returns none for txt [TestUnsupportedFormatError]
    Given the native detect format returns none for txt inputs and isolated test state
    When the detect format returns none for txt behavior is exercised with its prepared inputs
    Then the result of detect format with "notes.txt" is null

  @candidate-python-bugfix-round2-8f32d78c2d
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_unsupported_format_error_includes_extension
  Scenario: Native check: unsupported format error includes extension [TestUnsupportedFormatError]
    Given err is prepared as the result of unsupported format error with "report.pdf"
    When unsupported format error using "report.pdf"
    Then "error" occurs in the result of unsupported format error with "report.pdf"
    And ".pdf" occurs in the result of unsupported format error with "report.pdf" at "error"

  @candidate-python-bugfix-round2-46736ca356
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_unsupported_format_error_lists_supported
  Scenario: Native check: unsupported format error lists supported [TestUnsupportedFormatError]
    Given err is prepared as the result of unsupported format error with "data.csv"
    When unsupported format error using "data.csv"
    Then ".docx" occurs in the result of unsupported format error with "data.csv" at "error"
    And ".xlsx" occurs in the result of unsupported format error with "data.csv" at "error"
    And ".pptx" occurs in the result of unsupported format error with "data.csv" at "error"

  @candidate-python-bugfix-round2-bd54ab9bc6
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_office_read_unsupported_format
  Scenario: Native check: office read unsupported format [TestUnsupportedFormatError]
    Given combined tools
    And an isolated writable temporary directory
    And txt file.write text with "hello"
    And txt file is prepared as temp dir under "notes.txt"
    When combined tools.tool office read using str representation of temp dir under "notes.txt"
    Then "error" occurs in result
    And ".txt" occurs in result at "error"
    And "Supported" occurs in result at "error"

  @candidate-python-bugfix-round2-71dbe0b8ff
  # Native: tests/test_bugfix_round2.py::TestUnsupportedFormatError::test_office_inspect_unsupported_format
  Scenario: Native check: office inspect unsupported format [TestUnsupportedFormatError]
    Given combined tools
    And an isolated writable temporary directory
    And pdf file.write bytes with "b'%PDF-1.4 fake'"
    And pdf file is prepared as temp dir under "report.pdf"
    When combined tools.tool office inspect using str representation of temp dir under "report.pdf"
    Then "error" occurs in result
    And ".pdf" occurs in result at "error"

  @candidate-python-bugfix-round2-86092be1bb
  # Native: tests/test_bugfix_round2.py::TestResolveFilePath::test_absolute_path_exists
  Scenario: Native check: absolute path exists [TestResolveFilePath]
    Given an isolated writable temporary directory
    And f.write bytes with "b'pk'"
    And f is prepared as temp dir under "existing.docx"
    When the absolute path exists behavior is exercised with its prepared inputs
    Then the result of resolve file path with str representation of temp dir under "existing.docx" equals str representation of temp dir under "existing.docx"

  @candidate-python-bugfix-round2-ca2bd73327
  # Native: tests/test_bugfix_round2.py::TestResolveFilePath::test_absolute_path_not_found
  Scenario: Native check: absolute path not found [TestResolveFilePath]
    Given p is prepared as "/nonexistent/abc.docx"
    When the absolute path not found behavior is exercised with its prepared inputs
    Then the result of resolve file path with "/nonexistent/abc.docx" equals "/nonexistent/abc.docx"

  @candidate-python-bugfix-round2-553f29f540
  # Native: tests/test_bugfix_round2.py::TestResolveFilePath::test_relative_via_workspace_root
  Scenario: Native check: relative via workspace root [TestResolveFilePath]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And f.write bytes with "b'pk'"
    And monkeypatch.setenv with "MCP_WORKSPACE_ROOT"; str representation of temp dir under "workspace"
    And sub is prepared as temp dir under "workspace"
    And f is prepared as temp dir under "workspace" under "report.docx"
    And resolved is prepared as the result of resolve file path with "report.docx"
    When sub.mkdir using the prepared inputs
    And monkeypatch.setenv using "MCP_WORKSPACE_ROOT"; str representation of temp dir under "workspace"
    And resolve file path using "report.docx"
    Then the result of resolve file path with "report.docx" equals str representation of temp dir under "workspace" under "report.docx"

  @candidate-python-bugfix-round2-5a5145c232
  # Native: tests/test_bugfix_round2.py::TestResolveFilePath::test_relative_via_cwd
  Scenario: Native check: relative via cwd [TestResolveFilePath]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.delenv with "MCP_WORKSPACE_ROOT"
    And f.write bytes with "b'pk'"
    And f is prepared as temp dir under "data.xlsx"
    And resolved is prepared as the result of resolve file path with "data.xlsx"
    When monkeypatch.delenv using "MCP_WORKSPACE_ROOT"
    And monkeypatch.chdir using temp dir
    And resolve file path using "data.xlsx"
    Then the result of Path with the result of resolve file path with "data.xlsx" exists is non-empty or true

  @candidate-python-bugfix-round2-1860c012e9
  # Native: tests/test_bugfix_round2.py::TestResolveFilePath::test_missing_relative_returns_original
  Scenario: Native check: missing relative returns original [TestResolveFilePath]
    Given isolated dependency/environment overrides
    And monkeypatch.delenv with "MCP_WORKSPACE_ROOT"
    When monkeypatch.delenv using "MCP_WORKSPACE_ROOT"
    Then the result of resolve file path with "no_such_file.pptx" equals "no_such_file.pptx"

  @candidate-python-bugfix-round2-523cd14fa0
  # Native: tests/test_bugfix_round2.py::TestTemplateCopyPreservesShapes::test_copy_then_duplicate_keeps_table
  Scenario: Native check: copy then duplicate keeps table [TestTemplateCopyPreservesShapes]
    Given combined tools
    And pptx tools
    And Create a presentation with a table on slide 1.
    And an isolated writable temporary directory
    And copy path is prepared as temp dir under "template_copy.pptx"
    When combined tools.tool office template using source path str representation of pptx with table; destination path str representation of temp dir under "template_copy.pptx"; operation "copy"
    And pptx tools.tool pptx duplicate slide using file path str representation of temp dir under "template_copy.pptx"; slide number 1; position "after"; output path str representation of temp dir under "template_dup.pptx"
    Then result field "success" is true
    And temp dir under "template_copy.pptx" exists is non-empty or true
    And the number of entries in tables equals 1
    And the number of entries in the result of Presentation with str representation of temp dir under "template_dup.pptx" slides equals 2
    And the number of entries in tables is at least 1

  @candidate-python-bugfix-round2-d2dea76a4b
  # Native: tests/test_bugfix_round2.py::TestAddSlidePosition::test_position_end
  Scenario: Native check: position end [TestAddSlidePosition]
    Given pptx tools
    And Create a presentation with 3 titled slides for ordering tests.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "add_end.pptx"
    When pptx tools.tool pptx add slide using file path str representation of pptx three slides; title "New End"; position "end"; output path str representation of temp dir under "add_end.pptx"
    Then result field "success" is true
    And result at "slide_number" equals 4

  @candidate-python-bugfix-round2-6660593f48
  # Native: tests/test_bugfix_round2.py::TestAddSlidePosition::test_position_start
  Scenario: Native check: position start [TestAddSlidePosition]
    Given pptx tools
    And Create a presentation with 3 titled slides for ordering tests.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "add_start.pptx"
    When pptx tools.tool pptx add slide using file path str representation of pptx three slides; title "New Start"; position "start"; output path str representation of temp dir under "add_start.pptx"
    Then result field "success" is true
    And result at "slide_number" equals 1
    And the number of entries in the result of Presentation with str representation of temp dir under "add_start.pptx" slides equals 4
    And when the result of Presentation with str representation of temp dir under "add_start.pptx" slides at 0 shapes title, the result of Presentation with str representation of temp dir under "add_start.pptx" slides at 0 shapes title text equals "New Start"

  @candidate-python-bugfix-round2-25a176f17e
  # Native: tests/test_bugfix_round2.py::TestAddSlidePosition::test_position_2_becomes_slide_2
  Scenario: Native check: position 2 becomes slide 2 [TestAddSlidePosition]
    Given pptx tools
    And Create a presentation with 3 titled slides for ordering tests.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "add_pos2.pptx"
    When pptx tools.tool pptx add slide using file path str representation of pptx three slides; title "Inserted at 2"; position "2"; output path str representation of temp dir under "add_pos2.pptx"
    Then result field "success" is true
    And result at "slide_number" equals 2
    And the number of entries in the result of Presentation with str representation of temp dir under "add_pos2.pptx" slides equals 4
    And [] at 0 equals "Slide 1"
    And [] at 1 equals "Inserted at 2"
    And [] at 2 equals "Slide 2"
    And [] at 3 equals "Slide 3"

  @candidate-python-bugfix-round2-204dd006de
  # Native: tests/test_bugfix_round2.py::TestAddSlidePosition::test_position_1_becomes_slide_1
  Scenario: Native check: position 1 becomes slide 1 [TestAddSlidePosition]
    Given pptx tools
    And Create a presentation with 3 titled slides for ordering tests.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "add_pos1.pptx"
    When pptx tools.tool pptx add slide using file path str representation of pptx three slides; title "Inserted at 1"; position "1"; output path str representation of temp dir under "add_pos1.pptx"
    Then result field "success" is true
    And result at "slide_number" equals 1
    And the number of entries in the result of Presentation with str representation of temp dir under "add_pos1.pptx" slides equals 4
    And when the result of Presentation with str representation of temp dir under "add_pos1.pptx" slides at 0 shapes title, the result of Presentation with str representation of temp dir under "add_pos1.pptx" slides at 0 shapes title text equals "Inserted at 1"

  @candidate-python-bugfix-round2-d79862bf4b
  # Native: tests/test_bugfix_round2.py::TestAddSlidePosition::test_position_3_in_3_slide_deck
  Scenario: Native check: position 3 in 3 slide deck [TestAddSlidePosition]
    Given pptx tools
    And Create a presentation with 3 titled slides for ordering tests.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "add_pos3.pptx"
    When pptx tools.tool pptx add slide using file path str representation of pptx three slides; title "Inserted at 3"; position "3"; output path str representation of temp dir under "add_pos3.pptx"
    Then result field "success" is true
    And result at "slide_number" equals 3
    And s shapes title text when s shapes title otherwise "" for each s in the result of Presentation with str representation of temp dir under "add_pos3.pptx" slides equals ["Slide 1", "Slide 2", "Inserted at 3", "Slide 3"]

  @candidate-python-bugfix-round2-2ce56f469c
  # Native: tests/test_bugfix_round2.py::TestPptxTableErrorMessages::test_patch_table_cell_no_table_hint
  Scenario: Native check: patch table cell no table hint [TestPptxTableErrorMessages]
    Given pptx tools
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_table.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "no_table.pptx"
    When pptx tools.tool pptx patch table cell using file path str representation of temp dir under "no_table.pptx"; slide number 1; row index 0; col index 0; new text "test"
    Then "error" occurs in result
    And "reordered" occurs in result at "error" in lowercase or "deleted" occurs in result at "error" in lowercase

  @candidate-python-bugfix-round2-4da7a78fa6
  # Native: tests/test_bugfix_round2.py::TestPptxTableErrorMessages::test_get_table_no_table_hint
  Scenario: Native check: get table no table hint [TestPptxTableErrorMessages]
    Given pptx tools
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_table2.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "no_table2.pptx"
    When pptx tools.tool pptx get table using file path str representation of temp dir under "no_table2.pptx"; slide number 1
    Then "error" occurs in result
    And "reordered" occurs in result at "error" in lowercase or "deleted" occurs in result at "error" in lowercase

  @candidate-python-bugfix-round2-30268ef1ec
  # Native: tests/test_bugfix_round2.py::TestPptxTableErrorMessages::test_insert_table_row_no_table_hint
  Scenario: Native check: insert table row no table hint [TestPptxTableErrorMessages]
    Given pptx tools
    And an isolated writable temporary directory
    And prs.save with temp dir under "no_table3.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "no_table3.pptx"
    When pptx tools.tool pptx insert table row using file path str representation of temp dir under "no_table3.pptx"; slide number 1; row data ["a", "b"]
    Then "error" occurs in result
    And "reordered" occurs in result at "error" in lowercase or "deleted" occurs in result at "error" in lowercase

  @candidate-python-bugfix-round2-f5ce1b9a5a
  # Native: tests/test_bugfix_round2.py::TestDeleteSlideRemainingCount::test_remaining_slides_after_delete_last
  Scenario: Native check: remaining slides after delete last [TestDeleteSlideRemainingCount]
    Given pptx tools
    And an isolated writable temporary directory
    And prs.save with temp dir under "seven_slides.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "seven_slides.pptx"
    When pptx tools.tool pptx delete slide using file path str representation of temp dir under "seven_slides.pptx"; slide number 7; output path str representation of temp dir under "seven_slides.pptx"
    Then result field "success" is true
    And result at "remaining_slides" equals 6
    And the number of entries in the result of Presentation with str representation of temp dir under "seven_slides.pptx" slides equals 6

  @candidate-python-bugfix-round2-b3d9bb289c
  # Native: tests/test_bugfix_round2.py::TestDeleteSlideRemainingCount::test_remaining_slides_after_delete_middle
  Scenario: Native check: remaining slides after delete middle [TestDeleteSlideRemainingCount]
    Given pptx tools
    And an isolated writable temporary directory
    And prs.save with temp dir under "five_slides.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "five_slides.pptx"
    When pptx tools.tool pptx delete slide using file path str representation of temp dir under "five_slides.pptx"; slide number 3; output path str representation of temp dir under "five_slides.pptx"
    Then result field "success" is true
    And result at "remaining_slides" equals 4
    And the number of entries in the result of Presentation with str representation of temp dir under "five_slides.pptx" slides equals 4
