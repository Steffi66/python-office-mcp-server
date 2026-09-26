@planned
Feature: Bounded ZIP admission rejects unsafe members and unsupported storage
  These scenarios exercise package admission, not ZIP writing, archive repair,
  decompression-allocation measurement or a general-purpose ZIP parser.

  @id-package-admission-unsafe-members
  Scenario Outline: ZIP admission refuses <variant>
    Given an ordered ZIP_STORED archive has member pairs encoded as JSON <entries_json>
    When the package admission guard checks the archive with default limits
    Then package admission is refused

    Examples:
      | variant                    | entries_json                                         |
      | duplicate member names     | [["a.xml","<a/>"],["a.xml","<b/>"]]                  |
      | parent traversal name      | [["../a.xml","<a/>"]]                               |
      | absolute member name       | [["/a.xml","<a/>"]]                                 |
      | backslash member name      | [["x\\\\a.xml","<a/>"]]                             |
      | directory entry with bytes | [["a/","payload"]]                                  |

  @id-package-admission-resource-limits
  Scenario Outline: ZIP admission refuses the package with <limit> set to <value>
    Given a ZIP_DEFLATED archive contains a.xml with UTF-8 XML enclosing exactly 10000 spaces between <a> and </a>
    When the package admission guard checks the archive with only <limit> set to <value>
    Then package admission is refused

    Examples:
      | limit            | value |
      | max_members      | 0     |
      | max_member_bytes | 2     |
      | max_total_bytes  | 2     |
      | max_ratio        | 1     |

  @id-package-admission-unsupported-compression
  Scenario: ZIP admission refuses BZIP2 member compression
    Given a ZIP_BZIP2 archive contains a.xml with UTF-8 text <a/>
    When the package admission guard checks the archive with default limits
    Then package admission is refused
    And the admission error contains compression
