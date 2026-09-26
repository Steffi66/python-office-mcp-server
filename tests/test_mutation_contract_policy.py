"""Minimal workflow policies retain exact membership and unchanged-part coverage."""

import copy
import hashlib
import json

import pytest

from tests.fixture_paths import (
    mutation_contract,
    preserved_members,
    validate_mutation_contract,
    verified_metadata,
)


def test_preservation_complement_keeps_every_unallowed_member():
    fixture = {"memberSha256": {"edited.xml": "a", "opaque.bin": "b", "sentinel.xml": "c"},
               "allowedChangedPartsForSuccess": ["edited.xml"]}
    assert preserved_members(fixture) == {"opaque.bin": "b", "sentinel.xml": "c"}
    fixture["memberSha256"]["additional.bin"] = "d"
    assert preserved_members(fixture)["additional.bin"] == "d"


@pytest.mark.parametrize("fault", ["membership", "preserve", "unknown-asset", "unknown-member", "duplicate-member", "duplicate-scenario"])
def test_weakened_or_ambiguous_policies_refuse(fault):
    contract = copy.deepcopy(mutation_contract())
    assets = {f["assetId"]: {} for f in contract["fixtures"]}
    if fault in {"membership", "preserve"}:
        contract["fixturePolicy"][fault] = "ignore"
    elif fault == "unknown-asset":
        contract["fixtures"][0]["assetId"] = "not-known"
    elif fault == "unknown-member":
        contract["fixtures"][0]["allowedChangedPartsForSuccess"].append("not-present.xml")
    elif fault == "duplicate-member":
        allowed = contract["fixtures"][0]["allowedChangedPartsForSuccess"]
        allowed.append(allowed[0])
    else:
        contract["scenarioIds"][1] = contract["scenarioIds"][0]
    with pytest.raises(RuntimeError):
        validate_mutation_contract(contract, assets)


def test_root_manifest_seals_metadata_without_a_pack_manifest(tmp_path):
    target = tmp_path / "contracts/mutation-safety.json"
    target.parent.mkdir()
    data = b'{"schemaVersion":1}'
    target.write_bytes(data)
    record = {"path": "contracts/mutation-safety.json", "role": "workflow-contract",
              "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
    manifest = {"schemaVersion": 2, "files": [record]}
    (tmp_path / "manifest.json").write_text(json.dumps(manifest))
    assert verified_metadata(record["path"], record["role"], source=tmp_path) == data
    target.write_bytes(b'{"schemaVersion":2}')
    with pytest.raises(RuntimeError, match="differs from root manifest"):
        verified_metadata(record["path"], record["role"], source=tmp_path)
    target.write_bytes(data)
    manifest["files"].append(record)
    (tmp_path / "manifest.json").write_text(json.dumps(manifest))
    with pytest.raises(RuntimeError, match="ambiguous sealed metadata"):
        verified_metadata(record["path"], record["role"], source=tmp_path)
