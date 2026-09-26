@captured @python_candidate
Feature: package preservation native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-package-preservation-00a43c0f38
  # Native: tests/test_package_preservation.py::test_prefix_and_opc_collection_order_are_equivalent
  Scenario: Native check: prefix and opc collection order are equivalent
    Given Set uri = 'http://schemas.openxmlformats.org/package/2006/relationships'.
    And Build a as <Relationships xmlns="{uri}"><Relationship Id="a" Target="a.xml"/><Relationship Id="b" Target="b.xml"/></Relationships>.
    And Build b as <r:Relationships xmlns:r="{uri}"><r:Relationship Target="b.xml" Id="b"/><r:Relationship Target="a.xml" Id="a"/></r:Relationships>.
    When Encode both XML strings to bytes and call equivalent_xml(a.encode(), b.encode()).
    Then The function returns truthy, treating namespace prefix changes, reversed relationship element order, and reversed attribute order as equivalent.

  @candidate-python-package-preservation-4d465caaa9
  # Native: tests/test_package_preservation.py::test_text_whitespace_order_and_attributes_are_significant
  Scenario: Native check: text whitespace order and attributes are significant
    Given Prepare b'<a><b> x </b></a>' and b'<a><b>x</b></a>'.
    And Prepare b'<a><b/><c/></a>' and b'<a><c/><b/></a>'.
    And Prepare b'<a v="1"/>' and b'<a v="2"/>'.
    When Call equivalent_xml on the whitespace-different pair.
    And Call equivalent_xml on the sibling-order-swapped pair.
    And Call equivalent_xml on the differing-attribute-value pair.
    Then Whitespace-sensitive text comparison returns falsy for b'<a><b> x </b></a>' versus b'<a><b>x</b></a>'.
    And Sibling element order comparison returns falsy for b'<a><b/><c/></a>' versus b'<a><c/><b/></a>'.
    And Attribute value comparison returns falsy for b'<a v="1"/>' versus b'<a v="2"/>'.

  @candidate-python-package-preservation-4bf31dfbf9
  # Native: tests/test_package_preservation.py::test_prefix_valued_attributes_retain_namespace_meaning
  Scenario: Native check: prefix valued attributes retain namespace meaning
    Given Prepare a = b'<a xmlns:p="urn:one" value="p:x"/>'.
    And Prepare b = b'<a xmlns:p="urn:two" value="p:x"/>'.
    When Call equivalent_xml(a, b).
    Then The comparison returns falsy because the same lexical prefix p:x is bound to different namespace URIs.

  @candidate-python-package-preservation-9babfbd455
  # Native: tests/test_package_preservation.py::test_dtd_or_malformed_xml_is_never_equated
  Scenario: Native check: dtd or malformed xml is never equated
    Given Create dtd = b'<!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a>'.
    And Use malformed input b'broken'.
    When Call equivalent_xml(dtd, dtd).
    And Call equivalent_xml(b'broken', b'broken').
    Then The DTD-bearing input is not considered equivalent even to itself.
    And The malformed input b'broken' is not considered equivalent even to itself.

  @candidate-python-package-preservation-59db595b9c
  # Native: tests/test_package_preservation.py::test_processing_instruction_targets_and_prolog_are_significant
  Scenario: Native check: processing instruction targets and prolog are significant
    Given Prepare b'<?one x?><a/>' and b'<?two x?><a/>'.
    And Prepare b'<a><?one x?></a>' and b'<a><?two x?></a>'.
    And Prepare b'<!--old--><a/>' and b'<!--new--><a/>'.
    When Call equivalent_xml on the prolog processing-instruction pair.
    And Call equivalent_xml on the in-document processing-instruction pair.
    And Call equivalent_xml on the differing-comment pair.
    Then Different prolog processing-instruction targets are treated as non-equivalent.
    And Different in-document processing-instruction targets are treated as non-equivalent.
    And Different comment contents are treated as non-equivalent.
