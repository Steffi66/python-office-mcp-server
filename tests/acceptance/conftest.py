"""Acceptance evidence is reset before collection and updated after every BDD step."""

import hashlib
import shutil
import subprocess
from importlib.metadata import version
from pathlib import Path

import pytest

from .ledger import Ledger, binding_matches, inventory

HERE = Path(__file__).parent
ROOT = HERE.parents[1]


def pytest_configure(config):
    ledger = Ledger(ROOT / "test-results" / "acceptance.json")
    config._office_ledger = ledger
    try:
        ledger.report["inventory"] = inventory(sorted((HERE / "features").glob("*.feature")))
        for case in ledger.report["inventory"]:
            config.addinivalue_line("markers", case["scenarioId"][1:] + ": shared contract identity")
        ledger.report["commit"] = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
        ledger.report["workingDiffSha256"] = hashlib.sha256(subprocess.check_output(["git", "diff", "HEAD"], cwd=ROOT)).hexdigest()
        ledger.report["workingStatus"] = subprocess.check_output(["git", "status", "--porcelain"], cwd=ROOT, text=True).splitlines()
        ledger.report["implementationFileHashes"] = {
            str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
            for directory in (ROOT / "tools", HERE)
            for path in sorted(directory.rglob("*.py"))
        }
        ledger.report["dependencies"] = {n: version(n) for n in ("python-docx", "python-pptx", "openpyxl", "pytest-bdd", "gherkin-official")}
        manifest = HERE.parent / "contracts/shared/fixture-manifest.json"
        ledger.report["fixtureManifestSha256"] = hashlib.sha256(manifest.read_bytes()).hexdigest()
        ledger.write()
    except Exception as exc:
        ledger.report["failures"].append(str(exc))
        ledger.finish(1)
        raise


def pytest_bdd_before_scenario(request, feature, scenario):
    ledger = request.config._office_ledger
    case = next(c for c in ledger.report["inventory"] if c["name"] == scenario.name)
    if case["outcome"] == "planned":
        pytest.skip("Planned contract; not an execution pass")
    request.node._office_case = case
    case["nodeid"] = request.node.nodeid
    case["outcome"] = "running"
    ledger.write()


def pytest_bdd_before_step(request, feature, scenario, step):
    case = request.node._office_case
    index = next(i for i, s in enumerate(scenario.steps) if s is step)
    request.node._office_step = index
    contexts = []
    seen = set()
    for name, definitions in request._fixturemanager._arg2fixturedefs.items():
        if not name.startswith("pytestbdd_stepdef_"):
            continue
        for definition in definitions:
            context = getattr(definition.func, "_pytest_bdd_step_context", None)
            if context is not None and id(context) not in seen:
                seen.add(id(context))
                contexts.append(context)
    matches = binding_matches(step, contexts)
    if len(matches) != 1:
        outcome = "undefined" if not matches else "ambiguous"
        case["steps"][index]["outcome"] = outcome
        case["outcome"] = "failed"
        request.config._office_ledger.write()
        raise AssertionError(f"{outcome} step: {step.name}")


def pytest_bdd_after_step(request, feature, scenario, step, step_func, step_func_args):
    request.node._office_case["steps"][request.node._office_step]["outcome"] = "passed"
    request.config._office_ledger.write()


def pytest_bdd_step_error(request, feature, scenario, step, step_func, step_func_args, exception):
    case = request.node._office_case
    row = case["steps"][request.node._office_step]
    row.update(outcome="failed", error=str(exception))
    case["outcome"] = "failed"
    request.config._office_ledger.write()


def pytest_bdd_step_func_lookup_error(request, feature, scenario, step, exception):
    case = request.node._office_case
    case["outcome"] = "failed"
    request.config._office_ledger.report["failures"].append(str(exception))
    request.config._office_ledger.write()


def pytest_bdd_after_scenario(request, feature, scenario):
    case = getattr(request.node, "_office_case", None)
    if case is None:
        return
    passed = all(s["outcome"] == "passed" for s in case["steps"])
    case["outcome"] = "passed" if passed else "failed"
    for step in case["steps"]:
        if step["outcome"] == "not-run":
            step["outcome"] = "skipped"
    ctx = request.getfixturevalue("ctx")
    case["request"] = ctx.get("request")
    case["response"] = ctx.get("result")
    if not passed:
        target = ROOT / "test-results" / "acceptance-failures" / hashlib.sha256(case["stableCaseKey"].encode()).hexdigest()[:12]
        target.mkdir(parents=True, exist_ok=True)
        for path in ctx["root"].iterdir():
            if path.is_file():
                shutil.copy2(path, target / path.name)
        case["artifactDirectory"] = str(target)
    request.config._office_ledger.write()


def pytest_sessionfinish(session, exitstatus):
    ledger = getattr(session.config, "_office_ledger", None)
    if ledger is not None:
        ledger.finish(exitstatus)
        if exitstatus == 0 and ledger.report["outcome"] != "passed":
            session.exitstatus = pytest.ExitCode.TESTS_FAILED
