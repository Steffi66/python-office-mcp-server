@captured @python_candidate
Feature: writer enrolment native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-writer-enrolment-518727408f
  # Native: tests/test_writer_enrolment.py::test_comment_preview_and_commit
  Scenario: Native check: comment preview and commit
    Given an isolated writable temporary directory
    And a prepared suffix input or fixture
    And a prepared target input or fixture
    And output.write bytes with "b'retain old destination'"
    And before is prepared as saved bytes of source
    And server is prepared as the result of OfficeServer with no arguments
    And args is prepared as the fields "file_path" set to str representation of source, "operation" set to "add", "target" set to target, "text" set to "review", "output_path" set to str representation of output
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [.docx-target] | {"suffix": "'.docx'", "target": "'target'"} |
      | [.xlsx-A1] | {"suffix": "'.xlsx'", "target": "'A1'"} |
      | [.pptx-1] | {"suffix": "'.pptx'", "target": "'1'"} |
    When server.tool office comment using expanded arguments the fields "file_path" set to str representation of source, "operation" set to "add", "target" set to target, "text" set to "review", "output_path" set to str representation of output; mode "dry_run"
    And server.tool office comment using expanded arguments the fields "file_path" set to str representation of source, "operation" set to "add", "target" set to target, "text" set to "review", "output_path" set to str representation of output; mode "safe"
    Then preview at "success" is non-empty or true
    And preview at "changes_applied" equals 0
    And saved bytes of source equals saved bytes of source and saved bytes of output equals "b'retain old destination'"
    And result at "changes_applied" equals 1
    And saved bytes of source equals saved bytes of source
    And "review" occurs in str representation of the result of server.tool office comment with str representation of output; operation "get"

  @candidate-python-writer-enrolment-48ea791deb
  # Native: tests/test_writer_enrolment.py::test_word_table_uses_top_level_output
  Scenario: Native check: word table uses top level output
    Given an isolated writable temporary directory
    And a prepared mode input or fixture
    And doc.save with source
    And doc is prepared as the result of Document with no arguments
    And table is prepared as the result of doc.add table with rows 2; cols 1
    And the result of table.cell with 0; 0 text is set to "Name"
    And the result of table.cell with 1; 0 text is set to "old"
    And before is prepared as saved bytes of source
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [dry_run] | {"mode": "'dry_run'"} |
      | [strict] | {"mode": "'strict'"} |
      | [safe] | {"mode": "'safe'"} |
    When OfficeServer().tool office table using str representation of source; operation "add_row"; table id "0"; data {"Name": "new"}; output path str representation of output; mode mode
    Then result at "success" is non-empty or true
    And saved bytes of source equals saved bytes of source
    And when mode equals "dry_run", not output exists
    And when mode equals "dry_run", the number of entries in the result of Document with output tables at 0 rows equals 3

  @candidate-python-writer-enrolment-bf8aab525a
  # Native: tests/test_writer_enrolment.py::test_specialised_writer_failure_does_not_publish
  Scenario: Native check: specialised writer failure does not publish
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And output.write bytes with "b'previous'"
    And monkeypatch.setattr with mutation; "validate_staged_document"; fail
    And before is prepared as saved bytes of source
    When OfficeServer().tool pptx add slide using str representation of source; output path str representation of output
    Then not result at "success" and "injected validation" occurs in result at "error"
    And saved bytes of source equals saved bytes of source
    And saved bytes of output equals "b'previous'"

  @candidate-python-writer-enrolment-1c812cb68f
  # Native: tests/test_writer_enrolment.py::test_nested_generic_writer_publishes_once
  Scenario: Native check: nested generic writer publishes once
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setattr with mutation os; "replace"; replace
    And source is prepared as tmp path under "source.xlsx"
    And server is prepared as the result of OfficeServer with no arguments
    When server.tool office comment using str representation of tmp path under "source.xlsx"; operation "add"; target "A1"; text "review"
    And server.tool office comment using str representation of tmp path under "source.xlsx"; operation "delete"; target "A1"
    Then result at "success" is non-empty or true
    And [] equals the entries str representation of tmp path under "source.xlsx"
    And the result of load workbook with tmp path under "source.xlsx" active at "A1" comment is null
