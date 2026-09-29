"""Independent malformed-graph and false-pass controls; no extra shared credit."""

from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZipFile

import pytest

from tests.comment_vml_acceptance.cases import FIXTURE_ID
from tests.fixture_paths import fixture_path
from tools.xlsx_comment_vml import CommentGraphError, inspect_existing_comment_graph

SHEET = "xl/worksheets/sheet1.xml"
RELS = "xl/worksheets/_rels/sheet1.xml.rels"
COMMENTS = "xl/comments/comment1.xml"


def changed_archive(source: Path, target: Path, member: str, before: bytes, after: bytes) -> None:
    """Copy the sealed archive, changing only one unique token in one part."""
    original = source.read_bytes()
    with ZipFile(source) as read, ZipFile(target, "w") as write:
        for item in read.infolist():
            data = read.read(item)
            if item.filename == member:
                assert data.count(before) == 1
                data = data.replace(before, after)
                assert data.count(after) >= 1
            write.writestr(item, data)
    assert target.read_bytes() != original
    assert source.read_bytes() == original
    with ZipFile(source) as read, ZipFile(target) as write:
        assert read.namelist() == write.namelist()
        assert [name for name in read.namelist() if read.read(name) != write.read(name)] == [member]


@pytest.mark.parametrize("member,before,after", [
    (SHEET, b'r:id="anysvml"', b'r:id="missing"'),
    (SHEET, b'<legacyDrawing xmlns:r=', b'<legacyDrawingX xmlns:r='),
    (RELS, b'Id="anysvml"', b'Id="comments"'),
    (RELS, b'/relationships/vmlDrawing', b'/relationships/comments'),
    (RELS, b'/xl/drawings/commentsDrawing1.vml', b'https://example.invalid/drawing.vml'),
    (RELS, b'Target="/xl/drawings/commentsDrawing1.vml"', b'TargetMode="External" Target="/xl/drawings/commentsDrawing1.vml"'),
    (RELS, b'/xl/comments/comment1.xml', b'/xl/comments/missing.xml'),
    (RELS, b'/xl/comments/comment1.xml', b'../../../outside.xml'),
    (RELS, b'/xl/comments/comment1.xml', b'https://example.invalid/comment.xml'),
    (COMMENTS, b'<commentList>', b'<commentListX>'),
    (COMMENTS, b'ref="A3"', b'ref="A2"'),
])
def test_malformed_graph_refuses_without_mutating_source(tmp_path, member, before, after):
    source = fixture_path(FIXTURE_ID)
    changed = tmp_path / "changed.xlsx"
    changed_archive(source, changed, member, before, after)
    altered = changed.read_bytes()
    with pytest.raises(CommentGraphError):
        inspect_existing_comment_graph(changed)
    assert changed.read_bytes() == altered


@pytest.mark.parametrize("member,before,after,field,expected", [
    (SHEET, b'r:id="anysvml"', b'r:id="comments"', "legacy_id", "anysvml"),
    (COMMENTS, b'protagonist', b'antagonist', "A2", "This is the protagonist who creates the creature."),
    (COMMENTS, b"creator's name.", b"creature's name.", "A3", "Often mistakenly called 'Frankenstein' - that is the creator's name."),
])
def test_exact_outcome_mutations_cannot_pass(tmp_path, member, before, after, field, expected):
    source = fixture_path(FIXTURE_ID)
    altered = tmp_path / "mutated.xlsx"
    changed_archive(source, altered, member, before, after)
    original = source.read_bytes()
    if field == "legacy_id":
        with pytest.raises(CommentGraphError):
            inspect_existing_comment_graph(altered)
    else:
        graph = inspect_existing_comment_graph(altered)
        assert graph["comments"][field] != expected
    assert source.read_bytes() == original


def test_namespace_alias_and_relative_targets_are_read_semantically(tmp_path):
    source = fixture_path(FIXTURE_ID)
    with ZipFile(source) as archive:
        sheet = archive.read(SHEET)
        rels = archive.read(RELS)
        comments = archive.read(COMMENTS)
    assert sheet.count(b'<legacyDrawing xmlns:r=') == 1
    assert rels.count(b'/xl/comments/comment1.xml') == 1
    assert rels.count(b'/xl/drawings/commentsDrawing1.vml') == 1
    updates = {
        SHEET: sheet.replace(b'<legacyDrawing xmlns:r=', b'<s:legacyDrawing xmlns:s="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r='),
        RELS: rels.replace(b'/xl/comments/comment1.xml', b'../comments/comment1.xml').replace(b'/xl/drawings/commentsDrawing1.vml', b'../drawings/commentsDrawing1.vml'),
        COMMENTS: comments.replace(b'<comments xmlns=', b'<m:comments xmlns:m=').replace(b'<authors>', b'<m:authors>').replace(b'</authors>', b'</m:authors>').replace(b'<author>', b'<m:author>').replace(b'</author>', b'</m:author>').replace(b'<commentList>', b'<m:commentList>').replace(b'</commentList>', b'</m:commentList>').replace(b'<comment ', b'<m:comment ').replace(b'</comment>', b'</m:comment>').replace(b'<text>', b'<m:text>').replace(b'</text>', b'</m:text>').replace(b'<t>', b'<m:t>').replace(b'</t>', b'</m:t>').replace(b'</comments>', b'</m:comments>'),
    }
    for part in updates.values():
        ET.fromstring(part)
    variant = tmp_path / "alias.xlsx"
    with ZipFile(source) as read, ZipFile(variant, 'w') as write:
        for item in read.infolist():
            write.writestr(item, updates.get(item.filename, read.read(item)))
    baseline = source.read_bytes()
    result = inspect_existing_comment_graph(variant)
    assert result['legacy_id'] == 'anysvml'
    assert result['vml_target'] == 'xl/drawings/commentsDrawing1.vml'
    assert result['comments_target'] == 'xl/comments/comment1.xml'
    assert result['comments']['A2'] == 'This is the protagonist who creates the creature.'
    assert result['comments']['A3'] == "Often mistakenly called 'Frankenstein' - that is the creator's name."
    assert source.read_bytes() == baseline
