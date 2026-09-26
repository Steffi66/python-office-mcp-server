@captured @python_candidate
Feature: Native Python mutation diagnostic response observations

  These five native definitions inspect responses without saved-document readback.
  Candidate descriptions need central reconciliation and grant no execution credit.

  @candidate-python-mutation-diagnostics-571472667f
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_word_patch_section_emits_standard_fields
  Scenario: Section patch returns matched-target and follow-up diagnostic fields
    Given a saved Word document with level-1 heading "Introduction" and paragraph "Old intro"
    When WordAdvancedTools.tool_word_patch_section replaces section "Introduction" with ["New intro"]
    Then success is true and status equals "success"
    And the first matched_targets entry has target "section:Introduction"
    And unmatched_targets equals an empty list
    And the result contains diagnostics and next_tools includes "word_insert_at_anchor"

  @candidate-python-mutation-diagnostics-47d3962281
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_word_create_sow_from_markdown_surfaces_partial_success
  Scenario: SOW creation reports an unmapped assumptions section as partial success
    Given a saved template with level-1 "Introduction" and paragraph "<Customer Name>"
    And level-1 "Delivery approach" with paragraph "[Template Guidance: add delivery approach]"
    And Markdown titled "Sample SOW" with Customer Contoso, Project Platform Review and Provider Microsoft
    And Markdown sections Introduction with "Architecture overview text." and Assumptions with "Customer will provide access."
    When WordAdvancedTools.tool_word_create_sow_from_markdown receives that template and Markdown with a distinct output_path and omitted mode
    Then success is true and status equals "partial_success"
    And at least one unmatched_targets entry has target "section:assumptions"
    And diagnostics.unmapped_sections is truthy
    And next_tools includes "word_insert_at_anchor"

  @candidate-python-mutation-diagnostics-cb38d01946
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_office_patch_word_all_miss_reports_failed
  Scenario: A missing Word placeholder permits failed or skipped diagnostic status
    Given a saved Word document with paragraph "No placeholders here"
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_patch receives <Customer Name> with value "Contoso", omitting mode and output_path
    Then success is false and status is either "failed" or "skipped"
    And matched_targets equals an empty list and skipped_targets is truthy
    And next_tools includes "office_inspect"

  @candidate-python-mutation-diagnostics-e9a6629de8
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_office_patch_excel_all_miss_reports_failed
  Scenario: A missing Excel sheet reports failure and the named preservation strategy
    Given a saved default empty workbook
    And a combined object using OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools
    When tool_office_patch receives "MissingSheet!A1" with value "Contoso", omitting mode and output_path
    Then success is false and status equals "failed"
    And matched_targets and edited_sheets each equal an empty list
    And the first unmatched_targets entry has target "MissingSheet!A1"
    And preserved_parts_summary.strategy equals "merge_original_package_with_edited_sheets"

  @candidate-python-mutation-diagnostics-1580998c58
  # Native: tests/test_mutation_diagnostics.py::TestMutationDiagnostics::test_excel_table_mutations_emit_standard_diagnostics
  Scenario: Appending and updating with unknown columns each report partial-success diagnostics
    Given a saved Sheet1 workbook with Staffing table A1:B3 and rows ["Role", "Count"], ["Architect", 1], ["PM", 1]
    And the table uses TableStyleMedium2 with row stripes true and first-column, last-column and column-stripe flags false
    When ExcelAdvancedTools.tool_excel_append_table_row receives table "Staffing" and row_data {"Role":"Engineer","Count":2,"Missing":"ignored"}
    And the same tool object's tool_excel_update_table_row receives table "Staffing", row_index 1 and row_data {"Count":3,"Unknown":"ignored"}
    Then both results have success true and status "partial_success"
    And both matched_targets values are truthy
    And the append result's first unmatched target is "column:Missing" and next_tools includes "office_table"
    And the update result's first unmatched target is "column:Unknown" and diagnostics.updates is truthy
