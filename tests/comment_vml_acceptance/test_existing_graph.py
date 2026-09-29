"""Execute the seven sealed steps against a namespace-aware read-only inspector."""

from tests.comment_vml_acceptance.cases import CASE_KEY, FIXTURE_ID
from tests.fixture_paths import fixture_path
from tools.xlsx_comment_vml import inspect_existing_comment_graph


EXPECTED = {
    "legacy_id": "anysvml",
    "vml_type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing",
    "vml_target": "xl/drawings/commentsDrawing1.vml",
    "comments_target": "xl/comments/comment1.xml",
    "comments": {
        "A2": "This is the protagonist who creates the creature.",
        "A3": "Often mistakenly called 'Frankenstein' - that is the creator's name.",
    },
}


def test_existing_comment_vml_graph(comment_vml_case, request):
    case = comment_vml_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._comment_vml_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = before = graph = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                source = fixture_path(FIXTURE_ID)
                before = source.read_bytes()
            elif index == 1:
                graph = inspect_existing_comment_graph(source)
                assert source.read_bytes() == before  # Read-only custody, independent of result.
                case["observedGraph"] = graph
            elif index == 2:
                assert graph["legacy_id"] == EXPECTED["legacy_id"]
                assert graph["vml_target"] == EXPECTED["vml_target"]
            elif index == 3:
                assert graph["vml_type"] == EXPECTED["vml_type"]
            elif index == 4:
                assert graph["comments_target"] == EXPECTED["comments_target"]
                assert graph["comments_target"] != graph["vml_target"]
            elif index == 5:
                assert graph["comments"]["A2"] == EXPECTED["comments"]["A2"]
            else:
                assert graph["comments"]["A3"] == EXPECTED["comments"]["A3"]
                assert graph["comments"] == EXPECTED["comments"]
                assert source.read_bytes() == before
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
