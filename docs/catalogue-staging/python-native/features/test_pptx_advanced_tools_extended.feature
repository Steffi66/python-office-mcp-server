@captured @python_candidate
Feature: pptx advanced tools extended native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-pptx-advanced-tools-extended-9077938164
  # Native: tests/test_pptx_advanced_tools_extended.py::TestReorderSlides::test_reorder_slides
  Scenario: Native check: reorder slides [TestReorderSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "reordered.pptx"
    When pptx advanced tools.tool pptx reorder slides using str representation of multi slide presentation; [1, 3, 2, 4]; output path str representation of temp dir under "reordered.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-59251c1cbd
  # Native: tests/test_pptx_advanced_tools_extended.py::TestReorderSlides::test_reorder_invalid_order
  Scenario: Native check: reorder invalid order [TestReorderSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx reorder slides using str representation of multi slide presentation; [1, 2, 3, 4, 5, 6]
    Then result has type dict

  @candidate-python-pptx-advanced-tools-extended-078aca1d31
  # Native: tests/test_pptx_advanced_tools_extended.py::TestLogChanges::test_logs_changes
  Scenario: Native check: logs changes [TestLogChanges]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "with_log.pptx"
    And changes is prepared as [{"slide": 1, "action": "Updated title", "detail": "Changed main title"}, {"slide": 2, "action": "Added content", "detail": "Added bullets"}]
    When pptx advanced tools.tool pptx log changes using str representation of multi slide presentation; [{"slide": 1, "action": "Updated title", "detail": "Changed main title"}, {"slide": 2, "action": "Added content", "detail": "Added bullets"}]; output path str representation of temp dir under "with_log.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-71303a3bc8
  # Native: tests/test_pptx_advanced_tools_extended.py::TestTableOperations::test_get_table
  Scenario: Native check: get table [TestTableOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with a table.
    When pptx advanced tools.tool pptx get table using str representation of presentation with table; slide number 1; table index 0
    Then "header" occurs in result or "rows" occurs in result or "columns" occurs in result

  @candidate-python-pptx-advanced-tools-extended-1ee246c5ba
  # Native: tests/test_pptx_advanced_tools_extended.py::TestLayoutAnalysis::test_analyze_layouts
  Scenario: Native check: analyze layouts [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx analyze layouts using str representation of multi slide presentation
    Then "layouts" occurs in result or "default_layouts" occurs in result

  @candidate-python-pptx-advanced-tools-extended-7fe1fdd593
  # Native: tests/test_pptx_advanced_tools_extended.py::TestLayoutAnalysis::test_recommend_layout_bullets
  Scenario: Native check: recommend layout bullets [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx recommend layout using str representation of multi slide presentation; "bullets"
    Then "layout_index" occurs in result or "recommended" occurs in result or "index" occurs in str representation of result in lowercase

  @candidate-python-pptx-advanced-tools-extended-f9a626bf28
  # Native: tests/test_pptx_advanced_tools_extended.py::TestLayoutAnalysis::test_recommend_layout_table
  Scenario: Native check: recommend layout table [TestLayoutAnalysis]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx recommend layout using str representation of multi slide presentation; "table"
    Then "layout_index" occurs in result or "recommended" occurs in result

  @candidate-python-pptx-advanced-tools-extended-4c888492aa
  # Native: tests/test_pptx_advanced_tools_extended.py::TestAuditPlaceholders::test_audit_clean_presentation
  Scenario: Native check: audit clean presentation [TestAuditPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "clean.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "Clean Title"
    And path is prepared as temp dir under "clean.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "clean.pptx"
    Then the number of entries in result field "findings", defaulting to result field "placeholders", defaulting to [] equals 0 or result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-4b5d24e11f
  # Native: tests/test_pptx_advanced_tools_extended.py::TestAuditPlaceholders::test_audit_finds_placeholders
  Scenario: Native check: audit finds placeholders [TestAuditPlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "with_placeholders.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer Name> Project"
    And path is prepared as temp dir under "with_placeholders.pptx"
    When pptx advanced tools.tool pptx audit placeholders using str representation of temp dir under "with_placeholders.pptx"
    Then the number of entries in result field "findings", defaulting to result field "placeholders", defaulting to [] is at least 1 or "Customer" occurs in str representation of result

  @candidate-python-pptx-advanced-tools-extended-3d00e1150b
  # Native: tests/test_pptx_advanced_tools_extended.py::TestHiddenSlides::test_hide_slide
  Scenario: Native check: hide slide [TestHiddenSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "with_hidden.pptx"
    When pptx advanced tools.tool pptx hide slide using str representation of multi slide presentation; slide number 2; hidden true; output path str representation of temp dir under "with_hidden.pptx"
    Then result field "success" is true or result field "hidden" is true

  @candidate-python-pptx-advanced-tools-extended-644d9aba3b
  # Native: tests/test_pptx_advanced_tools_extended.py::TestHiddenSlides::test_get_hidden_slides
  Scenario: Native check: get hidden slides [TestHiddenSlides]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx get hidden slides using str representation of multi slide presentation
    Then result field "hidden_slides", defaulting to result field "slides", defaulting to [] has type list

  @candidate-python-pptx-advanced-tools-extended-7e0c39b72e
  # Native: tests/test_pptx_advanced_tools_extended.py::TestTextAutofit::test_set_autofit_shrink
  Scenario: Native check: set autofit shrink [TestTextAutofit]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "autofit.pptx"
    When pptx advanced tools.tool pptx set text autofit using str representation of multi slide presentation; slide number 1; shape identifier "title"; autofit type "shrink"; output path str representation of temp dir under "autofit.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-6ba7b1b1cb
  # Native: tests/test_pptx_advanced_tools_extended.py::TestReplaceText::test_replace_text_all_slides
  Scenario: Native check: replace text all slides [TestReplaceText]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "replace_source.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "replace_source.pptx"
    And output is prepared as temp dir under "replaced.pptx"
    When pptx advanced tools.tool pptx replace text using str representation of temp dir under "replace_source.pptx"; find text "<Customer>"; replace text "Contoso"; output path str representation of temp dir under "replaced.pptx"
    Then result field "count", defaulting to result field "replacements", defaulting to 0 is at least 3 or result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-434fbe614e
  # Native: tests/test_pptx_advanced_tools_extended.py::TestDuplicateSlide::test_duplicate_slide_after
  Scenario: Native check: duplicate slide after [TestDuplicateSlide]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "duplicated.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of multi slide presentation; slide number 2; position "after"; output path str representation of temp dir under "duplicated.pptx"
    Then result field "success" is true or result field "new_slide_number" is not null

  @candidate-python-pptx-advanced-tools-extended-a74bccb610
  # Native: tests/test_pptx_advanced_tools_extended.py::TestDuplicateSlide::test_duplicate_slide_end
  Scenario: Native check: duplicate slide end [TestDuplicateSlide]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "dup_end.pptx"
    When pptx advanced tools.tool pptx duplicate slide using str representation of multi slide presentation; slide number 1; position "end"; output path str representation of temp dir under "dup_end.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-e7e05f4898
  # Native: tests/test_pptx_advanced_tools_extended.py::TestReplacePlaceholders::test_replace_multiple_placeholders
  Scenario: Native check: replace multiple placeholders [TestReplacePlaceholders]
    Given Create an instance of PresentationAdvancedTools.
    And an isolated writable temporary directory
    And prs.save with temp dir under "multi_ph.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1
    And the result of prs.slides.add slide with the result of Presentation with no arguments slide layouts at 1 shapes title text is set to "<Customer Name> - <Project Name>"
    And path is prepared as temp dir under "multi_ph.pptx"
    And output is prepared as temp dir under "multi_replaced.pptx"
    When pptx advanced tools.tool pptx replace placeholders using str representation of temp dir under "multi_ph.pptx"; replacements {"<Customer Name>": "Contoso Corp", "<Project Name>": "Cloud Migration"}; output path str representation of temp dir under "multi_replaced.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-a7242114ab
  # Native: tests/test_pptx_advanced_tools_extended.py::TestCommentOperations::test_get_comments_empty
  Scenario: Native check: get comments empty [TestCommentOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx get comments using str representation of multi slide presentation
    Then result has type dict

  @candidate-python-pptx-advanced-tools-extended-385ddcb85e
  # Native: tests/test_pptx_advanced_tools_extended.py::TestErrorHandling::test_get_slide_invalid_number
  Scenario: Native check: get slide invalid number [TestErrorHandling]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx get slide using str representation of multi slide presentation; slide number 999
    Then "error" occurs in result or "Error" occurs in str representation of result

  @candidate-python-pptx-advanced-tools-extended-4f461f193f
  # Native: tests/test_pptx_advanced_tools_extended.py::TestErrorHandling::test_delete_invalid_slide
  Scenario: Native check: delete invalid slide [TestErrorHandling]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    When pptx advanced tools.tool pptx delete slide using str representation of multi slide presentation; slide number 999
    Then "error" occurs in result

  @candidate-python-pptx-advanced-tools-extended-8a5bd3b54f
  # Native: tests/test_pptx_advanced_tools_extended.py::TestNonExistentFile::test_list_slides_missing_file
  Scenario: Native check: list slides missing file [TestNonExistentFile]
    Given Create an instance of PresentationAdvancedTools.
    When pptx advanced tools.tool pptx list slides using "/nonexistent/file.pptx"
    Then "error" occurs in result

  @candidate-python-pptx-advanced-tools-extended-190ce8dfa3
  # Native: tests/test_pptx_advanced_tools_extended.py::TestAdvancedBulletOperations::test_add_bullet_with_level
  Scenario: Native check: add bullet with level [TestAdvancedBulletOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "indented.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of multi slide presentation; slide number 2; text "Sub-point item"; level 1; output path str representation of temp dir under "indented.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-e255895bfd
  # Native: tests/test_pptx_advanced_tools_extended.py::TestAdvancedBulletOperations::test_add_bullet_with_bold_label
  Scenario: Native check: add bullet with bold label [TestAdvancedBulletOperations]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output is prepared as temp dir under "bold_label.pptx"
    When pptx advanced tools.tool pptx add bullet using str representation of multi slide presentation; slide number 2; text "Some detail text"; bold label "Key Point"; output path str representation of temp dir under "bold_label.pptx"
    Then result field "success" is true

  @candidate-python-pptx-advanced-tools-extended-6ca35bb636
  # Native: tests/test_pptx_advanced_tools_extended.py::TestNotesWithAppend::test_append_notes
  Scenario: Native check: append notes [TestNotesWithAppend]
    Given Create an instance of PresentationAdvancedTools.
    And Create presentation with multiple slides.
    And an isolated writable temporary directory
    And output1 is prepared as temp dir under "notes1.pptx"
    When pptx advanced tools.tool pptx set notes using str representation of multi slide presentation; slide number 1; notes text "Initial notes"; output path str representation of temp dir under "notes1.pptx"
    And pptx advanced tools.tool pptx set notes using str representation of temp dir under "notes1.pptx"; slide number 1; notes text "\nAdditional notes"; append true; output path str representation of temp dir under "notes2.pptx"
    Then result field "success" is true
