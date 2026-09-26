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

Use full-suite runs at integration boundaries. Running several full suites concurrently against the same checkout duplicates work and can overwrite test reports. Fixtures use temporary document directories; test reports and caches are separate from source files. Default templates and committed reference documents come from `references/fixtures-ooxml`. Missing inputs fail with submodule initialisation instructions; tests never generate replacement files in the shared checkout. Before collection, setup verifies the pinned HEAD, annotated release tag, root manifest seal and whole-submodule `git status --porcelain`. It also compares every tracked file's raw Git blob hash, regular-file path and executable bit with the pinned commit, independently of index flags. Hidden edits marked `assume-unchanged` or `skip-worktree`, missing files and symlink replacements refuse even when porcelain is empty. Git reads disable optional index refresh; verification preserves index bytes and flags. POSIX executable modes are checked even when `core.filemode=false`; Windows lacks that mode-bit guarantee. Ordinary untracked/staged changes still refuse. These checks detect checkout drift, not arbitrary concurrent adversarial filesystem replacement. Isolated tests cover refusals without modifying shared inputs.

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

## Canonical XML comparison

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/xml_comparison tests/test_xml_comparison_mapping.py \
  tests/test_package_preservation.py -q -o addopts=''
```

The separate XML lane compiles `workflows/xml/comparison.feature` from the pinned submodule with the official Gherkin parser. Its five IDs expand to ten input pairs and 40 steps. Explicit bindings call the conservative Boolean comparator and check the exact expected result. They do not test lexical parsing, XML canonical output, signatures or Office rendering.

The native-source mapping retains the reviewed input pairs and source hashes. Changed inputs, operation wording, expected results, missing/duplicate variants or unreviewed native implementation changes refuse before execution. Mapping starts cases at `not-run`; central consumer ledgers cannot award a local pass.

`test-results/xml-comparison.json` resets before collection and records each step outcome, observed Boolean, feature/native implementation hashes, release pin, working status and a fresh run ID. Selecting only part of this lane leaves it incomplete and returns failure. The mutation report remains independent at `test-results/acceptance.json`; neither lane can overwrite the other's results. The canonical feature is read in place, with no accepted local feature copy.

## Canonical package admission and semantic diff

```sh
PYTHON=.venv/bin/python bash tests/run_tests.sh \
  tests/package_admission tests/test_package_admission_mapping.py \
  tests/test_package_guard.py -q -o addopts=''
```

The package lane reads three sealed features under central `workflows/package/`: ZIP admission, XML-member admission and semantic diff. Five scenario IDs expand to 14 cases and 47 steps. The reviewed native mapping fixes member order, duplicate names, payload hashes/lengths, compression, caller limits and expected errors or result lists. It preserves the exact UTF-16 little-endian BOM input and limits `0/2/2/1`. Changed or ambiguous setup, operations or outcomes refuse before execution; mapping alone grants no passes.

Bindings construct only temporary native test archives. Diff uses distinct original and modified paths. Admission asserts `PackageAdmissionError`, with a message fragment only for unsupported compression; semantic diff checks its four member lists, including an empty removed list. These are not ZIP writer, lexical-parser, allocation-measurement, network-isolation or Office rendering tests.

`test-results/package-admission.json` resets before collection and records each case/step, observed refusal or diff result, input signatures, source hashes and the fixture release pin. A partial run fails completion rather than reporting unexecuted cases as passes. XML and mutation results remain in their separate reports. Canonical features are consumed from the submodule; the three accepted local copies were removed when v0.5.0 was adopted.

## Real MCP and wheel installation

The mutation Gherkin cases call the server methods directly. Separate transport tests start a real stdio server, initialise MCP, list tools, preview edits, commit and read back results:

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

Before adopting a release, verify its annotated tag and expected commit, then update the gitlink and pin record. Consumer/runtime or bound-contract changes require input-integrity, full native and installed-wheel checks. A coordinated reference-only addition may use release guards and the existing acceptance lanes after verifying that every prior asset record is unchanged; record that narrower scope explicitly. Dirty shared facts or workflows must fail even when document hashes match. Run candidate checks in a separate clone with an explicitly local test pin; never disable the release guard or publish that local tag. Candidate results must identify their draft source and cannot be reported as final-release verification.

## Catalogue capture and remaining work

`docs/catalogue-staging/python-native/` is temporary reconciliation input. Its README and mapping describe the captured source revision, denominator, manual reviews and gaps. Parsing candidate Gherkin grants no execution credit. The central repository owns canonical behaviour IDs and expected outcomes; Python keeps runner mappings and locally measured evidence. Resolver and minimal-policy tests are included in the current candidate mapping; their descriptions still need central semantic reconciliation. Reusable generated input seeds also need inventory. Neither task is completed by moving committed fixture files.

## Fixture migration verification

[Reference-only v0.16 verification](../validation/fixture-reference-v0160.json) records official `v0.16.0` at `641146c020e1011b8f3e930f5fb4fd0b76c27b3d`. All 147 prior asset records are unchanged; 16 added references bring the manifest to 163 entries. **82 released-default checks passed** on Python 3.12, covering the release guards and existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. The shared repository adds ECMA-376 PDFs, informative extracts and notes, and planned font-size and VML scenarios; Python gained no native bindings or execution credit for them. Specification PDFs supply authority; extracts and notes do not replace them. The Python runtime, native tests, catalogue reviews and local-only user files are unchanged. No full Python matrix, wheel tests or new scenario execution ran for this reference-only update.

Historical [reference-only v0.15 verification](../validation/fixture-reference-v0150.json) records official `v0.15.0` at `977ebe92522325a8bbc14999fed17e0a5e9626da`. All 146 prior asset records are unchanged; one added reference brings the manifest to 147 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun effective-formatting scenarios earn no Python execution credit. The coordinator reports a known LibreOffice font-probe mismatch; no renderer or general cascade parity is assigned. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.14 verification](../validation/fixture-reference-v0140.json) records official `v0.14.0` at `083023c10bd8635f905a7ec614e47409d466dd50`. All 145 prior asset records are unchanged; one added reference brings the manifest to 146 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun exact slide-permutation scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.13 verification](../validation/fixture-reference-v0130.json) records official `v0.13.0` at `aaf87902d2c381e72d75878dad4e49b137feafc6`. All 144 prior asset records are unchanged; one added reference brings the manifest to 145 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun final-section page-layout scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.12 verification](../validation/fixture-reference-v0120.json) records official `v0.12.0` at `89518aa62c9515a7ccbe05ed9afc1bbc89e1118a`. All 143 prior asset records are unchanged; one added reference brings the manifest to 144 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun existing-cell-style scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.11 verification](../validation/fixture-reference-v0110.json) records official `v0.11.0` at `48f1b3bebf65c29931383a0daab9ed95301c482b`. All 142 prior asset records are unchanged; one added reference brings the manifest to 143 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun PPTX text-box scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.10 verification](../validation/fixture-reference-v0100.json) records official `v0.10.0` at `f479bce5f16bfc46cd396892640bb755e51bb4e9`. All 141 prior asset records are unchanged; one added reference brings the manifest to 142 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun paragraph-style-authoring scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed catalogue reviews are unchanged.

Historical [reference-only v0.9 verification](../validation/fixture-reference-v090.json) records official `v0.9.0` at `23a3fa7281be869f217bcc472629de6eecac8650`. All 140 prior asset records are unchanged; one added reference brings the manifest to 141 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun existing-paragraph-style scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed comment catalogue reviews are unchanged.

Historical [reference-only v0.8 verification](../validation/fixture-reference-v080.json) records official `v0.8.0` at `b5729fc0c0fd59a98bfdfa5e4906143c3c6ce56a`. All 139 prior asset records are unchanged; one added reference brings the manifest to 140 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun direct run-formatting scenarios earn no Python execution credit. No full Python matrix, wheel tests or Bun semantic tests were rerun for this repin; the separately committed comment-resolution catalogue review is unchanged.

Historical [reference-only v0.7 verification](../validation/fixture-reference-v070.json) records official `v0.7.0` at `111740069babc6648325dd9d62ada585ecbd3553`. All 138 prior asset records are unchanged; one added reference brings the manifest to 139 entries. **82 scoped checks passed**, covering hardened release guards and the existing mutation 19 cases / 159 steps, XML 10/40 and package 14/47 lanes. No Python runtime, native assertion or binding changed. The new Bun tracked-workflow scenarios earn no Python execution credit; neither Bun's runtime semantics nor a full Python matrix were rerun for this repin.

Historical [hidden-checkout-drift verification](../validation/fixture-hidden-drift-guard.json) records the isolated bypass reproduction and fix: facts and ledger edits hidden from porcelain were previously accepted, then refused by raw pinned-tree verification. **82 scoped checks passed**, including 17 new hidden-change/read-only-index cases and the three existing execution lanes. This guard-only change leaves the v0.6 pin and runtime code unchanged; no full matrix was repeated.

Historical [reference-only v0.6 verification](../validation/fixture-reference-v060.json) records official `v0.6.0` at `dc8fdccd5a7e14c9154bb71e68e10c7404fe4fa0`. All 128 prior asset records are unchanged; ten added references bring the manifest to 138 entries. **65 scoped checks passed**: release/fixture guards, mutation 19 cases / 159 steps, XML 10/40 and package 14/47. No runtime code, native assertions or bindings changed. No full matrix or wheel tests were repeated, and new Bun/comment scenarios earn no Python execution credit. Python root-thread resolution and metadata creation remain distinct from Bun's selected-existing-entry operation.

Historical [canonical package-admission verification](../validation/canonical-package-admission.json) records official `v0.5.0` at `db913c65bb652c11c05eb40793be37b56761cb53`. The Python 3.12 default run passed **1,213 committed tests**, plus four preserved local-only tests, with three optional LibreOffice skips. The separate package lane executed 14 cases / 47 steps, alongside unchanged XML 10/40 and mutation 19/159 reports. A deliberate partial package run returned failure with 13 cases unexecuted. Native tests and runtime implementations retain their reviewed hashes.

Historical [canonical XML comparison verification](../validation/canonical-xml-comparison.json) records official `v0.4.0` at `40eb26e684b12073956e4f24915444075a60c212`. The Python 3.12 default run passed **1,184 committed tests**, plus four preserved local-only tests, with three optional LibreOffice skips. XML comparison executed ten cases / 40 steps; mutation acceptance separately executed 19 cases / 159 steps. These are overlapping suite scopes, not additional passes to sum. The accepted local comparison feature was removed; reviewed native assertions and mapping provenance remain.

Historical [minimal-contract release verification](../validation/fixture-contract-cleanup.json) records official `v0.3.0` at `a3048639f5b9c521852b9d126b83639c08eae056`. Python 3.12 passed **1,163 committed tests**, plus four preserved local-only tests; three optional LibreOffice checks remain skipped. All 19 shared cases / 159 steps and 13 installed-wheel checks passed. The earlier Python 3.10/3.12/3.13 matrix passed 1,163 native tests per runtime against candidate `29af401`; final fixture names and documentation changed afterwards without changing bytes or contract policies. The report keeps those source scopes separate.

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
