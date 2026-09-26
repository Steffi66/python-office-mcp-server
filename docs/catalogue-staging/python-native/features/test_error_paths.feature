@captured @python_candidate
Feature: error paths native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-error-paths-0cd2de5304
  # Native: tests/test_error_paths.py::TestToolInstantiation::test_tool_instance_creation
  Scenario: Native check: tool instance creation [TestToolInstantiation]
    Given the current parametrised test context
    And a prepared tool fixture input or fixture
    And tools is prepared as the result of request.getfixturevalue with tool fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [word_tools] | {"tool_fixture": "'word_tools'"} |
      | [word_advanced_tools] | {"tool_fixture": "'word_advanced_tools'"} |
      | [pptx_tools] | {"tool_fixture": "'pptx_tools'"} |
      | [pptx_advanced_tools] | {"tool_fixture": "'pptx_advanced_tools'"} |
      | [excel_tools] | {"tool_fixture": "'excel_tools'"} |
    When request.getfixturevalue using tool fixture
    Then the result of request.getfixturevalue with tool fixture is not null

  @candidate-python-error-paths-8b1146f03a
  # Native: tests/test_error_paths.py::TestNonexistentFileHandling::test_nonexistent_file_error
  Scenario: Native check: nonexistent file error [TestNonexistentFileHandling]
    Given the current parametrised test context
    And a prepared tool fixture input or fixture
    And a prepared method input or fixture
    And a prepared path input or fixture
    And tools is prepared as the result of request.getfixturevalue with tool fixture
    And result is prepared as the result of getattr(tools, method) with path
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [word_tools-tool_word_extract-/nonexistent/path.docx] | {"tool_fixture": "'word_tools'", "method": "'tool_word_extract'", "path": "'/nonexistent/path.docx'"} |
      | [word_tools-tool_word_to_markdown-/nonexistent/path.docx] | {"tool_fixture": "'word_tools'", "method": "'tool_word_to_markdown'", "path": "'/nonexistent/path.docx'"} |
      | [pptx_tools-tool_pptx_extract-/nonexistent/path.pptx] | {"tool_fixture": "'pptx_tools'", "method": "'tool_pptx_extract'", "path": "'/nonexistent/path.pptx'"} |
      | [pptx_tools-tool_pptx_to_markdown-/nonexistent/path.pptx] | {"tool_fixture": "'pptx_tools'", "method": "'tool_pptx_to_markdown'", "path": "'/nonexistent/path.pptx'"} |
      | [excel_tools-tool_excel_extract-/nonexistent/path.xlsx] | {"tool_fixture": "'excel_tools'", "method": "'tool_excel_extract'", "path": "'/nonexistent/path.xlsx'"} |
    When request.getfixturevalue using tool fixture
    And getattr(tools, method) using path
    Then "error" occurs in str representation of the result of getattr(tools, method) with path in lowercase

  @candidate-python-error-paths-28b7452624
  # Native: tests/test_error_paths.py::TestExcelPaths::test_extract_nonexistent_excel
  Scenario: Native check: extract nonexistent excel [TestExcelPaths]
    Given Create an instance of ExcelTools.
    When excel tools.tool excel extract using "/nonexistent/path.xlsx"
    Then "error" occurs in result

  @candidate-python-error-paths-b69dda7213
  # Native: tests/test_error_paths.py::TestExcelPaths::test_from_markdown_empty
  Scenario: Native check: from markdown empty [TestExcelPaths]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And path is prepared as temp dir under "empty.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "empty.xlsx"; ""
    Then result has type dict

  @candidate-python-error-paths-9101139036
  # Native: tests/test_error_paths.py::TestExcelPaths::test_from_markdown_no_tables
  Scenario: Native check: from markdown no tables [TestExcelPaths]
    Given Create an instance of ExcelTools.
    And an isolated writable temporary directory
    And path is prepared as temp dir under "no_tables.xlsx"
    When excel tools.tool excel from markdown using str representation of temp dir under "no_tables.xlsx"; "# Just a heading\n\nSome text."
    Then result has type dict

  @candidate-python-error-paths-e94c4a8d11
  # Native: tests/test_error_paths.py::TestWordErrorPaths::test_list_sections_invalid_docx
  Scenario: Native check: list sections invalid docx [TestWordErrorPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And path.write text with "not a valid docx"
    And path is prepared as temp dir under "fake.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "fake.docx"
    Then "error" occurs in result

  @candidate-python-error-paths-6db872c3a3
  # Native: tests/test_error_paths.py::TestWordErrorPaths::test_get_table_invalid_index
  Scenario: Native check: get table invalid index [TestWordErrorPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "table.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "table.docx"
    When word advanced tools.tool word get table using str representation of temp dir under "table.docx"; "-1"
    Then result has type dict

  @candidate-python-error-paths-d37808aeb7
  # Native: tests/test_error_paths.py::TestPptxErrorPaths::test_list_slides_invalid_pptx
  Scenario: Native check: list slides invalid pptx [TestPptxErrorPaths]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And path.write text with "not a valid pptx"
    And path is prepared as temp dir under "fake.pptx"
    When pptx advanced tools.tool pptx list slides using str representation of temp dir under "fake.pptx"
    Then "error" occurs in result

  @candidate-python-error-paths-b72c2cb502
  # Native: tests/test_error_paths.py::TestPptxErrorPaths::test_add_slide_invalid_position
  Scenario: Native check: add slide invalid position [TestPptxErrorPaths]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "pos.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "pos.pptx"
    And output is prepared as temp dir under "added.pptx"
    When pptx advanced tools.tool pptx add slide using str representation of temp dir under "pos.pptx"; position "invalid"; output path str representation of temp dir under "added.pptx"
    Then result has type dict

  @candidate-python-error-paths-bd23a36c79
  # Native: tests/test_error_paths.py::TestWordOutputPaths::test_patch_section_no_output
  Scenario: Native check: patch section no output [TestWordOutputPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_out.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_out.docx"
    When word advanced tools.tool word patch section using str representation of temp dir under "no_out.docx"; "Section"; "New content"
    Then result has type dict

  @candidate-python-error-paths-b1c9aa9e3b
  # Native: tests/test_error_paths.py::TestWordOutputPaths::test_insert_row_no_output
  Scenario: Native check: insert row no output [TestWordOutputPaths]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "row_no_out.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "row_no_out.docx"
    When word advanced tools.tool word insert table row using str representation of temp dir under "row_no_out.docx"; "0"; {"A": "X", "B": "Y"}
    Then result has type dict

  @candidate-python-error-paths-49c6f3c4d9
  # Native: tests/test_error_paths.py::TestPptxOutputPaths::test_patch_shape_no_output
  Scenario: Native check: patch shape no output [TestPptxOutputPaths]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "patch_no_out.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "patch_no_out.pptx"
    When pptx advanced tools.tool pptx patch shape using str representation of temp dir under "patch_no_out.pptx"; slide number 1; shape identifier "title"; new text "New Title"
    Then result has type dict

  @candidate-python-error-paths-e6998a4a69
  # Native: tests/test_error_paths.py::TestSpecialCharacters::test_word_with_unicode
  Scenario: Native check: word with unicode [TestSpecialCharacters]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "unicode.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "unicode.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "unicode.docx"
    Then result has type dict

  @candidate-python-error-paths-7419e60466
  # Native: tests/test_error_paths.py::TestSpecialCharacters::test_pptx_with_unicode
  Scenario: Native check: pptx with unicode [TestSpecialCharacters]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "unicode.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Ünïcödé Título 日本語"
    And path is prepared as temp dir under "unicode.pptx"
    When pptx advanced tools.tool pptx list slides using str representation of temp dir under "unicode.pptx"
    Then result has type dict

  @candidate-python-error-paths-72b71dcb10
  # Native: tests/test_error_paths.py::TestEmptyDocuments::test_empty_word_extract
  Scenario: Native check: empty word extract [TestEmptyDocuments]
    Given Create an instance of WordTools.
    And Create an empty Word document.
    When word tools.tool word extract using str representation of empty docx
    Then result has type dict

  @candidate-python-error-paths-f2c11022e4
  # Native: tests/test_error_paths.py::TestEmptyDocuments::test_empty_pptx_extract
  Scenario: Native check: empty pptx extract [TestEmptyDocuments]
    Given Create an instance of PowerPointTools.
    And Create an empty PowerPoint presentation.
    When pptx tools.tool pptx extract using str representation of empty pptx
    Then result has type dict

  @candidate-python-error-paths-2d8b5a4fa8
  # Native: tests/test_error_paths.py::TestLargeContent::test_many_sections
  Scenario: Native check: many sections [TestLargeContent]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "many_sections.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "many_sections.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "many_sections.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 20

  @candidate-python-error-paths-8ba4069a1a
  # Native: tests/test_error_paths.py::TestLargeContent::test_many_slides
  Scenario: Native check: many slides [TestLargeContent]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "many_slides.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "many_slides.pptx"
    When pptx advanced tools.tool pptx list slides using str representation of temp dir under "many_slides.pptx"
    Then result field "slide_count", defaulting to 0 is at least 10

  @candidate-python-error-paths-baec4a14d7
  # Native: tests/test_error_paths.py::TestWordMarkdownEdgeCases::test_from_markdown_complex_list
  Scenario: Native check: from markdown complex list [TestWordMarkdownEdgeCases]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Document\n\n## Section 1\n\n- Item 1\n - Nested 1.1\n - Nested 1.2\n- Item 2\n - Nested 2.1\n - Deep nested\n\n## Section 2\n\n1. Numbered\n2. List\n3. Items\n"
    And path is prepared as temp dir under "complex_list.docx"
    When word tools.tool word from markdown using str representation of temp dir under "complex_list.docx"; "# Document\n\n## Section 1\n\n- Item 1\n - Nested 1.1\n - Nested 1.2\n- Item 2\n - Nested 2.1\n - Deep nested\n\n## Section 2\n\n1. Numbered\n2. List\n3. Items\n"
    Then the result of Path with temp dir under "complex_list.docx" exists is non-empty or true

  @candidate-python-error-paths-f97c7bf6ea
  # Native: tests/test_error_paths.py::TestPptxMarkdownEdgeCases::test_from_markdown_multiple_tables
  Scenario: Native check: from markdown multiple tables [TestPptxMarkdownEdgeCases]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Data Report\n\n## Table 1\n\n| A | B | C |\n|---|---|---|\n| 1 | 2 | 3 |\n\n---\n\n## Table 2\n\n| X | Y |\n|---|---|\n| a | b |\n"
    And path is prepared as temp dir under "multi_table.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "multi_table.pptx"; "# Data Report\n\n## Table 1\n\n| A | B | C |\n|---|---|---|\n| 1 | 2 | 3 |\n\n---\n\n## Table 2\n\n| X | Y |\n|---|---|\n| a | b |\n"
    Then the result of Path with temp dir under "multi_table.pptx" exists is non-empty or true
