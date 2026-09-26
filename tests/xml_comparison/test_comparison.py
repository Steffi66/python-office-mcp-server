"""Explicit step binding over official Gherkin pickles; no local feature copy."""

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
                pair["result"] = equivalent_xml(pair["left"], pair["right"])
                case["observedBoolean"] = pair["result"]
            elif step["type"] == "Outcome" and text in {"the comparison result is true", "the comparison result is false"}:
                assert type(pair["result"]) is bool
                assert pair["result"] is text.endswith(" true")
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
