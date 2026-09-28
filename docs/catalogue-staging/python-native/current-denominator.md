# Python pytest denominator at v0.57

At Python `2608e13df9ee1355f6ddc80b21c352910e5686ed`, pinned to shared v0.57.0 `ce728d256a81d62472721fbd4d50532c79138d42`, a full pytest run collected and passed **1,337 leaves** from **1,066 definitions in 79 `test_*.py` modules**. This is a current-source count, separate from the [pre-v0.4 capture](mapping.json). It adds no canonical scenario binding or shared execution credit.

| Scope | Modules | Definitions | Collected leaves | Parametrised definitions | Parametrised leaves |
| --- | ---: | ---: | ---: | ---: | ---: |
| Historical capture, matched by exact node ID | 67 | 1,022 | 1,147 | 30 | 155 |
| Added after the capture | 12 | 44 | 190 | 30 | 176 |
| Current pytest suite | 79 | 1,066 | 1,337 | 60 | 331 |

Of the current definitions, 1,006 have one unparametrised leaf each. A parametrised definition counts once in the definition column and once per collected variant in the leaf column. The historical capture records 32 parametrisation **decorators**; the 30 effective parametrised definitions above count collected cases, including fixture-generated variants, and are a different measure. Across the current suite, the largest parameter-name groups are `fault` (10 definitions / 90 leaves), `fixture_path` (1 / 35), `_pytest_bdd_example` (6 / 17), `package_case` (1 / 14) and `expression` (1 / 13). These groups partition parametrised definitions by their complete parameter-name sets; names are not scenario IDs. Every one of the historical mapping's 1,147 `collectedCases` node IDs still appears under the same definition with the same group size. No historical definition disappeared. The 12 added modules include six acceptance-lane modules and six other test modules; nine further added definitions occur in modules already present in the capture. The historical source commit, hashes, scenario IDs and review flags in `mapping.json` remain unchanged.

The six separately run acceptance lanes are **inside** the 1,337 pytest leaves and the 44 added definitions:

| Lane | Definitions | Pytest leaves | Separate selected-case/step report |
| --- | ---: | ---: | ---: |
| Mutation (`tests/acceptance/`) | 8 | 19 | 19 cases / 159 steps |
| XML comparison (`tests/xml_comparison/`) | 1 | 10 | 10 / 40 |
| Package admission (`tests/package_admission/`) | 1 | 14 | 14 / 47 |
| Negative budgets (`tests/package_limit_configuration/`) | 1 | 2 | 2 / 12 |
| Descriptor integrity (`tests/package_descriptor_integrity/`) | 1 | 1 | 1 / 8 |
| Owned chain (`tests/calculation_chain_acceptance/`) | 1 | 1 | 1 / 14 |
| **Six-lane subset** | **13** | **47** | **47 cases / 280 steps** |

The other 73 modules contain 1,053 definitions and 1,290 leaves. The six-lane selected cases are counted once in pytest's 1,337 leaves; their **280 Gherkin step outcomes** are reported in separate `test-results/*.json` files, not added to the pytest denominator. Mapping guards and native controls outside those six directories remain ordinary pytest leaves. A historical candidate scenario, a collected pytest leaf and a shared selected case answer different inventory questions. Neither the current count nor the historical capture grants new credit for planned visibility or other unbound workflows.

## Reproduction and limits

The count comes from pytest's `session.items` during a **full run** of `tests/` in a clean recursive clone, with `OOXML_FIXTURE_CANDIDATE_*` overrides unset. A definition is the collected node ID before its parameter suffix; a module is a distinct `tests/**/test_*.py` source path; parametrisation is present when the item has `callspec`. The run passed 1,337 tests with three known warnings. The six lane reports were then checked separately for passed outcomes, exact case/step inventories, pinned `fixtureSourceCommit`, and clean fixture status. Running `--collect-only` can reset ignored lane reports through fail-closed `conftest.py` hooks; collection alone is not execution evidence. Re-run the full suite before citing those reports.

The historical mapping captures source at `2f5b97e95148ea57c5ccf98a1fd4c0fc7b1ccaa9`; this note describes the later published Python commit above. It does not regenerate candidate features, change native tests or reconcile semantic equivalence. `docs/catalogue-staging/python-native/` remains reconciliation input, while selected-case evidence stays in the six independent acceptance reports and the shared workflow ledger.
