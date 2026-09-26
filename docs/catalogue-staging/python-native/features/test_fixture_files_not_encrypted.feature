@captured @python_candidate
Feature: fixture files not encrypted native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-fixture-files-not-encrypted-6ef4a69253
  # Native: tests/test_fixture_files_not_encrypted.py::test_fixture_file_is_not_encrypted
  Scenario: Native check: fixture file is not encrypted
    Given a prepared fixture path input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [fixture_path0] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/comments/comments-ccdfb41723d5.docx')"} |
      | [fixture_path1] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/content-controls/sdt-content-controls-e4f051ec2eb5.docx')"} |
      | [fixture_path2] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/creation/minimal-291ea45fd599.docx')"} |
      | [fixture_path3] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/formatting/formatted-text-12183fb28e49.docx')"} |
      | [fixture_path4] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/headers-footers/headers-footers-a99df5aa88c5.docx')"} |
      | [fixture_path5] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/numbering/bullet-list-fad9dd22fb2d.docx')"} |
      | [fixture_path6] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/numbering/numbered-list-feaa592c7914.docx')"} |
      | [fixture_path7] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/revisions/track-changes-e3c5159fbf25.docx')"} |
      | [fixture_path8] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/styles/headings-0e3d6fb95187.docx')"} |
      | [fixture_path9] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/styles/styles-9548a1ce68ca.docx')"} |
      | [fixture_path10] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/tables/complex-table-10737b881f16.docx')"} |
      | [fixture_path11] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/tables/simple-table-8192955ef935.docx')"} |
      | [fixture_path12] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/docx/text/single-paragraph-dfca453a4b60.docx')"} |
      | [fixture_path13] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/comments/comments-2c771c00dfe2.pptx')"} |
      | [fixture_path14] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/creation/minimal-e6b4859435d7.pptx')"} |
      | [fixture_path15] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/layouts/layouts-d902e187a376.pptx')"} |
      | [fixture_path16] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/layouts/multiple-masters-7342e20ba487.pptx')"} |
      | [fixture_path17] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/media/images-792277d2c358.pptx')"} |
      | [fixture_path18] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/notes/notes-e97c8d590798.pptx')"} |
      | [fixture_path19] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/shapes/shapes-10a6d7267ed9.pptx')"} |
      | [fixture_path20] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/slides/hidden-slides-fa245a3df00f.pptx')"} |
      | [fixture_path21] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/tables/tables-3998d8058f35.pptx')"} |
      | [fixture_path22] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/text/bullet-points-50f9157c8ff3.pptx')"} |
      | [fixture_path23] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/pptx/text/title-slide-1b848867cffb.pptx')"} |
      | [fixture_path24] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/cells/data-types-bf5ecc732bd2.xlsx')"} |
      | [fixture_path25] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/cells/single-cell-7c4584b7c6a6.xlsx')"} |
      | [fixture_path26] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/comments/comments-c03ad6550802.xlsx')"} |
      | [fixture_path27] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/conditional-formatting/conditional-format-80f3dc2dbfa2.xlsx')"} |
      | [fixture_path28] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/creation/minimal-9145d25de350.xlsx')"} |
      | [fixture_path29] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/defined-names/named-ranges-de71d259e267.xlsx')"} |
      | [fixture_path30] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/formatting/formatting-ee0ee5c84016.xlsx')"} |
      | [fixture_path31] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/formulas/formulas-9668136d1f23.xlsx')"} |
      | [fixture_path32] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/tables/merged-cells-444855bd685a.xlsx')"} |
      | [fixture_path33] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/tables/tables-7a10c58d6f99.xlsx')"} |
      | [fixture_path34] | {"fixture_path": "PosixPath('/srv/piclaw-dev/workspace/tmp/python-contract-cleanup-check/references/fixtures-ooxml/fixtures/xlsx/worksheets/multiple-sheets-40628979d414.xlsx')"} |
    When zf.testzip using the prepared inputs
    And zf.infolist using the prepared inputs
    Then the result of zipfile.is zipfile with fixture path is non-empty or true
    And the result of zf.testzip with no arguments is null
    And not info filename for each info in the result of zf.infolist with no arguments where info flag bits combined with 1

  @candidate-python-fixture-files-not-encrypted-3416fbdf27
  # Native: tests/test_fixture_files_not_encrypted.py::test_office_fixture_inventory_not_empty
  Scenario: Native check: office fixture inventory not empty
    Given files is prepared as the result of office fixture files with no arguments
    When office fixture files using the prepared inputs
    Then the number of entries in the result of office fixture files with no arguments equals 35
