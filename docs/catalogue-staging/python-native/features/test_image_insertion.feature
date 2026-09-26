@captured @python_candidate
Feature: image insertion native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-image-insertion-cea23d58fc
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_at_end
  Scenario: Native check: insert png at end [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"
    And the result of Path with temp dir under "out.docx" exists is non-empty or true

  @candidate-python-image-insertion-2ef3964614
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_after_section
  Scenario: Native check: insert png after section [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image; target "after:Executive Summary"; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"
    And result field "location" equals "after:Executive Summary"

  @candidate-python-image-insertion-969f063aeb
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_section_not_found
  Scenario: Native check: insert png section not found [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image; target "after:Nonexistent Section"; output path str representation of temp dir under "out.docx"
    Then "error" occurs in result

  @candidate-python-image-insertion-f6d925ba7a
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_with_width
  Scenario: Native check: insert png with width [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image; width inches 3.0; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"

  @candidate-python-image-insertion-fa771edfd9
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_with_both_dims
  Scenario: Native check: insert png with both dims [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image; width inches 4.0; height inches 2.5; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"

  @candidate-python-image-insertion-242c4f9066
  # Native: tests/test_image_insertion.py::TestPngInsertionWord::test_insert_png_overwrites_input
  Scenario: Native check: insert png overwrites input [TestPngInsertionWord]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create a minimal 100x80 red PNG image.
    When tools.tool office image using file path str representation of sample docx; image path str representation of png image
    Then result field "status" equals "success"
    And result field "file" equals str representation of sample docx

  @candidate-python-image-insertion-2edbbbee72
  # Native: tests/test_image_insertion.py::TestPngInsertionExcel::test_insert_png_default_cell
  Scenario: Native check: insert png default cell [TestPngInsertionExcel]
    Given tools
    And Create an Excel workbook with two sheets.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.xlsx"
    When tools.tool office image using file path str representation of sample xlsx; image path str representation of png image; output path str representation of temp dir under "out.xlsx"
    Then result field "status" equals "success"
    And result field "cell" equals "A1"

  @candidate-python-image-insertion-373a77ae22
  # Native: tests/test_image_insertion.py::TestPngInsertionExcel::test_insert_png_specific_cell
  Scenario: Native check: insert png specific cell [TestPngInsertionExcel]
    Given tools
    And Create an Excel workbook with two sheets.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.xlsx"
    When tools.tool office image using file path str representation of sample xlsx; image path str representation of png image; target "C5"; output path str representation of temp dir under "out.xlsx"
    Then result field "status" equals "success"
    And result field "cell" equals "C5"

  @candidate-python-image-insertion-0d08459161
  # Native: tests/test_image_insertion.py::TestPngInsertionExcel::test_insert_png_specific_sheet
  Scenario: Native check: insert png specific sheet [TestPngInsertionExcel]
    Given tools
    And Create an Excel workbook with two sheets.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.xlsx"
    When tools.tool office image using file path str representation of sample xlsx; image path str representation of png image; target "Charts!B3"; output path str representation of temp dir under "out.xlsx"
    Then result field "status" equals "success"
    And result field "sheet" equals "Charts"
    And result field "cell" equals "B3"

  @candidate-python-image-insertion-2389084ace
  # Native: tests/test_image_insertion.py::TestPngInsertionExcel::test_insert_png_with_dimensions
  Scenario: Native check: insert png with dimensions [TestPngInsertionExcel]
    Given tools
    And Create an Excel workbook with two sheets.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.xlsx"
    When tools.tool office image using file path str representation of sample xlsx; image path str representation of png image; target "A1"; width inches 2.0; height inches 1.5; output path str representation of temp dir under "out.xlsx"
    Then result field "status" equals "success"

  @candidate-python-image-insertion-4a19d4f1ba
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_first_slide
  Scenario: Native check: insert png first slide [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"
    And result field "slide" equals 1

  @candidate-python-image-insertion-53ab36cc00
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_specific_slide
  Scenario: Native check: insert png specific slide [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:2"; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"
    And result field "slide" equals 2

  @candidate-python-image-insertion-07df8bedc1
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_invalid_slide
  Scenario: Native check: insert png invalid slide [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:99"; output path str representation of temp dir under "out.pptx"
    Then "error" occurs in result

  @candidate-python-image-insertion-c3adb62c41
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_invalid_slide_format
  Scenario: Native check: insert png invalid slide format [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:abc"; output path str representation of temp dir under "out.pptx"
    Then "error" occurs in result

  @candidate-python-image-insertion-b18f47f6de
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_with_width_only
  Scenario: Native check: insert png with width only [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:1"; width inches 5.0; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"

  @candidate-python-image-insertion-0cacbf26fa
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_with_height_only
  Scenario: Native check: insert png with height only [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:1"; height inches 3.0; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"

  @candidate-python-image-insertion-43d78b1705
  # Native: tests/test_image_insertion.py::TestPngInsertionPptx::test_insert_png_centered
  Scenario: Native check: insert png centered [TestPngInsertionPptx]
    Given tools
    And Create a two-slide presentation.
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of png image; target "slide:1"; width inches 3.0; height inches 2.0; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"
    And result field "position", defaulting to {} is non-empty or true

  @candidate-python-image-insertion-ca11008ded
  # Native: tests/test_image_insertion.py::TestSvgInsertion::test_svg_succeeds_word
  Scenario: Native check: svg succeeds word [TestSvgInsertion]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create an SVG with explicit width/height attributes (px).
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of svg image with dims; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"
    And the result of Path with temp dir under "out.docx" exists is non-empty or true
    And n for each n in z ZIP member names where n ends with ".svg" is non-empty or true

  @candidate-python-image-insertion-79cde171ab
  # Native: tests/test_image_insertion.py::TestSvgInsertion::test_svg_word_with_target
  Scenario: Native check: svg word with target [TestSvgInsertion]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And Create an SVG with explicit width/height attributes (px).
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.docx"
    When tools.tool office image using file path str representation of sample docx; image path str representation of svg image with dims; target "after:Executive Summary"; width inches 3.0; output path str representation of temp dir under "out.docx"
    Then result field "status" equals "success"
    And result field "location" equals "after:Executive Summary"

  @candidate-python-image-insertion-38eac0461b
  # Native: tests/test_image_insertion.py::TestSvgInsertion::test_svg_rejected_excel
  Scenario: Native check: svg rejected excel [TestSvgInsertion]
    Given tools
    And Create an Excel workbook with two sheets.
    And Create an SVG with explicit width/height attributes (px).
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.xlsx"
    When tools.tool office image using file path str representation of sample xlsx; image path str representation of svg image with dims; output path str representation of temp dir under "out.xlsx"
    Then "error" occurs in result
    And "not supported" occurs in result at "error" in lowercase

  @candidate-python-image-insertion-048a83cda9
  # Native: tests/test_image_insertion.py::TestSvgInsertion::test_svg_succeeds_pptx
  Scenario: Native check: svg succeeds pptx [TestSvgInsertion]
    Given tools
    And Create a two-slide presentation.
    And Create an SVG with explicit width/height attributes (px).
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of svg image with dims; target "slide:1"; width inches 2.0; height inches 1.0; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"
    And the result of Path with temp dir under "out.pptx" exists is non-empty or true
    And n for each n in z ZIP member names where n ends with ".svg" is non-empty or true

  @candidate-python-image-insertion-d3f78f5fda
  # Native: tests/test_image_insertion.py::TestSvgInsertion::test_svg_pptx_auto_dimensions
  Scenario: Native check: svg pptx auto dimensions [TestSvgInsertion]
    Given tools
    And Create a two-slide presentation.
    And Create an SVG with explicit width/height attributes (px).
    And an isolated writable temporary directory
    And out is prepared as temp dir under "out.pptx"
    When tools.tool office image using file path str representation of sample pptx; image path str representation of svg image with dims; target "slide:2"; output path str representation of temp dir under "out.pptx"
    Then result field "status" equals "success"
    And result field "position", defaulting to {} field "width_inches", defaulting to 0 exceeds 0

  @candidate-python-image-insertion-7dfd80f8f2
  # Native: tests/test_image_insertion.py::TestImageDimensionsPng::test_png_dimensions_96dpi
  Scenario: Native check: png dimensions 96dpi [TestImageDimensionsPng]
    Given tools
    And Create a minimal 100x80 red PNG image.
    When tools. get image dimensions using str representation of png image
    Then the result of abs with w minus 100 under 96 is below 0.01
    And the result of abs with h minus 80 under 96 is below 0.01

  @candidate-python-image-insertion-8e468203ff
  # Native: tests/test_image_insertion.py::TestImageDimensionsPng::test_png_dimensions_300dpi
  Scenario: Native check: png dimensions 300dpi [TestImageDimensionsPng]
    Given tools
    And Create a 300 DPI PNG to test DPI-aware dimension calculation.
    When tools. get image dimensions using str representation of png image hires
    Then the result of abs with w minus 1.0 is below 0.01
    And the result of abs with h minus 1.0 is below 0.01

  @candidate-python-image-insertion-63dbc5a8c2
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_with_pixel_dims
  Scenario: Native check: svg with pixel dims [TestImageDimensionsSvg]
    Given tools
    And Create an SVG with explicit width/height attributes (px).
    When tools. get image dimensions using str representation of svg image with dims
    Then the result of abs with w minus 2.0 is below 0.01
    And the result of abs with h minus 1.0 is below 0.01

  @candidate-python-image-insertion-736f40499e
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_viewbox_fallback
  Scenario: Native check: svg viewbox fallback [TestImageDimensionsSvg]
    Given tools
    And Create an SVG with viewBox but no width/height attributes.
    When tools. get image dimensions using str representation of svg image viewbox only
    Then the result of abs with w minus 5.0 is below 0.01
    And the result of abs with h minus 2.5 is below 0.01

  @candidate-python-image-insertion-fbf9f86b27
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_inches_unit
  Scenario: Native check: svg inches unit [TestImageDimensionsSvg]
    Given tools
    And Create an SVG with dimensions in inches.
    When tools. get image dimensions using str representation of svg image inches
    Then the result of abs with w minus 3.0 is below 0.01
    And the result of abs with h minus 2.0 is below 0.01

  @candidate-python-image-insertion-674e105272
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_mm_unit
  Scenario: Native check: svg mm unit [TestImageDimensionsSvg]
    Given tools
    And Create an SVG with dimensions in millimetres.
    When tools. get image dimensions using str representation of svg image mm
    Then the result of abs with w minus 2.0 is below 0.01
    And the result of abs with h minus 1.0 is below 0.01

  @candidate-python-image-insertion-1d5bf1a499
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_percent_falls_back_to_viewbox
  Scenario: Native check: svg percent falls back to viewbox [TestImageDimensionsSvg]
    Given tools
    And Create an SVG with percentage dimensions (unresolvable).
    When tools. get image dimensions using str representation of svg image percent
    Then the result of abs with w minus 10.0 is below 0.01
    And the result of abs with h minus 5.0 is below 0.01

  @candidate-python-image-insertion-af02659066
  # Native: tests/test_image_insertion.py::TestImageDimensionsSvg::test_svg_no_dims_no_viewbox
  Scenario: Native check: svg no dims no viewbox [TestImageDimensionsSvg]
    Given tools
    And an isolated writable temporary directory
    And path.write text with "<svg xmlns=\"http://www.w3.org/2000/svg\"><circle r=\"10\"/></svg>"
    And svg is prepared as "<svg xmlns=\"http://www.w3.org/2000/svg\"><circle r=\"10\"/></svg>"
    And path is prepared as temp dir under "bare.svg"
    When tools. get image dimensions using str representation of temp dir under "bare.svg"
    Then the result of abs with w minus 6.0 is below 0.01
    And the result of abs with h minus 4.0 is below 0.01

  @candidate-python-image-insertion-0e62d59fef
  # Native: tests/test_image_insertion.py::TestImageInsertionErrors::test_image_file_not_found
  Scenario: Native check: image file not found [TestImageInsertionErrors]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And an isolated writable temporary directory
    When tools.tool office image using file path str representation of sample docx; image path "/nonexistent/missing.png"
    Then "error" occurs in result
    And "not found" occurs in result at "error" in lowercase

  @candidate-python-image-insertion-576feb3397
  # Native: tests/test_image_insertion.py::TestImageInsertionErrors::test_unsupported_image_format
  Scenario: Native check: unsupported image format [TestImageInsertionErrors]
    Given tools
    And Create a Word document with sections for targeted insertion.
    And an isolated writable temporary directory
    And PILImage.new('RGB', (10, 10)).save with temp dir under "image.bmp"
    And bmp.write bytes with "b'\\x00'" repeated by 100
    And bmp is prepared as temp dir under "image.bmp"
    When tools.tool office image using file path str representation of sample docx; image path str representation of temp dir under "image.bmp"
    Then "error" occurs in result
    And "unsupported" occurs in result at "error" in lowercase

  @candidate-python-image-insertion-3666e07c5b
  # Native: tests/test_image_insertion.py::TestImageInsertionErrors::test_unsupported_document_format
  Scenario: Native check: unsupported document format [TestImageInsertionErrors]
    Given tools
    And Create a minimal 100x80 red PNG image.
    And an isolated writable temporary directory
    And txt.write text with "hello"
    And txt is prepared as temp dir under "notes.txt"
    When tools.tool office image using file path str representation of temp dir under "notes.txt"; image path str representation of png image
    Then "error" occurs in result

  @candidate-python-image-insertion-3fd7f2b3f5
  # Native: tests/test_image_insertion.py::TestImageInsertionErrors::test_document_file_not_found
  Scenario: Native check: document file not found [TestImageInsertionErrors]
    Given tools
    And Create a minimal 100x80 red PNG image.
    When tools.tool office image using file path "/nonexistent/doc.docx"; image path str representation of png image
    Then "error" occurs in result
