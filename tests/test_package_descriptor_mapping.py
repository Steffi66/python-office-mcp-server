"""The ZIP descriptor binding rejects drift and earns no credit from its mapping."""

import copy
import struct

import pytest

from tests.package_descriptor_integrity.cases import CASE_KEY, FEATURE_SHA256, load_cases
from tests.package_descriptor_integrity.test_descriptor import authored_archive
from tools.package_guard import PackageAdmissionError, inspect_unsigned_zip32_descriptor


@pytest.mark.parametrize("fault", ["descriptor-size", "central-borrow", "signed-extent"])
def test_raw_descriptor_probe_rejects_altered_extent(tmp_path, fault):
    raw, compressed, payload_start, central_offset = authored_archive()
    changed = bytearray(raw)
    descriptor_start = payload_start + len(compressed)
    if fault == "descriptor-size":
        struct.pack_into("<I", changed, descriptor_start + 4, len(compressed) + 1)
    elif fault == "central-borrow":
        struct.pack_into("<I", changed, len(changed) - 22 + 16, central_offset - 4)
    else:
        changed[descriptor_start:descriptor_start] = b"PK\\x07\\x08"
        struct.pack_into("<I", changed, len(changed) - 22 + 16, central_offset + 4)
    path = tmp_path / "altered.zip"
    path.write_bytes(changed)
    with pytest.raises(PackageAdmissionError):
        inspect_unsigned_zip32_descriptor(path)
    assert path.read_bytes() == changed


def test_exact_descriptor_inventory():
    case, = load_cases()
    assert case["stableCaseKey"] == CASE_KEY
    assert case["featureSha256"] == FEATURE_SHA256
    assert case["outcome"] == "not-run"
    assert len(case["steps"]) == 8
    assert all(step["outcome"] == "not-run" for step in case["steps"])


@pytest.mark.parametrize("fault", ["duplicate", "identity", "setup", "action", "outcome", "lifecycle", "feature"])
def test_changed_descriptor_declaration_refuses(monkeypatch, fault):
    from tests.package_descriptor_integrity import cases as module

    case = copy.deepcopy(module.inventory([module.FIXTURE_SOURCE / module.FEATURE])[0])
    if fault == "duplicate":
        cases = [case, copy.deepcopy(case)]
    else:
        cases = [case]
        if fault == "identity":
            case["stableCaseKey"] = "@id-other:{}"
        elif fault == "setup":
            case["steps"][0]["text"] = case["steps"][0]["text"].replace('"payload"', '"other"')
        elif fault == "action":
            case["steps"][3]["text"] = "ZIP admission skips descriptor shape"
        elif fault == "outcome":
            case["steps"][5]["text"] = "the corrupt payload is accepted"
        elif fault == "lifecycle":
            case["outcome"] = "passed"
        else:
            case["featureSha256"] = "changed"
    monkeypatch.setattr(module, "inventory", lambda paths: cases)
    with pytest.raises(ValueError):
        module.load_cases()
