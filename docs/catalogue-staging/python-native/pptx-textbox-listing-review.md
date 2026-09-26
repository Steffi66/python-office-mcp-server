# PowerPoint text-box listing source review

Three native definitions were reviewed at Python `0229c1415ed436f4fea46acf0e5c812b6f7d8fcc`. Each uses python-pptx to prepare a title and text box, then calls `tool_pptx_list_shapes` and asserts only `len(result.get("shapes", [])) >= 2`. No native tests or Office operations were run for this catalogue pass.

## Native inputs and assertion limits

All inputs use one slide from `slide_layouts[5]`, title text `Title`, and a text box at left 1 inch, top 2 inches and width 4 inches. Setup saves the file before shape listing reads slide 1.

| Native definition | Candidate ID | Height and text | Tool construction |
|---|---|---|---|
| [`test_final_coverage.py::TestMorePptxShapeOperations::test_list_shapes_with_textbox`](../../../tests/test_final_coverage.py) | `@candidate-python-final-coverage-27a6c52a4c` | 1 inch; `Textbox`; saved as shapes.pptx | Local PresentationAdvancedTools instance |
| [`test_workflow_coverage.py::TestMoreEdgeCases::test_pptx_with_textbox`](../../../tests/test_workflow_coverage.py) | `@candidate-python-workflow-coverage-eaec7e7f6d` | 1.5 inches; `Textbox content`; saved as textbox.pptx | Local PresentationAdvancedTools instance |
| [`test_workflows.py::TestMoreEdgeCases::test_pptx_with_textbox`](../../../tests/test_workflows.py) | `@candidate-python-workflows-980faaa900` | 1.5 inches; `Textbox content`; saved as textbox.pptx | pptx_advanced_tools fixture from conftest.py |

A missing shapes field defaults to an empty list and fails the length assertion. The assertion does not require a particular collection type, identify either returned entry, compare text/geometry, reject error fields, require exactly two entries, check ordering or prove source preservation. Title plus text box is the input setup, not an independently asserted classification of the returned entries.

The two workflow tests have equivalent setup and assertions but remain separate native definitions and stable candidate IDs. Central reconciliation can deduplicate their behaviour later without discarding native mappings or changing the recorded denominator.

These checks do not call a Python text-box authoring tool or Bun's `Slide.addTextBox`. They grant no authoring, rendering, layout, namespace, ID-allocation, transaction or cross-runtime parity credit. The earlier Bun read-only review is a separate source assessment; its owner-reported test results were not rerun here.

## Inventory and validation

The [validation record](pptx-textbox-listing-validation.json) records parsing/compilation, mapping agreement, stable IDs/cases, native/helper hashes and retained gaps. The shared fixture helper in [`tests/conftest.py`](../../../tests/conftest.py) returns PresentationAdvancedTools; the two coverage modules have their own temporary-directory fixtures. All three definitions have one recorded case and no parameter decorator.

All 175 prior gap entries and messages remain unchanged; three new limits bring the total to 178. The mapping now has 48 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution credit. The broad denominator remains **1,022 definitions / 1,147 native cases plus 19 shared cases**; no collection refresh was performed.

Shared v0.10, runtime, native assertions, earlier review artefacts and original untracked user files are unchanged. Broader semantic reconciliation and generated-seed inventory are incomplete.
