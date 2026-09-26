"""Read-only paths into the shared fixture submodule; never generate inputs there."""

import hashlib
import json
import subprocess
from pathlib import Path, PurePosixPath

REPOSITORY = Path(__file__).resolve().parents[1]
FIXTURE_SOURCE = REPOSITORY / "references" / "fixtures-ooxml"
SHARED = FIXTURE_SOURCE / "shared" / "v2" / "pack"
FEATURE = SHARED / "features" / "mutation-safety.feature"


def load_fixture_assets(source):
    """Validate the ID index without assuming directory depth or filename spelling."""
    manifest = json.loads((source / "manifest.json").read_text())
    if manifest.get("schemaVersion") != 2 or manifest.get("fixturePathBase") != "repository-root":
        raise RuntimeError("Expected shared fixture manifest schema 2 with repository-root paths")
    assets = {}
    hashes = set()
    paths = set()
    aliases = set()
    for record in manifest["files"]:
        if record.get("role") != "fixture":
            continue
        digest = record.get("sha256", "")
        ident = record.get("id")
        if len(digest) != 64 or any(c not in "0123456789abcdef" for c in digest) or ident != "fixture-" + digest:
            raise RuntimeError("Invalid content-addressed fixture ID")
        if ident in assets or digest in hashes:
            raise RuntimeError("Duplicate fixture ID or content hash")
        relative = record.get("path", "")
        if not isinstance(relative, str):
            raise RuntimeError("Unsafe shared fixture path")
        path = PurePosixPath(relative)
        if ("\\" in relative or path.is_absolute()
                or not path.parts or path.parts[0] != "fixtures" or len(path.parts) < 2
                or any(part in {".", "..", ""} for part in relative.split("/"))):
            raise RuntimeError("Unsafe shared fixture path")
        resolved = (source / relative).resolve()
        if not resolved.is_relative_to(source.resolve() / "fixtures"):
            raise RuntimeError("Shared fixture path escapes fixtures directory")
        if any((source / PurePosixPath(*path.parts[:i])).is_symlink() for i in range(1, len(path.parts) + 1)):
            raise RuntimeError("Shared fixture paths must not use symlinks")
        if relative in paths:
            raise RuntimeError("Duplicate physical fixture path")
        if not all(isinstance(record.get(k), str) and record[k].strip() for k in ("format", "scenarioGroup")):
            raise RuntimeError("Fixture format and scenario group are required")
        if path.suffix.lower().lstrip(".") != record["format"]:
            raise RuntimeError("Fixture extension disagrees with format metadata")
        if type(record.get("bytes")) is not int or record["bytes"] < 0:
            raise RuntimeError("Invalid fixture byte count")
        if not isinstance(record.get("aliases"), list) or not isinstance(record.get("origins"), list):
            raise RuntimeError("Fixture aliases and provenance are required")
        for alias in record["aliases"]:
            if not isinstance(alias, str) or alias in aliases:
                raise RuntimeError("Duplicate or invalid historical fixture alias")
            aliases.add(alias)
        hashes.add(digest)
        paths.add(relative)
        assets[ident] = record
    if not assets:
        raise RuntimeError("Shared manifest contains no document fixtures")
    return assets


def fixture_path(asset_id, *, source=FIXTURE_SOURCE):
    record = load_fixture_assets(source).get(asset_id)
    if record is None:
        raise RuntimeError("Unknown shared fixture ID: " + asset_id)
    path = source / record["path"]
    data = path.read_bytes()
    if len(data) != record["bytes"] or hashlib.sha256(data).hexdigest() != record["sha256"]:
        raise RuntimeError("Shared fixture bytes differ from manifest: " + asset_id)
    return path


def template_asset_ids():
    mapping = json.loads((REPOSITORY / "tests/fixture-assets.json").read_text())
    if mapping.get("schemaVersion") != 1 or mapping.get("consumer") != "python":
        raise RuntimeError("Invalid Python fixture mapping")
    return mapping["assets"]


def template_fixture(logical_name):
    return fixture_path(template_asset_ids()[logical_name])


def shared_fixture(fixture_id):
    manifest = json.loads((SHARED / "fixture-manifest.json").read_text())
    if manifest.get("schemaVersion") != 2 or manifest.get("pathBase") != "repository-root":
        raise RuntimeError("Expected repository-root shared fixture references")
    records = [r for r in manifest["fixtures"] if r["id"] == fixture_id]
    if len(records) != 1:
        raise RuntimeError("Missing or ambiguous shared fixture identity: " + fixture_id)
    record = records[0]
    path = fixture_path(record["assetId"])
    if path != FIXTURE_SOURCE / record["path"] or record["assetId"] != "fixture-" + record["sha256"]:
        raise RuntimeError("Shared fixture and asset manifest disagree")
    return path


def verify_fixture_source(source, pin):
    """Reject drift in every shared input, including facts outside asset manifests."""
    def git(*args):
        result = subprocess.run(["git", "-C", str(source), *args], text=True, capture_output=True)
        if result.returncode:
            raise RuntimeError("Cannot verify shared fixtures: " + result.stderr.strip())
        return result.stdout.strip()

    if Path(git("rev-parse", "--show-toplevel")).resolve() != source.resolve():
        raise RuntimeError("Shared fixtures must be an initialised Git submodule")
    if git("rev-parse", "HEAD") != pin["commit"]:
        raise RuntimeError("Shared fixture HEAD differs from the consumer pin")
    tag = "refs/tags/" + pin["tag"]
    if git("cat-file", "-t", tag) != "tag":
        raise RuntimeError("Shared fixture release must have an annotated tag")
    if git("rev-parse", tag + "^{commit}") != pin["commit"]:
        raise RuntimeError("Shared fixture tag differs from the consumer pin")
    if git("status", "--porcelain", "--untracked-files=all", "--ignore-submodules=none"):
        raise RuntimeError("Shared fixture checkout is dirty; restore the pinned release before testing")
    for relative, expected in (("manifest.json", pin["manifestSha256"]),
                               ("shared/v2/pack/pack-manifest.json", pin["sharedPackManifestSha256"])):
        if hashlib.sha256((source / relative).read_bytes()).hexdigest() != expected:
            raise RuntimeError("Shared fixture seal mismatch: " + relative)


def require_fixtures():
    required = [FIXTURE_SOURCE / "manifest.json", SHARED / "pack-manifest.json", FEATURE]
    missing = [str(path.relative_to(REPOSITORY)) for path in required if not path.is_file()]
    if missing:
        raise RuntimeError("Shared fixtures are missing; run git submodule update --init --recursive. "
                           "Missing: " + ", ".join(missing))
    verify_fixture_source(FIXTURE_SOURCE, json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text()))
    for asset_id in template_asset_ids().values():
        fixture_path(asset_id)
    for record in json.loads((SHARED / "fixture-manifest.json").read_text())["fixtures"]:
        shared_fixture(record["id"])
