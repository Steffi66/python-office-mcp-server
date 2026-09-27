"""Fail-closed acceptance inventory and report lifecycle tests."""

import json
from types import SimpleNamespace

import pytest

from tests.acceptance.ledger import Ledger, binding_matches, inventory

FEATURE = '''@implemented @python
Feature: Example
  @id-xlsx-example
  Scenario: Edit
    Given an input
    When editing
    Then saved value matches
'''


def test_ledger_replaces_stale_success_before_execution(tmp_path):
    path = tmp_path / "report.json"
    path.write_text('{"outcome":"passed","runId":"old"}')
    ledger = Ledger(path)
    assert json.loads(path.read_text())["outcome"] == "running"
    assert ledger.report["runId"] != "old"
    ledger.finish(0)
    assert ledger.report["outcome"] == "incomplete-or-failed"


@pytest.mark.parametrize("text", [
    FEATURE.replace("    Then saved value matches\n", ""),
    FEATURE.replace("@id-xlsx-example", "@unidentified"),
    FEATURE + '\n  @id-xlsx-example\n  Scenario: Duplicate\n    Then done\n',
    FEATURE.replace("@implemented @python", "@implemented @planned"),
    FEATURE.replace("Scenario: Edit", "Scenario Outline: Edit") + '\n    Examples:\n      | x |\n',
])
def test_invalid_inventory_fails(tmp_path, text):
    path = tmp_path / "test.feature"
    path.write_text(text)
    with pytest.raises(ValueError):
        inventory([path])


def test_planned_cases_never_count_as_passes(tmp_path):
    path = tmp_path / "test.feature"
    path.write_text(FEATURE.replace("@implemented @python", "@planned"))
    ledger = Ledger(tmp_path / "report.json")
    ledger.report["inventory"] = inventory([path])
    ledger.finish(0)
    assert ledger.report["inventory"][0]["outcome"] == "planned"
    assert ledger.report["outcome"] == "incomplete-or-failed"


def test_binding_match_count_exposes_undefined_and_ambiguous():
    step = SimpleNamespace(name="saved value matches", type="then")
    context = SimpleNamespace(type="then", parser=SimpleNamespace(is_matching=lambda text: text == step.name))
    assert not binding_matches(step, [])
    assert len(binding_matches(step, [context])) == 1
    assert len(binding_matches(step, [context, context])) == 2


def test_compiled_table_json_rejects_literal_newlines(tmp_path):
    path = tmp_path / "bad.feature"
    text = FEATURE.replace("    When editing", '    When editing:\n      | value_json |\n      | "first\\nsecond" |')
    path.write_text(text)
    with pytest.raises(ValueError):
        inventory([path])
    path.write_text(text.replace('first\\nsecond', 'first\\\\nsecond'))
    assert len(inventory([path])) == 1


def test_scenario_cannot_override_lifecycle(tmp_path):
    path = tmp_path / 'bad.feature'
    path.write_text(FEATURE.replace('@id-xlsx-example', '@id-xlsx-example @planned'))
    with pytest.raises(ValueError, match='override'):
        inventory([path])


def test_case_status_cannot_hide_unexecuted_step(tmp_path):
    ledger = Ledger(tmp_path / 'report.json')
    ledger.report['inventory'] = [{'outcome': 'passed', 'steps': [{'outcome': 'not-run'}]}]
    ledger.finish(0)
    assert ledger.report['outcome'] == 'incomplete-or-failed'


def test_shared_mapping_selects_cases_without_awarding_passes(tmp_path):
    import hashlib

    from tests.acceptance.ledger import apply_implementation_mapping

    path = tmp_path / 'shared.feature'
    path.write_text(FEATURE.replace('@implemented @python', '@planned'))
    cases = inventory([path])
    mapping = {'schemaVersion': 1, 'consumer': 'python', 'contractRevision': 'ooxml-shared-contracts-v2',
               'feature': 'workflows/mutation-safety.feature',
               'featureSha256': hashlib.sha256(path.read_bytes()).hexdigest(),
               'implementedCaseKeys': [cases[0]['stableCaseKey']]}
    apply_implementation_mapping(cases, mapping, feature_path=path)
    assert cases[0]['outcome'] == 'not-run'
    assert all(s['outcome'] == 'not-run' for s in cases[0]['steps'])
    report = Ledger(tmp_path / 'evidence.json')
    report.report['inventory'] = cases
    report.finish(0)
    assert report.report['outcome'] == 'incomplete-or-failed'
    for key, value in [('consumer', 'go'), ('featureSha256', 'bad'),
                       ('implementedCaseKeys', ['unknown']),
                       ('implementedCaseKeys', mapping['implementedCaseKeys'] * 2)]:
        with pytest.raises(ValueError):
            apply_implementation_mapping(inventory([path]), {**mapping, key: value}, feature_path=path)
    apply_implementation_mapping(cases := inventory([path]), {**mapping, 'implementedCaseKeys': []}, feature_path=path)
    assert cases[0]['outcome'] == 'planned'


def test_schema2_selects_only_sealed_mutation_cases_across_features(tmp_path):
    import hashlib
    from tests.acceptance.ledger import apply_implementation_mapping

    paths = [tmp_path / 'workflows/docx/mutation-safety.feature', tmp_path / 'workflows/xlsx/cell-style.feature']
    for path in paths:
        path.parent.mkdir(parents=True, exist_ok=True)
    paths[0].write_text(FEATURE.replace('@implemented @python', '@planned').replace('@id-xlsx-example', '@id-docx-edit'))
    paths[1].write_text(FEATURE.replace('@implemented @python', '@planned').replace('Feature: Example', 'Feature: Spreadsheet') + '''
  @id-xlsx-extra-style
  Scenario: Unrelated style operation
    Given an input
    When editing
    Then saved value matches
''')
    contract = {'schemaVersion': 2, 'features': ['workflows/docx/mutation-safety.feature', 'workflows/xlsx/cell-style.feature'],
                'scenarioIds': ['@id-docx-edit', '@id-xlsx-example'], 'expandedCaseCount': 2}
    cases = inventory(paths, scenario_ids=contract['scenarioIds'])
    assert len(cases) == 2 and '@id-xlsx-extra-style' not in {c['scenarioId'] for c in cases}
    mapping = {'schemaVersion': 2, 'consumer': 'python', 'contractRevision': 'ooxml-shared-contracts-v2',
               'features': [{'path': name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
                            for name, path in zip(contract['features'], paths)],
               'implementedCaseKeys': [c['stableCaseKey'] for c in cases]}
    apply_implementation_mapping(cases, mapping, feature_paths=paths, contract=contract)
    assert all(c['outcome'] == 'not-run' for c in cases)
    for changed in [dict(mapping, feature='workflows/mutation-safety.feature'),
                    dict(mapping, features=mapping['features'][:1]),
                    dict(mapping, features=[dict(mapping['features'][0], sha256='0' * 64), mapping['features'][1]]),
                    dict(mapping, implementedCaseKeys=mapping['implementedCaseKeys'] + ['unknown'])]:
        with pytest.raises(ValueError):
            apply_implementation_mapping(inventory(paths, scenario_ids=contract['scenarioIds']), changed,
                                         feature_paths=paths, contract=contract)
    with pytest.raises(ValueError, match='missing'):
        inventory(paths[:1], scenario_ids=contract['scenarioIds'])
    with pytest.raises(ValueError):
        apply_implementation_mapping(cases, mapping, feature_path=paths[0], contract=contract)
