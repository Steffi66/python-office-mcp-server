@captured @python_candidate
Feature: Native Python mutation mode responses and bounded saved-file observations

  Six native definitions use generated files in a writable temporary directory.
  Candidate descriptions need central reconciliation and grant no execution credit.

  @candidate-python-mutation-modes-cd0c13a3e2
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_patch_dry_run_does_not_modify_word_file
  Scenario: Word dry-run returns its mode and preserves source bytes
    Given a saved document with level-1 heading "Introduction" and paragraph "Current intro"
    And the source bytes are captured before the call
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_patch receives target "section:Introduction" with value "New intro", mode "dry_run" and no output_path
    Then success is true and mode equals "dry_run"
    And post-call source bytes equal the captured pre-call bytes

  @candidate-python-mutation-modes-e5e9ce01ea
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_patch_safe_requires_distinct_output_path
  Scenario: Word safe mode reports failure when output_path is omitted
    Given a saved document with level-1 heading "Introduction" and paragraph "Current intro"
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_patch receives target "section:Introduction" with value "New intro", mode "safe" and no output_path
    Then success is false, mode equals "safe" and status equals "failed"

  @candidate-python-mutation-modes-98a5ec284e
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_word_create_sow_strict_rejects_unmapped_sections_without_writing
  Scenario: Strict SOW creation reports failure and leaves its requested output absent
    Given a saved template with level-1 "Introduction" and paragraph "<Customer Name>"
    And level-1 "Delivery approach" with paragraph "[Template Guidance: add delivery approach]"
    And Markdown titled "Sample SOW" with Customer Contoso, Project Platform Review and Provider Microsoft
    And Markdown sections Introduction with "Architecture overview text." and Assumptions with "Customer will provide access."
    When WordAdvancedTools.tool_word_create_sow_from_markdown receives that template and Markdown with mode "strict" and distinct strict-output.docx output_path
    Then success is false, mode equals "strict" and status equals "failed"
    And strict-output.docx does not exist after the call

  @candidate-python-mutation-modes-5c226b35fd
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_table_excel_dry_run_does_not_write
  Scenario: Excel table dry-run returns its mode and preserves source bytes
    Given a saved Sheet1 workbook with Staffing table A1:B2 and rows ["Role", "Count"], ["Architect", 1]
    And the table uses TableStyleMedium2 with row stripes true and first-column, last-column and column-stripe flags false
    And the source bytes are captured before the call
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_table receives operation "add_row", table_id "Staffing", data {"Role":"Engineer","Count":2}, mode "dry_run" and no output_path
    Then success is true and mode equals "dry_run"
    And post-call source bytes equal the captured pre-call bytes

  @candidate-python-mutation-modes-bd31ead847
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_table_excel_safe_requires_output_path
  Scenario: Excel table safe mode reports failure when output_path is omitted
    Given a saved Sheet1 workbook with Staffing table A1:B2 and rows ["Role", "Count"], ["Architect", 1]
    And the table uses TableStyleMedium2 with row stripes true and first-column, last-column and column-stripe flags false
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_table receives operation "add_row", table_id "Staffing", data {"Role":"Engineer","Count":2}, mode "safe" and no output_path
    Then success is false and mode equals "safe"

  @candidate-python-mutation-modes-a5aa9665b7
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_best_effort_preserves_existing_successful_path
  Scenario: Best-effort table append writes an output whose A3 contains Engineer
    Given a saved Sheet1 workbook with Staffing table A1:B2 and rows ["Role", "Count"], ["Architect", 1]
    And the table uses TableStyleMedium2 with row stripes true and first-column, last-column and column-stripe flags false
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_table receives operation "add_row", table_id "Staffing", data {"Role":"Engineer","Count":2}, mode "best_effort" and distinct table-out.xlsx output_path
    Then success is true and mode equals "best_effort"
    And table-out.xlsx exists after the call
    When load_workbook opens that output
    Then active-sheet A3 equals "Engineer"
