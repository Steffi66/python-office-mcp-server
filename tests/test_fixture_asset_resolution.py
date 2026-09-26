"""Stable fixture IDs resolve through manifest metadata, never old directory aliases."""

import hashlib
import json

import pytest

from tests.fixture_paths import fixture_path, load_fixture_assets


def synthetic_manifest(root, relative="fixtures/docx/comments/renamable.docx"):
    data = b"synthetic fixture bytes"
    digest = hashlib.sha256(data).hexdigest()
    record = {"id": "fixture-" + digest, "path": relative, "bytes": len(data),
              "sha256": digest, "role": "fixture", "format": "docx", "scenarioGroup": "comments",
              "origins": [{"kind": "synthetic-test"}], "aliases": ["old/logical/path.docx"]}
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    manifest = {"schemaVersion": 2, "fixturePathBase": "repository-root", "files": [record]}
    (root / "manifest.json").write_text(json.dumps(manifest))
    return manifest, record


def save(root, manifest):
    (root / "manifest.json").write_text(json.dumps(manifest))


def test_stable_id_survives_physical_rename(tmp_path):
    manifest, record = synthetic_manifest(tmp_path)
    original = fixture_path(record["id"], source=tmp_path)
    renamed = tmp_path / "fixtures/docx/another-group/different-name.docx"
    renamed.parent.mkdir(parents=True)
    original.rename(renamed)
    record.update(path=renamed.relative_to(tmp_path).as_posix(), scenarioGroup="another-group")
    save(tmp_path, manifest)
    assert fixture_path(record["id"], source=tmp_path) == renamed
    with pytest.raises(RuntimeError, match="Unknown shared fixture ID"):
        fixture_path("old/logical/path.docx", source=tmp_path)


@pytest.mark.parametrize("relative", ["../escape.docx", "/absolute.docx", "testdata/file.docx",
                                      "fixtures/../escape.docx", "fixtures//bad.docx", "fixtures/a\\b.docx"])
def test_unsafe_or_alternate_fixture_root_refuses(tmp_path, relative):
    manifest, record = synthetic_manifest(tmp_path)
    record["path"] = relative
    save(tmp_path, manifest)
    with pytest.raises(RuntimeError, match="Unsafe shared fixture path"):
        load_fixture_assets(tmp_path)


def test_symlink_fixture_payload_refuses(tmp_path):
    manifest, record = synthetic_manifest(tmp_path)
    path = tmp_path / record["path"]
    outside = tmp_path / "outside.docx"
    path.rename(outside)
    try:
        path.symlink_to(outside)
    except (OSError, NotImplementedError):
        pytest.skip("Symbolic links unavailable on this platform")
    with pytest.raises(RuntimeError, match="escapes fixtures|must not use symlinks"):
        fixture_path(record["id"], source=tmp_path)


def test_duplicate_payload_ids_and_aliases_refuse(tmp_path):
    manifest, record = synthetic_manifest(tmp_path)
    manifest["files"].append(dict(record))
    save(tmp_path, manifest)
    with pytest.raises(RuntimeError, match="Duplicate fixture ID or content hash"):
        load_fixture_assets(tmp_path)
    manifest["files"].pop()
    record["aliases"].append(record["aliases"][0])
    save(tmp_path, manifest)
    with pytest.raises(RuntimeError, match="Duplicate or invalid historical fixture alias"):
        load_fixture_assets(tmp_path)


@pytest.mark.parametrize("field,value", [("format", "xlsx"), ("scenarioGroup", ""),
                                          ("bytes", -1), ("id", "fixture-invalid")])
def test_invalid_asset_metadata_refuses(tmp_path, field, value):
    manifest, record = synthetic_manifest(tmp_path)
    record[field] = value
    save(tmp_path, manifest)
    with pytest.raises(RuntimeError):
        load_fixture_assets(tmp_path)


def test_payload_tampering_refuses_even_with_same_length(tmp_path):
    _, record = synthetic_manifest(tmp_path)
    path = tmp_path / record["path"]
    path.write_bytes(b"x" * record["bytes"])
    with pytest.raises(RuntimeError, match="bytes differ from manifest"):
        fixture_path(record["id"], source=tmp_path)
