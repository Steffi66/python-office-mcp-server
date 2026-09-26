@captured @python_candidate
Feature: pptx tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-pptx-tools-26657b7a42
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_title_slide_detection_h1
  Scenario: Native check: title slide detection h1 [TestAnalyzeNodesForLayouts]
    Given result is prepared as the result of analyze markdown for layouts with "# Main Title\n\nContent"
    When analyze markdown for layouts using "# Main Title\n\nContent"
    Then the result of analyze markdown for layouts with "# Main Title\n\nContent" at "has_title_slide" is true

  @candidate-python-pptx-tools-cf679097c2
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_title_slide_detection_no_h1
  Scenario: Native check: title slide detection no h1 [TestAnalyzeNodesForLayouts]
    Given result is prepared as the result of analyze markdown for layouts with "## Section Only\n\nContent"
    When analyze markdown for layouts using "## Section Only\n\nContent"
    Then the result of analyze markdown for layouts with "## Section Only\n\nContent" at "has_title_slide" is false

  @candidate-python-pptx-tools-f2b3840005
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_detects_content_slides
  Scenario: Native check: detects content slides [TestAnalyzeNodesForLayouts]
    Given md is prepared as "# Title\n\n## First Section\n- bullet 1\n- bullet 2\n\n## Second Section\n- bullet 3\n"
    And result is prepared as the result of analyze markdown for layouts with "# Title\n\n## First Section\n- bullet 1\n- bullet 2\n\n## Second Section\n- bullet 3\n"
    When analyze markdown for layouts using "# Title\n\n## First Section\n- bullet 1\n- bullet 2\n\n## Second Section\n- bullet 3\n"
    Then the number of entries in the result of analyze markdown for layouts with "# Title\n\n## First Section\n- bullet 1\n- bullet 2\n\n## Second Section\n- bullet 3\n" at "slides" is at least 2

  @candidate-python-pptx-tools-35b9736b18
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_detects_tables
  Scenario: Native check: detects tables [TestAnalyzeNodesForLayouts]
    Given md is prepared as "# Title\n\n## Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    And result is prepared as the result of analyze markdown for layouts with "# Title\n\n## Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    And table slides is prepared as s for each s in the result of analyze markdown for layouts with "# Title\n\n## Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n" at "slides" where s field "has_table"
    When analyze markdown for layouts using "# Title\n\n## Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    And s.get using "has_table"
    Then the number of entries in s for each s in the result of analyze markdown for layouts with "# Title\n\n## Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n" at "slides" where s field "has_table" is at least 1

  @candidate-python-pptx-tools-c47de35ab6
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_detects_bullets
  Scenario: Native check: detects bullets [TestAnalyzeNodesForLayouts]
    Given md is prepared as "# Title\n\n## Points\n- Point 1\n- Point 2\n- Point 3\n"
    And result is prepared as the result of analyze markdown for layouts with "# Title\n\n## Points\n- Point 1\n- Point 2\n- Point 3\n"
    And bullet slides is prepared as s for each s in the result of analyze markdown for layouts with "# Title\n\n## Points\n- Point 1\n- Point 2\n- Point 3\n" at "slides" where s field "has_bullets"
    When analyze markdown for layouts using "# Title\n\n## Points\n- Point 1\n- Point 2\n- Point 3\n"
    And s.get using "has_bullets"
    Then the number of entries in s for each s in the result of analyze markdown for layouts with "# Title\n\n## Points\n- Point 1\n- Point 2\n- Point 3\n" at "slides" where s field "has_bullets" is at least 1

  @candidate-python-pptx-tools-646f8ad617
  # Native: tests/test_pptx_tools.py::TestAnalyzeNodesForLayouts::test_horizontal_rule_creates_boundary
  Scenario: Native check: horizontal rule creates boundary [TestAnalyzeNodesForLayouts]
    Given md is prepared as "# Title\n\n---\n\n## Next Section\n"
    And result is prepared as the result of analyze markdown for layouts with "# Title\n\n---\n\n## Next Section\n"
    When analyze markdown for layouts using "# Title\n\n---\n\n## Next Section\n"
    Then the result of analyze markdown for layouts with "# Title\n\n---\n\n## Next Section\n" at "has_title_slide" is true

  @candidate-python-pptx-tools-6a19add302
  # Native: tests/test_pptx_tools.py::TestSetThemeFonts::test_sets_title_font
  Scenario: Native check: sets title font [TestSetThemeFonts]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "themed.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "themed.pptx"
    When set theme fonts using the result of Presentation with no arguments; "Arial Black"; "Arial"
    Then temp dir under "themed.pptx" exists is non-empty or true

  @candidate-python-pptx-tools-dc6160cd1c
  # Native: tests/test_pptx_tools.py::TestSetThemeFonts::test_sets_body_font
  Scenario: Native check: sets body font [TestSetThemeFonts]
    Given an isolated writable temporary directory
    And prs.save with temp dir under "themed2.pptx"
    And prs is prepared as the result of Presentation with no arguments
    And path is prepared as temp dir under "themed2.pptx"
    When set theme fonts using the result of Presentation with no arguments; "Impact"; "Calibri"
    Then temp dir under "themed2.pptx" exists is non-empty or true

  @candidate-python-pptx-tools-8ff34d8496
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_creates_presentation
  Scenario: Native check: creates presentation [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Test Presentation\n\n## Overview\n- Point 1\n- Point 2\n"
    And output is prepared as temp dir under "output.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "output.pptx"; "# Test Presentation\n\n## Overview\n- Point 1\n- Point 2\n"
    Then result field "success" is true
    And temp dir under "output.pptx" exists is non-empty or true

  @candidate-python-pptx-tools-4c922d1fdb
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_creates_from_markdown_file
  Scenario: Native check: creates from markdown file [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md file.write text with "# File Deck\n\n## Intro\n- Point one\n"
    And md file is prepared as temp dir under "deck.md"
    And output is prepared as temp dir under "from_file.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "from_file.pptx"; markdown file str representation of temp dir under "deck.md"
    Then result field "success" is true
    And temp dir under "from_file.pptx" exists is non-empty or true

  @candidate-python-pptx-tools-6f04665419
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_creates_title_slide
  Scenario: Native check: creates title slide [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# My Title"
    And output is prepared as temp dir under "title.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "title.pptx"; "# My Title"
    Then result field "success" is true
    And the number of entries in the result of Presentation with temp dir under "title.pptx" slides is at least 1
    And the result of Presentation with temp dir under "title.pptx" slides at 0 shapes title is not null

  @candidate-python-pptx-tools-b9ebfff6ca
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_creates_content_slides
  Scenario: Native check: creates content slides [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n\n## Section 1\n- bullet\n\n## Section 2\n- bullet\n"
    And output is prepared as temp dir under "content.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "content.pptx"; "# Title\n\n## Section 1\n- bullet\n\n## Section 2\n- bullet\n"
    Then result field "success" is true
    And the number of entries in the result of Presentation with temp dir under "content.pptx" slides is at least 3

  @candidate-python-pptx-tools-fc0e4d47df
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_creates_tables
  Scenario: Native check: creates tables [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n\n## Data\n\n| Name | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    And output is prepared as temp dir under "tables.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "tables.pptx"; "# Title\n\n## Data\n\n| Name | Value |\n|------|-------|\n| A | 1 |\n| B | 2 |\n"
    Then result field "success" is true
    And 0 is at least 1

  @candidate-python-pptx-tools-560b2c0a97
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_bold_labels
  Scenario: Native check: bold labels [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n\n## Key Points\n- **Duration:** 6 months\n- **Cost:** $100K\n"
    And output is prepared as temp dir under "labels.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "labels.pptx"; "# Title\n\n## Key Points\n- **Duration:** 6 months\n- **Cost:** $100K\n"
    Then result field "success" is true

  @candidate-python-pptx-tools-3adf84527e
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_custom_fonts
  Scenario: Native check: custom fonts [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title"
    And output is prepared as temp dir under "fonts.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "fonts.pptx"; "# Title"; title font "Impact"; body font "Calibri"
    Then result field "success" is true

  @candidate-python-pptx-tools-258ca5ff84
  # Native: tests/test_pptx_tools.py::TestPptxFromMarkdown::test_subtitle_on_title_slide
  Scenario: Native check: subtitle on title slide [TestPptxFromMarkdown]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Main Title\n**Context:** Supporting subtitle text\n"
    And output is prepared as temp dir under "subtitle.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "subtitle.pptx"; "# Main Title\n**Context:** Supporting subtitle text\n"
    Then result field "success" is true

  @candidate-python-pptx-tools-72b347391e
  # Native: tests/test_pptx_tools.py::TestPptxExtract::test_extracts_titles
  Scenario: Native check: extracts titles [TestPptxExtract]
    Given Create an instance of PowerPointTools.
    And Create a simple test presentation.
    When pptx tools.tool pptx extract using str representation of sample pptx
    Then "slides" occurs in result
    And the number of entries in result at "slides" is at least 2
    And "Test Title" occurs in str representation of result

  @candidate-python-pptx-tools-2c16bad251
  # Native: tests/test_pptx_tools.py::TestPptxExtract::test_extracts_content
  Scenario: Native check: extracts content [TestPptxExtract]
    Given Create an instance of PowerPointTools.
    And Create a simple test presentation.
    When pptx tools.tool pptx extract using str representation of sample pptx
    Then "slides" occurs in result

  @candidate-python-pptx-tools-93c877d418
  # Native: tests/test_pptx_tools.py::TestPptxExtract::test_file_not_found
  Scenario: Native check: file not found [TestPptxExtract]
    Given Create an instance of PowerPointTools.
    When pptx tools.tool pptx extract using "/nonexistent/file.pptx"
    Then "error" occurs in result or "Error" occurs in str representation of result

  @candidate-python-pptx-tools-0495d5484a
  # Native: tests/test_pptx_tools.py::TestPptxToMarkdown::test_converts_to_markdown
  Scenario: Native check: converts to markdown [TestPptxToMarkdown]
    Given Create an instance of PowerPointTools.
    And Create a simple test presentation.
    When pptx tools.tool pptx to markdown using str representation of sample pptx
    Then result has type str
    And "Test Title" occurs in result or "Slide" occurs in result

  @candidate-python-pptx-tools-bfcbbb9a26
  # Native: tests/test_pptx_tools.py::TestPptxToMarkdown::test_includes_slide_titles
  Scenario: Native check: includes slide titles [TestPptxToMarkdown]
    Given Create an instance of PowerPointTools.
    And Create a simple test presentation.
    When pptx tools.tool pptx to markdown using str representation of sample pptx
    Then "#" occurs in result or "Slide" occurs in result

  @candidate-python-pptx-tools-2bc9f4dcce
  # Native: tests/test_pptx_tools.py::TestPptxToMarkdown::test_file_not_found
  Scenario: Native check: file not found [TestPptxToMarkdown]
    Given Create an instance of PowerPointTools.
    When pptx tools.tool pptx to markdown using "/nonexistent/file.pptx"
    Then "Error" occurs in result or "not found" occurs in result in lowercase

  @candidate-python-pptx-tools-a75bef0541
  # Native: tests/test_pptx_tools.py::TestSlidePositioning::test_content_within_bounds
  Scenario: Native check: content within bounds [TestSlidePositioning]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n\n## Content\n- Bullet 1\n- Bullet 2\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    And output is prepared as temp dir under "bounds.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "bounds.pptx"; "# Title\n\n## Content\n- Bullet 1\n- Bullet 2\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n"
    Then result field "success" is true
    And shape left is at least 0
    And shape top is at least 0
    And shape left joined with shape width is at most the result of Presentation with temp dir under "bounds.pptx" slide width
    And shape top joined with shape height is at most the result of Presentation with temp dir under "bounds.pptx" slide height

  @candidate-python-pptx-tools-c101d89434
  # Native: tests/test_pptx_tools.py::TestSlidePositioning::test_widescreen_dimensions
  Scenario: Native check: widescreen dimensions [TestSlidePositioning]
    Given Create an instance of PowerPointTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title"
    And output is prepared as temp dir under "widescreen.pptx"
    When pptx tools.tool pptx from markdown using str representation of temp dir under "widescreen.pptx"; "# Title"
    Then result field "success" is true
    And the result of abs with the result of Presentation with temp dir under "widescreen.pptx" slide width minus the result of Mm with 338.67 is below the result of Mm with 1
    And the result of abs with the result of Presentation with temp dir under "widescreen.pptx" slide height minus the result of Mm with 190.5 is below the result of Mm with 1
