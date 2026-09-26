# Staged writer scope

Existing-document mutations listed below use private-copy staging, package admission and library reopen checks, process-local writer locks and one atomic destination replacement when they commit. The decorator preserves each tool's signature; only `office_comment` gains the four mutation modes. A nested call on the same private path does not create another transaction.

## Enrolled tools

- Unified: `office_patch`, `office_table` (except get), `office_comment` (except get), `office_image`.
- Excel: `excel_add_chart`, `excel_add_sheet`, `excel_delete_comment`.
- PowerPoint: `pptx_add_slide`, `pptx_add_table`, `pptx_delete_comment`, `pptx_delete_slide`, `pptx_duplicate_slide`, `pptx_hide_slide`, `pptx_log_changes`, `pptx_reorder_slides`, `pptx_set_notes`, `pptx_import_slide` (target presentation is staged; donor remains read-only).
- Word: `word_accept_all_changes`, `word_cleanup_sow`, `word_enable_track_changes`, `word_insert_at_anchor`, `word_patch_with_track_changes`, `word_delete_comment`, `word_reply_comment`, `word_reply_to_comment`, `word_resolve_comment`.

Existing modes apply to the transaction boundary. Tools without a mode parameter keep their signatures and default to best-effort publication after package checks. A generic tool call is one mutation operation; its original detailed counts remain in the response. `changes_applied` records committed operations, not the number of cells/paragraphs it contains.

Word/PPTX tables now honour the unified output path and preview mode. Nested legacy `data.output_path` is normalised at the boundary and removed from internal dispatch. Read-only get operations bypass staging.

## Separate contracts

Output-only creation (`word_from_markdown`, `excel_from_markdown`, `pptx_from_markdown`) and template-driven SOW generation have no existing source argument that can be enrolled with this decorator. They retain their current generation contracts and tests. Template copy is also separate. Broad creation API redesign is outside this preservation-safety release.

Deprecated internal writers are not all decorated individually. Calls reached through an enrolled unified tool run on its private copy. Direct calls to an undecorated internal helper are not covered. External source paths used by slide import are read-only inputs but are not locked against other applications.

## Receipts and operation modes

`office_patch`, `office_table` and `office_comment` expose `best_effort`, `safe`, `strict` and `dry_run`. Other enrolled tools accept modes only where their existing signature declares them. `safe` requires a distinct output but permits a supported subset; `strict` rejects the transaction on unmatched/skipped targets. Preview runs on a private copy and reports zero committed operations.

`changes_planned` and `changes_applied` separate staged outcomes from publication. Inspect per-target `results[].applied`, error/diagnostic fields and the source fingerprint. `package_diff` lists added, removed and changed member payloads; equivalent-only XML serialisations are separate. It describes the proposed result during preview and the committed result after a successful write. A later refusal can retain proposed diff details, so check `changes_applied` before treating them as committed.

Word and PowerPoint adjacent-run replacement retains boundary formatting. Word fields/hyperlinks/revisions and PowerPoint fields/paragraph breaks form barriers; a match cannot cross them. PPTX whole-shape replacement retains its existing clear/autofit semantics. Duplication gives charts and embedded workbooks independent parts; notes require explicit `pptx_import_slide(include_notes=True)`.

## Limits

See [operating limits](operations.md) for writable staging directories, path resolution, receipt interpretation and trust boundaries. Replacement publishes a complete staged file; it does not certify OOXML schema validity, rendering fidelity or crash durability. XLSX style/cache dependency repair currently belongs to `office_patch` and cell-level formula caches; it is not a general guarantee for chart, external-link or array-result freshness. Table/comment/chart saves still use the underlying library serialiser and may lose unsupported structures. Package-level preservation ports need independent tests before extending that claim. Process locks do not exclude arbitrary external writers; fingerprints detect most stale-file changes but are not an operating-system compare-and-swap.
