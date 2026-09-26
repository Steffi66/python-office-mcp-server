@captured @python_candidate
Feature: mutation diagnostics native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-mutation-diagnostics-571472667f
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_word_patch_section_emits_standard_fields
  Scenario: Native check: word patch section emits standard fields [TestMutationDiagnostics]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "section.docx"
    And path is prepared as temp dir under "section.docx"
    And doc is prepared as the result of Document with no arguments
    When WordAdvancedTools().tool word patch section using file path str representation of temp dir under "section.docx"; section title "Introduction"; new content ["New intro"]
    Then result at "success" is true
    And result at "status" equals "success"
    And result at "matched_targets" at 0 at "target" equals "section:Introduction"
    And result at "unmatched_targets" equals []
    And "diagnostics" occurs in result
    And "word_insert_at_anchor" occurs in result at "next_tools"

  @candidate-python-mutation-diagnostics-47d3962281
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_word_create_sow_from_markdown_surfaces_partial_success
  Scenario: Native check: word create sow from markdown surfaces partial success [TestMutationDiagnostics]
    Given an isolated writable temporary directory
    And template is prepared as the result of build word template with temp dir under "template.docx"
    And output is prepared as temp dir under "output.docx"
    And markdown is prepared as "# Sample SOW\n\nCustomer: Contoso\nProject: Platform Review\nProvider: Microsoft\n\n## Introduction\nArchitecture overview text.\n\n## Assumptions\nCustomer will provide access.\n"
    When WordAdvancedTools().tool word create sow from markdown using output path str representation of temp dir under "output.docx"; template path str representation of the result of build word template with temp dir under "template.docx"; markdown "# Sample SOW\n\nCustomer: Contoso\nProject: Platform Review\nProvider: Microsoft\n\n## Introduction\nArchitecture overview text.\n\n## Assumptions\nCustomer will provide access.\n"
    Then result at "success" is true
    And result at "status" equals "partial_success"
    And at least one item satisfies item at "target" equals "section:assumptions" for each item in result at "unmatched_targets"
    And result at "diagnostics" at "unmapped_sections" is non-empty or true
    And "word_insert_at_anchor" occurs in result at "next_tools"

  @candidate-python-mutation-diagnostics-cb38d01946
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_office_patch_word_all_miss_reports_failed
  Scenario: Native check: office patch word all miss reports failed [TestMutationDiagnostics]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "placeholder.docx"
    And path is prepared as temp dir under "placeholder.docx"
    And doc is prepared as the result of Document with no arguments
    When UnifiedOfficeTools().tool office patch using file path str representation of temp dir under "placeholder.docx"; changes [{"target": "<Customer Name>", "value": "Contoso"}]
    Then result at "success" is false
    And result at "status" occurs in "{'skipped', 'failed'}"
    And result at "matched_targets" equals []
    And result at "skipped_targets" is non-empty or true
    And "office_inspect" occurs in result at "next_tools"

  @candidate-python-mutation-diagnostics-e9a6629de8
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_office_patch_excel_all_miss_reports_failed
  Scenario: Native check: office patch excel all miss reports failed [TestMutationDiagnostics]
    Given an isolated writable temporary directory
    And wb.save with temp dir under "book.xlsx"
    And path is prepared as temp dir under "book.xlsx"
    And wb is prepared as the result of Workbook with no arguments
    When UnifiedOfficeTools().tool office patch using file path str representation of temp dir under "book.xlsx"; changes [{"target": "MissingSheet!A1", "value": "Contoso"}]
    Then result at "success" is false
    And result at "status" equals "failed"
    And result at "matched_targets" equals []
    And result at "unmatched_targets" at 0 at "target" equals "MissingSheet!A1"
    And result at "edited_sheets" equals []
    And result at "preserved_parts_summary" at "strategy" equals "merge_original_package_with_edited_sheets"

  @candidate-python-mutation-diagnostics-1580998c58
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_excel_table_mutations_emit_standard_diagnostics
  Scenario: Native check: excel table mutations emit standard diagnostics [TestMutationDiagnostics]
    Given an isolated writable temporary directory
    And path is prepared as the result of build excel table workbook with temp dir under "table.xlsx"
    And tool is prepared as the result of ExcelAdvancedTools with no arguments
    When tool.tool excel append table row using file path str representation of the result of build excel table workbook with temp dir under "table.xlsx"; table name "Staffing"; row data {"Role": "Engineer", "Count": 2, "Missing": "ignored"}
    And tool.tool excel update table row using file path str representation of the result of build excel table workbook with temp dir under "table.xlsx"; table name "Staffing"; row index 1; row data {"Count": 3, "Unknown": "ignored"}
    Then append result at "success" is true
    And append result at "status" equals "partial_success"
    And append result at "matched_targets" is non-empty or true
    And append result at "unmatched_targets" at 0 at "target" equals "column:Missing"
    And "office_table" occurs in append result at "next_tools"
    And update result at "success" is true
    And update result at "status" equals "partial_success"
    And update result at "matched_targets" is non-empty or true
    And update result at "unmatched_targets" at 0 at "target" equals "column:Unknown"
    And update result at "diagnostics" at "updates" is non-empty or true
