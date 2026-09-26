# Patch transaction source review

Seven definitions in [`tests/test_patch_transactions.py`](../../../tests/test_patch_transactions.py) were reviewed at Python `7aaa45b0197c00679ae6e178f02bce4ab8f2c7dc`. Their 30 recorded cases and native parameter tables are unchanged. The rewritten feature restores the distinction between pre-call snapshots and post-call observations. No native tests or Office operations were run for this catalogue review.

## Inputs and operations

The module generates its own inputs: XLSX active-sheet A1 is `before`; DOCX has a single `<Present>` paragraph; PPTX has slide-1 title `Original title` and subtitle `Original subtitle`. A destination is either the source path, a missing distinct output, or a distinct output containing the exact bytes `existing output must survive failure`. Native `snapshot()` captures immediate file names and bytes; it does not record filesystem metadata.

These tests call `OfficeServer().tool_office_patch` directly. They do not open an MCP connection. Only the preview, strict and PPTX accumulation tests specify a mode. The other four omit both mode and output_path; their descriptions retain that call boundary instead of supplying an inferred argument.

All candidate suffixes below follow `@candidate-python-patch-transactions-`.

| Native definition suffix | Candidate suffix | Cases | Asserted outcome and limit |
|---|---|---:|---|
| preview_never_modifies_source_or_destination | `ae7eee373d` | 9 | Truthy success; applied=0, planned=1; first result applied falsey; file snapshot and sorted entry names equal their pre-call values. No filesystem metadata or external-path checks |
| strict_refusal_is_atomic | `d45a22b5f7` | 9 | success is False; applied=0; returned results all have falsey applied; file snapshot unchanged and no immediate directories. The result predicate permits missing/empty results; no exact diagnostics or crash/concurrency assertion |
| presentation_batch_accumulates_at_distinct_output | `69c7d57f18` | 2 | applied=2; reopened output has changed title and subtitle; source bytes unchanged. No success/status/per-result assertion or unrelated output-member check |
| word_best_effort_counts_each_placeholder | `86b17c8885` | 1 | partial_success, applied=1 and ordered flags [True, False]; saved paragraph strings joined through `_get_text_with_track_changes` equal `changed`. No revision-markup/author/date assertion |
| invalid_range_does_not_leak_partial_rows_in_best_effort | `6a9d778173` | 3 | applied=1; reopened A1=`before`, B1=None and D1=`valid`. A2/B2 are not inspected despite the range target A1:B2; no full-range rollback assertion |
| missing_pptx_placeholder_is_not_applied | `b2522e469b` | 1 | applied=0 and source bytes equal pre-call bytes. No success/status, refusal reason or result-count assertion |
| invalid_excel_address_preserves_source | `ccdfa52bb0` | 5 | applied=0 and unchanged source bytes for A0, XFE1, A1junk, A2:A1 and A0:B1. These cases do not define the complete address grammar |

The nine preview cases are three formats/targets across three destinations. The nine strict cases use the same destination set and format-specific good/bad targets. PPTX safe output tests cover absent and existing destinations only. The invalid range values remain exactly `[['bad', 'partial'], ['short']]`, `[['bad', 'partial'], None]` and `[['bad', 'partial'], [1, {}]]`; the valid D1 edit follows each invalid range attempt. Invalid addresses use `[[1, 2]]` for colon-containing targets and `new` otherwise.

The prior extraction rendered a pre-call and post-call snapshot as identical expressions, obscuring actual preservation assertions. Those are now explicit before/after comparisons. Existing parameter rows, node IDs, parameter groups and values are retained byte-for-byte or structurally unchanged as appropriate. Each candidate remains one Scenario with a native-variant data table; the parser compiles seven catalogue cases, while the recorded native collection has 30. Neither count is execution evidence from this pass.

## Inventory and verification

The [validation record](patch-transactions-validation.json) checks all 67 features and 1,022 stable candidate IDs, mapping/scenario agreement, preserved parameter tables and native cases, source hashes, earlier reviews and local links. All 168 earlier gap entries remain unchanged; seven assertion-limit entries bring the total to 175. The mapping now has 45 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no new execution credit.

The broad recorded denominator stays **1,022 definitions / 1,147 native cases plus 19 shared cases**. No collection refresh was performed. These native descriptions are separate from the existing shared mutation lane, its 19 cases/159 steps and release-pinned execution reports; no central mapping or binding was added. Shared v0.10, runtime, native assertions and original user files are unchanged. Broader semantic reconciliation and generated-seed inventory are incomplete.
