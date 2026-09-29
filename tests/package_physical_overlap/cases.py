"""Seal one canonical ZIP32 physical-overlap refusal without extending other profiles."""

import hashlib

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/package/zip-admission.feature"
FEATURE_SHA256 = "8fa7b8618fd9797e3470dfdfa1132b76784f180fe31d344f1d9d758f5c30f09c"
CASE_KEY = "@id-zip-physical-member-overlap-refusal:{}"
FIXTURE_ID = "fixture-9286fc07c3f8698f9637cf9b7a0c60461d1f304753ba69b39f655c8c348ea027"
STEPS = (
    f"fixture {FIXTURE_ID} has exactly three distinct STORED members [Content_Types].xml, outer.bin and inner.bin",
    "an independent ZIP reader opens all three members with declared lengths 149, 49 and 10 bytes and matching CRC32 d694f44a, 32c80458 and 4daa6380",
    "inner.bin's complete local header and payload lie within outer.bin's physical payload range in this ZIP32 single-disk archive",
    "bounded package admission checks the unchanged archive with max entries 4 and max total bytes 4096",
    "admission refuses overlapping physical member extents as an invalid package, not a name, CRC or resource refusal",
    "no package session or output archive is delivered",
    "the caller's source buffer remains byte-identical to the sealed fixture",
)


def load_cases():
    sealed = verified_metadata(FEATURE, "workflow")
    if hashlib.sha256(sealed).hexdigest() != FEATURE_SHA256:
        raise ValueError("Physical-overlap feature differs from reviewed seal")
    cases = [case for case in inventory([FIXTURE_SOURCE / FEATURE]) if case["scenarioId"] == "@id-zip-physical-member-overlap-refusal"]
    if len(cases) != 1:
        raise ValueError("Expected one sealed physical-overlap case")
    case = cases[0]
    if (case["stableCaseKey"] != CASE_KEY or case["examples"] != {}
            or case["featureSha256"] != FEATURE_SHA256 or case["outcome"] != "planned"
            or len(case["steps"]) != len(STEPS)
            or [step["type"] for step in case["steps"]] != ["Context"] * 3 + ["Action"] + ["Outcome"] * 3
            or [step["text"] for step in case["steps"]] != list(STEPS)
            or any(step["argument"] is not None or step["outcome"] != "planned" for step in case["steps"])):
        raise ValueError("Physical-overlap steps changed from reviewed binding")
    case["outcome"] = "not-run"
    for step in case["steps"]:
        step["outcome"] = "not-run"
    return cases
