## Running checks

Run tests from a Git checkout with Git on `PATH`. Acceptance configuration calls `git rev-parse`, `git diff HEAD` and `git status`; a source archive without `.git` cannot produce its revision report. The test runner does not format or fix source files. Install development dependencies from the repository root, then run the suite in one process:

```sh
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

Use full-suite runs at integration boundaries. Running several full suites concurrently against the same checkout duplicates work and can overwrite test reports. Fixtures use temporary document directories; test reports and caches are separate from source files. The fixture setup expects the committed default DOCX/PPTX templates; if they are absent it can generate replacements under `tests/_templates/`, so use a complete checkout.

## Gherkin and typed inputs

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/acceptance tests/test_acceptance_ledger.py \
  tests/test_shared_contract_inventory.py -q -o addopts=''
```

The inventory/ledger runs under `tests/acceptance/conftest.py`; unit-only runs outside that directory do not refresh its report. Read the report's run ID and source hashes before citing it. The Python feature under `tests/acceptance/features/` is tagged `@implemented @python`. Its 8 scenarios expand to 19 cases and 159 executed steps. The sealed source pack under `tests/contracts/shared/` keeps its original `@planned` tags; those describe shared requirements, not every implementation's execution status. Do not modify the sealed pack in place to change coverage claims.

`test-results/acceptance.json` is replaced before collection, then records each step's outcome, the run ID, stable case key, feature/fixture hashes, source revision, source-file hashes and dependency versions. Undefined or ambiguous bindings fail. Planned, skipped and unexecuted cases never count as passes. Running only a subset of the acceptance cases leaves the full inventory incomplete and fails its gate; use ordinary unit tests for narrow development checks.

Shared v2 uses strict JSON after Gherkin compilation. In a data table, write two backslashes before `n` so the compiler leaves one JSON escape:

```gherkin
| target | value_json       |
| A1     | "first\\nsecond" |
```

The decoded JSON value contains a newline. Step text outside a table has a different escaping layer. Python consumes the official compiler's decoded table rather than pytest-bdd 8's raw table representation, then calls strict `json.loads`; Bun calls strict `JSON.parse`. Neither runner needs relaxed JSON or another unescape pass.

The shared v2 manifest SHA-256 is `4fb30e0d1a75e889985eceb0c6929dc59971089cc3bc692f18675f36dfeb81de`. Fixture hashes and scenario identities are pinned in the pack. New contract revisions need a new seal and explicit migration; the original audit's six `@id-office-*` IDs are historical aliases, not additional coverage.

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
  tests/test_stdio_mutation_workflows.py -q -o addopts=''
```

Use a fresh wheel environment and a `dist/` containing only the intended wheel. The test client runs the installed server from a temporary working directory. Request/response transcripts are saved under `test-results/stdio/`. These tests cover stdio. `tests/test_office_http.py` separately starts authenticated loopback Streamable HTTP servers and checks sessions, persistent connections, progress streams, deletion, framing/auth limits and Office writes. It also checks legacy SSE selection and raw TCP startup. Run that file with `OFFICE_MCP_TEST_PYTHON` to target the same clean installed wheel.

[Python CI](../.github/workflows/tests.yml) runs the suite and clean-wheel checks on Python 3.10, 3.12 and 3.13. It uploads JUnit and resolved dependencies for seven days. The [Windows workflow](../.github/workflows/build-windows.yml) builds an executable and checks discovery; that is narrower than the mutation suite.

## uMCP upgrade checks

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_umcp_vendor.py tests/test_umcp_office_features.py \
  tests/test_office_http.py tests/test_stdio_mutation_workflows.py \
  -q -o addopts=''
```

Vendor tests compare exact runtime/licence hashes against `vendor/umcp/manifest.json`. Office tests check object-compatible schemas, structured/text agreement, explicit annotations, guidance-only resources/prompts/completions and request-local progress/cancellation. HTTP tests use ephemeral loopback ports and synthetic tokens; they never use production credentials. Cross-session cancellation, notification isolation and expiry also have bounded in-process tests.

The earlier preservation reports below predate the upgrade and retain their original source pins/counts. New upgrade results belong in a separate report, not a rewritten historical record.

## Independent calculation and rendering

LibreOffice is optional locally. Its absence produces three explicit skips:

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/test_libreoffice_oracle.py -q -rs -o addopts=''
```

The [manual oracle workflow](../.github/workflows/oracle.yml) provisions Writer, Calc and Impress before running these checks. It verifies a recalculated cross-sheet answer and PDF production from edited DOCX/PPTX files. A PDF header and non-empty output establish that conversion ran; they do not establish pixel-level visual equivalence. LibreOffice calculation also does not prove native Excel equivalence.

Native Microsoft Office rendering and the Windows executable runtime have not been verified locally. The implementation review delegations timed out; a later documentation-only review checked setup and test instructions, not implementation correctness.

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
