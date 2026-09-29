"""Seal one planned XML entity-value case without granting other parser credit."""

import hashlib
import json

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xml/parsing.feature"
FEATURE_SHA256 = "350edcdfa0dc1206f9f5165cae93ba41c12b6974ee21e71cd3329ed2a82438ff"
CASE_ID = "@id-xml-entity-values"
CASE_KEY = CASE_ID + ":{}"
SOURCE = '<r a="&quot;&apos;">&#x41;&#65;&amp;&lt;&gt;</r>'
ATTRIBUTE = '"\''
TEXT = "AA&<>"
STEPS = (
    "XML values input encoded as JSON " + json.dumps(SOURCE),
    "the XML values input is parsed",
    "the root attribute a equals JSON " + json.dumps(ATTRIBUTE),
    "the root text equals JSON " + json.dumps(TEXT),
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("XML entity feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("XML entity feature lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "Decode predefined entities and decimal and hexadecimal references"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]} != {CASE_ID}
            or any(step.get("argument") for step in compiled[0]["steps"])):
        raise ValueError("XML entity steps changed from reviewed binding")
    given = json.loads(compiled[0]["steps"][0]["text"].removeprefix("XML values input encoded as JSON "))
    attribute = json.loads(compiled[0]["steps"][2]["text"].removeprefix("the root attribute a equals JSON "))
    text = json.loads(compiled[0]["steps"][3]["text"].removeprefix("the root text equals JSON "))
    if (given, attribute, text) != (SOURCE, ATTRIBUTE, TEXT):
        raise ValueError("XML entity JSON operand/outcomes differ from reviewed literals")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": value, "type": kind, "argument": None, "outcome": "not-run"}
                                           for value, kind in zip(STEPS, ("Context", "Action", "Outcome", "Outcome"))]}]
