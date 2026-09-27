"""Seal the single descriptor-signature collision scenario and its exact steps."""

import hashlib

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/package/data-descriptor-integrity.feature"
FEATURE_SHA256 = "c0c855a3f4dd74e15fd59aa03572bb7f8c752544fd9bb64b6f082e14388c9370"
CASE_KEY = "@id-zip-unsigned-descriptor-signature-collision:{}"
STEPS = (
    'a single-disk ZIP32 archive has one DEFLATED data.bin member with declared size 7 and stored payload "payload"',
    'its unsigned twelve-byte data descriptor and central directory both declare CRC32 08074B50, equal to the optional descriptor signature value',
    'independent CRC32 of the decompressed payload differs from 08074B50',
    'ZIP admission validates the descriptor shape and then opens the archive with default bounds',
    'the unsigned descriptor is recognised as twelve bytes without borrowing a four-byte signature or central-directory bytes',
    'complete admission refuses the corrupt payload as a CRC or invalid-package failure, not as an ambiguous descriptor-shape failure',
    'no package or member payloads are delivered',
    "the caller's original archive bytes remain unchanged",
)


def load_cases():
    sealed = verified_metadata(FEATURE, "workflow")
    if hashlib.sha256(sealed).hexdigest() != FEATURE_SHA256:
        raise ValueError("Descriptor integrity feature differs from reviewed seal")
    cases = inventory([FIXTURE_SOURCE / FEATURE])
    if len(cases) != 1:
        raise ValueError("Expected one sealed descriptor case")
    case = cases[0]
    if (case["stableCaseKey"] != CASE_KEY or case["scenarioId"] != "@id-zip-unsigned-descriptor-signature-collision"
            or case["examples"] != {} or case["featureSha256"] != FEATURE_SHA256
            or case["outcome"] != "planned" or len(case["steps"]) != len(STEPS)
            or [step["type"] for step in case["steps"]] != ["Context"] * 3 + ["Action"] + ["Outcome"] * 4
            or [step["text"] for step in case["steps"]] != list(STEPS)
            or any(step["argument"] is not None or step["outcome"] != "planned" for step in case["steps"])):
        raise ValueError("Descriptor input or outcome changed from reviewed binding")
    case["outcome"] = "not-run"
    for step in case["steps"]:
        step["outcome"] = "not-run"
    return cases
