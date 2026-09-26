@captured @python_candidate
Feature: acceptance ledger native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-acceptance-ledger-5135d5266e
  # Native: tests/test_acceptance_ledger.py::test_ledger_replaces_stale_success_before_execution
  Scenario: Native check: ledger replaces stale success before execution
    Given an isolated writable temporary directory
    And path.write text with "{\"outcome\":\"passed\",\"runId\":\"old\"}"
    And path is prepared as tmp path under "report.json"
    And ledger is prepared as the result of Ledger with tmp path under "report.json"
    When ledger.finish using 0
    Then the result of json.loads with saved text of tmp path under "report.json" at "outcome" equals "running"
    And the result of Ledger with tmp path under "report.json" report at "runId" differs from "old"
    And the result of Ledger with tmp path under "report.json" report at "outcome" equals "incomplete-or-failed"

  @candidate-python-acceptance-ledger-f0e22dd7dc
  # Native: tests/test_acceptance_ledger.py::test_invalid_inventory_fails
  Scenario: Native check: invalid inventory fails
    Given an isolated writable temporary directory
    And a prepared text input or fixture
    And path.write text with text
    And path is prepared as tmp path under "test.feature"
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [@implemented @python\nFeature: Example\n  @id-xlsx-example\n  Scenario: Edit\n    Given an input\n    When editing\n] | {"text": "'@implemented @python\\\\nFeature: Example\\\\n @id-xlsx-example\\\\n Scenario: Edit\\\\n Given an input\\\\n When editing\\\\n'"} |
      | [@implemented @python\nFeature: Example\n  @unidentified\n  Scenario: Edit\n    Given an input\n    When editing\n    Then saved value matches\n] | {"text": "'@implemented @python\\\\nFeature: Example\\\\n @unidentified\\\\n Scenario: Edit\\\\n Given an input\\\\n When editing\\\\n Then saved value matches\\\\n'"} |
      | [@implemented @python\nFeature: Example\n  @id-xlsx-example\n  Scenario: Edit\n    Given an input\n    When editing\n    Then saved value matches\n\n  @id-xlsx-example\n  Scenario: Duplicate\n    Then done\n] | {"text": "'@implemented @python\\\\nFeature: Example\\\\n @id-xlsx-example\\\\n Scenario: Edit\\\\n Given an input\\\\n When editing\\\\n Then saved value matches\\\\n\\\\n @id-xlsx-example\\\\n Scenario: Duplicate\\\\n Then done\\\\n'"} |
      | [@implemented @planned\nFeature: Example\n  @id-xlsx-example\n  Scenario: Edit\n    Given an input\n    When editing\n    Then saved value matches\n] | {"text": "'@implemented @planned\\\\nFeature: Example\\\\n @id-xlsx-example\\\\n Scenario: Edit\\\\n Given an input\\\\n When editing\\\\n Then saved value matches\\\\n'"} |
      | [@implemented @python\nFeature: Example\n  @id-xlsx-example\n  Scenario Outline: Edit\n    Given an input\n    When editing\n    Then saved value matches\n\n    Examples:\n      \| x \|\n] | {"text": "'@implemented @python\\\\nFeature: Example\\\\n @id-xlsx-example\\\\n Scenario Outline: Edit\\\\n Given an input\\\\n When editing\\\\n Then saved value matches\\\\n\\\\n Examples:\\\\n \| x \|\\\\n'"} |
    When inventory using the entries tmp path under "test.feature"
    Then the operation raises ValueError

  @candidate-python-acceptance-ledger-7d994889f5
  # Native: tests/test_acceptance_ledger.py::test_planned_cases_never_count_as_passes
  Scenario: Native check: planned cases never count as passes
    Given an isolated writable temporary directory
    And path.write text with the result of FEATURE.replace with "@implemented @python"; "@planned"
    And path is prepared as tmp path under "test.feature"
    And ledger is prepared as the result of Ledger with tmp path under "report.json"
    And the result of Ledger with tmp path under "report.json" report at "inventory" is set to the result of inventory with the entries tmp path under "test.feature"
    When inventory using the entries tmp path under "test.feature"
    Then the result of Ledger with tmp path under "report.json" report at "inventory" at 0 at "outcome" equals "planned"
    And the result of Ledger with tmp path under "report.json" report at "outcome" equals "incomplete-or-failed"

  @candidate-python-acceptance-ledger-a63c5dab21
  # Native: tests/test_acceptance_ledger.py::test_binding_match_count_exposes_undefined_and_ambiguous
  Scenario: Native check: binding match count exposes undefined and ambiguous
    Given Create step = SimpleNamespace(name="saved value matches", type="then").
    And Create context = SimpleNamespace(type="then", parser=SimpleNamespace(is_matching=lambda text: text == step.name)).
    When Call binding_matches(step, []).
    And Call binding_matches(step, [context]) and measure len(...).
    And Call binding_matches(step, [context, context]) and measure len(...).
    Then binding_matches(step, []) is falsy.
    And len(binding_matches(step, [context])) equals 1.
    And len(binding_matches(step, [context, context])) equals 2.

  @candidate-python-acceptance-ledger-a9061d4bb9
  # Native: tests/test_acceptance_ledger.py::test_compiled_table_json_rejects_literal_newlines
  Scenario: Native check: compiled table json rejects literal newlines
    Given an isolated writable temporary directory
    And path.write text with the result of FEATURE.replace with " When editing"; " When editing:\n | value_json |\n | \"first\\nsecond\" |"
    And path.write text with the result of text.replace with "first\\nsecond"; "first\\\\nsecond"
    And path is prepared as tmp path under "bad.feature"
    And text is prepared as the result of FEATURE.replace with " When editing"; " When editing:\n | value_json |\n | \"first\\nsecond\" |"
    When inventory using the entries tmp path under "bad.feature"
    Then the operation raises ValueError
    And the number of entries in the result of inventory with the entries tmp path under "bad.feature" equals 1

  @candidate-python-acceptance-ledger-6e3d5d5ef4
  # Native: tests/test_acceptance_ledger.py::test_scenario_cannot_override_lifecycle
  Scenario: Native check: scenario cannot override lifecycle
    Given an isolated writable temporary directory
    And path.write text with the result of FEATURE.replace with "@id-xlsx-example"; "@id-xlsx-example @planned"
    And path is prepared as tmp path under "bad.feature"
    When inventory using the entries tmp path under "bad.feature"
    Then the operation raises ValueError with a message matching "override"

  @candidate-python-acceptance-ledger-b2e4ea916a
  # Native: tests/test_acceptance_ledger.py::test_case_status_cannot_hide_unexecuted_step
  Scenario: Native check: case status cannot hide unexecuted step
    Given an isolated writable temporary directory
    And ledger is prepared as the result of Ledger with tmp path under "report.json"
    And the result of Ledger with tmp path under "report.json" report at "inventory" is set to [{"outcome": "passed", "steps": [{"outcome": "not-run"}]}]
    When ledger.finish using 0
    Then the result of Ledger with tmp path under "report.json" report at "outcome" equals "incomplete-or-failed"

  @candidate-python-acceptance-ledger-84a0c0f4ca
  # Native: tests/test_acceptance_ledger.py::test_shared_mapping_selects_cases_without_awarding_passes
  Scenario: Native check: shared mapping selects cases without awarding passes
    Given an isolated writable temporary directory
    And path.write text with the result of FEATURE.replace with "@implemented @python"; "@planned"
    And path is prepared as tmp path under "shared.feature"
    And cases is prepared as the result of inventory with the entries tmp path under "shared.feature"
    And mapping is prepared as the fields "schemaVersion" set to 1, "consumer" set to "python", "contractRevision" set to "ooxml-shared-contracts-v2", "feature" set to "workflows/mutation-safety.feature", "featureSha256" set to the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments, "implementedCaseKeys" set to the entries the result of inventory with the entries tmp path under "shared.feature" at 0 at "stableCaseKey"
    When inventory using the entries tmp path under "shared.feature"
    And apply implementation mapping using the result of inventory with the entries tmp path under "shared.feature"; the fields "schemaVersion" set to 1, "consumer" set to "python", "contractRevision" set to "ooxml-shared-contracts-v2", "feature" set to "workflows/mutation-safety.feature", "featureSha256" set to the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments, "implementedCaseKeys" set to the entries the result of inventory with the entries tmp path under "shared.feature" at 0 at "stableCaseKey"; feature path tmp path under "shared.feature"
    And apply implementation mapping using the result of inventory with the entries tmp path under "shared.feature"; the fields no value set to the fields "schemaVersion" set to 1, "consumer" set to "python", "contractRevision" set to "ooxml-shared-contracts-v2", "feature" set to "workflows/mutation-safety.feature", "featureSha256" set to the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments, "implementedCaseKeys" set to the entries the result of inventory with the entries tmp path under "shared.feature" at 0 at "stableCaseKey", key set to value; feature path tmp path under "shared.feature"
    And apply implementation mapping using the result of inventory with the entries tmp path under "shared.feature"; the fields no value set to the fields "schemaVersion" set to 1, "consumer" set to "python", "contractRevision" set to "ooxml-shared-contracts-v2", "feature" set to "workflows/mutation-safety.feature", "featureSha256" set to the result of hashlib.sha256(path.read bytes()).hexdigest with no arguments, "implementedCaseKeys" set to the entries the result of inventory with the entries tmp path under "shared.feature" at 0 at "stableCaseKey", "implementedCaseKeys" set to []; feature path tmp path under "shared.feature"
    Then the result of inventory with the entries tmp path under "shared.feature" at 0 at "outcome" equals "not-run"
    And every item satisfies s at "outcome" equals "not-run" for each s in the result of inventory with the entries tmp path under "shared.feature" at 0 at "steps"
    And the result of Ledger with tmp path under "evidence.json" report at "outcome" equals "incomplete-or-failed"
    And the operation raises ValueError
    And the result of inventory with the entries tmp path under "shared.feature" at 0 at "outcome" equals "planned"
