"""Refusals, no-op and write-fault custody for existing extension only."""

import shutil
from zipfile import ZipFile

import pytest
from lxml import etree

from tests.docx_comment_resolution.test_resolution import FIXTURE_ID, ROOT_START, W15, parts, states
from tests.fixture_paths import fixture_path
from tools.word_tools import WordTools


def prepared(tmp_path, name="source.docx"):
    source = tmp_path / name
    source.write_bytes(fixture_path(FIXTURE_ID).read_bytes())
    return source


def mutated(tmp_path, changed, part="word/commentsExtended.xml"):
    source = prepared(tmp_path)
    output = tmp_path / "mutated.docx"
    with ZipFile(source) as archive, ZipFile(output, "w") as result:
        for info in archive.infolist():
            raw = archive.read(info)
            result.writestr(info, changed(raw) if info.filename == part else raw)
    assert output.read_bytes() != source.read_bytes()
    return output


def replace_unique(old, new):
    def mutate(raw):
        assert raw.count(old) == 1
        return raw.replace(old, new)
    return mutate


@pytest.mark.parametrize("defect,part,mutation", [
    ("missing-root-entry", "word/commentsExtended.xml", replace_unique(ROOT_START, b"")),
    ("duplicate-root-entry", "word/commentsExtended.xml", replace_unique(ROOT_START, ROOT_START + ROOT_START)),
    ("invalid-done", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START.replace(b'done="0"', b'done="maybe"'))),
    ("absent-done", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START.replace(b' w15:done="0"', b''))),
    ("wrong-namespace-done", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START.replace(b'w15:done', b'done'))),
    ("aliased-other-namespace-done", "word/commentsExtended.xml",
     replace_unique(ROOT_START, b'<w15:commentEx xmlns:other="urn:other" w15:paraId="3395B541" other:done="0"/>')),
    ("aliased-other-namespace-para", "word/commentsExtended.xml",
     replace_unique(ROOT_START, b'<w15:commentEx xmlns:other="urn:other" other:paraId="3395B541" w15:done="0"/>')),
    ("ambiguous-local-done", "word/commentsExtended.xml",
     replace_unique(ROOT_START, b'<w15:commentEx xmlns:other="urn:other" w15:paraId="3395B541" other:done="0" w15:done="0"/>')),
    ("invalid-reply-done", "word/commentsExtended.xml",
     replace_unique(b'<w15:commentEx w15:paraId="0E00AF3F" w15:paraIdParent="3395B541" w15:done="0"/>',
                    b'<w15:commentEx w15:paraId="0E00AF3F" w15:paraIdParent="3395B541" w15:done="maybe"/>')),
    ("duplicate-para", "word/commentsExtended.xml",
     replace_unique(b'paraId="0E00AF3F"', b'paraId="3395B541"')),
    ("orphan-entry", "word/commentsExtended.xml",
     replace_unique(b'paraId="0E00AF3F"', b'paraId="DEADBEEF"')),
    ("missing-parent", "word/commentsExtended.xml",
     replace_unique(b'paraIdParent="3395B541"', b'paraIdParent="DEADBEEF"')),
    ("duplicate-comment-id", "word/comments.xml", replace_unique(b'w:id="2"', b'w:id="1"')),
    ("duplicate-comment-para", "word/comments.xml",
     replace_unique(b'w14:paraId="0E00AF3F"', b'w14:paraId="3395B541"')),
    ("missing-root-para", "word/comments.xml", replace_unique(b'w14:paraId="3395B541"', b'')),
    ("wrong-root", "word/commentsExtended.xml", replace_unique(b'<w15:commentsEx', b'<w15:elsewhere')),
    ("malformed", "word/commentsExtended.xml", replace_unique(ROOT_START, ROOT_START[:-1])),
    ("nested-entry", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START.replace(b'/>', b'><w15:commentEx/></w15:commentEx>'))),
    ("dtd-entity", "word/commentsExtended.xml",
     replace_unique(b'\r\n<w15:commentsEx', b'\r\n<!DOCTYPE w15:commentsEx [<!ENTITY evil "x">]>\r\n<w15:commentsEx')),
    ("entity-reference", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START.replace(b'done="0"', b'done="&#48;"'))),
    ("utf8-bom", "word/commentsExtended.xml", lambda raw: b'\xef\xbb\xbf' + raw),
    ("utf16", "word/commentsExtended.xml", lambda raw: raw.decode("utf-8").replace(
        'encoding="UTF-8"', 'encoding="UTF-16"').encode("utf-16")),
    ("false-utf16-declaration", "word/commentsExtended.xml",
     replace_unique(b'encoding="UTF-8"', b'encoding="UTF-16"')),
    ("processing-instruction", "word/commentsExtended.xml",
     replace_unique(ROOT_START, b'<?flag x?>' + ROOT_START)),
    ("mixed-content", "word/commentsExtended.xml",
     replace_unique(ROOT_START, ROOT_START + b'unexpected text')),
    ("comments-entity", "word/comments.xml",
     replace_unique(b'Classical hubris', b'Classical &amp; hubris')),
    ("comments-ids-dtd", "word/commentsIds.xml",
     lambda raw: b'<!DOCTYPE w16cid:commentsIds [<!ENTITY e "x">]>' + raw),
])
def test_existing_extension_refuses_unsafe_bytes_and_preserves_dest(tmp_path, defect, part, mutation):
    source = mutated(tmp_path, mutation, part)
    original = source.read_bytes()
    destination = tmp_path / "prior.docx"
    destination.write_bytes(b"prior destination; must not be replaced")
    prior = destination.read_bytes()
    result = WordTools().tool_word_resolve_comment(str(source), "1", True, output_path=str(destination))
    assert result["success"] is False, defect
    assert result["changes_applied"] == 0 and result.get("error"), defect
    assert source.read_bytes() == original and destination.read_bytes() == prior
    assert fixture_path(FIXTURE_ID).read_bytes() == prepared(tmp_path, "comparison.docx").read_bytes()
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))


def test_same_state_distinct_output_refuses_without_creating_or_replacing(tmp_path):
    source = prepared(tmp_path)
    original = source.read_bytes()
    absent = tmp_path / "absent.docx"
    result = WordTools().tool_word_resolve_comment(str(source), "1", False, output_path=str(absent))
    assert result["success"] is False and result["changes_applied"] == 0 and result.get("error")
    assert not absent.exists() and source.read_bytes() == original
    destination = tmp_path / "prior.docx"
    destination.write_bytes(b"prior destination stays intact")
    prior = destination.read_bytes()
    result = WordTools().tool_word_resolve_comment(str(source), "1", False, output_path=str(destination))
    assert result["success"] is False and result["changes_applied"] == 0 and result.get("error")
    assert destination.read_bytes() == prior and source.read_bytes() == original
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))


def test_duplicate_package_member_refuses_without_destination_or_stage_leak(tmp_path):
    source = prepared(tmp_path)
    malformed = tmp_path / "duplicate.docx"
    with ZipFile(source) as original:
        members = [(info, original.read(info)) for info in original.infolist()]
        extension = original.read("word/commentsExtended.xml")
    with ZipFile(malformed, "w") as output:
        for info, data in members:
            output.writestr(info, data)
        output.writestr("word/commentsExtended.xml", extension)
    before = malformed.read_bytes()
    destination = tmp_path / "prior.docx"
    destination.write_bytes(b"prior destination")
    result = WordTools().tool_word_resolve_comment(str(malformed), "1", True,
                                                   output_path=str(destination))
    assert result["success"] is False and result["changes_applied"] == 0 and result.get("error")
    assert malformed.read_bytes() == before and destination.read_bytes() == b"prior destination"
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))


def test_namespace_alias_and_single_quoted_target_preserve_all_other_bytes(tmp_path):
    old = b'<w15:commentEx w15:paraId="3395B541" w15:done="0"/>'
    new = b"<alt:commentEx alt:paraId='3395B541' alt:done='0'/>"
    def alias(raw):
        assert raw.count(old) == 1
        assert raw.count(b'xmlns:w15=') == 1
        return raw.replace(b'xmlns:w15=', b'xmlns:alt="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w15=', 1).replace(old, new)
    source = mutated(tmp_path, alias)
    original = parts(source)
    changed = tmp_path / "changed.docx"
    result = WordTools().tool_word_resolve_comment(str(source), "1", True, output_path=str(changed))
    assert result["success"] is True and result["changes_applied"] == 1
    actual = parts(changed)
    assert states(actual) == ["0", "1", "0"]
    assert actual["word/commentsExtended.xml"] == original["word/commentsExtended.xml"].replace(
        new, new.replace(b"done='0'", b"done='1'"))
    assert {name for name in original if original[name] != actual[name]} == {"word/commentsExtended.xml"}
    assert source.read_bytes() != changed.read_bytes()


@pytest.mark.parametrize("suffix", [b'  />', b' / >', b'\t/>'])
def test_suffix_whitespace_before_empty_close_preserves_lexical_bytes(tmp_path, suffix):
    new = ROOT_START.replace(b'/>', suffix)
    source = mutated(tmp_path, replace_unique(ROOT_START, new))
    original = parts(source)
    changed = tmp_path / "changed.docx"
    result = WordTools().tool_word_resolve_comment(str(source), "1", True, output_path=str(changed))
    if suffix == b' / >':
        assert result["success"] is False and result["changes_applied"] == 0
        assert not changed.exists() and parts(source) == original
    else:
        assert result["success"] is True and result["changes_applied"] == 1
        assert parts(changed)["word/commentsExtended.xml"] == original["word/commentsExtended.xml"].replace(
            new, new.replace(b'done="0"', b'done="1"'))
        assert source.read_bytes() != changed.read_bytes() and states(parts(changed)) == ["0", "1", "0"]
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))


@pytest.mark.parametrize("selected,expected", [
    ("0", ["1", "0", "0"]),
    ("2", ["0", "1", "0"]),
])
def test_selected_root_or_reply_changes_only_its_root(tmp_path, selected, expected):
    source = prepared(tmp_path)
    before = source.read_bytes()
    original = parts(source)
    destination = tmp_path / "selected.docx"
    result = WordTools().tool_word_resolve_comment(str(source), selected, True,
                                                   output_path=str(destination))
    assert result["success"] is True and result["changes_applied"] == 1
    assert result["thread_root_comment_id"] == ("0" if selected == "0" else "1")
    updated = parts(destination)
    assert states(updated) == expected
    assert {name for name in original if updated[name] != original[name]} == {"word/commentsExtended.xml"}
    assert source.read_bytes() == before and not list(tmp_path.glob(".office-patch-*"))


def test_unknown_comment_refuses_before_publication(tmp_path):
    source = prepared(tmp_path)
    original = source.read_bytes()
    destination = tmp_path / "absent.docx"
    result = WordTools().tool_word_resolve_comment(str(source), "not-an-id", True,
                                                   output_path=str(destination))
    assert result["success"] is False and result["changes_applied"] == 0 and result.get("error")
    assert source.read_bytes() == original and not destination.exists()
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))


def test_matching_state_is_exact_archive_noop(tmp_path):
    source = prepared(tmp_path)
    original = source.read_bytes()
    before = parts(source)
    result = WordTools().tool_word_resolve_comment(str(source), "1", False)
    assert result["success"] is True and result["changes_planned"] == result["changes_applied"] == 0
    assert source.read_bytes() == original and parts(source) == before
    resolved = WordTools().tool_word_resolve_comment(str(source), "1", True)
    assert resolved["success"] is True and resolved["changes_applied"] == 1
    done = source.read_bytes()
    repeated = WordTools().tool_word_resolve_comment(str(source), "1", True)
    assert repeated["success"] is True and repeated["changes_planned"] == repeated["changes_applied"] == 0
    assert source.read_bytes() == done


@pytest.mark.parametrize("failure", ["part-write", "publication"])
def test_reached_zip_write_failures_preserve_source_and_destination(tmp_path, monkeypatch, failure):
    source = prepared(tmp_path)
    original = source.read_bytes()
    prior = tmp_path / "prior.docx"
    prior.write_bytes(b"prior destination stays intact")
    untouched = prior.read_bytes()
    reached = []
    if failure == "part-write":
        original_write = ZipFile.writestr
        def fail_extension(self, name, data, *args, **kwargs):
            original_write(self, name, data, *args, **kwargs)
            if name == "word/commentsExtended.xml":
                reached.append(failure)
                raise OSError("injected after extension part write")
        monkeypatch.setattr(ZipFile, "writestr", fail_extension)
    else:
        def fail_move(_source, _destination):
            reached.append(failure)
            raise OSError("injected after zip serialization")
        monkeypatch.setattr(shutil, "move", fail_move)
    result = WordTools().tool_word_resolve_comment(str(source), "1", True, output_path=str(prior))
    assert reached == [failure]
    assert result["success"] is False and result["changes_applied"] == 0 and result.get("error")
    assert source.read_bytes() == original and prior.read_bytes() == untouched
    assert not list(tmp_path.glob(".office-patch-*")) and not list(tmp_path.glob("tmp*.docx"))
