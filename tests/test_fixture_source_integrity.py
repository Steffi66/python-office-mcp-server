"""Shared facts and workflows must be as immutable as document fixture bytes."""

import hashlib
import os
import stat
import subprocess

import pytest

from tests.fixture_paths import verify_fixture_source


def git(root, *args):
    return subprocess.check_output(["git", "--no-optional-locks", "-C", str(root), *args], text=True).strip()


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
        "contracts/mutation-safety.json": '{"schemaVersion":1}',
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
           "manifestSha256": hashlib.sha256((root / "manifest.json").read_bytes()).hexdigest()}
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
    # The root manifest payload remains unchanged; whole-checkout integrity
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


@pytest.mark.parametrize("field", ["manifestSha256"])
def test_wrong_seal_refuses_even_clean_release(release, field):
    root, pin = release
    with pytest.raises(RuntimeError, match="seal mismatch"):
        verify_fixture_source(root, {**pin, field: "0" * 64})


def test_nested_directory_is_not_mistaken_for_submodule(release):
    root, pin = release
    with pytest.raises(RuntimeError, match="initialised Git submodule"):
        verify_fixture_source(root / "facts", pin)


def assert_read_only_check(root, pin, expected_error=None):
    before = (root / ".git/index").read_bytes()
    flags = git(root, "ls-files", "-v")
    try:
        if expected_error:
            with pytest.raises(RuntimeError, match=expected_error):
                verify_fixture_source(root, pin)
        else:
            verify_fixture_source(root, pin)
    finally:
        assert (root / ".git/index").read_bytes() == before
        assert git(root, "ls-files", "-v") == flags


@pytest.mark.parametrize("flag", ["assume-unchanged", "skip-worktree"])
@pytest.mark.parametrize("name", ["facts/constants.json", "ledgers/workflows.json", "contracts/workflow.feature"])
def test_hidden_tracked_changes_refuse_without_refreshing_index(release, flag, name):
    root, pin = release
    git(root, "update-index", "--" + flag, "--", name)
    path = root / name
    path.write_bytes(path.read_bytes() + b" ")
    assert git(root, "status", "--porcelain") == ""
    assert_read_only_check(root, pin, "Tracked fixture blob mismatch")


@pytest.mark.parametrize("flag", ["assume-unchanged", "skip-worktree"])
def test_hidden_missing_file_refuses_without_refreshing_index(release, flag):
    root, pin = release
    name = "facts/constants.json"
    git(root, "update-index", "--" + flag, "--", name)
    (root / name).unlink()
    assert git(root, "status", "--porcelain") == ""
    assert_read_only_check(root, pin, "Cannot verify tracked fixture payload")


@pytest.mark.skipif(os.name == "nt", reason="POSIX executable mode bits unavailable")
@pytest.mark.parametrize("flag", ["assume-unchanged", "skip-worktree"])
def test_hidden_executable_mode_refuses_with_filemode_disabled(release, flag):
    root, pin = release
    name = "facts/constants.json"
    git(root, "config", "core.filemode", "false")
    git(root, "update-index", "--" + flag, "--", name)
    path = root / name
    path.chmod(path.stat().st_mode | stat.S_IXUSR)
    assert git(root, "status", "--porcelain") == ""
    assert_read_only_check(root, pin, "executable mode mismatch")


@pytest.mark.parametrize("flag", ["assume-unchanged", "skip-worktree"])
@pytest.mark.parametrize("symlink_kind", ["file", "parent"])
def test_hidden_symlink_to_identical_bytes_refuses(release, flag, symlink_kind):
    root, pin = release
    name = "facts/constants.json"
    git(root, "update-index", "--" + flag, "--", name)
    target = root / name if symlink_kind == "file" else root / "facts"
    outside = root.parent / ("outside.json" if symlink_kind == "file" else "outside-facts")
    target.rename(outside)
    try:
        target.symlink_to(outside, target_is_directory=symlink_kind == "parent")
    except (OSError, NotImplementedError):
        pytest.skip("Symbolic links unavailable")
    if symlink_kind == "parent":
        # Hide the replacement directory link from untracked detection too.
        with (root / ".git/info/exclude").open("a") as excluded:
            excluded.write("\n/facts\n")
    assert git(root, "status", "--porcelain") == ""
    assert_read_only_check(root, pin, "Tracked fixture symlink")


@pytest.mark.parametrize("flag", [None, "assume-unchanged", "skip-worktree"])
def test_clean_index_flags_are_preserved_without_false_refusal(release, flag):
    root, pin = release
    if flag:
        git(root, "update-index", "--" + flag, "--", "facts/constants.json")
    assert_read_only_check(root, pin)
