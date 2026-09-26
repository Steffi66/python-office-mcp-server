@planned
Feature: Package admission refuses DTD-bearing or malformed XML members
  These cases inspect XML carried inside ZIP members. They do not define
  standalone lexical-parser acceptance, entity fetching or XML equivalence.

  @id-package-admission-unsafe-xml-members
  Scenario Outline: XML member admission refuses <variant>
    Given a ZIP_STORED archive contains a.xml with <encoding> text <xml>
    When the package admission guard checks the archive with default limits
    Then package admission is refused

    Examples:
      | variant                   | encoding         | xml                                        |
      | internal DTD with entity  | UTF-8            | <!DOCTYPE a [<!ENTITY e "text">]><a>&e;</a> |
      | UTF-16 DTD                | UTF-16 with BOM  | <!DOCTYPE a><a/>                          |
      | malformed XML             | UTF-8            | <broken>                                  |
