"""Explicit native bindings: preserve member order/duplicates and isolate diff paths."""

import hashlib
import warnings
import zipfile

from tests.package_admission.cases import DIFF_ID, decode_case, input_signature
from tools.package_guard import PackageAdmissionError, admit_package
from tools.package_preservation import diff_package


def write_archive(path, entries, compression):
    with warnings.catch_warnings(), zipfile.ZipFile(path, "w", compression=getattr(zipfile, compression)) as archive:
        warnings.simplefilter("ignore", UserWarning)  # Duplicate names are intentional negative input.
        for name, payload in entries:
            archive.writestr(name, payload)


def inspect_archive(path, entries, compression):
    """Read the actual ZIP member order, bytes, method and compressed sizes."""
    with zipfile.ZipFile(path) as archive:
        infos = archive.infolist()
        assert [(info.filename, archive.read(info)) for info in infos] == entries
        assert all(info.compress_type == getattr(zipfile, compression) for info in infos)
        return [info.compress_size for info in infos]


def control_evidence(case, inputs, expected, original, modified, tmp_path):
    source_sha = hashlib.sha256(original.read_bytes()).hexdigest()
    if case["scenarioId"] == DIFF_ID:
        modified_sha = hashlib.sha256(modified.read_bytes()).hexdigest()
        inspect_archive(original, inputs["original"], "ZIP_STORED")
        inspect_archive(modified, inputs["modified"], "ZIP_STORED")
        result = diff_package(original, modified)
        assert {key: result[key] for key in expected} == expected
        assert expected == {"equivalent_xml": ["a.xml"], "changed": ["b.bin"],
                            "added": ["c.bin"], "removed": []}
        assert inputs["original"] == [("a.xml", b'<a xmlns="urn:x"/>'), ("b.bin", b"old")]
        assert inputs["modified"] == [("a.xml", b'<p:a xmlns:p="urn:x"/>'),
                                      ("b.bin", b"new"), ("c.bin", b"added")]
        assert inputs["original"][0][1] != inputs["modified"][0][1]
        assert result["changed_payload_hashes"] == {
            name: {"before": hashlib.sha256(dict(inputs["original"])[name]).hexdigest(),
                   "after": hashlib.sha256(dict(inputs["modified"])[name]).hexdigest()}
            for name in ("a.xml", "b.bin")}
        # A different expanded XML name must not be called equivalent; an actual
        # removal must not be confused with the canonical empty removed list.
        counter = tmp_path / "counter.docx"
        write_archive(counter, [("a.xml", b'<p:a xmlns:p="urn:other"/>')], "ZIP_STORED")
        counter_result = diff_package(original, counter)
        assert counter_result["changed"] == ["a.xml"]
        assert counter_result["removed"] == ["b.bin"]
        assert counter_result["equivalent_xml"] == [] and counter_result["added"] == []
        assert hashlib.sha256(original.read_bytes()).hexdigest() == source_sha
        assert hashlib.sha256(modified.read_bytes()).hexdigest() == modified_sha
        return {"sourceSha256": source_sha, "modifiedSha256": modified_sha,
                "changedPayloadHashes": result["changed_payload_hashes"],
                "counterexample": {key: counter_result[key] for key in expected}}

    members = inputs["members"]
    compressed = inspect_archive(original, members, inputs["compression"])
    size = original.stat().st_size
    observed = case["observedRefusal"]
    assert observed["type"] == "PackageAdmissionError"
    scenario = case["scenarioId"]
    if scenario.endswith("unsafe-members"):
        messages = {"duplicate member names": "Duplicate package member: a.xml",
                    "parent traversal name": "Unsafe package member name: '../a.xml'",
                    "absolute member name": "Unsafe package member name: '/a.xml'",
                    "backslash member name": "Unsafe package member name: 'x\\\\a.xml'",
                    "directory entry with bytes": "Directory member has payload"}
        variant = next(label for label in messages if case["name"].endswith(label))
        assert observed["message"] == messages[variant]
        repaired = [("b.xml" if index else "a.xml", b"<a/>") for index in range(len(members))]
    elif scenario.endswith("resource-limits"):
        limit, value = next(iter(inputs["limits"].items()))
        assert value == (1 if limit == "max_ratio" else 2 if limit != "max_members" else 0)
        messages = {"max_members": "Package member count limit exceeded",
                    "max_member_bytes": "Package member size limit exceeded",
                    "max_total_bytes": "Package compressed size limit exceeded",
                    "max_ratio": "Package inflation limit exceeded"}
        assert observed["message"] == messages[limit]
        assert len(members) == 1 and len(members[0][1]) == 10007
        assert members[0][1] == b"<a>" + b" " * 10000 + b"</a>"
        if limit == "max_total_bytes":
            assert size > 2  # canonical refusal is SOURCE size, not aggregate inflation
        if limit == "max_ratio":
            assert len(members[0][1]) > max(1, compressed[0])
        repaired = members
    elif scenario.endswith("unsupported-compression"):
        assert observed["message"] == "Unsupported OPC compression method"
        assert inputs["compression"] == "ZIP_BZIP2" and members == [("a.xml", b"<a/>")]
        repaired = members
    else:
        assert scenario.endswith("unsafe-xml-members")
        variant = case["name"]
        assert members[0][0] == "a.xml"
        assert observed["message"] == ("Invalid XML member: a.xml" if variant.endswith("malformed XML")
                                       else "DTD declarations are forbidden in Office packages")
        if variant.endswith("UTF-16 DTD"):
            assert members[0][1] == b"\xff\xfe" + "<!DOCTYPE a><a/>".encode("utf-16-le")
            repaired = [("a.xml", b"\xff\xfe" + "<a/>".encode("utf-16-le"))]
        elif variant.endswith("internal DTD with entity"):
            assert members[0][1] == b'<!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a>'
            repaired = [("a.xml", b"<a/>")]
        else:
            assert variant.endswith("malformed XML") and members == [("a.xml", b"<broken>")]
            repaired = [("a.xml", b"<a/>")]
    # One valid default archive and a control close to the rejected package.
    valid = tmp_path / "valid.docx"
    write_archive(valid, [("a.xml", b"<a/>")], "ZIP_STORED")
    inspect_archive(valid, [("a.xml", b"<a/>")], "ZIP_STORED")
    assert admit_package(valid) == {"members": 1, "uncompressed_bytes": 4}
    repaired_path = tmp_path / "repaired.docx"
    repaired_method = "ZIP_DEFLATED" if scenario.endswith("unsupported-compression") else inputs["compression"]
    write_archive(repaired_path, repaired, repaired_method)
    inspect_archive(repaired_path, repaired, repaired_method)
    controls = inputs.get("limits", {})
    if scenario.endswith("resource-limits"):
        limit = next(iter(controls))
        if limit == "max_members":
            controls = {limit: 1}
        elif limit == "max_member_bytes":
            controls = {limit: 10007}
        elif limit == "max_total_bytes":
            # Separate from the canonical value 2: pass compressed-source
            # preflight but fail the expanded aggregate after ZIP intake.
            threshold = max(size, repaired_path.stat().st_size) + 1
            assert threshold < 10007
            try:
                admit_package(original, max_total_bytes=threshold)
            except PackageAdmissionError as exc:
                assert str(exc) == "Package inflation limit exceeded"
            else:
                raise AssertionError("Expanded total-byte threshold admitted")
            controls = {limit: 10007}
        else:
            controls = {limit: len(members[0][1]) // max(1, compressed[0]) + 1}
    assert admit_package(repaired_path, **controls) == {
        "members": len(repaired), "uncompressed_bytes": sum(len(payload) for _, payload in repaired)}
    assert hashlib.sha256(original.read_bytes()).hexdigest() == source_sha
    return {"sourceSha256": source_sha, "sourceBytes": size,
            "memberCompressedBytes": compressed, "observedClassification": observed["message"],
            "defaultAccepted": True, "pertinentAccepted": True,
            **({"aggregateThreshold": threshold} if scenario.endswith("resource-limits") and limit == "max_total_bytes" else {})}


def test_canonical_package_profile(package_case, tmp_path, request):
    case = package_case
    ledger = request.config._package_admission_ledger
    inputs, expected = decode_case(case)
    case.update(outcome="running", nodeid=request.node.nodeid, inputSignature=input_signature(inputs))
    ledger.write()
    original = tmp_path / "original.docx"
    modified = tmp_path / "modified.docx"
    source_sha = None
    modified_sha = None
    result = None
    error = None
    for index, step in enumerate(case["steps"]):
        try:
            if case["scenarioId"] == DIFF_ID:
                if index in (0, 1):
                    key, path = ("original", original) if index == 0 else ("modified", modified)
                    write_archive(path, inputs[key], inputs["compression"])
                    inspect_archive(path, inputs[key], inputs["compression"])
                    if index == 0:
                        source_sha = hashlib.sha256(path.read_bytes()).hexdigest()
                    else:
                        modified_sha = hashlib.sha256(path.read_bytes()).hexdigest()
                elif index == 2:
                    result = diff_package(original, modified)
                    assert hashlib.sha256(original.read_bytes()).hexdigest() == source_sha
                    assert hashlib.sha256(modified.read_bytes()).hexdigest() == modified_sha
                    case["observedResult"] = result
                else:
                    key = ("equivalent_xml", "changed", "added", "removed")[index - 3]
                    assert result[key] == expected[key]
            elif index == 0:
                write_archive(original, inputs["members"], inputs["compression"])
                inspect_archive(original, inputs["members"], inputs["compression"])
                source_sha = hashlib.sha256(original.read_bytes()).hexdigest()
            elif index == 1:
                try:
                    admit_package(original, **inputs.get("limits", {}))
                except PackageAdmissionError as exc:
                    error = exc
                    case["observedRefusal"] = {"type": type(exc).__name__, "message": str(exc)}
                assert hashlib.sha256(original.read_bytes()).hexdigest() == source_sha
            elif index == 2:
                assert isinstance(error, PackageAdmissionError), "Package was admitted instead of refused"
            else:
                assert expected["messageContains"] in str(error)
            step["outcome"] = "passed"
        except BaseException as exc:
            step.update(outcome="failed", error=str(exc))
            case["outcome"] = "failed"
            for following in case["steps"]:
                if following["outcome"] == "not-run":
                    following["outcome"] = "skipped"
            ledger.write()
            raise
        ledger.write()
    try:
        case["controlEvidence"] = control_evidence(case, inputs, expected, original, modified, tmp_path)
        assert case["controlEvidence"]["sourceSha256"] == source_sha
        if modified_sha is not None:
            assert case["controlEvidence"]["modifiedSha256"] == modified_sha
    except BaseException as exc:
        case.update(outcome="failed", controlError=str(exc))
        ledger.write()
        raise
    case["outcome"] = "passed"
    ledger.write()
