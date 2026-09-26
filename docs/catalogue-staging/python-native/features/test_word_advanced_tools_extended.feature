@captured @python_candidate
Feature: word advanced tools extended native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-advanced-tools-extended-7754980155
  # Native: tests/test_word_advanced_tools_extended.py::TestPromptSowGeneration::test_returns_guidance
  Scenario: Native check: returns guidance [TestPromptSowGeneration]
    Given Create an instance of WordAdvancedTools.
    And result is prepared as the result of word advanced tools.prompt sow generation with no arguments
    When word advanced tools.prompt sow generation using the prepared inputs
    Then "prompt" occurs in the result of word advanced tools.prompt sow generation with no arguments or "guidance" occurs in the result of word advanced tools.prompt sow generation with no arguments or the result of word advanced tools.prompt sow generation with no arguments has type dict

  @candidate-python-word-advanced-tools-extended-2338b6da45
  # Native: tests/test_word_advanced_tools_extended.py::TestCheckTracking::test_checks_tracking_status
  Scenario: Native check: checks tracking status [TestCheckTracking]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "tracking.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "tracking.docx"
    When word advanced tools.tool word check tracking using str representation of temp dir under "tracking.docx"
    Then "tracking" occurs in str representation of result in lowercase or "revisions" occurs in str representation of result in lowercase or result has type dict

  @candidate-python-word-advanced-tools-extended-e3bb9af087
  # Native: tests/test_word_advanced_tools_extended.py::TestMultipleTableOperations::test_lists_multiple_tables
  Scenario: Native check: lists multiple tables [TestMultipleTableOperations]
    Given Create an instance of WordAdvancedTools.
    And Create a document with multiple tables.
    When word advanced tools.tool word list tables using str representation of doc with tables
    Then the number of entries in result field "tables", defaulting to [] is at least 2

  @candidate-python-word-advanced-tools-extended-456423ae3e
  # Native: tests/test_word_advanced_tools_extended.py::TestMultipleTableOperations::test_gets_second_table
  Scenario: Native check: gets second table [TestMultipleTableOperations]
    Given Create an instance of WordAdvancedTools.
    And Create a document with multiple tables.
    When word advanced tools.tool word get table using str representation of doc with tables; "1"
    Then "header" occurs in result or "rows" occurs in result

  @candidate-python-word-advanced-tools-extended-b9e1130e9e
  # Native: tests/test_word_advanced_tools_extended.py::TestDuplicateTableStructure::test_duplicates_table
  Scenario: Native check: duplicates table [TestDuplicateTableStructure]
    Given Create an instance of WordAdvancedTools.
    And Create a document with multiple tables.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "dup_table.docx"
    When word advanced tools.tool word duplicate table structure using str representation of doc with tables; "0"; output path str representation of temp dir under "dup_table.docx"
    Then result field "success" is true or temp dir under "dup_table.docx" exists

  @candidate-python-word-advanced-tools-extended-3f0bc12d37
  # Native: tests/test_word_advanced_tools_extended.py::TestCreateNewTable::test_creates_table
  Scenario: Native check: creates table [TestCreateNewTable]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "new_table_doc.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "new_table_doc.docx"
    And output is prepared as temp dir under "with_table.docx"
    When word advanced tools.tool word create new table using str representation of temp dir under "new_table_doc.docx"; ["Col1", "Col2", "Col3"]; output path str representation of temp dir under "with_table.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-extended-c9bc1cdf0d
  # Native: tests/test_word_advanced_tools_extended.py::TestExtractSowStructure::test_extracts_structure
  Scenario: Native check: extracts structure [TestExtractSowStructure]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "sow_struct.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sow_struct.docx"
    When word advanced tools.tool word extract sow structure using str representation of temp dir under "sow_struct.docx"
    Then "sections" occurs in result or "structure" occurs in result

  @candidate-python-word-advanced-tools-extended-8628f6bd55
  # Native: tests/test_word_advanced_tools_extended.py::TestPatchPlaceholder::test_patches_placeholder
  Scenario: Native check: patches placeholder [TestPatchPlaceholder]
    Given Create an instance of WordAdvancedTools.
    And Create a document with various placeholder patterns.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched.docx"
    When word advanced tools.tool word patch placeholder using str representation of doc with placeholders; "<Customer Name>"; "Contoso Corp"; output path str representation of temp dir under "patched.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-extended-d03abb8ba4
  # Native: tests/test_word_advanced_tools_extended.py::TestMoreSectionOperations::test_get_section_with_tables
  Scenario: Native check: get section with tables [TestMoreSectionOperations]
    Given Create an instance of WordAdvancedTools.
    And Create a document with multiple tables.
    When word advanced tools.tool word get section using str representation of doc with tables; "Multiple Tables"
    Then "content" occurs in result or "text" occurs in result or "error" does not occur in str representation of result in lowercase

  @candidate-python-word-advanced-tools-extended-c8230f6500
  # Native: tests/test_word_advanced_tools_extended.py::TestErrorHandling::test_list_sections_invalid_file
  Scenario: Native check: list sections invalid file [TestErrorHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And path.write text with "Not a docx file"
    And path is prepared as temp dir under "invalid.txt"
    When word advanced tools.tool word list sections using str representation of temp dir under "invalid.txt"
    Then "error" occurs in result

  @candidate-python-word-advanced-tools-extended-bb669e4fb7
  # Native: tests/test_word_advanced_tools_extended.py::TestErrorHandling::test_get_table_no_tables
  Scenario: Native check: get table no tables [TestErrorHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_tables.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_tables.docx"
    When word advanced tools.tool word get table using str representation of temp dir under "no_tables.docx"; "0"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-extended-67f21e1cb7
  # Native: tests/test_word_advanced_tools_extended.py::TestComplexDocuments::test_nested_content
  Scenario: Native check: nested content [TestComplexDocuments]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "nested.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "nested.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "nested.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 4

  @candidate-python-word-advanced-tools-extended-c1ed46f094
  # Native: tests/test_word_advanced_tools_extended.py::TestComplexDocuments::test_mixed_content
  Scenario: Native check: mixed content [TestComplexDocuments]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "mixed.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "mixed.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "mixed.docx"
    Then the number of entries in result field "sections", defaulting to [] is at least 2

  @candidate-python-word-advanced-tools-extended-bd68ac9e89
  # Native: tests/test_word_advanced_tools_extended.py::TestExtractDataFromMarkdown::test_extracts_customer_name
  Scenario: Native check: extracts customer name [TestExtractDataFromMarkdown]
    Given Create an instance of WordAdvancedTools.
    And md is prepared as "# SOW for Contoso Corp\n\n## Project: Cloud Migration\n"
    And data is prepared as the result of word advanced tools. extract data from markdown with "# SOW for Contoso Corp\n\n## Project: Cloud Migration\n"
    When word advanced tools. extract data from markdown using "# SOW for Contoso Corp\n\n## Project: Cloud Migration\n"
    Then the result of word advanced tools. extract data from markdown with "# SOW for Contoso Corp\n\n## Project: Cloud Migration\n" has type dict

  @candidate-python-word-advanced-tools-extended-41ab5dc237
  # Native: tests/test_word_advanced_tools_extended.py::TestAuditVariations::test_audit_with_brackets
  Scenario: Native check: audit with brackets [TestAuditVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "brackets.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "brackets.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "brackets.docx"
    Then the number of entries in result field "issues", defaulting to result field "findings", defaulting to [] is at least 1 or "placeholder" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-extended-f25d79460b
  # Native: tests/test_word_advanced_tools_extended.py::TestAuditVariations::test_audit_sow_completeness
  Scenario: Native check: audit sow completeness [TestAuditVariations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "incomplete_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "incomplete_sow.docx"
    When word advanced tools.tool word audit sow using str representation of temp dir under "incomplete_sow.docx"
    Then result has type dict
