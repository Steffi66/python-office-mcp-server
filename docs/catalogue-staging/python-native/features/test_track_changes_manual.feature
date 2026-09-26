@captured @python_candidate
Feature: track changes manual native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-track-changes-manual-2eaf569b22
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_create_sample_with_track_changes
  Scenario: Native check: create sample with track changes [TestManualVerification]
    Given an isolated writable temporary directory
    And doc.save with tmp path under "track_changes_manual_test.docx"
    And doc is prepared as the result of Document with no arguments
    And para1 is prepared as the result of doc.add paragraph with "This paragraph has an insertion: "
    And para2 is prepared as the result of doc.add paragraph with "This paragraph has a deletion: "
    And para3 is prepared as the result of doc.add paragraph with "Before replacement "
    And para4 is prepared as the result of doc.add paragraph with "Changes by different people: "
    And output path is prepared as tmp path under "track_changes_manual_test.docx"
    And doc2 is prepared as the result of Document with tmp path under "track_changes_manual_test.docx"
    When doc.add heading using "Track Changes Test Document"; 0
    And doc.add paragraph using "Open this in Word and check Review > Track Changes panel."
    And doc.add paragraph using ""
    And doc.add heading using "Test 1: Insertion Only"
    And doc.add paragraph using "This paragraph has an insertion: "
    Then the number of entries in the result of Document with tmp path under "track_changes_manual_test.docx" paragraphs exceeds 0

  @candidate-python-track-changes-manual-63b1c88c77
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_analyze_current_implementation
  Scenario: Native check: analyze current implementation [TestManualVerification]
    Given an isolated writable temporary directory
    And doc.save with tmp path under "analyze_structure.docx"
    And doc is prepared as the result of Document with no arguments
    And para is prepared as the result of doc.add paragraph with "Start "
    And output path is prepared as tmp path under "analyze_structure.docx"
    And root is prepared as the result of ET.fromstring with zf saved payload for "word/document.xml"
    And body is prepared as the result of ET.fromstring with zf saved payload for "word/document.xml" first match for text .//{{WORD NS}}body
    And paragraphs is prepared as the result of ET.fromstring with zf saved payload for "word/document.xml" first match for text .//{{WORD NS}}body matches for text {{WORD NS}}p
    When doc.add paragraph using "Start "
    And add tracked deletion using the result of doc.add paragraph with "Start "; "OLD"
    And add tracked insertion using the result of doc.add paragraph with "Start "; "NEW"
    And para.add run using " End"
    And zf.read using "word/document.xml"
    Then the resulting document or diagnostic output is available for manual inspection

  @candidate-python-track-changes-manual-5d62e67797
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_compare_with_word_generated
  Scenario: Native check: compare with word generated [TestManualVerification]
    Given the native compare with word generated inputs and isolated test state
    When the compare with word generated behavior is exercised with its prepared inputs
    Then the resulting document or diagnostic output is available for manual inspection

  @candidate-python-track-changes-manual-6b059e206a
  # Native: tests/test_track_changes_manual.py::TestToolIntegration::test_patch_with_track_changes_creates_changes
  Scenario: Native check: patch with track changes creates changes [TestToolIntegration]
    Given Create an instance of WordAdvancedTools.
    And an isolated writable temporary directory
    And doc.save with tmp path under "input.docx"
    And doc is prepared as the result of Document with no arguments
    And input path is prepared as tmp path under "input.docx"
    And output path is prepared as tmp path under "output.docx"
    When word advanced tools.tool word patch with track changes using file path str representation of tmp path under "input.docx"; replacements {"PLACEHOLDER": "REPLACED"}; author "Integration Test"; output path str representation of tmp path under "output.docx"
    Then result field "success" is non-empty or true
    And result field "total_changes" equals 1
    And "<w:ins " occurs in the result of zf.read('word/document.xml').decode with no arguments or "w:ins " occurs in the result of zf.read('word/document.xml').decode with no arguments or "<w:del " occurs in the result of zf.read('word/document.xml').decode with no arguments or "w:del " occurs in the result of zf.read('word/document.xml').decode with no arguments
