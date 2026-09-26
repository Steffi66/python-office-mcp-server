"""Dependency repairs for the bounded cell-edit XLSX preservation writer."""

from copy import deepcopy
from zipfile import ZipFile

from lxml import etree

S = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
R = "{http://schemas.openxmlformats.org/package/2006/relationships}"
CT = "{http://schemas.openxmlformats.org/package/2006/content-types}"


def parse(data):
    return etree.fromstring(data, etree.XMLParser(resolve_entities=False, no_network=True))


def semantic(node):
    """Expanded names ignore prefix choice, but retain meaningful content/attributes."""
    attributes = dict(node.attrib)
    if node.tag == S + "xf":
        for key in ("pivotButton", "quotePrefix"):
            if attributes.get(key) in {"0", "false"}:
                attributes.pop(key)
    if node.tag == S + "patternFill" and attributes.get("patternType") == "none":
        attributes.pop("patternType")
    children = [semantic(child) for child in node]
    if node.tag == S + "font":
        children.sort(key=repr)  # CT_Font properties are order-independent.
    return (node.tag, sorted(attributes.items()), (node.text or "").strip(), tuple(children))


def xml(node):
    return etree.tostring(node, encoding="UTF-8", xml_declaration=True)


def merge_styles(original: bytes, staged: bytes) -> bytes:
    """Append style registry entries only; never reinterpret an existing index."""
    old, new = parse(original), parse(staged)
    changed = False
    registries = {"numFmts", "fonts", "fills", "borders", "cellStyleXfs", "cellXfs", "cellStyles", "dxfs"}
    for incoming in new:
        local = etree.QName(incoming).localname
        if local not in registries:
            continue
        existing = old.find(incoming.tag)
        if existing is None:
            if len(incoming):
                # Place a new registry in the staged schema order, before the next known sibling.
                next_tags = [child.tag for child in list(new)[list(new).index(incoming) + 1:]]
                anchor = next((child for child in old if child.tag in next_tags), None)
                if anchor is None:
                    old.append(deepcopy(incoming))
                else:
                    old.insert(old.index(anchor), deepcopy(incoming))
                changed = True
            continue
        if len(incoming) < len(existing) or any(
            semantic(a) != semantic(b) for a, b in zip(existing, incoming)
        ):
            raise ValueError(f"Unsupported style registry rewrite: {local}; nothing committed")
        for child in list(incoming)[len(existing):]:
            existing.append(deepcopy(child))
            changed = True
        if len(incoming) != int(existing.get("count", str(len(existing)))):
            existing.set("count", str(len(existing)))
    return xml(old) if changed else original


def repair_dependencies(source: ZipFile, staged: ZipFile, replacements: dict[str, bytes],
                        sheet_paths: set[str]) -> tuple[set[str], bool]:
    """Invalidate all formula caches after a cell edit; do not claim dependency analysis.

    The conservative policy also drops the calculation chain. Unsupported ZIP parts
    remain original unless they are known calculation/style dependencies.
    """
    original_styles = source.read("xl/styles.xml")
    styles = merge_styles(original_styles, staged.read("xl/styles.xml"))
    if styles != original_styles:
        replacements["xl/styles.xml"] = styles
    style_count = len(parse(styles).find(S + "cellXfs"))
    formulas = False
    for name in sorted(sheet_paths):
        payload = replacements.get(name, source.read(name))
        root = parse(payload)
        changed = False
        for cell in root.iter(S + "c"):
            index = int(cell.get("s", "0"))
            if index < 0 or index >= style_count:
                raise ValueError(f"Unresolved style index {index} in {name}")
            if cell.find(S + "f") is not None:
                formulas = True
                for cached in list(cell.findall(S + "v")):
                    cell.remove(cached)
                    changed = True
        if changed:
            replacements[name] = xml(root)

    removed = set()
    if formulas:
        workbook = parse(source.read("xl/workbook.xml"))
        props = workbook.find(S + "calcPr")
        if props is None:
            props = etree.SubElement(workbook, S + "calcPr")
        props.set("fullCalcOnLoad", "1")
        props.set("forceFullCalc", "1")
        props.set("calcCompleted", "0")
        replacements["xl/workbook.xml"] = xml(workbook)
    # Drop old chains even if the edit removed the last formula.
    rel_path = "xl/_rels/workbook.xml.rels"
    rels = parse(source.read(rel_path))
    for rel in list(rels):
        if (rel.get("Type") or "").endswith("/calcChain"):
            import posixpath

            target = rel.get("Target", "")
            name = target.lstrip("/") if target.startswith("/") else posixpath.normpath("xl/" + target)
            removed.add(name)
            rels.remove(rel)
    if removed:
        replacements[rel_path] = xml(rels)
        types = parse(source.read("[Content_Types].xml"))
        for entry in list(types):
            if entry.get("PartName", "").lstrip("/") in removed:
                types.remove(entry)
        replacements["[Content_Types].xml"] = xml(types)
    return removed, formulas
