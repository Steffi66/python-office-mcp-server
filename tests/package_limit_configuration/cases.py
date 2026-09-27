"""Fail-closed binding for the two direct negative-budget admission cases."""

import hashlib
import json

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY, verified_metadata

FEATURE = "workflows/package/admission-limit-configuration.feature"
FEATURE_SHA256 = "885083126a39d17a795609bbf5d2e273678b5d8613af9cafdc0fac46396adb8a"
SCENARIO = "@id-package-admission-negative-budget"
FIXTURE = "fixture-d9d6a313182a71a73d75a26a0ff3b7826dbd2e300e1d202114ec9f8fb018fda5"
KEYS = {
    "source bytes": '@id-package-admission-negative-budget:{"budget":"source bytes"}',
    "entry count": '@id-package-admission-negative-budget:{"budget":"entry count"}',
}
STEP_TEXT = (
    f"the byte-sealed valid DOCX archive {FIXTURE} and a separate caller byte snapshot",
    "only the {budget} admission budget is set to -1",
    "bounded package admission checks that archive",
    "it refuses the invalid caller budget before reading source metadata or ZIP members and returns no package or parts",
    "the refusal is an invalid-argument result, not a resource-limit or malformed-archive result",
    "the caller's archive bytes remain unchanged",
)
IMPLEMENTATION = REPOSITORY / "tools/package_guard.py"


def load_cases():
    sealed = verified_metadata(FEATURE, "workflow")
    if hashlib.sha256(sealed).hexdigest() != FEATURE_SHA256:
        raise ValueError("Admission budget feature differs from reviewed seal")
    cases = inventory([FIXTURE_SOURCE / FEATURE])
    if (len(cases) != 2 or {c["scenarioId"] for c in cases} != {SCENARIO}
            or {c["stableCaseKey"] for c in cases} != set(KEYS.values())
            or {c["examples"].get("budget") for c in cases} != set(KEYS)
            or any(c["outcome"] != "planned" or c["featureSha256"] != FEATURE_SHA256 for c in cases)):
        raise ValueError("Unexpected negative-budget case identity")
    for case in cases:
        budget = case["examples"]["budget"]
        if (case["stableCaseKey"] != KEYS[budget] or len(case["steps"]) != len(STEP_TEXT)
                or [s["type"] for s in case["steps"]] != ["Context", "Context", "Action", "Outcome", "Outcome", "Outcome"]
                or [s["text"] for s in case["steps"]] != [text.format(budget=budget) for text in STEP_TEXT]
                or any(step["outcome"] != "planned" or step["argument"] is not None for step in case["steps"])):
            raise ValueError("Negative-budget preconditions or outcomes differ from reviewed binding")
        case["outcome"] = "not-run"
        for step in case["steps"]:
            step["outcome"] = "not-run"
    return cases
