# Comment-reply and roundtrip source review

Seven definitions in [`tests/test_word_comment_replies.py`](../../../tests/test_word_comment_replies.py) and three in [`tests/test_word_comment_roundtrip_fixture.py`](../../../tests/test_word_comment_roundtrip_fixture.py) were reviewed at Python `af579a032642cac57bd2616eee9583fd3f7f1a73`. Each has one recorded collected case and no parameter decorator. Candidate IDs, collected-case identities and native source hashes are unchanged. No native tests or Office operations were run for this review.

## Reply assertions

The reply fixture saves `Please review this section.`, adds `Initial reviewer comment` by `Reviewer` to `review this section`, checks addition success and a readback count of at least one, then captures the first returned ID. The rewritten feature uses this setup as its Background.

All reply candidate suffixes below follow `@candidate-python-word-comment-replies-`.

| Native check | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| reply_to_existing_comment | `634c069b81` | Success, parent ID echo, non-null reply ID; saved parent/reply comments and first paragraphs exist; parent paraId is truthy and reply paraIdParent matches it | No reply text/author readback, ordering, or nonempty reply-owned paraId assertion |
| reply_invalid_comment_id_returns_valid_ids | `aa375068b3` | Reply to `999` returns error text containing `Valid IDs` and a list-typed valid_comment_ids | No list contents, completeness, exact IDs or refusal byte-preservation assertion |
| reply_preserves_existing_replies | `450fd39171` | Two successes, distinct returned reply IDs, and both `First reply` and `Second reply` in text readback | No exact count, ordering, thread structure or duplicate exclusion |
| reply_adds_parent_paraid_when_missing | `93084aabed` | After removing the first parent paragraph's paraId and rewriting comments XML, reply succeeds; saved parent has a truthy new paraId and reply paraIdParent matches | No deterministic ID, reply-owned paraId, package-metadata or unrelated-part assertion |
| multiple_replies_have_unique_ids_and_paraids | `b01d533716` | Three sequential replies succeed; returned IDs and saved first-paragraph paraId values are each pairwise distinct | Set-cardinality checks do not themselves require non-null IDs; saved comment/paragraph lookup must also succeed. One missing paraId can satisfy the final uniqueness assertion |
| reply_author_fallback_from_identity | `f0ffd6d6a9` | With _comment_author set and author omitted, reply succeeds and author is either `Fixture Reviewer` or DEFAULT_COMMENT_AUTHOR | Does not require the configured identity to win or inspect serialized author metadata |
| reply_to_output_path_leaves_source_unchanged | `73beff4b9c` | Reply succeeds, output exists, source comment_count is unchanged and output count rises by one | Counts alone do not establish source-byte or comment-content preservation, or output reply text/linkage |

The former uniqueness scenario reduced the loop to an empty-list/set comparison and omitted the saved paragraph-ID check. It now records all three inputs and both uniqueness checks. These are one native test with three sequential operations, not three parameter instances. The missing-parent-ID scenario now includes the XML edit before the reply.

## Roundtrip assertions

The roundtrip helper saves two paragraphs, `Roundtrip scope item` and `Secondary note`. Candidate suffixes below follow `@candidate-python-word-comment-roundtrip-fixture-`.

| Native check | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| word_comment_roundtrip_direct_tools | `96e109e5b6` | Add succeeds; one initial thread has an open root; reply auto-resolution succeeds; threaded reread has that root done and contains the reply ID; reopening via reply ID reports the root and returns it open | No exact post-reply thread/reply count, reply text/author readback or package-byte preservation |
| word_comment_roundtrip_unified_tool | `cf0e06a82a` | Unified add/reply succeed, initial thread count is one, resolve/reopen results and filtered root membership agree, deletion returns success | No read after deletion, persisted deletion proof, reply-cascade policy or reply-linkage assertion |
| word_resolve_roundtrip_with_output_path | `ec40884570` | Source starts open and remains open after resolution to a copy; the same ID is resolved in the copy and open after reopening it | State observations do not establish source-byte preservation, output member preservation or source state after the later copy reopen |

The direct feature now includes threaded readback between auto-resolution and reopening. The output-copy feature explicitly reads the source as well as the output. All sequences retain intermediate assertions instead of presenting final state as evidence for every preceding action.

## Reconciliation and validation

Python synthesises a missing parent paragraph ID and redirects resolution/reopening through reply IDs to the root in these tests. Those expectations remain distinct from the earlier Bun selected-existing-entry comment operation. No Bun source or tests were revisited for this catalogue pass, and no parity credit is assigned.

The [validation record](comment-replies-validation.json) covers parser/compiler checks, candidate/mapping agreement, retained collected cases and gaps, source hashes and local documentation links. The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and has not been recollected. All 150 prior gap entries remain; ten new assertion-limit entries bring the total to 160. The mapping now has 29 `native-source-reviewed` definitions, including the nine XML-family and ten comment-resolution definitions reviewed earlier. This overlaps historical manual-override work and is not new execution coverage.

The shared v0.8 pin, runtime, native assertions, earlier review artefacts and original untracked user files are unchanged. Catalogue execution stays `not-executed-by-catalogue`. Broader semantic reconciliation and generated-seed inventory are incomplete.
