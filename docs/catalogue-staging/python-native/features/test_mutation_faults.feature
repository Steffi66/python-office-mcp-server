@captured @python_candidate
Feature: mutation faults native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-mutation-faults-d0b84bdd09
  # Native: tests/test_mutation_faults.py::test_failed_phase_preserves_existing_destination_and_cleans
  Scenario: Native check: failed phase preserves existing destination and cleans
    Given The test is parameterized to inject a failure during the apply, validation, or replace phase.
    And A source workbook and an existing destination workbook are created in a temporary directory before each run.
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [apply] | {"failure": "'apply'"} |
      | [validation] | {"failure": "'validation'"} |
      | [replace] | {"failure": "'replace'"} |
    When The test snapshots all files in the temporary directory.
    And Depending on the parameter, it either passes an apply callback that raises OSError, monkeypatches validate_staged_document to raise OSError, or monkeypatches os.replace inside the mutation module to raise OSError.
    And It calls mutation.stage_patch in strict mode with one requested change.
    Then stage_patch returns success as False.
    And The reported error text includes injected failure.
    And The reported changes_applied count is 0.
    And All files in the temporary directory remain byte-for-byte identical to the snapshot taken before the call.
    And mutation._path_locks is empty after the failure.

  @candidate-python-mutation-faults-0fa2b533ba
  # Native: tests/test_mutation_faults.py::test_external_change_is_not_overwritten
  Scenario: Native check: external change is not overwritten
    Given The test is parameterized to simulate an external edit to either the source file or the destination file during publication.
    And A source workbook and an existing destination workbook are created in a temporary directory before each run.
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [source] | {"changed": "'source'"} |
      | [destination] | {"changed": "'destination'"} |
    When The apply callback increments the staged workbook and then overwrites either the source or the destination file with the bytes external edit.
    And The test calls mutation.stage_patch in strict mode with that callback.
    Then stage_patch returns success as False.
    And The reported error text includes changed before commit.
    And The file that was externally edited still contains the bytes external edit after stage_patch returns.
    And The untouched peer file still has its original bytes.
    And No directories remain inside the temporary directory.

  @candidate-python-mutation-faults-599428e5c8
  # Native: tests/test_mutation_faults.py::test_same_source_writers_are_serialised_without_lost_updates
  Scenario: Native check: same source writers are serialised without lost updates
    Given A source workbook exists and two worker threads can call mutation.stage_patch concurrently on that same path.
    When The first apply callback signals that it has started and then blocks on an event before incrementing the staged workbook.
    And The second apply callback records whether it was entered.
    And The test submits two stage_patch calls concurrently, checks that the second callback does not start during the first callback's blocked window, and then releases the first callback.
    And After both futures complete, it reopens the source workbook.
    Then Each stage_patch call reports one applied change.
    And The second apply callback is still blocked from entry during the first callback's initial 0.1 second hold window.
    And The final source workbook value at A1 is 2, showing that both increments were preserved.
    And mutation._path_locks is empty after both calls complete.

  @candidate-python-mutation-faults-1f3b33ac2e
  # Native: tests/test_mutation_faults.py::test_symlink_source_mutates_target_without_replacing_link
  Scenario: Native check: symlink source mutates target without replacing link
    Given A symbolic link alias.xlsx points to the real source workbook.
    When The test calls mutation.stage_patch on the symlink path with in-place strict mode and an incrementing apply callback.
    And It then inspects both the symlink and the real source workbook.
    Then The reported changes_applied count is 1.
    And alias.xlsx remains a symbolic link.
    And The real source workbook ends with A1 equal to 1.

  @candidate-python-mutation-faults-a163f73b8a
  # Native: tests/test_mutation_faults.py::test_hard_links_are_refused_without_mutation
  Scenario: Native check: hard links are refused without mutation
    Given A hard link alias.xlsx points to the real source workbook.
    When The test records the source bytes and calls mutation.stage_patch on the hard-link path with in-place strict mode.
    Then The reported changes_applied count is 0.
    And The reported error text contains Hard-linked.
    And The real source file bytes are unchanged.

  @candidate-python-mutation-faults-a13137c4cc
  # Native: tests/test_mutation_faults.py::test_invalid_staged_archive_never_replaces_output
  Scenario: Native check: invalid staged archive never replaces output
    Given A source workbook and an existing destination workbook are created in a temporary directory.
    When The apply callback replaces the staged file contents with the bytes broken zip and reports a nominally successful cell result.
    And The test calls mutation.stage_patch in strict mode with that callback.
    Then The reported changes_applied count is 0.
    And The existing destination file still contains the bytes previous output.
