# Selected Word and PowerPoint improvements


## Implemented and tested

- Word tracked replacement spans adjacent plain-text runs, retaining prefix/suffix run formatting and each deleted run's properties. Fields, hyperlinks, existing revisions and non-text content form barriers. It still replaces the first eligible occurrence per call, preserving the existing method contract.
- PowerPoint global text replacement spans adjacent runs, keeps boundary formatting, counts actual non-overlapping occurrences and walks groups, tables and existing notes. Paragraph breaks, fields and non-run children are barriers.
- Slide duplication reuses the existing OOXML graph importer, so charts and their embedded workbooks receive independent parts. Editing the cloned chart is tested not to change the original.
- Explicit note import is tested to copy note text while leaving the donor bytes unchanged. Existing layout reuse/master and comment resolve/reopen/reply tests remain gates.

Focused validation: 106 tests pass, including shared acceptance, revision reading, comment replies/resolution and import/duplicate regression families.

## Current boundaries

These helpers do not provide all-story traversal, public live Span objects, serialised structural anchors, full inherited formatting provenance, cross-document Word composition or comparison/redlining. Full Word compare needs independent accept/reject round-trip and unsupported-structure contracts. Theme-aware import policy beyond the existing layout/master-copy behaviour needs separate visual evidence.

Compatibility choices: shape-level PPTX patching still applies the existing clear/autofit semantics; only literal replacement gains run-span preservation. Slide duplication retains its current notes-excluded behaviour; users can request notes through explicit import. No blanket font/layout/rendering equivalence is claimed.

