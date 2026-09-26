"""Read-only paths into the shared fixture submodule; never generate inputs there."""

from pathlib import Path

REPOSITORY = Path(__file__).resolve().parents[1]
FIXTURE_SOURCE = REPOSITORY / "references" / "fixtures-ooxml"
TEMPLATES = FIXTURE_SOURCE / "fixtures" / "python-office-mcp-server" / "tests" / "_templates"
SHARED = FIXTURE_SOURCE / "shared" / "v2" / "pack"
FEATURE = SHARED / "features" / "mutation-safety.feature"


def require_fixtures():
    required = [FIXTURE_SOURCE / "manifest.json", TEMPLATES / "default.docx",
                TEMPLATES / "default.pptx", SHARED / "pack-manifest.json", FEATURE]
    missing = [str(path.relative_to(REPOSITORY)) for path in required if not path.is_file()]
    if missing:
        raise RuntimeError("Shared fixtures are missing; run git submodule update --init --recursive. "
                           "Missing: " + ", ".join(missing))
