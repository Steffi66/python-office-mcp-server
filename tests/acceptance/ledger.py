"""Inventory and fail-closed per-step evidence for the pytest-bdd acceptance lane."""

import hashlib
import json
import uuid
from datetime import datetime, timezone
from pathlib import Path

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler


def now():
    return datetime.now(timezone.utc).isoformat()


def inventory(paths):
    cases = []
    seen_ids = set()
    seen_features = set()
    for path in paths:
        text = Path(path).read_text()
        document = Parser().parse(text)
        document["uri"] = str(path)
        feature = document["feature"]
        if not feature["name"].strip() or feature["name"] in seen_features:
            raise ValueError("Empty or duplicate feature name")
        seen_features.add(feature["name"])
        tags = {t["name"] for t in feature["tags"]}
        if tags not in ({"@planned"}, {"@implemented", "@python"}):
            raise ValueError("Invalid lifecycle tags")
        planned = "@planned" in tags
        rows = {}
        names = set()
        scenarios = []
        for child in feature["children"]:
            if "scenario" not in child:
                raise ValueError("Only direct scenarios are supported in this acceptance lane")
            scenario = child["scenario"]
            scenarios.append(scenario)
            if any(t["name"] in {"@implemented", "@planned", "@python"} for t in scenario["tags"]):
                raise ValueError("Scenario cannot override lifecycle or runner")
            ids = [t["name"] for t in scenario["tags"] if t["name"].startswith("@id-")]
            if len(ids) != 1 or ids[0] in seen_ids:
                raise ValueError("Missing or duplicate scenario ID")
            seen_ids.add(ids[0])
            if not scenario["name"].strip() or scenario["name"] in names:
                raise ValueError("Empty or duplicate scenario name")
            names.add(scenario["name"])
            if not scenario["steps"] or not any(s["keywordType"] == "Outcome" for s in scenario["steps"]):
                raise ValueError("Scenario needs at least one outcome assertion")
            for examples in scenario["examples"]:
                if any(t["name"] in {"@implemented", "@planned", "@python"} or t["name"].startswith("@id-") for t in examples["tags"]):
                    raise ValueError("Examples cannot override identity, lifecycle or runner")
                header = [c["value"] for c in examples["tableHeader"]["cells"]]
                if not all(header) or len(set(header)) != len(header):
                    raise ValueError("Invalid example headers")
                for row in examples["tableBody"]:
                    rows[row["id"]] = dict(zip(header, [c["value"] for c in row["cells"]]))
        compiled = Compiler().compile(document)
        if not compiled:
            raise ValueError("Feature has no executable cases")
        for scenario in scenarios:
            if not any(scenario["id"] in c["astNodeIds"] for c in compiled):
                raise ValueError("Scenario has no compiled cases")
        if len({c["name"] for c in compiled}) != len(compiled):
            raise ValueError("Duplicate expanded case name")
        for case in compiled:
            for step in case["steps"]:
                table = step.get("argument", {}).get("dataTable", {}).get("rows", [])
                if table:
                    header = [c["value"] for c in table[0]["cells"]]
                    if "value_json" in header:
                        column = header.index("value_json")
                        for row in table[1:]:
                            json.loads(row["cells"][column]["value"])
            ids = [t["name"] for t in case["tags"] if t["name"].startswith("@id-")]
            if len(ids) != 1:
                raise ValueError("Case overrides scenario identity")
            values = next((rows[i] for i in case["astNodeIds"] if i in rows), {})
            stable_key = ids[0] + ":" + json.dumps(values, sort_keys=True, separators=(",", ":"))
            cases.append({
                "scenarioId": ids[0], "stableCaseKey": stable_key, "name": case["name"],
                "examples": values, "feature": str(path),
                "featureSha256": hashlib.sha256(text.encode()).hexdigest(),
                "outcome": "planned" if planned else "not-run",
                "steps": [{"text": s["text"], "type": s["type"], "argument": s.get("argument"),
                           "outcome": "planned" if planned else "not-run"} for s in case["steps"]],
            })
    if len({c["stableCaseKey"] for c in cases}) != len(cases):
        raise ValueError("Duplicate expanded case identity")
    return cases


def apply_implementation_mapping(cases, mapping, *, feature_path):
    """Select locally implemented cases without granting credit from other runners."""
    if mapping.get("schemaVersion") != 1 or mapping.get("consumer") != "python":
        raise ValueError("Invalid Python implementation mapping")
    if mapping.get("contractRevision") != "ooxml-shared-contracts-v2":
        raise ValueError("Unexpected mapped contract revision")
    if mapping.get("feature") != "workflows/mutation-safety.feature":
        raise ValueError("Unexpected mapped feature")
    digest = hashlib.sha256(Path(feature_path).read_bytes()).hexdigest()
    if mapping.get("featureSha256") != digest or any(c["featureSha256"] != digest for c in cases):
        raise ValueError("Mapped feature hash mismatch")
    keys = mapping.get("implementedCaseKeys")
    if not isinstance(keys, list) or not all(isinstance(k, str) for k in keys) or len(keys) != len(set(keys)):
        raise ValueError("Invalid or duplicate mapped case identities")
    if not set(keys).issubset({c["stableCaseKey"] for c in cases}):
        raise ValueError("Mapped case absent from shared inventory")
    for case in cases:
        if case["stableCaseKey"] in keys:
            case["outcome"] = "not-run"
            for step in case["steps"]:
                step["outcome"] = "not-run"


def binding_matches(step, contexts):
    # pytest-bdd resolves by fixture scope. For this dedicated lane ambiguous steps
    # are prohibited even if fixture precedence could choose one implicitly.
    return [c for c in contexts if (c.type is None or c.type == step.type) and c.parser.is_matching(step.name)]


class Ledger:
    def __init__(self, path):
        self.path = Path(path)
        self.report = {"schemaVersion": 1, "runId": str(uuid.uuid4()), "startedAt": now(),
                       "outcome": "running", "inventory": [], "failures": []}
        self.write()  # Reset stale success before parsing/collection can fail.

    def write(self):
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(".tmp")
        tmp.write_text(json.dumps(self.report, indent=2, default=str) + "\n")
        tmp.replace(self.path)

    def finish(self, exitstatus):
        cases = self.report["inventory"]
        all_passed = bool(cases) and all(
            c["outcome"] == "passed" and c["steps"] and all(s["outcome"] == "passed" for s in c["steps"])
            for c in cases
        )
        self.report.update(finishedAt=now(), outcome="passed" if exitstatus == 0 and all_passed else "incomplete-or-failed")
        self.write()
