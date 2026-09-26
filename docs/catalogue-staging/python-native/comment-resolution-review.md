# Comment-resolution source review

Ten native definitions in [`tests/test_word_comment_resolution.py`](../../../tests/test_word_comment_resolution.py) were reviewed at Python `1b74a40eae2389b7bbfd5d3586f53de014b5c6aa`. Each has one recorded collected case and no parameter decorator. Their candidate IDs and source hash are unchanged. The feature now describes the generated inputs, action order and assertions directly; the mapping records `native-source-reviewed` and the limits below. No Office operations or native tests were run for this documentation review.

## Assertions and limits

All candidate suffixes below follow `@candidate-python-word-comment-resolution-`. T1–T7 refer to the corresponding native function names; the other rows use the native function suffix.

| Native check | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| T1 mixed done state | `be256c979c` | Resolving the first captured ID succeeds; unfiltered reread has first done true and second done false | No XML or unrelated-part preservation assertion |
| T2 resolve and reread | `a31be46775` | Result success/done true; resolved-filter output contains that ID with done true | The docstring mentions commentsExtended, but this test never inspects its XML |
| T3 reopen | `d243f1fea2` | Resolve succeeds, reopen returns success/done false, and open-filter output contains that ID with done false | No direct assertion of `w15:done="0"` despite the docstring |
| T4 resolve reply | `78d1a129df` | Reply creation and resolution succeed; response identifies the root and reread gives root done true | No reply done-state assertion or proof that only the root changed |
| T5 commentsIds fallback | `2e2621a412` | After removing the first paragraph's ID and writing an explicit commentsIds mapping, reread returns the mapped para_id | One paragraph only; no first-versus-last precedence test, metadata repair or relationship/content-type validation |
| T6 absent commentsExtended | `8d2f1be135` | Part absent before resolution; resolution succeeds; reread para_id is truthy; new part contains matching commentEx with done="1" | No relationship/content-type, entry-count, unrelated-part or exact generated-ID assertion |
| T7 resolve/reopen sequence | `6e862657a6` | Resolve succeeds, resolved comment_count is at least one, reopen succeeds, open output contains the target with done false | Intermediate resolved count does not identify the target; no XML state assertion |
| exposes_new_metadata_and_filters | `53363ffd9d` | First entry has four metadata keys; resolve succeeds; returned open/resolved/mine entries satisfy their respective predicates | Empty lists satisfy all three predicates; no cardinality, completeness, metadata-value or case-varied query assertion |
| threaded_format_groups_replies | `6940bf041d` | Reply succeeds; thread_count is at least one; first root ID matches; first thread contains reply ID | No exact thread/reply count, nesting beyond one reply or duplicate-exclusion assertion |
| reply_auto_resolve_marks_thread_done | `18ccc72cf3` | Reply returns success/resolved true; resolved-filter output contains root ID with done true | No independent reply done-state or serialized commentsExtended assertion |

The two-comment helper writes paragraphs `Alpha target` and `Beta target`, adds `Comment alpha` by `Manuel` and `Comment beta` by `Rui Carmo`, and checks both additions succeed. T1, T2, T3, T7 and the filter test select IDs from subsequent readback. Their assertions do not independently identify the first returned comment by author or text.

T5 performs package surgery before its final read. It takes the existing first-paragraph `w14:paraId` or `0F0E0D0C`, removes the attribute, writes `word/commentsIds.xml` with a `w16cid:commentId` mapping, and rewrites the archive. The previous extracted feature omitted this setup. T6's absence check now appears before the resolving action; T3, T7 and the filter test also retain their actual resolve/read/reopen order.

## Python and Bun remain distinct

Python's source at this review revision selects the first comment paragraph, falls back to commentsIds mappings, creates missing resolution metadata and redirects reply resolution to the root. These tests exercise a single-paragraph fallback, absent-part creation and root redirection. They do not establish multi-paragraph precedence or every metadata-synthesis branch.

The earlier Bun comment review recorded a selected-existing-entry operation using the last paragraph and refusing missing metadata. That separate behaviour must retain its own central expectations. No Bun comment source or tests were rerun in this catalogue pass, and no cross-runtime parity is awarded.

## Inventory and verification boundary

The recorded broad inventory remains **1,022 definitions / 1,147 native cases plus 19 shared cases**. It predates the later guard and execution-lane additions; this review does not refresh that denominator. All 140 prior gap entries are retained. Ten reviewed definitions now also have explicit assertion limits, bringing the gap list to 150 entries. Nineteen definitions carry `native-source-reviewed` (the nine earlier XML-family definitions plus these ten); this count overlaps the historical manual-override work and must not be added to it as new coverage.

The [catalogue validation record](comment-resolution-validation.json) checks Gherkin parsing/compilation, stable candidate and collected-case identities, unchanged source hashes, retained gaps and documentation links. Its execution status remains `not-executed-by-catalogue`. Full native capture, central reconciliation and generated-seed inventory are still incomplete. The shared v0.7 pin and all three execution lanes are unchanged.
