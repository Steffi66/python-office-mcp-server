"""Fresh per-step evidence for the bounded fourteen-case package lane."""

import hashlib
import json
import subprocess
from importlib.metadata import version

import pytest

from tests.acceptance.ledger import Ledger
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY
from tests.package_admission.cases import IMPLEMENTATIONS, MAPPING, NATIVE, load_cases


def pytest_configure(config):
    ledger = Ledger(REPOSITORY / "test-results/package-admission.json")
    config._package_admission_ledger = ledger
    try:
        ledger.report["inventory"] = load_cases()
        ledger.report["consumer"] = "python"
        ledger.report["executionScope"] = "fourteen ZIP/XML admission and semantic package diff cases only"
        ledger.report["fixturePin"] = json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text())
        ledger.report["fixtureSourceCommit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=FIXTURE_SOURCE, text=True).strip()
        ledger.report["fixtureSourceStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=FIXTURE_SOURCE, text=True).splitlines()
        ledger.report["commit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPOSITORY, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(["git", "diff", "HEAD"], cwd=REPOSITORY)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=REPOSITORY, text=True).splitlines()
        ledger.report["implementationFileHashes"] = {
            path.relative_to(REPOSITORY).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [*(REPOSITORY / "tests/package_admission").glob("*.py"),
                         REPOSITORY / "tests/acceptance/ledger.py", REPOSITORY / "tests/fixture_paths.py",
                         REPOSITORY / NATIVE, *(REPOSITORY / name for name in IMPLEMENTATIONS)]
        }
        ledger.report["nativeMappingSha256"] = hashlib.sha256(MAPPING.read_bytes()).hexdigest()
        ledger.report["dependencies"] = {name: version(name) for name in ["lxml", "pytest", "gherkin-official"]}
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_generate_tests(metafunc):
    if "package_case" in metafunc.fixturenames:
        cases = metafunc.config._package_admission_ledger.report["inventory"]
        metafunc.parametrize("package_case", cases, ids=[c["name"] for c in cases])


def pytest_sessionfinish(session, exitstatus):
    ledger = session.config._package_admission_ledger
    ledger.finish(exitstatus)
    if exitstatus == 0 and ledger.report["outcome"] != "passed":
        session.exitstatus = pytest.ExitCode.TESTS_FAILED
