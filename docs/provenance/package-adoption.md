# Package safety adoption

The server's package helpers implement admission, payload comparison and original-byte restoration. Their tests check saved-document outcomes and explicit refusals.

Admission uses Python ZipFile's local-name/CRC checks plus bounded package/member counts and inflation, safe member names, compression/encryption restrictions and XML/DTD rejection. Complete raw-offset/overlap validation is outside this helper's scope.

Admission defaults for staged writes: 10,000 entries, 64 MiB per inflated member, 256 MiB package/inflated total, maximum inflation ratio 1,000. Limit violations refuse before writer execution. These defaults may reject very large legitimate documents; raising them requires explicit resource review. Core mutation paths and enrolled specialised writers are guarded, not every read-only tool.

`package_diff` receipts list added/removed/changed members, equivalent-only XML serialisations and changed-payload hashes. DOCX/PPTX saves restore original bytes only when the conservative comparator proves equivalence. It retains exact text, tails, attributes and child order except for unordered OPC relationship/content-type collections; prefix-valued attribute bindings remain significant. Unknown structures and genuinely changed parts are not silently equated.

This layer does not restore parts that a serialiser actually dropped, or certify Office rendering. Format-specific preservation tests and input inventories remain necessary. Raw ZIP offset overlap fuzzing, full schema validation, every QName-valued OOXML attribute and signature preservation are beyond this bounded helper.
