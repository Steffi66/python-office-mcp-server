# Staged writer scope

Existing-document mutations listed below use private-copy staging, validated reopen, process-local writer locks and one atomic destination replacement. The decorator preserves each tool's signature; only `office_comment` gains the four mutation modes. A nested call on the same private path does not create another transaction.

## Enrolled tools

- Unified: `office_patch`, `office_table` (except get), `office_comment` (except get), `office_image`.
- Excel: `excel_add_chart`, `excel_add_sheet`, `excel_delete_comment`.
- PowerPoint: `pptx_add_slide`, `pptx_add_table`, `pptx_delete_comment`, `pptx_delete_slide`, `pptx_duplicate_slide`, `pptx_hide_slide`, `pptx_log_changes`, `pptx_reorder_slides`, `pptx_set_notes`, `pptx_import_slide` (target presentation is staged; donor remains read-only).
- Word: `word_accept_all_changes`, `word_cleanup_sow`, `word_enable_track_changes`, `word_insert_at_anchor`, `word_patch_with_track_changes`, `word_delete_comment`, `word_reply_comment`, `word_reply_to_comment`, `word_resolve_comment`.

Existing modes apply to the transaction boundary. Tools without a mode parameter keep their signatures and default to best-effort publication after validation. A generic tool call is one mutation operation; its original detailed counts remain in the response. `changes_applied` records committed operations, not the number of cells/paragraphs it contains.

Word/PPTX tables now honour the unified output path and preview mode. Nested legacy `data.output_path` is normalised at the boundary and removed from internal dispatch. Read-only get operations bypass staging.

## Separate contracts

Output-only creation (`word_from_markdown`, `excel_from_markdown`, `pptx_from_markdown`) and template-driven SOW generation have no existing source argument that can be enrolled with this decorator. They retain their current generation contracts and tests. Template copy is also separate. Broad creation API redesign is outside this preservation-safety release.

Deprecated internal writers are not all decorated individually. Calls reached through an enrolled unified tool run on its private copy. Direct calls to an undecorated internal helper are not covered. External source paths used by slide import are read-only inputs but are not locked against other applications.

## Limits

Atomic publication prevents partial files; it does not prove complete OOXML fidelity. XLSX style/cache dependency repair currently belongs to `office_patch`. Table/comment/chart saves still use the underlying library serialiser and may lose unsupported structures. Package-level preservation ports need independent tests before extending that claim. Process locks do not exclude arbitrary external writers; fingerprints detect most stale-file changes but are not an operating-system compare-and-swap.
