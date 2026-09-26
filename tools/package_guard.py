"""Bounded ZIP/XML admission for staged Office writes.

Implements the documented rejection contracts. Complete raw ZIP offset/overlap
validation and ECMA schema validation are outside this helper's scope.
"""

import posixpath
import zipfile
from pathlib import Path

from lxml import etree


class PackageAdmissionError(ValueError):
    """Input package exceeds resource limits or has ambiguous/unsafe structure."""


def admit_package(path, *, max_members=10000, max_member_bytes=64 * 1024 * 1024,
                  max_total_bytes=256 * 1024 * 1024, max_ratio=1000):
    path = Path(path)
    if path.stat().st_size > max_total_bytes:
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
            with archive.open(info) as stream:
                payload = stream.read(max_member_bytes + 1)
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
