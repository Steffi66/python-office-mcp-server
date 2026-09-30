"""Per-step provenance for one authored reply auto-resolve case."""

import hashlib
import json
import subprocess
from importlib.metadata import version

import pytest

from tests.acceptance.ledger import Ledger
from tests.fixture_paths import FIXTURE_SOURCE, REPOSITORY
from tests.docx_comments_reply_auto_resolve.cases import FEATURE, load_cases


def pytest_configure(config):
    ledger = Ledger(REPOSITORY / "test-results/docx-comments-reply-auto-resolve.json")
    config._docx_comments_reply_auto_resolve_ledger = ledger
    try:
        ledger.report["inventory"] = load_cases()
        ledger.report["consumer"] = "python"
        ledger.report["executionScope"] = ("one saved authored reply auto-resolve case; "
                                           "not complete-thread editing, general reply targeting, existing-extension refusal or general DOCX credit")
        ledger.report["fixturePin"] = json.loads((REPOSITORY / "tests/fixtures-pin.json").read_text())
        ledger.report["fixtureSourceCommit"] = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=FIXTURE_SOURCE, text=True).strip()
        ledger.report["fixtureSourceStatus"] = subprocess.check_output(
            ["git", "status", "--porcelain"], cwd=FIXTURE_SOURCE, text=True).splitlines()
        ledger.report["commit"] = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=REPOSITORY, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(
            ["git", "diff", "HEAD"], cwd=REPOSITORY)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(
            ["git", "status", "--porcelain"], cwd=REPOSITORY, text=True).splitlines()
        ledger.report["featureSha256"] = hashlib.sha256((FIXTURE_SOURCE / FEATURE).read_bytes()).hexdigest()
        ledger.report["implementationFileHashes"] = {
            path.relative_to(REPOSITORY).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [*(REPOSITORY / "tests/docx_comments_reply_auto_resolve").glob("*.py"),
                         REPOSITORY / "tests/acceptance/ledger.py", REPOSITORY / "tests/fixture_paths.py",
                         REPOSITORY / "tools/word_tools.py", REPOSITORY / "tools/word_advanced_tools.py",
                         REPOSITORY / "tools/mutation.py"]
        }
        ledger.report["dependencies"] = {name: version(name) for name in
                                         ["pytest", "gherkin-official", "lxml", "python-docx"]}
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_generate_tests(metafunc):
    if "reply_auto_resolve_case" in metafunc.fixturenames:
        cases = metafunc.config._docx_comments_reply_auto_resolve_ledger.report["inventory"]
        metafunc.parametrize("reply_auto_resolve_case", cases, ids=[case["name"] for case in cases])


def pytest_sessionfinish(session, exitstatus):
    ledger = session.config._docx_comments_reply_auto_resolve_ledger
    ledger.finish(exitstatus)
    if exitstatus == 0 and ledger.report["outcome"] != "passed":
        session.exitstatus = pytest.ExitCode.TESTS_FAILED
