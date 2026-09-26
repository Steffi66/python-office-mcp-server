@captured @python_candidate
Feature: word deep coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-deep-coverage-ccc6acf714
  # Native: tests/test_word_deep_coverage.py::TestWordCreateNewTable::test_create_table_basic
  Scenario: Native check: create table basic [TestWordCreateNewTable]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "before_table.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "before_table.docx"
    And output is prepared as temp dir under "with_table.docx"
    When tools.tool word create new table using str representation of temp dir under "before_table.docx"; ["Name", "Role", "Hours"]; [{"Name": "Alice", "Role": "Developer", "Hours": "40"}, {"Name": "Bob", "Role": "Tester", "Hours": "35"}]; output path str representation of temp dir under "with_table.docx"
    Then result has type dict
    And the result of Path with temp dir under "with_table.docx" exists is non-empty or true

  @candidate-python-word-deep-coverage-db71330620
  # Native: tests/test_word_deep_coverage.py::TestWordCreateNewTable::test_create_empty_table
  Scenario: Native check: create empty table [TestWordCreateNewTable]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "empty_table.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "empty_table.docx"
    When tools.tool word create new table using str representation of temp dir under "empty_table.docx"; ["Col A", "Col B", "Col C"]; []
    Then result has type dict

  @candidate-python-word-deep-coverage-063a6e8270
  # Native: tests/test_word_deep_coverage.py::TestWordDuplicateTableStructure::test_duplicate_table
  Scenario: Native check: duplicate table [TestWordDuplicateTableStructure]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "original.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 4
    And path is prepared as temp dir under "original.docx"
    When tools.tool word duplicate table structure using str representation of temp dir under "original.docx"; "0"
    Then result has type dict

  @candidate-python-word-deep-coverage-2a5c10a4e7
  # Native: tests/test_word_deep_coverage.py::TestWordCopyTemplate::test_copy_template
  Scenario: Native check: copy template [TestWordCopyTemplate]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "template.docx"
    And output is prepared as temp dir under "copy.docx"
    When tools.tool word copy template using str representation of temp dir under "template.docx"; str representation of temp dir under "copy.docx"
    Then result has type dict
    And the result of Path with temp dir under "copy.docx" exists is non-empty or true

  @candidate-python-word-deep-coverage-7de41fb00b
  # Native: tests/test_word_deep_coverage.py::TestWordPatchPlaceholder::test_patch_placeholder_basic
  Scenario: Native check: patch placeholder basic [TestWordPatchPlaceholder]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "placeholders.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "placeholders.docx"
    When tools.tool word patch placeholder using str representation of temp dir under "placeholders.docx"; "<Title>"; "Real Title"
    Then result has type dict

  @candidate-python-word-deep-coverage-8b95277fba
  # Native: tests/test_word_deep_coverage.py::TestWordPatchPlaceholder::test_patch_multiple_occurrences
  Scenario: Native check: patch multiple occurrences [TestWordPatchPlaceholder]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "multi_ph.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "multi_ph.docx"
    When tools.tool word patch placeholder using str representation of temp dir under "multi_ph.docx"; "<NAME>"; "John Smith"
    Then result has type dict

  @candidate-python-word-deep-coverage-9b64291597
  # Native: tests/test_word_deep_coverage.py::TestWordEnableTrackChanges::test_enable_track_changes
  Scenario: Native check: enable track changes [TestWordEnableTrackChanges]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "track.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track.docx"
    When tools.tool word enable track changes using str representation of temp dir under "track.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-c8eaabcbee
  # Native: tests/test_word_deep_coverage.py::TestWordCheckTracking::test_check_tracking_status
  Scenario: Native check: check tracking status [TestWordCheckTracking]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "check_track.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "check_track.docx"
    When tools.tool word check tracking using str representation of temp dir under "check_track.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-6defd5b5a3
  # Native: tests/test_word_deep_coverage.py::TestWordPatchWithTrackChanges::test_patch_with_tracking
  Scenario: Native check: patch with tracking [TestWordPatchWithTrackChanges]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "patch_track.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "patch_track.docx"
    When tools.tool word patch with track changes using str representation of temp dir under "patch_track.docx"; {"<Customer>": "Contoso", "Original": "Updated"}
    Then result has type dict

  @candidate-python-word-deep-coverage-2f46bd93b3
  # Native: tests/test_word_deep_coverage.py::TestWordAuditCompletion::test_audit_with_missing
  Scenario: Native check: audit with missing [TestWordAuditCompletion]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "incomplete.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "incomplete.docx"
    When tools.tool word audit completion using str representation of temp dir under "incomplete.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-c24aff0acc
  # Native: tests/test_word_deep_coverage.py::TestWordAuditCompletion::test_audit_complete_doc
  Scenario: Native check: audit complete doc [TestWordAuditCompletion]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "complete.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "complete.docx"
    When tools.tool word audit completion using str representation of temp dir under "complete.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-1f2ae44bc2
  # Native: tests/test_word_deep_coverage.py::TestWordAuditSow::test_audit_sow
  Scenario: Native check: audit sow [TestWordAuditSow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_audit.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "sow_audit.docx"
    When tools.tool word audit sow using str representation of temp dir under "sow_audit.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-0970e0f27a
  # Native: tests/test_word_deep_coverage.py::TestWordFixSplitPlaceholders::test_fix_split_placeholders
  Scenario: Native check: fix split placeholders [TestWordFixSplitPlaceholders]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "split.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And path is prepared as temp dir under "split.docx"
    When tools.tool word fix split placeholders using str representation of temp dir under "split.docx"; {"<Customer Name>": "Contoso"}
    Then result has type dict

  @candidate-python-word-deep-coverage-6a7fc81b4d
  # Native: tests/test_word_deep_coverage.py::TestWordGetSectionGuidance::test_get_section_guidance
  Scenario: Native check: get section guidance [TestWordGetSectionGuidance]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "guidance.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And run is prepared as the result of para.add run with "[Guidance: Describe the project background]"
    And the result of para.add run with "[Guidance: Describe the project background]" font color rgb is set to the result of RGBColor with 0; 0; 255
    And path is prepared as temp dir under "guidance.docx"
    When tools.tool word get section guidance using str representation of temp dir under "guidance.docx"; "1. Introduction"
    Then result has type dict

  @candidate-python-word-deep-coverage-6ce440304d
  # Native: tests/test_word_deep_coverage.py::TestWordExtractSowStructure::test_extract_sow_structure
  Scenario: Native check: extract sow structure [TestWordExtractSowStructure]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_structure.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "Item"
    And the result of table.cell with 0; 1 text is set to "Description"
    And path is prepared as temp dir under "sow_structure.docx"
    When tools.tool word extract sow structure using str representation of temp dir under "sow_structure.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-9d3027bef1
  # Native: tests/test_word_deep_coverage.py::TestWordParseSowTemplate::test_parse_sow_template
  Scenario: Native check: parse sow template [TestWordParseSowTemplate]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "sow_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 3
    And the result of table.cell with 0; 0 text is set to "Objective"
    And the result of table.cell with 0; 1 text is set to "Activities"
    And the result of table.cell with 0; 2 text is set to "Assumptions"
    And path is prepared as temp dir under "sow_template.docx"
    When tools.tool word parse sow template using str representation of temp dir under "sow_template.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-5066d75c53
  # Native: tests/test_word_deep_coverage.py::TestWordCleanupSow::test_cleanup_sow
  Scenario: Native check: cleanup sow [TestWordCleanupSow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "cleanup_sow.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with no arguments
    And run is prepared as the result of para.add run with "[Template Guidance: This should be removed]"
    And the result of para.add run with "[Template Guidance: This should be removed]" font color rgb is set to the result of RGBColor with 0; 0; 255
    And path is prepared as temp dir under "cleanup_sow.docx"
    And output is prepared as temp dir under "cleaned.docx"
    When tools.tool word cleanup sow using str representation of temp dir under "cleanup_sow.docx"; output path str representation of temp dir under "cleaned.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-5d746a2828
  # Native: tests/test_word_deep_coverage.py::TestWordGenerateSow::test_generate_sow_minimal
  Scenario: Native check: generate sow minimal [TestWordGenerateSow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "gen_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "gen_template.docx"
    And output is prepared as temp dir under "generated_sow.docx"
    When tools.tool word generate sow using str representation of temp dir under "gen_template.docx"; str representation of temp dir under "generated_sow.docx"; {"customer_name": "Test Corp", "project_name": "Test Project", "provider_name": "Provider Inc"}
    Then result has type dict

  @candidate-python-word-deep-coverage-8dff1795b5
  # Native: tests/test_word_deep_coverage.py::TestWordCreateSowFromMarkdown::test_create_sow_from_markdown
  Scenario: Native check: create sow from markdown [TestWordCreateSowFromMarkdown]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "md_template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "md_template.docx"
    And markdown is prepared as "# Test Project - SOW\n\n## Overview\nCustomer: Test Corp\nProvider: Test Provider\n\n## Objectives\n- Objective 1\n- Objective 2\n"
    And output is prepared as temp dir under "md_sow.docx"
    When tools.tool word create sow from markdown using str representation of temp dir under "md_sow.docx"; "# Test Project - SOW\n\n## Overview\nCustomer: Test Corp\nProvider: Test Provider\n\n## Objectives\n- Objective 1\n- Objective 2\n"; template path str representation of temp dir under "md_template.docx"
    Then result has type dict

  @candidate-python-word-deep-coverage-3537e7724b
  # Native: tests/test_word_deep_coverage.py::TestWordCreateSowFromMarkdown::test_create_sow_from_markdown_file
  Scenario: Native check: create sow from markdown file [TestWordCreateSowFromMarkdown]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "md_template_file.docx"
    And md file.write text with "# Test Project - SOW\n\nCustomer: Test Corp\nProject: Test Project\n"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "md_template_file.docx"
    And md file is prepared as temp dir under "sow.md"
    And output is prepared as temp dir under "md_sow_file.docx"
    When tools.tool word create sow from markdown using str representation of temp dir under "md_sow_file.docx"; template path str representation of temp dir under "md_template_file.docx"; markdown file str representation of temp dir under "sow.md"
    Then result has type dict
    And "error" does not occur in result

  @candidate-python-word-deep-coverage-5ed195682e
  # Native: tests/test_word_deep_coverage.py::TestWordAddComment::test_add_comment_to_text
  Scenario: Native check: add comment to text [TestWordAddComment]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "comment.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "comment.docx"
    When tools.tool word add comment using str representation of temp dir under "comment.docx"; "important text"; "Please verify this is correct."
    Then result has type dict

  @candidate-python-word-deep-coverage-02a25dc9fc
  # Native: tests/test_word_deep_coverage.py::TestWordAddComment::test_add_comment_with_author
  Scenario: Native check: add comment with author [TestWordAddComment]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "comment_author.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "comment_author.docx"
    When tools.tool word add comment using str representation of temp dir under "comment_author.docx"; "Review needed"; "This needs manager approval"; author "John Smith"
    Then result has type dict

  @candidate-python-word-deep-coverage-6b83227dcd
  # Native: tests/test_word_deep_coverage.py::TestWordAddComment::test_add_comment_with_none_author
  Scenario: Native check: add comment with none author [TestWordAddComment]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "comment_none_author.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "comment_none_author.docx"
    When tools.tool word add comment using str representation of temp dir under "comment_none_author.docx"; "review this sentence"; "Use default author"; author null
    Then "error" does not occur in result

  @candidate-python-word-deep-coverage-558ef7dfab
  # Native: tests/test_word_deep_coverage.py::TestWordFromMarkdownComplex::test_from_markdown_with_tables
  Scenario: Native check: from markdown with tables [TestWordFromMarkdownComplex]
    Given an isolated writable temporary directory
    And markdown is prepared as "# Report\n\n## Data\n\n| Name | Value | Notes |\n|------|-------|-------|\n| Alpha | 100 | First |\n| Beta | 200 | Second |\n| Gamma | 300 | Third |\n\n## Summary\n\nTotal items: 3\n"
    And word tools is prepared as the result of WordTools with no arguments
    And path is prepared as temp dir under "complex_md.docx"
    When word tools.tool word from markdown using str representation of temp dir under "complex_md.docx"; "# Report\n\n## Data\n\n| Name | Value | Notes |\n|------|-------|-------|\n| Alpha | 100 | First |\n| Beta | 200 | Second |\n| Gamma | 300 | Third |\n\n## Summary\n\nTotal items: 3\n"
    Then the result of Path with temp dir under "complex_md.docx" exists is non-empty or true

  @candidate-python-word-deep-coverage-6e799e358e
  # Native: tests/test_word_deep_coverage.py::TestWordFromMarkdownComplex::test_from_markdown_with_nested_headings
  Scenario: Native check: from markdown with nested headings [TestWordFromMarkdownComplex]
    Given an isolated writable temporary directory
    And tools is prepared as the result of WordTools with no arguments
    And markdown is prepared as "# Main Title\n\n## Section 1\n\n### Subsection 1.1\n\nContent for 1.1\n\n### Subsection 1.2\n\nContent for 1.2\n\n## Section 2\n\n### Subsection 2.1\n\nContent for 2.1\n"
    And path is prepared as temp dir under "nested_headers.docx"
    When tools.tool word from markdown using str representation of temp dir under "nested_headers.docx"; "# Main Title\n\n## Section 1\n\n### Subsection 1.1\n\nContent for 1.1\n\n### Subsection 1.2\n\nContent for 1.2\n\n## Section 2\n\n### Subsection 2.1\n\nContent for 2.1\n"
    Then the result of Path with temp dir under "nested_headers.docx" exists is non-empty or true
