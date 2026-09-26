"""XML declarations cannot grant passes or hide missing/changed comparison variants."""

import copy

import pytest

from tests.acceptance.ledger import Ledger
from tests.xml_comparison.cases import WHEN, validate_cases


def inputs():
    mapping = {"sourcePath": "tests/test_package_preservation.py", "sourceSha256": "source",
               "implementationPath": "tools/package_preservation.py", "implementationSha256": "implementation", "mapping": []}
    cases = []
    for number in range(5):
        scenario_id = f"@id-xml-comparison-{number}"
        variants = []
        for index in range(2):
            name = f"Comparison {number}/{index}"
            variants.append({"name": name, "leftUtf8": "<a/>", "rightUtf8": "<a/>", "expectedBoolean": True})
            steps = [{"type": kind, "text": text, "outcome": "planned"} for kind, text in [
                ("Context", "the left XML is <a/>"), ("Context", "the right XML is <a/>"),
                ("Action", WHEN), ("Outcome", "the comparison result is true")]]
            cases.append({"scenarioId": scenario_id, "name": name, "outcome": "planned", "steps": steps})
        mapping["mapping"].append({"nativeId": f"test_native_{number}", "proposedScenarioId": scenario_id, "variants": variants})
    return cases, mapping


def test_reviewed_mapping_only_marks_cases_not_run(tmp_path):
    cases, mapping = inputs()
    selected = validate_cases(cases, mapping, "source", "implementation")
    assert len(selected) == 10
    assert all(case["outcome"] == "not-run" for case in selected)
    assert all(step["outcome"] == "not-run" for case in selected for step in case["steps"])
    report = Ledger(tmp_path / "report.json")
    report.report["inventory"] = selected
    report.finish(0)
    assert report.report["outcome"] == "incomplete-or-failed"


@pytest.mark.parametrize("fault", ["source", "implementation", "missing-case", "duplicate-case", "duplicate-native", "duplicate-variant", "input", "action", "result", "lifecycle"])
def test_changed_or_ambiguous_xml_declarations_refuse(fault):
    cases, mapping = copy.deepcopy(inputs())
    if fault in {"source", "implementation"}:
        mapping["sourceSha256" if fault == "source" else "implementationSha256"] = "changed"
    elif fault == "missing-case":
        cases.pop()
    elif fault == "duplicate-case":
        cases[1] = copy.deepcopy(cases[0])
    elif fault == "duplicate-native":
        mapping["mapping"][1]["nativeId"] = mapping["mapping"][0]["nativeId"]
    elif fault == "duplicate-variant":
        mapping["mapping"][0]["variants"].append(copy.deepcopy(mapping["mapping"][0]["variants"][0]))
    elif fault == "lifecycle":
        cases[0]["outcome"] = "passed"
    else:
        index = {"input": 0, "action": 2, "result": 3}[fault]
        cases[0]["steps"][index]["text"] = "changed"
    with pytest.raises(ValueError):
        validate_cases(cases, mapping, "source", "implementation")
