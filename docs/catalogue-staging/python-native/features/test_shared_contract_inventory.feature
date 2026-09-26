@captured @python_candidate
Feature: shared contract inventory native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-shared-contract-inventory-b71c520b86
  # Native: tests/test_shared_contract_inventory.py::test_shared_pack_matches_pinned_manifest
  Scenario: Native check: shared pack matches pinned manifest
    Given the native shared pack matches pinned manifest inputs and isolated test state
    When the shared pack matches pinned manifest behavior is exercised with its prepared inputs
    Then not FIXTURE SOURCE under "shared" exists
    And the result of verified metadata with "contracts/mutation-safety.json"; "workflow-contract" equals saved bytes of CONTRACT
    And the result of verified metadata with "workflows/mutation-safety.feature"; "workflow" equals saved bytes of FEATURE
    And POLICY at "fixturePolicy" equals {"membership": "exact", "preserve": "all-except-allowed"}

  @candidate-python-shared-contract-inventory-e40d4e868b
  # Native: tests/test_shared_contract_inventory.py::test_expanded_inventory_has_unique_ids_and_exact_fixture_pins
  Scenario: Native check: expanded inventory has unique ids and exact fixture pins
    Given source is prepared as saved bytes of FEATURE
    And scenarios is prepared as re matches for "b'^ (@id-[a-z0-9-]+)$'", saved bytes of FEATURE, re MULTILINE
    And the number of entries in re matches for "b'^ (@id-[a-z0-9-]+)$'", saved bytes of FEATURE, re MULTILINE equals the number of entries in set representation of re matches for "b'^ (@id-[a-z0-9-]+)$'", saved bytes of FEATURE, re MULTILINE and the number of entries in set representation of re matches for "b'^ (@id-[a-z0-9-]+)$'", saved bytes of FEATURE, re MULTILINE equals 8
    When inventory using the entries FEATURE
    Then the number of entries in the result of inventory with the entries FEATURE equals POLICY at "expandedCaseCount" and POLICY at "expandedCaseCount" equals 19
    And c at "scenarioId" for each c in the result of inventory with the entries FEATURE equals set representation of POLICY at "scenarioIds" and set representation of POLICY at "scenarioIds" equals the result of s.decode with no arguments for each s in re matches for "b'^ (@id-[a-z0-9-]+)$'", saved bytes of FEATURE, re MULTILINE
    And c at "stableCaseKey" for each c in the result of inventory with the entries FEATURE equals set representation of the result of json.loads with saved text of REPOSITORY under "tests/acceptance/shared-mapping.json" at "implementedCaseKeys"
    And case at "outcome" equals "planned"
    And case at "featureSha256" equals the result of digest with saved bytes of FEATURE
    And at least one item satisfies step at "type" equals "Outcome" for each step in case at "steps"
    And "fixture-" joined with the result of digest with saved bytes of the result of shared fixture with the result of next with the result of re.fullmatch with "fixture \"([^\"]+)\" verified against the fixture manifest"; s at "text" at 1 for each s in case at "steps" where s at "text" starts with "fixture \"" equals f for each f in POLICY at "fixtures" at the result of next with the result of re.fullmatch with "fixture \"([^\"]+)\" verified against the fixture manifest"; s at "text" at 1 for each s in case at "steps" where s at "text" starts with "fixture \"" at "assetId"

  @candidate-python-shared-contract-inventory-d520e49d59
  # Native: tests/test_shared_contract_inventory.py::test_fixture_and_member_hashes
  Scenario: Native check: fixture and member hashes
    Given a prepared fixture input or fixture
    And path is prepared as the result of shared fixture with fixture at "id"
    And asset is prepared as the result of load fixture assets with FIXTURE SOURCE at fixture at "assetId"
    And each of these native parameter variants is exercised independently
      | variant | parameter values |
      | [title-and-subtitle.pptx] | {"fixture": "{'id': 'title-and-subtitle.pptx', 'assetId': 'fixture-2aec94471f93c300d56ca4789106a974411085d1588f3424155362a06dd043f3', 'facts': {'slideCount': 1, 'slide1': {'title': 'Original title', 'subtitle': 'Original subtitle'}}, 'allowedChangedPartsForSuccess': ['ppt/slides/slide1.xml'], 'memberSha256': {'[Content_Types].xml': '6ab3a68b046347265eb95d2fe8254a47ce1c54ed07786351a81aeeee0d18c83d', '_rels/.rels': '762380638bf9443ce2877735f28fba27bdc8648f138298ef2485806fc36ffbac', 'customXml/preservation-sentinel.xml': 'b80f825e167d3ef176f2c0d96d33ce045352ca23e1272cf848433113eff8664d', 'docMetadata/LabelInfo.xml': 'cf6920270eaf515b468f40f211221be4853bfc44aea9d06e591dd1a84a3447ac', 'docProps/app.xml': '8a92317a315a1dd7453a855c22c076b1cfa6a07eeaa697203b2d667a5971611e', 'docProps/core.xml': 'c4b78164023098dca568d528487409cdf8ffeeb60f88f942123696ac201ab448', 'docProps/thumbnail.jpeg': '2f5b46476bb93bb970b0debe6582845721c4c027abe1f0be1fd7c175e2d3bdff', 'ppt/_rels/presentation.xml.rels': '6c38eb3088da6ec9ee6f33f157e329c366fa21ea95fcb45bde372a249590822e', 'ppt/presProps.xml': '9b2d272fb0c0ec29606b8b513dd3e9185f940c53cb81fa0db446c0445ec0ba85', 'ppt/presentation.xml': '16508356e684882c698d5fef1a4082b047d8e4fe20a07acab1d2154d116080eb', 'ppt/slideLayouts/_rels/slideLayout1.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout10.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout11.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout2.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout3.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout4.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout5.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout6.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout7.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout8.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/_rels/slideLayout9.xml.rels': '8246d333bf3764cd35563e3df1828c26bbc28890815a2987caf3e592791ba60d', 'ppt/slideLayouts/slideLayout1.xml': '34d3f04548f15599456032b04d59f7de963df223e0895e1c3c97567a3b437a67', 'ppt/slideLayouts/slideLayout10.xml': '4c7a938cec1c94895f8dcd76ef8a68efa8c892f0defa938db9805cc5f1af7d40', 'ppt/slideLayouts/slideLayout11.xml': '068e18567bb4d72f7c2647b2cf20f1a470399f7b10b5dbc495c51cab25bbe1b9', 'ppt/slideLayouts/slideLayout2.xml': '892506ec9f864e8f9f2d8b5dcb43b1c3d95bfee6b80d819aaee81c95f07b707d', 'ppt/slideLayouts/slideLayout3.xml': '6bf6a2521fb71ea825b21a68634db053fa66fce09e99e469fec229ca8291dfac', 'ppt/slideLayouts/slideLayout4.xml': 'cdbdd8ee98d2c56b16bf4311d983da33aebcd45518bb558b9df3ed57b3e7529e', 'ppt/slideLayouts/slideLayout5.xml': '7e4d7cbeb9b240adfe9272cbe0b4367b35a842010c95f26f8b6c7df2646c86f0', 'ppt/slideLayouts/slideLayout6.xml': '874eff0965a4e992feb8e34c30abf38eca89956b414357cf78835ad0ebbd6a5b', 'ppt/slideLayouts/slideLayout7.xml': '3d8797b1b1b592e4f42cd9431008f1e54ddcd9f8aa2e0e7455f047504bbd4348', 'ppt/slideLayouts/slideLayout8.xml': 'e6ccab7800e506f8b1c8742143ca0ecb506d925e17889b35d771d757e3722c6d', 'ppt/slideLayouts/slideLayout9.xml': '72d77a3d15d60b8ca7373f19935814f7c6ab6ddcd72f36848b5a1db450eda87d', 'ppt/slideMasters/_rels/slideMaster1.xml.rels': 'e9e503158ddaff4d9afa825a3d1048ffa1c1275291d9ab818812ff8e061ea8fd', 'ppt/slideMasters/slideMaster1.xml': 'b2b6bcf3cd43fbfe011adb080745ce55a4f8a2133d20f44479ecd859c32d9e11', 'ppt/slides/_rels/slide1.xml.rels': 'e125c916ff3118a8767f5a2303bd9c0b3068a0e7476556f56fbe2f41943c26a9', 'ppt/slides/slide1.xml': '9889b9e48d77e8c2e37972b15355a6878dbb590d7e72e6091bf7ae2813cd306b', 'ppt/tableStyles.xml': '0e7ac03251337ecbaf6c8ca13619db1caeda5c90c4e3210d45d6c3f5df4de103', 'ppt/theme/theme1.xml': '4c3412087e8fa20cf5642f42e69f1e733881c28611a2bdd4622654ee313d214e', 'ppt/viewProps.xml': '0dd9e6966af2b7baae65c67e106052babe84d6f4eda2946f07c69888cab51c8e'}}"} |
      | [present-placeholder.docx] | {"fixture": "{'id': 'present-placeholder.docx', 'assetId': 'fixture-535910216e3531e4f70959cccf83038f1c51febbf4a149f9f46abfbfa8667d90', 'facts': {'bodyText': '<Present>', 'absentText': '<Missing>'}, 'allowedChangedPartsForSuccess': ['word/document.xml', 'word/settings.xml'], 'memberSha256': {'[Content_Types].xml': '2df32f34112e2bb1d6cd7e78777a813c21adfb3c08036301c3856eb87e63c9e9', '_rels/.rels': 'e6a262fba21a1de765b7bf06c30dadb26aef76c14cde97ad23ed1926ee56f9db', 'customXml/_rels/item1.xml.rels': '80482f86e196171d66001e0e74d1900408a3aaf2463e54005d251b5f2db9a0b0', 'customXml/item1.xml': 'fd38bf9d14299ec0909557ff8b08b38816a6860d488f11a7c53dc63eb13ee44f', 'customXml/itemProps1.xml': '4c998dc0bc6eb6f38ecc20856255fff6891d5b6345a7260698c53063da4bc5f2', 'customXml/preservation-sentinel.xml': 'b80f825e167d3ef176f2c0d96d33ce045352ca23e1272cf848433113eff8664d', 'docMetadata/LabelInfo.xml': '857642758c87cdc181e6e757e887e84ef5b1fa7889bbfb28d7313f06150e7df7', 'docProps/app.xml': '938ecd7d22e43ae7ba5f169cd98f911dbf3919f1f7ad7c76d31906daddc73817', 'docProps/core.xml': 'c303f140e713efda344235c649c4e4611c96aee1ac0f0fbc924b870d40d5e6ff', 'word/_rels/document.xml.rels': '14e2469320c6c093096066505e35f3c94b2eb61b47eecb47ef2585ae3dc64222', 'word/document.xml': '2c749ca2c670373ac74381d5a470ae0c86c0f53c4597b10be89d369743300fb5', 'word/fontTable.xml': '80afe49c53877d33b6047ff8675986a50411b025dc09721369b573151c58ab63', 'word/numbering.xml': 'ce80cea09e284909636cb1d5a5da259e33a5122d6b03797536cc437746f613f7', 'word/settings.xml': 'e3f4bb26cde8be1b7729c2a86fbc4392c50a9ec47b1f88e205dda0ddd960520b', 'word/styles.xml': '70dd2f9b81a34e12bffca926c1e53fb9f10ef156bc7d2e003502e0c919326332', 'word/theme/theme1.xml': 'b2295d3198893d2c03f5e584c749a15751b798aefdcd9bee2889f13903d68cb2', 'word/webSettings.xml': 'ee07406206c299bd15efc79295c9a223911089ff30b81b89c17dd93064d33d58'}}"} |
      | [default-style.xlsx] | {"fixture": "{'id': 'default-style.xlsx', 'assetId': 'fixture-38c2ed936696179d3b2359e9107ad2b8d62d71d69296f8f60bdfe1fe8f7f2439', 'facts': {'activeSheetCellA1': 'before', 'cellXfsCount': 1, 'absentSheet': 'Missing'}, 'allowedChangedPartsForSuccess': ['xl/worksheets/sheet1.xml', 'xl/styles.xml', 'xl/workbook.xml'], 'memberSha256': {'[Content_Types].xml': 'c231f8ec622013ad13c7e2dee7358ad6852c35a2723d5a7d11666251bdd1a136', '_rels/.rels': 'dde81334e088a6877ef0b11b338377be774d944080e380b1bc105147683b2da6', 'customXml/preservation-sentinel.xml': 'b80f825e167d3ef176f2c0d96d33ce045352ca23e1272cf848433113eff8664d', 'docMetadata/LabelInfo.xml': '857642758c87cdc181e6e757e887e84ef5b1fa7889bbfb28d7313f06150e7df7', 'docProps/app.xml': '209fca6b00afe72a5029754b94be5953d8f16d96f67130325566b9366ad4ccc5', 'docProps/core.xml': '8ce052385c2e46ba3da46c9c9c36e6d0fae2cee04e98605e04466db4dce2dc0c', 'xl/_rels/workbook.xml.rels': '26ad8fcc38d41229833e624496df364492772697ad2e5d6696e1738f05ba225f', 'xl/styles.xml': 'ceabc26839ae8c5285c667366bffa538562f76e219eb4f2f5188626232d96900', 'xl/theme/theme1.xml': 'd15e8ebf78ef7b9720839d7ae8fdc81a7df5bc24706d8e137df61a5683c358d9', 'xl/workbook.xml': '0118136ea9ff4b7a8178fc79b6a9a5fa285927dc238c79c67b418fdb505dd400', 'xl/worksheets/sheet1.xml': 'a3e06f53409c8176305d5fcfa9a7870d69fc52a04de629a93f5227d8db110a8c'}}"} |
      | [cross-sheet-cache.xlsx] | {"fixture": "{'id': 'cross-sheet-cache.xlsx', 'assetId': 'fixture-8ba5708d5030adf93a4f7e4ae466563a1b66341067a200a6cb9b782484dcb5b1', 'facts': {'Input!A1': 1, 'Calc!A1': {'formula': '=Input!A1*2', 'cachedValue': 2}, 'calcChainPresent': False}, 'allowedChangedPartsForSuccess': ['xl/worksheets/sheet1.xml', 'xl/worksheets/sheet2.xml', 'xl/workbook.xml'], 'memberSha256': {'[Content_Types].xml': 'ceee553956c95720ede66de6d0ac43a3f434e35da3e924d4f42c737f86ae92d6', '_rels/.rels': 'dde81334e088a6877ef0b11b338377be774d944080e380b1bc105147683b2da6', 'customXml/preservation-sentinel.xml': 'b80f825e167d3ef176f2c0d96d33ce045352ca23e1272cf848433113eff8664d', 'docMetadata/LabelInfo.xml': '857642758c87cdc181e6e757e887e84ef5b1fa7889bbfb28d7313f06150e7df7', 'docProps/app.xml': '209fca6b00afe72a5029754b94be5953d8f16d96f67130325566b9366ad4ccc5', 'docProps/core.xml': '8ce052385c2e46ba3da46c9c9c36e6d0fae2cee04e98605e04466db4dce2dc0c', 'xl/_rels/workbook.xml.rels': 'c92b03d81aff7421c86461ec82da1607d7ba670630d84fa849992a31fd68e06b', 'xl/styles.xml': 'ceabc26839ae8c5285c667366bffa538562f76e219eb4f2f5188626232d96900', 'xl/theme/theme1.xml': 'd15e8ebf78ef7b9720839d7ae8fdc81a7df5bc24706d8e137df61a5683c358d9', 'xl/workbook.xml': '3fac8ac4c7ec6c13cfc1660513c3315145ef20d0fee37f5e17e1eb5e1f927b6e', 'xl/worksheets/sheet1.xml': '63841d43a2b6686e56b50601bed72c1d007ad52d5d844a0ddc56bac7ba8b3a97', 'xl/worksheets/sheet2.xml': '636912335c42b3ee0516632ffdf446441a650942364b3786ea125d41ecd0aa64'}}"} |
    When shared fixture using fixture at "id"
    And load fixture assets using FIXTURE SOURCE
    And archive.namelist using the prepared inputs
    Then the result of shared fixture with fixture at "id" equals FIXTURE SOURCE under the result of load fixture assets with FIXTURE SOURCE at fixture at "assetId" at "path"
    And the result of digest with saved bytes of the result of shared fixture with fixture at "id" equals the result of load fixture assets with FIXTURE SOURCE at fixture at "assetId" at "sha256"
    And at least one item satisfies origin field "revision" equals "36ac406ad9d4bd3e7538b4bcc7aa2fb0e51cc943" for each origin in the result of load fixture assets with FIXTURE SOURCE at fixture at "assetId" at "origins"
    And the number of entries in archive ZIP member names equals the number of entries in set representation of archive ZIP member names
    And the result of archive.testzip with no arguments is null
    And set representation of archive ZIP member names equals set representation of fixture at "memberSha256"
    And "customXml/preservation-sentinel.xml" occurs in the result of preserved members with fixture
    And set representation of the result of preserved members with fixture equals set representation of archive ZIP member names minus set representation of fixture at "allowedChangedPartsForSuccess"
    And the result of digest with archive saved payload for name equals fixture at "memberSha256" at name

  @candidate-python-shared-contract-inventory-ca6f9e6c3f
  # Native: tests/test_shared_contract_inventory.py::test_pinned_word_and_slide_facts
  Scenario: Native check: pinned word and slide facts
    Given Open Document(ROOT / "fixtures" / "present-placeholder.docx").
    And Open Presentation(ROOT / "fixtures" / "title-and-subtitle.pptx").
    When Collect [p.text for p in document.paragraphs].
    And Read len(presentation.slides).
    And Read presentation.slides[0].shapes.title.text.
    And Read presentation.slides[0].placeholders[1].text.
    Then The document paragraph texts equal ["<Present>"].
    And The presentation has exactly 1 slide.
    And The first slide title text is "Original title".
    And presentation.slides[0].placeholders[1].text equals "Original subtitle".

  @candidate-python-shared-contract-inventory-af21552e25
  # Native: tests/test_shared_contract_inventory.py::test_pinned_workbook_style_and_cache_facts
  Scenario: Native check: pinned workbook style and cache facts
    Given path is prepared as the result of shared fixture with "default-style.xlsx"
    When shared fixture using "default-style.xlsx"
    And load workbook using the result of shared fixture with "default-style.xlsx"
    And ET.fromstring using archive saved payload for "xl/styles.xml"
    And archive.read using "xl/styles.xml"
    And load workbook using the result of shared fixture with "cross-sheet-cache.xlsx"
    Then workbook active at "A1" value equals "before"
    And "Missing" does not occur in workbook sheetnames
    And the number of entries in the result of ET.fromstring with archive saved payload for "xl/styles.xml" first match for "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}" joined with "cellXfs" equals 1
    And workbook at "Input" at "A1" value equals 1
    And workbook at "Calc" at "A1" value equals expected

  @candidate-python-shared-contract-inventory-4df58a8169
  # Native: tests/test_shared_contract_inventory.py::test_central_fixture_manifest_matches_python_inputs
  Scenario: Native check: central fixture manifest matches python inputs
    Given records is prepared as the result of load fixture assets with FIXTURE SOURCE
    And mapping is prepared as the result of template asset ids with no arguments
    When load fixture assets using FIXTURE SOURCE
    And template asset ids using the prepared inputs
    And records.values using the prepared inputs
    And alias.startswith using "fixtures/python-office-mcp-server/tests/_templates/"
    And mapping.values using the prepared inputs
    Then the number of entries in the result of template asset ids with no arguments equals 37
    And the result of template asset ids with no arguments equals record at "id" for each record in the result of load fixture assets with FIXTURE SOURCE values for each alias in record at "aliases" where alias starts with "fixtures/python-office-mcp-server/tests/_templates/"
    And the result of fixture path with asset id is a file is non-empty or true
    And the result of p.relative to(FIXTURE SOURCE).as posix with no arguments for each p in the result of (FIXTURE SOURCE / 'fixtures').rglob with "*" where p is a file equals record at "path" for each record in the result of load fixture assets with FIXTURE SOURCE values

  @candidate-python-shared-contract-inventory-06d276c54d
  # Native: tests/test_shared_contract_inventory.py::test_python_constants_match_selected_shared_facts
  Scenario: Native check: python constants match selected shared facts
    Given bindings is prepared as the fields "namespaces" set to the fields "NSWordprocessingML" set to word tools W NS, "NSWord14" set to word tools W14 NS, "NSContentTypes" set to word tools PKG CT NS, "NSRelationships" set to word tools PKG REL NS, "relationships" set to the fields "RelTypeCommentsExtended" set to word tools REL COMMENTS EXTENDED, "content-types" set to the fields "ContentTypeCommentsExtendedSpecified" set to word tools CT COMMENTS EXTENDED
    When bindings.items using the prepared inputs
    And json.loads using saved text of FIXTURE SOURCE under "facts" under group joined with ".json"
    And constants.items using the prepared inputs
    And (FIXTURE SOURCE / 'facts' / (group + '.json')).read text using the prepared inputs
    And json.loads using saved text of FIXTURE SOURCE under "facts/content-types.json"
    Then the result of json.loads with saved text of FIXTURE SOURCE under "facts" under group joined with ".json" at "schemaVersion" equals 1
    And the number of entries in row for each row in the result of json.loads with saved text of FIXTURE SOURCE under "facts" under group joined with ".json" at "values" equals the number of entries in the result of json.loads with saved text of FIXTURE SOURCE under "facts" under group joined with ".json" at "values"
    And row for each row in the result of json.loads with saved text of FIXTURE SOURCE under "facts" under group joined with ".json" at "values" at name at "status" occurs in "{'specified', 'observed'}"
    And row for each row in the result of json.loads with saved text of FIXTURE SOURCE under "facts" under group joined with ".json" at "values" at name at "value" equals value
    And the result of next with row for each row in the result of json.loads with saved text of FIXTURE SOURCE under "facts/content-types.json" at "values" where row at "id" equals "ContentTypeCommentsExtended" at "status" equals "disputed"
    And the result of next with row for each row in the result of json.loads with saved text of FIXTURE SOURCE under "facts/content-types.json" at "values" where row at "id" equals "ContentTypeCommentsExtended" at "value" differs from word tools CT COMMENTS EXTENDED

  @candidate-python-shared-contract-inventory-e3956cda42
  # Native: tests/test_shared_contract_inventory.py::test_fixture_submodule_matches_common_tag_and_seals
  Scenario: Native check: fixture submodule matches common tag and seals
    Given the native fixture submodule matches common tag and seals inputs and isolated test state
    When verify fixture source using FIXTURE SOURCE; the result of json.loads with saved text of REPOSITORY under "tests/fixtures-pin.json"
    And json.loads using saved text of REPOSITORY under "tests/fixtures-pin.json"
    And (REPOSITORY / 'tests/fixtures-pin.json').read text using the prepared inputs
    Then the resulting document or diagnostic output is available for manual inspection
