"""Bounded ZIP/XML admission for staged Office writes.

Implements the documented rejection contracts. Complete raw ZIP offset/overlap
validation and ECMA schema validation are outside this helper's scope.
"""

import posixpath
import struct
import zipfile
from pathlib import Path

from lxml import etree


class PackageAdmissionError(ValueError):
    """Input package exceeds resource limits or has ambiguous/unsafe structure."""


class PackageAdmissionArgumentError(ValueError):
    """Caller supplied an invalid admission budget, before package intake."""


def inspect_unsigned_zip32_descriptor(path):
    """Inspect one DEFLATED ZIP32 member's unsigned descriptor geometry.

    This narrow read-only probe does not validate decompression, CRC, other ZIP
    layouts, or admit the package. In particular, a CRC equal to the optional
    descriptor signature is still CRC data when the physical extent is 12 bytes.
    """
    path = Path(path)
    if path.stat().st_size > 1024 * 1024:
        raise PackageAdmissionError("Descriptor probe source size limit exceeded")
    data = path.read_bytes()
    if len(data) < 30 + 12 + 46 + 22 or data[:4] != b"PK\x03\x04" or data[-22:-18] != b"PK\x05\x06":
        raise PackageAdmissionError("Invalid single-member ZIP32 geometry")
    disk, central_disk, disk_entries, entries, central_size, central_offset, comment_len = struct.unpack_from("<HHHHIIH", data, len(data) - 18)
    if (disk, central_disk, disk_entries, entries, comment_len) != (0, 0, 1, 1, 0) or central_offset + central_size != len(data) - 22:
        raise PackageAdmissionError("Invalid ZIP32 end-of-central-directory geometry")
    if central_offset + 46 > len(data) - 22 or data[central_offset:central_offset + 4] != b"PK\x01\x02":
        raise PackageAdmissionError("Missing ZIP32 central member")
    (_, made, needed, flags, method, mtime, mdate, crc, compressed, uncompressed,
     name_len, extra_len, comment, start_disk, internal, external, local_offset) = struct.unpack_from("<IHHHHHHIIIHHHHHII", data, central_offset)
    if (needed != 20 or flags != 8 or method != 8 or start_disk != 0 or local_offset != 0
            or name_len == 0 or compressed == 0xffffffff or uncompressed == 0xffffffff
            or central_size != 46 + name_len + extra_len + comment):
        raise PackageAdmissionError("Unsupported ZIP32 descriptor member")
    central_name = data[central_offset + 46:central_offset + 46 + name_len]
    (_, local_needed, local_flags, local_method, local_time, local_date,
     local_crc, local_compressed, local_uncompressed, local_name_len, local_extra) = struct.unpack_from("<IHHHHHIIIHH", data, 0)
    payload_start = 30 + local_name_len + local_extra
    descriptor_start = payload_start + compressed
    if (local_needed != needed or local_flags != flags or local_method != method
            or local_time != mtime or local_date != mdate or local_crc != 0
            or local_compressed != 0 or local_uncompressed != 0
            or data[30:30 + local_name_len] != central_name
            or descriptor_start + 12 != central_offset):
        raise PackageAdmissionError("Ambiguous ZIP32 descriptor extent")
    descriptor_crc, descriptor_compressed, descriptor_uncompressed = struct.unpack_from("<III", data, descriptor_start)
    if (descriptor_crc, descriptor_compressed, descriptor_uncompressed) != (crc, compressed, uncompressed):
        raise PackageAdmissionError("ZIP32 descriptor disagrees with central member")
    return {"name": central_name.decode("ascii"), "descriptor_offset": descriptor_start,
            "descriptor_bytes": 12, "central_offset": central_offset, "crc32": crc,
            "compressed_bytes": compressed, "uncompressed_bytes": uncompressed}


def admit_package(path, *, max_members=10000, max_member_bytes=64 * 1024 * 1024,
                  max_total_bytes=256 * 1024 * 1024, max_ratio=1000,
                  max_source_bytes=256 * 1024 * 1024):
    for name, value in (("max_members", max_members), ("max_member_bytes", max_member_bytes),
                        ("max_total_bytes", max_total_bytes), ("max_ratio", max_ratio),
                        ("max_source_bytes", max_source_bytes)):
        if type(value) is not int or value < 0:
            raise PackageAdmissionArgumentError(f"Invalid admission budget: {name}")
    path = Path(path)
    source_bytes = path.stat().st_size
    if source_bytes > max_source_bytes:
        raise PackageAdmissionError("Package source size limit exceeded")
    if source_bytes > max_total_bytes:
        raise PackageAdmissionError("Package compressed size limit exceeded")
    with zipfile.ZipFile(path) as archive:
        infos = archive.infolist()
        if len(infos) > max_members:
            raise PackageAdmissionError("Package member count limit exceeded")
        names = set()
        total = 0
        for info in infos:
            name = info.filename
            if name in names:
                raise PackageAdmissionError(f"Duplicate package member: {name}")
            names.add(name)
            if (not name or "\\" in name or name.startswith("/") or ":" in name
                    or posixpath.normpath(name.rstrip("/")) != name.rstrip("/")
                    or ".." in name.split("/") or "\x00" in info.orig_filename):
                raise PackageAdmissionError(f"Unsafe package member name: {name!r}")
            if info.flag_bits & 1:
                raise PackageAdmissionError("Encrypted ZIP members are unsupported")
            if info.compress_type not in {zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED}:
                raise PackageAdmissionError("Unsupported OPC compression method")
            if info.is_dir() and info.file_size:
                raise PackageAdmissionError("Directory member has payload")
            if info.file_size > max_member_bytes:
                raise PackageAdmissionError("Package member size limit exceeded")
            total += info.file_size
            if total > max_total_bytes or info.file_size > max(1, info.compress_size) * max_ratio:
                raise PackageAdmissionError("Package inflation limit exceeded")
        for info in infos:
            if info.is_dir():
                continue
            # Bound actual decompression too; ZipFile also checks local names and CRC.
            try:
                with archive.open(info) as stream:
                    payload = stream.read(max_member_bytes + 1)
            except zipfile.BadZipFile as exc:
                raise PackageAdmissionError(f"Invalid package member CRC or ZIP structure: {info.filename}") from exc
            if len(payload) > max_member_bytes or len(payload) != info.file_size:
                raise PackageAdmissionError("Package inflated size mismatch")
            if info.filename.endswith((".xml", ".rels")):
                parser = etree.XMLParser(resolve_entities=False, no_network=True, huge_tree=False)
                try:
                    root = etree.fromstring(payload, parser)
                except etree.XMLSyntaxError as exc:
                    raise PackageAdmissionError(f"Invalid XML member: {info.filename}") from exc
                if root.getroottree().docinfo.doctype:
                    raise PackageAdmissionError("DTD declarations are forbidden in Office packages")
    return {"members": len(infos), "uncompressed_bytes": total}
