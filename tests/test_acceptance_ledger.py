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
