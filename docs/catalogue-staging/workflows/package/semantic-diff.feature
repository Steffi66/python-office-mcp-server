@planned
Feature: Package diff separates equivalent XML from changed binary members
  This is semantic package comparison. It does not require byte-identical XML
  serialisation and does not exercise ZIP writing or Office rendering fidelity.

  @id-package-diff-equivalent-xml-and-binary-changes
  Scenario: Prefix-only XML changes are reported separately from binary changes
    Given the original ZIP_STORED package has these ordered UTF-8 members
      | member | payload            |
      | a.xml  | <a xmlns="urn:x"/>  |
      | b.bin  | old                |
    And the modified ZIP_STORED package has these ordered UTF-8 members
      | member | payload                   |
      | a.xml  | <p:a xmlns:p="urn:x"/>      |
      | b.bin  | new                       |
      | c.bin  | added                     |
    When the semantic package diff compares original and modified packages
    Then the equivalent_xml member list is ["a.xml"]
    And the changed member list is ["b.bin"]
    And the added member list is ["c.bin"]
    And the removed member list is []
