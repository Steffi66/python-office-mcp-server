# Formatting-analysis response-shape review

Three native formatting-analysis definitions were reviewed at Python `bf56bf95b868348c1ca393b68c262ad8abd6856a`. Their assertions accept error dictionaries and do not check analysis content. The candidate descriptions now give the actual saved inputs and retain that limited outcome. No native tests or Office operations were run.

## Inputs and assertions

| Native definition | Candidate ID | Input | Exact assertion |
|---|---|---|---|
| [`test_word_advanced_tools.py::TestAnalyzeTemplateFormatting::test_analyzes_formatting`](../../../tests/test_word_advanced_tools.py) | `@candidate-python-word-advanced-tools-e6c70de6b3` | The shared sow_template fixture: headings, customer/project placeholders, template guidance and a 2×2 Role/Hours table | `"error" not in result or isinstance(result, dict)` |
| [`test_word_coverage.py::TestAnalyzeTemplateFormatting::test_analyze_template_formatting`](../../../tests/test_word_coverage.py) | `@candidate-python-word-coverage-3cc72ff9ad` | Template title, boilerplate, `<Placeholder>` and `[TBD]` | `isinstance(result, dict)` |
| [`test_word_pptx_advanced_ops.py::TestWordSowOperations::test_analyze_template_formatting`](../../../tests/test_word_pptx_advanced_ops.py) | `@candidate-python-word-pptx-advanced-ops-d7e13faae4` | Project heading, blue RGB(0,0,255) guidance run, standard text and customer placeholder | `isinstance(result, dict)` |

Each calls `tool_word_analyze_template_formatting` once. The first assertion also accepts non-dictionary values when the membership test succeeds and finds no `error` member. Its original alternative-outcome gap remains. The other two require a dictionary, but never require success or error absence.

The blue run and placeholders are setup data. No assertion checks blue-text classification, guidance detection, styles, counts, fonts, analysis fields, source-byte preservation or computed inheritance. These tests do not exercise paragraph-style assignment or authoring. They confer no coverage on the separate Bun style APIs.

The SOW fixture is read from [`tests/conftest.py`](../../../tests/conftest.py). The review hashes that helper as well as the three native test files; no fixture code was changed or copied from another runtime.

## Inventory boundary

The [validation record](formatting-analysis-validation.json) checks parser/compiler output, scenario-to-mapping agreement, stable IDs and collected cases, native/helper hashes, prior gaps and local links. Only three scenarios within their existing feature files changed. Each is one native case with no parameter decorator.

All 166 earlier gap entries remain, including every earlier gap message. One reviewed definition already had a gap; its new limit is appended. Two definitions gain new entries, making **168 gap entries**. The mapping now has 38 `native-source-reviewed` definitions; this overlaps historical manual overrides and carries no execution credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and was not recollected. Shared v0.9, runtime, native assertions, earlier review artefacts and original user files are unchanged. Catalogue execution remains `not-executed-by-catalogue`; broader reconciliation and generated-seed inventory are incomplete.
