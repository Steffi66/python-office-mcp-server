"""Independently prove descriptor geometry, then observe full CRC refusal."""

import struct
import zlib
from pathlib import Path

from tests.package_descriptor_integrity.cases import CASE_KEY
from tools.package_guard import PackageAdmissionError, admit_package, inspect_unsigned_zip32_descriptor


SIGNATURE_COLLISION_CRC = 0x08074B50
NAME = b"data.bin"
PAYLOAD = b"payload"


def authored_archive():
    compressor = zlib.compressobj(wbits=-15)
    compressed = compressor.compress(PAYLOAD) + compressor.flush()
    local = struct.pack("<IHHHHHIIIHH", 0x04034B50, 20, 8, 8, 0, 0, 0, 0, 0, len(NAME), 0) + NAME
    descriptor = struct.pack("<III", SIGNATURE_COLLISION_CRC, len(compressed), len(PAYLOAD))
    central = struct.pack("<IHHHHHHIIIHHHHHII", 0x02014B50, 20, 20, 8, 8, 0, 0,
                          SIGNATURE_COLLISION_CRC, len(compressed), len(PAYLOAD), len(NAME),
                          0, 0, 0, 0, 0, 0) + NAME
    central_offset = len(local) + len(compressed) + len(descriptor)
    eocd = struct.pack("<IHHHHIIH", 0x06054B50, 0, 0, 1, 1, len(central), central_offset, 0)
    return local + compressed + descriptor + central + eocd, compressed, len(local), central_offset


def independent_raw_geometry(raw):
    """Test-side ZIP32 field oracle, separate from the production descriptor probe."""
    eocd_offset = len(raw) - 22
    assert struct.unpack_from("<IHHHHIIH", raw, eocd_offset)[:5] == (0x06054B50, 0, 0, 1, 1)
    central_offset = struct.unpack_from("<I", raw, eocd_offset + 16)[0]
    central_size = struct.unpack_from("<I", raw, eocd_offset + 12)[0]
    assert central_offset + central_size == eocd_offset
    central = struct.unpack_from("<IHHHHHHIIIHHHHHII", raw, central_offset)
    assert central[0] == 0x02014B50 and central[3:5] == (8, 8)
    assert central[9] == len(PAYLOAD)
    assert central[16] == 0 and raw[central_offset + 46:central_offset + 46 + central[10]] == NAME
    local = struct.unpack_from("<IHHHHHIIIHH", raw, 0)
    assert local[0] == 0x04034B50 and local[2:4] == (8, 8)
    assert local[6:9] == (0, 0, 0)
    assert raw[30:30 + local[9]] == NAME
    payload_offset = 30 + local[9] + local[10]
    compressed_bytes = central[8]
    descriptor_offset = payload_offset + compressed_bytes
    assert raw[descriptor_offset:central_offset] == struct.pack("<III", central[7], compressed_bytes, 7)
    actual = zlib.crc32(zlib.decompress(raw[payload_offset:descriptor_offset], wbits=-15)) & 0xffffffff
    return {"archive_bytes": len(raw), "payload_offset": payload_offset,
            "compressed_bytes": compressed_bytes, "descriptor_offset": descriptor_offset,
            "descriptor_bytes": central_offset - descriptor_offset,
            "central_offset": central_offset, "eocd_offset": eocd_offset,
            "declared_crc32": f"{central[7]:08x}", "actual_crc32": f"{actual:08x}"}


def test_unsigned_descriptor_collision(descriptor_case, tmp_path, request):
    case = descriptor_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._package_descriptor_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = tmp_path / "descriptor-collision.zip"
    raw = compressed = None
    payload_start = central_offset = None
    geometry = result = error = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                raw, compressed, payload_start, central_offset = authored_archive()
                source.write_bytes(raw)
                assert len(PAYLOAD) == 7 and NAME == b"data.bin"
                assert zlib.decompress(compressed, wbits=-15) == PAYLOAD
            elif index == 1:
                descriptor = raw[payload_start + len(compressed):central_offset]
                assert len(descriptor) == 12
                assert descriptor == struct.pack("<III", SIGNATURE_COLLISION_CRC, len(compressed), 7)
                assert raw[central_offset:central_offset + 4] == b"PK\x01\x02"
            elif index == 2:
                actual_crc = zlib.crc32(zlib.decompress(compressed, wbits=-15))
                assert actual_crc != SIGNATURE_COLLISION_CRC
                case["actualPayloadCrc32"] = f"{actual_crc:08x}"
                case["independentRawGeometry"] = independent_raw_geometry(raw)
            elif index == 3:
                geometry = inspect_unsigned_zip32_descriptor(source)
                try:
                    result = admit_package(source)
                except PackageAdmissionError as exc:
                    error = exc
                case["geometry"] = geometry
                case["observedRefusal"] = {"type": type(error).__name__, "message": str(error)} if error else None
            elif index == 4:
                assert case["independentRawGeometry"] == {"archive_bytes": 135, "payload_offset": 38,
                                                          "compressed_bytes": 9, "descriptor_offset": 47,
                                                          "descriptor_bytes": 12, "central_offset": 59,
                                                          "eocd_offset": 113, "declared_crc32": "08074b50",
                                                          "actual_crc32": "422c6a15"}
                assert geometry == {"name": "data.bin", "descriptor_offset": payload_start + len(compressed),
                                    "descriptor_bytes": 12, "central_offset": central_offset,
                                    "crc32": SIGNATURE_COLLISION_CRC,
                                    "compressed_bytes": len(compressed), "uncompressed_bytes": 7}
                assert geometry["central_offset"] == geometry["descriptor_offset"] + 12
            elif index == 5:
                assert type(error) is PackageAdmissionError
                assert "CRC" in str(error) and "descriptor" not in str(error).lower()
            elif index == 6:
                assert result is None and error is not None
            else:
                assert source.read_bytes() == raw
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


def test_same_geometry_valid_crc_admits(tmp_path):
    """Changing only both declared CRC fields makes the unsigned descriptor valid."""
    corrupt, compressed, payload_offset, central_offset = authored_archive()
    original = independent_raw_geometry(corrupt)
    assert original == {"archive_bytes": 135, "payload_offset": 38, "compressed_bytes": 9,
                        "descriptor_offset": 47, "descriptor_bytes": 12,
                        "central_offset": 59, "eocd_offset": 113,
                        "declared_crc32": "08074b50", "actual_crc32": "422c6a15"}
    valid = bytearray(corrupt)
    crc = zlib.crc32(PAYLOAD) & 0xffffffff
    struct.pack_into("<I", valid, original["descriptor_offset"], crc)
    struct.pack_into("<I", valid, central_offset + 16, crc)
    source = tmp_path / "valid-unsigned-descriptor.zip"
    source.write_bytes(valid)
    unchanged = source.read_bytes()
    expected = dict(original, declared_crc32=f"{crc:08x}")
    assert independent_raw_geometry(unchanged) == expected
    assert inspect_unsigned_zip32_descriptor(source) == {
        "name": "data.bin", "descriptor_offset": 47, "descriptor_bytes": 12,
        "central_offset": 59, "crc32": crc, "compressed_bytes": 9, "uncompressed_bytes": 7}
    assert admit_package(source) == {"members": 1, "uncompressed_bytes": 7}
    assert source.read_bytes() == unchanged
    assert independent_raw_geometry(corrupt) == original
