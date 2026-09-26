# Python native behaviour capture — reconciliation input

This directory stages Python test descriptions for import and reconciliation in `fixtures-ooxml`. It is not an independent functional specification, an executable binding suite or a claim that every description is semantically complete.

## Scope

This is the recorded pre-v0.4 capture denominator, not the current pytest collection. The bounded persistent comparison and package-admission lanes and their mapping guards were added afterwards; wider catalogue regeneration/reconciliation has not been completed.

- 1,022 native test definitions across 67 test modules.
- 1,147 collected native cases, including parameter variants.
- 19 existing shared Gherkin cases reused by their original stable keys; no copied feature.
- 32 parametrisation decorators; dynamic fixture variants are retained in collected-case mappings.
- Four user-local untracked tests are excluded.

Every definition has a candidate scenario ID, source path/line/hash, native node IDs and parameter values in `mapping.json`. The shared cases use the same tagged submodule as the executable Python suite. Candidate IDs are reconciliation handles; the central repository assigns or reuses canonical behaviour IDs. Language mappings must not introduce divergent expected outcomes.

## What was checked

The official Gherkin parser/compiler accepts all 67 feature files and finds 1,022 unique candidate scenarios. Each scenario has context, action and outcome steps. Mappings cover every collected native definition and parameter instance. These checks establish inventory and syntax, not semantic equivalence or execution.

Descriptions were extracted from native fixture documentation, concrete calls, assertions and collected parameters. Sixty-six definitions have manually authored semantic overrides, covering manual Word inspection, LibreOffice, HTTP, mutation faults, pure helpers and selected Markdown/package cases. Other entries are explicitly marked `unreviewed-extraction` in the mapping.

An independent bounded review found lost intermediate-value meanings, conditional guards and weak tests whose names overstate their assertions. The capture now includes derived expressions and branch qualifications, and records weak assertions as gaps. For example, a formatted-Markdown test asserts only a success result; it does not prove preserved bold/italic formatting. Bullet-list text assertions do not prove numbering definitions.

## XML-family source review

The [XML-family review](xml-family-review.md) separates Boolean XML equivalence, package admission and package diffing. Nine native definitions were checked directly; two staging prose values were corrected without changing tests. The mapping marks these entries `native-source-reviewed`. Five of those native definitions now have an accepted central comparison feature, bound locally in `tests/xml_comparison/`; its ten-case execution report is separate from this broader staging inventory. The accepted local comparison feature was removed after adopting v0.4.0. Four package-guard definitions also have a canonical v0.5 package lane (14 cases / 47 steps) with its own execution report; the three accepted local package feature copies were removed. Other staging descriptions still confer no execution credit.

## Comment-resolution source review

The [comment-resolution review](comment-resolution-review.md) checks ten native definitions against source at `1b74a40`. The rewritten candidate feature preserves its IDs and describes reply-to-root resolution, the crafted first-paragraph/commentsIds fallback, absent commentsExtended creation and the exact filter/readback assertions. Empty-filter predicates and other assertion limits are explicit. These entries now carry `native-source-reviewed`; their catalogue execution status is unchanged. The Python behaviours remain distinct from Bun's selected-existing-entry operation.

## Comment-reply and roundtrip source review

The [reply and roundtrip review](comment-replies-review.md) checks seven reply definitions and three workflow definitions at `af579a0`. It restores the three-reply uniqueness loop, missing-parent-ID setup and intermediate readback order. Source preservation is bounded to observed counts or done states, author fallback retains its two accepted values, and deletion has only a success assertion. Candidate IDs and native case counts are unchanged; no native tests were run for the review.

## Cross-format comment operation source review

The [cross-format comment review](comment-tools-e2e-review.md) checks six direct/unified Excel, Word and PowerPoint definitions at `161b437`. It retains dependency skips and separates text-checked unified reads from count-only direct reads. Final reads default missing counts to zero and do not reject errors; they cannot independently establish persisted deletion. These are Python method calls, with no MCP transport execution in this pass.

## Formatting-analysis source review

The [formatting-analysis review](formatting-analysis-review.md) checks three definitions at `bf56bf9`. All accept error dictionaries; two assert only dictionary type and one has a weaker alternative-outcome expression. Their blue guidance and placeholder inputs receive no detection assertions. These response-shape tests provide no paragraph-style authoring or inheritance coverage.

## Patch transaction source review

The [transaction review](patch-transactions-review.md) checks seven definitions and retains all 30 recorded parameter cases at `7aaa45b`. It restores before/after snapshot meanings, exact destination setup and saved-document observations. The range-refusal test checks only A1/B1/D1, strict result flags permit an empty list, and default-mode calls stay distinct from explicit mode arguments. No native execution or shared-lane binding was added.

## Remaining reconciliation

`mapping.json` lists 175 entries with explicit gaps: all 140 original entries, ten comment-resolution entries, ten reply/roundtrip entries, six cross-format comment entries, two new formatting-analysis entries and seven transaction entries. The formatting review also extends one existing gap without dropping its earlier message. This includes conditional assertions that may not run, alternative outcomes, timing-window checks, manual-only observations and extraction details needing semantic review. Entries without an automatic gap flag still need central semantic review; absence of a flag is not approval.

The central reconciliation must:

1. Dedupe these candidates against existing canonical scenarios by behaviour, not test names.
2. Preserve real preconditions, operations, saved-document effects and exact parameter/refusal variants.
3. Record conflicting expectations as issues rather than merging contradictory outcomes.
4. Keep coverage gaps and smoke-only assertions distinct from stronger requirements.
5. Move authoritative functional Gherkin centrally and retain only Python mappings/adapters locally.

Captured scenarios receive no execution credit. Existing pytest and 19-case acceptance results remain separate source-pinned evidence. Merely parsing this directory does not run an Office operation. No external implementation or test source is included here.
