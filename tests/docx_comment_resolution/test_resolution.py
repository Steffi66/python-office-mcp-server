"""Sealed root-1 resolve/reopen with independent lexical and package custody."""

from zipfile import ZipFile

from lxml import etree

from tests.docx_comment_resolution.cases import CASE_KEY
from tests.fixture_paths import fixture_path
from tools.word_tools import WordTools

FIXTURE_ID = "fixture-ccdfb41723d543a8baf3444b16c3f8fa7d8473aead590e13825042ba6119da62"
W15 = "{http://schemas.microsoft.com/office/word/2012/wordml}"
ROOT_START = b'<w15:commentEx w15:paraId="3395B541" w15:done="0"/>'


def parts(path):
    with ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names)) == 21
        return {name: archive.read(name) for name in names}


def states(data):
    root = etree.fromstring(data["word/commentsExtended.xml"])
    assert root.tag == W15 + "commentsEx"
    assert len(root) == 3
    rows = [(entry.get(W15 + "paraId"), entry.get(W15 + "done"), entry.get(W15 + "paraIdParent"))
            for entry in root]
    assert [row[0] for row in rows] == ["103008CD", "3395B541", "0E00AF3F"]
    assert [row[2] for row in rows] == [None, None, "3395B541"]
    return [row[1] for row in rows]


def test_canonical_pinned_comment_resolution(resolution_case, tmp_path, request):
    case = resolution_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._docx_comment_resolution_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = tmp_path / "source.docx"
    resolved_path = tmp_path / "resolved.docx"
    reopened_path = tmp_path / "reopened.docx"
    api = WordTools()
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                fixture = fixture_path(FIXTURE_ID)
                source.write_bytes(fixture.read_bytes())
                original = source.read_bytes()
                original_parts = parts(source)
                original_extension = original_parts["word/commentsExtended.xml"]
                assert len(original_extension) == 2824 and original_extension.count(ROOT_START) == 1
                assert states(original_parts) == ["0", "0", "0"]
                assert len(original) == 31618 and original == fixture.read_bytes()
                case["sourceProfile"] = {"fixture": FIXTURE_ID, "bytes": len(original),
                                         "members": len(original_parts), "extensionBytes": len(original_extension)}
            elif index == 1:
                response = api.tool_word_resolve_comment(str(source), "1", True, output_path=str(resolved_path))
                assert response["success"] is True and response["changes_applied"] == 1
                assert response["thread_root_comment_id"] == "1" and response["done"] is True
                assert resolved_path.exists() and source.read_bytes() == original
            elif index == 2:
                resolved_parts = parts(resolved_path)
                assert states(resolved_parts) == ["0", "1", "0"]
                observed = api.tool_word_get_comments(str(resolved_path), format="threaded")
                assert [(c["id"], c["done"], c["parent_id"], c["text"]) for c in observed["flat"]] == [
                    ("0", False, None, "This is a great opening"),
                    ("1", True, None, "Classical hubris"),
                    ("2", False, "1", "(this is a threaded reply)"),
                ]
                assert [[c["id"] for c in t["replies"]] for t in observed["threads"]] == [[], ["2"]]
                assert observed["threads"][1]["root"]["id"] == "1"
            elif index == 3:
                expected = original_extension.replace(ROOT_START, ROOT_START.replace(b'done="0"', b'done="1"'))
                assert len(expected) == len(original_extension) == 2824
                assert resolved_parts["word/commentsExtended.xml"] == expected
                assert {name for name in original_parts if original_parts[name] != resolved_parts[name]} == {
                    "word/commentsExtended.xml"}
                assert source.read_bytes() == original == fixture_path(FIXTURE_ID).read_bytes()
            elif index == 4:
                resolved_archive = resolved_path.read_bytes()
                response = api.tool_word_resolve_comment(str(resolved_path), "1", False,
                                                         output_path=str(reopened_path))
                assert response["success"] is True and response["changes_applied"] == 1
                assert response["thread_root_comment_id"] == "1" and response["done"] is False
                assert resolved_path.read_bytes() == resolved_archive and reopened_path.exists()
            else:
                reopened_parts = parts(reopened_path)
                assert reopened_parts == original_parts and states(reopened_parts) == ["0", "0", "0"]
                assert source.read_bytes() == original == fixture_path(FIXTURE_ID).read_bytes()
                assert resolved_path.read_bytes() == resolved_archive
                case["observedCustody"] = {"sourceBytesIdentical": True, "allReopenedMembersIdentical": True,
                                           "unchangedMembers": 20, "extensionBytesRestored": 2824}
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
