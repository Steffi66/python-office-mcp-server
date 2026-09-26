"""Private staging for unified mutations; only a validated batch reaches its destination."""

from __future__ import annotations

import hashlib
import os
import shutil
import tempfile
import threading
import zipfile
from collections.abc import Callable
from contextlib import contextmanager
from pathlib import Path
from typing import Any


def validate_staged_document(path: Path) -> None:
    """Check archive readability and reopen through the format library before publishing."""
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError("duplicate package members")
        if archive.testzip() is not None:
            raise ValueError("invalid package member checksum")
    suffix = path.suffix.lower()
    if suffix == ".docx":
        from docx import Document

        Document(path)
    elif suffix == ".pptx":
        from pptx import Presentation

        Presentation(path)
    else:
        from openpyxl import load_workbook

        from tools.excel_advanced_tools import _close_workbook

        workbook = load_workbook(path, keep_vba=suffix in {".xlsm", ".xltm"})
        _close_workbook(workbook)


def _public_paths(value: Any, staged: str, source: str) -> Any:
    if isinstance(value, str):
        return value.replace(staged, source)
    if isinstance(value, list):
        return [_public_paths(item, staged, source) for item in value]
    if isinstance(value, dict):
        return {key: _public_paths(item, staged, source) for key, item in value.items()}
    return value


_lock_guard = threading.Lock()
_path_locks: dict[str, list[Any]] = {}


@contextmanager
def _writer_locks(paths):
    """Serialise this process's writers; do not claim an external-editor lock."""
    keys = sorted({str(path) for path in paths})
    with _lock_guard:
        entries = []
        for key in keys:
            entry = _path_locks.setdefault(key, [threading.RLock(), 0])
            entry[1] += 1
            entries.append((key, entry))
    acquired = []
    try:
        for _, entry in entries:
            entry[0].acquire()
            acquired.append(entry[0])
        yield
    finally:
        for lock in reversed(acquired):
            lock.release()
        with _lock_guard:
            for key, entry in entries:
                entry[1] -= 1
                if not entry[1]:
                    del _path_locks[key]


def fingerprint(path: Path):
    if not path.exists():
        return None
    before = path.stat()
    if not path.is_file():
        raise ValueError("Document path must be a regular file")
    if before.st_nlink > 1:
        raise ValueError("Hard-linked document paths are unsupported for mutation")
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    after = path.stat()
    def state(stat):
        return (stat.st_dev, stat.st_ino, stat.st_size, stat.st_mtime_ns, stat.st_ctime_ns)

    if state(before) != state(after):
        raise ValueError("Document changed while being fingerprinted")
    return (digest.hexdigest(), state(after))


def stage_patch(
    source: str,
    output: str | None,
    mode: str,
    requested: int,
    apply: Callable[[str], dict[str, Any]],
) -> dict[str, Any]:
    """Run the existing format writers on a private copy and publish at most once.

    Preview executes the same transformations/validation as a real write, then discards
    the copy. The caller never sees a partially written source or existing destination.
    """
    source_path = Path(source).resolve()
    destination = Path(output or source).resolve()
    with _writer_locks((source_path, destination)):
        return _stage_patch_locked(source, output, mode, requested, apply, source_path, destination)


def _stage_patch_locked(source, output, mode, requested, apply, source_path, destination):
    result: dict[str, Any] = {}
    planned = 0
    committed = 0
    source_state = None
    try:
        source_state = fingerprint(source_path)
        if source_state is None:
            raise FileNotFoundError(source)
        destination_state = fingerprint(destination)
        # Same filesystem for atomic publication; the whole private directory is removed
        # on every return, including scratch files made by legacy format writers.
        with tempfile.TemporaryDirectory(prefix=".office-patch-", dir=destination.parent) as tmp:
            staged = Path(tmp) / ("document" + source_path.suffix)
            shutil.copy2(source_path, staged)
            if fingerprint(staged)[0] != source_state[0] or fingerprint(source_path) != source_state:
                raise ValueError("Source changed while staging")
            result = _public_paths(apply(str(staged)), str(staged), source)
            planned = sum(bool(item.get("success")) for item in result.get("results", []))
            rejected = bool(result.get("errors") or result.get("error") or result.get("skipped_targets"))
            if mode == "strict" and (rejected or planned != requested or not result.get("success")):
                result.update(success=False, status="failed")
                result.setdefault("warnings", []).append("Strict batch refused; no changes were committed.")
            elif result.get("error"):
                result.update(success=False, status="failed")
            elif planned:
                if staged.suffix.lower() == ".pptx":
                    from .package_preservation import restore_unchanged_parts

                    restore_unchanged_parts(source_path, staged)
                validate_staged_document(staged)
                if (Path(source).resolve() != source_path or Path(output or source).resolve() != destination
                        or fingerprint(source_path) != source_state
                        or fingerprint(destination) != destination_state):
                    raise ValueError("Source or destination changed before commit; retry with fresh inspection")
                if mode != "dry_run":
                    os.replace(staged, destination)
                    committed = planned
            if mode == "dry_run":
                result.setdefault("warnings", []).append("Preview only; no changes were committed.")
    except Exception as exc:
        result.update(success=False, status="failed", error=f"Patch not committed: {exc}")
    result.update(
        mode=mode,
        file=str(output or source),
        changes_planned=planned,
        changes_applied=committed,
        source_sha256=source_state[0] if source_state else None,
    )
    result.setdefault("diagnostics", {}).update(changes_planned=planned, changes_applied=committed)
    # Retain skipped_targets for old clients while exposing every missing target explicitly.
    unmatched = result.setdefault("unmatched_targets", [])
    known = {item.get("target") for item in unmatched}
    for item in result.get("skipped_targets", []):
        if item.get("target") not in known:
            unmatched.append({"target": item.get("target"), "reason": "target_not_matched"})
    for item in result.get("results", []):
        item["applied"] = bool(committed and item.get("success"))
    return result
