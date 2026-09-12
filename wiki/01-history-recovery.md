# 01 — History Recovery & Archive

## The problem

After moving the project from `/home/x3` → `/home/x3/workspace`, the opencode TUI session list appeared empty. OpenCode scopes sessions by their stored `directory` column, so only sessions created under the new path were visible.

## Recovery

1. **Located the store**: `~/.local/share/opencode/opencode.db` — 96 MB SQLite, 57 sessions, all intact.
2. **Mapped the schema**: each session row carries its origin `directory`; one `global` project row holds everything.
3. **Reattached** the 40 home-directory sessions to the workspace: single-column `UPDATE` on 40 rows, with a pre-change backup and a full rollback manifest (`opencode-history/reattach_manifest.json`).
4. **Verified** via `opencode session list` from `~/workspace` — all 57 sessions listed.

## The markdown archive

`~/workspace/opencode-history/export.py` renders every session to readable markdown (timestamps, durations, reasoning as blockquotes, full tool calls with output) plus an `INDEX.md`.

Key hardening added after the first run: a **secret-redaction pass** (`fbu_`, `sk-`/`csk-`, `gsk_`, `ghp_`, `github_pat_`, `AKIA`, Slack tokens, later `hf_` and `fw_`) replacing matches with `***REDACTED***` — this caught live keys sitting in old tool-output before they were ever committed to git.

Re-run anytime:

```bash
python3 ~/workspace/opencode-history/export.py
```

## Lessons

- The "missing history" was a path-scoping artifact, not data loss.
- Tool output in agent databases is a **secret spill surface**: anything ever printed to a session transcript should be treated as disclosed.
- Always secret-scan archives *before* the first commit — git history is forever.
