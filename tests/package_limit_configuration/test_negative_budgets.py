"""Direct negative caller budgets refuse before source metadata or ZIP reads."""

import hashlib
from pathlib import Path
from zipfile import ZipFile

import pytest

from tests.fixture_paths import fixture_path
from tests.package_limit_configuration.cases import FIXTURE
from tools.package_guard import PackageAdmissionArgumentError, PackageAdmissionError, admit_package


def test_negative_budget_case(budget_case, monkeypatch, request):
    case = budget_case
    ledger = request.config._package_limit_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = None
    original = None
    observed = None
    probes = []
    budget = case["examples"]["budget"]
    kwarg = {"source bytes": "max_source_bytes", "entry count": "max_members"}[budget]

    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                source = fixture_path(FIXTURE)
                original = source.read_bytes()
                assert hashlib.sha256(original).hexdigest() == FIXTURE.removeprefix("fixture-")
                with ZipFile(source) as archive:
                    members = {name: archive.read(name) for name in archive.namelist()}
                case["sourceSha256"] = hashlib.sha256(original).hexdigest()
                case["memberSha256"] = {name: hashlib.sha256(data).hexdigest() for name, data in members.items()}
            elif index == 1:
                assert case["examples"]["budget"] == budget
                assert kwarg in ("max_source_bytes", "max_members")
            elif index == 2:
                def no_metadata(*args, **kwargs):
                    probes.append("source metadata")
                    raise AssertionError("Source metadata read before invalid argument refusal")

                def no_zip(*args, **kwargs):
                    probes.append("ZIP")
                    raise AssertionError("ZIP opened before invalid argument refusal")

                with monkeypatch.context() as patch:
                    patch.setattr(Path, "stat", no_metadata)
                    patch.setattr("tools.package_guard.zipfile.ZipFile", no_zip)
                    try:
                        admitted = admit_package(source, **{kwarg: -1})
                    except PackageAdmissionArgumentError as exc:
                        observed = exc
                    else:
                        pytest.fail(f"Invalid admission budget returned package: {admitted!r}")
                case["observedRefusal"] = {"type": type(observed).__name__, "message": str(observed), "metadataOrZipReads": probes}
            elif index == 3:
                assert isinstance(observed, PackageAdmissionArgumentError)
                assert probes == [] and original is not None
                assert observed is not None  # No package/parts result exists on refusal.
            elif index == 4:
                assert type(observed) is PackageAdmissionArgumentError
                assert not isinstance(observed, PackageAdmissionError)
                assert str(observed) == f"Invalid admission budget: {kwarg}"
            else:
                assert source.read_bytes() == original
                with ZipFile(source) as archive:
                    assert {name: archive.read(name) for name in archive.namelist()} == members
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
