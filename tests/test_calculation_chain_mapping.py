"""Control selected owned-chain case identity and fail-closed opt-in formula policy."""

import copy
from xml.etree import ElementTree as ET
from zipfile import ZipFile

import pytest

from office_server import OfficeServer
from tests.calculation_chain_acceptance.cases import CASE_KEY, FEATURE_SHA256, load_cases
from tests.calculation_chain_acceptance.test_owned_chain import S, R, REL, TYPES, CT, CHAIN, authored_input, formula_cache, members, workbook_value
from tools.xlsx_preservation import _formula_dependencies


def test_exact_owned_chain_inventory():
    case, = load_cases()
    assert case["stableCaseKey"] == CASE_KEY and case["featureSha256"] == FEATURE_SHA256
    assert case["outcome"] == "not-run" and len(case["steps"]) == 14
    assert all(s["outcome"] == "not-run" for s in case["steps"])


@pytest.mark.parametrize("fault", ["duplicate", "identity", "setup", "outcome", "lifecycle", "seal"])
def test_drifted_owned_chain_case_refuses(monkeypatch, fault):
    from tests.calculation_chain_acceptance import cases as module
    case = copy.deepcopy(module.inventory([module.FIXTURE_SOURCE / module.FEATURE])[0])
    cases = [case]
    if fault == "duplicate":
        cases.append(copy.deepcopy(case))
    elif fault == "identity":
        case["stableCaseKey"] = "@id-other:{}"
    elif fault == "setup":
        case["steps"][2]["text"] = "the chain is unowned"
    elif fault == "outcome":
        case["steps"][9]["text"] = "unrelated cache disappears"
    elif fault == "lifecycle":
        case["outcome"] = "passed"
    else:
        case["featureSha256"] = "changed"
    monkeypatch.setattr(module, "inventory", lambda paths: cases)
    with pytest.raises(ValueError):
        module.load_cases()


@pytest.mark.parametrize("expression", [
    "SUM(A1)", "RAND()", "[book.xlsx]Input!A1", "A1:B1", "A1, B1", "'Input'!A1",
    "-1", "A1^2", "A1&1", "A1+", "A1 B1", "Unknown!A1", "A1%",
])
def test_unsupported_formula_refuses_before_cache_retention(expression):
    with pytest.raises(ValueError):
        _formula_dependencies(expression, "Calc", {"Calc", "Input"})


@pytest.mark.parametrize("existing_output", [False, True])
def test_opt_in_refuses_ambiguous_graph_without_publishing(tmp_path, existing_output):
    source = tmp_path / "source.xlsx"
    output = tmp_path / "output.xlsx"
    entries = authored_input(source)
    sheet = ET.fromstring(entries["xl/worksheets/sheet2.xml"])
    formula = next(c.find(S + "f") for c in sheet.iter(S + "c") if c.get("r") == "C1")
    formula.text = "RAND()"
    entries["xl/worksheets/sheet2.xml"] = ET.tostring(sheet)
    with ZipFile(source, "w") as archive:
        for name, payload in entries.items():
            archive.writestr(name, payload)
    before = source.read_bytes()
    if existing_output:
        output.write_bytes(b"existing destination sentinel")
    destination_before = output.read_bytes() if existing_output else None
    result = OfficeServer().tool_office_patch(
        str(source), [{"target": "Input!A1", "value": 10}],
        mode="safe", output_path=str(output), cache_policy="invalidate-dependent-formula-caches",
    )
    assert result["success"] is False and result["changes_applied"] == 0, result
    assert (output.read_bytes() if output.exists() else None) == destination_before
    assert source.read_bytes() == before and members(source) == entries


@pytest.mark.parametrize("changes", ["truthy", {"target": "Input!A1", "value": 10},
                                     (1,), 1, [None], ["Input!A1"]])
def test_opt_in_refuses_malformed_changes_before_index_or_publication(tmp_path, changes):
    source, output = tmp_path / "source.xlsx", tmp_path / "output.xlsx"
    authored_input(source)
    before = source.read_bytes()
    result = OfficeServer().tool_office_patch(
        str(source), changes, mode="safe", output_path=str(output),
        cache_policy="invalidate-dependent-formula-caches",
    )
    assert result["success"] is False and result["changes_applied"] == 0, result
    assert not output.exists() and source.read_bytes() == before


@pytest.mark.parametrize("fault", ["shared", "array", "external", "missing-reference", "circular", "defined-name"])
def test_opt_in_refuses_unsupported_dependency_graph_atomically(tmp_path, fault):
    source, output = tmp_path / "source.xlsx", tmp_path / "output.xlsx"
    entries = authored_input(source)
    sheet = ET.fromstring(entries["xl/worksheets/sheet2.xml"])
    formula = next(c.find(S + "f") for c in sheet.iter(S + "c") if c.get("r") == "C1")
    if fault in {"shared", "array"}:
        formula.set("t", fault)
    else:
        formula.text = {"external": "[book.xlsx]Input!A1", "missing-reference": "D1+1",
                        "circular": "C1+1", "defined-name": "NamedCell+1"}[fault]
    entries["xl/worksheets/sheet2.xml"] = ET.tostring(sheet)
    with ZipFile(source, "w") as archive:
        for name, payload in entries.items():
            archive.writestr(name, payload)
    before = source.read_bytes()
    result = OfficeServer().tool_office_patch(
        str(source), [{"target": "Input!A1", "value": 10}],
        mode="safe", output_path=str(output), cache_policy="invalidate-dependent-formula-caches",
    )
    assert result["success"] is False and result["changes_applied"] == 0, result
    assert not output.exists() and source.read_bytes() == before and members(source) == entries


@pytest.mark.parametrize("fault", [
    "duplicate-worksheet-id", "missing-worksheet-id", "external-worksheet", "wrong-worksheet-type",
    "wrong-worksheet-target", "unlisted-worksheet", "duplicate-chain", "external-chain",
    "unowned-chain", "other-owner", "missing-chain", "wrong-chain-type", "missing-chain-override", "duplicate-chain-override", "orphan-chain-override",
])
def test_opt_in_refuses_unowned_or_ambiguous_relationships_atomically(tmp_path, fault):
    source, output = tmp_path / "source.xlsx", tmp_path / "output.xlsx"
    entries = authored_input(source)
    workbook = ET.fromstring(entries["xl/workbook.xml"])
    rels = ET.fromstring(entries[REL])
    chain = next(r for r in rels if (r.get("Type") or "").endswith("/calcChain"))
    worksheets = [r for r in rels if (r.get("Type") or "").endswith("/worksheet")]
    types = ET.fromstring(entries[TYPES])
    if fault == "duplicate-worksheet-id":
        worksheets[1].set("Id", worksheets[0].get("Id"))
    elif fault == "missing-worksheet-id":
        workbook.find(S + "sheets")[1].attrib.pop("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id")
    elif fault == "external-worksheet":
        worksheets[1].set("TargetMode", "External")
    elif fault == "wrong-worksheet-type":
        worksheets[1].set("Type", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/chartsheet")
    elif fault == "wrong-worksheet-target":
        worksheets[1].set("Target", "/xl/worksheets/sheet1.xml")
    elif fault == "unlisted-worksheet":
        ET.SubElement(rels, R + "Relationship", {"Id": "rIdUnlisted", "Type": worksheets[0].get("Type"),
                                                    "Target": "/xl/worksheets/sheet99.xml"})
    elif fault == "duplicate-chain":
        ET.SubElement(rels, R + "Relationship", {"Id": "rIdOtherChain", "Type": chain.get("Type"),
                                                    "Target": "chains/other.xml"})
    elif fault == "external-chain":
        chain.set("TargetMode", "External")
    elif fault == "unowned-chain":
        rels.remove(chain)
    elif fault == "other-owner":
        sheet_rels = ET.Element(R + "Relationships")
        ET.SubElement(sheet_rels, R + "Relationship", {
            "Id": "rIdOtherChainOwner", "Type": chain.get("Type"), "Target": "/" + CHAIN,
        })
        entries["xl/worksheets/_rels/sheet2.xml.rels"] = ET.tostring(sheet_rels)
    elif fault == "missing-chain":
        entries.pop(CHAIN)
    elif fault == "wrong-chain-type":
        chain.set("Type", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/other")
    elif fault == "duplicate-chain-override":
        override = next(e for e in types if e.get("PartName") == "/" + CHAIN)
        ET.SubElement(types, CT + "Override", dict(override.attrib))
    elif fault == "orphan-chain-override":
        override = next(e for e in types if e.get("PartName") == "/" + CHAIN)
        override.set("PartName", "/xl/chains/unowned.xml")
    else:
        next(e for e in types if e.get("PartName") == "/" + CHAIN).set("ContentType", "application/xml")
    entries["xl/workbook.xml"] = ET.tostring(workbook)
    entries[REL] = ET.tostring(rels)
    entries[TYPES] = ET.tostring(types)
    with ZipFile(source, "w") as archive:
        for name, payload in entries.items():
            archive.writestr(name, payload)
    before = source.read_bytes()
    output.write_bytes(b"existing destination sentinel")
    destination_before = output.read_bytes()
    result = OfficeServer().tool_office_patch(
        str(source), [{"target": "Input!A1", "value": 10}], mode="safe", output_path=str(output),
        cache_policy="invalidate-dependent-formula-caches",
    )
    assert result["success"] is False and result["changes_applied"] == 0, (fault, result)
    assert output.read_bytes() == destination_before and source.read_bytes() == before
    assert members(source) == entries


def test_opt_in_invalidates_transitive_reference_to_edited_cell(tmp_path):
    source, output = tmp_path / "source.xlsx", tmp_path / "output.xlsx"
    entries = authored_input(source)
    sheet = ET.fromstring(entries["xl/worksheets/sheet2.xml"])
    next(c.find(S + "f") for c in sheet.iter(S + "c") if c.get("r") == "C1").text = "Input!A1*2"
    entries["xl/worksheets/sheet2.xml"] = ET.tostring(sheet)
    with ZipFile(source, "w") as archive:
        for name, payload in entries.items():
            archive.writestr(name, payload)
    before = source.read_bytes()
    result = OfficeServer().tool_office_patch(
        str(source), [{"target": "Input!A1", "value": 10}], mode="safe", output_path=str(output),
        cache_policy="invalidate-dependent-formula-caches",
    )
    assert result["success"] is True and source.read_bytes() == before
    assert formula_cache(members(output)["xl/worksheets/sheet2.xml"], "C1") == ("Input!A1*2", None)
    assert workbook_value(output, "Calc", "C1", data_only=True) is None


def test_default_policy_still_invalidates_independent_cache(tmp_path):
    source = tmp_path / "source.xlsx"
    output = tmp_path / "output.xlsx"
    authored_input(source)
    result = OfficeServer().tool_office_patch(
        str(source), [{"target": "Input!A1", "value": 10}], mode="safe", output_path=str(output),
    )
    assert result["success"] is True and result["preservation"]["cache_policy"] == "invalidate-all-formula-caches"
    assert formula_cache(members(output)["xl/worksheets/sheet2.xml"], "C1") == ("42", None)
