"""Independent ZIP32 STORED geometry/CRC oracle and canonical refusal."""

import struct
import warnings
import zipfile
import zlib

import pytest

from tests.fixture_paths import fixture_path
from tests.package_physical_overlap.cases import CASE_KEY, FIXTURE_ID
from tools.package_guard import PackageAdmissionError, admit_package


def inspect_stored_members(data):
    """Test-only local/central probe; do not use the admission implementation."""
    eocd = len(data) - 22
    assert data[eocd:eocd + 4] == b"PK\x05\x06"
    disk, central_disk, disk_count, count, central_size, central_start, comment = struct.unpack_from("<HHHHIIH", data, eocd + 4)
    assert (disk, central_disk, disk_count, count, comment) == (0, 0, 3, 3, 0)
    assert (central_start, central_size, eocd, len(data)) == (286, 175, 461, 483)
    cursor = central_start
    members = {}
    for _ in range(count):
        fields = struct.unpack_from("<IHHHHHHIIIHHHHHII", data, cursor)
        signature, _, _, flags, method, _, _, crc, compressed, length, name_length, extra_length, comment_length, start_disk, _, _, local = fields
        assert signature == 0x02014B50 and flags == method == start_disk == 0 and compressed == length
        name = data[cursor + 46:cursor + 46 + name_length].decode("ascii")
        local_fields = struct.unpack_from("<IHHHHHIIIHH", data, local)
        assert local_fields[0] == 0x04034B50 and local_fields[2] == local_fields[3] == 0
        assert local_fields[6:9] == (crc, compressed, length)
        assert data[local + 30:local + 30 + local_fields[9]] == name.encode("ascii")
        start = local + 30 + local_fields[9] + local_fields[10]
        end = start + length
        payload = data[start:end]
        assert len(payload) == length and zlib.crc32(payload) & 0xffffffff == crc
        members[name] = {"local": local, "start": start, "end": end, "length": length, "crc32": f"{crc:08x}"}
        cursor += 46 + name_length + extra_length + comment_length
    assert cursor == eocd
    return members


def test_canonical_stored_overlap(overlap_case, tmp_path, request):
    case = overlap_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._package_overlap_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    fixture = fixture_path(FIXTURE_ID)
    source = tmp_path / "overlap.zip"
    raw = None
    members = None
    error = result = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                raw = fixture.read_bytes()
                source.write_bytes(raw)
                assert len(raw) == 483
            elif index == 1:
                members = inspect_stored_members(raw)
                assert list(members) == ["[Content_Types].xml", "outer.bin", "inner.bin"]
                assert [(r["length"], r["crc32"]) for r in members.values()] == [
                    (149, "d694f44a"), (49, "32c80458"), (10, "4daa6380")]
                case["independentMembers"] = members
            elif index == 2:
                outer, inner = members["outer.bin"], members["inner.bin"]
                assert outer["start"] == inner["local"] == 237
                assert inner["end"] <= outer["end"] == 286
            elif index == 3:
                assert source.read_bytes() == raw
                try:
                    result = admit_package(source, max_members=4, max_total_bytes=4096)
                except PackageAdmissionError as exc:
                    error = exc
                case["observedRefusal"] = {"type": type(error).__name__, "message": str(error)} if error else None
            elif index == 4:
                assert type(error) is PackageAdmissionError
                assert "physical member overlap" in str(error).lower()
                assert not any(word in str(error).lower() for word in ("crc", "name", "limit", "resource"))
            elif index == 5:
                assert result is None and error is not None
                assert sorted(p.name for p in tmp_path.iterdir()) == ["overlap.zip"]
            else:
                assert source.read_bytes() == raw == fixture.read_bytes()
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


def test_stored_profile_controls(tmp_path):
    source = tmp_path / "control.zip"
    with zipfile.ZipFile(source, "w", compression=zipfile.ZIP_STORED) as archive:
        archive.writestr("[Content_Types].xml", "<Types/>")
        archive.writestr("first.bin", b"first")
        archive.writestr("second.bin", b"second")
    original = source.read_bytes()
    assert admit_package(source, max_members=4, max_total_bytes=4096) == {"members": 3, "uncompressed_bytes": 19}
    with pytest.raises(PackageAdmissionError, match="member count limit"):
        admit_package(source, max_members=2, max_total_bytes=4096)
    assert source.read_bytes() == original

    # A matching wrong CRC in both headers is still a CRC refusal, not overlap.
    with zipfile.ZipFile(source) as archive:
        member = archive.getinfo("second.bin")
        local = member.header_offset
        central = original.index(b"PK\x01\x02", original.index(b"PK\x01\x02") + 4)
        central = original.index(b"PK\x01\x02", central + 4)
    corrupted = bytearray(original)
    struct.pack_into("<I", corrupted, local + 14, 0)
    struct.pack_into("<I", corrupted, central + 16, 0)
    source.write_bytes(corrupted)
    with pytest.raises(PackageAdmissionError, match="CRC or ZIP structure") as refusal:
        admit_package(source, max_members=4, max_total_bytes=4096)
    assert "overlap" not in str(refusal.value).lower()
    assert source.read_bytes() == corrupted

    with warnings.catch_warnings(), zipfile.ZipFile(source, "w", compression=zipfile.ZIP_STORED) as archive:
        warnings.simplefilter("ignore", UserWarning)
        archive.writestr("same.bin", b"one")
        archive.writestr("same.bin", b"two")
    duplicate = source.read_bytes()
    with pytest.raises(PackageAdmissionError, match="Duplicate package member") as refusal:
        admit_package(source, max_members=4, max_total_bytes=4096)
    assert "overlap" not in str(refusal.value).lower()
    assert source.read_bytes() == duplicate
