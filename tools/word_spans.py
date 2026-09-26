"""Bounded tracked replacement across adjacent plain-text Word runs."""

from copy import deepcopy
from datetime import datetime, timezone

from docx.oxml import OxmlElement
from docx.oxml.ns import qn


def replace_tracked_span(paragraph, find, replacement, author, next_id):
    if not find:
        return False
    groups, group = [], []
    for child in paragraph._p:
        eligible = child.tag == qn("w:r") and all(c.tag in {qn("w:rPr"), qn("w:t")} for c in child)
        if eligible:
            group.append(child)
        else:
            if group:
                groups.append(group)
                group = []
    if group:
        groups.append(group)
    for runs in groups:
        texts = ["".join(t.text or "" for t in run.findall(qn("w:t"))) for run in runs]
        joined = "".join(texts)
        start = joined.find(find)
        if start < 0:
            continue
        end = start + len(find)
        offsets, offset = [], 0
        for text in texts:
            offsets.append((offset, offset + len(text)))
            offset += len(text)
        covered = [i for i, (lo, hi) in enumerate(offsets) if lo < end and hi > start]
        first, last = covered[0], covered[-1]
        parent = runs[first].getparent()
        position = parent.index(runs[first])

        def styled_run(template, text, deleted=False):
            run = OxmlElement("w:r")
            props = template.find(qn("w:rPr"))
            if props is not None:
                run.append(deepcopy(props))
            node = OxmlElement("w:delText" if deleted else "w:t")
            node.set(qn("xml:space"), "preserve")
            node.text = text
            run.append(node)
            return run

        prefix = texts[first][:start - offsets[first][0]]
        suffix = texts[last][end - offsets[last][0]:]
        output = []
        if prefix:
            output.append(styled_run(runs[first], prefix))
        deletion, insertion = OxmlElement("w:del"), OxmlElement("w:ins")
        for revision in (deletion, insertion):
            revision.set(qn("w:id"), str(next_id()))
            revision.set(qn("w:author"), author)
            revision.set(qn("w:date"), datetime.now(timezone.utc).isoformat())
        for i in covered:
            lo, hi = offsets[i]
            deletion.append(styled_run(runs[i], texts[i][max(start - lo, 0):min(end - lo, hi - lo)], True))
        insertion.append(styled_run(runs[first], replacement))
        output.extend([deletion, insertion])
        if suffix:
            output.append(styled_run(runs[last], suffix))
        for i in covered:
            parent.remove(runs[i])
        for i, node in enumerate(output):
            parent.insert(position + i, node)
        return True
    return False
