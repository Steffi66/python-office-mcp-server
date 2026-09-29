"""Seal one planned namespace-aware attribute lookup case, not adjacent XML cases."""

import hashlib
import json

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xml/parsing.feature"
FEATURE_SHA256 = "350edcdfa0dc1206f9f5165cae93ba41c12b6974ee21e71cd3329ed2a82438ff"
CASE_ID = "@id-xml-expanded-attribute-lookup"
CASE_KEY = CASE_ID + ":{}"
SOURCE = ('<r xmlns="urn:default" xmlns:a="urn:a" xmlns:r="urn:a" id="plain" '
          'a:id="outer"><child xmlns:r="urn:b" r:id="inner" xml:lang="en"/>'
          '<other r:id="sibling"/></r>')
GIVEN = "XML values input encoded as JSON " + json.dumps(SOURCE)
STEPS = (GIVEN, "the XML values input is parsed", "expanded attribute lookups return these JSON values")
# This is one Outcome with seven lookups, not seven expanded cases or extra steps.
ROWS = (
    ("element", "local", "namespace", "value_json"),
    ("root", "id", "", '"plain"'),
    ("root", "id", "urn:default", "null"),
    ("root", "id", "urn:a", '"outer"'),
    ("child", "id", "urn:b", '"inner"'),
    ("child", "id", "urn:a", "null"),
    ("other", "id", "urn:a", '"sibling"'),
    ("child", "lang", "http://www.w3.org/XML/1998/namespace", '"en"'),
)
EXPECTED = ("plain", None, "outer", "inner", None, "sibling", "en")


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("XML attribute feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("XML attribute feature lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "Attribute lookup respects local prefix rebinding and unqualified names"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]} != {CASE_ID}
            or any(step.get("argument") for step in compiled[0]["steps"][:2])):
        raise ValueError("XML attribute steps changed from reviewed binding")
    if json.loads(compiled[0]["steps"][0]["text"].removeprefix("XML values input encoded as JSON ")) != SOURCE:
        raise ValueError("XML attribute source differs from reviewed literal")
    if len(SOURCE.encode("utf-8")) != 157:
        raise ValueError("XML attribute source length changed")
    argument = compiled[0]["steps"][2].get("argument", {})
    table = argument.get("dataTable", {}).get("rows", [])
    observed_rows = tuple(tuple(cell["value"] for cell in row["cells"]) for row in table)
    if (set(argument) != {"dataTable"} or observed_rows != ROWS
            or len({row[:3] for row in observed_rows[1:]}) != 7
            or tuple(json.loads(row[3]) for row in observed_rows[1:]) != EXPECTED):
        raise ValueError("XML attribute lookup table differs from reviewed seven-row seal")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": step["text"], "type": step["type"],
                                               "argument": step.get("argument"), "outcome": "not-run"}
                                              for step in compiled[0]["steps"]]}]
