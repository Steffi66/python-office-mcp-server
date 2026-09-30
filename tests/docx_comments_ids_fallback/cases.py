"""Seal the one authored commentsIds paragraph-ID fallback case."""

import hashlib

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/docx/comments.feature"
FEATURE_SHA256 = "e1bcda50084acdc4231dc97273da5ae4194f90fa72dbb9a394fda343447001f0"
CASE_ID = "@id-python-comments-ids-fallback"
CASE_KEY = CASE_ID + ":{}"
STEPS = (
    'a saved Word document has paragraph "Legacy mapping target" and an authored comment "Legacy style comment"',
    "its comment's first paragraph has no w14:paraId",
    'word/commentsIds.xml maps that comment ID to para ID "0F0E0D0C"',
    'Word comments are read from the modified saved package',
    'that comment\'s returned para_id equals "0F0E0D0C"',
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("Word comment feature differs from reviewed fixture provenance")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    matches = [(rule["rule"], child["scenario"])
               for rule in feature["children"] if "rule" in rule
               for child in rule["rule"]["children"] if "scenario" in child
               and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(matches) != 1 or len(compiled) != 1
            or {tag["name"] for tag in feature["tags"]} != {"@planned"}):
        raise ValueError("Word commentsIds case identity drift")
    rule, scenario = matches[0]
    case = compiled[0]
    if (rule["name"] != "Word comment creation, inspection and thread resolution"
            or {tag["name"] for tag in rule["tags"]} != set()
            or {tag["name"] for tag in scenario["tags"]} != {CASE_ID, "@profile-comment-id-fallback"}
            or scenario["keyword"] != "Scenario"
            or scenario["name"] != "Inspect a comment's para ID through commentsIds when its first paragraph lacks paraId"
            or scenario["location"]["line"] != 92 or scenario["examples"]
            or [step["keyword"] for step in scenario["steps"]] != ["Given ", "And ", "And ", "When ", "Then "]
            or [step["text"] for step in scenario["steps"]] != list(STEPS)
            or case["name"] != scenario["name"]
            or [step["text"] for step in case["steps"]] != list(STEPS)
            or [step["type"] for step in case["steps"]] != ["Context", "Context", "Context", "Action", "Outcome"]
            or any(step.get("argument") for step in case["steps"])
            or len(case["astNodeIds"]) != 1):
        raise ValueError("Word commentsIds authored steps or profile drift")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": case["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": step["text"], "type": step["type"],
                                            "argument": None, "outcome": "not-run"}
                                           for step in case["steps"]]}]
