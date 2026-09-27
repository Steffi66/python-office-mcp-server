## Documentation review, 2026-09-26

This file records the 2026-09-26 documentation audit. For the active fixture tag and scoped test results, use [testing](testing.md#fixture-migration-verification) and `tests/fixtures-pin.json`.

### Canonical workflow contract cleanup

At that review, test instructions used `workflows/mutation-safety.feature` and `contracts/mutation-safety.json`. The root manifest seals both artifacts; fixture IDs resolve through the same registry. A nested pack seal and generated expanded-case JSON are no longer needed. The official Gherkin compiler derives the same 19 stable case identities.

The compact contract retains exact ZIP membership, read-back facts, member hashes and the allowed changed parts. Tests derive the preserve set as all members outside that allowance; it matches every previous preservation hash. Original fixture derivation records remain in root asset provenance alongside import origins. The lineage checks still run.

Earlier reports below describe the formats and results at their recorded source revisions. Use the linked testing guide and pin record for the active contract layout and fixture release.

### Grouped fixture and dependency migration

That review covered 16 tracked Markdown documents. Setup requires recursive submodule initialisation and Git for the exact transport dependency. Tests resolve schema-2 fixture IDs through the manifest, preserve one physical payload per digest, and refuse dirty facts/workflows before collection. The grouped layout is `fixtures/<format>/<scenario-group>/`; aliases are metadata, not compatibility directories.

The instructions distinguish candidate checks in an isolated clone from verification of a published annotated release. Historical counts, source IDs and source-pack seals are labelled as historical evidence. Native catalogue staging retains explicit semantic gaps and grants no execution credit; reusable generated-input inventory is separate unfinished work.

The direct review checked 60 local links/anchors and parsed 40 Python/JSON snippets across the 16 documents. Snippet parsing checks syntax, not native Office rendering or every example workflow. The additional independent documentation review timed out and is not counted as a pass. [Testing](testing.md) and the source-pinned migration report give current runtime scopes.

### Earlier documentation-only review

The review checked the README, operating/testing guidance, writer scope and OOXML research notes against the Python source at `7bcd040`. Corrections in this batch change documentation only. Shared contract bytes, recorded validation results and runtime code are unchanged.

| Finding | Correction |
|---|---|
| Development install omitted test dependencies; GUI path/VS Code naming guidance was inconsistent | Install the `dev` extra, use explicit interpreter/script paths when uninstalled, and keep the configured server name consistent |
| Acceptance setup omitted its Git dependency | Require a complete checkout and Git on `PATH`; explain when the ledger is refreshed |
| Stdio-only wording missed optional network transports | Document `--port`, `--host` and `--tcp`, legacy HTTP/SSE behaviour, lack of authentication/TLS and stdio-only workflow validation |
| Preview and atomic-write descriptions omitted prerequisites | Explain writable staging directories, temporary storage, crash leftovers, process-local locking and external-writer races |
| Receipt fields implied universal counts or successful publication | Distinguish planned/matched/applied operations, early error results, no-op outputs and proposed package diffs |
| Word acceptance and XLSX cache descriptions exceeded implemented coverage | Limit Word acceptance to main-document insertion/deletion wrappers and XLSX invalidation to cell-level formula caches; document unsupported stories/revisions/cache families |
| Format research notes mixed implementation status with general file-format features | Label sketches, remove stale pending work and unsupported Office-validation claims, distinguish legacy/modern comments, correct sheet-protection flag semantics and cached-value guidance |
| Trust-boundary guidance was missing | Document filesystem privileges, untrusted input limits, VBA/signatures, network exposure and sensitive logs/caches |

An independent read-only review found the development-extra, Git-prerequisite and VS Code naming issues. Its claim that no uninstalled-client example existed was only partly correct: a later example existed, but it relied on an unspecified interpreter. The revised README groups explicit virtual-environment configuration with the uninstalled workflow.

## Checks performed

* Parsed Python example blocks across 13 Markdown files and checked 43 README tool-call signatures against the current server class. Research snippets were syntax-checked, not executed as complete package-editing programs.
* Checked 46 local documentation links, heading anchors and JSON examples. External specification links were included as references; live endpoint availability and normative schema conformance were not tested.
* Ran one focused batch covering discovery, sealed inputs, acceptance, ledger rules, stdio, text preservation and revision reading: **67 passed in 3.15s**.
* Verified all 17 sealed contract artifact hashes and unchanged historical validation JSON. The two pre-existing untracked Python files retain their hashes.
* Dry-ran the documented frozen development sync. It was not applied to the existing project environment.

## Follow-up outside this documentation change

The Python implementation uses `application/vnd.openxmlformats-officedocument.wordprocessingml.commentsExtended+xml`. The shared content-type registry now records specification evidence for that value and a separate disputed alias. The Python constant is tested against the specified registry entry; native Office reopen validation remains separate.

`office_patch(track_changes=False)` is not an untracked-edit switch in the current dispatch. `word_accept_all_changes` has a broader name than its implemented scope. Those limits are documented; API changes need separate regression cases and compatibility decisions.

Native Office rendering, Windows executable mutation workflows and network transport security were not verified. The existing three LibreOffice skips remain skips; documentation review does not close them.
