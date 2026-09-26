@captured @python_candidate
Feature: fixture source integrity native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-fixture-source-integrity-8819fffbdd
  # Native: tests/test_fixture_source_integrity.py::test_clean_annotated_release_is_accepted
  Scenario: Native check: clean annotated release is accepted
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    When Verify the synthetic release using the matching consumer pin
    Then Verification returns without an error

  @candidate-python-fixture-source-integrity-5e151013de
  # Native: tests/test_fixture_source_integrity.py::test_changes_outside_asset_manifest_refuse
  Scenario: Native check: changes outside asset manifest refuse
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Change a facts file, workflow ledger, feature file or create an unexpected file without changing either manifest
    And Exercise both staged and unstaged facts modifications independently
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [facts/constants.json-False] | {"path": "'facts/constants.json'", "stage": "False"} |
      | [facts/constants.json-True] | {"path": "'facts/constants.json'", "stage": "True"} |
      | [ledgers/workflows.json-False] | {"path": "'ledgers/workflows.json'", "stage": "False"} |
      | [contracts/workflow.feature-False] | {"path": "'contracts/workflow.feature'", "stage": "False"} |
      | [unexpected.json-False] | {"path": "'unexpected.json'", "stage": "False"} |
    When Verify the release against the original pin
    Then Verification raises RuntimeError reporting a dirty checkout

  @candidate-python-fixture-source-integrity-2f1928ccb6
  # Native: tests/test_fixture_source_integrity.py::test_lightweight_tag_is_not_a_release
  Scenario: Native check: lightweight tag is not a release
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Replace the annotated release tag with a lightweight tag pointing to the same commit
    When Verify the release against the original pin
    Then Verification raises RuntimeError requiring an annotated tag

  @candidate-python-fixture-source-integrity-4ff44d8fbb
  # Native: tests/test_fixture_source_integrity.py::test_head_must_match_pin
  Scenario: Native check: head must match pin
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Create a new empty commit without updating the pin
    When Verify the new HEAD against the original pin
    Then Verification raises RuntimeError because HEAD differs from the pin

  @candidate-python-fixture-source-integrity-52e383fc1e
  # Native: tests/test_fixture_source_integrity.py::test_tag_must_point_to_pinned_head
  Scenario: Native check: tag must point to pinned head
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Create a new empty commit and update the pinned commit, but leave the release tag on the earlier commit
    When Verify the checkout against the updated pin
    Then Verification raises RuntimeError because the tag differs from the pinned commit

  @candidate-python-fixture-source-integrity-7db8c2c20b
  # Native: tests/test_fixture_source_integrity.py::test_wrong_seal_refuses_even_clean_release
  Scenario: Native check: wrong seal refuses even clean release
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Keep the checkout clean and replace one pinned manifest digest with 64 zeroes, independently for each seal
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [manifestSha256] | {"field": "'manifestSha256'"} |
      | [sharedPackManifestSha256] | {"field": "'sharedPackManifestSha256'"} |
    When Verify the release using the altered digest
    Then Verification raises RuntimeError reporting a seal mismatch

  @candidate-python-fixture-source-integrity-f0b8987151
  # Native: tests/test_fixture_source_integrity.py::test_nested_directory_is_not_mistaken_for_submodule
  Scenario: Native check: nested directory is not mistaken for submodule
    Given An isolated Git repository contains both sealed manifests, a facts registry, a workflow ledger and a feature file
    And The release commit is clean and has an annotated tag; the consumer pin records its commit and both SHA-256 seals
    And Select the facts directory inside the Git checkout as if it were the shared repository root
    When Verify that directory against the release pin
    Then Verification raises RuntimeError requiring an initialised Git submodule root
