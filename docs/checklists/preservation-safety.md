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

- [ ] Add source fingerprints and stale-source decisions.
- [ ] Serialise this server's writers; document external-editor limitations.
- [ ] Cover in-place, absent-output and existing-output paths and aliases.
- [ ] Inject save/validation failures; verify rollback and staging cleanup.
- [ ] Run transaction/security tests and one full-suite pass; review and commit.

## Batch 5: executable acceptance

- [ ] Add pytest-bdd and bind all shared Given/When/Then operations.
- [ ] Reuse independent pytest assertions and fixture copies; retain low-level tests.
- [ ] Inventory before execution, with fresh run IDs and source/dependency/fixture hashes.
- [ ] Record exact expanded case identity, step outcomes and failure artifacts.
- [ ] Gate duplicate IDs, undefined/ambiguous steps, empty assertions and stale reports.
- [ ] Keep planned/skipped cases separate from passes.
- [ ] Run all 19 cases plus runner self-tests as one batch; review and commit.

## Batch 6: MCP and packaging

- [ ] Exercise inspect/preview/patch/reopen over actual MCP stdio with process timeouts.
- [ ] Build/install the wheel in a clean environment; verify tool discovery and edits.
- [ ] Retain Windows executable smoke coverage.
- [ ] Update office_help and docs with verified mode/receipt/refusal behaviour.
- [ ] Run transport, packaging and one full-suite integration batch; commit and send results to Bun.

## Batch 7: remaining writers

- [ ] Inventory table, comment and specialised writers that bypass the staged path.
- [ ] Expand this checklist into bounded writer-specific sub-batches before editing them.
- [ ] Extend transaction guarantees without changing unrelated APIs.
- [ ] Test and commit each sub-batch separately.

## Batch 8: bounded package components

- [ ] Pin ZIP guard/package-diff sources, notices, dependent modules and tests.
- [ ] Map supported inputs and refusal boundaries before copying code.
- [ ] Adapt ZIP admission checks behind existing load/save helpers; test and commit.
- [ ] Adapt DOCX/PPTX package diff and preservation save; test and commit each component.

## Batch 9: Word and presentation enhancements

- [ ] Import missing Word span/revision/comment assertions and PPTX clone/import/formatting assertions.
- [ ] Compare them against existing implementations before porting duplicate features.
- [ ] Expand into concrete feature sub-batches with compatibility rules.
- [ ] Implement, batch-test and commit each selected slice.

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
