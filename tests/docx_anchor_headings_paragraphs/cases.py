"""Seal the one saved Word headings/paragraphs anchor case."""

import hashlib

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/docx/anchor-discovery.feature"
FEATURE_SHA256 = "322cf1df8cb454241bf9255cfe62b9f4c84f83042cc27f102b88ef06ff99d911"
CASE_ID = "@id-python-word-anchor-headings-paragraphs"
CASE_KEY = CASE_ID + ":{}"
STEPS = (
    'a saved Word document has headings "Introduction" and "Delivery approach" and paragraphs "Customer context paragraph" and "Use iterative delivery"',
    'Word anchors are listed without a query',
    'the anchor count is at least 4',
    'an anchor has type "section_heading" and text "Introduction"',
    'a "paragraph" anchor contains "Customer context" in its text',
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("Word anchor feature differs from reviewed fixture provenance")
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
        raise ValueError("Word anchor case identity drift")
    rule, scenario = matches[0]
    case = compiled[0]
    if (rule["name"] != "Discover Word anchors and use a heading for insertion"
            or {tag["name"] for tag in rule["tags"]} != set()
            or {tag["name"] for tag in scenario["tags"]} != {CASE_ID, "@profile-anchor-response-api"}
            or scenario["keyword"] != "Scenario"
            or scenario["name"] != "Headings and body text appear among discovered anchors"
            or scenario["location"]["line"] != 11 or scenario["examples"]
            or [step["keyword"] for step in scenario["steps"]] != ["Given ", "When ", "Then ", "And ", "And "]
            or [step["text"] for step in scenario["steps"]] != list(STEPS)
            or case["name"] != scenario["name"]
            or [step["text"] for step in case["steps"]] != list(STEPS)
            or [step["type"] for step in case["steps"]] != ["Context", "Action", "Outcome", "Outcome", "Outcome"]
            or any(step.get("argument") for step in case["steps"])
            or len(case["astNodeIds"]) != 1):
        raise ValueError("Word anchor authored steps or profile drift")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": case["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": step["text"], "type": step["type"],
                                            "argument": None, "outcome": "not-run"}
                                           for step in case["steps"]]}]
