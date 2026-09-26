# Python native behaviour capture — reconciliation input

This directory stages Python test descriptions for import and reconciliation in `fixtures-ooxml`. It is not an independent functional specification, an executable binding suite or a claim that every description is semantically complete.

## Scope

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

## Remaining reconciliation

`mapping.json` lists 140 entries with explicit gaps. This includes conditional assertions that may not run, alternative outcomes, timing-window checks, manual-only observations and extraction details needing semantic review. Entries without an automatic gap flag still need central semantic review; absence of a flag is not approval.

The central reconciliation must:

1. Dedupe these candidates against existing canonical scenarios by behaviour, not test names.
2. Preserve real preconditions, operations, saved-document effects and exact parameter/refusal variants.
3. Record conflicting expectations as issues rather than merging contradictory outcomes.
4. Keep coverage gaps and smoke-only assertions distinct from stronger requirements.
5. Move authoritative functional Gherkin centrally and retain only Python mappings/adapters locally.

Captured scenarios receive no execution credit. Existing pytest and 19-case acceptance results remain separate source-pinned evidence. Merely parsing this directory does not run an Office operation. No external implementation or test source is included here.
