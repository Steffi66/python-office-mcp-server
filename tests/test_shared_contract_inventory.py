"""Validate pinned acceptance inputs; planned scenarios are not execution passes."""

import hashlib
import json
import re
import zipfile
from xml.etree import ElementTree as ET

import pytest
from docx import Document
from openpyxl import load_workbook
from pptx import Presentation

from tests.fixture_paths import FIXTURE_SOURCE
from tests.fixture_paths import SHARED as ROOT

MANIFEST = json.loads((ROOT / "fixture-manifest.json").read_text())


def digest(data):
    return hashlib.sha256(data).hexdigest()


def test_shared_pack_matches_pinned_manifest():
    manifest = json.loads((ROOT / "pack-manifest.json").read_text())
    assert manifest["schemaVersion"] == 1
    assert manifest["distributionRevision"] == "fixtures-ooxml-v0.1.0"
    assert manifest["sourcePackManifestSha256"] == "4fb30e0d1a75e889985eceb0c6929dc59971089cc3bc692f18675f36dfeb81de"
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
    assert compiled["validation"] == "parsed-compiled-and-typed-inputs-validated"
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
        for step in case["expandedSteps"]:
            table = (step.get("argument") or {}).get("dataTable", [])
            if table and "value_json" in table[0]:
                column = table[0].index("value_json")
                for row in table[1:]:
                    json.loads(row[column])


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


def test_central_fixture_manifest_matches_python_inputs():
    from tests.fixture_paths import TEMPLATES

    records = json.loads((FIXTURE_SOURCE / "manifest.json").read_text())["files"]
    prefix = "fixtures/python-office-mcp-server/tests/_templates/"
    inputs = [record for record in records if record["path"].startswith(prefix)]
    assert len(inputs) == 38
    assert {record["path"][len(prefix):] for record in inputs} == {
        path.relative_to(TEMPLATES).as_posix() for path in TEMPLATES.rglob("*") if path.is_file()
    }
    for record in inputs:
        data = (FIXTURE_SOURCE / record["path"]).read_bytes()
        assert len(data) == record["bytes"]
        assert digest(data) == record["sha256"]


def test_python_constants_match_selected_shared_facts():
    from tools import word_tools

    bindings = {
        "namespaces": {"NSWordprocessingML": word_tools.W_NS, "NSWord14": word_tools.W14_NS,
                       "NSContentTypes": word_tools.PKG_CT_NS, "NSRelationships": word_tools.PKG_REL_NS},
        "relationships": {"RelTypeCommentsExtended": word_tools.REL_COMMENTS_EXTENDED},
        "content-types": {"ContentTypeCommentsExtendedSpecified": word_tools.CT_COMMENTS_EXTENDED},
    }
    for group, constants in bindings.items():
        catalog = json.loads((FIXTURE_SOURCE / "facts" / (group + ".json")).read_text())
        assert catalog["schemaVersion"] == 1
        values = {row["id"]: row for row in catalog["values"]}
        assert len(values) == len(catalog["values"])
        for name, value in constants.items():
            assert values[name]["status"] in {"specified", "observed"}
            assert values[name]["value"] == value
    # A documented alias does not silently become an accepted runtime constant.
    content_types = json.loads((FIXTURE_SOURCE / "facts/content-types.json").read_text())["values"]
    disputed = next(row for row in content_types if row["id"] == "ContentTypeCommentsExtended")
    assert disputed["status"] == "disputed"
    assert disputed["value"] != word_tools.CT_COMMENTS_EXTENDED


def test_fixture_submodule_matches_common_tag_and_seals():
    from tests.fixture_paths import REPOSITORY, verify_fixture_source

    verify_fixture_source(FIXTURE_SOURCE, json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text()))
