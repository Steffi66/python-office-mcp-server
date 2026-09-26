@planned
Feature: Conservative XML comparison for package preservation
  Compare two XML byte sequences for the bounded preservation decisions covered
  by the native Python tests. This operation returns a Boolean; it does not emit
  canonical XML or define a general lexical-parser acceptance contract.

  @id-xml-comparison-prefix-and-opc-order
  Scenario: Prefix spelling and OPC relationship order compare equivalent
    Given the left XML is <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="a" Target="a.xml"/><Relationship Id="b" Target="b.xml"/></Relationships>
    And the right XML is <r:Relationships xmlns:r="http://schemas.openxmlformats.org/package/2006/relationships"><r:Relationship Target="b.xml" Id="b"/><r:Relationship Target="a.xml" Id="a"/></r:Relationships>
    When equivalent_xml compares their UTF-8 bytes
    Then the comparison result is true

  @id-xml-comparison-significant-content
  Scenario Outline: XML content change to <variant> compares different
    Given the left XML is <left>
    And the right XML is <right>
    When equivalent_xml compares their UTF-8 bytes
    Then the comparison result is false

    Examples:
      | variant         | left                  | right                |
      | text whitespace | <a><b> x </b></a>      | <a><b>x</b></a>       |
      | child order     | <a><b/><c/></a>        | <a><c/><b/></a>       |
      | attribute value | <a v="1"/>            | <a v="2"/>           |

  @id-xml-comparison-prefix-attribute-binding
  Scenario: A prefix-valued attribute retains its namespace binding
    Given the left XML is <a xmlns:p="urn:one" value="p:x"/>
    And the right XML is <a xmlns:p="urn:two" value="p:x"/>
    When equivalent_xml compares their UTF-8 bytes
    Then the comparison result is false

  @id-xml-comparison-unsafe-input
  Scenario Outline: Identical <variant> inputs do not compare equivalent
    Given the left XML is <input>
    And the right XML is <input>
    When equivalent_xml compares their UTF-8 bytes
    Then the comparison result is false

    Examples:
      | variant       | input                                             |
      | DTD-bearing   | <!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a>          |
      | malformed XML | broken                                            |

  @id-xml-comparison-processing-instructions-and-comments
  Scenario Outline: XML markup change to <variant> compares different
    Given the left XML is <left>
    And the right XML is <right>
    When equivalent_xml compares their UTF-8 bytes
    Then the comparison result is false

    Examples:
      | variant                     | left                  | right                 |
      | prolog PI target            | <?one x?><a/>         | <?two x?><a/>         |
      | in-document PI target       | <a><?one x?></a>       | <a><?two x?></a>       |
      | prolog comment content      | <!--old--><a/>        | <!--new--><a/>        |
