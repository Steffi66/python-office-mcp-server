## Running the stdio server

Without transport flags, `office-mcp-server` reads MCP messages from stdin and writes responses to stdout. The client starts the process with the filesystem permissions of its configured account; use an absolute executable path when a GUI client's `PATH` differs from your shell.

Use unencrypted `.docx`, `.xlsx`, `.xlsm` and `.pptx` inputs. Extension dispatch is not file conversion: legacy `.doc`, `.xls` and `.ppt` names do not make binary Office files readable by the XML libraries. Encrypted or IRM-protected packages are unsupported. Keep the original extension when choosing an output, especially `.xlsm`; the writer is not a format converter.

## Transports

The bundled `aioumcp.py` recognises these optional modes:

| Invocation | Behaviour |
|---|---|
| `office-mcp-server` | Newline-delimited JSON-RPC over stdin/stdout |
| `office-mcp-server --port 8765` | Legacy HTTP/SSE on `127.0.0.1`; `GET /sse`, `POST /message` |
| `office-mcp-server --port 8765 --tcp` | Legacy raw TCP JSON-RPC listener |
| `--host ADDRESS` with `--port` | Override the default loopback bind address |

The network modes have no built-in authentication or TLS and should not be bound to untrusted interfaces. HTTP/SSE here is the older MCP transport, not a verified Streamable HTTP implementation. The preservation release tested stdio mutation workflows; it did not validate network sessions or security. Prefer stdio unless you deliberately provide a protected network boundary.

## Files and temporary storage

Prefer absolute document paths. Input resolution checks the supplied path, then roots such as `MCP_WORKSPACE_ROOT`, `GITHUB_WORKSPACE` and `WORKSPACE_FOLDER`, plus implementation fallbacks. This is lookup convenience, not a workspace access boundary. Output paths are not resolved through the same root search; a relative output is relative to the server's working directory.

The destination parent directory must already exist and be writable. Staging creates a private temporary directory beside the destination so the final replacement stays on the same filesystem. This includes `dry_run`: it runs the actual edits on the private copy and may need memory, disk space and write permission comparable to a commit. It does not publish source/destination changes, and normal return/failure paths clean up temporary files. A process kill or machine failure can leave temporary files behind.

When no output is supplied, mutating tools generally overwrite the source. Use a distinct output for review. `safe` requires one, but it can commit a supported subset; use `strict` with an explicit output when every requested target is required. See [writer scope](writer-scope.md) for tools and modes.

Locks serialise enrolled writers inside one server process. File fingerprints check for changes during staging and before publication; they do not lock other applications or eliminate the final check-to-replace race. Do not run multiple writers against the same document. Hard-linked input/output files are refused. Symlink paths are resolved and writes address the target; the symlink itself is retained.

## Interpreting a mutation result

Tool errors can be a JSON-RPC error or an ordinary tool result containing `error` or `success: false`. Early validation returns may omit the usual receipt fields. Do not treat transport success or the presence of an output path as proof that an edit committed.

For a completed staged call:

* `changes_planned` counts successful staged operations; `changes_applied` counts operations committed to the destination. These are not universal cell, occurrence or paragraph counts.
* `results[].applied` distinguishes a matched/staged operation from a committed one. The nested `success` field can still describe the staged match on a strict refusal; inspect the top-level result and applied flag.
* `unmatched_targets`, `skipped_targets`, `warnings` and format-specific details explain partial or refused work. `strict` refuses when those decisions make the request incomplete.
* `source_sha256` fingerprints the source used by that call. It is not a client-supplied compare-and-swap token. A later call resolves the source again.
* `package_diff`, when present, lists changed/added/removed member payloads. Preview describes its proposed output. A later failure can leave proposed diff details in the response even though `changes_applied` is zero.

A no-match/no-op call can produce zero applied changes and no distinct output file. Reopen the reported destination only after checking the result. Compare requested text/cells and run the relevant audit; archive reopening is not schema, calculation, rendering or semantic validation.

## Format-specific limits

Excel values are coerced: numeric-looking strings, currency strings and percentages may become numbers. There is no force-text option for preserving numeric identifiers such as `"00123"` as text. A string beginning with `=` is a formula; validate user content before passing it as a cell value.

`office_patch` invalidates cached values on cell-level formula elements across worksheets and requests recalculation. `office_read` defaults to cached values; use `include_formulas=True` to read expressions. Neither operation calculates answers. Dependency analysis is not performed, and chart caches, external-link caches and array-spill/follower results are not covered by a general freshness guarantee. Table/comment/chart/sheet operations have staged publication but use the library serialiser and lack the patch path's opaque-member preservation guarantees.

Word tracked replacement supports adjacent plain-text runs. Fields, hyperlinks and existing revisions are barriers; it does not provide arbitrary all-story spans or full comparison/redlining. `word_accept_all_changes` unwraps insertions and removes deletions within the main document XML only. Separate story parts, move/format revisions and reject-all are unsupported by that operation. `office_patch` currently retains a `track_changes` compatibility argument without passing it into its editing dispatch; setting it false is not an untracked-edit switch.

PowerPoint whole-shape edits can clear run formatting and set autofit, matching their existing contract. Literal text replacement preserves boundary-run properties within supported spans. Independent chart/workbook parts in a duplicate do not establish theme or visual-layout equivalence.

## Processing untrusted or sensitive files

The server has no filesystem sandbox, per-path authorisation layer or network authentication. Limit its OS account, mounts and MCP client tool permissions. Avoid exposing privileged accounts to untrusted documents or unreviewed tool arguments. These controls are the caller's responsibility.

Staged writes use bounded package admission: 10,000 members, 64 MiB per inflated member, 256 MiB compressed package/inflated total and an inflation ratio limit of 1,000. These are implementation defaults, not MCP arguments. See [package admission](provenance/package-adoption.md) for exactly which paths are guarded. The limits do not bound every XML-tree, library-object or temporary-copy allocation, and not every read-only or creation tool uses this guard.

Macro-enabled input can retain VBA bytes. This server does not execute VBA, but a later Office application may. Admission checks are not antivirus scanning; opening a modified document in Office is a separate security decision. Editing signed packages can invalidate signatures, and signature preservation is not certified.

Logs, transcripts, failure artifacts and metadata caches may contain file paths or document-derived content. `OFFICE_MCP_METADATA_CACHE_DIR` changes the Word metadata-cache location. Protect these files and inspect them before sharing reports or uploading CI artifacts. Comment attribution defaults can be set with `MCP_AUTHOR`, `MCP_AUTHOR_IDENTITY` and `MCP_AUTHOR_INITIALS`; they describe authorship metadata, not authenticated identity.
