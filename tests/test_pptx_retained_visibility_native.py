"""Native retained-PPTX structure checks; not a canonical or Office-visibility binding."""

from io import BytesIO
from pathlib import PurePosixPath
from xml.etree import ElementTree as ET
from zipfile import ZipFile

import pytest

from tests.fixture_paths import fixture_path
from tools.pptx_advanced_tools import PresentationAdvancedTools

P = "http://schemas.openxmlformats.org/presentationml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG = "http://schemas.openxmlformats.org/package/2006/relationships"
SLIDE_TYPE = R + "/slide"
SOURCE = "fixture-e01ded1106a28f94a3439e8368f9a12ec360891f4a9e2810f6504c4c328ed79c"
CONTROL = "fixture-fa245a3df00fef7f7bf4739921ee840194040161e06490589e3d52cc9fa7a71d"
PRESENTATION = "ppt/presentation.xml"
RELS = "ppt/_rels/presentation.xml.rels"


def inspect_package(data):
    """Resolve slide numbers through the package graph, not slideN filename order."""
    with ZipFile(BytesIO(data)) as package:
        names = package.namelist()
        if len(names) != len(set(names)):
            raise ValueError("duplicate ZIP member")
        slides = ET.fromstring(package.read(PRESENTATION)).find(f"{{{P}}}sldIdLst")
        if slides is None or len(slides) != 4 or any(e.tag != f"{{{P}}}sldId" for e in slides):
            raise ValueError("expected four ordered slide identities")
        relationships = {}
        for rel in ET.fromstring(package.read(RELS)):
            if rel.tag != f"{{{PKG}}}Relationship":
                raise ValueError("unexpected relationship element")
            rid = rel.get("Id")
            if not rid or rid in relationships:
                raise ValueError("missing or duplicate relationship ID")
            relationships[rid] = rel
        observed = []
        used_parts = set()
        used_slide_ids = set()
        used_rids = set()
        for slide in slides:
            slide_id = slide.get("id")
            rid = slide.get(f"{{{R}}}id")
            if not slide_id or slide_id in used_slide_ids or not rid or rid in used_rids:
                raise ValueError("missing or duplicate slide identity")
            used_slide_ids.add(slide_id)
            used_rids.add(rid)
            rel = relationships.get(rid)
            if rel is None or rel.get("Type") != SLIDE_TYPE or rel.get("TargetMode") is not None:
                raise ValueError("missing, non-slide, or external slide relationship")
            target = rel.get("Target", "")
            # The retained originals use only internal, presentation-relative targets.
            if (not target or target.startswith("/") or "\\" in target or
                    any(part in ("", ".", "..") for part in target.split("/")) or
                    "?" in target or "#" in target):
                raise ValueError("unsafe slide target")
            part = str(PurePosixPath("ppt") / target)
            if part in used_parts or part not in names:
                raise ValueError("duplicate or missing slide part")
            used_parts.add(part)
            root = ET.fromstring(package.read(part))
            if root.tag != f"{{{P}}}sld":
                raise ValueError("non-slide target part")
            observed.append((slide_id, rid, part, root.get(f"{{{P}}}show"), root.get("show")))
        return observed


def expected_profile(source):
    rids = range(7, 11) if source else range(2, 6)
    return [(str(255 + number), f"rId{rid}", f"ppt/slides/slide{number}.xml",
             "0" if source and number == 3 else None, None)
            for number, rid in enumerate(rids, 1)]


@pytest.mark.parametrize("asset_id,source", [(SOURCE, True), (CONTROL, False)])
def test_retained_pptx_slide_structure_and_native_read_only(asset_id, source):
    path = fixture_path(asset_id)  # Validates sealed manifest ID, size, and original SHA-256.
    original = path.read_bytes()
    assert inspect_package(original) == expected_profile(source)

    tools = PresentationAdvancedTools()
    overview = tools.tool_pptx_list_slides(str(path))
    hidden = tools.tool_pptx_get_hidden_slides(str(path))
    assert overview["slide_count"] == hidden["total_slides"] == 4
    assert [(slide["number"], slide["slide_id"], slide["hidden"])
            for slide in overview["slides"]] == [(n, 255 + n, False) for n in range(1, 5)]
    assert hidden["hidden_count"] == 0 and hidden["hidden_slides"] == []
    # A reader's zero count is not evidence of what PowerPoint displays.
    assert path.read_bytes() == original


def modified_package(data, *, member=RELS, change=None, omit=None):
    """Build a corrupt in-memory control without altering a manifest-backed source."""
    output = BytesIO()
    with ZipFile(BytesIO(data)) as source, ZipFile(output, "w") as dest:
        for name in source.namelist():
            if name == omit:
                continue
            payload = source.read(name)
            if name == member:
                root = ET.fromstring(payload)
                change(root)
                payload = ET.tostring(root)
            dest.writestr(name, payload)
    return output.getvalue()


@pytest.mark.parametrize("fault", ["missing-rid", "duplicate-rid", "external", "wrong-type",
                                   "traversal", "missing-part", "duplicate-slide-id", "duplicate-slide-rid",
                                   "duplicate-slide-target", "qualified-marker-removed",
                                   "unqualified-marker-added"])
def test_retained_visibility_negative_controls_fail_closed(fault):
    path = fixture_path(SOURCE)
    original = path.read_bytes()

    def change_rels(root):
        slide_rel = next(rel for rel in root if rel.get("Id") == "rId9")
        if fault == "missing-rid":
            root.remove(slide_rel)
        elif fault == "duplicate-rid":
            root.append(ET.fromstring(ET.tostring(slide_rel)))
        elif fault == "external":
            slide_rel.set("TargetMode", "External")
        elif fault == "wrong-type":
            slide_rel.set("Type", R + "/slideLayout")
        elif fault == "traversal":
            slide_rel.set("Target", "../../elsewhere.xml")
        elif fault == "duplicate-slide-target":
            slide_rel.set("Target", "slides/slide2.xml")

    def change_identity(root):
        slides = root.find(f"{{{P}}}sldIdLst")
        if fault == "duplicate-slide-id":
            slides[2].set("id", slides[1].get("id"))
        else:
            slides[2].set(f"{{{R}}}id", slides[1].get(f"{{{R}}}id"))

    def change_slide(root):
        if fault == "qualified-marker-removed":
            del root.attrib[f"{{{P}}}show"]
        else:
            root.set("show", "0")

    if fault == "missing-part":
        corrupt = modified_package(original, change=lambda root: None, omit="ppt/slides/slide3.xml")
    elif fault.endswith("marker-removed") or fault.endswith("marker-added"):
        corrupt = modified_package(original, member="ppt/slides/slide3.xml", change=change_slide)
    elif fault in ("duplicate-slide-id", "duplicate-slide-rid"):
        corrupt = modified_package(original, member=PRESENTATION, change=change_identity)
    else:
        corrupt = modified_package(original, change=change_rels)

    if fault in ("qualified-marker-removed", "unqualified-marker-added"):
        assert inspect_package(corrupt) != expected_profile(True)
    else:
        with pytest.raises((ValueError, KeyError)):
            inspect_package(corrupt)
    assert path.read_bytes() == original
