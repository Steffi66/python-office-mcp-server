@captured @python_candidate
Feature: more coverage native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-more-coverage-075314a3bf
  # Native: tests/test_more_coverage.py::TestPromptFunctions::test_prompt_sow_generation
  Scenario: Native check: prompt sow generation [TestPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And result is prepared as the result of word advanced tools.prompt sow generation with no arguments
    When word advanced tools.prompt sow generation using the prepared inputs
    Then the result of word advanced tools.prompt sow generation with no arguments has type dict
    And "name" occurs in the result of word advanced tools.prompt sow generation with no arguments or "arguments" occurs in the result of word advanced tools.prompt sow generation with no arguments or "prompt" occurs in the result of word advanced tools.prompt sow generation with no arguments

  @candidate-python-more-coverage-812ac9e8fe
  # Native: tests/test_more_coverage.py::TestPromptFunctions::test_prompt_section_editing
  Scenario: Native check: prompt section editing [TestPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And result is prepared as the result of word advanced tools.prompt section editing with no arguments
    When word advanced tools.prompt section editing using the prepared inputs
    Then the result of word advanced tools.prompt section editing with no arguments has type dict

  @candidate-python-more-coverage-058d2fbf09
  # Native: tests/test_more_coverage.py::TestPromptFunctions::test_prompt_document_audit
  Scenario: Native check: prompt document audit [TestPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And result is prepared as the result of word advanced tools.prompt document audit with no arguments
    When word advanced tools.prompt document audit using the prepared inputs
    Then the result of word advanced tools.prompt document audit with no arguments has type dict

  @candidate-python-more-coverage-5bc542c4f0
  # Native: tests/test_more_coverage.py::TestPromptFunctions::test_prompt_table_editing
  Scenario: Native check: prompt table editing [TestPromptFunctions]
    Given Create an instance of WordAdvancedTools.
    And result is prepared as the result of word advanced tools.prompt table editing with no arguments
    When word advanced tools.prompt table editing using the prepared inputs
    Then the result of word advanced tools.prompt table editing with no arguments has type dict

  @candidate-python-more-coverage-e8e27f7a44
  # Native: tests/test_more_coverage.py::TestMoreWordErrorHandling::test_patch_placeholder_not_found
  Scenario: Native check: patch placeholder not found [TestMoreWordErrorHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "no_ph.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "no_ph.docx"
    When word advanced tools.tool word patch placeholder using str representation of temp dir under "no_ph.docx"; "<Missing>"; "Replacement"
    Then result has type dict

  @candidate-python-more-coverage-6a65e72890
  # Native: tests/test_more_coverage.py::TestMoreWordErrorHandling::test_get_table_string_index
  Scenario: Native check: get table string index [TestMoreWordErrorHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "str_index.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "A"
    And path is prepared as temp dir under "str_index.docx"
    When word advanced tools.tool word get table using str representation of temp dir under "str_index.docx"; "0"
    Then result has type dict

  @candidate-python-more-coverage-ff97216bd4
  # Native: tests/test_more_coverage.py::TestMoreWordErrorHandling::test_insert_table_row_invalid_table
  Scenario: Native check: insert table row invalid table [TestMoreWordErrorHandling]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "one_table.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "one_table.docx"
    When word advanced tools.tool word insert table row using str representation of temp dir under "one_table.docx"; "999"; {"A": "1"}
    Then "error" occurs in result or "not found" occurs in str representation of result in lowercase

  @candidate-python-more-coverage-a129b64777
  # Native: tests/test_more_coverage.py::TestMorePptxOperations::test_add_bullet_with_shape
  Scenario: Native check: add bullet with shape [TestMorePptxOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "bullet_shape.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Title"
    And path is prepared as temp dir under "bullet_shape.pptx"
    And output is prepared as temp dir under "with_bullet.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of temp dir under "bullet_shape.pptx"; slide number 1; text "New bullet point"; shape identifier "body"; output path str representation of temp dir under "with_bullet.pptx"
    Then result has type dict

  @candidate-python-more-coverage-c53d50cb71
  # Native: tests/test_more_coverage.py::TestMorePptxOperations::test_set_notes_empty
  Scenario: Native check: set notes empty [TestMorePptxOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "empty_notes.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "empty_notes.pptx"
    And output is prepared as temp dir under "cleared_notes.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of temp dir under "empty_notes.pptx"; slide number 1; notes text ""; output path str representation of temp dir under "cleared_notes.pptx"
    Then result has type dict

  @candidate-python-more-coverage-5c74611505
  # Native: tests/test_more_coverage.py::TestMorePptxOperations::test_get_slide_invalid
  Scenario: Native check: get slide invalid [TestMorePptxOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "one_slide.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "one_slide.pptx"
    When pptx advanced tools.tool pptx get slide using str representation of temp dir under "one_slide.pptx"; slide number 99
    Then "error" occurs in result

  @candidate-python-more-coverage-2782b71906
  # Native: tests/test_more_coverage.py::TestWordTemplateOperations::test_copy_template_missing_source
  Scenario: Native check: copy template missing source [TestWordTemplateOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    When word advanced tools.tool word copy template using "/nonexistent/template.docx"; str representation of temp dir under "dest.docx"
    Then "error" occurs in result

  @candidate-python-more-coverage-8c6b0d8595
  # Native: tests/test_more_coverage.py::TestWordTemplateOperations::test_analyze_template_empty
  Scenario: Native check: analyze template empty [TestWordTemplateOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "simple.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "simple.docx"
    When word advanced tools.tool word analyze template formatting using str representation of temp dir under "simple.docx"
    Then result has type dict

  @candidate-python-more-coverage-5179dcb82d
  # Native: tests/test_more_coverage.py::TestMorePptxLayouts::test_recommend_layout_image
  Scenario: Native check: recommend layout image [TestMorePptxLayouts]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "img_layout.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "img_layout.pptx"
    When pptx advanced tools.tool pptx recommend layout using str representation of temp dir under "img_layout.pptx"; "image"
    Then result has type dict

  @candidate-python-more-coverage-17b6cb943a
  # Native: tests/test_more_coverage.py::TestMorePptxLayouts::test_recommend_layout_title
  Scenario: Native check: recommend layout title [TestMorePptxLayouts]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "title_layout.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "title_layout.pptx"
    When pptx advanced tools.tool pptx recommend layout using str representation of temp dir under "title_layout.pptx"; "title"
    Then result has type dict

  @candidate-python-more-coverage-4aa7459b14
  # Native: tests/test_more_coverage.py::TestWordComplexDocuments::test_document_with_images
  Scenario: Native check: document with images [TestWordComplexDocuments]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "complex.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 2
    And the result of table.cell with 0; 0 text is set to "Cell"
    And path is prepared as temp dir under "complex.docx"
    When word advanced tools.tool word list sections using str representation of temp dir under "complex.docx"
    Then result has type dict

  @candidate-python-more-coverage-4b9fa1aee2
  # Native: tests/test_more_coverage.py::TestWordComplexDocuments::test_extract_sow_structure_complex
  Scenario: Native check: extract sow structure complex [TestWordComplexDocuments]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "complex_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 3; cols 3
    And the result of table.cell with 0; 0 text is set to "ID"
    And the result of table.cell with 0; 1 text is set to "Deliverable"
    And the result of table.cell with 0; 2 text is set to "Date"
    And path is prepared as temp dir under "complex_sow.docx"
    When word advanced tools.tool word extract sow structure using str representation of temp dir under "complex_sow.docx"
    Then result has type dict

  @candidate-python-more-coverage-460fa4f5e0
  # Native: tests/test_more_coverage.py::TestPptxTableOperations::test_get_table_multiple_tables
  Scenario: Native check: get table multiple tables [TestPptxTableOperations]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "two_tables.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 5
    And table1 is prepared as the result of slide.shapes.add table with rows 2; cols 2; left the result of Inches with 0.5; top the result of Inches with 1.5; width the result of Inches with 3; height the result of Inches with 1 table
    And the result of table1.cell with 0; 0 text is set to "Table1"
    And table2 is prepared as the result of slide.shapes.add table with rows 2; cols 2; left the result of Inches with 5; top the result of Inches with 1.5; width the result of Inches with 3; height the result of Inches with 1 table
    And the result of table2.cell with 0; 0 text is set to "Table2"
    And path is prepared as temp dir under "two_tables.pptx"
    When pptx advanced tools.tool pptx get table using str representation of temp dir under "two_tables.pptx"; slide number 1; table index 1
    Then result has type dict

  @candidate-python-more-coverage-c3bbba58c7
  # Native: tests/test_more_coverage.py::TestWordCheckOperations::test_check_tracking_enabled
  Scenario: Native check: check tracking enabled [TestWordCheckOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "check_track.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "check_track.docx"
    When word advanced tools.tool word enable track changes using str representation of temp dir under "check_track.docx"
    And word advanced tools.tool word check tracking using str representation of temp dir under "check_track.docx"
    Then result has type dict

  @candidate-python-more-coverage-64a7df8464
  # Native: tests/test_more_coverage.py::TestPptxDuplication::test_duplicate_first_slide
  Scenario: Native check: duplicate first slide [TestPptxDuplication]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "dup_first.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Original"
    And path is prepared as temp dir under "dup_first.pptx"
    And output is prepared as temp dir under "duplicated.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of temp dir under "dup_first.pptx"; slide number 1; position "end"; output path str representation of temp dir under "duplicated.pptx"
    Then result field "success" is true or "slide" occurs in str representation of result

  @candidate-python-more-coverage-a0cec582a3
  # Native: tests/test_more_coverage.py::TestCleanupOperations::test_cleanup_sow_with_guidance
  Scenario: Native check: cleanup sow with guidance [TestCleanupOperations]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with temp dir under "guidance_sow.docx"
    And doc is prepared as the result of Document with no arguments
    And path is prepared as temp dir under "guidance_sow.docx"
    And output is prepared as temp dir under "cleaned.docx"
    When word advanced tools.tool word cleanup sow using str representation of temp dir under "guidance_sow.docx"; output path str representation of temp dir under "cleaned.docx"
    Then result has type dict

  @candidate-python-more-coverage-f587a02bfb
  # Native: tests/test_more_coverage.py::TestPptxPlaceholderReplacement::test_replace_in_notes
  Scenario: Native check: replace in notes [TestPptxPlaceholderReplacement]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "notes_replace.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer> Presentation"
    And notes slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 notes slide notes text frame text is set to "Notes for <Customer>"
    And path is prepared as temp dir under "notes_replace.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "notes_replace.pptx"; find text "<Customer>"; replace text "Contoso"; output path str representation of temp dir under "replaced.pptx"
    Then result has type dict
