"""Bind only the sealed read-only XLSX comment/VML graph scenario."""

import hashlib

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xlsx/comment-vml-custody.feature"
FEATURE_SHA256 = "e93331bb775a8c84cd2ca0bf35264b8ef085f5ef9b44578e231c7ff0165e801d"
CASE_KEY = "@id-xlsx-comment-vml-existing-graph:{}"
FIXTURE_ID = "fixture-264be55e012d4bc2b3bf25e59824fdd30022e94f70869ea7d6ad960b803a902f"
STEPS = (
    f"fixture {FIXTURE_ID}",
    "a namespace-aware reader opens xl/worksheets/sheet1.xml and its relationship part",
    "the legacyDrawing relationship ID is anysvml and resolves internally to xl/drawings/commentsDrawing1.vml",
    "the corresponding relationship Type is http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing",
    "a separate comments relationship resolves internally to xl/comments/comment1.xml",
    "the comment part contains A2 with text This is the protagonist who creates the creature.",
    "the comment part contains A3 with text Often mistakenly called 'Frankenstein' - that is the creator's name.",
)


def load_cases():
    sealed = verified_metadata(FEATURE, "workflow")
    if hashlib.sha256(sealed).hexdigest() != FEATURE_SHA256:
        raise ValueError("Comment/VML feature differs from reviewed seal")
    cases = inventory([FIXTURE_SOURCE / FEATURE], scenario_ids=["@id-xlsx-comment-vml-existing-graph"])
    if len(cases) != 1:
        raise ValueError("Expected exactly one comment/VML scenario")
    case = cases[0]
    if (case["stableCaseKey"] != CASE_KEY
            or case["scenarioId"] != "@id-xlsx-comment-vml-existing-graph"
            or case["examples"] != {} or case["featureSha256"] != FEATURE_SHA256
            or case["outcome"] != "planned"
            or [s["type"] for s in case["steps"]] != ["Context", "Action"] + ["Outcome"] * 5
            or [s["text"] for s in case["steps"]] != list(STEPS)
            or any(s["argument"] is not None or s["outcome"] != "planned" for s in case["steps"])):
        raise ValueError("Comment/VML input or outcomes differ from reviewed binding")
    case["outcome"] = "not-run"
    for step in case["steps"]:
        step["outcome"] = "not-run"
    return cases
