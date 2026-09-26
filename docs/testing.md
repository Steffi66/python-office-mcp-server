## Running checks

Run tests from a Git checkout with Git on `PATH`. Acceptance configuration calls `git rev-parse`, `git diff HEAD` and `git status`; a source archive without `.git` cannot produce its revision report. The test runner does not format or fix source files. Install development dependencies from the repository root, then run the suite in one process:

```sh
git submodule update --init --recursive
uv sync --frozen --extra dev
PYTHON=.venv/bin/python bash tests/run_tests.sh
```

To use pip instead, create and activate a virtual environment and run `python -m pip install -e '.[dev]'`. The `dev` extra includes pytest-bdd and its official Gherkin parser. Choose related files for a focused batch:

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_patch_transactions.py \
  tests/test_xlsx_dependency_preservation.py \
  -q -o addopts=''
```

Install Git as well as Python: the exact transport dependency is installed from its Git revision. An unqualified package named `umcp` from PyPI is unrelated and must not replace the declared dependency.

Use full-suite runs at integration boundaries. Running several full suites concurrently against the same checkout duplicates work and can overwrite test reports. Fixtures use temporary document directories; test reports and caches are separate from source files. Default templates and committed reference documents come from `references/fixtures-ooxml`. Missing inputs fail with submodule initialisation instructions; tests never generate replacement files in the shared checkout. Before collection, setup verifies the pinned HEAD, annotated release tag, the root manifest seal and whole-submodule `git status --porcelain`. Dirty facts, workflow definitions, staged changes and untracked files refuse even when every document hash still matches. Isolated synthetic-repository tests cover those refusals without modifying shared inputs.

## Gherkin and typed inputs

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/acceptance tests/test_acceptance_ledger.py \
  tests/test_shared_contract_inventory.py -q -o addopts=''
```

The inventory/ledger runs under `tests/acceptance/conftest.py`; unit-only runs outside that directory do not refresh its report. Read the report's run ID and source hashes before citing it. The runner reads `references/fixtures-ooxml/workflows/mutation-safety.feature` directly. Its 8 scenarios expand to 19 cases and 159 steps. The shared feature retains `@planned`; `tests/acceptance/shared-mapping.json` selects Python's implemented stable case keys without copying or editing the Gherkin. Mapping changes a case to `not-run`, never `passed`. Only this runner's actual outcome assertions earn execution credit.

`test-results/acceptance.json` is replaced before collection, then records each step's outcome, the run ID, stable case key, feature/fixture hashes, source revision, source-file hashes and dependency versions. It also records the fixture submodule revision/tag/status, root manifest seal, minimal mutation-contract hash and Python mapping hash. Undefined or ambiguous bindings fail. Planned, skipped and unexecuted cases never count as passes. Running only a subset of the acceptance cases leaves the full inventory incomplete and fails its gate; use ordinary unit tests for narrow development checks.

Shared v2 uses strict JSON after Gherkin compilation. In a data table, write two backslashes before `n` so the compiler leaves one JSON escape:

```gherkin
| target | value_json       |
| A1     | "first\\nsecond" |
```

The decoded JSON value contains a newline. Step text outside a table has a different escaping layer. Python consumes the official compiler's decoded table rather than pytest-bdd 8's raw table representation, then calls strict `json.loads`; Bun calls strict `JSON.parse`. Neither runner needs relaxed JSON or another unescape pass.

The root schema-2 manifest seals fixture payloads, `workflows/mutation-safety.feature` and `contracts/mutation-safety.json`. There is no nested pack manifest or generated case inventory; the runner compiles the official Gherkin to derive scenario instances and typed inputs. Document bytes live once under the central `fixtures/` directory, organised by format and scenario group. `tests/fixture-assets.json` maps Python's logical fixture names to content-addressed IDs. The resolver reads physical paths from the central manifest, verifies metadata and hashes, and rejects unsafe paths or symlinks. Historical aliases are metadata only; the consumer creates no compatibility directories or fixture copies. The minimal contract refers to asset IDs and records expected read-back facts, exact ZIP membership, member hashes and the allowed changed parts. The preserve set is computed as every member outside that allowance. Original fixture bytes, feature bytes and stable case identities are unchanged. New revisions need an explicit submodule update and local verification. Shared fact/consumer ledgers are reference metadata, not a substitute for local assertions.

## Real MCP and wheel installation

The Gherkin cases call the server methods directly. Separate transport tests start a real stdio server, initialise MCP, list tools, preview edits, commit and read back results:

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_stdio_mutation_workflows.py -q -o addopts=''
```

To test the installed package without importing the repository source:

```sh
uv build --wheel
uv venv .wheel-venv
uv pip install --python .wheel-venv/bin/python dist/*.whl
OFFICE_MCP_TEST_PYTHON="$PWD/.wheel-venv/bin/python" \
  PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_stdio_mutation_workflows.py tests/test_office_http.py -q -o addopts=''
```

Use a fresh wheel environment and a `dist/` containing only the intended wheel. The test client runs the installed server from a temporary working directory. Request/response transcripts are saved under `test-results/stdio/`. These tests cover stdio. `tests/test_office_http.py` separately starts authenticated loopback Streamable HTTP servers and checks sessions, persistent connections, progress streams, deletion, framing/auth limits and Office writes. It also checks legacy SSE selection and raw TCP startup. Run that file with `OFFICE_MCP_TEST_PYTHON` to target the same clean installed wheel.

[Python CI](../.github/workflows/tests.yml) runs the suite and clean-wheel checks on Python 3.10, 3.12 and 3.13. It uploads JUnit and resolved dependencies for seven days. The [Windows workflow](../.github/workflows/build-windows.yml) builds an executable and checks discovery; that is narrower than the mutation suite.

## Transport dependency checks

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_transport_dependency.py tests/test_umcp_office_features.py \
  tests/test_office_http.py tests/test_stdio_mutation_workflows.py \
  -q -o addopts=''
```

Dependency tests verify the installed transport version, Git source revision, included licence and absence of repository-local module shadowing. Office tests check object-compatible schemas, structured/text agreement, explicit annotations, guidance-only resources/prompts/completions and request-local progress/cancellation. HTTP tests use ephemeral loopback ports and synthetic tokens; they never use production credentials. Cross-session cancellation, notification isolation and expiry also have bounded in-process tests.

The earlier preservation reports below predate the upgrade and retain their original source pins/counts. [uMCP upgrade validation](../validation/umcp-upgrade.json) records the new matrix: 1,130 passing tests per runtime including four local-only tests (1,126 committed), three optional LibreOffice skips, and a 13-test installed-wheel batch (10 socket workflows plus three in-process policy/expiry/error checks). SDK 1.29.0 also completed the optional authenticated HTTP smoke script. Counts from different scopes are not added together.

## Independent calculation and rendering

LibreOffice is optional locally. Its absence produces three explicit skips:

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_libreoffice_oracle.py -q -rs -o addopts=''
```

The [manual oracle workflow](../.github/workflows/oracle.yml) provisions Writer, Calc and Impress before running these checks. It verifies a recalculated cross-sheet answer and PDF production from edited DOCX/PPTX files. A PDF header and non-empty output establish that conversion ran; they do not establish pixel-level visual equivalence. LibreOffice calculation also does not prove native Excel equivalence.

Native Microsoft Office rendering and the Windows executable runtime have not been verified locally. The implementation review delegations timed out; a later documentation-only review checked setup and test instructions, not implementation correctness.

## Shared fixture releases

The consumer's `tests/fixtures-pin.json` records the release tag, exact Git commit and root manifest seal. `references/fixtures-ooxml` is an ordinary Git submodule at that commit. All OOXML consumers must use the same coordinated release; do not track its moving default branch or update only one consumer silently.

The central manifest is schema 2. Fixture IDs are `fixture-<full SHA-256>`; physical files are grouped under `fixtures/<format>/<scenario-group>/`. A record supplies its repository-relative path, byte count, digest, format, scenario group, origins and historical aliases. Resolve the ID through that record, never by rebuilding a path from an alias. The minimal mutation contract uses an `assetId` for each of its four named inputs; it does not duplicate registry paths, origins or file hashes. Thirty-seven Python mappings select two defaults and 35 test documents; the fixture-description notice is metadata rather than an Office package.

Before adopting a release, verify its annotated tag and expected commit, update the gitlink and pin record, and run input-integrity, full native and installed-wheel tests. Dirty shared facts or workflows must fail even when document hashes match. Run candidate checks in a separate clone with an explicitly local test pin; never disable the release guard or publish that local tag. Candidate results must identify their draft source and cannot be reported as final-release verification.

## Catalogue capture and remaining work

`docs/catalogue-staging/python-native/` is temporary reconciliation input. Its README and mapping describe the captured source revision, denominator, manual reviews and gaps. Parsing candidate Gherkin grants no execution credit. The central repository owns canonical behaviour IDs and expected outcomes; Python keeps runner mappings and locally measured evidence. Resolver and minimal-policy tests are included in the current candidate mapping; their descriptions still need central semantic reconciliation. Reusable generated input seeds also need inventory. Neither task is completed by moving committed fixture files.

## Fixture migration verification

[Minimal-contract release verification](../validation/fixture-contract-cleanup.json) records official `v0.3.0` at `a3048639f5b9c521852b9d126b83639c08eae056`. Python 3.12 passed **1,163 committed tests**, plus four preserved local-only tests; three optional LibreOffice checks remain skipped. All 19 shared cases / 159 steps and 13 installed-wheel checks passed. The earlier Python 3.10/3.12/3.13 matrix passed 1,163 native tests per runtime against candidate `29af401`; final fixture names and documentation changed afterwards without changing bytes or contract policies. The report keeps those source scopes separate.

Historical [schema-2 release verification](../validation/fixture-schema2-release.json) records official `v0.2.0` at `631b1136c9d65451d21746db2ae2635866902cb4`: **1,156 committed tests passed** on Python 3.10, 3.12 and 3.13, plus four preserved local-only tests and three optional LibreOffice skips per runtime. All 19 shared cases / 159 steps and 13 installed-wheel checks passed. These overlapping scopes are not added together. The current release tag, commit and single root-manifest seal are in `tests/fixtures-pin.json`.

Earlier [fixture migration results](../validation/fixture-migration.json) record the tested fixture tag and seals, exact transport dependency, three-runtime results and local-only file hashes. This report distinguishes pre-cutover working-tree verification from later clean-clone checks. Removed source inventories grant no new workflow coverage.

## Recorded results

The preservation work is on `main`, merged at `7f4552d3bf221e6f27b7f28f6c347a9f6892f3c3`. Its temporary worktree and feature/backport branches have been removed. Run current development and tests from the main checkout.

| Scope | Runtime | Result |
|---|---|---|
| Committed suite at the recorded validation revision | Python 3.10.21 | 1,106 passed; 3 LibreOffice skips |
| Committed suite at the recorded validation revision | Python 3.12.3 | 1,106 passed; 3 LibreOffice skips |
| Committed suite at the recorded validation revision | Python 3.13.14 | 1,106 passed; 3 LibreOffice skips |
| Shared Python acceptance, included above | Direct server calls | 19 cases / 159 steps passed |
| Clean installed wheel | Real MCP stdio | 4 tests passed |
| Main merge checkout, including local-only CLI tests | Python 3.12.3 | 1,110 passed; 3 LibreOffice skips |

The last row includes four tests from the pre-existing, untracked `tests/test_pptx_import_slide_standalone.py`, using the untracked `pptx_import_slide.py`. Those files were preserved but not committed; a clean clone should not expect the extra four tests. The earlier audit similarly distinguished 988 committed tests from 992 in that working copy.

[Historical matrix results](../validation/preservation-safety.json) retain the original tested revision and branch label. [Merge results](../validation/main-merge.json) record the merge commit, JUnit hash and local-only file hashes. No running service was deployed or restarted during that merge. The [implementation checklist](checklists/preservation-safety.md) contains the batch history, and [writer scope](writer-scope.md) defines which operations have which guarantees.
