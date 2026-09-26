"""Validate pinned acceptance inputs; planned scenarios are not execution passes."""

import hashlib
import json
import re
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

import pytest
from docx import Document
from openpyxl import load_workbook
from pptx import Presentation

ROOT = Path(__file__).parent / "contracts" / "shared"
MANIFEST = json.loads((ROOT / "fixture-manifest.json").read_text())


def digest(data):
    return hashlib.sha256(data).hexdigest()


def test_shared_pack_matches_pinned_manifest():
    manifest = json.loads((ROOT / "pack-manifest.json").read_text())
    assert manifest["lifecycle"] == "planned"
    assert manifest["bindingsImplemented"] is False
    expected = manifest["files"]
    actual = {
        p.relative_to(ROOT).as_posix()
        for p in ROOT.rglob("*")
        if p.is_file() and p.name != "pack-manifest.json"
    }
    assert actual == set(expected)
    for name, sha256 in expected.items():
        assert digest((ROOT / name).read_bytes()) == sha256, name


def test_expanded_inventory_has_unique_ids_and_exact_fixture_pins():
    source = (ROOT / "features" / "mutation-safety.feature").read_bytes()
    scenarios = re.findall(rb"^  (@id-[a-z0-9-]+)$", source, re.MULTILINE)
    assert len(scenarios) == len(set(scenarios)) == 8
    compiled = json.loads((ROOT / "expanded-contracts.json").read_text())
    assert compiled["validation"] == "parsed-and-compiled-only"
    assert compiled["bindingsImplemented"] is False
    assert compiled["cases"] == len(compiled["inventory"]) == 19
    assert len({c["stableCaseKey"] for c in compiled["inventory"]}) == 19
    fixtures = {f["id"]: f for f in MANIFEST["fixtures"]}
    assert {c["scenarioId"] for c in compiled["inventory"]} == {
        s.decode() for s in scenarios
    }
    for case in compiled["inventory"]:
        assert case["execution"] == "not-run"
        assert case["featureSha256"] == digest(source)
        assert case["fixture"]["sha256"] == fixtures[case["fixture"]["id"]]["sha256"]
        assert any(step["keyword"].strip() == "Then" for step in case["expandedSteps"])


@pytest.mark.parametrize("fixture", MANIFEST["fixtures"], ids=lambda f: f["id"])
def test_fixture_and_member_hashes(fixture):
    path = ROOT / fixture["path"]
    assert digest(path.read_bytes()) == fixture["sha256"]
    assert fixture["origin"]["revision"] == "36ac406ad9d4bd3e7538b4bcc7aa2fb0e51cc943"
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names))
        assert archive.testzip() is None
        assert set(names) == set(fixture["memberSha256"])
        for name in names:
            assert digest(archive.read(name)) == fixture["memberSha256"][name]
        assert "customXml/preservation-sentinel.xml" in fixture["mustPreservePayloads"]


def test_pinned_word_and_slide_facts():
    document = Document(ROOT / "fixtures" / "present-placeholder.docx")
    assert [p.text for p in document.paragraphs] == ["<Present>"]
    presentation = Presentation(ROOT / "fixtures" / "title-and-subtitle.pptx")
    assert len(presentation.slides) == 1
    assert presentation.slides[0].shapes.title.text == "Original title"
    assert presentation.slides[0].placeholders[1].text == "Original subtitle"


def test_pinned_workbook_style_and_cache_facts():
    path = ROOT / "fixtures" / "default-style.xlsx"
    workbook = load_workbook(path)
    try:
        assert workbook.active["A1"].value == "before"
        assert "Missing" not in workbook.sheetnames
    finally:
        workbook.close()
    with zipfile.ZipFile(path) as archive:
        styles = ET.fromstring(archive.read("xl/styles.xml"))
        ns = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
        assert len(styles.find(ns + "cellXfs")) == 1

    for data_only, expected in ((True, 2), (False, "=Input!A1*2")):
        workbook = load_workbook(ROOT / "fixtures" / "cross-sheet-cache.xlsx", data_only=data_only)
        try:
            assert workbook["Input"]["A1"].value == 1
            assert workbook["Calc"]["A1"].value == expected
        finally:
            workbook.close()
