"""Conservative equivalence never hides real XML edits."""

from tools.package_preservation import equivalent_xml


def test_prefix_and_opc_collection_order_are_equivalent():
    uri = 'http://schemas.openxmlformats.org/package/2006/relationships'
    a = f'<Relationships xmlns="{uri}"><Relationship Id="a" Target="a.xml"/><Relationship Id="b" Target="b.xml"/></Relationships>'
    b = f'<r:Relationships xmlns:r="{uri}"><r:Relationship Target="b.xml" Id="b"/><r:Relationship Target="a.xml" Id="a"/></r:Relationships>'
    assert equivalent_xml(a.encode(), b.encode())


def test_text_whitespace_order_and_attributes_are_significant():
    assert not equivalent_xml(b'<a><b> x </b></a>', b'<a><b>x</b></a>')
    assert not equivalent_xml(b'<a><b/><c/></a>', b'<a><c/><b/></a>')
    assert not equivalent_xml(b'<a v="1"/>', b'<a v="2"/>')


def test_prefix_valued_attributes_retain_namespace_meaning():
    a = b'<a xmlns:p="urn:one" value="p:x"/>'
    b = b'<a xmlns:p="urn:two" value="p:x"/>'
    assert not equivalent_xml(a, b)


def test_dtd_or_malformed_xml_is_never_equated():
    dtd = b'<!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a>'
    assert not equivalent_xml(dtd, dtd)
    assert not equivalent_xml(b'broken', b'broken')


def test_processing_instruction_targets_and_prolog_are_significant():
    assert not equivalent_xml(b'<?one x?><a/>', b'<?two x?><a/>')
    assert not equivalent_xml(b'<a><?one x?></a>', b'<a><?two x?></a>')
    assert not equivalent_xml(b'<!--old--><a/>', b'<!--new--><a/>')
