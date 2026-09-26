# Mutation diagnostics and mode source review

Five definitions in [`tests/test_mutation_diagnostics.py`](../../../tests/test_mutation_diagnostics.py) and six in [`tests/test_mutation_modes.py`](../../../tests/test_mutation_modes.py) were reviewed at Python `a44009f1a9c23a2d79759a06569d3c5ac44d75c3`. Each has one recorded native case and no parameter decorator. No native tests or Office operations were run for this catalogue pass.

## Diagnostic response checks

All diagnostic candidate suffixes follow `@candidate-python-mutation-diagnostics-`. These five definitions do not reopen saved documents or compare file bytes.

| Native method | Candidate suffix | Asserted outcome and limit |
|---|---|---|
| test_word_patch_section_emits_standard_fields | `571472667f` | success/status, first matched section target, empty unmatched list, diagnostics key and follow-up tool; no saved replacement text or diagnostics contents assertion |
| test_word_create_sow_from_markdown_surfaces_partial_success | `47d3962281` | success with partial_success, an unmatched section:assumptions, truthy unmapped_sections and follow-up tool; no output existence/content assertion |
| test_office_patch_word_all_miss_reports_failed | `cb38d01946` | success false, status either failed or skipped, no matched targets, truthy skipped_targets, office_inspect hint; skipped-target identity/count and file preservation untested |
| test_office_patch_excel_all_miss_reports_failed | `e9a6629de8` | success false, failed status, no matched targets/edited sheets, first unmatched target MissingSheet!A1, named merge strategy; reported preservation is not compared with saved bytes |
| test_excel_table_mutations_emit_standard_diagnostics | `1580998c58` | Append and update both return partial_success with truthy matched targets and named unknown-column targets; append has office_table hint, update has truthy updates |

The last test appends Engineer/2 with extra key Missing, then updates row_index=1 with Count=3 and extra key Unknown using the same tool and workbook. It does not inspect saved rows, ignored-column effects, actual update count or table metadata.

The SOW template contains Introduction/customer placeholder and Delivery approach/guidance sections. Markdown supplies Introduction and Assumptions under Sample SOW with Customer Contoso, Project Platform Review and Provider Microsoft. The diagnostics case omits mode; the separate mode case explicitly requests strict. Their outcomes are not merged.

## Mode and saved-file checks

Mode candidate suffixes follow `@candidate-python-mutation-modes-`.

| Native method | Candidate suffix | Asserted outcome and limit |
|---|---|---|
| test_office_patch_dry_run_does_not_modify_word_file | `cd0c13a3e2` | success true, dry_run echo and exact pre/post source bytes; no planned/applied count, directory or external-write assertion |
| test_office_patch_safe_requires_distinct_output_path | `e5e9ce01ea` | success false, safe echo, failed status with output_path omitted; no same-path, symlink/alias or byte-preservation check |
| test_word_create_sow_strict_rejects_unmapped_sections_without_writing | `98a5ec284e` | success false, strict echo, failed status and requested output absent; no source/template integrity, temporary-file or diagnostic identity check |
| test_office_table_excel_dry_run_does_not_write | `5c226b35fd` | success true, dry_run echo and exact pre/post source bytes; no destination/directory or planned-row assertion |
| test_office_table_excel_safe_requires_output_path | `bd31ead847` | success false and safe echo with output_path omitted; no status, same-path or source-preservation check |
| test_best_effort_preserves_existing_successful_path | `a5aa9665b7` | success true, best_effort echo, output exists and reopened active-sheet A3=Engineer; no B3, table-range/style, source-byte or complete-row assertion |

The diagnostics table fixture has Staffing range A1:B3 with Architect/1 and PM/1. The mode fixture has A1:B2 with Architect/1 only. Both use TableStyleMedium2 with row striping enabled and first/last-column and column-striping flags disabled. The rewritten scenarios retain these distinct inputs and compare dry-run bytes with captured pre-call snapshots rather than the extraction's self-comparisons.

All calls are Python methods. Unified cases combine OfficeUnifiedTools, WordAdvancedTools and ExcelAdvancedTools; they do not exercise an MCP transport. Safe omission failures are distinct from the broader same-path/alias behaviours tested elsewhere.

## Inventory and validation

The [validation record](mutation-diagnostics-modes-validation.json) checks Gherkin parsing/compilation, mapping agreement, stable IDs/cases, source hashes, prior gaps and local links. All 201 earlier gap entries remain unchanged; eleven new limits bring the total to 212. There are now 85 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution or parity credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and has not been recollected. Shared v0.12, runtime, native assertions, earlier review artefacts and original user files remain unchanged. Broader reconciliation and generated-seed inventory are incomplete.
