# Slide-transfer source review

Five definitions in [`tests/test_pptx_slide_transfer_tools.py`](../../../tests/test_pptx_slide_transfer_tools.py) were reviewed at Python `24ade759541e4dd727222b88ac4c8488840362bb`. The feature now includes the generated decks, both repeated imports and captured pre-import package counts. No native tests or Office operations were run for this catalogue pass.

## Inputs and assertions

The fixture in [`tests/conftest.py`](../../../tests/conftest.py) instantiates `tools.pptx_slide_transfer_tools.PresentationSlideTransferTools`. This review concerns the tracked suite and tool fixture; the user-local `pptx_import_slide.py` and `tests/test_pptx_import_slide_standalone.py` were not source-reviewed or modified; validation only checks their recorded hashes.

The three successful-transfer setups use the test's embedded one-pixel PNG and a source slide from layout index 1, titled Imported Title with body Imported body. The picture is placed at 1 inch left, 1.5 inches top and 1.5×1.5 inches size. Receivers use the same default layout index with per-slide title/body text. Refusal tests use title/body slides without the picture setup.

All candidate suffixes below follow `@candidate-python-pptx-slide-transfer-tools-`.

| Native definition suffix | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| import_slide_copies_slide_assets_and_reuses_default_layout_master | `7d96a9f151` | success true; new_slide_number=2; master_copied false; layout_reused true; receiver has two slides, imported title and a picture-type shape; master-prefix count unchanged; media-prefix count increases by at least one | No image-byte/geometry/body comparison, exact media count, layout relationship identity, original target/source byte preservation or rendering assertion |
| import_slide_after_specific_position_preserves_order | `2a2bc4e9c9` | success true; new_slide_number=2; saved title list exactly [First, Imported Title, Second] | Order is inferred from titles only; no other content, asset or relationship validation |
| importing_same_source_slide_twice_does_not_duplicate_default_master | `8e7e42b10e` | Both sequential imports succeed; receiver reopens with three slides and one master-prefix member | No media deduplication, repeated-import title/body comparison or exhaustive master/layout graph validation |
| import_slide_rejects_invalid_source_slide_number | `e13dc9ed52` | Error exists and contains Presentation has 1 slides after requesting slide 2 | No success/status/count assertion, target/donor byte check or partial-write detection |
| import_slide_requires_after_slide_number_for_after_mode | `c74fe18267` | Exact required-argument error and changes_applied=0 | No byte-preservation, filesystem, success/status or validation-order assertion |

The package helper counts ZIP member names by prefix; it does not parse relationships or validate master/layout reuse. Reported `master_copied` and `layout_reused` flags remain separate from the master-prefix count. The first scenario compares post-import counts with captured pre-import values, replacing self-comparisons in the extracted text.

The repeated-import test calls the tool twice before checking both results. The earlier extraction omitted the second call. The revised scenario retains both actions without assigning media-deduplication or broader graph-copy credit. All calls are Python methods, without an MCP transport connection.

## Inventory and validation

The [validation record](slide-transfer-validation.json) checks Gherkin parsing/compilation, mapping agreement, stable IDs and native cases, source/helper hashes, prior gaps and local links. Each definition has one recorded case and no parameter decorator. All 212 earlier gap entries remain unchanged; five new assertion limits bring the total to 217. The mapping has 90 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution or parity credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and has not been recollected. Shared v0.12, runtime, native assertions, earlier review artefacts and original untracked user files remain unchanged. Broader reconciliation and generated-seed inventory are incomplete.
