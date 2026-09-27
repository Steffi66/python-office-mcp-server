# Office Document MCP Server

This Python MCP server reads and edits unencrypted `.docx`, `.xlsx`, `.xlsm` and `.pptx` files, and can create `.docx`, `.xlsx` and `.pptx` files. It runs over local stdio by default; the pinned transport dependency also supports Streamable HTTP sessions and legacy HTTP/SSE or raw TCP. Legacy binary Office files, encrypted packages and Information Rights Management are unsupported.

Covered edits use a private copy, reopen the saved package and replace the destination once. Excel cell patches preserve style dependencies and invalidate cell-level formula caches; supported Word and PowerPoint literal replacements retain formatting across adjacent runs. Reopening does not verify rendered layout or recalculate formulas. See the [operating limits](docs/operations.md) and [writer scope](docs/writer-scope.md) before editing complex files.

The project accepts patches and hotfixes but does not offer support or issue tracking.

## Available Tools

Start with `office_help` when choosing a workflow. Use `office_read` or `office_inspect` before editing with `office_patch`, `office_table`, `office_template`, `office_comment` or `office_image`; use `office_audit` to check the result. `word_insert_at_anchor` handles paragraph placement when a literal target is unsuitable. The specialised tools below cover conversion, slides, tracked changes and older SOW templates.

### Unified tools

These tools select document handlers from the file extension or provide cross-format guidance. `office_set_comment_identity` configures default comment attribution separately.

| Tool | Description |
|------|-------------|
| `office_help` | Structured workflow help and recommendations for consulting/architecture document workflows |
| `office_read` | Read content from Word/Excel/PowerPoint as JSON or Markdown |
| `office_inspect` | Get document structure (sheets, slides, sections, tables, comments) |
| `office_patch` | Edit cells, shapes, sections, or replace placeholders |
| `office_comment` | Add/get/reply/delete comments; Word also supports resolve/reopen, threaded get, and reply threading |
| `office_table` | Read tables, add/update rows, and create Word/PowerPoint tables |
| `office_template` | Copy templates or analyze template structure |
| `office_audit` | Audit for placeholders, completion, or tracking status |
| `office_image` | Insert images into Word, Excel, or PowerPoint documents |

### Specialised tools

Use these for operations that the unified tools do not expose, or when an existing integration calls them directly.

#### Word SOW Generation

The `sow` tools began as a template-specific proof of concept. They are deprecated but remain available for existing integrations; use the unified tools for new editing workflows.

| Tool | Description |
|------|-------------|
| `word_generate_sow` | Fill SOW template with structured data |
| `word_cleanup_sow` | Remove template artifacts and guidance (tracked) |
| `word_get_section_guidance` | Extract template instructions from a section |
| `word_parse_sow_template` | Analyze SOW template structure |
| `word_create_sow_from_markdown` | Create SOW from Markdown content |
| `word_extract_sow_structure` | Extract structured data from existing SOW |
| `word_insert_at_anchor` | Insert paragraphs before/after an anchor paragraph or paragraph index |
| `word_list_anchors` | List headings and high-signal paragraphs that can be used as insertion anchors |
| `word_document_map` | Return a lightweight map of sections, tables, placeholders, anchors, and warnings |
| `word_enable_track_changes` | Enable Word's track changes mode |
| `word_patch_with_track_changes` | Replace text with revision marks |
| `word_accept_all_changes` | Accept insertion/deletion wrappers in the main document XML; see revision limits below |

#### PowerPoint Slide Management

| Tool | Description |
|------|-------------|
| `pptx_add_slide` | Add new slide with specified layout |
| `pptx_delete_slide` | Remove a slide |
| `pptx_duplicate_slide` | Copy a slide with independent chart and embedded-workbook parts |
| `pptx_reorder_slides` | Change slide order |
| `pptx_hide_slide` | Hide/unhide a slide |
| `pptx_set_notes` | Set speaker notes |
| `pptx_recommend_layout` | Get best layout for content type |
| `pptx_log_changes` | Add change log slide |
| `pptx_import_slide` | Copy a slide between presentations, with optional speaker notes |

#### Document Conversion

| Tool | Description |
|------|-------------|
| `word_from_markdown` | Create Word document from Markdown (supports inline text or `markdown_file` path for large inputs) |
| `excel_from_markdown` | Create Excel workbook from Markdown tables (supports inline text or `markdown_file` for large inputs) |
| `pptx_from_markdown` | Create PowerPoint from Markdown slides (supports inline text or `markdown_file` for large inputs) |

#### Utility

| Tool | Description |
|------|-------------|
| `restart_server` | Hot-reload the server after code changes |
| `list_supported_formats` | Show available document formats |

## Quick Examples

### Protocol guidance and results

Tool results keep their legacy text content and add `structuredContent` for mappings. Failed operations set MCP `isError`; partial success still needs per-target checks. Tool lists support pagination and explicit conservative annotations. The read-only `office://guidance/workflows` resource and `review_document` prompt offer workflow guidance without opening files; the prompt's document-type argument supports completion.

See [the uMCP integration](docs/umcp-core.md) for opt-in progress, cooperative cancellation, HTTP authentication/session rules and the pinned dependency update procedure.

### Workflow Discovery

```python
# Find the best workflow for filling a consulting SOW from markdown
office_help(
  goal="fill_sow_from_markdown",
  document_type="word",
  constraints=["preserve_template_structure"],
  format="summary"
)

# Map a common consulting request onto a deterministic workflow
office_help(
  task="Patch an Excel estimate workbook safely and verify the result",
  format="detailed"
)

# Discover the safest path for a stakeholder review deck
office_help(
  goal="create_review_deck",
  document_type="powerpoint",
  format="summary"
)
```

### Template Analysis Cache

`word_parse_sow_template` and `office_template(operation="analyze")` cache Word template metadata as JSON in `.office-metadata-cache/`. Set `OFFICE_MCP_METADATA_CACHE_DIR` to move the cache. A resolved-path, file-size or mtime change invalidates an entry.

### Reading Documents

```python
# Read Excel as Markdown
office_read(file_path="data.xlsx", output_format="markdown")

# Read specific range
office_read(file_path="data.xlsx", scope="Sheet1!A1:D10")

# Read a single worksheet
office_read(file_path="data.xlsx", scope="Sheet1")

# Read Excel formulas instead of cached values (reading never recalculates)
office_read(file_path="model.xlsx", include_formulas=True)

# Read Word document
office_read(file_path="report.docx", output_format="markdown")
```

### Inspecting Structure

```python
# List Excel sheets
office_inspect(file_path="data.xlsx", what="sheets")

# List Word tables
office_inspect(file_path="report.docx", what="tables")

# List PowerPoint slides
office_inspect(file_path="deck.pptx", what="slides")

# Analyze a Word template and reuse cached metadata on later runs
office_template(
  source_path="templates/sow.docx",
  destination_path="",
  operation="analyze"
)

# Discover insertion anchors before adding narrative content
word_list_anchors(file_path="report.docx", query="delivery")

# Get a compact map of a Word document
word_document_map(file_path="report.docx")
```

### Editing Content

```python
# Patch Excel cell
office_patch(
  file_path="data.xlsx",
  changes=[{"target": "A1", "value": "New Value"}]
)

# Patch Word placeholder
office_patch(
  file_path="report.docx",
  changes=[{"target": "<Customer>", "value": "Contoso"}]
)

# Patch PowerPoint shape
office_patch(
  file_path="deck.pptx",
  changes=[{"target": "slide:1/Title 1", "value": "New Title"}]
)

# PowerPoint soft return in a single text box
office_patch(
  file_path="deck.pptx",
  changes=[{"target": "slide:1/Title 2", "value": "Contoso{br}Project"}]
)
```

Covered mutation tools return per-target diagnostics. `office_patch`, `office_table` and `office_comment` accept `best_effort`, `safe`, `strict` and `dry_run`; other tools accept a mode only if it appears in their schema. Fields depend on the tool and how early validation fails:

- `success`
- `status` (`success`, `partial_success`, `failed`, `skipped`)
- `warnings`
- `matched_targets`
- `unmatched_targets`
- `skipped_targets`
- `diagnostics`
- `next_tools`

- `best_effort`: current compatibility-oriented behavior
- `safe`: requires a distinct output path for covered mutation flows
- `strict`: for `office_patch`, any missing or failed target prevents the entire batch commit
- `dry_run`: for `office_patch`, validates changes on a private copy, discards it, and leaves source and destination unchanged

For `office_patch`, `safe` requires a distinct destination but may commit the accepted subset. Use `strict` with a new `output_path` when every target is required. Receipts distinguish `changes_planned` from committed `changes_applied`, include `results[].applied`, and record `source_sha256`.

Source/destination fingerprint changes prevent publication. Process-local writer locks cover staged patches and the enrolled existing-document writers in [writer scope](docs/writer-scope.md); arbitrary external editors are not locked. Hard-linked document paths refuse mutation. Tables and comments share staged publication, but their XLSX serialisation does not preserve every opaque part as `office_patch` does. Output-only generation paths retain separate contracts.

Excel cell patches preserve append-only style dependencies and invalidate formula caches on cell-level formula elements across worksheets. `calculation_state="recalculation-required"` means an external calculation engine must refresh results; no recalculation runs here. Unsupported style registry rewrites refuse before commit. Word read-back includes tracked insertions and excludes tracked deletions.

Start with `office_help`, then inspect, preview, patch to a new output, and reopen/audit the result. Excel value patches coerce numeric-looking strings, currencies and percentages; this API has no force-text option for numeric identifiers. See [operating limits](docs/operations.md) before processing untrusted or complex files.

### Verification

Install the development dependencies before running `bash tests/run_tests.sh`, or select related test paths as arguments. Set `PYTHON=/path/to/python` to choose the environment. The [testing guide](docs/testing.md) covers setup, focused batches, Gherkin reports and the optional LibreOffice checks. Verification never auto-formats or fixes source.

Shared acceptance scenarios execute through pytest-bdd in `tests/acceptance/`. Each run replaces `test-results/acceptance.json` with a fresh inventory and per-step outcomes. Planned, undefined, ambiguous and unexecuted cases cannot count as acceptance passes. Fixtures and shared requirements come from the tagged `references/fixtures-ooxml` submodule. Python reads the shared Gherkin directly and uses `tests/acceptance/shared-mapping.json` for local implementation status; no duplicate executable feature copy is maintained. Schema-2 document inputs have stable content IDs and one physical payload under central `fixtures/<format>/<scenario-group>/`; tests obtain paths from the manifest. The separate native-test catalogue staging directory is incomplete reconciliation input, not additional executable coverage.

The [testing guide](docs/testing.md) separates historical runtime results, fixture-migration measurements and current release checks. The [uMCP integration report](validation/umcp-upgrade.json) records results at its original source pin, including an official-SDK smoke check. See the [testing guide](docs/testing.md#fixture-migration-verification) for the current fixture release and its bounded checks. Optional local LibreOffice tests skipped when the executable was unavailable; the [manual oracle workflow](.github/workflows/oracle.yml) installs it for separate checks. Native Microsoft Office rendering and Windows executable mutation workflows have not been verified locally.

[Recorded test results](docs/testing.md#recorded-results) distinguish committed tests from local-only tests. The [XLSX adoption decision](docs/xlsx-adoption-decision.md) explains why the server retains upstream openpyxl.

### Table Operations

```python
# Add row to Word table
office_table(
  file_path="report.docx",
  operation="add_row",
  table_id="staffing",
  data={"Role": "PM", "Count": "1", "Notes": "Lead"}
)

# Create table in Word
office_table(
  file_path="report.docx",
  operation="create",
  data={
    "headers": ["Phase", "Owner", "Target Date"],
    "rows": [{"Phase": "Discovery", "Owner": "PM", "Target Date": "2026-04-01"}],
    "insert_after_section": "Delivery Plan"
  }
)

# Add table to PowerPoint
office_table(
  file_path="deck.pptx",
  operation="create",
  table_id="3",
  data={
    "headers": ["Phase", "Duration"],
    "rows": [["Discovery", "2 weeks"]]
  }
)
```

### Track Changes Workflows

```python
# Enable Track Changes in document settings
word_enable_track_changes(file_path="draft.docx", output_path="draft-tracked.docx")

# Apply a tracked replacement
word_patch_with_track_changes(
  file_path="draft-tracked.docx",
  replacements={"Old wording": "New wording"},
  output_path="draft-review.docx"
)

# Accept main-document insertion/deletion wrappers
word_accept_all_changes(
  file_path="draft-review.docx",
  output_path="draft-final.docx"
)
```

`word_accept_all_changes` traverses the main document XML, including its tables. It does not resolve revisions in separate headers, footers, footnotes or other story parts, and it does not implement move/format revision resolution or reject-all. Despite its name, it is not a complete Word revision engine. The `office_patch(track_changes=...)` compatibility parameter currently does not control Word dispatch; use the documented tracked workflow and inspect its output.

### Image Support

`office_image` supports raster formats (`PNG`, `JPG/JPEG`, `GIF`) across Word, Excel, and PowerPoint.

SVG support is currently:

| Format | Word | Excel | PowerPoint |
|---|---:|---:|---:|
| PNG | Yes | Yes | Yes |
| SVG | Yes | No | Yes |

Notes:
- Excel image placement is cell-anchored.
- PowerPoint image placement is centered by default and can be validated from returned position metadata.
- Recent local MCP validation covered image insertion plus position/bounds checks for Excel and PowerPoint fixture copies.

### Large Markdown Inputs

```python
# Avoid MCP argument-size limits by passing a markdown_file path
word_from_markdown(
  output_path="report.docx",
  markdown_file="inputs/large-report.md"
)

excel_from_markdown(
  output_path="budget.xlsx",
  markdown_file="inputs/budget-tables.md"
)

pptx_from_markdown(
  output_path="deck.pptx",
  markdown_file="inputs/deck.md"
)

word_create_sow_from_markdown(
  output_path="sow.docx",
  template_path="templates/Agile.docx",
  markdown_file="inputs/sow.md"
)
```

### Auditing

```python
# Audit for placeholders
office_audit(file_path="report.docx", checks=["placeholders"])

# Audit for completion
office_audit(file_path="report.docx", checks=["completion"])
```

## Comment Threads and Resolution (Word)

Word stores comment text in `word/comments.xml` and thread/resolution metadata in `word/commentsExtended.xml`.

### `word_get_comments`

```python
word_get_comments(
  file_path="SoW.docx",
  filter="all",      # all | open | resolved | mine
  author=None,        # used with filter="mine"
  format="flat"      # flat | threaded
)
```

Each comment now includes:

- `id`
- `author`
- `initials`
- `date`
- `text`
- `done` (resolved state)
- `is_reply`
- `parent_id`
- `para_id`

When `format="threaded"`, response includes:

- `threads`: grouped `{ root, replies[] }`
- `flat`: full backward-compatible flat list

### `word_resolve_comment`

```python
word_resolve_comment(
  file_path="SoW.docx",
  comment_id="121",
  resolved=True,      # True=resolve, False=reopen
  output_path=None,
)
```

Notes:

- If a reply ID is supplied, the root thread is resolved/reopened.
- If `commentsExtended.xml` is missing, it is created and wired into the package.
- If root comments lack `w14:paraId`, a paraId is synthesized for stable mapping.

### `word_reply_to_comment`

```python
word_reply_to_comment(
  file_path="SoW.docx",
  comment_id="121",
  text="Done — updated as requested.",
  author="Rui Carmo",
  auto_resolve=True,
)
```

`auto_resolve=True` performs reply + resolve in one call.

### Unified API (`office_comment`)

`office_comment` supports Word thread workflows directly:

```python
office_comment(file_path="SoW.docx", operation="get", format="threaded")
office_comment(file_path="SoW.docx", operation="get", filter="open")
office_comment(file_path="SoW.docx", operation="resolve", target="121")
office_comment(file_path="SoW.docx", operation="reopen", target="121")
```

Supported operations:

- Word: `add`, `get`, `reply`, `resolve`, `reopen`, `delete`
- Excel: `add`, `get`, `delete` (`reply`/`resolve`/`reopen` return clear unsupported errors)
- PowerPoint: `add`, `get`, `delete` (`reply`/`resolve`/`reopen` return clear unsupported errors)

### End-to-end round-trip tests

Fixture-based tests cover:

- mixed open/resolved states
- resolve/reopen toggling
- reply-to-root resolution behaviour
- legacy `commentsIds.xml` fallback
- missing `commentsExtended.xml` creation
- threaded retrieval + filtering
- output-path round trips

Primary test files:

- `tests/test_word_comment_resolution.py`
- `tests/test_word_comment_roundtrip_fixture.py`
- `tests/test_word_comment_replies.py`

## Word Review Workflow

Inspect the document before choosing targets. Use `section:` targets for section content and literal text for placeholders; `office_patch` has no `operation` argument.

```python
office_inspect(file_path="draft.docx", what="sections")
word_list_anchors(file_path="draft.docx", query="Delivery")

changes = [
  {"target": "<Customer>", "value": "Contoso"},
  {"target": "section:Delivery", "value": "Delivery starts after approval."}
]
office_patch(file_path="draft.docx", changes=changes, mode="dry_run")
office_patch(
  file_path="draft.docx", changes=changes,
  mode="strict", output_path="review.docx"
)
office_read(file_path="review.docx")
office_audit(file_path="review.docx", checks=["placeholders", "completion"])
```

Preview reports planned changes; strict commit requires every requested target to apply. `word_patch_with_track_changes` writes tracked replacements; `office_patch` does not route its `track_changes` argument into Word editing. Read-back includes tracked insertions and excludes deletions. Inspect the saved document before accepting revisions; package checks cannot establish its meaning or rendered layout.

## Setup

### Install from repository (recommended)

Using [uv](https://docs.astral.sh/uv/):

```bash
uv tool install "git+https://github.com/rcarmo/python-office-mcp-server.git"
```

Using pip:

```bash
python -m venv .venv
. .venv/bin/activate  # Windows PowerShell: .venv\\Scripts\\Activate.ps1
python -m pip install "git+https://github.com/rcarmo/python-office-mcp-server.git"
```

This installs the `office-mcp-server` command and the exact Git-pinned transport dependency. Git must be available during installation. The public PyPI package named `umcp` is unrelated; use the repository's dependency declaration. Requires Python >=3.10; locally tested on 3.10, 3.12 and 3.13. If a GUI client cannot find the command, configure the absolute executable path; its environment may not inherit your shell's `PATH`.

### Install from local clone

```bash
git clone --recurse-submodules https://github.com/rcarmo/python-office-mcp-server.git
cd python-office-mcp-server
uv sync --frozen
uv run office-mcp-server
# For development and tests: uv sync --frozen --extra dev
# In an activated pip environment: python -m pip install -e '.[dev]'
```

### Run the source script after installing dependencies

```bash
git clone --recurse-submodules https://github.com/rcarmo/python-office-mcp-server.git
cd python-office-mcp-server
python -m venv .venv
. .venv/bin/activate  # Windows PowerShell: .venv\\Scripts\\Activate.ps1
python -m pip install -r requirements.txt
python office_server.py
```

This starts the stdio server; it waits for MCP messages rather than opening a web page. Configure the client with the same virtual-environment interpreter and an absolute script path:

```json
{
  "command": "/absolute/path/to/python-office-mcp-server/.venv/bin/python",
  "args": ["/absolute/path/to/python-office-mcp-server/office_server.py"]
}
```

On Windows, use `.venv\\Scripts\\python.exe` and escape backslashes in JSON. Relative document paths depend on the server process's working directory; absolute paths avoid ambiguity.

For network clients use explicit `--http`; plain `--port` retains legacy SSE. Configure `OFFICE_MCP_HTTP_TOKEN` through the server environment for bearer authentication, and keep a TLS proxy and OS/path boundary for remote access. See [transports](docs/operations.md#transports). The client examples below use stdio.

### MCP client configuration

**VS Code** (`.vscode/mcp.json`):

```json
{
  "servers": {
    "office": {
      "command": "office-mcp-server"
    }
  }
}
```

**Claude Desktop** (`claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "office": {
      "command": "office-mcp-server"
    }
  }
}
```

**mcp-cli** (`mcp_servers.json`):

```json
{
  "mcpServers": {
    "office": {
      "command": "office-mcp-server"
    }
  }
}
```

To use `uvx` instead of a pre-installed binary:

```json
{
  "command": "uvx",
  "args": ["--from", "git+https://github.com/rcarmo/python-office-mcp-server.git", "office-mcp-server"]
}
```

## Tool Activation Note

Some MCP clients can start with subsets of tools disabled by policy/session settings.
If a call returns a disabled-tool error, enable the corresponding MCP tools in the client first, then retry.
This enablement behavior is controlled by the MCP client/host, not by this server.

### VS Code (Automatic)

Create `.vscode/mcp.json` using the VS Code example above; the repository does not ship that file. Open the Command Palette and run **MCP: List Servers** to confirm `office` is listed.

### GitHub Copilot CLI

Add the server to your Copilot CLI configuration:

```bash
# Open config file
code ~/.config/github-copilot/config.json

# Add this to the mcpServers section:
{
  "mcpServers": {
    "officeServer": {
      "command": "python",
      "args": ["/path/to/python-office-mcp-server/office_server.py"]
    }
  }
}
```

### Running Manually

```bash
cd python-office-mcp-server
pip install -r requirements.txt
python office_server.py
```

## Windows Single-File Distribution

Build a standalone `.exe` using PyInstaller.

### Build on Windows

```powershell
cd python-office-mcp-server
python -m pip install -r requirements.txt
python -m pip install -r requirements-build.txt
python build_windows_onefile.py --clean
```

Output artifact:

- `dist/office-mcp-server.exe`

### Custom output name

```powershell
python build_windows_onefile.py --name office-server-prod
```

### Run executable

```powershell
dist\office-mcp-server.exe
```

Use the generated executable in MCP client configuration by pointing `command` to the `.exe` path.

The Windows workflow builds the executable and checks tool discovery. It does not run mutation workflows through the executable.

## Dependencies

- `python-docx` — Word document handling
- `openpyxl` — Excel workbook handling  
- `python-pptx` — PowerPoint presentation handling
- `references/fixtures-ooxml` — Git submodule of tagged fixtures and behaviour contracts used by tests
- Installed uMCP 0.2.2 dependency — Async transport and request context; exact Git revision declared in project metadata
- `pyinstaller` — Build-time dependency for one-file Windows executable

## Architecture

The server dynamically loads tool modules from `tools/`:

- `office_unified_tools.py` — Unified document operations
- `word_tools.py` — Word conversion tools
- `word_advanced_tools.py` — Revisions, anchors, tables and legacy SOW workflows
- `excel_tools.py` — Excel conversion tools
- `excel_advanced_tools.py` — Excel advanced operations (internal)
- `pptx_tools.py` — PowerPoint conversion tools
- `pptx_advanced_tools.py` — Slide management tools
- `pptx_slide_transfer_tools.py` — Relationship-aware slide import
- `mcp_features.py` — Office metadata, structured failures, guidance and HTTP/request policy
- `mutation.py` — Staging, writer locks, fingerprints, cooperative cancellation and commit receipts
- `package_guard.py` / `package_preservation.py` — Bounded admission and package differences
- `xlsx_preservation.py` — Cell-edit style and calculation dependencies
- `word_spans.py` / `pptx_text.py` — Adjacent-run text replacement

Tools are discovered automatically by class name pattern (`*Tools`).
