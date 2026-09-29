"""One exact implicit xml binding; sensitivity and refusal tests earn no extra cases."""

import json

import pytest
from lxml import etree

from tests.xml_implicit_prefix.cases import CASE_KEY, SOURCE, STEPS, URI
from tools.xlsx_preservation import parse

RAW = b'<r xml:lang="en"/>'
ATTRIBUTE = "{" + URI + "}lang"
AXIS = [("xml", URI)]


def implicit_binding(root):
    """Observe lxml's implicit namespace axis and resolve @xml without a supplied map."""
    return root.xpath("namespace::*"), root.xpath("string(@xml:lang)")


def test_canonical_implicit_xml_prefix(prefix_case, request):
    case = prefix_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._xml_implicit_prefix_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = raw = root = None
    for index, step in enumerate(case["steps"]):
        try:
            assert step["text"] == STEPS[index] and step["argument"] is None
            if index == 0:
                source = json.loads(step["text"].removeprefix("XML values input encoded as JSON "))
                raw = source.encode("utf-8")
                assert source == SOURCE and raw == RAW and len(raw) == 18
                assert b"xmlns:xml" not in raw
                case["inputCustody"] = {"jsonDecodedXml": source, "utf8Bytes": len(raw),
                                        "hasExplicitXmlDeclaration": False}
            elif index == 1:
                root = parse(raw)
                assert raw == RAW and root.tag == "r" and root.getparent() is None
                assert len(root) == 0 and root.text is None
                case["parserApi"] = "tools.xlsx_preservation.parse"
            elif index == 2:
                expected = json.loads(step["text"].removeprefix("the root namespace URI equals JSON "))
                actual = etree.QName(root).namespace or ""
                assert expected == actual == "" and root.xpath("namespace-uri(.)") == expected
                case["observedRootNamespaceUri"] = actual
            elif index == 3:
                expected = json.loads(step["text"].removeprefix("the root attribute xml:lang equals JSON "))
                assert expected == "en"
                assert dict(root.attrib) == {ATTRIBUTE: expected}
                assert etree.QName(next(iter(root.attrib))).namespace == URI
                assert root.get(ATTRIBUTE) == expected and root.get("lang") is None
                case["observedExpandedAttribute"] = {"name": ATTRIBUTE, "value": root.get(ATTRIBUTE)}
            else:
                assert step["text"] == "the implicit xml namespace URI is " + URI
                axis, resolved = implicit_binding(root)
                assert axis == AXIS and resolved == "en"
                assert raw == RAW and b"xmlns:xml" not in raw
                case["observedImplicitNamespace"] = {"axis": axis, "unmappedXpathXmlLang": resolved}
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


@pytest.mark.parametrize(("mutated", "root_uri", "attribute", "value", "explicit"), [
    (b"<r/>", "", None, None, False),
    (b'<r lang="en"/>', "", "lang", "en", False),
    (b'<r xmlns:x="urn:wrong" x:lang="en"/>', "", "{urn:wrong}lang", "en", False),
    (b'<r xml:lang="fr"/>', "", ATTRIBUTE, "fr", False),
    (b'<r xmlns="urn:default" xml:lang="en"/>', "urn:default", ATTRIBUTE, "en", False),
    (b'<r xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:lang="en"/>', "", ATTRIBUTE, "en", True),
])
def test_single_predicate_sensitivity(mutated, root_uri, attribute, value, explicit):
    assert mutated != RAW
    root = parse(mutated)
    assert (etree.QName(root).namespace or "") == root_uri
    assert dict(root.attrib) == ({} if attribute is None else {attribute: value})
    assert root.get(ATTRIBUTE) == (value if attribute == ATTRIBUTE else None)
    assert (b"xmlns:xml" in mutated) == explicit
    axis, resolved = implicit_binding(root)
    assert axis[0] == ("xml", URI)
    assert resolved == (value if attribute == ATTRIBUTE else "")
    # The axis alone admits these alternatives. Each fails a canonical semantic
    # predicate, except the explicit declaration, which fails exact source custody.
    assert root_uri != "" or root.get(ATTRIBUTE) != "en" or explicit


@pytest.mark.parametrize("malformed", [
    b'<r xmlns:xml="urn:wrong" xml:lang="en"/>',
    b'<r x:lang="en"/>',
    b'<r xml:lang="en"></s>',
])
def test_wrong_reserved_binding_unbound_prefix_or_mismatched_root_refuses(malformed):
    with pytest.raises(etree.XMLSyntaxError):
        parse(malformed)
