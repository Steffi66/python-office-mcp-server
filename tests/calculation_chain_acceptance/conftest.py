"""Independent fail-closed evidence for one owned-chain acceptance case."""

import hashlib
import json
import subprocess
from importlib.metadata import version

import pytest

from tests.acceptance.ledger import Ledger
from tests.calculation_chain_acceptance.cases import FEATURE, load_cases
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY


def pytest_configure(config):
    ledger = Ledger(REPOSITORY / "test-results/calculation-chain-acceptance.json")
    config._chain_ledger = ledger
    try:
        ledger.report["inventory"] = load_cases()
        ledger.report["consumer"] = "python"
        ledger.report["executionScope"] = "one constructed owned nonstandard XLSX calculation-chain invalidation case"
        ledger.report["fixturePin"] = json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text())
        ledger.report["fixtureSourceCommit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=FIXTURE_SOURCE, text=True).strip()
        ledger.report["fixtureSourceStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=FIXTURE_SOURCE, text=True).splitlines()
        ledger.report["commit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPOSITORY, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(["git", "diff", "HEAD"], cwd=REPOSITORY)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=REPOSITORY, text=True).splitlines()
        ledger.report["featureSha256"] = hashlib.sha256((FIXTURE_SOURCE / FEATURE).read_bytes()).hexdigest()
        ledger.report["implementationFileHashes"] = {
            p.relative_to(REPOSITORY).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in [*(REPOSITORY / "tests/calculation_chain_acceptance").glob("*.py"),
                      REPOSITORY / "tests/acceptance/ledger.py", REPOSITORY / "tests/fixture_paths.py",
                      REPOSITORY / "tools/xlsx_preservation.py", REPOSITORY / "tools/save_utils.py",
                      REPOSITORY / "tools/office_unified_tools.py"]
        }
        ledger.report["dependencies"] = {name: version(name) for name in ["pytest", "gherkin-official", "openpyxl", "lxml"]}
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_generate_tests(metafunc):
    if "chain_case" in metafunc.fixturenames:
        metafunc.parametrize("chain_case", metafunc.config._chain_ledger.report["inventory"], ids=["owned-nonstandard-chain"])


def pytest_sessionfinish(session, exitstatus):
    ledger = session.config._chain_ledger
    ledger.finish(exitstatus)
    if exitstatus == 0 and ledger.report["outcome"] != "passed":
        session.exitstatus = pytest.ExitCode.TESTS_FAILED
