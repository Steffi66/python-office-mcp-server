"""Explicit step binding over official Gherkin pickles; no local feature copy."""

import hashlib

from tools.package_preservation import equivalent_xml


def test_canonical_xml_comparison(comparison_case, request):
    case = comparison_case
    ledger = request.config._xml_comparison_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    pair = {}
    for step in case["steps"]:
        text = step["text"]
        try:
            if step["type"] == "Context" and text.startswith("the left XML is "):
                pair["left"] = text.removeprefix("the left XML is ").encode("utf-8")
            elif step["type"] == "Context" and text.startswith("the right XML is "):
                pair["right"] = text.removeprefix("the right XML is ").encode("utf-8")
            elif step["type"] == "Action" and text == "the conservative XML comparator compares their UTF-8 bytes":
                before = {side: memoryview(pair[side]).tobytes() for side in ("left", "right")}
                pair["result"] = equivalent_xml(pair["left"], pair["right"])
                case["observedBoolean"] = pair["result"]
                after = {side: memoryview(pair[side]).tobytes() for side in ("left", "right")}
                case["operandCustody"] = {
                    f"{side}Unchanged": before[side] == after[side] for side in ("left", "right")
                }
                case["operandBytes"] = {
                    side: {"beforeLength": len(before[side]), "afterLength": len(after[side]),
                           "beforeSha256": hashlib.sha256(before[side]).hexdigest(),
                           "afterSha256": hashlib.sha256(after[side]).hexdigest()}
                    for side in ("left", "right")
                }
            elif step["type"] == "Outcome" and text in {"the comparison result is true", "the comparison result is false"}:
                assert type(pair["result"]) is bool
                assert pair["result"] is text.endswith(" true")
                assert case["operandCustody"] == {"leftUnchanged": True, "rightUnchanged": True}
            else:
                raise AssertionError("Unbound canonical XML step: " + text)
            step["outcome"] = "passed"
        except BaseException as exc:
            step.update(outcome="failed", error=str(exc))
            case["outcome"] = "failed"
            for following in case["steps"]:
                if following["outcome"] == "not-run":
                    following["outcome"] = "skipped"
            ledger.write()
            raise
        ledger.write()
    case["outcome"] = "passed"
    ledger.write()
