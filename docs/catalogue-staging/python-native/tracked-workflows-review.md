# Tracked-change workflow source review

Ten definitions in [`tests/test_track_changes.py`](../../../tests/test_track_changes.py) were reviewed at Python `eae39da51b6c6585385efc995967028803e1328b`. Their descriptions now distinguish reported counts, saved XML/text checks and library-reopen smoke tests. The six XML-helper scenarios reviewed earlier are unchanged. No native tests or Office operations were run for this catalogue pass.

## Assertions and limits

All candidate suffixes below follow `@candidate-python-track-changes-`. Each definition has one recorded native case and no parameter decorator.

| Native method | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| test_replacement_preserves_surrounding_text | `c3917b3be8` | Truthy success; output opens with python-docx and has at least four paragraphs | No text, replacement or surrounding-content comparison |
| test_changes_appear_in_correct_paragraph | `a26bfce76d` | Truthy success and total_changes=2 for two marker-bearing body paragraphs | No saved paragraph identity/content check |
| test_replacement_across_split_runs | `28bf7b827a` | Truthy success and total_changes=1 for a target spanning two setup runs | No output reopen, replacement text or run-formatting check |
| test_changes_in_table_cells | `88c3d25f1c` | Truthy success and total_changes>=2 with the simple fixture | Its two body hits can satisfy the count without any table-cell edit |
| test_accept_removes_del_elements | `54c2ca5d3c` | success is True; removal/acceptance counters each 1; saved document.xml has no descendant del/ins; concatenated itertext contains inserted text and excludes deleted text | No other story parts, formatting, source preservation or rendering check |
| test_accept_preserves_inserted_text | `19f5e586ed` | success is True; nonempty output paragraph texts equal [Before INSERTED After] | Empty paragraphs are filtered; no XML-wrapper or formatting assertion |
| test_enable_sets_trackRevisions | `d650cc1bac` | Truthy success; decoded settings contains trackRevisions | Token presence alone does not validate the element or enabled state |
| test_patch_enables_trackRevisions_in_settings | `81b9044a8f` | Truthy success; settings contains the token but not two literal disabled spellings | Different prefixes, quoting, spacing, attribute order or values are not ruled out |
| test_document_opens_without_corruption | `2c61301c0a` | Truthy success; python-docx opens output and paragraph text reads raise no exception | No Microsoft Word execution, text comparison or full corruption/schema validation |
| test_xml_is_well_formed | `ed6f1a7b5a` | Output ZIP opens and every selected .xml member parses with ElementTree; ParseError explicitly fails the test | No .rels parsing, minimum selected-member count, result.success, schema or rendered check |

The shared fixtures are defined in [`tests/conftest.py`](../../../tests/conftest.py). `simple_docx` has two body occurrences of `<Customer Name>` and a third in a table cell. `multi_paragraph_docx` has a heading and four body paragraphs, including four PLACEHOLDER occurrences. The output paragraph threshold of four does not require the original five paragraphs or their contents to survive.

The accept-all inputs use the native insertion/deletion helpers before saving. One combines deleted text and inserted text in a single paragraph; the other surrounds INSERTED with ordinary `Before ` and ` After` text. All ten operations request a distinct output path. None compares post-call source bytes or unrelated package members.

## Recovered automated checks

The earlier extraction dropped exception-based checks. `test_document_opens_without_corruption` catches any exception from python-docx opening/paragraph reading and calls pytest.fail. `test_xml_is_well_formed` calls ElementTree.fromstring for member names ending in `.xml` and fails on ParseError. These are automated checks; they provide narrower evidence than their compatibility-oriented names suggest.

The original gap text `No machine-checked observable postcondition in the native test definition` is retained in the mapping as historical extraction provenance. An appended source-review correction explicitly supersedes it. The rebuilt scenario describes the parsing check rather than manual inspection. Other gaps remain unresolved; this correction supplies no new runtime execution.

The settings checks operate on decoded strings: the patch case excludes only `trackRevisions w:val="false"` and `trackRevisions w:val="0"`. Their assertions do not parse namespace-qualified settings or normalise Boolean values.

## Inventory and validation

The [validation record](tracked-workflows-validation.json) checks Gherkin parsing/compilation, selected scenario/mapping agreement, unchanged earlier helper scenarios, source/helper hashes, native case identities and prior gap text. All 192 earlier entries and messages remain. One existing entry gains a correction; nine new entries bring the total to 201. There are now 74 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution or parity credit.

All 16 definitions in `test_track_changes.py` now have source-reviewed descriptions across this pass and the [earlier helper review](tracked-xml-review.md). That completes this module's review only. The historical broad denominator stays **1,022 definitions / 1,147 native cases plus 19 shared cases**, without recollection. Shared v0.12, runtime, native assertions, earlier review artefacts and user files are unchanged. Broader reconciliation and generated-seed inventory are incomplete.
