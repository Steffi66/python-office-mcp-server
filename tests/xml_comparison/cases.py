"""Compile the canonical feature and require exact agreement with reviewed native inputs."""

import hashlib
import json

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY, verified_metadata

FEATURE_PATH = "workflows/xml/comparison.feature"
FEATURE = FIXTURE_SOURCE / FEATURE_PATH
MAPPING = REPOSITORY / "docs/catalogue-staging/mappings/python/xml-comparison.json"
WHEN = "the conservative XML comparator compares their UTF-8 bytes"


def validate_cases(cases, mapping, source_digest, implementation_digest):
    """A declaration permits local execution; only assertions can mark it passed."""
    if (mapping.get("sourcePath") != "tests/test_package_preservation.py"
            or mapping.get("sourceSha256") != source_digest
            or mapping.get("implementationPath") != "tools/package_preservation.py"
            or mapping.get("implementationSha256") != implementation_digest):
        raise ValueError("Reviewed native XML source has changed; reconcile its mapping")
    rows = mapping.get("mapping", [])
    if len(rows) != 5 or len({r["nativeId"] for r in rows}) != 5:
        raise ValueError("Expected five unique native comparison declarations")
    expected = {}
    for row in rows:
        for variant in row["variants"]:
            key = (row["proposedScenarioId"], variant["name"])
            if key in expected:
                raise ValueError("Duplicate mapped XML variant")
            expected[key] = variant
    if len(expected) != 10 or len(cases) != 10:
        raise ValueError("Expected exactly ten canonical comparison variants")
    actual_keys = {(case["scenarioId"], case["name"]) for case in cases}
    if len(actual_keys) != 10 or actual_keys != set(expected):
        raise ValueError("Canonical and native XML variant identities differ")
    for case in cases:
        expected_case = expected[(case["scenarioId"], case["name"])]
        steps = case["steps"]
        if (case["outcome"] != "planned" or len(steps) != 4
                or [step["type"] for step in steps] != ["Context", "Context", "Action", "Outcome"]
                or any(step.get("argument") for step in steps)):
            raise ValueError("Unsupported comparison lifecycle or step structure")
        phrases = ["the left XML is " + expected_case["leftUtf8"],
                   "the right XML is " + expected_case["rightUtf8"], WHEN,
                   "the comparison result is " + str(expected_case["expectedBoolean"]).lower()]
        if type(expected_case["expectedBoolean"]) is not bool or [s["text"] for s in steps] != phrases:
            raise ValueError("Canonical XML inputs, operation or result differ from native assertions")
        case["outcome"] = "not-run"
        for step in steps:
            step["outcome"] = "not-run"
    return cases


def load_cases():
    sealed = verified_metadata(FEATURE_PATH, "workflow")
    mapping = json.loads(MAPPING.read_text())
    digest = hashlib.sha256(sealed).hexdigest()
    if mapping.get("feature") != FEATURE_PATH or mapping.get("featureSha256") != digest:
        raise ValueError("Reviewed canonical XML feature identity or hash differs")
    cases = inventory([FEATURE])
    if any(case["featureSha256"] != digest for case in cases):
        raise ValueError("XML feature changed during inventory")
    source = (REPOSITORY / "tests/test_package_preservation.py").read_bytes()
    implementation = (REPOSITORY / "tools/package_preservation.py").read_bytes()
    return validate_cases(cases, mapping, hashlib.sha256(source).hexdigest(),
                          hashlib.sha256(implementation).hexdigest())
