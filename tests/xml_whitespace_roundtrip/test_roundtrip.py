"""One exact whitespace case; perturbations earn no additional Gherkin credit."""

import json

import pytest
from lxml import etree

from tests.xml_whitespace_roundtrip.cases import CASE_KEY, STEPS, VALUE
from tools.xlsx_preservation import parse, xml


def serialized_pair(value):
    text = etree.Element("r")
    text.text = value
    attribute = etree.Element("r")
    attribute.set("a", value)
    return xml(text), xml(attribute)


def test_canonical_whitespace_roundtrip(whitespace_case, request):
    case = whitespace_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._xml_whitespace_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    value = text_bytes = attribute_bytes = text_root = attribute_root = None
    for index, step in enumerate(case["steps"]):
        try:
            assert step["text"] == STEPS[index] and step["argument"] is None
            if index == 0:
                value = json.loads(step["text"].removeprefix("an XML escaping value encoded as JSON "))
                assert value == VALUE and value.encode("utf-8") == bytes([120, 13, 10, 9, 121])
                case["inputCustody"] = {"jsonDecodedValue": value, "utf8Bytes": list(value.encode("utf-8"))}
            elif index == 1:
                text_bytes, attribute_bytes = serialized_pair(value)
                assert text_bytes != attribute_bytes
                assert text_bytes.count(b"&#13;") == 1 and b"x&#13;\n\ty</r>" in text_bytes
                assert attribute_bytes.count(b"&#13;") == 1
                assert attribute_bytes.count(b"&#10;") == 1 and attribute_bytes.count(b"&#9;") == 1
                assert b'a="x&#13;&#10;&#9;y"' in attribute_bytes
                assert value == VALUE and value.encode("utf-8") == bytes([120, 13, 10, 9, 121])
                text_root = parse(text_bytes)
                attribute_root = parse(attribute_bytes)
                assert text_root.tag == attribute_root.tag == "r" and len(text_root) == len(attribute_root) == 0
                case["serializerApi"] = "tools.xlsx_preservation.xml"
                case["parserApi"] = "tools.xlsx_preservation.parse"
                case["serializedUtf8"] = {"text": text_bytes.decode("utf-8"),
                                          "attribute": attribute_bytes.decode("utf-8")}
            else:
                expected = json.loads(step["text"].removeprefix("the decoded text and attribute both equal JSON "))
                assert expected == VALUE == value
                assert text_root.text == expected and text_root.attrib == {}
                assert attribute_root.get("a") == expected and attribute_root.text is None
                assert dict(attribute_root.attrib) == {"a": expected}
                assert value.encode("utf-8") == bytes([120, 13, 10, 9, 121])
                assert b"x&#13;\n\ty</r>" in text_bytes and b'a="x&#13;&#10;&#9;y"' in attribute_bytes
                case["observedDecoded"] = {"text": text_root.text, "attribute": attribute_root.get("a")}
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


@pytest.mark.parametrize(("context", "needle", "replacement", "observed"), [
    ("text", b"&#13;", b"\r", "x\n\ty"),
    ("attribute", b"&#13;", b"\r", "x \n\ty"),
    ("attribute", b"&#10;", b"\n", "x\r \ty"),
    ("attribute", b"&#9;", b"\t", "x\r\n y"),
    ("text", b"\n\ty</r>", b"Q\ty</r>", "x\rQ\ty"),
])
def test_corrupt_one_serialized_whitespace_distinction(context, needle, replacement, observed):
    text_bytes, attribute_bytes = serialized_pair(VALUE)
    source = text_bytes if context == "text" else attribute_bytes
    assert source.count(needle) == 1
    changed = source.replace(needle, replacement, 1)
    root = parse(changed)
    value = root.text if context == "text" else root.get("a")
    assert value == observed != VALUE
    assert VALUE.encode("utf-8") == bytes([120, 13, 10, 9, 121])


def test_unescaped_attribute_whitespace_loses_original_value():
    root = parse(b'<r a="x\r\n\ty"/>')
    assert root.get("a") == "x  y" and root.get("a") != VALUE
