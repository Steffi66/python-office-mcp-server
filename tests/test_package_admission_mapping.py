"""A canonical package declaration cannot infer passes or hide native-input drift."""

import hashlib
import json

import pytest

from tests.acceptance.ledger import Ledger, inventory
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY
from tests.package_admission.cases import (
    FEATURES,
    IMPLEMENTATIONS,
    MAPPING,
    NATIVE,
    decode_case,
    validate_cases,
)


def inputs():
    cases = inventory([FIXTURE_SOURCE / path for path in FEATURES])
    mapping = json.loads(MAPPING.read_text())
    source_hash = hashlib.sha256((REPOSITORY / NATIVE).read_bytes()).hexdigest()
    implementation = {p: hashlib.sha256((REPOSITORY / p).read_bytes()).hexdigest() for p in IMPLEMENTATIONS}
    return cases, mapping, source_hash, implementation


def test_reviewed_package_mapping_marks_not_run_only(tmp_path):
    cases = validate_cases(*inputs())
    assert len(cases) == 14
    assert set(c["stableCaseKey"] for c in cases) == set(json.loads(MAPPING.read_text())["reviewedCaseKeys"])
    assert all(c["outcome"] == "not-run" for c in cases)
    assert all(s["outcome"] == "not-run" for c in cases for s in c["steps"])
    ledger = Ledger(tmp_path / "evidence.json")
    ledger.report["inventory"] = cases
    ledger.finish(0)
    assert ledger.report["outcome"] == "incomplete-or-failed"


@pytest.mark.parametrize("fault", ["source", "implementation", "missing", "duplicate", "lifecycle", "input", "order", "limit", "encoding", "compression", "action", "outcome", "payload-hash", "unexpected-id", "reviewed-key", "unbound-key", "unbound-lifecycle", "unbound-missing", "feature-sha"])
def test_changed_package_declarations_refuse(fault):
    cases, mapping, source, implementation = inputs()
    if fault == "source":
        source = "changed"
    elif fault == "implementation":
        implementation[IMPLEMENTATIONS[0]] = "changed"
    elif fault == "missing":
        cases.pop()
    elif fault == "duplicate":
        cases[1] = cases[0]
    elif fault == "lifecycle":
        cases[0]["outcome"] = "passed"
    elif fault in {"input", "order"}:
        case = next(c for c in cases if c["name"] == "ZIP admission refuses duplicate member names")
        pairs = [["a.xml", "<b/>"], ["a.xml", "<a/>"]] if fault == "order" else [["a.xml", "changed"], ["a.xml", "<b/>"]]
        case["steps"][0]["text"] = "an ordered ZIP_STORED archive has member pairs encoded as JSON " + json.dumps(pairs)
    elif fault == "limit":
        case = next(c for c in cases if "max_members" in c["name"])
        case["steps"][1]["text"] = case["steps"][1]["text"].replace("set to 0", "set to 1")
    elif fault == "encoding":
        case = next(c for c in cases if "UTF-16 DTD" in c["name"])
        case["steps"][0]["text"] = case["steps"][0]["text"].replace("UTF-16 with BOM", "UTF-8")
    elif fault == "compression":
        case = next(c for c in cases if "BZIP2" in c["name"])
        case["steps"][0]["text"] = case["steps"][0]["text"].replace("ZIP_BZIP2", "ZIP_STORED")
    elif fault == "action":
        cases[0]["steps"][1]["text"] = "unknown operation"
    elif fault == "outcome":
        case = next(c for c in cases if "Prefix-only" in c["name"])
        case["steps"][-1]["text"] = 'the removed member list is ["missing.bin"]'
    elif fault == "unexpected-id":
        case = next(c for c in cases if c["scenarioId"] == "@id-zip-physical-member-overlap-refusal")
        case["scenarioId"] = "@id-unexpected"
    elif fault == "reviewed-key":
        cases[0]["stableCaseKey"] = "@id-package-admission-unsafe-members:{}"
    elif fault == "unbound-key":
        case = next(c for c in cases if c["scenarioId"] == "@id-zip-physical-member-overlap-refusal")
        case["stableCaseKey"] = "@id-zip-physical-member-overlap-refusal:{\"variant\":\"other\"}"
    elif fault == "unbound-lifecycle":
        case = next(c for c in cases if c["scenarioId"] == "@id-zip-physical-member-overlap-refusal")
        case["outcome"] = "passed"
    elif fault == "unbound-missing":
        mapping["unboundPlannedCase"]["stableCaseKey"] = "missing"
    elif fault == "feature-sha":
        mapping["featureSha256"]["workflows/package/zip-admission.feature"] = "bad"
    else:
        mapping["mapping"][0]["inputs"]["members"][0]["payloadSha256"] = "bad"
    with pytest.raises(ValueError):
        validate_cases(cases, mapping, source, implementation)


def test_only_sealed_overlap_case_is_unbound():
    cases, mapping, source, implementation = inputs()
    overlap = next(c for c in cases if c["scenarioId"] == "@id-zip-physical-member-overlap-refusal")
    assert overlap["stableCaseKey"] == mapping["unboundPlannedCase"]["stableCaseKey"]
    assert overlap["outcome"] == "planned"
    assert all(step["outcome"] == "planned" for step in overlap["steps"])
    assert overlap not in validate_cases(cases, mapping, source, implementation)
    assert overlap["outcome"] == "planned"
    assert all(step["outcome"] == "planned" for step in overlap["steps"])


def test_canonical_utf16_bytes_are_explicit_little_endian_with_bom():
    cases, _, _, _ = inputs()
    case = next(c for c in cases if "UTF-16 DTD" in c["name"])
    setup, _ = decode_case(case)
    assert setup["members"] == [("a.xml", b"\xff\xfe" + "<!DOCTYPE a><a/>".encode("utf-16-le"))]
