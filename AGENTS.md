# Agent guidance

Follow the workspace Git and coding rules. Read relevant files before editing, preserve unrelated working files, stage bounded changes explicitly, and verify before committing.

## Cross-agent priority messages

Use the `chat` tool for coordination; timeline replies are not a substitute for priority delivery.

- Use `mode: "steer"` for scope changes, stop/hold instructions, release or pin corrections, safety blockers, and decisions needed to unblock another agent.
- Use `mode: "queue"` only for routine progress that does not need immediate action.
- Prefer `target_agent_name` with the recipient's `@alias` over raw chat or session IDs.
- Include the current repository revision and shared release tag/commit, the requested action, its owner, and which earlier notice is superseded. Read current pins instead of copying an old message.
- On receipt, acknowledge the latest applicable state once. Do not replay historical release notices, obsolete blockers or repeated acknowledgements. Report again only when the state changes or a decision is needed.
- If messages arrive out of order, verify the current pin and explicit owner decision before acting. A newer correction supersedes older notices; do not roll back to an obsolete release.

## Shared fixture ownership

The current shared release is recorded in `tests/fixtures-pin.json` and the `references/fixtures-ooxml` gitlink. Resolve fixtures by stable ID through the central schema-2 manifest. Do not create local fixture copies, compatibility roots or symlinks, or change a shared tag from this consumer repository.

Canonical behaviour reconciliation belongs to the central repository. Candidate catalogue text grants no execution credit; retain native assertions and report semantic gaps separately from measured test results.
