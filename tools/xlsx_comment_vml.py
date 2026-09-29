"""Read-only, namespace-aware inspection of an existing XLSX comment/VML graph."""

import posixpath
import xml.etree.ElementTree as ET
from pathlib import Path
from zipfile import BadZipFile, ZipFile

SHEET = "xl/worksheets/sheet1.xml"
RELS = "xl/worksheets/_rels/sheet1.xml.rels"
SHEET_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
DOC_REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
VML_TYPE = DOC_REL_NS + "/vmlDrawing"
COMMENTS_TYPE = DOC_REL_NS + "/comments"


class CommentGraphError(ValueError):
    """The worksheet's existing comment/VML graph is missing or unsafe."""


def _xml(data: bytes, expected_root: str) -> ET.Element:
    # ElementTree does not resolve entities; reject DTDs rather than accepting a
    # malformed or surprising part on this narrow read-only path.
    if b"<!DOCTYPE" in data.upper() or b"<!ENTITY" in data.upper():
        raise CommentGraphError("DTD is not allowed in a comment graph")
    try:
        root = ET.fromstring(data)
    except ET.ParseError as exc:
        raise CommentGraphError("Invalid comment graph XML") from exc
    if root.tag != expected_root:
        raise CommentGraphError("Unexpected comment graph XML root")
    return root


def _internal_target(source: str, target: str, names: set[str]) -> str:
    if not target or "\\" in target or "?" in target or "#" in target:
        raise CommentGraphError("Unsafe relationship target")
    if target.startswith("//") or any(part in {"", "."} for part in target.lstrip("/").split("/")):
        raise CommentGraphError("Unsafe relationship target")
    source_parts = [] if target.startswith("/") else posixpath.dirname(source).split("/")
    for part in target.lstrip("/").split("/"):
        if part == "..":
            if not source_parts:
                raise CommentGraphError("Escaping relationship target")
            source_parts.pop()
        else:
            source_parts.append(part)
    result = "/".join(source_parts)
    if result not in names:
        raise CommentGraphError("Missing relationship target")
    return result


def inspect_existing_comment_graph(path: str | Path) -> dict:
    """Inspect distinct internal worksheet VML/comments links and exact cell text.

    This operation never opens an editing session, writes the archive or decodes
    VML shapes. It admits only the two link types needed for the sealed case.
    """
    try:
        with ZipFile(path, "r") as archive:
            names = archive.namelist()
            if len(names) != len(set(names)) or SHEET not in names or RELS not in names:
                raise CommentGraphError("Missing or duplicate worksheet graph members")
            present = set(names)
            sheet = _xml(archive.read(SHEET), f"{{{SHEET_NS}}}worksheet")
            relationships = _xml(archive.read(RELS), f"{{{PKG_REL_NS}}}Relationships")
            drawings = sheet.findall(f"{{{SHEET_NS}}}legacyDrawing")
            if len(drawings) != 1 or set(drawings[0].attrib) != {f"{{{DOC_REL_NS}}}id"}:
                raise CommentGraphError("Missing or ambiguous legacy drawing")
            legacy_id = drawings[0].get(f"{{{DOC_REL_NS}}}id")
            if not legacy_id:
                raise CommentGraphError("Missing legacy drawing relationship ID")
            links: dict[str, tuple[str, str]] = {}
            for item in relationships:
                if item.tag != f"{{{PKG_REL_NS}}}Relationship":
                    raise CommentGraphError("Invalid worksheet relationship entry")
                if any(key not in {"Id", "Type", "Target", "TargetMode"} for key in item.attrib):
                    raise CommentGraphError("Invalid worksheet relationship attributes")
                ident, kind, target = (item.get(key) for key in ("Id", "Type", "Target"))
                if not ident or not kind or not target or ident in links:
                    raise CommentGraphError("Missing or duplicate worksheet relationship ID")
                if kind in {VML_TYPE, COMMENTS_TYPE}:
                    if item.get("TargetMode") not in (None, "Internal"):
                        raise CommentGraphError("External comment graph relationship")
                    links[ident] = (kind, _internal_target(SHEET, target, present))
                else:
                    links[ident] = (kind, "")
            if legacy_id not in links or links[legacy_id][0] != VML_TYPE:
                raise CommentGraphError("Wrong legacy drawing relationship type")
            comment_links = [(ident, target) for ident, (kind, target) in links.items() if kind == COMMENTS_TYPE]
            if len(comment_links) != 1 or comment_links[0][0] == legacy_id:
                raise CommentGraphError("Missing or ambiguous separate comments relationship")
            comments_target = comment_links[0][1]
            vml_target = links[legacy_id][1]
            if comments_target == vml_target:
                raise CommentGraphError("Comment and VML links share a target")
            comments_xml = _xml(archive.read(comments_target), f"{{{SHEET_NS}}}comments")
            entries: dict[str, str] = {}
            comment_lists = comments_xml.findall(f"{{{SHEET_NS}}}commentList")
            if len(comment_lists) != 1:
                raise CommentGraphError("Missing or ambiguous comment list")
            for item in comment_lists[0]:
                if item.tag != f"{{{SHEET_NS}}}comment" or not item.get("ref") or item.get("ref") in entries:
                    raise CommentGraphError("Invalid or duplicate comment cell")
                texts = item.findall(f"{{{SHEET_NS}}}text")
                if len(texts) != 1:
                    raise CommentGraphError("Missing or ambiguous comment text")
                entries[item.get("ref")] = "".join(texts[0].itertext())
            return {"legacy_id": legacy_id, "vml_type": links[legacy_id][0], "vml_target": vml_target,
                    "comments_target": comments_target, "comments": entries}
    except (BadZipFile, KeyError, OSError) as exc:
        raise CommentGraphError("Invalid or incomplete comment graph package") from exc
