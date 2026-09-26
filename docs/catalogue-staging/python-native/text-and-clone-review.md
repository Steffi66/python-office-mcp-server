# Text preservation and slide-clone source review

Five definitions in [`tests/test_preserving_text_and_clone.py`](../../../tests/test_preserving_text_and_clone.py) were reviewed at Python `b87134bc1de14e85ef077674c1811ebf82cd703a`. Each has one recorded case and no parameter decorator. Candidate IDs, native cases and source hashes are unchanged. No native tests or Office operations were run for this catalogue review.

## Assertions and limits

All candidate suffixes below follow `@candidate-python-preserving-text-and-clone-`.

| Native definition suffix | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| word_split_span_preserves_boundary_fonts_and_revisions | `a58e306927` | applied=1; tracked-text helper returns `prefix Acme suffix`; surviving boundary runs retain exact text and bold/italic; first direct deletion contains `<Customer>` in two runs; ordinary paragraph text appears after accept-all | No insertion metadata, author/date, exact total revision count, accept-call result or post-accept formatting assertion |
| word_span_cannot_cross_field_barrier | `ee17cf0d07` | Strict patch across an empty fldSimple between two partial runs applies zero and leaves source bytes unchanged | No diagnostic/status, populated/complex field, or other barrier topology assertion |
| slide_split_run_replacement_preserves_properties | `fbd36c3e12` | One patch entry yields applied=1, both occurrences become Acme, first/last run bold/italic remain truthy | No exact run count, replacement-run formatting, other properties or package preservation assertion |
| duplicate_chart_has_independent_workbook_and_chart_part | `eda3af4e39` | Truthy success; original/clone chart and embedded workbook part names differ; after clone replace_data and save/reopen, original series stays [1,2] and clone becomes [9,8] | No exhaustive relationship graph, original-byte preservation, category readback, rendering or additional series/chart-type assertion |
| import_existing_notes_is_explicit_and_donor_unchanged | `f60f9a0596` | include_notes=True import succeeds truthily, donor bytes stay identical, receiver's last notes text contains Private note | No default/false notes policy, exact note text, slide count/title, old receiver-part preservation or notes-master graph assertion |

## Restored action order

The Word replacement spans two runs: bold `prefix <Cus` and italic `tomer> suffix`. The test reopens the document and checks text, boundary runs and the first deletion **before** calling accept-all. Only ordinary paragraph text is inspected after that second mutation. The previous extraction placed the accept action before all those assertions, losing this distinction.

The PowerPoint text case also uses a split occurrence, then a second whole occurrence in the italic run. It sends one patch entry and asserts `changes_applied == 1`; that count is not the number of replaced occurrences. It reopens the saved title paragraph to inspect text and boundary flags.

Chart setup creates a clustered column chart with categories A/B and one Series at [1,2]. After duplication, python-pptx changes the cloned chart to [9,8], saves, and reopens. The earlier feature omitted that mutation and its intervening save, leaving two unequal series values without the action that establishes their independence. The rebuilt scenario includes both saved reads and both part-name checks.

Field-barrier and notes-import cases now compare post-call bytes with a named pre-call snapshot instead of self-comparisons. Notes are supplied explicitly; no other include_notes branch is inferred. All tests call Python tool methods directly, without an MCP transport connection.

## Inventory and validation

The [validation record](text-and-clone-validation.json) checks Gherkin parsing/compilation, scenario/mapping agreement, native source hashes, stable IDs and collected cases, prior gaps and local links. All 181 prior gap entries remain unchanged; five new assertion-limit entries bring the total to 186. The mapping now has 58 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution or cross-runtime parity credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and was not recollected. Shared v0.12, runtime, native assertions, earlier review artefacts and original untracked user files are unchanged. Broader semantic reconciliation and generated-seed inventory are incomplete.
