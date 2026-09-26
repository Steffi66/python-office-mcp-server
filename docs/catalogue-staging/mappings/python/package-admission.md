# Package-admission and diff mapping

This bounded mapping covers exactly four unchanged definitions in `tests/test_package_guard.py`: 14 native parameter cases. Its five IDs and three profiles are now canonical in shared release v0.5.0. Shared features retain `@planned`; Python's persistent `tests/package_admission/` lane records actual local execution separately. The accepted local feature copies were removed when the tagged release was adopted.

| Canonical feature | Scenario ID | Native definition / variants |
|---|---|---|
| `workflows/package/zip-admission.feature` | `@id-package-admission-unsafe-members` | `test_unsafe_structure_refuses`: five ZIP-name/structure variants |
| `workflows/package/xml-member-admission.feature` | `@id-package-admission-unsafe-xml-members` | `test_unsafe_structure_refuses`: three XML-member variants |
| `workflows/package/zip-admission.feature` | `@id-package-admission-resource-limits` | `test_limits_refuse_before_large_allocations`: four limit variants |
| `workflows/package/zip-admission.feature` | `@id-package-admission-unsupported-compression` | `test_unsupported_compression_refuses`: one BZIP2 case |
| `workflows/package/semantic-diff.feature` | `@id-package-diff-equivalent-xml-and-binary-changes` | `test_package_diff_distinguishes_real_and_equivalent_changes`: one semantic classification case |

Paths in the table are relative to `references/fixtures-ooxml/`. `package-admission.json` records each native test identity, scenario/variant, source hashes, ordered member names, exact payload bytes and exception/list outcomes. The original eight unsafe variants are divided by operation profile without multiplying execution credit.

## Checks and evidence scope

The current persistent lane compiles the canonical Gherkin through the official compiler, checks input signatures against this reviewed mapping, and executes native admission/diff operations. `test-results/package-admission.json` resets before collection and tracks 14 cases / 47 steps. A partial selection fails completion. Results for XML comparison and mutation acceptance are separate; none grants credit to unexecuted package cases.

Official Gherkin compilation yields 14 uniquely named cases. The compiled unsafe-member inputs match all eight native parameter rows exactly, including the backslash path and UTF-16 BOM bytes on the tested platform. The four limits match `0`, `2`, `2` and `1` for member count, member size, total size and inflation ratio. The DEFLATED payload contains exactly 10,000 spaces. Semantic diff uses namespace `urn:x`.

Before central adoption, temporary pytest-bdd bindings ran all 14 proposed cases and all 14 original native cases: 28 passed. Inputs are checked against native AST parameter literals and constructor arguments. The mapping JSON records the JUnit and adapter hashes for this run. That evidence describes the earlier staging run, not the persistent v0.5 lane. At that time shared v0.4 and the native tests were unchanged.

A bounded independent review found no input/outcome mismatches in the three features. It did not inspect the JSON mapping or execution artifacts, so it supplies no independent confirmation of those recorded runs.

## Boundaries

- ZIP admission, XML-member admission and semantic package diff are separate contracts. Neither admission feature specifies ZIP writer behaviour or a standalone lexical XML parser.
- Admission refusal is a `PackageAdmissionError` in Python. Only the BZIP2 case checks a message fragment (`compression`). Other refusal messages are unconstrained by these native tests.
- DTD examples use an internal entity or a UTF-16 DTD. There is no external network trap or proof of network-request prevention.
- Resource limits are checked through refusal only. Allocation sizes, decompression work and resource consumption are not measured.
- Diff reports prefix-only XML change as `equivalent_xml`, modified binary data as `changed`, and a new member as `added`. It does not require XML byte equality. The implementation currently skips byte-identical payloads before XML comparison, but this native test does not assert that shortcut; it is not an expected outcome of this proposal.
- Before/after hash receipts, ZIP timestamp/header fidelity and visual Office outcomes are not asserted here.
- Reusable synthetic seed centralisation remains separate work. This handoff describes current native setup without importing external implementation or test code.
