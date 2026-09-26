# XLSX value-edit dependency source review

Five definitions in [`tests/test_xlsx_dependency_preservation.py`](../../../tests/test_xlsx_dependency_preservation.py) were reviewed at Python `eb99f092f33f592f8967aaaa29a630384140b408`. Each has one recorded case and no parameter decorator. The rewritten feature restores shared-fixture setup, the two formula-read modes and injected calculation-chain metadata. No native tests or Office operations were run for this catalogue review.

## Assertions and limits

All candidate suffixes below follow `@candidate-python-xlsx-dependency-preservation-`.

| Native definition suffix | Candidate suffix | Asserted outcome | Limit |
|---|---|---|---|
| multiline_edit_saves_style_dependency_and_retains_opaque_parts | `b4cbe8ef34` | applied=1; same ZIP member keys; original payloads outside sheet1/styles retained; A1 value and truthy wrap_text; every sheet1 cell s index is in cellXfs bounds | Does not check all XF dependencies, exact style index, source bytes after the call or rendering |
| cross_sheet_formula_cache_is_invalidated_without_calculation | `06aa509d55` | applied=1; reported recalculation-required and invalidate-all-formula-caches; Input!A1=10 in both read modes; Calc!A1 cache None and formula unchanged; retained source payloads outside two sheets/workbook; forceFullCalc="1" | Report says all caches, but only Calc!A1 is inspected; no member-key equality, complete calcPr schema or calculated result assertion |
| existing_custom_style_indices_remain_valid | `232a6f4854` | applied=1; B1 number format and right alignment retained; A1 wrap_text truthy after reopen | Despite its name, does not inspect style indices, B1 value 1.25, A1 value or unrelated parts |
| style_reindexing_is_refused | `4ce21ae4f6` | merge_styles rejects a single existing XF fontId change from 0 to 1 with ValueError matching registry rewrite | Input has one XF, so no actual registry reorder is exercised; no full-package mutation or rollback assertion |
| calculation_chain_relationship_and_content_type_are_removed | `5587a2b78e` | applied=1; calcChain part absent; calcChain byte token absent in workbook relationships and content types | No complete graph/schema validation, other-member preservation or saved formula/cache readback |

The multiline test copies `shared_fixture("default-style.xlsx")`. Both cache tests use `shared_fixture("cross-sheet-cache.xlsx")`; the chain-removal test reads its entries and writes a temporary archive after injecting a calcChain relationship, MIME override and part. Shared payloads remain centrally authoritative; this review neither copies them into the catalogue nor reruns fixture guards.

The cross-sheet test reopens one output twice, with `(data_only, expected)` pairs `(True, None)` and `(False, "=Input!A1*2")`. This loop is one native case, not two parameter instances. Its preservation loop checks every captured source member outside the explicit allowlist; newly added member names are not ruled out. The multiline test separately asserts exact member-key equality.

The generated custom-format test sets B1 number_format to `#,##0.0000" units"` and horizontal alignment to `right`, saves, then patches A1 to `a\nb` using omitted mode/output_path. The first two tests instead request safe mode and a distinct output. The chain-removal patch also omits mode/output_path. These argument differences are retained.

## Distinct operations

Python's value edit intentionally invalidates the observed formula cache and requests recalculation. Bun's reviewed existing-style selection is a style-only operation intended to preserve values, formulas and caches. The same XLSX format does not make those mutation policies equivalent. No style-selection, calculation, effective-inheritance or cross-runtime parity credit is assigned by this catalogue pass.

## Inventory and validation

The [validation record](xlsx-dependencies-validation.json) checks parser/compiler output, scenario/mapping agreement, stable IDs/cases, native source hashes, prior gaps and local links. All 178 prior gap entries and messages remain. Two existing conditional-assertion entries gain specific limits; three definitions gain new entries, making **181 gap entries**. The mapping now has 53 `native-source-reviewed` definitions, overlapping historical manual overrides and carrying no execution credit.

The historical **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and was not recollected. Shared v0.11, runtime, native assertions, earlier review artefacts and original user files remain unchanged. The separate isolated candidate 89518aa6 guard/lane result grants these catalogue descriptions no new execution credit. Broader reconciliation and generated-seed inventory are incomplete.
