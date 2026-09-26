## Documentation review, 2026-09-26

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

Content-type compatibility requires specification evidence and independent consumer validation.

`office_patch(track_changes=False)` is not an untracked-edit switch in the current dispatch. `word_accept_all_changes` has a broader name than its implemented scope. Those limits are documented; API changes need separate regression cases and compatibility decisions.

Native Office rendering, Windows executable mutation workflows and network transport security were not verified. The existing three LibreOffice skips remain skips; documentation review does not close them.
