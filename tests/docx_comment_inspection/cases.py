"""Seal the single planned pinned Word-comment inspection case."""

import hashlib

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/docx/comments.feature"
FEATURE_SHA256 = "e1bcda50084acdc4231dc97273da5ae4194f90fa72dbb9a394fda343447001f0"
CASE_ID = "@id-docx-comments-inspection"
CASE_KEY = CASE_ID + ":{}"
STEPS = (
    "the pinned threaded Word comments package is opened",
    "existing Word comments are inspected",
    "the three comment bodies and reply parent match the pinned fixture",
    "the Word comment package bytes remain unchanged",
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("Word comment feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("Word comment lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "Inspecting the pinned threaded comments does not dirty the package"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]}
               != {CASE_ID, "@profile-existing-comments-extended"}
            or any(step.get("argument") for step in compiled[0]["steps"])):
        raise ValueError("Word comment steps differ from reviewed binding")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": step["text"], "type": step["type"],
                                               "argument": None, "outcome": "not-run"}
                                              for step in compiled[0]["steps"]]}]
