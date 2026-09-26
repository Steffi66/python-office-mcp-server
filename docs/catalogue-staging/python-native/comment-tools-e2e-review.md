# Cross-format comment operation source review

Six definitions in [`tests/test_comment_tools_e2e.py`](../../../tests/test_comment_tools_e2e.py) were reviewed at Python `161b437fc51e8a75369c049bcfe0e0a2e1fbc78b`. Each has one recorded native case, a dependency `skipif` marker and no parametrisation. Their candidate IDs, collected cases, markers and source hashes are unchanged. No native tests or Office operations were run for this catalogue pass.

## Inputs and assertions

The tests instantiate a combined object from `TOOL_CLASSES`; they call its Python methods directly. The unified cases exercise `tool_office_comment`, not an MCP transport connection.

Generated inputs are a workbook with sheet `Data` (`A1="Revenue"`, `B1=1000`), a document with two paragraphs including `comment target`, and a deck with one title-layout slide. The PowerPoint fixture sets its title only if a title shape exists; the tests do not assert title-shape creation.

All candidate suffixes below follow `@candidate-python-comment-tools-e2e-`. Every row asserts add and delete success. The table describes the intermediate read and deletion target.

| Native check | Candidate suffix | Pre-delete read assertions and target |
|---|---|---|
| excel_comments_unified_read_write_delete | `87e7f9fd1d` | No error; total_comments=1; one Data entry at A1 with text containing `Finance`; delete target A1 |
| excel_comments_direct_read_write_delete | `f0bcc3a2a3` | total_comments=1; delete cell_ref A1; no returned text, cell or sheet assertion |
| word_comments_unified_read_write_delete | `20ece7957e` | No error; comment_count>=1; nonempty comments; first text lowercases to contain `verify`; delete first ID as string target |
| word_comments_direct_read_write_delete | `676e3b50ad` | comment_count>=1 and first ID lookup; delete that ID as string comment_id; no returned-text assertion |
| pptx_comments_unified_read_write_delete | `de1d579a0b` | No error; total_comments>=1; nonempty integer slide-key 1 list; first text lowercases to contain `update`; delete `slide:1/comment:{index}` |
| pptx_comments_direct_read_write_delete | `846a41e278` | total_comments>=1 and first slide-1 index lookup; delete slide 1 with integer comment_index; no returned-text assertion |

All six read again after deletion. Word checks `after.get("comment_count", 0) == 0`; Excel and PowerPoint check `after.get("total_comments", 0) == 0`. A missing count satisfies these assertions. None rejects an error-shaped final payload or requires an empty collection, so the final assertions do not independently prove persisted deletion. The earlier extraction omitted these final get actions; the rewritten feature includes them and their default-zero semantics.

Only the unified intermediate reads assert error absence and comment-text fragments. The direct reads assert counts and, for Word/PowerPoint, locate an ID/index. None of the six checks unrelated package parts, author fidelity, rendering, metadata cleanup, exact Word/PowerPoint comment cardinality or transport behaviour.

## Dependency gates

- Excel checks skip when openpyxl cannot be imported; the fixture also has that skip guard.
- Word checks skip unless both python-docx and lxml import; the fixture separately guards python-docx.
- PowerPoint checks skip when python-pptx cannot be imported; the fixture also guards it.

These conditions are preserved alongside the original collected `skipif` markers. No dependency availability was tested here. A skipped native test receives no execution credit.

## Inventory boundary

The [validation record](comment-tools-e2e-validation.json) covers Gherkin parsing/compilation, candidate/mapping agreement, unchanged source and collected-case identities, retained gaps and local links. All 160 previous gap entries remain; six assertion-limit entries bring the total to 166. There are now 35 `native-source-reviewed` definitions; this overlaps historical manual-override work and does not represent execution or parity coverage.

The recorded **1,022 definitions / 1,147 native cases plus 19 shared cases** denominator is unchanged and has not been recollected. The shared v0.9 pin, runtime, native assertions, prior review artefacts and user files are unchanged. Catalogue execution stays `not-executed-by-catalogue`; broader reconciliation and generated-seed inventory are incomplete.
