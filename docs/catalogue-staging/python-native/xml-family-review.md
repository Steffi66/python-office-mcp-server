# XML-family reconciliation notes

Reviewed against native source at `de17e86d9f71d5915a10de4557aefeb6a5465a41`. These are central reconciliation inputs, not new canonical scenarios or execution credit.

## Three separate operations

- `tools.package_preservation.equivalent_xml(left, right)` returns a conservative Boolean comparison used to preserve original payloads after saving. It compares parsed expanded names and exact text, tails and attributes; selected OPC collections ignore child order. It emits no canonical XML bytes and provides no signature/C14N API.
- `tools.package_guard.admit_package(path, limits...)` validates ZIP members, resource limits and XML admission. It raises `PackageAdmissionError` for the tested unsafe packages. Its exception/refusal contract differs from the comparator's `False` result.
- `tools.package_preservation.diff_package(original, staged)` reports member additions, removals, changes and serialization-only XML differences. Byte-identical members are skipped before semantic comparison, so identical malformed XML can be unchanged at this layer even though `equivalent_xml` rejects it. Do not merge these behaviours without their distinct preconditions.

## Native definitions and candidate IDs

All paths below are repository-relative. Prefix preservation suffixes with `@candidate-python-package-preservation-`; guard suffixes with `@candidate-python-package-guard-`.

| Native definition | Candidate suffix | Observable assertion |
|---|---|---|
| `tests/test_package_preservation.py::test_prefix_and_opc_collection_order_are_equivalent` | `00a43c0f38` | A combined namespace-prefix, relationship-child-order and attribute-order change compares true |
| `tests/test_package_preservation.py::test_text_whitespace_order_and_attributes_are_significant` | `4d465caaa9` | Text whitespace, ordinary child order and differing attribute values each compare false |
| `tests/test_package_preservation.py::test_prefix_valued_attributes_retain_namespace_meaning` | `4bf31dfbf9` | Identical `p:x` attribute text bound to different namespace URIs compares false |
| `tests/test_package_preservation.py::test_dtd_or_malformed_xml_is_never_equated` | `9babfbd455` | DTD-bearing and malformed input compare false even against identical bytes |
| `tests/test_package_preservation.py::test_processing_instruction_targets_and_prolog_are_significant` | `59db595b9c` | Changed prolog/in-document PI targets and changed prolog comment content compare false |
| `tests/test_package_guard.py::test_unsafe_structure_refuses` | `6990b40908` | Eight variants raise: duplicate names, traversal, absolute paths, backslashes, directory entries, DTD/entity, UTF-16 DTD and malformed XML |
| `tests/test_package_guard.py::test_limits_refuse_before_large_allocations` | `6a549316ed` | A DEFLATED XML member with 10,000 spaces is refused independently with `max_members=0`, `max_member_bytes=2`, `max_total_bytes=2`, `max_ratio=1` |
| `tests/test_package_guard.py::test_unsupported_compression_refuses` | `803565567d` | BZIP2 package admission raises with a message containing `compression` |
| `tests/test_package_guard.py::test_package_diff_distinguishes_real_and_equivalent_changes` | `004ca93762` | Prefix-only `urn:x` XML is `equivalent_xml`, modified `b.bin` is `changed`, new `c.bin` is `added`, no part is `removed` |

The source files contain nine definitions and 19 collected instances. Generated small archives are native setup; no external test source is imported.

## Gaps and conflicts to retain

- The namespace-prefix/OPC-order positive test changes several properties at once; it does not isolate each property independently. The comparator also handles content-type collections, but this test exercises relationships only.
- `equivalent_xml` does not establish a generic lexical parser contract, XML round-trip serialization fidelity, canonical bytes or signature validity.
- The namespace-valued attribute check covers one conservative binding comparison. It is not a complete QName-typed attribute schema.
- Admission limits are observed as refusals. Tests do not measure allocations, instrument a decompression budget or set a network trap for external entities.
- The diff classification case does not assert its optional before/after payload-hash map or any visual Office outcome.
- Rejection of DTDs is not an equivalence relation over all byte strings: deliberately, identical DTD-bearing or malformed inputs compare false. Other runtime APIs that accept lexical input need separate behaviour IDs.

Two staging prose mistakes were corrected during this review: the limit values now match the native parameter rows exactly, and the diff namespace is `urn:x`. Native assertions were not changed.
