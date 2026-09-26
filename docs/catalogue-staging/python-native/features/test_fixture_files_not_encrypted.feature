@captured @python_candidate
Feature: fixture files not encrypted native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-fixture-files-not-encrypted-6ef4a69253
  # Native: tests/test_fixture_files_not_encrypted.py::test_fixture_file_is_not_encrypted
  Scenario: Native check: fixture file is not encrypted
    Given a prepared fixture path input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [fixture_path0] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/comments.xlsx')"} |
      | [fixture_path1] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/conditional_format.xlsx')"} |
      | [fixture_path2] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/data_types.xlsx')"} |
      | [fixture_path3] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/formatting.xlsx')"} |
      | [fixture_path4] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/formulas.xlsx')"} |
      | [fixture_path5] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/merged_cells.xlsx')"} |
      | [fixture_path6] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/minimal.xlsx')"} |
      | [fixture_path7] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/multiple_sheets.xlsx')"} |
      | [fixture_path8] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/named_ranges.xlsx')"} |
      | [fixture_path9] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/single_cell.xlsx')"} |
      | [fixture_path10] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/excel/tables.xlsx')"} |
      | [fixture_path11] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/bullet_points.pptx')"} |
      | [fixture_path12] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/comments.pptx')"} |
      | [fixture_path13] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/hidden_slides.pptx')"} |
      | [fixture_path14] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/images.pptx')"} |
      | [fixture_path15] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/layouts.pptx')"} |
      | [fixture_path16] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/minimal.pptx')"} |
      | [fixture_path17] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/multiple_masters.pptx')"} |
      | [fixture_path18] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/notes.pptx')"} |
      | [fixture_path19] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/shapes.pptx')"} |
      | [fixture_path20] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/tables.pptx')"} |
      | [fixture_path21] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/pptx/title_slide.pptx')"} |
      | [fixture_path22] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/bullet_list.docx')"} |
      | [fixture_path23] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/comments.docx')"} |
      | [fixture_path24] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/complex_table.docx')"} |
      | [fixture_path25] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/formatted_text.docx')"} |
      | [fixture_path26] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/headers_footers.docx')"} |
      | [fixture_path27] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/headings.docx')"} |
      | [fixture_path28] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/minimal.docx')"} |
      | [fixture_path29] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/numbered_list.docx')"} |
      | [fixture_path30] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/sdt_content_controls.docx')"} |
      | [fixture_path31] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/simple_table.docx')"} |
      | [fixture_path32] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/single_paragraph.docx')"} |
      | [fixture_path33] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/styles.docx')"} |
      | [fixture_path34] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/projects/python-office-mcp-server/references/fixtures-ooxml/fixtures/python-office-mcp-server/tests/_templates/testdata/word/track_changes.docx')"} |
    When zf.testzip using the prepared inputs
    And zf.infolist using the prepared inputs
    Then the result of zipfile.is zipfile with fixture path is non-empty or true
    And the result of zf.testzip with no arguments is null
    And not info filename for each info in the result of zf.infolist with no arguments where info flag bits combined with 1

  @candidate-python-fixture-files-not-encrypted-3416fbdf27
  # Native: tests/test_fixture_files_not_encrypted.py::test_office_fixture_inventory_not_empty
  Scenario: Native check: office fixture inventory not empty
    Given files is prepared as the result of office fixture files with no arguments
    When office fixture files using the prepared inputs
    Then the number of entries in the result of office fixture files with no arguments equals 35
