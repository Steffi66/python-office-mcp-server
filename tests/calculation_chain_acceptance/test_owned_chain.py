"""Construct a coherent two-sheet XLSX and check the owned chain after a cell edit."""

import hashlib
import posixpath
from xml.etree import ElementTree as ET
from zipfile import ZipFile

from openpyxl import load_workbook

from office_server import OfficeServer
from tests.calculation_chain_acceptance.cases import CASE_KEY
from tests.fixture_paths import shared_fixture

S = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
R = "{http://schemas.openxmlformats.org/package/2006/relationships}"
CT = "{http://schemas.openxmlformats.org/package/2006/content-types}"
CHAIN = "xl/chains/order.xml"
REL = "xl/_rels/workbook.xml.rels"
TYPES = "[Content_Types].xml"
ALLOWED = {"xl/workbook.xml", "xl/worksheets/sheet1.xml", "xl/worksheets/sheet2.xml", REL, TYPES}


def members(path):
    with ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names))
        return {name: archive.read(name) for name in names}


def cell(xml, ref):
    return next(c for c in ET.fromstring(xml).iter(S + "c") if c.get("r") == ref)


def formula_cache(xml, ref):
    target = cell(xml, ref)
    f, v = target.find(S + "f"), target.find(S + "v")
    return f.text if f is not None else None, v.text if v is not None else None


def workbook_value(path, sheet, ref, *, data_only=False):
    wb = load_workbook(path, data_only=data_only)
    try:
        return wb[sheet][ref].value
    finally:
        wb.close()


def relationship_targets(payloads):
    names = set(payloads)
    assert len(names) == len(payloads)
    for name in names:
        if not name.endswith(".rels"):
            continue
        base = "" if name == "_rels/.rels" else posixpath.dirname(posixpath.dirname(name))
        for rel in ET.fromstring(payloads[name]):
            if rel.get("TargetMode") == "External":
                continue
            target = rel.get("Target", "").split("#", 1)[0]
            resolved = target.lstrip("/") if target.startswith("/") else posixpath.normpath(posixpath.join(base, target))
            assert resolved in names, (name, resolved)
    types = ET.fromstring(payloads[TYPES])
    defaults = {e.get("Extension") for e in types if e.tag == CT + "Default"}
    overrides = {e.get("PartName", "").lstrip("/") for e in types if e.tag == CT + "Override"}
    for name in names - {TYPES}:
        assert name in overrides or name.rsplit(".", 1)[-1] in defaults, name


def authored_input(path):
    """Construct from sealed input bytes; metadata is test-owned, never Office-authored."""
    original = members(shared_fixture("cross-sheet-cache.xlsx"))
    # Independently verify the sealed starting facts before adding metadata.
    assert formula_cache(original["xl/worksheets/sheet1.xml"], "A1") == (None, "1")
    assert formula_cache(original["xl/worksheets/sheet2.xml"], "A1") == ("Input!A1*2", "2")
    calc = ET.fromstring(original["xl/worksheets/sheet2.xml"])
    row = next(r for r in calc.iter(S + "row") if r.get("r") == "1")
    for ref, expression, cached in (("B1", "A1+1", "3"), ("C1", "42", "42")):
        c = ET.SubElement(row, S + "c", {"r": ref})
        ET.SubElement(c, S + "f").text = expression
        ET.SubElement(c, S + "v").text = cached
    calc.find(S + "dimension").set("ref", "A1:C1")
    original["xl/worksheets/sheet2.xml"] = ET.tostring(calc, encoding="utf-8")
    rels = ET.fromstring(original[REL])
    assert not any((r.get("Type") or "").endswith("/calcChain") for r in rels)
    ET.SubElement(rels, R + "Relationship", {"Id": "rIdOwnedCalcChain", "Type":
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain", "Target": "chains/order.xml"})
    original[REL] = ET.tostring(rels, encoding="utf-8")
    types = ET.fromstring(original[TYPES])
    ET.SubElement(types, CT + "Override", {"PartName": "/" + CHAIN,
        "ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml"})
    original[TYPES] = ET.tostring(types, encoding="utf-8")
    original[CHAIN] = (f'<calcChain xmlns="{S[1:-1]}"><c r="A1" i="2"/><c r="B1" i="2"/></calcChain>').encode()
    with ZipFile(path, "w") as archive:
        for name, payload in original.items():
            archive.writestr(name, payload)
    return original


def test_owned_chain_case(chain_case, tmp_path, request):
    case = chain_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._chain_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source, output = tmp_path / "owned-chain.xlsx", tmp_path / "out.xlsx"
    before = after = source_bytes = result = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                authored_input(source)
                before = members(source)
                relationship_targets(before)
                assert workbook_value(source, "Input", "A1") == 1
                assert workbook_value(source, "Calc", "A1") == "=Input!A1*2"
                assert workbook_value(source, "Calc", "A1", data_only=True) == 2
            elif index == 1:
                assert formula_cache(before["xl/worksheets/sheet2.xml"], "B1") == ("A1+1", "3")
                assert formula_cache(before["xl/worksheets/sheet2.xml"], "C1") == ("42", "42")
            elif index == 2:
                owners = [(name, rel) for name, payload in before.items() if name.endswith(".rels")
                          for rel in ET.fromstring(payload) if (rel.get("Type") or "").endswith("/calcChain")]
                assert len(owners) == 1 and owners[0][0] == REL
                assert owners[0][1].get("Target") == "chains/order.xml" and owners[0][1].get("TargetMode") is None
                assert posixpath.normpath("xl/" + owners[0][1].get("Target")) == CHAIN
            elif index == 3:
                overrides = [e for e in ET.fromstring(before[TYPES]) if e.get("PartName") == "/" + CHAIN]
                assert len(overrides) == 1
                assert overrides[0].get("ContentType") == "application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml"
                chain = ET.fromstring(before[CHAIN])
                assert chain.tag == S + "calcChain"
                assert [(c.get("r"), c.get("i")) for c in chain] == [("A1", "2"), ("B1", "2")]
            elif index == 4:
                source_bytes = source.read_bytes()
                case["sourceSha256"] = hashlib.sha256(source_bytes).hexdigest()
                case["memberSha256"] = {name: hashlib.sha256(payload).hexdigest() for name, payload in before.items()}
            elif index == 5:
                result = OfficeServer().tool_office_patch(str(source), [{"target": "Input!A1", "value": 10}],
                                                           mode="safe", output_path=str(output),
                                                           cache_policy="invalidate-dependent-formula-caches")
                assert result["success"] is True and result["changes_applied"] == 1, result
                assert result["calculation_state"] == "recalculation-required"
                assert result["preservation"]["cache_policy"] == "invalidate-dependent-formula-caches"
                after = members(output)
                case["request"] = {"file_path": str(source), "changes": [{"target": "Input!A1", "value": 10}],
                                   "mode": "safe", "output_path": str(output),
                                   "cache_policy": "invalidate-dependent-formula-caches"}
                case["response"] = result
            elif index == 6:
                assert source.read_bytes() == source_bytes and members(source) == before
                assert workbook_value(output, "Input", "A1") == 10
                assert formula_cache(after["xl/worksheets/sheet1.xml"], "A1") == (None, "10")
            elif index == 7:
                for ref, expression in (("A1", "Input!A1*2"), ("B1", "A1+1")):
                    assert formula_cache(after["xl/worksheets/sheet2.xml"], ref) == (expression, None)
                    assert workbook_value(output, "Calc", ref) == "=" + expression
                    assert workbook_value(output, "Calc", ref, data_only=True) is None
            elif index == 8:
                assert workbook_value(output, "Calc", "A1", data_only=True) != 2
                assert workbook_value(output, "Calc", "B1", data_only=True) != 3
            elif index == 9:
                assert formula_cache(after["xl/worksheets/sheet2.xml"], "C1") == ("42", "42")
                assert workbook_value(output, "Calc", "C1") == "=42"
                assert workbook_value(output, "Calc", "C1", data_only=True) == 42
            elif index == 10:
                props = ET.fromstring(after["xl/workbook.xml"]).find(S + "calcPr")
                assert props is not None
                assert props.get("fullCalcOnLoad") == "1" and props.get("forceFullCalc") == "1"
                assert props.get("calcCompleted") == "0"
                assert result["calculation_state"] == "recalculation-required"
            elif index == 11:
                assert CHAIN not in after
                assert not any((r.get("Type") or "").endswith("/calcChain") for r in ET.fromstring(after[REL]))
                assert not any(e.get("PartName") == "/" + CHAIN for e in ET.fromstring(after[TYPES]))
            elif index == 12:
                relationship_targets(after)
            else:
                assert set(before) - set(after) == {CHAIN}
                assert set(after) - set(before) == set()
                for name in set(before) - ALLOWED - {CHAIN}:
                    assert after[name] == before[name], name
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
