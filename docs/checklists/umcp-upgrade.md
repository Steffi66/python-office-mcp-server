# Vendored uMCP upgrade

Upgrade the asynchronous core to `rcarmo/umcp@30cce7dfe08c6ee63de235f7d81754ba286dafbb` (package version 0.2.2). Keep vendored runtime files byte-identical; integrate Office-specific behaviour in the subclass and helpers. Work on `main`, preserving the two existing untracked files.

## Scope and decisions

The server keeps Python >=3.10 and its existing public document tool signatures. The core needs `aioumcp.py` plus `umcp_shared.py`; the unused synchronous `umcp.py` is not shipped. Include the upstream MIT notice and exact hashes in the wheel and source repository.

Adopt structured tool responses while preserving legacy text content; correct misleading static annotations; keep deprecated tools hidden in discovery and available to explicit legacy callers. Add useful read-only workflow prompts/resources with bounded completion rather than exposing arbitrary filesystem resources. Cooperative cancellation must reach staged writers before publication; long library calls cannot be interrupted safely in the middle and completed commits cannot be undone.

Enable explicit Streamable HTTP selection with upstream negotiation/session handling. Preserve `--port` legacy SSE and `--tcp` compatibility, default to loopback, and provide environment-backed HTTP authentication instead of treating session IDs as credentials. No roles database, new document engine, TLS listener or broad permission framework is in scope. Network access still needs OS/path isolation and TLS at a trusted proxy.

Upstream documents some broader guarantees and examples than its code or this Office server supports. Tests and the actual pinned implementation decide adopted behaviour. Full JSON Schema, durable event replay, arbitrary synchronous thread interruption and HTTP guarantees for raw TCP are not assumed.

## Batches

- [x] Inspect the old vendor, Office integration and local edits; verify current upstream HEAD.
- [x] Read upstream README, architecture, chaining, prompts and Streamable HTTP contract; obtain bounded independent integration review.
- [x] Record source pin, licence and applicable upgrade decisions.
- [x] Batch 1: vendor async/shared files, licence and provenance; update wheel/PyInstaller inputs.
- [x] Batch 1: run baseline core/Office regressions and commit/push; existing discovery filtering remains compatible.

Batch 1 result: **1,114 passed, 3 LibreOffice skips in 24.51s**, including four local-only CLI tests. Built wheel contains both exact upstream modules, licence and manifest. New tests cover vendor hashes, filtered pagination, negotiated versions and structured/text result agreement. Application-specific schemas, errors and cancellation follow in Batch 2.
- [ ] Batch 2: explicit annotations, object-compatible output schemas/error flags, precise patch schema and useful workflow resources/prompts/completions.
- [ ] Batch 2: add cancellation/progress checkpoints to staged publication, test request-context isolation/stdio and commit/push.
- [ ] Batch 3: environment-backed HTTP identity; real persistent session lifecycle, SSE stream, protocol/origin/header/size/error tests on loopback.
- [ ] Batch 3: verify legacy selection and shutdown; commit/push.
- [ ] Batch 4: update setup/network/help/vendoring documentation and examples; batch-test and commit/push.
- [ ] Final: full Python 3.10/3.12/3.13 regression, all 19 Gherkin cases, clean wheel stdio/HTTP, independent bounded review.
- [ ] Final: publish pinned results, verify remote main/local edits and mark goal complete only after all required gates pass.

## Verification policy

Run related tests in one process, avoiding repeated full-suite runs per file. Commit each verified batch as Rui Carmo, then push without rebasing. Preserve original test counts and source pins in historical reports; write a new upgrade report. Keep optional LibreOffice skips explicit. Tests bind temporary loopback ports, use synthetic credentials and private temporary files, and clean subprocesses in `finally` blocks.
