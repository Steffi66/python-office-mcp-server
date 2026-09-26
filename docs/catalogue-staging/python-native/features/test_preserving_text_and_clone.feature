@captured @python_candidate
Feature: preserving text and clone native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-preserving-text-and-clone-a58e306927
  # Native: tests/test_preserving_text_and_clone.py::test_word_split_span_preserves_boundary_fonts_and_revisions
  Scenario: Native check: word split span preserves boundary fonts and revisions
    Given an isolated writable temporary directory
    And doc.save with tmp path under "word.docx"
    And path is prepared as tmp path under "word.docx"
    And doc is prepared as the result of Document with no arguments
    And the result of p.add run with "prefix <Cus" bold is set to true
    And the result of p.add run with "tomer> suffix" italic is set to true
    When OfficeServer().tool office patch using str representation of tmp path under "word.docx"; [{"target": "<Customer>", "value": "Acme"}]
    And OfficeServer().tool word accept all changes using str representation of tmp path under "word.docx"
    Then result at "changes_applied" equals 1
    And the result of get text with track changes with p equals "prefix Acme suffix"
    And p runs at 0 text equals "prefix " and p runs at 0 bold
    And p runs at -1 text equals " suffix" and p runs at -1 italic
    And the result of ''.join with n text or "" for each n in the result of deleted[0].iter with the result of qn with "w:delText" equals "<Customer>"
    And the number of entries in p p matches for the result of qn with "w:del" at 0 matches for the result of qn with "w:r" equals 2
    And "prefix Acme suffix" occurs in p text for each p in the result of Document with tmp path under "word.docx" paragraphs

  @candidate-python-preserving-text-and-clone-ee17cf0d07
  # Native: tests/test_preserving_text_and_clone.py::test_word_span_cannot_cross_field_barrier
  Scenario: Native check: word span cannot cross field barrier
    Given an isolated writable temporary directory
    And doc.save with tmp path under "word.docx"
    And path is prepared as tmp path under "word.docx"
    And doc is prepared as the result of Document with no arguments
    And p is prepared as the result of doc.add paragraph with no arguments
    And before is prepared as saved bytes of tmp path under "word.docx"
    When OfficeServer().tool office patch using str representation of tmp path under "word.docx"; [{"target": "<Customer>", "value": "Acme"}]; mode "strict"
    Then result at "changes_applied" equals 0
    And saved bytes of tmp path under "word.docx" equals saved bytes of tmp path under "word.docx"

  @candidate-python-preserving-text-and-clone-fbd36c3e12
  # Native: tests/test_preserving_text_and_clone.py::test_slide_split_run_replacement_preserves_properties
  Scenario: Native check: slide split run replacement preserves properties
    Given an isolated writable temporary directory
    And prs.save with tmp path under "deck.pptx"
    And path is prepared as tmp path under "deck.pptx"
    And prs is prepared as the result of Presentation with no arguments
    When OfficeServer().tool office patch using str representation of tmp path under "deck.pptx"; [{"target": "<Customer>", "value": "Acme"}]
    Then result at "changes_applied" equals 1
    And p text equals "pre Acme post Acme"
    And p runs at 0 font bold and p runs at -1 font italic

  @candidate-python-preserving-text-and-clone-eda3af4e39
  # Native: tests/test_preserving_text_and_clone.py::test_duplicate_chart_has_independent_workbook_and_chart_part
  Scenario: Native check: duplicate chart has independent workbook and chart part
    Given an isolated writable temporary directory
    And prs.save with tmp path under "chart.pptx"
    And path is prepared as tmp path under "chart.pptx"
    And slide is prepared as the result of prs.slides.add slide with prs slide layouts at 6
    And data is prepared as the result of CategoryChartData with no arguments
    And the result of CategoryChartData with no arguments categories is set to ["A", "B"]
    When OfficeServer().tool pptx duplicate slide using str representation of tmp path under "chart.pptx"; 1
    Then result at "success" is non-empty or true
    And original part partname differs from clone part partname
    And original part chart workbook xlsx part partname differs from clone part chart workbook xlsx part partname
    And list representation of prs slides at 0 shapes at 0 chart series at 0 values equals [1, 2]
    And list representation of prs slides at 1 shapes at 0 chart series at 0 values equals [9, 8]

  @candidate-python-preserving-text-and-clone-f60f9a0596
  # Native: tests/test_preserving_text_and_clone.py::test_import_existing_notes_is_explicit_and_donor_unchanged
  Scenario: Native check: import existing notes is explicit and donor unchanged
    Given an isolated writable temporary directory
    And donor.save with source
    And receiver.save with target
    And donor is prepared as the result of Presentation with no arguments
    And slide is prepared as the result of donor.slides.add slide with the result of Presentation with no arguments slide layouts at 0
    And the result of donor.slides.add slide with the result of Presentation with no arguments slide layouts at 0 shapes title text is set to "Donor"
    And the result of donor.slides.add slide with the result of Presentation with no arguments slide layouts at 0 notes slide notes text frame text is set to "Private note"
    And receiver is prepared as the result of Presentation with no arguments
    And before is prepared as saved bytes of source
    When OfficeServer().tool pptx import slide using str representation of source; 1; str representation of target; include notes true
    Then result at "success" is non-empty or true
    And saved bytes of source equals saved bytes of source
    And "Private note" occurs in the result of Presentation with target slides at -1 notes slide notes text frame text
