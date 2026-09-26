# Transport integration verification

The server uses the exact uMCP 0.2.2 Git dependency declared in project metadata. Application policy lives in the Office adapter; transport source is not kept in this repository. Dependency licence attribution is supplied by its installed distribution and standalone metadata collection.

## Completed integration gates

- [x] Preserve Python 3.10 support, public tool signatures and legacy text results.
- [x] Add structured results, object-compatible schemas, conservative annotations and explicit failure flags.
- [x] Expose guidance resources, prompts and document-type completion without opening user documents.
- [x] Add cooperative cancellation checkpoints before staged publication.
- [x] Scope cancellation IDs and progress/log notifications to the originating session.
- [x] Exercise authenticated persistent Streamable HTTP, session SSE, deletion, expiry and framing limits.
- [x] Retain legacy SSE selection and loopback-only raw TCP.
- [x] Verify stdio and HTTP through an installed wheel and the optional official SDK smoke script.

The historical integration report in `validation/umcp-upgrade.json` records 1,126 committed passes per supported Python runtime, four additional local-only tests, three optional LibreOffice skips, 19 Gherkin cases / 159 steps and 13 installed-wheel checks. Those measurements retain their original source/run identifiers. They are not new executions at a rewritten commit.

## Fixture and dependency cutover

The shared fixture submodule replaces local fixture/feature copies. A fresh pinned dependency installation replaces repository-local transport files without changing server APIs. Current commands and dependency checks are in [testing](../testing.md), and the protocol contract is in [transport integration](../umcp-core.md).

Native Office rendering, Windows executable mutation workflows and production proxy deployment remain unverified. No production service is deployed by this source migration.
