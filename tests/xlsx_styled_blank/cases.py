"""Seal only the planned four-step styled-blank XLSX cell case."""

import hashlib

from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler

from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xlsx/cells.feature"
FEATURE_SHA256 = "cdfcbd99ba3d8aa775306fc9eb2caf879350d50d832d59d9f9034b0666a6d925"
CASE_ID = "@id-xlsx-styled-blank-cell-editable"
CASE_KEY = CASE_ID + ":{}"
STEPS = (
    "a synthetic XLSX fixture with a styled blank cell",
    'I change the blank styled cell A1 text to "filled" and save and reopen the workbook',
    "the blank styled cell was readable as null before editing",
    "the reopened blank styled cell keeps its style and new value",
)


def load_cases():
    source = FIXTURE_SOURCE / FEATURE
    sealed = verified_metadata(FEATURE, "workflow")
    digest = hashlib.sha256(sealed).hexdigest()
    if digest != FEATURE_SHA256:
        raise ValueError("Styled-blank feature differs from reviewed seal")
    document = Parser().parse(sealed.decode("utf-8"))
    document["uri"] = str(source)
    feature = document["feature"]
    if {tag["name"] for tag in feature["tags"]} != {"@planned"}:
        raise ValueError("Styled-blank feature lifecycle changed")
    scenarios = [child["scenario"] for rule in feature["children"] for child in rule["rule"]["children"]
                 if "scenario" in child and any(tag["name"] == CASE_ID for tag in child["scenario"]["tags"])]
    compiled = [case for case in Compiler().compile(document)
                if any(tag["name"] == CASE_ID for tag in case["tags"])]
    if (len(scenarios) != 1 or len(compiled) != 1
            or compiled[0]["name"] != "Read and edit a styled blank cell without losing its style"
            or [step["text"] for step in compiled[0]["steps"]] != list(STEPS)
            or [step["type"] for step in compiled[0]["steps"]] != ["Context", "Action", "Outcome", "Outcome"]
            or scenarios[0]["examples"]
            or {tag["name"] for tag in scenarios[0]["tags"]} != {CASE_ID}
            or any(step.get("argument") for step in compiled[0]["steps"])):
        raise ValueError("Styled-blank steps changed from reviewed binding")
    return [{"scenarioId": CASE_ID, "stableCaseKey": CASE_KEY, "name": compiled[0]["name"],
             "examples": {}, "feature": str(source), "featureSha256": digest,
             "outcome": "not-run", "steps": [{"text": step["text"], "type": step["type"],
                                               "argument": None, "outcome": "not-run"}
                                              for step in compiled[0]["steps"]]}]
