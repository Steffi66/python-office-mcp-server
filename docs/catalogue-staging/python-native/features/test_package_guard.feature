@captured @python_candidate
Feature: package guard native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-package-guard-6990b40908
  # Native: tests/test_package_guard.py::test_unsafe_structure_refuses
  Scenario: Native check: unsafe structure refuses
    Given an isolated writable temporary directory
    And a prepared entries input or fixture
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [entries0] | {"entries": "[('a.xml', b'<a/>'), ('a.xml', b'<b/>')]"} |
      | [entries1] | {"entries": "[('../a.xml', b'<a/>')]"} |
      | [entries2] | {"entries": "[('/a.xml', b'<a/>')]"} |
      | [entries3] | {"entries": "[('x\\\\\\\\a.xml', b'<a/>')]"} |
      | [entries4] | {"entries": "[('a/', b'payload')]"} |
      | [entries5] | {"entries": "[('a.xml', b'<!DOCTYPE a [<!ENTITY e \\"text\\">]><a>&e;</a>')]"} |
      | [entries6] | {"entries": "[('a.xml', b'\\\\xff\\\\xfe<\\\\x00!\\\\x00D\\\\x00O\\\\x00C\\\\x00T\\\\x00Y\\\\x00P\\\\x00E\\\\x00 \\\\x00a\\\\x00>\\\\x00<\\\\x00a\\\\x00/\\\\x00>\\\\x00')]"} |
      | [entries7] | {"entries": "[('a.xml', b'<broken>')]"} |
    When admit package using the result of archive with tmp path; entries
    Then the operation raises PackageAdmissionError

  @candidate-python-package-guard-6a549316ed
  # Native: tests/test_package_guard.py::test_limits_refuse_before_large_allocations
  Scenario: Native check: limits refuse before large allocations
    Given A DEFLATED ZIP contains a.xml with ten thousand spaces enclosed in an XML element
    And Each configured limit is tested independently: max_members=1, max_member_bytes=4, max_total_bytes=8 or max_ratio=2
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [limit0] | {"limit": "{'max_members': 0}"} |
      | [limit1] | {"limit": "{'max_member_bytes': 2}"} |
      | [limit2] | {"limit": "{'max_total_bytes': 2}"} |
      | [limit3] | {"limit": "{'max_ratio': 1}"} |
    When Run package admission with the selected resource limit
    Then Package admission raises PackageAdmissionError

  @candidate-python-package-guard-803565567d
  # Native: tests/test_package_guard.py::test_unsupported_compression_refuses
  Scenario: Native check: unsupported compression refuses
    Given an isolated writable temporary directory
    And path is prepared as the result of archive with tmp path; [["a.xml", "b'<a/>'"]]; zipfile ZIP BZIP2
    When admit package using the result of archive with tmp path; [["a.xml", "b'<a/>'"]]; zipfile ZIP BZIP2
    Then the operation raises PackageAdmissionError with a message matching "compression"

  @candidate-python-package-guard-004ca93762
  # Native: tests/test_package_guard.py::test_package_diff_distinguishes_real_and_equivalent_changes
  Scenario: Native check: package diff distinguishes real and equivalent changes
    Given The old ZIP contains a.xml=<a xmlns="urn:a"/> and b.bin=old
    And The new ZIP contains the equivalent prefix spelling <p:a xmlns:p="urn:a"/>, b.bin=new and added c.bin=added
    When Compare the original and changed ZIP package payloads
    Then a.xml is reported as equivalent XML
    And b.bin is reported changed
    And c.bin is reported added
    And No member is reported removed
