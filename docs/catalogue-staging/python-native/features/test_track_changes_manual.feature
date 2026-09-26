@captured @python_candidate
Feature: track changes manual native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-track-changes-manual-2eaf569b22
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_create_sample_with_track_changes
  Scenario: Native check: create sample with track changes [TestManualVerification]
    Given A temporary output directory is available.
    And The tracked-change helper functions can add insertion and deletion markup to python-docx paragraphs.
    When The test builds a DOCX with headings plus four review scenarios: insertion, deletion, replacement, and multiple authors.
    And It saves the document as track_changes_manual_test.docx in the temporary directory and prints instructions for opening it in Microsoft Word.
    And It reopens the saved file with python-docx for a basic sanity check.
    Then The saved DOCX can be reopened successfully.
    And The reopened document contains at least one paragraph.

  @candidate-python-track-changes-manual-63b1c88c77
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_analyze_current_implementation
  Scenario: Native check: analyze current implementation [TestManualVerification]
    Given A temporary output directory is available.
    When The test creates a DOCX paragraph containing a tracked deletion followed by a tracked insertion and saves it as analyze_structure.docx.
    And It opens the DOCX as a ZIP archive, reads word/document.xml, parses the XML, and prints any detected w:ins and w:del structure for non-empty paragraphs.
    Then The saved DOCX must be readable as a ZIP archive.
    And word/document.xml must parse successfully as XML.

  @candidate-python-track-changes-manual-5d62e67797
  # Native: tests/test_track_changes_manual.py::TestManualVerification::test_compare_with_word_generated
  Scenario: Native check: compare with word generated [TestManualVerification]
    Given The test is explicitly manual/documentation-oriented and cites OOXML insertion and deletion structure from ISO/IEC 29500-1 in its docstring.
    And Its printed example hard-codes the replacement of "OLD" with "NEW", author "Author", and timestamp "2026-01-20T10:00:00Z".
    When Print a separator banner made from "=" * 60.
    And Print the heading "EXPECTED XML STRUCTURE (per OOXML spec)".
    And Print a multiline <w:p> example where <w:del> and <w:ins> are sibling paragraph-level elements around OLD and NEW.
    And Print six key points covering sibling placement, order, w:delText versus w:t, unique w:id values, and ISO 8601 date format.
    And Print the closing separator banner.
    Then There are no automated assertions.
    And The observable result is console output describing the expected OOXML structure and the six stated constraints.

  @candidate-python-track-changes-manual-6b059e206a
  # Native: tests/test_track_changes_manual.py::TestToolIntegration::test_patch_with_track_changes_creates_changes
  Scenario: Native check: patch with track changes creates changes [TestToolIntegration]
    Given The word_advanced_tools fixture must expose tool_word_patch_with_track_changes.
    And A temporary output directory is available.
    When The test creates an input DOCX containing the text Hello PLACEHOLDER world.
    And It calls tool_word_patch_with_track_changes to replace PLACEHOLDER with REPLACED and writes output.docx.
    And It then reads word/document.xml from the output package and searches the XML text for track-change tags.
    Then The tool reports success.
    And The tool reports exactly one total change.
    And The output package XML contains at least one w:ins or w:del element marker.
