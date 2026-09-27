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


def inventory(paths, *, scenario_ids=None):
    """Compile sealed features; select only contract IDs when files contain other work."""
    selected = None if scenario_ids is None else set(scenario_ids)
    if selected is not None and (len(selected) != len(scenario_ids) or not selected):
        raise ValueError("Invalid selected scenario IDs")
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
        children = []
        for child in feature["children"]:
            if "scenario" in child:
                children.append(child)
            elif "rule" in child:
                children.extend(child["rule"]["children"])
            else:
                raise ValueError("Unsupported feature child")
        for child in children:
            if "scenario" not in child:
                raise ValueError("Only scenarios are supported in this acceptance lane")
            scenario = child["scenario"]
            if any(t["name"] in {"@implemented", "@planned", "@python"} for t in scenario["tags"]):
                raise ValueError("Scenario cannot override lifecycle or runner")
            ids = [t["name"] for t in scenario["tags"] if t["name"].startswith("@id-")]
            if len(ids) != 1 or ids[0] in seen_ids:
                raise ValueError("Missing or duplicate scenario ID")
            seen_ids.add(ids[0])
            if not scenario["name"].strip() or scenario["name"] in names:
                raise ValueError("Empty or duplicate scenario name")
            names.add(scenario["name"])
            if selected is None or ids[0] in selected:
                scenarios.append(scenario)
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
            ids = [t["name"] for t in case["tags"] if t["name"].startswith("@id-")]
            if len(ids) != 1:
                raise ValueError("Case overrides scenario identity")
            if selected is not None and ids[0] not in selected:
                continue
            for step in case["steps"]:
                table = step.get("argument", {}).get("dataTable", {}).get("rows", [])
                if table:
                    header = [c["value"] for c in table[0]["cells"]]
                    if "value_json" in header:
                        column = header.index("value_json")
                        for row in table[1:]:
                            json.loads(row["cells"][column]["value"])
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
    if selected is not None and {c["scenarioId"] for c in cases} != selected:
        raise ValueError("Selected mutation scenarios are missing from sealed features")
    return cases


def apply_implementation_mapping(cases, mapping, *, feature_path=None, feature_paths=None, contract=None):
    """Select locally implemented cases without granting credit from other runners."""
    if mapping.get("consumer") != "python" or mapping.get("contractRevision") != "ooxml-shared-contracts-v2":
        raise ValueError("Invalid Python implementation mapping")
    if mapping.get("schemaVersion") == 1:
        if (feature_path is None or feature_paths is not None
                or (contract is not None and contract.get("schemaVersion") != 1)):
            raise ValueError("Schema-1 mapping requires its released feature")
        if mapping.get("feature") != "workflows/mutation-safety.feature" or "features" in mapping:
            raise ValueError("Unexpected mapped feature")
        digest = hashlib.sha256(Path(feature_path).read_bytes()).hexdigest()
        if mapping.get("featureSha256") != digest or any(c["featureSha256"] != digest for c in cases):
            raise ValueError("Mapped feature hash mismatch")
    elif mapping.get("schemaVersion") == 2:
        if (contract is None or contract.get("schemaVersion") != 2 or feature_paths is None
                or feature_path is not None or "feature" in mapping or "featureSha256" in mapping):
            raise ValueError("Schema-2 mapping requires its feature set")
        names = contract["features"]
        records = mapping.get("features")
        if (not isinstance(records, list) or len(records) != len(names)
                or [r.get("path") for r in records if isinstance(r, dict)] != names
                or len(feature_paths) != len(names)):
            raise ValueError("Mapped feature paths differ from mutation contract")
        digests = {}
        for name, record, path in zip(names, records, feature_paths):
            if Path(path).as_posix().endswith('/' + name) is False:
                raise ValueError("Mapped feature path mismatch")
            digest = hashlib.sha256(Path(path).read_bytes()).hexdigest()
            if record.get("sha256") != digest:
                raise ValueError("Mapped feature hash mismatch")
            digests[str(path)] = digest
        if any(c["featureSha256"] != digests.get(c["feature"]) for c in cases):
            raise ValueError("Mapped case feature hash mismatch")
        if ({c["scenarioId"] for c in cases} != set(contract["scenarioIds"])
                or len(cases) != contract["expandedCaseCount"]
                or set(digests) != {c["feature"] for c in cases}):
            raise ValueError("Mapped mutation case inventory mismatch")
    else:
        raise ValueError("Unsupported Python mapping schema")
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
