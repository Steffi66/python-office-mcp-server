@captured @python_candidate
Feature: libreoffice oracle native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-libreoffice-oracle-49c5a57893
  # Native: tests/test_libreoffice_oracle.py::test_libreoffice_recalculates_invalidated_cross_sheet_cache
  Scenario: Native check: libreoffice recalculates invalidated cross sheet cache
    Given LibreOffice or soffice must be installed; otherwise the module-level skip marker prevents execution.
    And The shared fixture fixtures/cross-sheet-cache.xlsx must be available.
    When The test copies the cross-sheet workbook fixture to a temporary calculation.xlsx file.
    And It patches Input!A1 to 10 through OfficeServer.tool_office_patch.
    And It converts the edited file back to XLSX through headless LibreOffice and opens the converted workbook with cached formula results.
    Then The patch result reports calculation_state as recalculation-required.
    And After LibreOffice recalculates the workbook, Calc!A1 evaluates to 20.

  @candidate-python-libreoffice-oracle-0d51fd4ffb
  # Native: tests/test_libreoffice_oracle.py::test_libreoffice_renders_edited_document_to_pdf
  Scenario: Native check: libreoffice renders edited document to pdf
    Given LibreOffice or soffice must be installed; otherwise the module-level skip marker prevents execution.
    And The test is parameterized to run once for a .docx source and once for a .pptx source.
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [.docx] | {"suffix": "'.docx'"} |
      | [.pptx] | {"suffix": "'.pptx'"} |
    When For the .docx variant, the test creates a document containing the placeholder text <Present> and targets that text for replacement.
    And For the .pptx variant, the test creates a presentation with a title slide and targets slide:1/title for replacement.
    And It applies an office_patch change that writes Verified render and converts the edited file to PDF through headless LibreOffice.
    Then The patch result reports exactly one applied change.
    And The converted file starts with the PDF signature %PDF-.
    And The produced PDF is larger than 1000 bytes.
