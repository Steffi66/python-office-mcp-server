@captured @python_candidate
Feature: mutation modes native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-mutation-modes-cd0c13a3e2
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_patch_dry_run_does_not_modify_word_file
  Scenario: Native check: office patch dry run does not modify word file [TestMutationModes]
    Given an isolated writable temporary directory
    And path is prepared as the result of build word doc with temp dir under "doc.docx"
    And before is prepared as saved bytes of the result of build word doc with temp dir under "doc.docx"
    When UnifiedTools().tool office patch using file path str representation of the result of build word doc with temp dir under "doc.docx"; changes [{"target": "section:Introduction", "value": "New intro"}]; mode "dry_run"
    Then result at "mode" equals "dry_run"
    And result at "success" is true
    And saved bytes of the result of build word doc with temp dir under "doc.docx" equals saved bytes of the result of build word doc with temp dir under "doc.docx"

  @candidate-python-mutation-modes-e5e9ce01ea
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_patch_safe_requires_distinct_output_path
  Scenario: Native check: office patch safe requires distinct output path [TestMutationModes]
    Given an isolated writable temporary directory
    And path is prepared as the result of build word doc with temp dir under "doc.docx"
    When UnifiedTools().tool office patch using file path str representation of the result of build word doc with temp dir under "doc.docx"; changes [{"target": "section:Introduction", "value": "New intro"}]; mode "safe"
    Then result at "success" is false
    And result at "mode" equals "safe"
    And result at "status" equals "failed"

  @candidate-python-mutation-modes-98a5ec284e
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_word_create_sow_strict_rejects_unmapped_sections_without_writing
  Scenario: Native check: word create sow strict rejects unmapped sections without writing [TestMutationModes]
    Given an isolated writable temporary directory
    And template is prepared as the result of build word template with temp dir under "template.docx"
    And output is prepared as temp dir under "strict-output.docx"
    And markdown is prepared as "# Sample SOW\n\nCustomer: Contoso\nProject: Platform Review\nProvider: Microsoft\n\n## Introduction\nArchitecture overview text.\n\n## Assumptions\nCustomer will provide access.\n"
    When WordAdvancedTools().tool word create sow from markdown using output path str representation of temp dir under "strict-output.docx"; template path str representation of the result of build word template with temp dir under "template.docx"; markdown "# Sample SOW\n\nCustomer: Contoso\nProject: Platform Review\nProvider: Microsoft\n\n## Introduction\nArchitecture overview text.\n\n## Assumptions\nCustomer will provide access.\n"; mode "strict"
    Then result at "success" is false
    And result at "mode" equals "strict"
    And result at "status" equals "failed"
    And not temp dir under "strict-output.docx" exists

  @candidate-python-mutation-modes-5c226b35fd
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_table_excel_dry_run_does_not_write
  Scenario: Native check: office table excel dry run does not write [TestMutationModes]
    Given an isolated writable temporary directory
    And path is prepared as the result of build excel table with temp dir under "table.xlsx"
    And before is prepared as saved bytes of the result of build excel table with temp dir under "table.xlsx"
    When UnifiedTools().tool office table using file path str representation of the result of build excel table with temp dir under "table.xlsx"; operation "add_row"; table id "Staffing"; data {"Role": "Engineer", "Count": 2}; mode "dry_run"
    Then result at "success" is true
    And result at "mode" equals "dry_run"
    And saved bytes of the result of build excel table with temp dir under "table.xlsx" equals saved bytes of the result of build excel table with temp dir under "table.xlsx"

  @candidate-python-mutation-modes-bd31ead847
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_office_table_excel_safe_requires_output_path
  Scenario: Native check: office table excel safe requires output path [TestMutationModes]
    Given an isolated writable temporary directory
    And path is prepared as the result of build excel table with temp dir under "table.xlsx"
    When UnifiedTools().tool office table using file path str representation of the result of build excel table with temp dir under "table.xlsx"; operation "add_row"; table id "Staffing"; data {"Role": "Engineer", "Count": 2}; mode "safe"
    Then result at "success" is false
    And result at "mode" equals "safe"

  @candidate-python-mutation-modes-a5aa9665b7
  # Native: tests/test_mutation_modes.py::TestMutationModes::test_best_effort_preserves_existing_successful_path
  Scenario: Native check: best effort preserves existing successful path [TestMutationModes]
    Given an isolated writable temporary directory
    And path is prepared as the result of build excel table with temp dir under "table.xlsx"
    And output is prepared as temp dir under "table-out.xlsx"
    When UnifiedTools().tool office table using file path str representation of the result of build excel table with temp dir under "table.xlsx"; operation "add_row"; table id "Staffing"; data {"Role": "Engineer", "Count": 2}; output path str representation of temp dir under "table-out.xlsx"; mode "best_effort"
    Then result at "success" is true
    And result at "mode" equals "best_effort"
    And temp dir under "table-out.xlsx" exists is non-empty or true
    And the result of load workbook with temp dir under "table-out.xlsx" active at "A3" value equals "Engineer"
