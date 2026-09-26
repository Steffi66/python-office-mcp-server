# Preservation safety implementation checklist

The first release closes six reproduced server mutation failures before adding broader editing functionality. Keep the MCP interface, existing pytest tests and source provenance. Every test batch ends with a reviewed commit; no unrelated changes are bundled.

Base: `36ac406ad9d4bd3e7538b4bcc7aa2fb0e51cc943`. The audited source at `774ee72` differs only in CI files. Work takes place on `feature/preservation-safety` in an isolated worktree. Modified `uv.lock` and untracked standalone import files in the original checkout are excluded.

## Completed research

- [x] Audit code and identify six missing mutation contracts.
- [x] Run upstream baseline: 988 committed tests pass; local working snapshot has four additional tests.
- [x] Prepare eight shared scenario IDs, 19 expanded cases and four deterministic fixtures.
- [x] Verify shared fixture hashes, package references, style indices and read-back facts.
- [x] Preserve existing dirty files and create the isolated worktree with required Git identity.

## Batch 1: verification foundation

- [x] Record this implementation sequence.
- [x] Import the shared pack intact, including fixture/source hashes and licence caveats.
- [x] Add tests for pack integrity, compiled inventory and fixture preconditions.
- [x] Make the shell test entrypoint read-only with focused path selection.
- [x] Add PR/push CI with sequential pytest per environment and retained test/dependency evidence.
- [x] Run baseline and inventory validation in one process; verify existing dirty files are unchanged.
- [x] Review and commit the foundation batch (this change).

Verification: Python 3.12.3, **996 passed in 17.08s** (988 baseline plus eight inventory/precondition tests). Touched-file Ruff check, shell syntax and `git diff --check` pass. Original dirty-file SHA-256 values are unchanged. The new remote CI matrix has not run locally.

The imported scenarios remain `@planned`. Inventory tests validate their inputs; they do not count as scenario execution. Python 3.12 is locally verified. CI is configured for 3.10, 3.12 and 3.13; those remote results must be recorded before claiming matrix coverage. Python 3.14 is not part of this initial gate.

## Batch 2: mutation semantics

- [x] Add independent regressions for PPTX dry-run, XLSX strict rollback, accumulated PPTX outputs and Word per-target counts.
- [x] Stage the whole request; resolve strict errors before committing.
- [x] Preview without source/destination changes.
- [x] Apply all successful edits to one staged document and commit once.
- [x] Distinguish planned/matched/committed counts and exact rejected targets.
- [x] Validate ranges before mutation, including malformed later rows.
- [x] Preserve existing destinations on failure.
- [x] Run mutation, diagnostics and relevant format tests together; review and commit.

Verification: **151 passed in 2.42s**; new-file Ruff and diff whitespace checks pass. Private-copy preview validates actual transformations, then discards them. Repeated format writers address the same private copy; only the final destination replacement is committed. Source-fingerprint/locking hardening follows in Batch 4.

## Batch 3: XLSX dependency preservation

- [x] Add multiline/new-style and cross-sheet formula-cache regressions.
- [x] Preserve style definitions referenced by edited sheets without discarding opaque original parts.
- [x] Refuse unsupported style registry reindexing before replacing an output.
- [x] Invalidate formula caches across all sheets conservatively; no dependency-analysis claim.
- [x] Keep calculation metadata consistent, drop stale calculation chains and report recalculation required.
- [x] Reopen outputs and check member hashes/style indices; batch Excel tests and commit.

Verification: **219 passed in 2.47s**, including opaque-part byte checks, custom style indices, cross-sheet invalidation and calculation-chain relationships/content types. New-file Ruff and diff checks pass. Supported changes here are existing-sheet cell values and appended style registries, not arbitrary structural workbook edits.

## Batch 4: transaction hardening

- [x] Add source fingerprints and stale-source decisions.
- [x] Serialise this process's staged writers; document external-editor limitations.
- [x] Cover in-place, absent-output and existing-output paths and aliases.
- [x] Inject save/validation failures; verify rollback and staging cleanup.
- [x] Run transaction/security tests and full-suite pass; review and commit.

Verification: **1,040 passed in 17.21s**. Source/destination fingerprint changes refuse publication; process-local per-path locks prevent lost updates through this staging path. Symlinks retain their link identity; hard-linked files refuse. Fault tests assert the injected failure was actually reached. Legacy specialised writers are not yet covered by these locks (Batch 7). Arbitrary external writers can still race after the final hash check; no cross-process locking guarantee is claimed.

## Batch 5: executable acceptance

- [x] Add pytest-bdd and bind all shared Given/When/Then operations.
- [x] Reuse independent pytest assertions and fixture copies; retain low-level tests.
- [x] Inventory before execution, with fresh run IDs and source/dependency/fixture hashes.
- [x] Record exact expanded case identity, step outcomes and failure artifacts.
- [x] Gate duplicate IDs, undefined/ambiguous steps, empty assertions and stale reports.
- [x] Keep planned/skipped cases separate from passes.
- [x] Restore byte-original semantically unchanged PPTX XML payloads before publication (acceptance exposed this prerequisite ahead of Batch 8).
- [x] Run all 19 cases plus runner self-tests as one batch; review and commit.

Verification: **66 tests passed in 1.36s**, including **19 acceptance cases / 159 executed steps**. Runtime feature copy is tagged `@implemented @python`; original shared pack remains immutable/planned evidence. Gherkin table escaping is decoded before JSON string parsing; the adapter accepts literal newlines emitted by the compiler. Conservative OPC-equivalence restores unchanged PPTX payloads without relaxing fixture hashes. Independent regressions cover whitespace, child order, prefix-valued attributes and DTD rejection. The worktree lockfile was refreshed for pytest-bdd; original checkout lockfile is untouched.

## Batch 6: MCP and packaging

- [x] Exercise inspect/preview/patch/reopen over actual MCP stdio with process timeouts.
- [x] Build/install the wheel in a clean environment; verify tool discovery and edits.
- [x] Retain Windows executable smoke coverage (workflow retained; Windows binary not run locally).
- [x] Update office_help and docs with verified mode/receipt/refusal behaviour.
- [x] Run transport, packaging and one full-suite integration batch; commit and send results to Bun.

Verification: clean wheel-backed MCP **4 passed in 3.34s**; full regression **1,075 passed in 18.63s**, including **19 cases / 159 acceptance steps**. Transport assertions exposed that Word's basic JSON/Markdown readers omitted tracked insertions; both now use the revision-aware text helper for paragraphs and cells. Four transport tests cover all formats plus strict failure against an existing output. CI repeats the clean-wheel lane. No native Office, Windows runtime or LibreOffice validation ran locally.

## Batch 7: remaining writers

- [x] Inventory table, comment and specialised writers that bypass the staged path; record exact scope in `docs/writer-scope.md`.
- [x] Batch 7a: enrol unified tables/comments/images and verify nested output handling and preview.
- [x] Batch 7b: explicitly enrol 22 specialised existing-document writers, including slide-import target staging; preserve signatures.
- [x] Verify nested calls commit once, failure preserves existing outputs, read paths bypass staging and unsupported creation paths remain documented separately.
- [x] Run the combined writer regression batch and commit.

Verification: **1,083 passed in 21.06s**. Eight new tests exercise preview/commit across comment formats, Word table modes, specialised validation failure and one-publication nested dispatch. Transaction guarantees do not imply full-fidelity XLSX table/comment/chart serialisation; scope is explicit.

## Batch 8: bounded package components

- [x] Pin ZIP guard/package-diff sources, notices, dependent modules and tests.
- [x] Map supported inputs and refusal boundaries; implement bounded independent helpers rather than a partial verbatim port.
- [x] Add ZIP admission checks to staged input/output paths, with resource limits and DTD rejection.
- [x] Add package-diff receipts and DOCX/PPTX unchanged-payload restoration.
- [x] Batch-test admission, preservation, fault injection and acceptance; commit.

Verification: **54 passed in 1.76s**. Limits, duplicate/traversal names, unusual compression, UTF-16 DTD and malformed XML refusals are explicit. `docs/provenance/package-adoption.md` records the bounded package validation rules. Full OOXML schema/signature/rendering fidelity is not claimed.

## Batch 9: Word and presentation enhancements

- [x] Add independently authored Word span/revision boundary and PPTX clone/import/formatting assertions; retain existing comment thread regressions.
- [x] Compare against current code: Word flattened runs, PPTX replacement missed split runs, duplication shared relationship targets.
- [x] Select bounded slices: adjacent-run tracked Word replacement, adjacent-run PPTX literal replacement, graph-based duplication and explicit note-import checks.
- [x] Implement and batch-test these related preservation outcomes; record compatibility boundaries and commit.

Verification: **106 passed in 3.86s**. See `docs/provenance/selected-enhancements.md`. Full Word composition/compare and inherited PPTX formatting-provenance APIs are outside this selected server slice; no full-library parity claim.

## Batch 10: larger subsystem decisions

- [ ] Decide XLSX structural/reference adoption after dependency and compatibility analysis.
- [ ] Record supported edit families and refusals before implementation.
- [ ] Add independent calculation/rendering lanes where available.
- [ ] Keep absent Office/LibreOffice validation explicitly unverified.

## Final integration and delivery

- [ ] Run all declared gates and record skipped/unavailable evidence separately.
- [ ] Review fixture provenance, licence records and every implementation diff.
- [ ] Commit any remaining verified batch.
- [ ] Report commit IDs, tests and remaining gates; coordinate merge/push without rebasing.
- [ ] Recheck original local-edit hashes and leave shared references unchanged.

## Test execution policy

Use `PYTHON=/path/to/python bash tests/run_tests.sh tests/test_a.py tests/test_b.py -q -o addopts=''` for focused batches. Calling without arguments runs the full suite. Do not run a full suite once per file, or parallelise multiple full-suite processes against the same checkout. New fixtures use isolated temporary document directories.

Run formatting/lint checks explicitly on touched files. Verification must not auto-fix source. Preserve JUnit and resolved dependency versions for CI. Repeat the full suite at transaction and transport integration boundaries, then before final delivery. A failing batch is fixed and rerun before its implementation commit; confirmed red regression seeds may be committed only if explicitly separated and labelled, never hidden as passing acceptance.
