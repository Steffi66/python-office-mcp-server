@captured @python_candidate
Feature: mutation contract policy native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-mutation-contract-policy-a9b9a5c32d
  # Native: tests/test_mutation_contract_policy.py::test_preservation_complement_keeps_every_unallowed_member
  Scenario: Native check: preservation complement keeps every unallowed member
    Given A policy lists exact ZIP members and permits changes to edited.xml only
    When Compute the preserved-member complement
    And Add an additional opaque member and compute the complement again
    Then Opaque and sentinel members retain their expected hashes
    And The additional member is preserved automatically without a second stored hash map

  @candidate-python-mutation-contract-policy-ae88bf4064
  # Native: tests/test_mutation_contract_policy.py::test_weakened_or_ambiguous_policies_refuse
  Scenario: Native check: weakened or ambiguous policies refuse
    Given The current four-fixture mutation contract is copied into isolated test data
    And Independently weaken exact membership or preservation mode, reference an unknown asset/member, repeat an allowed member or duplicate a scenario ID
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [membership] | {"fault": "'membership'"} |
      | [preserve] | {"fault": "'preserve'"} |
      | [unknown-asset] | {"fault": "'unknown-asset'"} |
      | [unknown-member] | {"fault": "'unknown-member'"} |
      | [duplicate-member] | {"fault": "'duplicate-member'"} |
      | [duplicate-scenario] | {"fault": "'duplicate-scenario'"} |
    When Validate each altered contract
    Then Every unsupported or ambiguous policy raises a verification error

  @candidate-python-mutation-contract-policy-2f6c00a2c0
  # Native: tests/test_mutation_contract_policy.py::test_root_manifest_seals_metadata_without_a_pack_manifest
  Scenario: Native check: root manifest seals metadata without a pack manifest
    Given A root manifest records the path, role, byte count and SHA-256 of minimal workflow contract JSON
    When Read the sealed contract
    And Replace its contents with same-length JSON carrying a different version
    And Restore its contents and duplicate the manifest metadata row
    Then The original contract payload is accepted
    And Changed content is refused by its root-manifest digest
    And Duplicate metadata rows are refused as ambiguous
