"""Seal one planned pre-root stylesheet PI case without other parser credit."""

import hashlib
import json

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xml/parsing.feature"
FEATURE_SHA256 = "350edcdfa0dc1206f9f5165cae93ba41c12b6974ee21e71cd3329ed2a82438ff"
CASE_ID = "@id-xml-stylesheet-processing-instruction"
CASE_KEY = CASE_ID + ":{}"
SOURCE = '<?xml-stylesheet href="style.xsl"?><r/>'
STEPS = (
    "XML values input encoded as JSON " + json.dumps(SOURCE),
    "the XML values input is parsed",
    "the root qualified name equals r",
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("XML stylesheet feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("XML stylesheet feature lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "Accept a stylesheet processing instruction before the root"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]} != {CASE_ID}
            or any(step.get("argument") for step in compiled[0]["steps"])):
        raise ValueError("XML stylesheet steps changed from reviewed binding")
    given = json.loads(compiled[0]["steps"][0]["text"].removeprefix("XML values input encoded as JSON "))
    if given != SOURCE:
        raise ValueError("XML stylesheet JSON operand differs from reviewed literal")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": text, "type": kind, "argument": None, "outcome": "not-run"}
                                           for text, kind in zip(STEPS, ("Context", "Action", "Outcome"))]}]
