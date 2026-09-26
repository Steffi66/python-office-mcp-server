@captured @python_candidate
Feature: Native Python slide transfer responses and saved-deck observations

  Five native definitions use generated source and receiver decks in temporary directories.
  Candidate descriptions need central reconciliation and grant no execution credit.

  Background:
    Given the pptx_slide_transfer_tools fixture returns PresentationSlideTransferTools
    And an isolated writable temporary directory

  @candidate-python-pptx-slide-transfer-tools-7d96a9f151
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_copies_slide_assets_and_reuses_default_layout_master
  Scenario: Default import reports layout reuse and adds a saved picture-bearing slide
    Given tiny.png is written from the test's embedded one-pixel PNG bytes
    And a saved source has one slide using slide_layouts[1], title "Imported Title" and body "Imported body"
    And its picture is placed at left 1 inch, top 1.5 inches, width 1.5 inches and height 1.5 inches
    And a saved receiver has one slide using slide_layouts[1], title "Target One" and body "Body for Target One"
    And receiver ZIP counts for prefixes "ppt/slideMasters/slideMaster" and "ppt/media/" are captured before import
    When tool_pptx_import_slide imports source slide 1 into the receiver with position arguments omitted
    Then success is true, new_slide_number equals 2, master_copied is false and layout_reused is true
    When the receiver is reopened with Presentation
    Then it has exactly two slides and slide 2 title equals "Imported Title"
    And at least one shape on slide 2 has shape_type equal to 13
    When receiver ZIP members are counted again with the same prefixes
    Then the master-prefix count equals the captured pre-import count
    And the media-prefix count is at least the captured pre-import count plus 1

  @candidate-python-pptx-slide-transfer-tools-2a2bc4e9c9
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_after_specific_position_preserves_order
  Scenario: Explicit after-position import yields the expected saved title sequence
    Given tiny.png is written from the test's embedded one-pixel PNG bytes
    And a saved source has one slide using slide_layouts[1], title "Imported Title" and body "Imported body"
    And its picture is placed at left 1 inch, top 1.5 inches, width 1.5 inches and height 1.5 inches
    And a saved receiver has slide_layouts[1] slides titled "First" and "Second", each with body "Body for " followed by its title
    When tool_pptx_import_slide imports source slide 1 with position "after" and after_slide_number 1
    Then success is true and new_slide_number equals 2
    When the receiver is reopened with Presentation
    Then all slide titles in order equal ["First", "Imported Title", "Second"]

  @candidate-python-pptx-slide-transfer-tools-8e7e42b10e
  # Native: tests/test_pptx_slide_transfer_tools.py::test_importing_same_source_slide_twice_does_not_duplicate_default_master
  Scenario: Two default imports produce three saved slides and one counted master member
    Given tiny.png is written from the test's embedded one-pixel PNG bytes
    And a saved source has one slide using slide_layouts[1], title "Imported Title" and body "Imported body"
    And its picture is placed at left 1 inch, top 1.5 inches, width 1.5 inches and height 1.5 inches
    And a saved receiver has one slide using slide_layouts[1], title "Seed" and body "Body for Seed"
    When tool_pptx_import_slide imports source slide 1 into that receiver with position arguments omitted
    And tool_pptx_import_slide imports the same source slide 1 into the same receiver a second time
    Then both results have success true
    When the receiver is reopened with Presentation
    Then it has exactly three slides
    And its ZIP has exactly one member whose name starts with "ppt/slideMasters/slideMaster"

  @candidate-python-pptx-slide-transfer-tools-e13dc9ed52
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_rejects_invalid_source_slide_number
  Scenario: Importing source slide 2 from a one-slide deck returns a count-bearing error
    Given a saved one-slide source using slide_layouts[1], title "Only" and body "Body for Only"
    And a saved one-slide receiver using slide_layouts[1], title "Target" and body "Body for Target"
    When tool_pptx_import_slide requests source slide 2 into that receiver
    Then the result contains error and its text includes "Presentation has 1 slides"

  @candidate-python-pptx-slide-transfer-tools-c74fe18267
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_requires_after_slide_number_for_after_mode
  Scenario: After mode with no after_slide_number returns the exact error and zero applied changes
    Given a saved one-slide source using slide_layouts[1], title "Source" and body "Body for Source"
    And a saved one-slide receiver using slide_layouts[1], title "Target" and body "Body for Target"
    When tool_pptx_import_slide requests source slide 1 with position "after" and no after_slide_number
    Then error equals "after_slide_number is required when position='after'."
    And changes_applied equals 0
