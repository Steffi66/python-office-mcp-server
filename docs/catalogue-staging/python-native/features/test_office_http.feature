@captured @python_candidate
Feature: office http native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-office-http-a0c9c65b3e
  # Native: tests/test_office_http.py::test_persistent_session_office_mutation_delete_and_errors
  Scenario: Native check: persistent session office mutation delete and errors
    Given The server fixture must be running in HTTP mode on loopback with bearer-token authentication and a 65536-byte request limit.
    And A temporary directory is available for creating source and output workbooks.
    When The test initializes an MCP session over HTTP and records the underlying socket.
    And It lists tools, verifies office_patch is advertised, and checks that the same HTTP connection socket is still in use.
    And It creates a source workbook with A1=1, performs a dry-run office_patch that would write A1=42 to a separate output file, and then performs the same call in strict mode.
    And It loads the strict-mode output workbook to inspect A1.
    And It also sends requests with a wrong bearer token, a mismatched protocol version, a forbidden restart_server call, a notifications/initialized message, and finally an HTTP DELETE for the session.
    And After deletion it attempts another tools/list call with the old session id.
    Then initialize returns HTTP 200 with the requested protocol version and a session id.
    And tools/list returns HTTP 200 on the existing connection and includes office_patch in the tool list.
    And The dry-run call reports zero applied changes, does not create the output file, and leaves the source bytes unchanged.
    And The strict-mode call is not marked as an error, reports one applied change, writes an output workbook with A1=42, and leaves the source bytes unchanged.
    And A request with the wrong token returns 401.
    And A request with the wrong protocol version returns 400.
    And A tools/call for restart_server returns 403.
    And The notifications/initialized POST returns 202.
    And Deleting the session returns 200, and reusing that session id afterward returns 404.

  @candidate-python-office-http-9663261780
  # Native: tests/test_office_http.py::test_session_sse_progress_and_single_stream
  Scenario: Native check: session sse progress and single stream
    Given The server fixture must be running in HTTP mode on loopback with bearer-token authentication.
    When The test initializes a session, opens one GET /mcp event stream for that session, and then attempts to open a second competing stream for the same session.
    And It calls the office_help tool with a progress token while the first stream remains open.
    And It reads SSE data lines until two progress events have been received.
    And It deletes the session and then reads the remainder of the stream.
    Then The first event stream request returns 200 and begins with a connected comment line.
    And A second concurrent stream attempt for the same session returns 409.
    And The office_help call returns 200 and reports success in structured content.
    And The two captured progress notifications report progress values 0 and 1 and use the method notifications/progress.
    And Deleting the session returns 200 and the event stream then closes cleanly.

  @candidate-python-office-http-21c167628d
  # Native: tests/test_office_http.py::test_http_negotiation_origin_size_and_header_guards
  Scenario: Native check: http negotiation origin size and header guards
    Given The server fixture must be running in HTTP mode on loopback with bearer-token authentication.
    When The test POSTs tools/list with a missing protocol-version header, with an unsupported protocol version, with an untrusted Origin header, and with an unacceptable Accept header.
    And It also POSTs an oversized tools/list request body by adding 70000 padding characters.
    And Separately, it opens a raw TCP connection and sends an HTTP request containing duplicate Host headers.
    Then The missing-version request returns 400.
    And The unsupported-version request returns 400.
    And The untrusted-origin request returns 403.
    And The unacceptable Accept request returns 406.
    And The oversized request returns 413.
    And The duplicate-Host raw request produces an HTTP 400 status line.

  @candidate-python-office-http-ec7d94e161
  # Native: tests/test_office_http.py::test_cors_requires_explicit_allowed_origin
  Scenario: Native check: cors requires explicit allowed origin
    Given The server must be started in HTTP mode with --allowed-origin https://review.example.
    When The test sends an OPTIONS preflight request to /mcp with Origin https://review.example and Access-Control-Request-Method POST.
    Then The preflight response returns 204.
    And Access-Control-Allow-Origin is set to https://review.example.
    And Access-Control-Expose-Headers includes Mcp-Session-Id.

  @candidate-python-office-http-eede52074e
  # Native: tests/test_office_http.py::test_legacy_sse_keeps_plain_port_selection_and_auth
  Scenario: Native check: legacy sse keeps plain port selection and auth
    Given The server must be running with the default startup path used by running(tmp_path), without the explicit --http flag in this test.
    When The test sends an unauthenticated GET request to /sse with Accept: text/event-stream.
    Then The response status is 401.

  @candidate-python-office-http-4cab326d79
  # Native: tests/test_office_http.py::test_bind_policy_and_constant_time_token_hook
  Scenario: Native check: bind policy and constant time token hook
    Given The test can modify OFFICE_MCP_HTTP_TOKEN in the process environment.
    When It removes OFFICE_MCP_HTTP_TOKEN, constructs an OfficeServer, and attempts to start streamable HTTP on 0.0.0.0.
    And It then sets OFFICE_MCP_HTTP_TOKEN, constructs a new OfficeServer, and calls authenticate_request once with the correct bearer token and once with no authorization header.
    And It also attempts to start the raw TCP server on 0.0.0.0.
    Then Starting streamable HTTP on a non-loopback address raises ValueError matching Non-loopback.
    And authenticate_request returns a truthy result for the correct bearer token.
    And authenticate_request returns None when the authorization header is missing.
    And Starting raw TCP on a non-loopback address raises ValueError matching raw TCP.

  @candidate-python-office-http-035dcae70e
  # Native: tests/test_office_http.py::test_raw_tcp_remains_loopback_legacy_compatible
  Scenario: Native check: raw tcp remains loopback legacy compatible
    Given The server must be running in --tcp mode on loopback.
    When The test opens a TCP connection, sends a single-line JSON-RPC initialize request, and reads one JSON response line.
    Then The initialize response reports serverInfo.name as office-mcp-server.

  @candidate-python-office-http-a30218ec7a
  # Native: tests/test_office_http.py::test_remote_exceptions_hide_internal_details
  Scenario: Native check: remote exceptions hide internal details
    Given The test can create an OfficeServer instance and register an ad hoc tool.
    When It registers a broken tool that raises RuntimeError with the text sensitive-internal-path.
    And It invokes that tool through process_request_async in a streamable-http request context and serializes the returned result to JSON.
    Then The returned error code is -32603.
    And The serialized response does not contain the string sensitive-internal-path.

  @candidate-python-office-http-e3c9f75feb
  # Native: tests/test_office_http.py::test_session_expiry_releases_stream_and_subscriptions
  Scenario: Native check: session expiry releases stream and subscriptions
    Given The test can construct the private _AsyncStreamableHTTPSession helper and mutate OfficeServer internal session dictionaries.
    When It creates an expired in-memory streamable HTTP session and a matching resource subscription, inserts both into OfficeServer internals, and then calls _expire_streamable_http_sessions.
    Then The expired session entry is removed from _streamable_http_sessions.
    And The matching subscription entry is removed from _resource_session_subscriptions.
    And The session disconnect event is set.
    And The session queue receives a single empty-bytes sentinel.
