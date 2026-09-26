@captured @python_candidate
Feature: word advanced tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-advanced-tools-677797f600
  # Native: tests/test_word_advanced_tools.py::TestGetTextWithTrackChanges::test_reads_normal_text
  Scenario: Native check: reads normal text [TestGetTextWithTrackChanges]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "normal.docx"
    And path is prepared as temp dir under "normal.docx"
    And texts is prepared as the result of get text with track changes with p for each p in doc paragraphs
    When doc.add paragraph using "Normal text content"
    And get text with track changes using p
    Then at least one item satisfies "Normal text content" occurs in t for each t in the result of get text with track changes with p for each p in doc paragraphs

  @candidate-python-word-advanced-tools-e9d13f8f32
  # Native: tests/test_word_advanced_tools.py::TestListSections::test_lists_sections
  Scenario: Native check: lists sections [TestListSections]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word list sections using str representation of sow template
    Then "sections" occurs in result
    And at least one item satisfies "Executive Summary" occurs in t for each t in s field "title", defaulting to s field "text", defaulting to "" for each s in result at "sections"
    And at least one item satisfies "Scope" occurs in t for each t in s field "title", defaulting to s field "text", defaulting to "" for each s in result at "sections"

  @candidate-python-word-advanced-tools-bc701422c8
  # Native: tests/test_word_advanced_tools.py::TestListSections::test_file_not_found
  Scenario: Native check: file not found [TestListSections]
    Given Create an instance of WordAdvancedTools.
    When word advanced tools.tool word list sections using "/nonexistent.docx"
    Then "error" occurs in result

  @candidate-python-word-advanced-tools-644c267546
  # Native: tests/test_word_advanced_tools.py::TestGetSection::test_gets_section_content
  Scenario: Native check: gets section content [TestGetSection]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word get section using str representation of sow template; "Executive Summary"
    Then "content" occurs in result or "text" occurs in result or "paragraphs" occurs in str representation of result

  @candidate-python-word-advanced-tools-4cf2ca9b96
  # Native: tests/test_word_advanced_tools.py::TestGetSection::test_section_not_found
  Scenario: Native check: section not found [TestGetSection]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word get section using str representation of sow template; "Nonexistent Section"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase or "available" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-9b9014e064
  # Native: tests/test_word_advanced_tools.py::TestPatchSection::test_patches_section
  Scenario: Native check: patches section [TestPatchSection]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched.docx"
    When word advanced tools.tool word patch section using str representation of sow template; "Executive Summary"; "This is the new executive summary content."; output path str representation of temp dir under "patched.docx"
    Then result field "success" is true or "patched" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-b21cb2f405
  # Native: tests/test_word_advanced_tools.py::TestPatchSection::test_section_not_found
  Scenario: Native check: section not found [TestPatchSection]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "patched2.docx"
    When word advanced tools.tool word patch section using str representation of sow template; "Nonexistent"; "New content"; output path str representation of temp dir under "patched2.docx"
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-1d46d9d38a
  # Native: tests/test_word_advanced_tools.py::TestListTables::test_lists_tables
  Scenario: Native check: lists tables [TestListTables]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    When word advanced tools.tool word list tables using str representation of sample docx
    Then "tables" occurs in result
    And the number of entries in result at "tables" is at least 1

  @candidate-python-word-advanced-tools-0115b412ec
  # Native: tests/test_word_advanced_tools.py::TestGetTable::test_gets_table_by_index
  Scenario: Native check: gets table by index [TestGetTable]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    When word advanced tools.tool word get table using str representation of sample docx; "0"
    Then "rows" occurs in result or "data" occurs in result or "header" occurs in result

  @candidate-python-word-advanced-tools-c6f6a9923a
  # Native: tests/test_word_advanced_tools.py::TestInsertTableRow::test_inserts_row
  Scenario: Native check: inserts row [TestInsertTableRow]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "row_added.docx"
    When word advanced tools.tool word insert table row using str representation of sample docx; "0"; {"Role": "Analyst", "Hours": "80", "Rate": "$125"}; output path str representation of temp dir under "row_added.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-c4f2f63a28
  # Native: tests/test_word_advanced_tools.py::TestPatchTableRow::test_patches_row
  Scenario: Native check: patches row [TestPatchTableRow]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "row_patched.docx"
    When word advanced tools.tool word patch table row using str representation of sample docx; "0"; 1; {"Hours": "120"}; output path str representation of temp dir under "row_patched.docx"
    Then result field "success" is true or "updated" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-086c16207b
  # Native: tests/test_word_advanced_tools.py::TestAuditCompletion::test_finds_placeholders
  Scenario: Native check: finds placeholders [TestAuditCompletion]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word audit completion using str representation of sow template
    Then "issues" occurs in result or "placeholders" occurs in str representation of result in lowercase or "findings" occurs in result

  @candidate-python-word-advanced-tools-5e227202c6
  # Native: tests/test_word_advanced_tools.py::TestAuditCompletion::test_empty_document
  Scenario: Native check: empty document [TestAuditCompletion]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "clean.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "clean.docx"
    When word advanced tools.tool word audit completion using str representation of temp dir under "clean.docx"
    Then "error" does not occur in result

  @candidate-python-word-advanced-tools-e24b427e88
  # Native: tests/test_word_advanced_tools.py::TestAuditSow::test_audits_sow
  Scenario: Native check: audits sow [TestAuditSow]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word audit sow using str representation of sow template
    Then "issues" occurs in result or "placeholders" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-00a2014b81
  # Native: tests/test_word_advanced_tools.py::TestReplaceGlobalVariables::test_replaces_placeholders
  Scenario: Native check: replaces placeholders [TestReplaceGlobalVariables]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "replaced.docx"
    When word advanced tools.tool word replace global variables using str representation of sow template; {"<Customer Name>": "Contoso Corp", "<Project Name>": "Cloud Migration"}; output path str representation of temp dir under "replaced.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-d2058eb91a
  # Native: tests/test_word_advanced_tools.py::TestEnableTrackChanges::test_enables_tracking
  Scenario: Native check: enables tracking [TestEnableTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "tracked.docx"
    When word advanced tools.tool word enable track changes using str representation of sample docx; output path str representation of temp dir under "tracked.docx"
    Then result field "success" is true or "enabled" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-e6311d4040
  # Native: tests/test_word_advanced_tools.py::TestPatchWithTrackChanges::test_patches_with_tracking
  Scenario: Native check: patches with tracking [TestPatchWithTrackChanges]
    Given Create an instance of WordAdvancedTools.
    And Create a test Word document with sections.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "tracked_patch.docx"
    When word advanced tools.tool word patch with track changes using str representation of sample docx; {"executive summary content": "updated summary content"}; output path str representation of temp dir under "tracked_patch.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-fd0464090b
  # Native: tests/test_word_advanced_tools.py::TestGenerateSow::test_generates_sow
  Scenario: Native check: generates sow [TestGenerateSow]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "generated.docx"
    When word advanced tools.tool word generate sow using str representation of sow template; str representation of temp dir under "generated.docx"; {"customer_name": "Contoso Corp", "project_name": "Migration"}
    Then result field "success" is true

  @candidate-python-word-advanced-tools-9eac66e5eb
  # Native: tests/test_word_advanced_tools.py::TestGenerateSow::test_generates_sow_fills_staffing_table
  Scenario: Native check: generates sow fills staffing table [TestGenerateSow]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "generated_staffing.docx"
    When word advanced tools.tool word generate sow using str representation of sow template; str representation of temp dir under "generated_staffing.docx"; {"customer_name": "Contoso Corp", "project_name": "Migration", "staffing": [{"role": "Architect", "hours": "40"}]}
    Then result field "success" is true
    And result field "tables_filled", defaulting to 0 is at least 1
    And at least one item satisfies item field "purpose" equals "staffing" and item field "matched" for each item in result field "table_diagnostics", defaulting to []
    And "word_insert_at_anchor" occurs in result field "next_tools", defaulting to []
    And "Architect" occurs in the result of ' '.join with the result of ' '.join with row for each row in the result of get text with track changes with cell for each cell in row cells for each row in the result of Document with temp dir under "generated_staffing.docx" tables at 0 rows
    And "40" occurs in the result of ' '.join with the result of ' '.join with row for each row in the result of get text with track changes with cell for each cell in row cells for each row in the result of Document with temp dir under "generated_staffing.docx" tables at 0 rows

  @candidate-python-word-advanced-tools-6ffa5b0f4f
  # Native: tests/test_word_advanced_tools.py::TestGenerateSow::test_generate_sow_reports_missing_target_table_reason
  Scenario: Native check: generate sow reports missing target table reason [TestGenerateSow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template.save with temp dir under "missing_staffing_table.docx"
    And template is prepared as the result of Document with no arguments
    And other table is prepared as the result of template.add table with rows 2; cols 2
    And the result of template.add table with rows 2; cols 2 rows at 0 cells at 0 text is set to "Term / acronym"
    And the result of template.add table with rows 2; cols 2 rows at 0 cells at 1 text is set to "Description"
    And the result of template.add table with rows 2; cols 2 rows at 1 cells at 0 text is set to "API"
    And the result of template.add table with rows 2; cols 2 rows at 1 cells at 1 text is set to "Application Programming Interface"
    And template path is prepared as temp dir under "missing_staffing_table.docx"
    And output is prepared as temp dir under "missing_staffing_out.docx"
    When word advanced tools.tool word generate sow using str representation of temp dir under "missing_staffing_table.docx"; str representation of temp dir under "missing_staffing_out.docx"; {"staffing": [{"role": "Architect", "hours": "40"}]}
    Then result field "success" is false or result field "status" occurs in "{'partial_success', 'failed'}"
    And at least one item satisfies item field "purpose" equals "staffing" and item field "reason" equals "no_matching_table_found" for each item in result field "table_diagnostics", defaulting to []

  @candidate-python-word-advanced-tools-0804226cdb
  # Native: tests/test_word_advanced_tools.py::TestGenerateSow::test_generate_sow_normalizes_complex_table_headers
  Scenario: Native check: generate sow normalizes complex table headers [TestGenerateSow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template.save with temp dir under "complex_staffing_header.docx"
    And template is prepared as the result of Document with no arguments
    And staffing table is prepared as the result of template.add table with rows 2; cols 2
    And the result of template.add table with rows 2; cols 2 rows at 0 cells at 0 text is set to "Role / Skill"
    And the result of template.add table with rows 2; cols 2 rows at 0 cells at 1 text is set to "Count & Hours"
    And the result of template.add table with rows 2; cols 2 rows at 1 cells at 0 text is set to "Template role"
    And the result of template.add table with rows 2; cols 2 rows at 1 cells at 1 text is set to "Template hours"
    And template path is prepared as temp dir under "complex_staffing_header.docx"
    And output is prepared as temp dir under "complex_staffing_header_out.docx"
    When word advanced tools.tool word generate sow using str representation of temp dir under "complex_staffing_header.docx"; str representation of temp dir under "complex_staffing_header_out.docx"; {"staffing": [{"role": "Architect", "hours": "40"}]}
    Then result field "success" is true
    And the result of next with item for each item in result field "table_diagnostics", defaulting to [] where item field "purpose" equals "staffing" field "matched" is true
    And the result of next with item for each item in result field "table_diagnostics", defaulting to [] where item field "purpose" equals "staffing" field "normalized_header" equals ["role skill", "count and hours"]

  @candidate-python-word-advanced-tools-426629c53b
  # Native: tests/test_word_advanced_tools.py::TestGenerateSow::test_generate_sow_uses_second_header_row_when_first_is_banner
  Scenario: Native check: generate sow uses second header row when first is banner [TestGenerateSow]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template.save with temp dir under "banner_header_staffing.docx"
    And template is prepared as the result of Document with no arguments
    And staffing table is prepared as the result of template.add table with rows 3; cols 2
    And the result of staffing table.cell with 0; 0 text is set to "Staffing Plan"
    And the result of staffing table.cell with 0; 1 text is set to "Staffing Plan"
    And the result of template.add table with rows 3; cols 2 rows at 1 cells at 0 text is set to "Role / Skill"
    And the result of template.add table with rows 3; cols 2 rows at 1 cells at 1 text is set to "Count & Hours"
    And the result of template.add table with rows 3; cols 2 rows at 2 cells at 0 text is set to "Template role"
    And the result of template.add table with rows 3; cols 2 rows at 2 cells at 1 text is set to "Template hours"
    And template path is prepared as temp dir under "banner_header_staffing.docx"
    And output is prepared as temp dir under "banner_header_staffing_out.docx"
    When word advanced tools.tool word generate sow using str representation of temp dir under "banner_header_staffing.docx"; str representation of temp dir under "banner_header_staffing_out.docx"; {"staffing": [{"role": "Architect", "hours": "40"}]}
    Then result field "success" is true
    And the result of next with item for each item in result field "table_diagnostics", defaulting to [] where item field "purpose" equals "staffing" field "matched" is true
    And the result of next with item for each item in result field "table_diagnostics", defaulting to [] where item field "purpose" equals "staffing" field "header_rows_used" equals [0, 1]
    And "Architect" occurs in the result of ' '.join with the result of ' '.join with row for each row in the result of get text with track changes with cell for each cell in row cells for each row in the result of Document with temp dir under "banner_header_staffing_out.docx" tables at 0 rows
    And "40" occurs in the result of ' '.join with the result of ' '.join with row for each row in the result of get text with track changes with cell for each cell in row cells for each row in the result of Document with temp dir under "banner_header_staffing_out.docx" tables at 0 rows

  @candidate-python-word-advanced-tools-e042e72f8b
  # Native: tests/test_word_advanced_tools.py::TestCopyTemplate::test_copies_template
  Scenario: Native check: copies template [TestCopyTemplate]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "copied.docx"
    When word advanced tools.tool word copy template using str representation of sow template; str representation of temp dir under "copied.docx"
    Then result field "success" is true
    And temp dir under "copied.docx" exists is non-empty or true

  @candidate-python-word-advanced-tools-b16998420d
  # Native: tests/test_word_advanced_tools.py::TestFixSplitPlaceholders::test_fixes_placeholders
  Scenario: Native check: fixes placeholders [TestFixSplitPlaceholders]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "fixed.docx"
    When word advanced tools.tool word fix split placeholders using str representation of sow template; {"<Customer Name>": "Contoso"}; output path str representation of temp dir under "fixed.docx"
    Then result field "success" is true

  @candidate-python-word-advanced-tools-b9628384c0
  # Native: tests/test_word_advanced_tools.py::TestCleanupSow::test_cleans_sow
  Scenario: Native check: cleans sow [TestCleanupSow]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "cleaned.docx"
    When word advanced tools.tool word cleanup sow using str representation of sow template; output path str representation of temp dir under "cleaned.docx"
    Then result field "success" is true or "cleaned" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-6314c91af5
  # Native: tests/test_word_advanced_tools.py::TestGetSectionGuidance::test_gets_guidance
  Scenario: Native check: gets guidance [TestGetSectionGuidance]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word get section guidance using str representation of sow template; "Executive Summary"
    Then "guidance" occurs in result or "content" occurs in result or "error" does not occur in str representation of result in lowercase

  @candidate-python-word-advanced-tools-2efa464bb2
  # Native: tests/test_word_advanced_tools.py::TestParseSowTemplate::test_parses_template
  Scenario: Native check: parses template [TestParseSowTemplate]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    When word advanced tools.tool word parse sow template using str representation of sow template
    Then "sections" occurs in result or "structure" occurs in result or "template" occurs in str representation of result in lowercase

  @candidate-python-word-advanced-tools-e6c70de6b3
  # Native: tests/test_word_advanced_tools.py::TestAnalyzeTemplateFormatting::test_analyzes_formatting
  Scenario: SOW formatting analysis accepts either no error membership or a dictionary response
    Given an isolated writable directory and a WordAdvancedTools instance
    And a saved template with level-0 heading "Statement of Work" and paragraphs "<Customer Name>" and "<Project Name>"
    And level-1 heading "Executive Summary" followed by "[Template Guidance: Describe the project here]"
    And level-1 heading "Scope" followed by "<Customer Name> requires the following services."
    And level-1 heading "Staffing" followed by a 2-by-2 table whose first row is "Role", "Hours"
    When tool_word_analyze_template_formatting reads that saved template
    Then either "error" is not a member of the result or the result is a dictionary, including an error dictionary

  @candidate-python-word-advanced-tools-95a1d33a6d
  # Native: tests/test_word_advanced_tools.py::TestWordFromMarkdown::test_method_location
  Scenario: Native check: method location [TestWordFromMarkdown]
    Given Import WordTools from tools.word_tools.
    When Instantiate wt = WordTools().
    And Evaluate hasattr(wt, 'tool_word_from_markdown').
    Then The WordTools instance exposes tool_word_from_markdown.

  @candidate-python-word-advanced-tools-8d5ec232f1
  # Native: tests/test_word_advanced_tools.py::TestCreateSowFromMarkdown::test_creates_sow
  Scenario: Native check: creates sow [TestCreateSowFromMarkdown]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And md is prepared as "# Statement of Work\n\n## Executive Summary\n\nThis is the executive summary.\n\n## Scope\n\nProject scope description.\n"
    And output is prepared as temp dir under "sow_from_md.docx"
    When word advanced tools.tool word create sow from markdown using str representation of temp dir under "sow_from_md.docx"; "# Statement of Work\n\n## Executive Summary\n\nThis is the executive summary.\n\n## Scope\n\nProject scope description.\n"; str representation of sow template
    Then result field "success" is true or temp dir under "sow_from_md.docx" exists

  @candidate-python-word-advanced-tools-d8fb6ce620
  # Native: tests/test_word_advanced_tools.py::TestCreateSowFromMarkdown::test_extracts_narrative_sections_from_markdown
  Scenario: Native check: extracts narrative sections from markdown [TestCreateSowFromMarkdown]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template.save with temp dir under "narrative_template.docx"
    And template is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "narrative_template.docx"
    And md is prepared as "# Statement of Work\n\nCustomer: Contoso Ltd\nProject: Migration Factory\n\n## Executive Summary\n\nThis is the executive summary.\n\n## Delivery approach\n\nMicrosoft will undertake an iterative delivery approach.\n\n## Customer responsibilities and project assumptions\n\nCustomer will provide timely access to systems.\n"
    And output is prepared as temp dir under "narrative_output.docx"
    When word advanced tools.tool word create sow from markdown using str representation of temp dir under "narrative_output.docx"; "# Statement of Work\n\nCustomer: Contoso Ltd\nProject: Migration Factory\n\n## Executive Summary\n\nThis is the executive summary.\n\n## Delivery approach\n\nMicrosoft will undertake an iterative delivery approach.\n\n## Customer responsibilities and project assumptions\n\nCustomer will provide timely access to systems.\n"; str representation of temp dir under "narrative_template.docx"
    Then result field "success" is true
    And "sections" occurs in result field "extracted_fields", defaulting to []
    And result field "sections_filled", defaulting to 0 is at least 3
    And not result field "unmapped_sections"
    And every item satisfies item field "matched" for each item in result field "section_diagnostics", defaulting to []
    And "word_insert_at_anchor" occurs in result field "next_tools", defaulting to []
    And at least one item satisfies "This is the executive summary." occurs in p for each p in the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "narrative_output.docx" paragraphs
    And at least one item satisfies "Microsoft will undertake an iterative delivery approach." occurs in p for each p in the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "narrative_output.docx" paragraphs
    And at least one item satisfies "Customer will provide timely access to systems." occurs in p for each p in the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "narrative_output.docx" paragraphs

  @candidate-python-word-advanced-tools-2ff8ceb463
  # Native: tests/test_word_advanced_tools.py::TestInsertAtAnchor::test_inserts_after_anchor_text
  Scenario: Native check: inserts after anchor text [TestInsertAtAnchor]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "insert_anchor.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "insert_anchor.docx"
    And output is prepared as temp dir under "insert_anchor_out.docx"
    When word advanced tools.tool word insert at anchor using str representation of temp dir under "insert_anchor.docx"; "Inserted content."; anchor text "Anchor paragraph"; position "after"; output path str representation of temp dir under "insert_anchor_out.docx"
    Then result field "success" is true
    And the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "insert_anchor_out.docx" paragraphs where the result of get text with track changes with p with boundary whitespace removed equals ["Intro", "Anchor paragraph", "Inserted content.", "Tail"]

  @candidate-python-word-advanced-tools-3292964cf0
  # Native: tests/test_word_advanced_tools.py::TestInsertAtAnchor::test_inserts_before_paragraph_index
  Scenario: Native check: inserts before paragraph index [TestInsertAtAnchor]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "insert_index.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "insert_index.docx"
    And output is prepared as temp dir under "insert_index_out.docx"
    When word advanced tools.tool word insert at anchor using str representation of temp dir under "insert_index.docx"; ["Inserted A", "Inserted B"]; paragraph index 1; position "before"; output path str representation of temp dir under "insert_index_out.docx"
    Then result field "success" is true
    And the result of get text with track changes with p with boundary whitespace removed for each p in the result of Document with temp dir under "insert_index_out.docx" paragraphs where the result of get text with track changes with p with boundary whitespace removed equals ["First", "Inserted A", "Inserted B", "Second"]

  @candidate-python-word-advanced-tools-62be8d475c
  # Native: tests/test_word_advanced_tools.py::TestInsertAtAnchor::test_insert_requires_single_anchor_mode
  Scenario: Native check: insert requires single anchor mode [TestInsertAtAnchor]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "insert_validation.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "insert_validation.docx"
    When word advanced tools.tool word insert at anchor using str representation of temp dir under "insert_validation.docx"; "Text"; anchor text "Only paragraph"; paragraph index 0
    Then "error" occurs in result

  @candidate-python-word-advanced-tools-4a550d3073
  # Native: tests/test_word_advanced_tools.py::TestInsertAtAnchor::test_reports_unmapped_markdown_sections
  Scenario: Native check: reports unmapped markdown sections [TestInsertAtAnchor]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And template.save with temp dir under "unmapped_template.docx"
    And template is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "unmapped_template.docx"
    And md is prepared as "# Statement of Work\n\n## Executive Summary\n\nCovered summary.\n\n## Completely Custom Section\n\nThis section has no template match.\n"
    And output is prepared as temp dir under "unmapped_output.docx"
    When word advanced tools.tool word create sow from markdown using str representation of temp dir under "unmapped_output.docx"; "# Statement of Work\n\n## Executive Summary\n\nCovered summary.\n\n## Completely Custom Section\n\nThis section has no template match.\n"; str representation of temp dir under "unmapped_template.docx"
    Then result field "success" is true
    And "completely_custom_section" occurs in result field "unmapped_sections", defaulting to []
    And at least one item satisfies not item field "matched" for each item in result field "section_diagnostics", defaulting to []
    And "word_insert_at_anchor" occurs in result field "next_tools", defaulting to []

  @candidate-python-word-advanced-tools-53732cbd1c
  # Native: tests/test_word_advanced_tools.py::TestAddComment::test_adds_comment
  Scenario: Native check: adds comment [TestAddComment]
    Given Create an instance of WordAdvancedTools.
    And Create a SOW-style template document.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "commented.docx"
    When word advanced tools.tool word add comment using str representation of sow template; "Executive Summary"; "This needs more detail"; output path str representation of temp dir under "commented.docx"
    Then result field "success" is true or "added" occurs in str representation of result in lowercase
