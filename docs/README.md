## Office MCP documentation

Start with the repository [README](../README.md) to install the server and configure a stdio MCP client. Use the documents below for the editing contract and its limits.

| Document | Use it for |
|---|---|
| [Operating limits](operations.md) | File paths, permissions, previews, receipts, package bounds and handling sensitive files |
| [Staged writer scope](writer-scope.md) | Which mutations commit atomically and which preservation guarantees apply |
| [Testing](testing.md) | Development setup, Gherkin, installed-wheel checks and recorded results |
| [XLSX adoption decision](xlsx-adoption-decision.md) | Why upstream openpyxl is retained and what a structural-edit engine would need |
| [Package adoption](provenance/package-adoption.md) | ZIP/XML admission, diff semantics and refusal boundaries |
| [Selected text and slide improvements](provenance/selected-enhancements.md) | Run-span replacement, clone independence and supported boundaries |
| [Completed implementation checklist](checklists/preservation-safety.md) | Historical batch and merge results |
| [Documentation review](documentation-review.md) | Corrected claims, validation scope and unresolved compatibility questions |

The following format notes contain illustrative XML and library snippets. They describe more of OOXML than this server implements; current tool behaviour is defined by the code, schema and tests linked in each note.

* [Excel package notes](excel-ooxml-format-research.md)
* [Word revision and comment notes](word-ooxml-track-changes-research.md)
* [PowerPoint comment notes](pptx-ooxml-comments-research.md)

Sealed shared fixtures and contracts are under [`tests/contracts/shared/`](../tests/contracts/shared/README.md). Keep their provenance separate from per-implementation test results; a fixture or scenario imported by another runtime does not prove that runtime executes it correctly.
