@captured @python_candidate
Feature: word tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-word-tools-4171e876e4
  # Native: tests/test_word_tools.py::TestWordExtract::test_extracts_content
  Scenario: Native check: extracts content [TestWordExtract]
    Given Create an instance of WordTools.
    And Create a test Word document with sections.
    When word tools.tool word extract using str representation of sample docx
    Then "content" occurs in result or "paragraphs" occurs in result or "text" occurs in str representation of result

  @candidate-python-word-tools-2797d0202c
  # Native: tests/test_word_tools.py::TestWordExtract::test_extracts_headings
  Scenario: Native check: extracts headings [TestWordExtract]
    Given Create an instance of WordTools.
    And Create a test Word document with sections.
    When word tools.tool word extract using str representation of sample docx
    Then "Test Document" occurs in str representation of result or "Section 1" occurs in str representation of result

  @candidate-python-word-tools-4632093cb9
  # Native: tests/test_word_tools.py::TestWordToMarkdown::test_converts_to_markdown
  Scenario: Native check: converts to markdown [TestWordToMarkdown]
    Given Create an instance of WordTools.
    And Create a test Word document with sections.
    When word tools.tool word to markdown using str representation of sample docx
    Then result has type str
    And "Test Document" occurs in result

  @candidate-python-word-tools-7154116c53
  # Native: tests/test_word_tools.py::TestWordToMarkdown::test_converts_headings
  Scenario: Native check: converts headings [TestWordToMarkdown]
    Given Create an instance of WordTools.
    And Create a test Word document with sections.
    When word tools.tool word to markdown using str representation of sample docx
    Then "#" occurs in result

  @candidate-python-word-tools-aad7cadb60
  # Native: tests/test_word_tools.py::TestWordToMarkdown::test_converts_tables
  Scenario: Native check: converts tables [TestWordToMarkdown]
    Given Create an instance of WordTools.
    And Create a test Word document with sections.
    When word tools.tool word to markdown using str representation of sample docx
    Then "|" occurs in result

  @candidate-python-word-tools-bc96f55e90
  # Native: tests/test_word_tools.py::TestWordFileNotFound::test_file_not_found
  Scenario: Native check: file not found [TestWordFileNotFound]
    Given Create an instance of WordTools.
    And a prepared method input or fixture
    And a prepared path input or fixture
    And result is prepared as the result of getattr(word tools, method) with path
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [tool_word_extract-/nonexistent.docx] | {"method": "'tool_word_extract'", "path": "'/nonexistent.docx'"} |
      | [tool_word_to_markdown-/nonexistent.docx] | {"method": "'tool_word_to_markdown'", "path": "'/nonexistent.docx'"} |
    When getattr(word tools, method) using path
    Then "error" occurs in str representation of the result of getattr(word tools, method) with path in lowercase

  @candidate-python-word-tools-fb55616d6d
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_document
  Scenario: Native check: creates document [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Main Title\n\nThis is a paragraph.\n\n## Section 1\n\nContent here.\n"
    And output is prepared as temp dir under "created.docx"
    When word tools.tool word from markdown using str representation of temp dir under "created.docx"; "# Main Title\n\nThis is a paragraph.\n\n## Section 1\n\nContent here.\n"
    Then result field "success" is true
    And temp dir under "created.docx" exists is non-empty or true

  @candidate-python-word-tools-e21175bfe9
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_from_markdown_file
  Scenario: Native check: creates from markdown file [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md file.write text with "# File Input\n\nThis came from a file.\n"
    And md file is prepared as temp dir under "input.md"
    And output is prepared as temp dir under "from_file.docx"
    When word tools.tool word from markdown using str representation of temp dir under "from_file.docx"; markdown file str representation of temp dir under "input.md"
    Then result field "success" is true
    And temp dir under "from_file.docx" exists is non-empty or true
    And "File Input" occurs in the result of '\n'.join with p text for each p in the result of Document with temp dir under "from_file.docx" paragraphs
    And "This came from a file." occurs in the result of '\n'.join with p text for each p in the result of Document with temp dir under "from_file.docx" paragraphs

  @candidate-python-word-tools-4d17d24ed4
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_nested_lists_do_not_duplicate_child_text
  Scenario: Native check: nested lists do not duplicate child text [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Nested\n\n- Parent\n - Child A\n - Child B\n"
    And output is prepared as temp dir under "nested_list.docx"
    When word tools.tool word from markdown using str representation of temp dir under "nested_list.docx"; "# Nested\n\n- Parent\n - Child A\n - Child B\n"
    Then result field "success" is true
    And "Parent" occurs in p text with boundary whitespace removed for each p in the result of Document with temp dir under "nested_list.docx" paragraphs where p text with boundary whitespace removed
    And the result of texts.count with "Child A" equals 1
    And the result of texts.count with "Child B" equals 1
    And not at least one item satisfies "Parent" occurs in t and "Child A" occurs in t for each t in p text with boundary whitespace removed for each p in the result of Document with temp dir under "nested_list.docx" paragraphs where p text with boundary whitespace removed

  @candidate-python-word-tools-9ff29b12c3
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_headings
  Scenario: Native check: creates headings [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n## Section\n### Subsection\n"
    And output is prepared as temp dir under "headings.docx"
    When word tools.tool word from markdown using str representation of temp dir under "headings.docx"; "# Title\n## Section\n### Subsection\n"
    Then the number of entries in p style name for each p in the result of Document with temp dir under "headings.docx" paragraphs where "Heading" occurs in p style name is at least 2

  @candidate-python-word-tools-3ebbeab26b
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_paragraphs
  Scenario: Native check: creates paragraphs [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Title\n\nFirst paragraph.\n\nSecond paragraph.\n"
    And output is prepared as temp dir under "paragraphs.docx"
    When word tools.tool word from markdown using str representation of temp dir under "paragraphs.docx"; "# Title\n\nFirst paragraph.\n\nSecond paragraph.\n"
    Then "First paragraph" occurs in the result of ' '.join with p text for each p in the result of Document with temp dir under "paragraphs.docx" paragraphs where p text with boundary whitespace removed

  @candidate-python-word-tools-30f1aee2b3
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_tables
  Scenario: Native check: creates tables [TestWordFromMarkdown]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n| C | D |\n"
    And output is prepared as temp dir under "tables.docx"
    When word tools.tool word from markdown using str representation of temp dir under "tables.docx"; "# Data\n\n| Col1 | Col2 |\n|------|------|\n| A | B |\n| C | D |\n"
    Then the number of entries in the result of Document with temp dir under "tables.docx" tables is at least 1

  @candidate-python-word-tools-66274d1314
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_blockquotes
  Scenario: Native check: creates blockquotes [TestWordFromMarkdown]
    Given Markdown containing a blockquote paragraph and a new DOCX output path
    When Convert the Markdown and reopen the output document
    Then At least one paragraph contains the word "blockquote"

  @candidate-python-word-tools-513ae3857b
  # Native: tests/test_word_tools.py::TestWordFromMarkdown::test_creates_bullet_lists
  Scenario: Native check: creates bullet lists [TestWordFromMarkdown]
    Given Markdown with three hyphen-prefixed Item entries and a new DOCX output path
    When Convert the Markdown and reopen the output document
    Then At least two output paragraphs contain "Item"

  @candidate-python-word-tools-8a226687a2
  # Native: tests/test_word_tools.py::TestWordDocumentStructure::test_preserves_formatting
  Scenario: Native check: preserves formatting [TestWordDocumentStructure]
    Given Markdown containing bold, italic and bold-italic markers and a new DOCX output path
    When Convert the Markdown to the output Word document
    Then The conversion reports success

  @candidate-python-word-tools-d5bf2a87ef
  # Native: tests/test_word_tools.py::TestWordDocumentStructure::test_handles_empty_document
  Scenario: Native check: handles empty document [TestWordDocumentStructure]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as ""
    And output is prepared as temp dir under "empty.docx"
    When word tools.tool word from markdown using str representation of temp dir under "empty.docx"; ""
    Then temp dir under "empty.docx" exists or "success" occurs in result

  @candidate-python-word-tools-6f7c921a96
  # Native: tests/test_word_tools.py::TestWordDocumentStructure::test_handles_special_characters
  Scenario: Native check: handles special characters [TestWordDocumentStructure]
    Given Create an instance of WordTools.
    And an isolated writable temporary directory
    And md is prepared as "# Special Characters\n\nText with <angle brackets> and & ampersand.\n"
    And output is prepared as temp dir under "special.docx"
    When word tools.tool word from markdown using str representation of temp dir under "special.docx"; "# Special Characters\n\nText with <angle brackets> and & ampersand.\n"
    Then result field "success" is true
