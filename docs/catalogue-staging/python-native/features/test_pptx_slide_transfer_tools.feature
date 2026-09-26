@captured @python_candidate
Feature: pptx slide transfer tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-pptx-slide-transfer-tools-7d96a9f151
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_copies_slide_assets_and_reuses_default_layout_master
  Scenario: Native check: import slide copies slide assets and reuses default layout master
    Given Create an instance of PresentationSlideTransferTools.
    And an isolated writable temporary directory
    And image path.write bytes with MINIMAL PNG
    And image path is prepared as temp dir under "tiny.png"
    And source is prepared as temp dir under "source.pptx"
    And target is prepared as temp dir under "target.pptx"
    And masters before is prepared as the result of count package members with temp dir under "target.pptx"; "ppt/slideMasters/slideMaster"
    And media before is prepared as the result of count package members with temp dir under "target.pptx"; "ppt/media/"
    When pptx slide transfer tools.tool pptx import slide using str representation of temp dir under "source.pptx"; 1; str representation of temp dir under "target.pptx"
    Then result at "success" is true
    And result at "new_slide_number" equals 2
    And result at "master_copied" is false
    And result at "layout_reused" is true
    And the number of entries in the result of Presentation with str representation of temp dir under "target.pptx" slides equals 2
    And the result of Presentation with str representation of temp dir under "target.pptx" slides at 1 shapes title text equals "Imported Title"
    And at least one item satisfies shape attribute "shape_type" equals 13 for each shape in the result of Presentation with str representation of temp dir under "target.pptx" slides at 1 shapes
    And the result of count package members with temp dir under "target.pptx"; "ppt/slideMasters/slideMaster" equals the result of count package members with temp dir under "target.pptx"; "ppt/slideMasters/slideMaster"
    And the result of count package members with temp dir under "target.pptx"; "ppt/media/" is at least the result of count package members with temp dir under "target.pptx"; "ppt/media/" joined with 1

  @candidate-python-pptx-slide-transfer-tools-2a2bc4e9c9
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_after_specific_position_preserves_order
  Scenario: Native check: import slide after specific position preserves order
    Given Create an instance of PresentationSlideTransferTools.
    And an isolated writable temporary directory
    And image path.write bytes with MINIMAL PNG
    And image path is prepared as temp dir under "tiny.png"
    And source is prepared as temp dir under "source_order.pptx"
    And target is prepared as temp dir under "target_order.pptx"
    When pptx slide transfer tools.tool pptx import slide using str representation of temp dir under "source_order.pptx"; 1; str representation of temp dir under "target_order.pptx"; position "after"; after slide number 1
    Then result at "success" is true
    And result at "new_slide_number" equals 2
    And slide shapes title text for each slide in the result of Presentation with str representation of temp dir under "target_order.pptx" slides equals ["First", "Imported Title", "Second"]

  @candidate-python-pptx-slide-transfer-tools-8e7e42b10e
  # Native: tests/test_pptx_slide_transfer_tools.py::test_importing_same_source_slide_twice_does_not_duplicate_default_master
  Scenario: Native check: importing same source slide twice does not duplicate default master
    Given Create an instance of PresentationSlideTransferTools.
    And an isolated writable temporary directory
    And image path.write bytes with MINIMAL PNG
    And image path is prepared as temp dir under "tiny.png"
    And source is prepared as temp dir under "source_twice.pptx"
    And target is prepared as temp dir under "target_twice.pptx"
    When pptx slide transfer tools.tool pptx import slide using str representation of temp dir under "source_twice.pptx"; 1; str representation of temp dir under "target_twice.pptx"
    Then result1 at "success" is true
    And result2 at "success" is true
    And the number of entries in the result of Presentation with str representation of temp dir under "target_twice.pptx" slides equals 3
    And the result of count package members with temp dir under "target_twice.pptx"; "ppt/slideMasters/slideMaster" equals 1

  @candidate-python-pptx-slide-transfer-tools-e13dc9ed52
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_rejects_invalid_source_slide_number
  Scenario: Native check: import slide rejects invalid source slide number
    Given Create an instance of PresentationSlideTransferTools.
    And an isolated writable temporary directory
    And source is prepared as temp dir under "source_invalid.pptx"
    And target is prepared as temp dir under "target_invalid.pptx"
    When pptx slide transfer tools.tool pptx import slide using str representation of temp dir under "source_invalid.pptx"; 2; str representation of temp dir under "target_invalid.pptx"
    Then "error" occurs in result
    And "Presentation has 1 slides" occurs in result at "error"

  @candidate-python-pptx-slide-transfer-tools-c74fe18267
  # Native: tests/test_pptx_slide_transfer_tools.py::test_import_slide_requires_after_slide_number_for_after_mode
  Scenario: Native check: import slide requires after slide number for after mode
    Given Create an instance of PresentationSlideTransferTools.
    And an isolated writable temporary directory
    And source is prepared as temp dir under "source_after.pptx"
    And target is prepared as temp dir under "target_after.pptx"
    When pptx slide transfer tools.tool pptx import slide using str representation of temp dir under "source_after.pptx"; 1; str representation of temp dir under "target_after.pptx"; position "after"
    Then result at "error" equals "after_slide_number is required when position='after'."
    And result at "changes_applied" equals 0
