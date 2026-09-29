"""Fresh per-step evidence for the bounded XML entity-value case."""

import hashlib
import json
import subprocess
from importlib.metadata import version

import pytest

from tests.acceptance.ledger import Ledger
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY
from tests.xml_entity_values.cases import FEATURE, load_cases


def pytest_configure(config):
    ledger = Ledger(REPOSITORY / "test-results/xml-entity-values.json")
    config._xml_entity_ledger = ledger
    try:
        ledger.report["inventory"] = load_cases()
        ledger.report["consumer"] = "python"
        ledger.report["executionScope"] = "one XML entity-value decode through XLSX preservation parser; no general parser, DTD, package or Office claim"
        ledger.report["fixturePin"] = json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text())
        ledger.report["fixtureSourceCommit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=FIXTURE_SOURCE, text=True).strip()
        ledger.report["fixtureSourceStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=FIXTURE_SOURCE, text=True).splitlines()
        ledger.report["commit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPOSITORY, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(["git", "diff", "HEAD"], cwd=REPOSITORY)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=REPOSITORY, text=True).splitlines()
        ledger.report["featureSha256"] = hashlib.sha256((FIXTURE_SOURCE / FEATURE).read_bytes()).hexdigest()
        ledger.report["implementationFileHashes"] = {
            path.relative_to(REPOSITORY).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [*(REPOSITORY / "tests/xml_entity_values").glob("*.py"),
                         REPOSITORY / "tests/acceptance/ledger.py", REPOSITORY / "tests/fixture_paths.py",
                         REPOSITORY / "tools/xlsx_preservation.py"]
        }
        ledger.report["dependencies"] = {name: version(name) for name in ["pytest", "gherkin-official", "lxml"]}
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_generate_tests(metafunc):
    if "entity_case" in metafunc.fixturenames:
        cases = metafunc.config._xml_entity_ledger.report["inventory"]
        metafunc.parametrize("entity_case", cases, ids=[case["name"] for case in cases])


def pytest_sessionfinish(session, exitstatus):
    ledger = session.config._xml_entity_ledger
    ledger.finish(exitstatus)
    if exitstatus == 0 and ledger.report["outcome"] != "passed":
        session.exitstatus = pytest.ExitCode.TESTS_FAILED
