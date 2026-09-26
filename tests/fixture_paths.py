"""Read-only paths into the shared fixture submodule; never generate inputs there."""

import hashlib
import json
import subprocess
from pathlib import Path

REPOSITORY = Path(__file__).resolve().parents[1]
FIXTURE_SOURCE = REPOSITORY / "references" / "fixtures-ooxml"
TEMPLATES = FIXTURE_SOURCE / "fixtures" / "python-office-mcp-server" / "tests" / "_templates"
SHARED = FIXTURE_SOURCE / "shared" / "v2" / "pack"
FEATURE = SHARED / "features" / "mutation-safety.feature"


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
    required = [FIXTURE_SOURCE / "manifest.json", TEMPLATES / "default.docx",
                TEMPLATES / "default.pptx", SHARED / "pack-manifest.json", FEATURE]
    missing = [str(path.relative_to(REPOSITORY)) for path in required if not path.is_file()]
    if missing:
        raise RuntimeError("Shared fixtures are missing; run git submodule update --init --recursive. "
                           "Missing: " + ", ".join(missing))
    verify_fixture_source(FIXTURE_SOURCE, json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text()))
