"""One pinned existing-thread inspection with independent XML and byte custody."""

import zipfile

from lxml import etree

from tests.docx_comment_inspection.cases import CASE_KEY
from tests.fixture_paths import fixture_path
from tools.word_tools import WordTools

FIXTURE_ID = "fixture-ccdfb41723d543a8baf3444b16c3f8fa7d8473aead590e13825042ba6119da62"
W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
W14 = "http://schemas.microsoft.com/office/word/2010/wordml"
W15 = "http://schemas.microsoft.com/office/word/2012/wordml"
EXPECTED = (
    ("0", "This is a great opening", "103008CD", None),
    ("1", "Classical hubris", "3395B541", None),
    ("2", "(this is a threaded reply)", "0E00AF3F", "1"),
)


def archive_parts(path):
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names)) == 21
        parts = {name: archive.read(name) for name in names}
    assert {"word/comments.xml", "word/commentsIds.xml", "word/commentsExtended.xml"} <= set(parts)
    return names, parts


def raw_comments(parts):
    """Build an oracle from three XML parts, without the production thread helper."""
    root = etree.fromstring(parts["word/comments.xml"])
    ids_root = etree.fromstring(parts["word/commentsIds.xml"])
    ext_root = etree.fromstring(parts["word/commentsExtended.xml"])
    assert root.tag == f"{{{W}}}comments"
    assert len(ids_root) == len(ext_root) == 3
    para_to_id = {}
    rows = []
    for comment in root:
        assert comment.tag == f"{{{W}}}comment"
        paragraphs = comment.findall(f"{{{W}}}p")
        assert len(paragraphs) == 1
        para_id = paragraphs[0].get(f"{{{W14}}}paraId")
        cid = comment.get(f"{{{W}}}id")
        assert cid not in {row[0] for row in rows} and para_id not in para_to_id
        para_to_id[para_id] = cid
        body = "".join(text.text or "" for text in comment.iter(f"{{{W}}}t"))
        assert comment.get(f"{{{W}}}author") == "Rui Carmo"
        rows.append((cid, body, para_id, comment.get(f"{{{W}}}date")))
    assert [row[3] for row in rows] == ["2026-03-10T15:24:00Z", "2026-03-10T15:25:00Z", "2026-03-10T15:25:00Z"]
    ids = [entry.get("{http://schemas.microsoft.com/office/word/2016/wordml/cid}paraId") for entry in ids_root]
    assert ids == [row[2] for row in rows]
    parents = {}
    for entry in ext_root:
        para_id = entry.get(f"{{{W15}}}paraId")
        assert para_id in para_to_id and para_id not in parents
        parent_para = entry.get(f"{{{W15}}}paraIdParent")
        assert parent_para is None or parent_para in para_to_id
        assert entry.get(f"{{{W15}}}done") == "0"
        parents[para_id] = para_to_id[parent_para] if parent_para else None
    assert len(parents) == 3
    return tuple((cid, text, para_id, parents[para_id]) for cid, text, para_id, _ in rows)


def observed_rows(result):
    assert result["comment_count"] == 3 and result["thread_count"] == 2
    flat = result["flat"]
    assert len(flat) == 3 and result["comments"] == flat
    assert [comment["author"] for comment in flat] == ["Rui Carmo"] * 3
    assert [comment["done"] for comment in flat] == [False] * 3
    assert [comment["date"] for comment in flat] == ["2026-03-10 15:24", "2026-03-10 15:25", "2026-03-10 15:25"]
    return tuple((comment["id"], comment["text"], comment["para_id"], comment["parent_id"])
                 for comment in flat)


def assert_threads(result):
    threads = result["threads"]
    assert [thread["root"]["id"] for thread in threads] == ["0", "1"]
    assert [thread["root"]["parent_id"] for thread in threads] == [None, None]
    assert [[reply["id"] for reply in thread["replies"]] for thread in threads] == [[], ["2"]]
    assert threads[1]["replies"][0]["parent_id"] == "1"
    assert threads[1]["replies"][0]["text"] == EXPECTED[2][1]


def test_canonical_pinned_comment_inspection(comment_case, tmp_path, request):
    case = comment_case
    assert case["stableCaseKey"] == CASE_KEY
    ledger = request.config._docx_comment_inspection_ledger
    case.update(outcome="running", nodeid=request.node.nodeid)
    ledger.write()
    source = tmp_path / "comments.docx"
    original_bytes = None
    original_names = original_parts = reference_rows = inspected = repeated = None
    for index, step in enumerate(case["steps"]):
        try:
            if index == 0:
                sealed = fixture_path(FIXTURE_ID)
                source.write_bytes(sealed.read_bytes())  # Caller-owned copy; leave the shared fixture alone.
                original_bytes = source.read_bytes()
                assert len(original_bytes) == 31618 and original_bytes == sealed.read_bytes()
                original_names, original_parts = archive_parts(source)
                reference_rows = raw_comments(original_parts)
                assert reference_rows == EXPECTED  # Reviewed contract and raw OOXML agree.
                case["sourceProfile"] = {"sealedFixtureId": FIXTURE_ID, "bytes": len(original_bytes),
                                         "members": len(original_names), "ids": [row[0] for row in reference_rows]}
            elif index == 1:
                api = WordTools()
                inspected = api.tool_word_get_comments(str(source), format="threaded")
                repeated = api.tool_word_get_comments(str(source), format="threaded")
                assert "error" not in inspected and "error" not in repeated
                assert inspected == repeated and inspected["file"] == source.name
                assert inspected["filter"] == "all"
            elif index == 2:
                assert observed_rows(inspected) == observed_rows(repeated) == reference_rows == EXPECTED
                assert_threads(inspected)
                assert_threads(repeated)
                assert [c["is_reply"] for c in inspected["flat"]] == [False, False, True]
                check_wrong_body_and_parent(tmp_path, original_names, original_parts)
                case["observedComments"] = {"ids": [row[0] for row in reference_rows],
                                             "bodies": [row[1] for row in reference_rows],
                                             "reply2Parent": "1", "roots": ["0", "1"],
                                             "replyGroups": [[], ["2"]]}
            else:
                assert source.read_bytes() == original_bytes
                actual_names, actual_parts = archive_parts(source)
                assert actual_names == original_names and actual_parts == original_parts
                assert raw_comments(actual_parts) == reference_rows
                assert fixture_path(FIXTURE_ID).read_bytes() == original_bytes
                case["observedCustody"] = {"sourceBytesIdentical": True, "membersIdentical": True,
                                           "memberCount": len(actual_names), "repeatReadIdentical": True}
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


def check_wrong_body_and_parent(tmp_path, original_names, original_parts):
    sealed = fixture_path(FIXTURE_ID)
    with zipfile.ZipFile(sealed) as archive:
        entries = [(info, archive.read(info)) for info in archive.infolist()]
    assert [info.filename for info, _ in entries] == original_names
    assert {info.filename: data for info, data in entries} == original_parts
    api = WordTools()
    for altered_part, old, new, expected_text, expected_parent in (
        ("word/comments.xml", b"(this is a threaded reply)", b"(changed threaded reply)",
         "(changed threaded reply)", "1"),
        ("word/commentsExtended.xml", b'paraIdParent="3395B541"', b'paraIdParent="103008CD"',
         EXPECTED[2][1], "0"),
    ):
        output = tmp_path / ("changed-body.docx" if altered_part == "word/comments.xml" else "changed-parent.docx")
        with zipfile.ZipFile(output, "w") as archive:
            for info, data in entries:
                if info.filename == altered_part:
                    assert data.count(old) == 1
                    data = data.replace(old, new)
                archive.writestr(info, data)
        _, altered = archive_parts(output)
        assert {name for name in altered if altered[name] != original_parts[name]} == {altered_part}
        result = api.tool_word_get_comments(str(output), format="threaded")
        assert observed_rows(result)[2][1] == expected_text
        assert observed_rows(result)[2][3] == expected_parent
        if expected_parent == "0":
            assert [[c["id"] for c in thread["replies"]] for thread in result["threads"]] == [["2"], []]
        else:
            assert [[c["id"] for c in thread["replies"]] for thread in result["threads"]] == [[], ["2"]]
    assert sealed.read_bytes() == fixture_path(FIXTURE_ID).read_bytes()
