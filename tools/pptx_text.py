"""Formatting-preserving literal replacement across adjacent DrawingML runs.

Paragraph breaks, fields and other non-run children are edit barriers. Boundary
run properties remain in place; only matched text is replaced.
"""

A = "{http://schemas.openxmlformats.org/drawingml/2006/main}"


def replace_paragraph(paragraph, find, replacement):
    if not find:
        raise ValueError("find_text must not be empty")
    groups, current = [], []
    for child in paragraph._p:
        if child.tag == A + "r" and child.find(A + "t") is not None:
            current.append(child.find(A + "t"))
        else:
            if current:
                groups.append(current)
                current = []
    if current:
        groups.append(current)
    count = 0
    for nodes in groups:
        original = [node.text or "" for node in nodes]
        text = "".join(original)
        offsets = []
        offset = 0
        for value in original:
            offsets.append((offset, offset + len(value)))
            offset += len(value)
        matches = []
        start = text.find(find)
        while start >= 0:
            matches.append((start, start + len(find)))
            start = text.find(find, start + len(find))
        # Right-to-left keeps all earlier original offsets valid.
        for start, end in reversed(matches):
            covered = [i for i, (lo, hi) in enumerate(offsets) if lo < end and hi > start]
            first, last = covered[0], covered[-1]
            lo = start - offsets[first][0]
            hi = end - offsets[last][0]
            if first == last:
                value = nodes[first].text or ""
                nodes[first].text = value[:lo] + replacement + value[hi:]
            else:
                nodes[first].text = (nodes[first].text or "")[:lo] + replacement
                for i in covered[1:-1]:
                    nodes[i].text = ""
                nodes[last].text = (nodes[last].text or "")[hi:]
            count += 1
    return count


def iter_shapes(shapes):
    for shape in shapes:
        yield shape
        if hasattr(shape, "shapes"):
            yield from iter_shapes(shape.shapes)
