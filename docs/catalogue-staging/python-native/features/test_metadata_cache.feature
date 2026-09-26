@captured @python_candidate
Feature: metadata cache native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-metadata-cache-5c759f7f6e
  # Native: tests/test_metadata_cache.py::TestMetadataCacheHelpers::test_cache_key_stable_for_same_file_identity
  Scenario: Native check: cache key stable for same file identity [TestMetadataCacheHelpers]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as temp dir under "template.docx"
    And key1 is prepared as the result of metadata cache key with temp dir under "template.docx"; "word"; "template_metadata"
    And key2 is prepared as the result of metadata cache key with temp dir under "template.docx"; "word"; "template_metadata"
    When monkeypatch.setenv using "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And build template using temp dir under "template.docx"
    And metadata cache key using temp dir under "template.docx"; "word"; "template_metadata"
    Then the result of metadata cache key with temp dir under "template.docx"; "word"; "template_metadata" equals the result of metadata cache key with temp dir under "template.docx"; "word"; "template_metadata"

  @candidate-python-metadata-cache-69e49dbdc8
  # Native: tests/test_metadata_cache.py::TestMetadataCacheHelpers::test_cache_read_write_roundtrip
  Scenario: Native check: cache read write roundtrip [TestMetadataCacheHelpers]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as temp dir under "template.docx"
    And metadata is prepared as {"sections": [{"title": "Intro"}], "warnings": []}
    When monkeypatch.setenv using "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And build template using temp dir under "template.docx"
    And store cached metadata using temp dir under "template.docx"; "word"; "template_metadata"; {"sections": [{"title": "Intro"}], "warnings": []}
    And load cached metadata using temp dir under "template.docx"; "word"; "template_metadata"
    Then info at "hit" is true
    And cached equals {"sections": [{"title": "Intro"}], "warnings": []}

  @candidate-python-metadata-cache-e061ca50fb
  # Native: tests/test_metadata_cache.py::TestMetadataCacheHelpers::test_cache_invalidation_on_file_change
  Scenario: Native check: cache invalidation on file change [TestMetadataCacheHelpers]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as temp dir under "template.docx"
    And metadata is prepared as {"sections": [{"title": "Intro"}], "warnings": []}
    When monkeypatch.setenv using "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And build template using temp dir under "template.docx"
    And store cached metadata using temp dir under "template.docx"; "word"; "template_metadata"; {"sections": [{"title": "Intro"}], "warnings": []}
    And load cached metadata using temp dir under "template.docx"; "word"; "template_metadata"
    Then cached is null
    And info at "reason" equals "stale"

  @candidate-python-metadata-cache-75abc7255b
  # Native: tests/test_metadata_cache.py::TestMetadataCacheHelpers::test_corrupt_cache_falls_back_cleanly
  Scenario: Native check: corrupt cache falls back cleanly [TestMetadataCacheHelpers]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And cache path.write text with "{not valid json"
    And source is prepared as temp dir under "template.docx"
    And cache path is prepared as the result of metadata cache path with temp dir under "template.docx"; "word"; "template_metadata"
    When monkeypatch.setenv using "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And build template using temp dir under "template.docx"
    And metadata cache path using temp dir under "template.docx"; "word"; "template_metadata"
    And load cached metadata using temp dir under "template.docx"; "word"; "template_metadata"
    Then cached is null
    And info at "reason" equals "corrupt"

  @candidate-python-metadata-cache-26678b0b4c
  # Native: tests/test_metadata_cache.py::TestMetadataCacheHelpers::test_schema_mismatch_falls_back_cleanly
  Scenario: Native check: schema mismatch falls back cleanly [TestMetadataCacheHelpers]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And cache path.write text with the result of json.dumps with the fields "schemaVersion" set to CACHE SCHEMA VERSION joined with 1, "documentType" set to "word", "analysisType" set to "template_metadata", "source" set to the fields "path" set to str representation of the result of source.resolve with no arguments, "mtime_ns" set to the result of source.stat with no arguments st mtime ns, "size" set to the result of source.stat with no arguments st size, "generatedAt" set to "2026-04-08T00:00:00+00:00", "metadata" set to {"sections": []}
    And source is prepared as temp dir under "template.docx"
    And cache path is prepared as the result of metadata cache path with temp dir under "template.docx"; "word"; "template_metadata"
    When monkeypatch.setenv using "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And build template using temp dir under "template.docx"
    And metadata cache path using temp dir under "template.docx"; "word"; "template_metadata"
    And json.dumps using the fields "schemaVersion" set to CACHE SCHEMA VERSION joined with 1, "documentType" set to "word", "analysisType" set to "template_metadata", "source" set to the fields "path" set to str representation of the result of source.resolve with no arguments, "mtime_ns" set to the result of source.stat with no arguments st mtime ns, "size" set to the result of source.stat with no arguments st size, "generatedAt" set to "2026-04-08T00:00:00+00:00", "metadata" set to {"sections": []}
    And source.resolve using the prepared inputs
    Then cached is null
    And info at "reason" equals "schema_mismatch"

  @candidate-python-metadata-cache-bf0a4392ea
  # Native: tests/test_metadata_cache.py::TestMetadataCacheIntegration::test_word_parse_sow_template_uses_cache_on_second_call
  Scenario: Native check: word parse sow template uses cache on second call [TestMetadataCacheIntegration]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as the result of build template with temp dir under "template.docx"
    And tool is prepared as the result of WordAdvancedTools with no arguments
    When tool.tool word parse sow template using str representation of the result of build template with temp dir under "template.docx"
    Then first at "cache" at "reason" equals "stored"
    And second at "cache" at "hit" is true
    And second at "cache" at "reason" equals "hit"
    And second at "section_count" equals first at "section_count"
    And second at "anchors" is non-empty or true
    And second at "warnings" is non-empty or true

  @candidate-python-metadata-cache-d068423ce9
  # Native: tests/test_metadata_cache.py::TestMetadataCacheIntegration::test_word_parse_sow_template_regenerates_after_template_change
  Scenario: Native check: word parse sow template regenerates after template change [TestMetadataCacheIntegration]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as the result of build template with temp dir under "template.docx"
    And tool is prepared as the result of WordAdvancedTools with no arguments
    When tool.tool word parse sow template using str representation of the result of build template with temp dir under "template.docx"
    Then first at "cache" at "reason" equals "stored"
    And second at "cache" at "reason" equals "stored"
    And at least one item satisfies anchor at "text" starts with "Architecture decisions" for each anchor in second at "anchors"

  @candidate-python-metadata-cache-d189cde318
  # Native: tests/test_metadata_cache.py::TestMetadataCacheIntegration::test_office_template_analyze_exposes_cached_template_metadata
  Scenario: Native check: office template analyze exposes cached template metadata [TestMetadataCacheIntegration]
    Given an isolated writable temporary directory
    And isolated dependency/environment overrides
    And monkeypatch.setenv with "OFFICE_MCP_METADATA_CACHE_DIR"; str representation of temp dir under "cache"
    And source is prepared as the result of build template with temp dir under "template.docx"
    And server is prepared as the result of OfficeServer with no arguments
    When server.tool office template using source path str representation of the result of build template with temp dir under "template.docx"; destination path ""; operation "analyze"
    Then "template_metadata" occurs in first
    And first at "template_metadata" at "cache" at "reason" equals "stored"
    And second at "template_metadata" at "cache" at "reason" equals "hit"
    And second at "template_metadata" at "tables" at 0 at "purpose" equals "staffing"
