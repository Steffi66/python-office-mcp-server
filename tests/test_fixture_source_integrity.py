"""Shared facts and workflows must be as immutable as document fixture bytes."""

import hashlib
import subprocess

import pytest

from tests.fixture_paths import verify_fixture_source


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()


@pytest.fixture
def release(tmp_path):
    root = tmp_path / "shared"
    root.mkdir()
    git(root, "init", "-q")
    git(root, "config", "user.name", "Rui Carmo")
    git(root, "config", "user.email", "rui.carmo@gmail.com")
    git(root, "config", "commit.gpgsign", "false")
    files = {
        "manifest.json": '{"schemaVersion":2}',
        "shared/v2/pack/pack-manifest.json": '{"schemaVersion":1}',
        "facts/constants.json": '{"values":[]}',
        "ledgers/workflows.json": '{"workflows":[]}',
        "contracts/workflow.feature": "Feature: An immutable behaviour reference\n",
    }
    for name, contents in files.items():
        path = root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(contents)
    git(root, "add", ".")
    git(root, "commit", "-qm", "Create synthetic release for integrity checks")
    git(root, "-c", "tag.gpgSign=false", "tag", "-a", "v-test", "-m", "Synthetic fixture release")
    pin = {"commit": git(root, "rev-parse", "HEAD"), "tag": "v-test",
           "manifestSha256": hashlib.sha256((root / "manifest.json").read_bytes()).hexdigest(),
           "sharedPackManifestSha256": hashlib.sha256((root / "shared/v2/pack/pack-manifest.json").read_bytes()).hexdigest()}
    return root, pin


def test_clean_annotated_release_is_accepted(release):
    root, pin = release
    verify_fixture_source(root, pin)


@pytest.mark.parametrize("path,stage", [
    ("facts/constants.json", False),
    ("facts/constants.json", True),
    ("ledgers/workflows.json", False),
    ("contracts/workflow.feature", False),
    ("unexpected.json", False),
])
def test_changes_outside_asset_manifest_refuse(release, path, stage):
    root, pin = release
    # Both sealed manifest payloads remain unchanged; whole-checkout integrity
    # must still reject facts/workflows or newly introduced files.
    (root / path).write_text("changed")
    if stage:
        git(root, "add", path)
    with pytest.raises(RuntimeError, match="checkout is dirty"):
        verify_fixture_source(root, pin)


def test_lightweight_tag_is_not_a_release(release):
    root, pin = release
    git(root, "tag", "-d", pin["tag"])
    git(root, "-c", "tag.gpgSign=false", "tag", pin["tag"])
    with pytest.raises(RuntimeError, match="annotated tag"):
        verify_fixture_source(root, pin)


def test_head_must_match_pin(release):
    root, pin = release
    git(root, "commit", "--allow-empty", "-qm", "Different source revision")
    with pytest.raises(RuntimeError, match="HEAD differs"):
        verify_fixture_source(root, pin)


def test_tag_must_point_to_pinned_head(release):
    root, pin = release
    git(root, "commit", "--allow-empty", "-qm", "New head with old release tag")
    pin = {**pin, "commit": git(root, "rev-parse", "HEAD")}
    with pytest.raises(RuntimeError, match="tag differs"):
        verify_fixture_source(root, pin)


@pytest.mark.parametrize("field", ["manifestSha256", "sharedPackManifestSha256"])
def test_wrong_seal_refuses_even_clean_release(release, field):
    root, pin = release
    with pytest.raises(RuntimeError, match="seal mismatch"):
        verify_fixture_source(root, {**pin, field: "0" * 64})


def test_nested_directory_is_not_mistaken_for_submodule(release):
    root, pin = release
    with pytest.raises(RuntimeError, match="initialised Git submodule"):
        verify_fixture_source(root / "facts", pin)
