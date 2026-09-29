"""Sealed comment-1 reopen no-op; control mutations have no shared credit."""

from zipfile import ZipFile

from lxml import etree

from tests.docx_comment_noop.cases import CASE_KEY
from tests.fixture_paths import fixture_path
from tools.word_tools import WordTools

FIXTURE_ID = "fixture-ccdfb41723d543a8baf3444b16c3f8fa7d8473aead590e13825042ba6119da62"
W15 = "{http://schemas.microsoft.com/office/word/2012/wordml}"
EXPECTED = [("103008CD", "0", None), ("3395B541", "0", None),
            ("0E00AF3F", "0", "3395B541")]


def inspect(path):
    with ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names)) == 21
        contents = {name: archive.read(name) for name in names}
    extension = contents["word/commentsExtended.xml"]
    root = etree.fromstring(extension)
    assert root.tag == W15 + "commentsEx" and len(root) == 3
    states = [(entry.get(W15 + "paraId"), entry.get(W15 + "done"), entry.get(W15 + "paraIdParent"))
              for entry in root]
    return names, contents, states


def test_canonical_pinned_comment_noop(noop_case, tmp_path, request):
    case = noop_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._docx_comment_noop_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    caller = tmp_path / "caller.docx"
    api = WordTools()
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                sealed = fixture_path(FIXTURE_ID)
                fixture_bytes = sealed.read_bytes()
                assert len(fixture_bytes) == 31618
                caller.write_bytes(fixture_bytes)
                before = caller.read_bytes()
                names, member_bytes, state = inspect(caller)
                assert before == fixture_bytes and state == EXPECTED
                assert len(member_bytes["word/commentsExtended.xml"]) == 2824
                case["sourceProfile"] = {"fixture": FIXTURE_ID, "bytes": 31618,
                                         "members": 21, "extensionBytes": 2824}
            elif index == 1:
                response = api.tool_word_resolve_comment(str(caller), "1", False)
                assert response["success"] is True and response.get("error") is None
                assert response["unchanged"] is True
                assert response["comment_id"] == response["thread_root_comment_id"] == "1"
                assert response["resolved"] is False and response["done"] is False
                assert response["changes_planned"] == response["changes_applied"] == 0
                assert response["file"] == str(caller)
                assert response.get("package_diff") is None
                case["observedResponse"] = {"success": True, "unchanged": True,
                                            "changesPlanned": 0, "changesApplied": 0,
                                            "rootCommentId": "1", "done": False}
            else:
                after_names, after_members, after_state = inspect(caller)
                assert after_names == names and after_members == member_bytes and after_state == state
                assert caller.read_bytes() == before == fixture_bytes == sealed.read_bytes()
                assert not list(tmp_path.glob(".office-patch-*"))
                assert not list(tmp_path.glob("tmp*.docx"))
                sensitivity_controls(tmp_path, api, before, member_bytes)
                assert caller.read_bytes() == before and sealed.read_bytes() == fixture_bytes
                case["observedCustody"] = {"wholeArchiveExact": True, "all21MembersExact": True,
                                           "extension2824Exact": True, "fixtureExact": True,
                                           "stageClean": True}
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


def sensitivity_controls(tmp_path, api, original, original_members):
    """Show wrong state/root alters the package; distinct-output no-ops refuse."""
    for comment_id, expected in (("1", ["0", "1", "0"]), ("0", ["1", "0", "0"])):
        source = tmp_path / f"control-{comment_id}.docx"
        destination = tmp_path / f"changed-{comment_id}.docx"
        source.write_bytes(original)
        response = api.tool_word_resolve_comment(str(source), comment_id, True,
                                                 output_path=str(destination))
        assert response["success"] is True and response["changes_applied"] == 1
        _, contents, state = inspect(destination)
        assert [row[1] for row in state] == expected
        assert {name for name, value in original_members.items() if contents[name] != value} == {
            "word/commentsExtended.xml"}
        assert source.read_bytes() == original
    source = tmp_path / "distinct-source.docx"
    source.write_bytes(original)
    missing = tmp_path / "no-output.docx"
    response = api.tool_word_resolve_comment(str(source), "1", False, output_path=str(missing))
    assert response["success"] is False and response["changes_planned"] == response["changes_applied"] == 0
    assert response["error"] == "No-op comment resolution cannot publish a distinct output_path"
    assert not missing.exists() and source.read_bytes() == original
    prior = tmp_path / "prior.docx"
    prior.write_bytes(b"prior destination")
    response = api.tool_word_resolve_comment(str(source), "1", False, output_path=str(prior))
    assert response["success"] is False and response["changes_planned"] == response["changes_applied"] == 0
    assert response["error"] == "No-op comment resolution cannot publish a distinct output_path"
    assert prior.read_bytes() == b"prior destination" and source.read_bytes() == original
    assert not list(tmp_path.glob(".office-patch-*"))
    assert not list(tmp_path.glob("tmp*.docx"))
