"""Fresh two-case evidence independent of the fourteen-case package lane."""

import hashlib
import json
import subprocess
from importlib.metadata import version

import pytest

from tests.acceptance.ledger import Ledger
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY
from tests.package_limit_configuration.cases import FEATURE, IMPLEMENTATION, load_cases


def pytest_configure(config):
    ledger = Ledger(REPOSITORY / "test-results/package-limit-configuration.json")
    config._package_limit_ledger = ledger
    try:
        ledger.report["inventory"] = load_cases()
        ledger.report["consumer"] = "python"
        ledger.report["executionScope"] = "two direct invalid-budget package admission cases only; no editing session or ZIP overlap case"
        ledger.report["fixturePin"] = json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text())
        ledger.report["fixtureSourceCommit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=FIXTURE_SOURCE, text=True).strip()
        ledger.report["fixtureSourceStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=FIXTURE_SOURCE, text=True).splitlines()
        ledger.report["commit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPOSITORY, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(["git", "diff", "HEAD"], cwd=REPOSITORY)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=REPOSITORY, text=True).splitlines()
        ledger.report["featureSha256"] = hashlib.sha256((FIXTURE_SOURCE / FEATURE).read_bytes()).hexdigest()
        ledger.report["implementationFileHashes"] = {
            path.relative_to(REPOSITORY).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [*(REPOSITORY / "tests/package_limit_configuration").glob("*.py"),
                         REPOSITORY / "tests/acceptance/ledger.py", REPOSITORY / "tests/fixture_paths.py", IMPLEMENTATION]
        }
        ledger.report["dependencies"] = {name: version(name) for name in ["pytest", "gherkin-official"]}
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_generate_tests(metafunc):
    if "budget_case" in metafunc.fixturenames:
        cases = metafunc.config._package_limit_ledger.report["inventory"]
        metafunc.parametrize("budget_case", cases, ids=[c["examples"]["budget"] for c in cases])


def pytest_sessionfinish(session, exitstatus):
    ledger = session.config._package_limit_ledger
    ledger.finish(exitstatus)
    if exitstatus == 0 and ledger.report["outcome"] != "passed":
        session.exitstatus = pytest.ExitCode.TESTS_FAILED
