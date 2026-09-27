"""Negative admission fixtures are generated, small and independently checked."""

import warnings
import zipfile

import pytest

from tools.package_guard import PackageAdmissionArgumentError, PackageAdmissionError, admit_package
from tests.fixture_paths import fixture_path
from tools.package_preservation import diff_package


def archive(tmp_path, entries, compression=zipfile.ZIP_STORED):
    path = tmp_path / "case.docx"
    with warnings.catch_warnings(), zipfile.ZipFile(path, "w", compression=compression) as output:
        warnings.simplefilter("ignore", UserWarning)
        for name, payload in entries:
            output.writestr(name, payload)
    return path


@pytest.mark.parametrize("entries", [
    [("a.xml", b"<a/>"), ("a.xml", b"<b/>")],
    [("../a.xml", b"<a/>")], [("/a.xml", b"<a/>")], [("x\\a.xml", b"<a/>")],
    [("a/", b"payload")], [("a.xml", b'<!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a>')],
    [("a.xml", '<!DOCTYPE a><a/>'.encode('utf-16'))], [("a.xml", b"<broken>")],
])
def test_unsafe_structure_refuses(tmp_path, entries):
    with pytest.raises(PackageAdmissionError):
        admit_package(archive(tmp_path, entries))


@pytest.mark.parametrize("limit", [{"max_members": 0}, {"max_member_bytes": 2}, {"max_total_bytes": 2}, {"max_ratio": 1}])
def test_limits_refuse_before_large_allocations(tmp_path, limit):
    path = archive(tmp_path, [("a.xml", b"<a>" + b" " * 10000 + b"</a>")], zipfile.ZIP_DEFLATED)
    with pytest.raises(PackageAdmissionError):
        admit_package(path, **limit)


def test_source_byte_budget_is_independent_of_total_bytes():
    source = fixture_path("fixture-d9d6a313182a71a73d75a26a0ff3b7826dbd2e300e1d202114ec9f8fb018fda5")
    size = source.stat().st_size
    with pytest.raises(PackageAdmissionError, match="source size"):
        admit_package(source, max_source_bytes=size - 1)
    result = admit_package(source, max_source_bytes=size, max_total_bytes=256 * 1024 * 1024)
    assert result["members"] > 0
    assert result["uncompressed_bytes"] > 0
    with pytest.raises(PackageAdmissionError, match="compressed size"):
        admit_package(source, max_source_bytes=size, max_total_bytes=size - 1)


@pytest.mark.parametrize("limit", [
    {"max_members": -1}, {"max_member_bytes": -1}, {"max_total_bytes": -1},
    {"max_ratio": -1}, {"max_source_bytes": -1}, {"max_members": True},
    {"max_source_bytes": 1.5},
])
def test_invalid_budget_is_distinct_from_package_refusal(limit, monkeypatch):
    from pathlib import Path

    def no_stat(*args, **kwargs):
        raise AssertionError("stat called before invalid-argument refusal")

    monkeypatch.setattr(Path, "stat", no_stat)
    with pytest.raises(PackageAdmissionArgumentError, match="Invalid admission budget") as exc:
        admit_package("unused.docx", **limit)
    assert not isinstance(exc.value, PackageAdmissionError)


def test_unsupported_compression_refuses(tmp_path):
    path = archive(tmp_path, [("a.xml", b"<a/>")], zipfile.ZIP_BZIP2)
    with pytest.raises(PackageAdmissionError, match="compression"):
        admit_package(path)


def test_package_diff_distinguishes_real_and_equivalent_changes(tmp_path):
    a = archive(tmp_path, [("a.xml", b'<a xmlns="urn:x"/>'), ("b.bin", b"old")])
    b = tmp_path / "output.docx"
    with zipfile.ZipFile(b, "w") as out:
        out.writestr("a.xml", b'<p:a xmlns:p="urn:x"/>')
        out.writestr("b.bin", b"new")
        out.writestr("c.bin", b"added")
    result = diff_package(a, b)
    assert result["equivalent_xml"] == ["a.xml"]
    assert result["changed"] == ["b.bin"]
    assert result["added"] == ["c.bin"]
    assert result["removed"] == []
