@captured @python_candidate
Feature: fixture asset resolution native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-fixture-asset-resolution-045d94bd6d
  # Native: tests/test_fixture_asset_resolution.py::test_stable_id_survives_physical_rename
  Scenario: Native check: stable id survives physical rename
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    When Resolve the ID, move its payload to a different grouped filename, update only path and scenario-group metadata, then resolve the same ID again
    And Attempt to use its historical alias as an ID
    Then The unchanged stable ID resolves to the renamed physical file
    And The alias lookup raises an unknown fixture ID error

  @candidate-python-fixture-asset-resolution-fd7b66a462
  # Native: tests/test_fixture_asset_resolution.py::test_unsafe_or_alternate_fixture_root_refuses
  Scenario: Native check: unsafe or alternate fixture root refuses
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    And Independently substitute an absolute path, parent traversal, a testdata root, an internal parent component, repeated separator or Windows backslash path
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [../escape.docx] | {"relative": "'../escape.docx'"} |
      | [/absolute.docx] | {"relative": "'/absolute.docx'"} |
      | [testdata/file.docx] | {"relative": "'testdata/file.docx'"} |
      | [fixtures/../escape.docx] | {"relative": "'fixtures/../escape.docx'"} |
      | [fixtures//bad.docx] | {"relative": "'fixtures//bad.docx'"} |
      | [fixtures/a\\b.docx] | {"relative": "'fixtures/a\\\\\\\\b.docx'"} |
    When Load the altered manifest
    Then The resolver rejects each path as unsafe

  @candidate-python-fixture-asset-resolution-5ac3c4adcb
  # Native: tests/test_fixture_asset_resolution.py::test_symlink_fixture_payload_refuses
  Scenario: Native check: symlink fixture payload refuses
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    And Move the payload outside fixtures and replace its manifest path with a symbolic link
    When Resolve its ID
    Then The resolver rejects the escaping or symbolic-link path

  @candidate-python-fixture-asset-resolution-72d494e83e
  # Native: tests/test_fixture_asset_resolution.py::test_duplicate_payload_ids_and_aliases_refuse
  Scenario: Native check: duplicate payload ids and aliases refuse
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    When Duplicate a payload record in the manifest
    And Restore one record and duplicate its historical alias
    Then Duplicate content IDs or hashes are refused
    And Duplicate aliases are refused

  @candidate-python-fixture-asset-resolution-f9a5b33a54
  # Native: tests/test_fixture_asset_resolution.py::test_invalid_asset_metadata_refuses
  Scenario: Native check: invalid asset metadata refuses
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    And Independently change the format to mismatch the file extension, clear its scenario group, set a negative byte count or supply an invalid ID
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [format-xlsx] | {"field": "'format'", "value": "'xlsx'"} |
      | [scenarioGroup-] | {"field": "'scenarioGroup'", "value": "''"} |
      | [bytes--1] | {"field": "'bytes'", "value": "-1"} |
      | [id-fixture-invalid] | {"field": "'id'", "value": "'fixture-invalid'"} |
    When Load each malformed manifest
    Then Each malformed record raises a verification error

  @candidate-python-fixture-asset-resolution-3bc9865e71
  # Native: tests/test_fixture_asset_resolution.py::test_payload_tampering_refuses_even_with_same_length
  Scenario: Native check: payload tampering refuses even with same length
    Given An isolated schema-2 manifest maps a content-addressed fixture ID to a payload under fixtures, with its format, scenario group, byte count, digest and provenance
    When Replace the payload with different bytes of exactly the same length
    And Resolve the unchanged fixture ID
    Then SHA-256 verification refuses the altered payload
