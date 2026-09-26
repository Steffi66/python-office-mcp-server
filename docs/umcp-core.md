## Vendored core and Office integration

The server vendors uMCP 0.2.2 from `rcarmo/umcp@30cce7dfe08c6ee63de235f7d81754ba286dafbb`. `aioumcp.py` and `umcp_shared.py` are byte-identical upstream files. The synchronous `umcp.py` is unused and not shipped. [`vendor/umcp/manifest.json`](../vendor/umcp/manifest.json) records the pin and SHA-256 values; its MIT licence is included in source, wheels and standalone-build inputs.

Office behaviour lives in `tools/mcp_features.py`, the `OfficeServer` subclass and the staging helper. Do not patch the vendored files to change Office policy.

## Results and discovery

Mapping results retain `content[].text` for existing clients and also provide the same data in `structuredContent`. Office errors (`error` or `success: false`) set MCP `isError`; a partial-success result still needs its per-target diagnostics inspected. Early JSON-RPC validation failures remain protocol errors.

Object-returning tools advertise an object `outputSchema`. `office_read` can return Markdown or a mapping, so it deliberately omits an incompatible object/string output schema. Patch changes require `target`; an omitted `value` retains the existing clear-value behaviour. Upstream's schema checker supports a subset of JSON Schema, not full standard validation.

Tool lists are sorted and can be paginated using upstream `pageSize`/`cursor`. Deprecated tools are filtered before pagination; they remain callable explicitly for compatibility. Read-only annotations use an explicit Office allowlist. Mixed-operation tools, template analysis that may cache data, setters and other mutations are conservative: a `get` or `dry_run` argument does not make the whole tool statically read-only.

## Guidance, progress and cancellation

`resources/list` exposes `office://guidance/workflows`, a JSON catalogue of goals and safe editing guidance. It opens no documents and does not expose arbitrary file URIs. `prompts/list` adds `review_document(file_path, document_type)` alongside the existing four workflow prompts; its document-type enum provides `completion/complete` suggestions. Prompt paths are data, and retrieving a prompt performs no file read or edit.

A `tools/call` with `_meta.progressToken` receives coarse start/finish progress where a return channel is available. Finish means the operation returned; check its result for success. Request-scoped progress/log notifications go only to the originating HTTP session, not all connected clients. Stateless HTTP and legacy raw TCP do not get those notifications. Tool/prompt/resource list-change notifications retain upstream catalogue behaviour.

Cancellation is cooperative for synchronous Office work. The upstream executor copies request context; staged writers check cancellation while fingerprinting/waiting for locks and before validation/publication. Cancelling a library call cannot forcibly stop its Python thread. A worker may finish the current library operation before noticing cancellation, but a cancellation observed before the final publication checkpoint prevents replacement. Cancellation after that checkpoint may race a commit and cannot undo it; inspect the output before retrying. Legacy output-only generators are not enrolled in every staging checkpoint.

Cancellation IDs are scoped by transport, session and principal in the Office adapter; stateless transports also use peer identity. This avoids one HTTP session cancelling another's reused JSON-RPC request ID. The default stdio loop processes requests sequentially, so a cancellation notification on the same stream cannot interrupt an already-running synchronous call. Session HTTP requests on separate connections can overlap.

## Streamable HTTP

For local child-process clients, keep stdio. For network clients, select Streamable HTTP explicitly:

```sh
# Loopback anonymous use is allowed when no token is set.
office-mcp-server --port 8765 --http

# Supply OFFICE_MCP_HTTP_TOKEN through your secret manager/environment.
# Do not put the credential in tool arguments or commit it to configuration.
office-mcp-server --port 8765 --http --host 127.0.0.1 \
  --endpoint /mcp --max-request-bytes 4194304
```

The runtime snapshots `OFFICE_MCP_HTTP_TOKEN` at startup. When set, HTTP/SSE requests need `Authorization: Bearer <token>` and comparisons use `hmac.compare_digest`. Restart to rotate it. A configured token represents one shared identity; there is no roles database or document-path authorisation. Remote `restart_server` and `office_set_comment_identity` are denied because they mutate shared process state.

Non-loopback HTTP/SSE binds require a token. Raw TCP is loopback-only and does not use HTTP bearer authentication, even when a token exists. TLS is not built in: bind to loopback behind a trusted TLS proxy for remote use. Origin checks are additional request validation, not credentials or a filesystem sandbox.

### Sessions and framing

A successful `initialize` negotiates `2025-03-26` or `2024-11-05` and returns `Mcp-Session-Id`. Unsupported initialize versions fall back to the supported preference. Later HTTP requests require `MCP-Protocol-Version`; session-bound requests must use the negotiated value and authenticated identity.

| Request | Contract |
|---|---|
| `POST /mcp` | One JSON-RPC object; JSON request responses use HTTP 200, notifications/client responses use 202 |
| `GET /mcp` | `Accept: text/event-stream` plus valid session/version/auth attaches one notification stream |
| Second simultaneous GET for one session | 409 Conflict |
| `DELETE /mcp` | Authenticated session deletion; attached stream and subscriptions are removed |
| Unknown session | 404 |
| Wrong principal or disallowed Origin | 403 |
| Missing/unsupported version, ambiguous headers/framing | 400 |
| Missing/incorrect configured bearer token | 401 |

HTTP/1.1 connections support sequential reuse. Session IDs are routing state, not credentials. Defaults are 1,024 sessions, 30-minute inactivity expiry, 15-second stream keepalive, 30-second idle reads and 1,000 requests per connection. These session/connection limits are subclass attributes, not tool arguments. Request body size defaults to 4 MiB and is configurable by CLI.

Sessionless POST is retained for compatibility; it has no session notification channel. An SSE stream can reconnect while its session is live, but disconnected events are not replayed and `Last-Event-ID` is not a replay promise. Socket-close detection may lag until a keepalive/write fails; retry a replacement GET's 409 with bounded backoff.

Duplicate singleton headers and transfer encoding are rejected. Browser preflight requires an allowed Origin on the endpoint; `--allowed-origin` is repeatable. Proxies must preserve session/protocol/auth headers, avoid duplicate headers and chunked request transfer encoding, and disable buffering for SSE. See the [pinned upstream contract](https://github.com/rcarmo/umcp/blob/30cce7dfe08c6ee63de235f7d81754ba286dafbb/docs/STREAMABLE_HTTP.md).

Plain `--port` still chooses legacy SSE (`GET /sse`, `POST /message`), now with header/media/Origin/body-limit and authentication checks. `--tcp` retains legacy raw TCP. `--transport stdio|streamable-http|sse|tcp` is the explicit alternative; conflicting aliases and missing network ports refuse startup.

## Refreshing the vendor

Review a chosen upstream commit and its required modules before changing the pin. Export committed bytes with `git show`, never an unreviewed working tree. Refresh `aioumcp.py`, `umcp_shared.py`, the licence and manifest hashes together; keep Office adaptations outside them.

Run `tests/test_umcp_vendor.py`, schema/feature tests, real HTTP and stdio tests, then the full declared matrix and clean wheel. Check the wheel contains the shared module and licence, and keep PyInstaller hidden imports/data in sync. Re-review object output schemas, deprecated-tool filtering, cancellation registry keys, request-scoped notification routing and default authentication policy at every upgrade.

Do not infer Office feature support from upstream examples or prose. Record new tests and pinned results separately from historical preservation reports. The [upgrade checklist](checklists/umcp-upgrade.md) and [upgrade validation](../validation/umcp-upgrade.json) record the completed gates and explicit limits.

## Optional official-SDK check

The repository includes `scripts/mcp_sdk_smoke.ts`. Point `MCP_SDK_ROOT` at an installed `@modelcontextprotocol/sdk` directory and `MCP_URL` at a running server's Streamable HTTP endpoint. Supply the same `OFFICE_MCP_HTTP_TOKEN` through the environment when authentication is enabled, then run:

```sh
bun scripts/mcp_sdk_smoke.ts
```

The script connects, checks tool/structured-result/resource/prompt schemas and terminates its session. Bun and the SDK are optional development tools, not Python runtime dependencies. The recorded run used SDK 1.29.0 against a loopback server with a synthetic credential.
