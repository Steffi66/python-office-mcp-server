"""One exact XML entity-value binding; controls earn no sibling parser credit."""

import json

import pytest
from lxml import etree

from tests.xml_entity_values.cases import ATTRIBUTE, CASE_KEY, SOURCE, TEXT
from tools.xlsx_preservation import parse


def test_canonical_xml_entity_values(entity_case, request):
    case = entity_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._xml_entity_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = raw = root = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                source = json.loads(step["text"].removeprefix("XML values input encoded as JSON "))
                assert source == SOURCE
                raw = source.encode("utf-8")
                assert raw == b'<r a="&quot;&apos;">&#x41;&#65;&amp;&lt;&gt;</r>'
                case["inputCustody"] = {"jsonDecodedXml": source, "utf8Bytes": len(raw)}
            elif index == 1:
                root = parse(raw)
                assert raw == source.encode("utf-8")
                assert root.tag == "r" and len(root) == 0
                case["parserApi"] = "tools.xlsx_preservation.parse"
            elif index == 2:
                expected = json.loads(step["text"].removeprefix("the root attribute a equals JSON "))
                assert expected == ATTRIBUTE == '"\''
                assert dict(root.attrib) == {"a": '"\''}
                case["observedAttribute"] = root.get("a")
            else:
                expected = json.loads(step["text"].removeprefix("the root text equals JSON "))
                assert expected == TEXT == "AA&<>"
                assert root.text == "AA&<>" and root.tail is None
                assert raw == source.encode("utf-8")
                case["observedText"] = root.text
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


@pytest.mark.parametrize(("old", "new", "attribute", "text"), [
    ("&#x41;", "&#x42;", ATTRIBUTE, "BA&<>"),
    ("&#65;", "&#66;", ATTRIBUTE, "AB&<>"),
    ("&quot;", "X", "X'", TEXT),
    ("&apos;", "Y", '"Y', TEXT),
    ("&amp;", "Z", ATTRIBUTE, "AAZ<>"),
    ("&lt;", "L", ATTRIBUTE, "AA&L>"),
    ("&gt;", "G", ATTRIBUTE, "AA&<G"),
])
def test_each_reference_controls_its_own_value(old, new, attribute, text):
    assert SOURCE.count(old) == 1
    mutated = SOURCE.replace(old, new)
    assert mutated != SOURCE
    root = parse(mutated.encode("utf-8"))
    assert root.tag == "r" and dict(root.attrib) == {"a": attribute} and root.text == text
    assert (attribute, text) != (ATTRIBUTE, TEXT)
    assert parse(SOURCE.encode("utf-8")).get("a") == ATTRIBUTE
    assert parse(SOURCE.encode("utf-8")).text == TEXT


def test_malformed_reference_refuses_without_partial_root():
    with pytest.raises(etree.XMLSyntaxError):
        parse(SOURCE.replace("&#x41;", "&#xZZ;").encode("utf-8"))


def test_internal_dtd_is_accepted_by_this_parser_not_credited():
    """Do not infer package admission or general DTD refusal from this API."""
    data = b'<!DOCTYPE r [<!ENTITY x "visible">]><r>&x;</r>'
    root = parse(data)
    assert root.tag == "r" and data.startswith(b"<!DOCTYPE")
    assert root.getroottree().docinfo.doctype == '<!DOCTYPE r>'
