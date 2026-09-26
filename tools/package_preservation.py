"""Restore unchanged XML payloads after supported PPTX edits.

Conservative XML comparison: expanded names, exact text/tails/attributes. Only OPC
relationship/content-type collections ignore child order. Unrecognised differences
remain visible; this does not equate arbitrary OOXML serialisations.
"""

import hashlib
import os
import tempfile
import zipfile
from pathlib import Path

from lxml import etree

UNORDERED = {
    "{http://schemas.openxmlformats.org/package/2006/relationships}Relationships",
    "{http://schemas.openxmlformats.org/package/2006/content-types}Types",
}


def _tree(node):
    children = [_tree(child) for child in node]
    if node.tag in UNORDERED:
        children.sort(key=repr)
    # Preserve namespace bindings when prefix-valued attributes may refer to them.
    opc = str(node.tag).startswith((
        "{http://schemas.openxmlformats.org/package/2006/relationships}",
        "{http://schemas.openxmlformats.org/package/2006/content-types}",
    ))
    nsmap = sorted((key or "", value) for key, value in node.nsmap.items()) if not opc and any(
        ":" in value or key.endswith("}Ignorable") for key, value in node.attrib.items()
    ) else []
    if not isinstance(node.tag, str):
        # Comments and processing instructions need their actual node kind/target.
        kind = "comment" if isinstance(node, etree._Comment) else ("pi", getattr(node, "target", ""))
    else:
        kind = node.tag
    return (kind, sorted(node.attrib.items()), node.text, node.tail, children, nsmap)


def equivalent_xml(left, right):
    try:
        parser = etree.XMLParser(resolve_entities=False, no_network=True, remove_blank_text=False)
        a, b = etree.fromstring(left, parser), etree.fromstring(right, parser)
        if a.getroottree().docinfo.doctype or b.getroottree().docinfo.doctype:
            return False
        def outside(root):
            previous, following = [], []
            node = root.getprevious()
            while node is not None:
                previous.append(_tree(node))
                node = node.getprevious()
            node = root.getnext()
            while node is not None:
                following.append(_tree(node))
                node = node.getnext()
            return previous, following

        return _tree(a) == _tree(b) and outside(a) == outside(b)
    except (ValueError, etree.XMLSyntaxError):
        return False


def diff_package(original: Path, staged: Path) -> dict:
    """Report payload changes; semantic-only XML differences are explicitly separate."""
    with zipfile.ZipFile(original) as source, zipfile.ZipFile(staged) as edited:
        old_names, new_names = set(source.namelist()), set(edited.namelist())
        changed, equivalent = [], []
        hashes = {}
        for name in sorted(old_names & new_names):
            old, new = source.read(name), edited.read(name)
            if old == new:
                continue
            (equivalent if name.endswith((".xml", ".rels")) and equivalent_xml(old, new) else changed).append(name)
            hashes[name] = {"before": hashlib.sha256(old).hexdigest(), "after": hashlib.sha256(new).hexdigest()}
        return {"added": sorted(new_names - old_names), "removed": sorted(old_names - new_names),
                "changed": changed, "equivalent_xml": equivalent, "changed_payload_hashes": hashes}


def restore_unchanged_parts(original: Path, staged: Path) -> None:
    """Keep staged additions/deletions; restore only demonstrably equivalent members."""
    with zipfile.ZipFile(original) as source, zipfile.ZipFile(staged) as edited:
        originals = set(source.namelist())
        replacements = {}
        for name in edited.namelist():
            if name not in originals or not name.endswith((".xml", ".rels")):
                continue
            old, new = source.read(name), edited.read(name)
            if old != new and equivalent_xml(old, new):
                replacements[name] = old
        if not replacements:
            return
        fd, output = tempfile.mkstemp(dir=staged.parent, suffix=staged.suffix)
        os.close(fd)
        try:
            with zipfile.ZipFile(output, "w") as archive:
                for info in edited.infolist():
                    archive.writestr(info, replacements.get(info.filename, edited.read(info.filename)))
        except Exception:
            os.unlink(output)
            raise
    try:
        os.replace(output, staged)
    finally:
        if os.path.exists(output):
            os.unlink(output)
