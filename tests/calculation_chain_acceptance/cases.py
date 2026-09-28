"""Select only the sealed owned-chain case; no credit from a native chain test."""

import hashlib

from tests.acceptance.ledger import inventory
from tests.fixture_paths import FIXTURE_SOURCE, verified_metadata

FEATURE = "workflows/xlsx/calculation-chain-lifecycle.feature"
FEATURE_SHA256 = "705365c666efd68ae2fc1ac85d86f85511cde77c8fc7644ea04b3978bb56103e"
CASE_KEY = "@id-xlsx-owned-calculation-chain-invalidation:{}"
STEPS = (
    'a two-sheet XLSX package with Input!A1 numeric 1 and Calc!A1 formula "Input!A1*2" cached as 2',
    'Calc!B1 formula "A1+1" is cached as 3 and unrelated Calc!C1 formula "42" is cached as 42',
    'the workbook alone owns a calculation-chain relationship to xl/chains/order.xml',
    'xl/chains/order.xml has the calculation-chain content type and entries for Calc!A1 and Calc!B1',
    'all source package member payloads and bytes are recorded',
    'Input!A1 is set to numeric 10 with explicit dependent-cache invalidation and the result is saved and reopened',
    'the source package bytes remain unchanged and reopened Input!A1 is numeric 10',
    'the reopened Calc!A1 and Calc!B1 formulas are unchanged with absent or empty cached values',
    'a data-only read of those cells cannot return the old cached values 2 and 3 as current',
    'the reopened Calc!C1 formula and cached value 42 remain unchanged',
    'the workbook requests full recalculation without claiming a computed result',
    'xl/chains/order.xml, its workbook relationship and its content-type override are absent',
    'every destination relationship and content-type target resolves',
    'every source member payload outside the workbook, two worksheets, workbook relationships and content types remains byte-identical',
)


def load_cases():
    sealed = verified_metadata(FEATURE, "workflow")
    if hashlib.sha256(sealed).hexdigest() != FEATURE_SHA256:
        raise ValueError("Owned-chain feature differs from reviewed seal")
    cases = inventory([FIXTURE_SOURCE / FEATURE])
    if len(cases) != 1:
        raise ValueError("Expected exactly one owned-chain scenario")
    case = cases[0]
    if (case["stableCaseKey"] != CASE_KEY or case["scenarioId"] != "@id-xlsx-owned-calculation-chain-invalidation"
            or case["examples"] != {} or case["featureSha256"] != FEATURE_SHA256 or case["outcome"] != "planned"
            or [s["type"] for s in case["steps"]] != ["Context"] * 5 + ["Action"] + ["Outcome"] * 8
            or [s["text"] for s in case["steps"]] != list(STEPS)
            or any(s["argument"] is not None or s["outcome"] != "planned" for s in case["steps"])):
        raise ValueError("Owned-chain input or outcome changed from reviewed binding")
    case["outcome"] = "not-run"
    for step in case["steps"]:
        step["outcome"] = "not-run"
    return cases
