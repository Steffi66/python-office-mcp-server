"""Literal layout-ranking expectations for the sealed eleven-layout PPTX.

The values come from the fixture's slide-layout XML and the reviewed ranking
policy. This module does not ask the implementation to produce expectations.
"""

import hashlib
from pathlib import Path
from zipfile import ZipFile

from tests.fixture_paths import fixture_path

FIXTURE_ID = "fixture-c54a7b746c0328fc1930525edd91387eedbbca69a6f388f7ec024150187b6bab"

# Each row is recommended followed by the first three alternatives, in order.
# Tuple fields: index, name, classification, score.
RANKINGS = {
    "title": (
        (0, "Title Slide", "title_slide", 2),
        (2, "Section Header", "section_header", 1),
        (1, "Title and Content", "title_and_content", 0),
        (3, "Two Content", "two_content", 0),
    ),
    "bullets": (
        (1, "Title and Content", "title_and_content", 2),
        (9, "Title and Vertical Text", "title_and_vertical_text", 1),
        (10, "Vertical Title and Text", "title_and_vertical_text", 1),
        (0, "Title Slide", "title_slide", 0),
    ),
    "table": (
        (1, "Title and Content", "title_and_content", 3),
        (5, "Title Only", "title_only", 2),
        (6, "Blank", "blank", 1),
        (0, "Title Slide", "title_slide", 0),
    ),
    "comparison": (
        (4, "Comparison", "comparison", 2),
        (3, "Two Content", "two_content", 1),
        (0, "Title Slide", "title_slide", 0),
        (1, "Title and Content", "title_and_content", 0),
    ),
    "blank": (
        (6, "Blank", "blank", 2),
        (5, "Title Only", "title_only", 1),
        (0, "Title Slide", "title_slide", 0),
        (1, "Title and Content", "title_and_content", 0),
    ),
}


def snapshot(path: Path):
    data = path.read_bytes()
    with ZipFile(path) as archive:
        members = {name: archive.read(name) for name in archive.namelist()}
    return hashlib.sha256(data).hexdigest(), data, members


def assert_unchanged(path: Path, before):
    assert snapshot(path) == before


def assert_ranked_layout(tools, content_type: str):
    path = fixture_path(FIXTURE_ID)
    before = snapshot(path)
    assert before[0] == FIXTURE_ID.removeprefix("fixture-")
    result = tools.tool_pptx_recommend_layout(str(path), content_type)
    assert isinstance(result, dict)
    assert result["file"] == path.name
    assert result["content_type"] == content_type
    expected = RANKINGS[content_type]
    fields = ("index", "name", "classification", "score")
    assert tuple(result["recommended"][field] for field in fields) == expected[0]
    assert [tuple(item[field] for field in fields) for item in result["alternatives"]] == list(expected[1:])
    assert result["next_tools"] == ["pptx_add_slide"]
    assert_unchanged(path, before)
