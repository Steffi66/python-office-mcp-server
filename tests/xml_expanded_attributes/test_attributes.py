"""One exact seven-row attribute lookup; auxiliary controls earn no extra cases."""

import json

import pytest
from lxml import etree

from tests.xml_expanded_attributes.cases import CASE_KEY, EXPECTED, ROWS, SOURCE
from tools.xlsx_preservation import parse


# Independent raw operand; the sealed feature JSON must decode to exactly these bytes.
RAW = (b'<r xmlns="urn:default" xmlns:a="urn:a" xmlns:r="urn:a" id="plain" '
       b'a:id="outer"><child xmlns:r="urn:b" r:id="inner" xml:lang="en"/>'
       b'<other r:id="sibling"/></r>')


def expanded_lookup(root, rows):
    """Lookup expanded attributes by namespace URI, never by lexical prefix."""
    child, other = list(root)
    elements = {"root": root, "child": child, "other": other}
    return tuple(elements[element].get(f"{{{namespace}}}{local}" if namespace else local)
                 for element, local, namespace, _ in rows[1:])


def test_canonical_expanded_attributes(attribute_case, request):
    case = attribute_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._xml_expanded_attributes_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = raw = root = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                source = json.loads(step["text"].removeprefix("XML values input encoded as JSON "))
                assert source == SOURCE
                raw = source.encode("utf-8")
                assert len(raw) == 157 and raw == RAW
                case["inputCustody"] = {"jsonDecodedXml": source, "utf8Bytes": len(raw)}
            elif index == 1:
                root = parse(raw)
                assert raw == source.encode("utf-8")
                assert root.tag == "{urn:default}r" and root.getparent() is None
                assert len(root) == 2
                child, other = list(root)
                assert child.tag == "{urn:default}child"
                assert other.tag == "{urn:default}other"
                assert child.getparent() is root and other.getparent() is root
                case["parserApi"] = "tools.xlsx_preservation.parse"
                case["observedElementTags"] = [root.tag, child.tag, other.tag]
            else:
                assert step["text"] == "expanded attribute lookups return these JSON values"
                table = step["argument"]["dataTable"]["rows"]
                rows = tuple(tuple(cell["value"] for cell in row["cells"]) for row in table)
                assert rows == ROWS
                expected = tuple(json.loads(row[3]) for row in rows[1:])
                assert expected == EXPECTED
                actual = expanded_lookup(root, rows)
                assert actual == expected
                assert raw == RAW and source.encode("utf-8") == RAW
                case["observedLookups"] = [
                    {"element": element, "local": local, "namespace": namespace,
                     "expected": value, "actual": observed}
                    for (element, local, namespace, _), value, observed
                    in zip(rows[1:], expected, actual, strict=True)
                ]
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


@pytest.mark.parametrize(("before", "after", "index", "changed_value"), [
    ('id="plain"', 'id="wrong"', 0, "wrong"),
    ('id="plain"', 'xmlns:d="urn:default" d:id="plain"', 1, "plain"),
    ('a:id="outer"', 'a:id="wrong"', 2, "wrong"),
    ('xmlns:r="urn:b"', 'xmlns:r="urn:c"', 3, None),
    ('r:id="inner"', 'r:id="inner" a:id="shadow"', 4, "shadow"),
    ('r:id="sibling"', 'xmlns:r="urn:c" r:id="sibling"', 5, None),
    ('xml:lang="en"', 'xml:lang="fr"', 6, "fr"),
])
def test_one_row_sensitivity(before, after, index, changed_value):
    assert SOURCE.count(before) == 1
    mutated = SOURCE.replace(before, after, 1)
    assert mutated != SOURCE
    actual = expanded_lookup(parse(mutated.encode("utf-8")), ROWS)
    assert actual[index] == changed_value != EXPECTED[index]
    assert expanded_lookup(parse(SOURCE.encode("utf-8")), ROWS) == EXPECTED


def test_distinct_prefix_same_uri_is_an_alias():
    root = parse(b'<r xmlns:r="urn:a" xmlns:a="urn:a"><child r:id="inner"/></r>')
    assert root.tag == "r" and dict(root.attrib) == {} and root[0].getparent() is root
    assert root[0].get("{urn:a}id") == "inner" and root[0].get("id") is None


@pytest.mark.parametrize("bad", [
    b'<r xmlns:a="urn:a" xmlns:b="urn:a" a:id="one" b:id="two"/>',
    b'<r xmlns:r="urn:a"><child r:id="inner"></r>',
])
def test_malformed_duplicate_expanded_name_or_mismatched_tag_refuses(bad):
    with pytest.raises(etree.XMLSyntaxError):
        parse(bad)
