"""Dependency repairs for the bounded cell-edit XLSX preservation writer."""

import posixpath
import re
from copy import deepcopy
from zipfile import ZipFile

from lxml import etree

S = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
R = "{http://schemas.openxmlformats.org/package/2006/relationships}"
CT = "{http://schemas.openxmlformats.org/package/2006/content-types}"
DOC_REL = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"
WORKSHEET_REL = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"
CHAIN_REL = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain"
CHAIN_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml"


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


CELL = re.compile(r"\$?([A-Za-z]{1,3})\$?([1-9][0-9]{0,6})")
REF = re.compile(r"(?:(?P<sheet>[A-Za-z_][A-Za-z0-9_]*)!)?\$?(?P<column>[A-Za-z]{1,3})\$?(?P<row>[1-9][0-9]{0,6})")
LITERAL = re.compile(r"[0-9]+(?:\.[0-9]+)?")


def _formula_dependencies(expression: str, sheet: str, sheets: set[str]) -> set[tuple[str, str]]:
    """Prove a bounded arithmetic formula's complete cell-reference set.

    No functions, names, ranges, strings, external references or volatile values
    are admitted. Unknown grammar refuses before any destination is published.
    """
    text = (expression or "").strip()
    if text.startswith("="):
        text = text[1:]
    if not text:
        raise ValueError("Empty formula in dependency-aware cache policy")
    refs: set[tuple[str, str]] = set()
    offset = 0
    expect_operand = True
    depth = 0
    while offset < len(text):
        if text[offset].isspace():
            offset += 1
            continue
        if expect_operand:
            if text[offset] == "(":
                depth += 1
                offset += 1
                continue
            match = REF.match(text, offset)
            if match:
                target_sheet = match.group("sheet") or sheet
                if target_sheet not in sheets:
                    raise ValueError("Unknown formula sheet in dependency-aware cache policy")
                refs.add((target_sheet, match.group("column").upper() + match.group("row")))
            else:
                match = LITERAL.match(text, offset)
            if not match:
                raise ValueError("Unsupported formula in dependency-aware cache policy")
            offset = match.end()
            expect_operand = False
        elif text[offset] in "+-*/":
            offset += 1
            expect_operand = True
        elif text[offset] == ")" and depth:
            depth -= 1
            offset += 1
        else:
            raise ValueError("Unsupported formula in dependency-aware cache policy")
    if expect_operand or depth:
        raise ValueError("Incomplete formula in dependency-aware cache policy")
    return refs


def _owned_sheet_and_chain_graph(source: ZipFile, workbook, sheet_map: dict[str, str]) -> str:
    """Prove each worksheet and one nonstandard chain are workbook-owned.

    This opt-in path refuses ambiguous relationship IDs, external targets,
    unowned chain parts and stale content-type overrides before any output.
    """
    names = set(source.namelist())
    relationships = parse(source.read("xl/_rels/workbook.xml.rels"))
    rels = list(relationships)
    ids = [rel.get("Id") for rel in rels]
    if (not all(ids) or len(ids) != len(set(ids))
            or any(rel.tag != R + "Relationship" for rel in rels)):
        raise ValueError("Duplicate or malformed workbook relationship")
    by_id = {rel.get("Id"): rel for rel in rels}
    sheets = workbook.find(S + "sheets")
    if sheets is None or len(sheets) != len(sheet_map):
        raise ValueError("Incomplete workbook worksheet ownership")
    sheet_ids = [sheet.get(DOC_REL) for sheet in sheets]
    if not all(sheet_ids) or len(sheet_ids) != len(set(sheet_ids)):
        raise ValueError("Missing or duplicate workbook worksheet relationship ID")
    for sheet in sheets:
        rel = by_id.get(sheet.get(DOC_REL))
        if rel is None or rel.get("Type") != WORKSHEET_REL or rel.get("TargetMode") is not None:
            raise ValueError("Unowned or external workbook worksheet")
        target = rel.get("Target", "")
        resolved = target.lstrip("/") if target.startswith("/") else posixpath.normpath("xl/" + target)
        if not target or resolved != sheet_map.get(sheet.get("name")) or resolved not in names:
            raise ValueError("Unresolved workbook worksheet relationship")
    declared_worksheet_ids = {rel.get("Id") for rel in rels if rel.get("Type") == WORKSHEET_REL}
    if declared_worksheet_ids != set(sheet_ids):
        raise ValueError("Unlisted workbook worksheet relationship")
    chains = [rel for rel in rels if (rel.get("Type") or "").endswith("/calcChain")]
    if (len(chains) != 1 or chains[0].get("Type") != CHAIN_REL
            or chains[0].get("TargetMode") is not None):
        raise ValueError("Expected one internal workbook-owned calculation chain")
    target = chains[0].get("Target", "")
    chain = target.lstrip("/") if target.startswith("/") else posixpath.normpath("xl/" + target)
    if (not target or chain not in names or chain == "xl/calcChain.xml"
            or not chain.startswith("xl/") or not chain.endswith(".xml")
            or chain in set(sheet_map.values())):
        raise ValueError("Unresolved nonstandard workbook-owned calculation chain")
    for rel_path in names:
        if not rel_path.endswith(".rels") or rel_path == "xl/_rels/workbook.xml.rels":
            continue
        base = "" if rel_path == "_rels/.rels" else posixpath.dirname(posixpath.dirname(rel_path))
        for rel in parse(source.read(rel_path)):
            other = rel.get("Target", "")
            resolved = other.lstrip("/") if other.startswith("/") else posixpath.normpath(posixpath.join(base, other))
            if ((rel.get("Type") or "").endswith("/calcChain") or
                    (rel.get("TargetMode") != "External" and resolved == chain)):
                raise ValueError("Calculation chain has another relationship owner")
    types = parse(source.read("[Content_Types].xml"))
    overrides = [entry for entry in types if entry.get("ContentType") == CHAIN_TYPE]
    if (len(overrides) != 1 or overrides[0].get("PartName") != "/" + chain
            or len([entry for entry in types if entry.get("PartName") == "/" + chain]) != 1):
        raise ValueError("Unowned or duplicate calculation-chain content-type override")
    chain_root = parse(source.read(chain))
    if chain_root.tag != S + "calcChain" or not len(chain_root):
        raise ValueError("Malformed owned calculation chain")
    sheet_numbers = [sheet.get("sheetId") for sheet in sheets]
    if not all(sheet_numbers) or len(set(sheet_numbers)) != len(sheet_numbers):
        raise ValueError("Duplicate or missing worksheet sheetId in owned chain")
    if any(cell.tag != S + "c" or cell.get("i") not in set(sheet_numbers)
           or not CELL.fullmatch(cell.get("r", "")) for cell in chain_root):
        raise ValueError("Unresolved owned calculation-chain entry")
    return chain


def _dependent_formula_cells(source: ZipFile, sheet_map: dict[str, str],
                             edited_cells: set[tuple[str, str]]) -> set[tuple[str, str]]:
    if not edited_cells or len(edited_cells) != 1 or len(set(sheet_map.values())) != len(sheet_map):
        raise ValueError("Incomplete dependency-aware edit or worksheet graph")
    if any(not CELL.fullmatch(address) or address != address.upper() for _, address in edited_cells):
        raise ValueError("Invalid edited cell in dependency-aware graph")
    names = set(source.namelist())
    if (any(path not in names for path in sheet_map.values())
            or {path for path in names if path.startswith("xl/worksheets/") and path.endswith(".xml")}
            != set(sheet_map.values())):
        raise ValueError("Unresolved worksheet in dependency-aware graph")
    workbook = parse(source.read("xl/workbook.xml"))
    _owned_sheet_and_chain_graph(source, workbook, sheet_map)
    declared = workbook.find(S + "sheets")
    if (declared is None or {item.get("name") for item in declared} != set(sheet_map)
            or len(declared) != len(sheet_map) or len(set(source.namelist())) != len(source.namelist())):
        raise ValueError("Incomplete worksheet graph in dependency-aware cache policy")
    for sheet in declared:
        if sheet.get("state", "visible") != "visible":
            raise ValueError("Hidden worksheet unsupported in dependency-aware cache policy")
    if workbook.find(S + "externalReferences") is not None:
        raise ValueError("External references unsupported in dependency-aware cache policy")
    names = workbook.find(S + "definedNames")
    if names is not None and len(names):
        raise ValueError("Defined names unsupported in dependency-aware cache policy")
    if any(path.startswith(("xl/externalLinks/", "xl/tables/", "xl/pivotTables/", "xl/connections"))
           for path in source.namelist()):
        raise ValueError("Unsupported formula-bearing package part in dependency-aware cache policy")
    if any(path.startswith(("xl/metadata", "xl/model/", "xl/queryTables/", "xl/charts/", "xl/pivotCache/"))
           for path in source.namelist()):
        raise ValueError("Unsupported calculation metadata in dependency-aware cache policy")
    sheets = set(sheet_map)
    dependencies: dict[tuple[str, str], set[tuple[str, str]]] = {}
    existing: set[tuple[str, str]] = set()
    for sheet, path in sheet_map.items():
        root = parse(source.read(path))
        if (root.findall(".//" + S + "tableParts") or root.findall(".//" + S + "extLst")
                or root.findall(".//" + S + "arrayFormulas") or root.findall(".//" + S + "dataTable")):
            raise ValueError("Unsupported worksheet extension in dependency-aware graph")
        for cell in root.iter(S + "c"):
            address = cell.get("r", "").upper()
            if not CELL.fullmatch(address) or (sheet, address) in existing:
                raise ValueError("Invalid or duplicate cell in dependency-aware graph")
            existing.add((sheet, address))
            formula = cell.find(S + "f")
            if formula is None:
                continue
            if formula.attrib or len(formula) or not formula.text:
                raise ValueError("Shared, array or ambiguous formula in dependency-aware graph")
            key = (sheet, address)
            if key in dependencies:
                raise ValueError("Duplicate formula cell in dependency-aware graph")
            dependencies[key] = _formula_dependencies(formula.text, sheet, sheets)
    if not edited_cells <= existing or any(not refs <= existing for refs in dependencies.values()):
        raise ValueError("Incomplete formula-reference graph in dependency-aware cache policy")
    visiting: set[tuple[str, str]] = set()
    visited: set[tuple[str, str]] = set()

    def visit(key):
        if key in visiting:
            raise ValueError("Circular formula graph in dependency-aware cache policy")
        if key in visited:
            return
        visiting.add(key)
        for ref in dependencies[key] & dependencies.keys():
            visit(ref)
        visiting.remove(key)
        visited.add(key)

    for key in dependencies:
        visit(key)
    affected = set(edited_cells)
    while True:
        added = {key for key, refs in dependencies.items() if key not in affected and refs & affected}
        if not added:
            break
        affected.update(added)
    return affected & dependencies.keys()


def repair_dependencies(source: ZipFile, staged: ZipFile, replacements: dict[str, bytes],
                        sheet_paths: set[str], *, cache_policy: str = "invalidate-all-formula-caches",
                        edited_cells: set[tuple[str, str]] | None = None,
                        sheet_map: dict[str, str] | None = None) -> tuple[set[str], bool]:
    """Invalidate formula caches; opt-in uses a conservative complete static graph.

    The default policy still drops all formula caches. Unsupported graphs refuse
    before the temporary output is made, leaving the source and destination alone.
    """
    if cache_policy not in {"invalidate-all-formula-caches", "invalidate-dependent-formula-caches"}:
        raise ValueError("Unsupported formula cache policy")
    dependent = (_dependent_formula_cells(source, sheet_map or {}, edited_cells or set())
                 if cache_policy == "invalidate-dependent-formula-caches" else None)
    original_styles = source.read("xl/styles.xml")
    styles = merge_styles(original_styles, staged.read("xl/styles.xml"))
    if styles != original_styles:
        replacements["xl/styles.xml"] = styles
    style_count = len(parse(styles).find(S + "cellXfs"))
    formulas = False
    reverse_sheets = {path: sheet for sheet, path in (sheet_map or {}).items()}
    for name in sorted(sheet_paths):
        payload = replacements.get(name, source.read(name))
        root = parse(payload)
        old_cells = ({cell.get("r"): cell for cell in parse(source.read(name)).iter(S + "c")}
                     if dependent is not None else {})
        changed = False
        for cell in root.iter(S + "c"):
            index = int(cell.get("s", "0"))
            if index < 0 or index >= style_count:
                raise ValueError(f"Unresolved style index {index} in {name}")
            if cell.find(S + "f") is not None:
                formulas = True
                if dependent is not None and (reverse_sheets.get(name), cell.get("r", "").upper()) not in dependent:
                    original = old_cells.get(cell.get("r"))
                    old_formula = original.find(S + "f") if original is not None else None
                    if (old_formula is None or old_formula.text != cell.find(S + "f").text
                            or old_formula.attrib != cell.find(S + "f").attrib):
                        raise ValueError("Unchanged formula cannot be proved in dependency-aware graph")
                    old_cached = original.find(S + "v")
                    for cached in list(cell.findall(S + "v")):
                        cell.remove(cached)
                        changed = True
                    if old_cached is not None:
                        cell.append(deepcopy(old_cached))
                        changed = True
                    continue
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
