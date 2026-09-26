# XLSX preservation and reference-engine decision

Keep the openpyxl dependency and require saved-document compatibility tests before changing distributions.

## Evidence



## Supported guarantees now

- `office_patch` edits cell values/formulas on existing worksheets through staged publication.
- Existing style indices stay stable. Supported new style registry entries are appended; semantic rewrites of old indexed styles refuse.
- Cached values on cell-level formula elements are invalidated across worksheets after cell edits; calculation flags and chain removal follow that policy. Chart/external-link caches and array-result followers are not a general freshness contract.
- Original opaque members remain byte-identical unless they are identified edited-sheet/style/calculation dependencies.
- Malformed/adversarial package admission has explicit size/entry/inflation bounds.

No calculation engine runs in production. Invalidated cell caches are unavailable until an external application recalculates; other cache families need separate checks. `recalculation-required` requests that work and does not establish Excel calculation correctness.

## Separate contracts and refusals

Table append/update, charts, comments and sheet creation use staged publication but the upstream serialiser, so unsupported feature fidelity is not guaranteed there. Unsupported modes/targets and unknown style-registry rewrites fail before commit. The server exposes no general row/column insertion or rename API promising automatic updates to every formula/name/chart/validation/conditional-format reference.

A future structural-edit engine must first enumerate reference surfaces and supported grammar, including names, table expressions, shared/array formulas, 3-D/external references, INDIRECT/OFFSET and embedded chart references. Unsupported dynamic forms must refuse before write or have an explicit loss-of-guarantee opt-in; no regexp-only reference shifting or silent fallback writer.

## Evaluating a structural-edit dependency

A mutually exclusive, pinned worker environment remains the least expensive adoption experiment. Reconsider only after:

1. Existing comment edit/delete compatibility has a tested path.
2. Each proposed structural workflow has fixtures, typed refusal cases and independent saved-output assertions.
3. The server uses a preservation API without overwriting its output with a worksheet-only merge.
4. Resource/latency measurements and dependency collision checks pass.
5. Calculation evidence distinguishes LibreOffice from native Excel behaviour.

This is an explicit decision not to implement the larger subsystem in this bounded improvement release. It can be revisited without changing the current MCP contracts.
