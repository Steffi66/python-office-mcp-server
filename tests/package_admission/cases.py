"""Decode canonical package cases and match exact reviewed native setup/outcomes."""

import hashlib
import json
import re

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY, verified_metadata

FEATURES = tuple("workflows/package/" + name + ".feature" for name in
                 ("zip-admission", "xml-member-admission", "semantic-diff"))
MAPPING = REPOSITORY / "docs/catalogue-staging/mappings/python/package-admission.json"
NATIVE = "tests/test_package_guard.py"
IMPLEMENTATIONS = ("tools/package_guard.py", "tools/package_preservation.py")
DEFAULT_ACTION = "the package admission guard checks the archive with default limits"
REFUSAL = "package admission is refused"
DIFF_ACTION = "the semantic package diff compares original and modified packages"
DIFF_ID = "@id-package-diff-equivalent-xml-and-binary-changes"


def member(name, payload):
    return {"name": name, "payloadBytes": len(payload), "payloadSha256": hashlib.sha256(payload).hexdigest()}


def decode_case(case):
    """Return bounded setup and assertions, rejecting any unrecognised step."""
    steps = case["steps"]
    texts = [s["text"] for s in steps]
    if case["scenarioId"] == DIFF_ID:
        if ([s["type"] for s in steps] != ["Context", "Context", "Action", "Outcome", "Outcome", "Outcome", "Outcome"]
                or texts[:3] != ["the original ZIP_STORED package has these ordered UTF-8 members",
                                 "the modified ZIP_STORED package has these ordered UTF-8 members", DIFF_ACTION]
                or any(s.get("argument") for s in steps[2:])):
            raise ValueError("Unsupported semantic package diff steps")
        inputs = {"compression": "ZIP_STORED"}
        for key, step in zip(("original", "modified"), steps[:2]):
            rows = step.get("argument", {}).get("dataTable", {}).get("rows", [])
            if not rows or [c["value"] for c in rows[0]["cells"]] != ["member", "payload"]:
                raise ValueError("Invalid package member table")
            pairs = []
            for row in rows[1:]:
                if len(row["cells"]) != 2:
                    raise ValueError("Invalid package member row")
                pairs.append((row["cells"][0]["value"], row["cells"][1]["value"].encode("utf-8")))
            inputs[key] = pairs
        outcomes = {}
        for step, key in zip(steps[3:], ("equivalent_xml", "changed", "added", "removed")):
            prefix = f"the {key} member list is "
            if not step["text"].startswith(prefix):
                raise ValueError("Unknown package diff outcome")
            value = json.loads(step["text"][len(prefix):])
            if not isinstance(value, list) or not all(isinstance(v, str) for v in value):
                raise ValueError("Invalid package diff member list")
            outcomes[key] = value
        return inputs, outcomes

    if (len(steps) not in (3, 4) or [s["type"] for s in steps] != ["Context", "Action"] + ["Outcome"] * (len(steps) - 2)
            or any(s.get("argument") for s in steps) or texts[2] != REFUSAL):
        raise ValueError("Unsupported package admission steps")
    setup = texts[0]
    inputs = {"compression": "ZIP_STORED"}
    prefix = "an ordered ZIP_STORED archive has member pairs encoded as JSON "
    if setup.startswith(prefix):
        rows = json.loads(setup[len(prefix):])
        if not isinstance(rows, list) or not all(isinstance(r, list) and len(r) == 2 and all(isinstance(v, str) for v in r) for r in rows):
            raise ValueError("Invalid ordered package member pairs")
        inputs["members"] = [(name, value.encode("utf-8")) for name, value in rows]
    elif setup == "a ZIP_DEFLATED archive contains a.xml with UTF-8 XML enclosing exactly 10000 spaces between <a> and </a>":
        inputs.update(compression="ZIP_DEFLATED", members=[("a.xml", b"<a>" + b" " * 10000 + b"</a>")])
    elif setup.startswith("a ZIP_BZIP2 archive contains a.xml with UTF-8 text "):
        inputs.update(compression="ZIP_BZIP2", members=[("a.xml", setup.removeprefix("a ZIP_BZIP2 archive contains a.xml with UTF-8 text ").encode("utf-8"))])
    else:
        match = re.fullmatch(r"a ZIP_STORED archive contains a.xml with (UTF-8|UTF-16 with BOM) text (.*)", setup)
        if not match:
            raise ValueError("Unknown package admission setup")
        encoding, text = match.groups()
        # The reviewed native observation is little-endian BOM, independent of host byte order.
        payload = text.encode("utf-8") if encoding == "UTF-8" else b"\xff\xfe" + text.encode("utf-16-le")
        inputs.update(encoding=encoding, members=[("a.xml", payload)])
    if texts[1] != DEFAULT_ACTION:
        match = re.fullmatch(r"the package admission guard checks the archive with only (max_members|max_member_bytes|max_total_bytes|max_ratio) set to ([0-9]+)", texts[1])
        if not match:
            raise ValueError("Unknown package admission action")
        inputs["limits"] = {match[1]: int(match[2])}
    outcomes = {"pythonException": "PackageAdmissionError"}
    if len(steps) == 4:
        if texts[3] != "the admission error contains compression":
            raise ValueError("Unknown package admission error assertion")
        outcomes["messageContains"] = "compression"
    return inputs, outcomes


def input_signature(inputs):
    return {key: [member(name, payload) for name, payload in value] if key in {"members", "original", "modified"} else value
            for key, value in inputs.items()}


def mapped_signature(inputs):
    result = {}
    for key, value in inputs.items():
        if key in {"members", "original", "modified"}:
            records = []
            for row in value:
                payload = bytes.fromhex(row["payloadHex"])
                if hashlib.sha256(payload).hexdigest() != row["payloadSha256"]:
                    raise ValueError("Reviewed package payload hash mismatch")
                records.append(member(row["name"], payload))
            result[key] = records
        else:
            result[key] = value
    return result


def validate_cases(cases, mapping, source_digest, implementation_hashes):
    if (mapping.get("sourcePath") != NATIVE or mapping.get("sourceSha256") != source_digest
            or mapping.get("implementationHashes") != implementation_hashes):
        raise ValueError("Reviewed native package source or implementation changed")
    feature_hashes = mapping.get("featureSha256", {})
    if set(feature_hashes) != set(FEATURES):
        raise ValueError("Unexpected package feature seals")
    sealed_paths = {str(FIXTURE_SOURCE / relative): feature_hashes[relative] for relative in FEATURES}
    if any(case["feature"] not in sealed_paths or case["featureSha256"] != sealed_paths[case["feature"]]
           for case in cases):
        raise ValueError("Package feature declarations differ from reviewed seals")
    rows = mapping.get("mapping", [])
    if len(rows) != 14 or len({row["nativeId"] for row in rows}) != 4:
        raise ValueError("Expected four native package declarations and fourteen variants")
    expected = {(r["proposedScenarioId"], r["variant"]): r for r in rows}
    reviewed_keys = mapping.get("reviewedCaseKeys")
    unbound = mapping.get("unboundPlannedCase")
    if (len(expected) != 14 or len(rows) != 14 or not isinstance(reviewed_keys, list)
            or len(reviewed_keys) != 14 or len(set(reviewed_keys)) != 14
            or not isinstance(unbound, dict) or set(unbound) != {"scenarioId", "stableCaseKey", "feature"}
            or unbound != {"scenarioId": "@id-zip-physical-member-overlap-refusal",
                           "stableCaseKey": "@id-zip-physical-member-overlap-refusal:{}",
                           "feature": "workflows/package/zip-admission.feature"}):
        raise ValueError("Missing or unexpected reviewed/unbound package mapping")
    keys = [(c["scenarioId"], c["name"]) for c in cases]
    stable_keys = [c["stableCaseKey"] for c in cases]
    if (len(cases) != 15 or len(set(keys)) != 15 or len(set(stable_keys)) != 15
            or len({c["scenarioId"] for c in cases}) != 6):
        raise ValueError("Missing, duplicate or unexpected package variants")
    reviewed = [c for c in cases if (c["scenarioId"], c["name"]) in expected]
    excluded = [c for c in cases if (c["scenarioId"], c["name"]) not in expected]
    if (len(reviewed) != 14 or set(c["stableCaseKey"] for c in reviewed) != set(reviewed_keys)
            or len(excluded) != 1 or excluded[0]["scenarioId"] != unbound["scenarioId"]
            or excluded[0]["stableCaseKey"] != unbound["stableCaseKey"]
            or excluded[0]["feature"] != str(FIXTURE_SOURCE / unbound["feature"])
            or excluded[0]["outcome"] != "planned"
            or any(step["outcome"] != "planned" for step in excluded[0]["steps"])):
        raise ValueError("Unreviewed package case is not the single sealed planned overlap")
    for case in reviewed:
        if case["outcome"] != "planned":
            raise ValueError("Package declarations cannot supply execution credit")
        inputs, outcomes = decode_case(case)
        row = expected[(case["scenarioId"], case["name"])]
        if input_signature(inputs) != mapped_signature(row["inputs"]) or outcomes != row["expectedOutcomes"]:
            raise ValueError("Canonical package setup or outcomes differ from reviewed native assertions")
        case["outcome"] = "not-run"
        for step in case["steps"]:
            step["outcome"] = "not-run"
    return reviewed


def load_cases():
    cases = []
    mapping = json.loads(MAPPING.read_text())
    for relative in FEATURES:
        sealed = verified_metadata(relative, "workflow")
        if mapping["featureSha256"].get(relative) != hashlib.sha256(sealed).hexdigest():
            raise ValueError("Canonical package feature differs from reviewed source")
        compiled = inventory([FIXTURE_SOURCE / relative])
        if any(c["featureSha256"] != hashlib.sha256(sealed).hexdigest() for c in compiled):
            raise ValueError("Package feature changed during inventory")
        cases.extend(compiled)
    source_digest = hashlib.sha256((REPOSITORY / NATIVE).read_bytes()).hexdigest()
    implementation_hashes = {p: hashlib.sha256((REPOSITORY / p).read_bytes()).hexdigest() for p in IMPLEMENTATIONS}
    return validate_cases(cases, mapping, source_digest, implementation_hashes)
