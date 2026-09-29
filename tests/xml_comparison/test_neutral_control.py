"""ECMA-neutral comparator positive: not OPC relationship validity or C14N."""

from tools.package_preservation import equivalent_xml


def test_well_formed_namespace_alias_is_equivalent():
    left = b'<a xmlns="urn:neutral" id="x"><child>value</child></a>'
    right = b'<p:a xmlns:p="urn:neutral" id="x"><p:child>value</p:child></p:a>'
    before = (memoryview(left).tobytes(), memoryview(right).tobytes())
    result = equivalent_xml(left, right)
    assert type(result) is bool and result is True
    assert (left, right) == before
