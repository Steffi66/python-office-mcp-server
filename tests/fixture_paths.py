"""Read-only paths into the shared fixture submodule; never generate inputs there."""

import hashlib
import json
import os
import stat
import subprocess
from pathlib import Path, PurePosixPath

REPOSITORY = Path(__file__).resolve().parents[1]
FIXTURE_SOURCE = REPOSITORY / "references" / "fixtures-ooxml"
CONTRACT = FIXTURE_SOURCE / "contracts" / "mutation-safety.json"
FEATURE = FIXTURE_SOURCE / "workflows" / "mutation-safety.feature"


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


def verified_metadata(relative, role, *, source=FIXTURE_SOURCE):
    """Read the exact workflow/contract payload sealed by the root manifest."""
    records = json.loads((source / "manifest.json").read_text())["files"]
    matches = [r for r in records if r.get("path") == relative and r.get("role") == role]
    if len(matches) != 1:
        raise RuntimeError("Missing or ambiguous sealed metadata: " + relative)
    data = (source / relative).read_bytes()
    record = matches[0]
    if len(data) != record["bytes"] or hashlib.sha256(data).hexdigest() != record["sha256"]:
        raise RuntimeError("Shared metadata differs from root manifest: " + relative)
    return data


def validate_mutation_contract(contract, assets):
    if (contract.get("schemaVersion") != 1 or contract.get("contractRevision") != "ooxml-shared-contracts-v2"
            or contract.get("feature") != "workflows/mutation-safety.feature"
            or contract.get("fixturePolicy") != {"membership": "exact", "preserve": "all-except-allowed"}):
        raise RuntimeError("Unsupported mutation contract or preservation policy")
    scenario_ids = contract.get("scenarioIds", [])
    if len(scenario_ids) != 8 or len(set(scenario_ids)) != 8 or contract.get("expandedCaseCount") != 19:
        raise RuntimeError("Unexpected mutation scenario inventory")
    fixtures = contract.get("fixtures", [])
    if len(fixtures) != 4 or len({r["id"] for r in fixtures}) != 4:
        raise RuntimeError("Missing or duplicate mutation fixture identities")
    for fixture in fixtures:
        if fixture.get("assetId") not in assets:
            raise RuntimeError("Unknown mutation fixture asset ID")
        members = fixture.get("memberSha256", {})
        allowed = fixture.get("allowedChangedPartsForSuccess", [])
        if not members or len(allowed) != len(set(allowed)) or not set(allowed).issubset(members):
            raise RuntimeError("Invalid mutation member preservation allowance")


def mutation_contract(*, source=FIXTURE_SOURCE):
    contract = json.loads(verified_metadata("contracts/mutation-safety.json", "workflow-contract", source=source))
    verified_metadata("workflows/mutation-safety.feature", "workflow", source=source)
    validate_mutation_contract(contract, load_fixture_assets(source))
    return contract


def preserved_members(fixture):
    """Derive the complete unchanged set rather than storing a second hash map."""
    return {name: digest for name, digest in fixture["memberSha256"].items()
            if name not in fixture["allowedChangedPartsForSuccess"]}


def shared_fixture(fixture_id):
    records = [r for r in mutation_contract()["fixtures"] if r["id"] == fixture_id]
    if len(records) != 1:
        raise RuntimeError("Missing or ambiguous shared fixture identity: " + fixture_id)
    return fixture_path(records[0]["assetId"])


def _verify_tracked_payloads(source, commit, git_bytes):
    """Compare disk bytes/modes with committed blobs, never index stat-cache hints."""
    root = source.resolve()
    if source.is_symlink():
        raise RuntimeError("Shared fixture checkout root must not be a symlink")
    object_format = git_bytes("rev-parse", "--show-object-format").decode().strip()
    if object_format not in {"sha1", "sha256"}:
        raise RuntimeError("Unsupported shared fixture Git object format")
    for entry in git_bytes("ls-tree", "-r", "-z", "--full-tree", commit).split(b"\x00"):
        if not entry:
            continue
        header, raw_name = entry.split(b"\t", 1)
        mode, kind, object_id = header.decode().split()
        name = os.fsdecode(raw_name)
        relative = PurePosixPath(name)
        if (kind != "blob" or mode not in {"100644", "100755"} or relative.is_absolute()
                or any(part in {"", ".", ".."} for part in name.split("/"))):
            raise RuntimeError("Unsupported tracked fixture entry: " + name)
        path = root
        try:
            for index, part in enumerate(relative.parts):
                path = path / part
                info = path.lstat()
                if stat.S_ISLNK(info.st_mode):
                    raise RuntimeError("Tracked fixture symlink is forbidden: " + name)
                if index < len(relative.parts) - 1 and not stat.S_ISDIR(info.st_mode):
                    raise RuntimeError("Tracked fixture parent is not a directory: " + name)
            if not stat.S_ISREG(info.st_mode) or path.resolve() != root / name:
                raise RuntimeError("Tracked fixture path is not a regular file: " + name)
            # Git records the owner executable bit. Windows lacks POSIX mode semantics.
            actual_mode = "100755" if info.st_mode & stat.S_IXUSR else "100644"
            if os.name != "nt" and actual_mode != mode:
                raise RuntimeError("Tracked fixture executable mode mismatch: " + name)
            fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0))
            with os.fdopen(fd, "rb") as stream:
                opened = os.fstat(stream.fileno())
                def identity(st):
                    return (st.st_dev, st.st_ino, st.st_size, st.st_mtime_ns, st.st_mode)
                if identity(opened) != identity(info):
                    raise RuntimeError("Tracked fixture changed while opening: " + name)
                digest = hashlib.new(object_format)
                digest.update(f"blob {opened.st_size}\0".encode())
                for chunk in iter(lambda: stream.read(1024 * 1024), b""):
                    digest.update(chunk)
                if identity(os.fstat(stream.fileno())) != identity(opened) or identity(path.lstat()) != identity(opened):
                    raise RuntimeError("Tracked fixture changed while reading: " + name)
            if digest.hexdigest() != object_id:
                raise RuntimeError("Tracked fixture blob mismatch: " + name)
        except OSError as exc:
            raise RuntimeError("Cannot verify tracked fixture payload: " + name) from exc


def verify_fixture_source(source, pin):
    """Reject drift in every shared input, including facts outside asset manifests."""
    def git_bytes(*args):
        # status may otherwise refresh/write the index as a side effect of verification.
        result = subprocess.run(["git", "--no-optional-locks", "--no-replace-objects", "-C", str(source), *args], capture_output=True)
        if result.returncode:
            raise RuntimeError("Cannot verify shared fixtures: " + result.stderr.decode(errors="replace").strip())
        return result.stdout

    def git(*args):
        return git_bytes(*args).decode().strip()

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
    _verify_tracked_payloads(source, pin["commit"], git_bytes)
    if hashlib.sha256((source / "manifest.json").read_bytes()).hexdigest() != pin["manifestSha256"]:
        raise RuntimeError("Shared fixture seal mismatch: manifest.json")


def require_fixtures():
    required = [FIXTURE_SOURCE / "manifest.json", CONTRACT, FEATURE]
    missing = [str(path.relative_to(REPOSITORY)) for path in required if not path.is_file()]
    if missing:
        raise RuntimeError("Shared fixtures are missing; run git submodule update --init --recursive. "
                           "Missing: " + ", ".join(missing))
    verify_fixture_source(FIXTURE_SOURCE, json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text()))
    for asset_id in template_asset_ids().values():
        fixture_path(asset_id)
    for record in mutation_contract()["fixtures"]:
        shared_fixture(record["id"])
