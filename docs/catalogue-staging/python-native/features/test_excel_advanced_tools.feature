@captured @python_candidate
Feature: excel advanced tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-excel-advanced-tools-ea0130bb3c
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_parse_cell_reference_simple
  Scenario: Native check: parse cell reference simple [TestHelperFunctions]
    Given the native parse cell reference simple inputs and isolated test state
    When parse cell reference using "A1"
    Then sheet is null
    And cell equals "A1"

  @candidate-python-excel-advanced-tools-201f064c89
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_parse_cell_reference_with_sheet
  Scenario: Native check: parse cell reference with sheet [TestHelperFunctions]
    Given the native parse cell reference with sheet inputs and isolated test state
    When parse cell reference using "Sheet1!B5"
    Then sheet equals "Sheet1"
    And cell equals "B5"

  @candidate-python-excel-advanced-tools-0d33f2e6ed
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_parse_cell_reference_quoted_sheet
  Scenario: Native check: parse cell reference quoted sheet [TestHelperFunctions]
    Given the native parse cell reference quoted sheet inputs and isolated test state
    When parse cell reference using "'My Sheet'!C10"
    Then sheet equals "My Sheet"
    And cell equals "C10"

  @candidate-python-excel-advanced-tools-8b53158668
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_get_range_bounds_single_cell
  Scenario: Native check: get range bounds single cell [TestHelperFunctions]
    Given the native get range bounds single cell inputs and isolated test state
    When get range bounds using "B5"
    Then min row equals 5
    And min col equals 2
    And max row equals 5
    And max col equals 2

  @candidate-python-excel-advanced-tools-ac6019d072
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_get_range_bounds_range
  Scenario: Native check: get range bounds range [TestHelperFunctions]
    Given the native get range bounds range inputs and isolated test state
    When get range bounds using "A1:D10"
    Then min row equals 1
    And min col equals 1
    And max row equals 10
    And max col equals 4

  @candidate-python-excel-advanced-tools-38e11271b2
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_get_range_bounds_invalid
  Scenario: Native check: get range bounds invalid [TestHelperFunctions]
    Given the native get range bounds invalid inputs and isolated test state
    When get range bounds using "invalid"
    Then the operation raises ValueError

  @candidate-python-excel-advanced-tools-2120c61bd1
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_ensure_change_log_sheet
  Scenario: Native check: ensure change log sheet [TestHelperFunctions]
    Given wb is prepared as the result of Workbook with no arguments
    When ensure change log sheet using the result of Workbook with no arguments
    Then "_ChangeLog" does not occur in the result of Workbook with no arguments sheetnames
    And "_ChangeLog" occurs in the result of Workbook with no arguments sheetnames
    And the result of Workbook with no arguments at "_ChangeLog" at "A1" value equals "Timestamp"
    And the result of Workbook with no arguments at "_ChangeLog" at "F1" value equals "Author"

  @candidate-python-excel-advanced-tools-a701356ba1
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_log_change
  Scenario: Native check: log change [TestHelperFunctions]
    Given wb is prepared as the result of Workbook with no arguments
    When log change using the result of Workbook with no arguments; "Sheet1"; "A1"; "old"; "new"; "TestAuthor"
    Then "_ChangeLog" occurs in the result of Workbook with no arguments sheetnames
    And the result of Workbook with no arguments at "_ChangeLog" at "B2" value equals "Sheet1"
    And the result of Workbook with no arguments at "_ChangeLog" at "C2" value equals "A1"
    And the result of Workbook with no arguments at "_ChangeLog" at "D2" value equals "old"
    And the result of Workbook with no arguments at "_ChangeLog" at "E2" value equals "new"
    And the result of Workbook with no arguments at "_ChangeLog" at "F2" value equals "TestAuthor"

  @candidate-python-excel-advanced-tools-851ff41829
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_highlight_cell
  Scenario: Native check: highlight cell [TestHelperFunctions]
    Given wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And cell is prepared as the result of Workbook with no arguments active at "A1"
    And the result of Workbook with no arguments active at "A1" value is set to "Test"
    When highlight cell using the result of Workbook with no arguments active at "A1"
    Then the result of Workbook with no arguments active at "A1" fill start color rgb ends with "FFFF99" is non-empty or true

  @candidate-python-excel-advanced-tools-0250ec1ba5
  # Native: tests/test_excel_advanced_tools.py::TestHelperFunctions::test_add_change_comment
  Scenario: Native check: add change comment [TestHelperFunctions]
    Given wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And cell is prepared as the result of Workbook with no arguments active at "A1"
    And the result of Workbook with no arguments active at "A1" value is set to "Test"
    When add change comment using the result of Workbook with no arguments active at "A1"; "old_value"; "new_value"; "TestAuthor"
    Then the result of Workbook with no arguments active at "A1" comment is not null
    And "TestAuthor" occurs in the result of Workbook with no arguments active at "A1" comment text
    And "old_value" occurs in the result of Workbook with no arguments active at "A1" comment text
    And "new_value" occurs in the result of Workbook with no arguments active at "A1" comment text

  @candidate-python-excel-advanced-tools-7f9d783847
  # Native: tests/test_excel_advanced_tools.py::TestListSheets::test_lists_all_sheets
  Scenario: Native check: lists all sheets [TestListSheets]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with multiple sheets including hidden ones.
    When excel advanced tools.tool excel list sheets using str representation of multi sheet xlsx
    Then result at "sheet_count" equals 3
    And "Main" occurs in s at "name" for each s in result at "sheets"
    And "Hidden" occurs in s at "name" for each s in result at "sheets"
    And "VeryHidden" occurs in s at "name" for each s in result at "sheets"

  @candidate-python-excel-advanced-tools-552637a2b8
  # Native: tests/test_excel_advanced_tools.py::TestListSheets::test_excludes_hidden_when_requested
  Scenario: Native check: excludes hidden when requested [TestListSheets]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with multiple sheets including hidden ones.
    When excel advanced tools.tool excel list sheets using str representation of multi sheet xlsx; include hidden false
    Then result at "sheet_count" equals 1
    And result at "sheets" at 0 at "name" equals "Main"

  @candidate-python-excel-advanced-tools-41f216f500
  # Native: tests/test_excel_advanced_tools.py::TestListSheets::test_includes_sheet_state
  Scenario: Native check: includes sheet state [TestListSheets]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with multiple sheets including hidden ones.
    When excel advanced tools.tool excel list sheets using str representation of multi sheet xlsx
    Then s at "state" for each s in result at "sheets" at "Main" equals "visible"
    And s at "state" for each s in result at "sheets" at "Hidden" equals "hidden"
    And s at "state" for each s in result at "sheets" at "VeryHidden" equals "veryHidden"

  @candidate-python-excel-advanced-tools-819ee6a329
  # Native: tests/test_excel_advanced_tools.py::TestListSheets::test_file_not_found
  Scenario: Native check: file not found [TestListSheets]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel list sheets using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-d0275c44fe
  # Native: tests/test_excel_advanced_tools.py::TestListNamedRanges::test_lists_named_ranges
  Scenario: Native check: lists named ranges [TestListNamedRanges]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with named ranges.
    When excel advanced tools.tool excel list named ranges using str representation of xlsx with named ranges
    Then result at "count" is at least 2
    And "CustomerName" occurs in nr at "name" for each nr in result at "named_ranges"
    And "Amount" occurs in nr at "name" for each nr in result at "named_ranges"

  @candidate-python-excel-advanced-tools-b2d0cc12e6
  # Native: tests/test_excel_advanced_tools.py::TestListNamedRanges::test_includes_scope
  Scenario: Native check: includes scope [TestListNamedRanges]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with named ranges.
    When excel advanced tools.tool excel list named ranges using str representation of xlsx with named ranges
    Then nr at "scope" for each nr in result at "named_ranges" at "CustomerName" equals "Workbook"
    And nr at "scope" for each nr in result at "named_ranges" at "DataRange" equals "Workbook"

  @candidate-python-excel-advanced-tools-e8d52b6da4
  # Native: tests/test_excel_advanced_tools.py::TestListNamedRanges::test_file_not_found
  Scenario: Native check: file not found [TestListNamedRanges]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel list named ranges using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-b670e50110
  # Native: tests/test_excel_advanced_tools.py::TestListTables::test_lists_tables
  Scenario: Native check: lists tables [TestListTables]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel list tables using str representation of xlsx with table
    Then result at "table_count" equals 1
    And result at "tables" at 0 at "name" equals "Tasks"

  @candidate-python-excel-advanced-tools-077d20359c
  # Native: tests/test_excel_advanced_tools.py::TestListTables::test_includes_columns
  Scenario: Native check: includes columns [TestListTables]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel list tables using str representation of xlsx with table
    Then "Task" occurs in result at "tables" at 0 at "columns"
    And "Owner" occurs in result at "tables" at 0 at "columns"
    And "Status" occurs in result at "tables" at 0 at "columns"

  @candidate-python-excel-advanced-tools-4e1541d15c
  # Native: tests/test_excel_advanced_tools.py::TestListTables::test_filter_by_sheet
  Scenario: Native check: filter by sheet [TestListTables]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel list tables using str representation of xlsx with table; sheet name "NonExistent"
    Then result at "table_count" equals 0

  @candidate-python-excel-advanced-tools-dd8302102a
  # Native: tests/test_excel_advanced_tools.py::TestListTables::test_file_not_found
  Scenario: Native check: file not found [TestListTables]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel list tables using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-cef958f7ee
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_reads_single_cell
  Scenario: Native check: reads single cell [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get range using str representation of simple xlsx; "A1"; sheet name "Data"
    Then result at "row_count" equals 1
    And result at "col_count" equals 1
    And result at "data" at 0 at 0 at "value" equals "Name"

  @candidate-python-excel-advanced-tools-214a3609a0
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_reads_range
  Scenario: Native check: reads range [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get range using str representation of simple xlsx; "A1:C2"; sheet name "Data"
    Then result at "row_count" equals 2
    And result at "col_count" equals 3

  @candidate-python-excel-advanced-tools-6c18c0a043
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_includes_formulas
  Scenario: Native check: includes formulas [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get range using str representation of simple xlsx; "B1"; sheet name "Summary"; include formulas true
    Then result at "data" at 0 at 0 at "value" is not null

  @candidate-python-excel-advanced-tools-3e704f9d5d
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_sheet_in_reference
  Scenario: Native check: sheet in reference [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get range using str representation of simple xlsx; "Data!A1"
    Then result at "sheet" equals "Data"

  @candidate-python-excel-advanced-tools-59c867b840
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_file_not_found
  Scenario: Native check: file not found [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel get range using "/nonexistent.xlsx"; "A1"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-321e26702e
  # Native: tests/test_excel_advanced_tools.py::TestGetRange::test_sheet_not_found
  Scenario: Native check: sheet not found [TestGetRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get range using str representation of simple xlsx; "A1"; sheet name "NonExistent"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-2fd1f9f9ab
  # Native: tests/test_excel_advanced_tools.py::TestPatchCell::test_updates_cell
  Scenario: Native check: updates cell [TestPatchCell]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel patch cell using str representation of simple xlsx; "A2"; "Updated"; sheet name "Data"
    Then result at "success" is true
    And result at "old_value" equals "Item 1"
    And result at "new_value" equals "Updated"
    And the result of load workbook with simple xlsx at "Data" at "A2" value equals "Updated"

  @candidate-python-excel-advanced-tools-2d2452eaa4
  # Native: tests/test_excel_advanced_tools.py::TestPatchCell::test_creates_change_log
  Scenario: Native check: creates change log [TestPatchCell]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel patch cell using str representation of simple xlsx; "A2"; "Updated"; sheet name "Data"
    Then "_ChangeLog" occurs in the result of load workbook with simple xlsx sheetnames

  @candidate-python-excel-advanced-tools-d6d21f3e4f
  # Native: tests/test_excel_advanced_tools.py::TestPatchCell::test_highlights_cell
  Scenario: Native check: highlights cell [TestPatchCell]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel patch cell using str representation of simple xlsx; "A2"; "Updated"; sheet name "Data"; highlight true
    Then the result of load workbook with simple xlsx at "Data" at "A2" fill start color rgb ends with "FFFF99" is non-empty or true

  @candidate-python-excel-advanced-tools-0da7770284
  # Native: tests/test_excel_advanced_tools.py::TestPatchCell::test_respects_output_path
  Scenario: Native check: respects output path [TestPatchCell]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched.xlsx"
    When excel advanced tools.tool excel patch cell using str representation of simple xlsx; "A2"; "Updated"; sheet name "Data"; output path str representation of temp dir under "patched.xlsx"
    Then result at "file" equals str representation of temp dir under "patched.xlsx"
    And temp dir under "patched.xlsx" exists is non-empty or true

  @candidate-python-excel-advanced-tools-61799c517b
  # Native: tests/test_excel_advanced_tools.py::TestPatchCell::test_file_not_found
  Scenario: Native check: file not found [TestPatchCell]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel patch cell using "/nonexistent.xlsx"; "A1"; "value"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-b06a29dbd1
  # Native: tests/test_excel_advanced_tools.py::TestPatchRange::test_updates_range
  Scenario: Native check: updates range [TestPatchRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And values is prepared as [["New1", 111, "Status1"], ["New2", 222, "Status2"]]
    When excel advanced tools.tool excel patch range using str representation of simple xlsx; "A2:C3"; [["New1", 111, "Status1"], ["New2", 222, "Status2"]]; sheet name "Data"
    Then result at "success" is true
    And result at "cells_changed" exceeds 0

  @candidate-python-excel-advanced-tools-38ca94720e
  # Native: tests/test_excel_advanced_tools.py::TestPatchRange::test_validates_dimensions
  Scenario: Native check: validates dimensions [TestPatchRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And values is prepared as [["Only", "Two"]]
    When excel advanced tools.tool excel patch range using str representation of simple xlsx; "A2:C3"; [["Only", "Two"]]; sheet name "Data"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-4efa14eea8
  # Native: tests/test_excel_advanced_tools.py::TestPatchRange::test_logs_all_changes
  Scenario: Native check: logs all changes [TestPatchRange]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And values is prepared as [["New1", 111, "Status1"]]
    When excel advanced tools.tool excel patch range using str representation of simple xlsx; "A2:C2"; [["New1", 111, "Status1"]]; sheet name "Data"
    Then the number of entries in row for each row in the result of ws.iter rows with min row 2; values only true where at least one item satisfies row is at least 1

  @candidate-python-excel-advanced-tools-6d515dcbad
  # Native: tests/test_excel_advanced_tools.py::TestGetTable::test_reads_table_data
  Scenario: Native check: reads table data [TestGetTable]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel get table using str representation of xlsx with table; "Tasks"
    Then result at "table_name" equals "Tasks"
    And result at "row_count" is at least 3

  @candidate-python-excel-advanced-tools-d6d8ae4cc2
  # Native: tests/test_excel_advanced_tools.py::TestGetTable::test_includes_columns
  Scenario: Native check: includes columns [TestGetTable]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel get table using str representation of xlsx with table; "Tasks"
    Then "Task" occurs in result at "columns"
    And "Owner" occurs in result at "columns"

  @candidate-python-excel-advanced-tools-1ab131b17f
  # Native: tests/test_excel_advanced_tools.py::TestGetTable::test_excludes_headers
  Scenario: Native check: excludes headers [TestGetTable]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel get table using str representation of xlsx with table; "Tasks"; include headers false
    Then result at "data" at 0 at 0 differs from "Task"

  @candidate-python-excel-advanced-tools-719e045c37
  # Native: tests/test_excel_advanced_tools.py::TestGetTable::test_table_not_found
  Scenario: Native check: table not found [TestGetTable]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel get table using str representation of xlsx with table; "NonExistent"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-8e92c0ded0
  # Native: tests/test_excel_advanced_tools.py::TestAppendTableRow::test_appends_row
  Scenario: Native check: appends row [TestAppendTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel append table row using str representation of xlsx with table; "Tasks"; {"Task": "Deploy", "Owner": "Dave", "Status": "Pending", "Due Date": "2026-04-01"}
    Then result at "success" is true
    And result at "new_row" equals 5

  @candidate-python-excel-advanced-tools-cd5ee6349f
  # Native: tests/test_excel_advanced_tools.py::TestAppendTableRow::test_expands_table_range
  Scenario: Native check: expands table range [TestAppendTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel append table row using str representation of xlsx with table; "Tasks"; {"Task": "New Task"}
    Then "D5" occurs in result at "new_range"

  @candidate-python-excel-advanced-tools-80429bde84
  # Native: tests/test_excel_advanced_tools.py::TestAppendTableRow::test_handles_partial_data
  Scenario: Native check: handles partial data [TestAppendTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel append table row using str representation of xlsx with table; "Tasks"; {"Task": "Partial"}
    Then result at "success" is true
    And "Task" occurs in result at "columns_filled"

  @candidate-python-excel-advanced-tools-0bf44474c4
  # Native: tests/test_excel_advanced_tools.py::TestUpdateTableRow::test_updates_row
  Scenario: Native check: updates row [TestUpdateTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel update table row using str representation of xlsx with table; "Tasks"; 1; {"Status": "Done"}
    Then result at "success" is true
    And the number of entries in result at "updates" equals 1
    And result at "updates" at 0 at "column" equals "Status"

  @candidate-python-excel-advanced-tools-6b8c47f44a
  # Native: tests/test_excel_advanced_tools.py::TestUpdateTableRow::test_row_out_of_range
  Scenario: Native check: row out of range [TestUpdateTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel update table row using str representation of xlsx with table; "Tasks"; 100; {"Status": "Done"}
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-38510db45e
  # Native: tests/test_excel_advanced_tools.py::TestUpdateTableRow::test_logs_and_highlights
  Scenario: Native check: logs and highlights [TestUpdateTableRow]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with an Excel table.
    When excel advanced tools.tool excel update table row using str representation of xlsx with table; "Tasks"; 1; {"Status": "Done"}
    Then "_ChangeLog" occurs in the result of load workbook with xlsx with table sheetnames

  @candidate-python-excel-advanced-tools-51c5a520bc
  # Native: tests/test_excel_advanced_tools.py::TestReplacePlaceholders::test_replaces_placeholders
  Scenario: Native check: replaces placeholders [TestReplacePlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel replace placeholders using str representation of xlsx with placeholders; {"<Customer Name>": "Contoso", "<Project Name>": "Migration"}
    Then result at "success" is true
    And result at "total_replacements" is at least 2

  @candidate-python-excel-advanced-tools-e74cf219ab
  # Native: tests/test_excel_advanced_tools.py::TestReplacePlaceholders::test_counts_by_placeholder
  Scenario: Native check: counts by placeholder [TestReplacePlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel replace placeholders using str representation of xlsx with placeholders; {"<Customer Name>": "Contoso"}
    Then result at "by_placeholder" at "<Customer Name>" is at least 2

  @candidate-python-excel-advanced-tools-0fb72008b0
  # Native: tests/test_excel_advanced_tools.py::TestReplacePlaceholders::test_handles_partial_replacement
  Scenario: Native check: handles partial replacement [TestReplacePlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel replace placeholders using str representation of xlsx with placeholders; {"<Customer Name>": "Contoso", "<Project Name>": "Migration"}
    Then "Contoso" occurs in the result of load workbook with xlsx with placeholders at "Form" at "B5" value
    And "Migration" occurs in the result of load workbook with xlsx with placeholders at "Form" at "B5" value

  @candidate-python-excel-advanced-tools-e13c84ff68
  # Native: tests/test_excel_advanced_tools.py::TestReplacePlaceholders::test_filters_by_sheet
  Scenario: Native check: filters by sheet [TestReplacePlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel replace placeholders using str representation of xlsx with placeholders; {"<Customer Name>": "Contoso"}; sheet names ["NonExistent"]
    Then result at "total_replacements" equals 0

  @candidate-python-excel-advanced-tools-0df8471564
  # Native: tests/test_excel_advanced_tools.py::TestAuditPlaceholders::test_finds_placeholders
  Scenario: Native check: finds placeholders [TestAuditPlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel audit placeholders using str representation of xlsx with placeholders
    Then result at "total_found" exceeds 0
    And result at "status" equals "needs_attention"

  @candidate-python-excel-advanced-tools-5f7af56b5d
  # Native: tests/test_excel_advanced_tools.py::TestAuditPlaceholders::test_reports_locations
  Scenario: Native check: reports locations [TestAuditPlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel audit placeholders using str representation of xlsx with placeholders
    Then "B1" occurs in f at "cell" for each f in result at "findings" or "B2" occurs in f at "cell" for each f in result at "findings"

  @candidate-python-excel-advanced-tools-b61524e37f
  # Native: tests/test_excel_advanced_tools.py::TestAuditPlaceholders::test_custom_patterns
  Scenario: Native check: custom patterns [TestAuditPlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create workbook with various placeholder patterns.
    When excel advanced tools.tool excel audit placeholders using str representation of xlsx with placeholders; patterns ["[TBD]"]
    Then result at "total_found" is at least 1

  @candidate-python-excel-advanced-tools-690cb3c9a8
  # Native: tests/test_excel_advanced_tools.py::TestAuditPlaceholders::test_clean_workbook
  Scenario: Native check: clean workbook [TestAuditPlaceholders]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel audit placeholders using str representation of simple xlsx
    Then result at "status" equals "clean"

  @candidate-python-excel-advanced-tools-6e31ecfbde
  # Native: tests/test_excel_advanced_tools.py::TestCopyTemplate::test_copies_file
  Scenario: Native check: copies file [TestCopyTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "copy.xlsx"
    When excel advanced tools.tool excel copy template using str representation of simple xlsx; str representation of temp dir under "copy.xlsx"
    Then result at "success" is true
    And temp dir under "copy.xlsx" exists is non-empty or true

  @candidate-python-excel-advanced-tools-4458c723c4
  # Native: tests/test_excel_advanced_tools.py::TestCopyTemplate::test_preserves_content
  Scenario: Native check: preserves content [TestCopyTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "copy.xlsx"
    When excel advanced tools.tool excel copy template using str representation of simple xlsx; str representation of temp dir under "copy.xlsx"
    Then the result of load workbook with temp dir under "copy.xlsx" at "Data" at "A1" value equals "Name"

  @candidate-python-excel-advanced-tools-42d814dc63
  # Native: tests/test_excel_advanced_tools.py::TestCopyTemplate::test_template_not_found
  Scenario: Native check: template not found [TestCopyTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    When excel advanced tools.tool excel copy template using "/nonexistent.xlsx"; str representation of temp dir under "out.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-eec71d70fa
  # Native: tests/test_excel_advanced_tools.py::TestGetChangeLog::test_no_change_log
  Scenario: Native check: no change log [TestGetChangeLog]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel get change log using str representation of simple xlsx
    Then result at "has_change_log" is false

  @candidate-python-excel-advanced-tools-c04d678f66
  # Native: tests/test_excel_advanced_tools.py::TestGetChangeLog::test_retrieves_log
  Scenario: Native check: retrieves log [TestGetChangeLog]
    Given Create an instance of ExcelAdvancedTools.
    And Create a simple Excel workbook for testing.
    When excel advanced tools.tool excel patch cell using str representation of simple xlsx; "A2"; "Changed"; sheet name "Data"
    And excel advanced tools.tool excel get change log using str representation of simple xlsx
    Then result at "has_change_log" is true
    And result at "entry_count" is at least 1
    And result at "entries" at 0 at "new_value" equals "Changed"

  @candidate-python-excel-advanced-tools-73deb9476c
  # Native: tests/test_excel_advanced_tools.py::TestGetChangeLog::test_file_not_found
  Scenario: Native check: file not found [TestGetChangeLog]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel get change log using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-e9964037af
  # Native: tests/test_excel_advanced_tools.py::TestECIFTemplate::test_list_ecif_sheets
  Scenario: Native check: list ecif sheets [TestECIFTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a local ECIF-like workbook for testing.
    When excel advanced tools.tool excel list sheets using str representation of ecif copy
    Then result at "sheet_count" exceeds 5
    And result at "has_vba" is true
    And "ECIF Work Scope (E)" occurs in s at "name" for each s in result at "sheets"

  @candidate-python-excel-advanced-tools-e9b2d8db46
  # Native: tests/test_excel_advanced_tools.py::TestECIFTemplate::test_list_ecif_tables
  Scenario: Native check: list ecif tables [TestECIFTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a local ECIF-like workbook for testing.
    When excel advanced tools.tool excel list tables using str representation of ecif copy
    Then "Milestones" occurs in t at "name" for each t in result at "tables"

  @candidate-python-excel-advanced-tools-14e48fb339
  # Native: tests/test_excel_advanced_tools.py::TestECIFTemplate::test_get_milestones_table
  Scenario: Native check: get milestones table [TestECIFTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a local ECIF-like workbook for testing.
    When excel advanced tools.tool excel get table using str representation of ecif copy; "Milestones"
    Then result at "table_name" equals "Milestones"
    And "Milestone #" occurs in result at "columns"

  @candidate-python-excel-advanced-tools-afd5d2a874
  # Native: tests/test_excel_advanced_tools.py::TestECIFTemplate::test_list_ecif_named_ranges
  Scenario: Native check: list ecif named ranges [TestECIFTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a local ECIF-like workbook for testing.
    When excel advanced tools.tool excel list named ranges using str representation of ecif copy
    Then result at "count" exceeds 10

  @candidate-python-excel-advanced-tools-102c61cd59
  # Native: tests/test_excel_advanced_tools.py::TestECIFTemplate::test_patch_ecif_cell
  Scenario: Native check: patch ecif cell [TestECIFTemplate]
    Given Create an instance of ExcelAdvancedTools.
    And Create a local ECIF-like workbook for testing.
    When excel advanced tools.tool excel patch cell using str representation of ecif copy; "B5"; "Contoso Corporation"; sheet name "ECIF Work Scope (E)"
    Then result at "success" is true
    And the result of load workbook with ecif copy; keep vba true at "ECIF Work Scope (E)" at "B5" value equals "Contoso Corporation"

  @candidate-python-excel-advanced-tools-6a787e0a58
  # Native: tests/test_excel_advanced_tools.py::TestEdgeCases::test_empty_workbook
  Scenario: Native check: empty workbook [TestEdgeCases]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "empty.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And path is prepared as temp dir under "empty.xlsx"
    When excel advanced tools.tool excel list sheets using str representation of temp dir under "empty.xlsx"
    Then result at "sheet_count" equals 1

  @candidate-python-excel-advanced-tools-5421f0a63b
  # Native: tests/test_excel_advanced_tools.py::TestEdgeCases::test_unicode_content
  Scenario: Native check: unicode content [TestEdgeCases]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "unicode.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "日本語テスト"
    And the result of Workbook with no arguments active at "A2" is set to "Ñoño"
    And path is prepared as temp dir under "unicode.xlsx"
    When excel advanced tools.tool excel get range using str representation of temp dir under "unicode.xlsx"; "A1:A2"
    Then "日本語テスト" occurs in str representation of result at "data"

  @candidate-python-excel-advanced-tools-598f7e714a
  # Native: tests/test_excel_advanced_tools.py::TestEdgeCases::test_special_characters_in_sheet_name
  Scenario: Native check: special characters in sheet name [TestEdgeCases]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "special.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Data (2026)"
    And the result of Workbook with no arguments active at "A1" is set to "Test"
    And path is prepared as temp dir under "special.xlsx"
    When excel advanced tools.tool excel get range using str representation of temp dir under "special.xlsx"; "A1"; sheet name "Data (2026)"
    Then result at "data" at 0 at 0 at "value" equals "Test"

  @candidate-python-excel-advanced-tools-5938f47c31
  # Native: tests/test_excel_advanced_tools.py::TestEdgeCases::test_large_range
  Scenario: Native check: large range [TestEdgeCases]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "large.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And path is prepared as temp dir under "large.xlsx"
    When excel advanced tools.tool excel get range using str representation of temp dir under "large.xlsx"; "A1:J100"
    Then result at "row_count" equals 100
    And result at "col_count" equals 10

  @candidate-python-excel-advanced-tools-2fe97c4343
  # Native: tests/test_excel_advanced_tools.py::TestEdgeCases::test_numeric_coercion
  Scenario: Native check: numeric coercion [TestEdgeCases]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "numbers.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to 123
    And the result of Workbook with no arguments active at "A2" is set to 45.67
    And the result of Workbook with no arguments active at "A3" is set to "Not a number"
    And path is prepared as temp dir under "numbers.xlsx"
    When excel advanced tools.tool excel get range using str representation of temp dir under "numbers.xlsx"; "A1:A3"
    Then result at "data" at 0 at 0 at "type" equals "int"
    And result at "data" at 1 at 0 at "type" equals "float"
    And result at "data" at 2 at 0 at "type" equals "str"

  @candidate-python-excel-advanced-tools-02882f12b0
  # Native: tests/test_excel_advanced_tools.py::TestListMergedCells::test_lists_merged_cells
  Scenario: Native check: lists merged cells [TestListMergedCells]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "merged.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Data"
    And the result of Workbook with no arguments active at "A1" is set to "Header spanning 3 columns"
    And path is prepared as temp dir under "merged.xlsx"
    When excel advanced tools.tool excel list merged cells using str representation of temp dir under "merged.xlsx"
    Then result at "total_merged_regions" equals 2
    And "Data" occurs in result at "by_sheet"
    And "A1:C1" occurs in m at "range" for each m in result at "by_sheet" at "Data"
    And "B3:B5" occurs in m at "range" for each m in result at "by_sheet" at "Data"

  @candidate-python-excel-advanced-tools-adf3966641
  # Native: tests/test_excel_advanced_tools.py::TestListMergedCells::test_filter_by_sheet
  Scenario: Native check: filter by sheet [TestListMergedCells]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "multi_merge.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws1 is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Sheet1"
    And ws2 is prepared as the result of wb.create sheet with "Sheet2"
    And path is prepared as temp dir under "multi_merge.xlsx"
    When excel advanced tools.tool excel list merged cells using str representation of temp dir under "multi_merge.xlsx"; sheet name "Sheet1"
    Then result at "total_merged_regions" equals 1
    And "Sheet1" occurs in result at "by_sheet"
    And "Sheet2" does not occur in result at "by_sheet"

  @candidate-python-excel-advanced-tools-edc30c78f4
  # Native: tests/test_excel_advanced_tools.py::TestListMergedCells::test_no_merged_cells
  Scenario: Native check: no merged cells [TestListMergedCells]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "no_merge.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "No merges"
    And path is prepared as temp dir under "no_merge.xlsx"
    When excel advanced tools.tool excel list merged cells using str representation of temp dir under "no_merge.xlsx"
    Then result at "total_merged_regions" equals 0
    And result at "by_sheet" equals {}

  @candidate-python-excel-advanced-tools-11a0a27231
  # Native: tests/test_excel_advanced_tools.py::TestListMergedCells::test_file_not_found
  Scenario: Native check: file not found [TestListMergedCells]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel list merged cells using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-ff26d0d6c6
  # Native: tests/test_excel_advanced_tools.py::TestListMergedCells::test_includes_top_left_cell
  Scenario: Native check: includes top left cell [TestListMergedCells]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "topleft.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And path is prepared as temp dir under "topleft.xlsx"
    When excel advanced tools.tool excel list merged cells using str representation of temp dir under "topleft.xlsx"
    Then result at "by_sheet" at "Sheet" at 0 at "top_left" equals "B2"
    And result at "by_sheet" at "Sheet" at 0 at "min_row" equals 2
    And result at "by_sheet" at "Sheet" at 0 at "max_row" equals 4

  @candidate-python-excel-advanced-tools-e5a0758461
  # Native: tests/test_excel_advanced_tools.py::TestAddComment::test_adds_comment
  Scenario: Native check: adds comment [TestAddComment]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "comment.xlsx"
    And ws is prepared as wb active
    And wb active at "A1" is set to "Data"
    And path is prepared as temp dir under "comment.xlsx"
    When excel advanced tools.tool excel add comment using str representation of temp dir under "comment.xlsx"; "A1"; "This is a test comment"; author "Test User"
    Then result at "success" is true
    And result at "appended" is false
    And result at "author" equals "Test User"
    And wb active at "A1" comment is not null
    And "test comment" occurs in wb active at "A1" comment text

  @candidate-python-excel-advanced-tools-db09ae6f35
  # Native: tests/test_excel_advanced_tools.py::TestAddComment::test_appends_to_existing_comment
  Scenario: Native check: appends to existing comment [TestAddComment]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "append_comment.xlsx"
    And ws is prepared as wb active
    And wb active at "A1" is set to "Data"
    And wb active at "A1" comment is set to the result of Comment with "Original comment"; "Author1"
    And path is prepared as temp dir under "append_comment.xlsx"
    When excel advanced tools.tool excel add comment using str representation of temp dir under "append_comment.xlsx"; "A1"; "Appended text"; author "Author2"
    Then result at "success" is true
    And result at "appended" is true
    And "Original comment" occurs in wb active at "A1" comment text
    And "Appended text" occurs in wb active at "A1" comment text

  @candidate-python-excel-advanced-tools-b181363fb4
  # Native: tests/test_excel_advanced_tools.py::TestAddComment::test_sheet_in_reference
  Scenario: Native check: sheet in reference [TestAddComment]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "sheet_ref.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "MySheet"
    And the result of Workbook with no arguments active at "B5" is set to "Value"
    And path is prepared as temp dir under "sheet_ref.xlsx"
    When excel advanced tools.tool excel add comment using str representation of temp dir under "sheet_ref.xlsx"; "MySheet!B5"; "Comment via sheet ref"
    Then result at "success" is true
    And result at "sheet" equals "MySheet"

  @candidate-python-excel-advanced-tools-c7f3391f95
  # Native: tests/test_excel_advanced_tools.py::TestAddComment::test_file_not_found
  Scenario: Native check: file not found [TestAddComment]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel add comment using "/nonexistent.xlsx"; "A1"; "Comment"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-ca3136d8cd
  # Native: tests/test_excel_advanced_tools.py::TestAddComment::test_sheet_not_found
  Scenario: Native check: sheet not found [TestAddComment]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "no_sheet.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And path is prepared as temp dir under "no_sheet.xlsx"
    When excel advanced tools.tool excel add comment using str representation of temp dir under "no_sheet.xlsx"; "A1"; "Comment"; sheet name "NonExistent"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-07eb85ead0
  # Native: tests/test_excel_advanced_tools.py::TestGetComments::test_gets_comments
  Scenario: Native check: gets comments [TestGetComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "get_comments.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Data"
    And the result of Workbook with no arguments active at "A1" is set to "Value 1"
    And the result of Workbook with no arguments active at "A1" comment is set to the result of Comment with "Comment 1"; "Author1"
    And the result of Workbook with no arguments active at "B2" is set to "Value 2"
    And the result of Workbook with no arguments active at "B2" comment is set to the result of Comment with "Comment 2"; "Author2"
    And path is prepared as temp dir under "get_comments.xlsx"
    When excel advanced tools.tool excel get comments using str representation of temp dir under "get_comments.xlsx"
    Then result at "total_comments" equals 2
    And "Data" occurs in result at "by_sheet"
    And "A1" occurs in c at "cell" for each c in result at "by_sheet" at "Data"
    And "B2" occurs in c at "cell" for each c in result at "by_sheet" at "Data"

  @candidate-python-excel-advanced-tools-9e0c74a510
  # Native: tests/test_excel_advanced_tools.py::TestGetComments::test_filter_by_sheet
  Scenario: Native check: filter by sheet [TestGetComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "multi_comments.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws1 is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active title is set to "Sheet1"
    And the result of Workbook with no arguments active at "A1" comment is set to the result of Comment with "Comment in Sheet1"; "Author"
    And ws2 is prepared as the result of wb.create sheet with "Sheet2"
    And the result of wb.create sheet with "Sheet2" at "A1" comment is set to the result of Comment with "Comment in Sheet2"; "Author"
    And path is prepared as temp dir under "multi_comments.xlsx"
    When excel advanced tools.tool excel get comments using str representation of temp dir under "multi_comments.xlsx"; sheet name "Sheet1"
    Then result at "total_comments" equals 1
    And "Sheet1" occurs in result at "by_sheet"
    And "Sheet2" does not occur in result at "by_sheet"

  @candidate-python-excel-advanced-tools-833b4393c0
  # Native: tests/test_excel_advanced_tools.py::TestGetComments::test_no_comments
  Scenario: Native check: no comments [TestGetComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "no_comments.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "No comments"
    And path is prepared as temp dir under "no_comments.xlsx"
    When excel advanced tools.tool excel get comments using str representation of temp dir under "no_comments.xlsx"
    Then result at "total_comments" equals 0
    And result at "by_sheet" equals {}

  @candidate-python-excel-advanced-tools-5c6168e7d3
  # Native: tests/test_excel_advanced_tools.py::TestGetComments::test_file_not_found
  Scenario: Native check: file not found [TestGetComments]
    Given Create an instance of ExcelAdvancedTools.
    When excel advanced tools.tool excel get comments using "/nonexistent.xlsx"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-c014f58b09
  # Native: tests/test_excel_advanced_tools.py::TestGetComments::test_includes_cell_value
  Scenario: Native check: includes cell value [TestGetComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "value_comment.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "Important Data"
    And the result of Workbook with no arguments active at "A1" comment is set to the result of Comment with "Note about this"; "Author"
    And path is prepared as temp dir under "value_comment.xlsx"
    When excel advanced tools.tool excel get comments using str representation of temp dir under "value_comment.xlsx"
    Then result at "by_sheet" at "Sheet" at 0 at "cell_value" equals "Important Data"
    And result at "by_sheet" at "Sheet" at 0 at "author" equals "Author"

  @candidate-python-excel-advanced-tools-8d61475cef
  # Native: tests/test_excel_advanced_tools.py::TestDeleteComments::test_deletes_comment
  Scenario: Native check: deletes comment [TestDeleteComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "delete_comment.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "Data"
    And the result of Workbook with no arguments active at "A1" comment is set to the result of Comment with "To delete"; "Author"
    And path is prepared as temp dir under "delete_comment.xlsx"
    When excel advanced tools.tool excel delete comment using str representation of temp dir under "delete_comment.xlsx"; "A1"
    Then result field "success" is true
    And the result of load workbook with temp dir under "delete_comment.xlsx" active at "A1" comment is null

  @candidate-python-excel-advanced-tools-51975dedf4
  # Native: tests/test_excel_advanced_tools.py::TestDeleteComments::test_delete_missing_comment_errors
  Scenario: Native check: delete missing comment errors [TestDeleteComments]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "delete_missing_comment.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    And ws is prepared as the result of Workbook with no arguments active
    And the result of Workbook with no arguments active at "A1" is set to "No comment"
    And path is prepared as temp dir under "delete_missing_comment.xlsx"
    When excel advanced tools.tool excel delete comment using str representation of temp dir under "delete_missing_comment.xlsx"; "A1"
    Then "error" occurs in result

  @candidate-python-excel-advanced-tools-05b6b00b1a
  # Native: tests/test_excel_advanced_tools.py::TestHighlightDefault::test_patch_cell_no_highlight_by_default
  Scenario: Native check: patch cell no highlight by default [TestHighlightDefault]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "no_highlight.xlsx"
    And ws is prepared as wb active
    And wb active at "A1" is set to "Original"
    And wb active at "A1" fill is set to the result of PatternFill with start color "FF0000"; end color "FF0000"; fill type "solid"
    And path is prepared as temp dir under "no_highlight.xlsx"
    When excel advanced tools.tool excel patch cell using str representation of temp dir under "no_highlight.xlsx"; "A1"; "Updated"
    Then wb active at "A1" fill start color rgb differs from "00FFFF99"

  @candidate-python-excel-advanced-tools-8a7c1d46ec
  # Native: tests/test_excel_advanced_tools.py::TestHighlightDefault::test_patch_cell_explicit_highlight
  Scenario: Native check: patch cell explicit highlight [TestHighlightDefault]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "explicit_highlight.xlsx"
    And ws is prepared as wb active
    And wb active at "A1" is set to "Original"
    And path is prepared as temp dir under "explicit_highlight.xlsx"
    When excel advanced tools.tool excel patch cell using str representation of temp dir under "explicit_highlight.xlsx"; "A1"; "Updated"; highlight true
    Then wb active at "A1" fill start color rgb equals "00FFFF99"

  @candidate-python-excel-advanced-tools-fdee640831
  # Native: tests/test_excel_advanced_tools.py::TestHighlightDefault::test_patch_range_no_highlight_by_default
  Scenario: Native check: patch range no highlight by default [TestHighlightDefault]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "range_no_highlight.xlsx"
    And ws is prepared as wb active
    And wb active at "A1" is set to "A"
    And wb active at "B1" is set to "B"
    And wb active at "A1" fill is set to the result of PatternFill with start color "00FF00"; end color "00FF00"; fill type "solid"
    And path is prepared as temp dir under "range_no_highlight.xlsx"
    When excel advanced tools.tool excel patch range using str representation of temp dir under "range_no_highlight.xlsx"; "A1:B1"; [["X", "Y"]]
    Then wb active at "A1" fill start color rgb differs from "00FFFF99"
