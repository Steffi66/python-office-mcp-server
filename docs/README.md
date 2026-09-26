## Office MCP documentation

Start with the repository [README](../README.md) to install the server and configure a stdio MCP client. Use the documents below for the editing contract and its limits.

| Document | Use it for |
|---|---|
| [Operating limits](operations.md) | File paths, permissions, previews, receipts, package bounds and handling sensitive files |
| [uMCP core and transports](umcp-core.md) | Dependency pin, structured results, prompts/resources, cancellation, authenticated HTTP sessions and update procedure |
| [Staged writer scope](writer-scope.md) | Which mutations commit atomically and which preservation guarantees apply |
| [Testing](testing.md) | Schema-2 fixture IDs and releases, development setup, Gherkin, wheel checks and scoped results |
| [Native catalogue staging](catalogue-staging/python-native/README.md) | Candidate behaviour capture, source mappings and unresolved semantic gaps; no execution credit |
| [XLSX adoption decision](xlsx-adoption-decision.md) | Why upstream openpyxl is retained and what a structural-edit engine would need |
| [Package adoption](provenance/package-adoption.md) | ZIP/XML admission, diff semantics and refusal boundaries |
| [Selected text and slide improvements](provenance/selected-enhancements.md) | Run-span replacement, clone independence and supported boundaries |
| [Completed implementation checklist](checklists/preservation-safety.md) | Historical batch and merge results |
| [Documentation review](documentation-review.md) | Corrected claims, validation scope and unresolved compatibility questions |

The following format notes contain illustrative XML and library snippets. They describe more of OOXML than this server implements; current tool behaviour is defined by the code, schema and tests linked in each note.

* [Excel package notes](excel-ooxml-format-research.md)
* [Word revision and comment notes](word-ooxml-track-changes-research.md)
* [PowerPoint comment notes](pptx-ooxml-comments-research.md)

Shared fixtures, typed facts and behaviour contracts are in the tagged [`references/fixtures-ooxml`](../references/fixtures-ooxml/README.md) submodule. Keep their provenance separate from per-implementation test results; importing a fixture or scenario grants no execution credit.
