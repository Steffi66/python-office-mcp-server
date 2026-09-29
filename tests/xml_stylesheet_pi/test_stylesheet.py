"""One exact stylesheet-PI binding; controls earn no sibling parser credit."""

import json

import pytest
from lxml import etree

from tests.xml_stylesheet_pi.cases import CASE_KEY, SOURCE
from tools.xlsx_preservation import parse


def pi_identity(root):
    previous = root.getprevious()
    assert isinstance(previous, etree._ProcessingInstruction)
    assert previous.getprevious() is None
    return previous.target, previous.text


def test_canonical_stylesheet_pi(stylesheet_case, request):
    case = stylesheet_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._xml_stylesheet_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = raw = root = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                source = json.loads(step["text"].removeprefix("XML values input encoded as JSON "))
                assert source == SOURCE
                raw = source.encode("utf-8")
                assert raw == b'<?xml-stylesheet href="style.xsl"?><r/>' and len(raw) == 39
                case["inputCustody"] = {"jsonDecodedXml": source, "utf8Bytes": 39}
            elif index == 1:
                root = parse(raw)
                assert raw == source.encode("utf-8")
                assert pi_identity(root) == ("xml-stylesheet", 'href="style.xsl"')
                assert etree.tostring(root.getroottree(), encoding="utf-8", xml_declaration=False) == raw
                case["parserApi"] = "tools.xlsx_preservation.parse"
                case["observedPreRootPi"] = {"target": "xml-stylesheet", "text": 'href="style.xsl"'}
            else:
                assert step["text"] == "the root qualified name equals r"
                assert root.tag == "r" and root.prefix is None and root.nsmap == {}
                assert len(root) == 0 and root.text is None
                assert pi_identity(root) == ("xml-stylesheet", 'href="style.xsl"')
                assert raw == source.encode("utf-8")
                case["observedRootQName"] = root.tag
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


@pytest.mark.parametrize(("input_xml", "target", "text"), [
    ("<r/>", None, None),
    ('<?other href="style.xsl"?><r/>', "other", 'href="style.xsl"'),
    ('<?xml-stylesheet href="other.xsl"?><r/>', "xml-stylesheet", 'href="other.xsl"'),
])
def test_root_r_alone_does_not_prove_correct_pi(input_xml, target, text):
    root = parse(input_xml.encode("utf-8"))
    assert root.tag == "r"  # All three would pass the weak canonical outcome alone.
    previous = root.getprevious()
    if target is None:
        assert previous is None
    else:
        assert isinstance(previous, etree._ProcessingInstruction)
        assert (previous.target, previous.text) == (target, text)
    assert previous is None or (previous.target, previous.text) != ("xml-stylesheet", 'href="style.xsl"')


def test_wrong_root_does_not_pass_canonical_qname():
    root = parse(b'<?xml-stylesheet href="style.xsl"?><s/>')
    assert pi_identity(root) == ("xml-stylesheet", 'href="style.xsl"')
    assert root.tag == "s" and root.tag != "r"


@pytest.mark.parametrize("malformed", [
    b'<?xml-stylesheet href="style.xsl"<r/>',
    b'<?xml-stylesheet href="style.xsl"?><r></x>',
])
def test_malformed_pi_or_xml_refuses(malformed):
    with pytest.raises(etree.XMLSyntaxError):
        parse(malformed)
