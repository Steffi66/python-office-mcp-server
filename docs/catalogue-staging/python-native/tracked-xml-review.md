# Tracked-change XML structure source review

Six definitions in `TestTrackChangesXMLStructure` in [`tests/test_track_changes.py`](../../../tests/test_track_changes.py) were reviewed at Python `a90503dd5473fa427d8a713cb353ce7a8e82ff79`. These helper-level tests inspect saved `word/document.xml`; they do not run a schema validator or Microsoft Word. No native tests or Office operations were run for this catalogue pass.

## Setup and assertions

Each test loads `simple_docx` from [`tests/conftest.py`](../../../tests/conftest.py), appends an empty paragraph, calls the tracked insertion/deletion helpers, saves a separate output and parses its document XML. The fixture has two placeholder paragraphs and a 2×2 table. Those original contents are not compared after helper calls.

All candidate suffixes below follow `@candidate-python-track-changes-`.

| Native method | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| test_insertion_has_required_attributes | `ef6e5bd3a7` | At least one ins; last ins has non-null id/author/date; author equals Test Author | No numeric/nonempty ID, valid date, total revision count or complete schema assertion |
| test_insertion_contains_run_with_text | `12023074dc` | At least one ins; last ins has a direct run; first run has a direct t whose first text is test insertion | Does not inspect every run/text node or exact counts |
| test_deletion_has_required_attributes | `095d85b1f1` | At least one del; last del has non-null id/author/date | Supplied Test Author is not compared; no numeric ID or date validation |
| test_deletion_uses_delText_not_text | `9f6d5aa0cf` | Last del has a run; first run has delText with first text deleted content and no direct t | Other runs and nested nodes are unchecked; no exact number of deletions or delText nodes |
| test_date_format_is_iso8601 | `c8394a6706` | Last ins date matches the numeric YYYY-MM-DDTHH:MM:SS prefix pattern | No end anchor, timezone/Z, valid calendar/time ranges or full ISO8601 validation |
| test_unique_ids_across_document | `68da4f2809` | Collected ins/del ID list length equals its set cardinality | No required four revisions, nonempty collection, non-null or numeric ID check; only document.xml is scanned |

The date assertion uses `re.match(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}", date_str)`. A valid-looking prefix is sufficient; the test's timezone wording is stronger than its assertion.

The uniqueness setup requests insertions `first`, `second`, deletion `third`, then insertion `fourth`, all by Test. Collection visits every descendant ins followed by every descendant del. The set-cardinality assertion can pass with no collected revisions or one missing ID among otherwise distinct values. Other tests' existence and metadata assertions do not strengthen this individual test.

These six descriptions retain the original candidate IDs and source locations. The other ten scenarios in the same feature are unchanged and still need their own source review. No positioning, acceptance, tracked-change enabling, rendered display or all-parts schema coverage is inferred from this class.

## Inventory and validation

The [validation record](tracked-xml-validation.json) checks parser/compiler output, selected scenario/mapping agreement, unchanged unselected scenarios, source/helper hashes, collected identities and prior gaps. All 186 earlier gap entries remain unchanged; six specific limits bring the total to 192. The mapping now has 64 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution or parity credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and was not recollected. Shared v0.12, runtime, native assertions, earlier review artefacts and original user files are unchanged. The separate read-only Bun oracle review grants these Python descriptions no external-validation credit. Broader reconciliation and generated-seed inventory are incomplete.
