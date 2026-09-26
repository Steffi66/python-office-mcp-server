@captured @python_candidate
Feature: eighty percent native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-eighty-percent-2ebb02c5da
  # Native: tests/test_eighty_percent.py::TestWordExtractDeep::test_extract_with_all_elements
  Scenario: Native check: extract with all elements [TestWordExtractDeep]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "all_elements.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And the result of table.cell with 0; 1 text is set to "B"
    And path is prepared as temp dir under "all_elements.docx"
    And tools is prepared as the result of WordTools with no arguments
    When tools.tool word extract using str representation of temp dir under "all_elements.docx"
    Then "paragraphs" occurs in result or "text" occurs in str representation of result

  @candidate-python-eighty-percent-f43345c801
  # Native: tests/test_eighty_percent.py::TestPptxExtractDeep::test_extract_with_shapes_and_tables
  Scenario: Native check: extract with shapes and tables [TestPptxExtractDeep]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "shapes_tables.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide1 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 0 shapes title text is set to "Main Title"
    And slide2 is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Data"
    And table is prepared as the result of slide2.shapes.add table with 3; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 2
    And tbl is prepared as the result of slide2.shapes.add table with 3; 2; the result of PptxInches with 1; the result of PptxInches with 2; the result of PptxInches with 5; the result of PptxInches with 2 table
    And the result of tbl.cell with 0; 0 text is set to "H1"
    And the result of tbl.cell with 0; 1 text is set to "H2"
    And path is prepared as temp dir under "shapes_tables.pptx"
    And tools is prepared as the result of PowerPointTools with no arguments
    When tools.tool pptx extract using str representation of temp dir under "shapes_tables.pptx"
    Then result has type dict

  @candidate-python-eighty-percent-d55ded5baf
  # Native: tests/test_eighty_percent.py::TestWordFromMarkdownVariations::test_with_numbered_list
  Scenario: Native check: with numbered list [TestWordFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of WordTools with no arguments
    And md is prepared as "# Document\n\n## Steps\n\n1. First step\n2. Second step\n3. Third step\n"
    And path is prepared as temp dir under "numbered.docx"
    When tools.tool word from markdown using str representation of temp dir under "numbered.docx"; "# Document\n\n## Steps\n\n1. First step\n2. Second step\n3. Third step\n"
    Then the result of Path with temp dir under "numbered.docx" exists is non-empty or true

  @candidate-python-eighty-percent-dbfcdc7c7b
  # Native: tests/test_eighty_percent.py::TestWordFromMarkdownVariations::test_with_mixed_content
  Scenario: Native check: with mixed content [TestWordFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of WordTools with no arguments
    And md is prepared as "# Title\n\n## Section 1\n\nRegular paragraph text.\n\n- Bullet 1\n- Bullet 2\n\n| Col A | Col B |\n|-------|-------|\n| 1 | 2 |\n\n## Section 2\n\nMore text here.\n"
    And path is prepared as temp dir under "mixed.docx"
    When tools.tool word from markdown using str representation of temp dir under "mixed.docx"; "# Title\n\n## Section 1\n\nRegular paragraph text.\n\n- Bullet 1\n- Bullet 2\n\n| Col A | Col B |\n|-------|-------|\n| 1 | 2 |\n\n## Section 2\n\nMore text here.\n"
    Then the result of Path with temp dir under "mixed.docx" exists is non-empty or true

  @candidate-python-eighty-percent-76b0d0468d
  # Native: tests/test_eighty_percent.py::TestPptxFromMarkdownVariations::test_multiple_sections
  Scenario: Native check: multiple sections [TestPptxFromMarkdownVariations]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Presentation Title\n\n## Section 1\n- Point A\n- Point B\n\n---\n\n## Section 2\n- Point C\n- Point D\n\n---\n\n## Section 3\n- Point E\n- Point F\n"
    And path is prepared as temp dir under "multi_section.pptx"
    When tools.tool pptx from markdown using str representation of temp dir under "multi_section.pptx"; "# Presentation Title\n\n## Section 1\n- Point A\n- Point B\n\n---\n\n## Section 2\n- Point C\n- Point D\n\n---\n\n## Section 3\n- Point E\n- Point F\n"
    Then the result of Path with temp dir under "multi_section.pptx" exists is non-empty or true

  @candidate-python-eighty-percent-76e17cec76
  # Native: tests/test_eighty_percent.py::TestExcelOperationsDeep::test_extract_with_formulas
  Scenario: Native check: extract with formulas [TestExcelOperationsDeep]
    Given an isolated writable temporary directory
    And tools is prepared as the result of ExcelTools with no arguments
    And md is prepared as "| Value | Multiplier | Result |\n|-------|------------|--------|\n| 10 | 2 | 20 |\n| 20 | 3 | 60 |\n| 30 | 4 | 120 |\n"
    And path is prepared as temp dir under "formulas.xlsx"
    When tools.tool excel from markdown using str representation of temp dir under "formulas.xlsx"; "| Value | Multiplier | Result |\n|-------|------------|--------|\n| 10 | 2 | 20 |\n| 20 | 3 | 60 |\n| 30 | 4 | 120 |\n"
    And tools.tool excel extract using str representation of temp dir under "formulas.xlsx"
    Then result has type dict

  @candidate-python-eighty-percent-9142489570
  # Native: tests/test_eighty_percent.py::TestWordSowWorkflow::test_full_sow_workflow
  Scenario: Native check: full sow workflow [TestWordSowWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "template.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And template path is prepared as temp dir under "template.docx"
    When tools.tool word parse sow template using str representation of temp dir under "template.docx"
    And tools.tool word copy template using str representation of temp dir under "template.docx"; str representation of temp dir under "sow.docx"
    And tools.tool word replace global variables using str representation of temp dir under "sow.docx"; {"<Customer Name>": "Contoso", "<Project Name>": "Migration", "<Provider Name>": "Microsoft"}
    Then result has type dict

  @candidate-python-eighty-percent-e1caec4075
  # Native: tests/test_eighty_percent.py::TestPptxCompleteWorkflow::test_full_presentation_workflow
  Scenario: Native check: full presentation workflow [TestPptxCompleteWorkflow]
    Given an isolated writable temporary directory
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And basic tools is prepared as the result of PowerPointTools with no arguments
    And md is prepared as "# Presentation\n\n## Slide 1\n- Point 1\n- Point 2\n\n## Slide 2\n- Point 3\n- Point 4\n"
    And path is prepared as temp dir under "workflow.pptx"
    When basic tools.tool pptx from markdown using str representation of temp dir under "workflow.pptx"; "# Presentation\n\n## Slide 1\n- Point 1\n- Point 2\n\n## Slide 2\n- Point 3\n- Point 4\n"
    And tools.tool pptx list slides using str representation of temp dir under "workflow.pptx"
    And tools.tool pptx add slide using str representation of temp dir under "workflow.pptx"; title "New Slide"
    And tools.tool pptx set notes using str representation of temp dir under "workflow.pptx"; 1; "Speaker notes"
    Then result field "slide_count", defaulting to 0 is at least 2
    And result has type dict

  @candidate-python-eighty-percent-5b78de9158
  # Native: tests/test_eighty_percent.py::TestWordTableWorkflow::test_table_operations_workflow
  Scenario: Native check: table operations workflow [TestWordTableWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "tables.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And headers is prepared as ["Name", "Role", "Hours"]
    And the result of table.cell with 1; 0 text is set to "Alice"
    And the result of table.cell with 1; 1 text is set to "Dev"
    And the result of table.cell with 1; 2 text is set to "40"
    And the result of table.cell with 2; 0 text is set to "Bob"
    And the result of table.cell with 2; 1 text is set to "QA"
    And the result of table.cell with 2; 2 text is set to "35"
    And path is prepared as temp dir under "tables.docx"
    When tools.tool word list tables using str representation of temp dir under "tables.docx"
    And tools.tool word get table using str representation of temp dir under "tables.docx"; "0"
    And tools.tool word insert table row using str representation of temp dir under "tables.docx"; "0"; {"Name": "Carol", "Role": "PM", "Hours": "45"}
    Then the number of entries in result field "tables", defaulting to [] is at least 1
    And result has type dict

  @candidate-python-eighty-percent-c409f2825d
  # Native: tests/test_eighty_percent.py::TestPptxTableWorkflow::test_pptx_table_operations
  Scenario: Native check: pptx table operations [TestPptxTableWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "pptx_table.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5 shapes title text is set to "Table"
    And path is prepared as temp dir under "pptx_table.pptx"
    When tools.tool pptx add table using str representation of temp dir under "pptx_table.pptx"; 1; ["A", "B", "C"]; [["1", "2", "3"], ["4", "5", "6"]]
    And tools.tool pptx get table using str representation of temp dir under "pptx_table.pptx"; 1
    Then result has type dict

  @candidate-python-eighty-percent-f24be4d7d5
  # Native: tests/test_eighty_percent.py::TestWordAuditWorkflow::test_audit_workflow
  Scenario: Native check: audit workflow [TestWordAuditWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "audit.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "audit.docx"
    When tools.tool word audit completion using str representation of temp dir under "audit.docx"
    And tools.tool word audit sow using str representation of temp dir under "audit.docx"
    Then result has type dict

  @candidate-python-eighty-percent-33bb6b6734
  # Native: tests/test_eighty_percent.py::TestPptxAuditWorkflow::test_audit_workflow
  Scenario: Native check: audit workflow [TestPptxAuditWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "pptx_audit.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title with <Customer>"
    And path is prepared as temp dir under "pptx_audit.pptx"
    When tools.tool pptx audit placeholders using str representation of temp dir under "pptx_audit.pptx"
    Then result has type dict

  @candidate-python-eighty-percent-fc729a4d55
  # Native: tests/test_eighty_percent.py::TestWordCommentWorkflow::test_comment_workflow
  Scenario: Native check: comment workflow [TestWordCommentWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "comment.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "comment.docx"
    When tools.tool word add comment using str representation of temp dir under "comment.docx"; "needs review"; "Please verify this section."; author "Reviewer"
    Then result has type dict

  @candidate-python-eighty-percent-cf4f4397dc
  # Native: tests/test_eighty_percent.py::TestPptxCommentWorkflow::test_comment_workflow
  Scenario: Native check: comment workflow [TestPptxCommentWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "comments.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Review Slide"
    And path is prepared as temp dir under "comments.pptx"
    When tools.tool pptx add comment using str representation of temp dir under "comments.pptx"; 1; "Review this slide"; author "Reviewer"
    And tools.tool pptx get comments using str representation of temp dir under "comments.pptx"
    Then result has type dict

  @candidate-python-eighty-percent-02f53935dc
  # Native: tests/test_eighty_percent.py::TestWordTrackChangesWorkflow::test_track_changes_workflow
  Scenario: Native check: track changes workflow [TestWordTrackChangesWorkflow]
    Given an isolated writable temporary directory
    And doc.save with temp dir under "track.docx"
    And tools is prepared as the result of WordAdvancedTools with no arguments
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "track.docx"
    When tools.tool word enable track changes using str representation of temp dir under "track.docx"
    And tools.tool word check tracking using str representation of temp dir under "track.docx"
    Then result has type dict

  @candidate-python-eighty-percent-b258566855
  # Native: tests/test_eighty_percent.py::TestPptxNotesWorkflow::test_notes_workflow
  Scenario: Native check: notes workflow [TestPptxNotesWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "notes.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Notes Test"
    And path is prepared as temp dir under "notes.pptx"
    When tools.tool pptx set notes using str representation of temp dir under "notes.pptx"; 1; "Speaker notes here"
    And tools.tool pptx get notes using str representation of temp dir under "notes.pptx"; slide number 1
    Then result has type dict

  @candidate-python-eighty-percent-58b8ccda89
  # Native: tests/test_eighty_percent.py::TestPptxSlideManagementWorkflow::test_slide_management_workflow
  Scenario: Native check: slide management workflow [TestPptxSlideManagementWorkflow]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "manage.pptx"
    And tools is prepared as the result of PresentationAdvancedTools with no arguments
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "manage.pptx"
    When tools.tool pptx duplicate slide using str representation of temp dir under "manage.pptx"; 1
    And tools.tool pptx hide slide using str representation of temp dir under "manage.pptx"; 2; hidden true
    And tools.tool pptx get hidden slides using str representation of temp dir under "manage.pptx"
    Then result has type dict
