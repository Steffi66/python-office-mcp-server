@captured @python_candidate
Feature: package preservation native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-package-preservation-00a43c0f38
  # Native: tests/test_package_preservation.py::test_prefix_and_opc_collection_order_are_equivalent
  Scenario: Native check: prefix and opc collection order are equivalent
    Given uri is prepared as "http://schemas.openxmlformats.org/package/2006/relationships"
    And a is prepared as text <Relationships xmlns="{"http://schemas.openxmlformats.org/package/2006/relationships"}"><Relationship Id="a" Target="a.xml"/><Relationship Id="b" Target="b.xml"/></Relationships>
    And b is prepared as text <r:Relationships xmlns:r="{"http://schemas.openxmlformats.org/package/2006/relationships"}"><r:Relationship Target="b.xml" Id="b"/><r:Relationship Target="a.xml" Id="a"/></r:Relationships>
    When the prefix and opc collection order are equivalent behavior is exercised with its prepared inputs
    Then the result of equivalent xml with the result of a.encode with no arguments; the result of b.encode with no arguments is non-empty or true

  @candidate-python-package-preservation-4d465caaa9
  # Native: tests/test_package_preservation.py::test_text_whitespace_order_and_attributes_are_significant
  Scenario: Native check: text whitespace order and attributes are significant
    Given the native text whitespace order and attributes are significant inputs and isolated test state
    When the text whitespace order and attributes are significant behavior is exercised with its prepared inputs
    Then not the result of equivalent xml with "b'<a><b> x </b></a>'"; "b'<a><b>x</b></a>'"
    And not the result of equivalent xml with "b'<a><b/><c/></a>'"; "b'<a><c/><b/></a>'"
    And not the result of equivalent xml with "b'<a v=\"1\"/>'"; "b'<a v=\"2\"/>'"

  @candidate-python-package-preservation-4bf31dfbf9
  # Native: tests/test_package_preservation.py::test_prefix_valued_attributes_retain_namespace_meaning
  Scenario: Native check: prefix valued attributes retain namespace meaning
    Given a is prepared as "b'<a xmlns:p=\"urn:one\" value=\"p:x\"/>'"
    And b is prepared as "b'<a xmlns:p=\"urn:two\" value=\"p:x\"/>'"
    When the prefix valued attributes retain namespace meaning behavior is exercised with its prepared inputs
    Then not the result of equivalent xml with "b'<a xmlns:p=\"urn:one\" value=\"p:x\"/>'"; "b'<a xmlns:p=\"urn:two\" value=\"p:x\"/>'"

  @candidate-python-package-preservation-9babfbd455
  # Native: tests/test_package_preservation.py::test_dtd_or_malformed_xml_is_never_equated
  Scenario: Native check: dtd or malformed xml is never equated
    Given dtd is prepared as "b'<!DOCTYPE a [<!ENTITY e \"text\">]><a>&e;</a>'"
    When the dtd or malformed xml is never equated behavior is exercised with its prepared inputs
    Then not the result of equivalent xml with "b'<!DOCTYPE a [<!ENTITY e \"text\">]><a>&e;</a>'"; "b'<!DOCTYPE a [<!ENTITY e \"text\">]><a>&e;</a>'"
    And not the result of equivalent xml with "b'broken'"; "b'broken'"

  @candidate-python-package-preservation-59db595b9c
  # Native: tests/test_package_preservation.py::test_processing_instruction_targets_and_prolog_are_significant
  Scenario: Native check: processing instruction targets and prolog are significant
    Given the native processing instruction targets and prolog are significant inputs and isolated test state
    When the processing instruction targets and prolog are significant behavior is exercised with its prepared inputs
    Then not the result of equivalent xml with "b'<?one x?><a/>'"; "b'<?two x?><a/>'"
    And not the result of equivalent xml with "b'<a><?one x?></a>'"; "b'<a><?two x?></a>'"
    And not the result of equivalent xml with "b'<!--old--><a/>'"; "b'<!--new--><a/>'"
