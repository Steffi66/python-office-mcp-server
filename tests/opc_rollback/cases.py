"""Seal only the planned OPC file-publication rollback case; grant no shared credit."""

import hashlib

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/package/preservation.feature"
FEATURE_SHA256 = "1a2c653871f6bd830da4ca37f2b9c355c3885463234101b55a403786aedbba5a"
CASE_ID = "@id-opc-package-transaction-rollback"
CASE_KEY = CASE_ID + ":{}"
STEPS = (
    "a valid OPC package with XML and opaque payload parts",
    "a transactional edit changes multiple parts and then fails",
    "the package reverts to the original bytes and parts after the refusal",
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("OPC rollback feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("OPC rollback feature lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "A failed transactional edit rolls back every changed part"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]} != {CASE_ID}
            or any(step.get("argument") for step in compiled[0]["steps"])):
        raise ValueError("OPC rollback steps changed from reviewed binding")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": text, "type": kind, "argument": None, "outcome": "not-run"}
                                           for text, kind in zip(STEPS, ("Context", "Action", "Outcome"))]}]
