"""A changed sealed budget case cannot borrow direct-admission execution credit."""

import copy

import pytest

from tests.package_limit_configuration.cases import FEATURE_SHA256, FIXTURE, KEYS, load_cases
from tools.package_guard import PackageAdmissionArgumentError, PackageAdmissionError


def test_exact_negative_budget_inventory():
    cases = load_cases()
    assert len(cases) == 2
    assert {c["stableCaseKey"] for c in cases} == set(KEYS.values())
    assert all(c["outcome"] == "not-run" and c["featureSha256"] == FEATURE_SHA256 for c in cases)
    assert all(len(c["steps"]) == 6 and all(s["outcome"] == "not-run" for s in c["steps"]) for c in cases)
    assert not issubclass(PackageAdmissionArgumentError, PackageAdmissionError)


@pytest.mark.parametrize("fault", ["duplicate", "unexpected", "setup", "outcome", "lifecycle", "feature", "budget"])
def test_changed_negative_budget_declarations_refuse(monkeypatch, fault):
    from tests.package_limit_configuration import cases as module

    original_inventory = module.inventory
    original = original_inventory([module.FIXTURE_SOURCE / module.FEATURE])
    altered = copy.deepcopy(original)
    if fault == "duplicate":
        altered[1] = altered[0]
    elif fault == "unexpected":
        altered[0]["stableCaseKey"] = "@id-other:{}"
    elif fault == "setup":
        altered[0]["steps"][0]["text"] = altered[0]["steps"][0]["text"].replace(FIXTURE, "fixture-other")
    elif fault == "outcome":
        altered[0]["steps"][4]["text"] = "resource-limit refusal"
    elif fault == "lifecycle":
        altered[0]["outcome"] = "passed"
    elif fault == "feature":
        altered[0]["featureSha256"] = "changed"
    else:
        altered[0]["examples"]["budget"] = "total bytes"
    monkeypatch.setattr(module, "inventory", lambda paths: altered)
    with pytest.raises(ValueError):
        module.load_cases()
