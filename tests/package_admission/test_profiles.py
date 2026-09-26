"""Explicit native bindings: preserve member order/duplicates and isolate diff paths."""

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


def test_canonical_package_profile(package_case, tmp_path, request):
    case = package_case
    ledger = request.config._package_admission_ledger
    inputs, expected = decode_case(case)
    case.update(outcome="running", nodeid=request.node.nodeid, inputSignature=input_signature(inputs))
    ledger.write()
    original = tmp_path / "original.docx"
    modified = tmp_path / "modified.docx"
    result = None
    error = None
    for index, step in enumerate(case["steps"]):
        try:
            if case["scenarioId"] == DIFF_ID:
                if index in (0, 1):
                    key, path = ("original", original) if index == 0 else ("modified", modified)
                    write_archive(path, inputs[key], inputs["compression"])
                elif index == 2:
                    result = diff_package(original, modified)
                    case["observedResult"] = result
                else:
                    key = ("equivalent_xml", "changed", "added", "removed")[index - 3]
                    assert result[key] == expected[key]
            elif index == 0:
                write_archive(original, inputs["members"], inputs["compression"])
            elif index == 1:
                try:
                    admit_package(original, **inputs.get("limits", {}))
                except PackageAdmissionError as exc:
                    error = exc
                    case["observedRefusal"] = {"type": type(exc).__name__, "message": str(exc)}
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
    case["outcome"] = "passed"
    ledger.write()
