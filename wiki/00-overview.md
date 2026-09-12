# 00 — Overview & Timeline

Complete record of the September 11–12, 2026 session on the `x3` workstation: history recovery, security incident response, key rotation, database scrub, and hardening.

## Master timeline

| Date | Action | Outcome |
|---|---|---|
| Sep 11 | Recovered opencode session history from `~/.local/share/opencode/opencode.db` (96 MB SQLite, 57 sessions) | History was never lost — sessions were scoped to the old `/home/x3` directory |
| Sep 11 | Built `export.py` — session → markdown exporter | 57 transcripts + `INDEX.md` (7.6 MB) in `~/workspace/opencode-history/` |
| Sep 11 | Reattached 40 `/home/x3` sessions to `~/workspace` via single-column `directory` update | All sessions visible from workspace; rollback manifest kept |
| Sep 11 | Exported full deep-research transcript (245 messages) on request | `2026-09-09_performance-tuning-deep-research-tools_f7b510e1.md` |
| Sep 11 | **Pre-commit secret scan before first commit found live API keys in transcripts** | Added redaction pass to `export.py`, regenerated archive clean before committing |
| Sep 11 | Committed archive (`06a0927`), then repo files (`82a018e`) | Repo: 2 commits, no remote |
| Sep 11 | Rotated both locally-issued `fbu_` keys (freebuff-unified proxy) | New key → HTTP 200, old → 401; all 3 consumer files rewired; service restarted |
| Sep 11 | **GitHub audit: 11 of 12 leaked tokens STILL VALID, 7 with full admin scopes** | No abuse evidence (SSH keys pre-date leak, events match own work) |
| Sep 11 | Scrubbed 587 DB rows + tool-output caches + logs of all secret material | `secure_delete=ON`, WAL truncation; final sweep zero findings |
| Sep 12 | Installed pre-commit secret scanner (`hooks/pre-commit` + `core.hooksPath`) | Blocks 11 secret families; initial pipe-separator bug found via block-test, fixed with tab-separated patterns |
| Sep 12 | Provider activity sweep (22 of 25 keys valid, 3 already dead) | No anomalous usage; risk profile = quota burn, GitHub = real blast radius |
| Sep 12 | Recreated + committed `API_KEY_ROTATION_CHECKLIST.md` (lost from disk once, now under git) | Commit `f588c56` |
| Sep 12 | GitHub liveness re-check: **18/18 candidates still valid (12 distinct tokens), zero revoked** | Rotation remains open |
| Sep 12 | Started GitHub rotation via device flow; user-code expired un-authorized | Rotation still pending — see `04-rotation-status.md` |
| Sep 12 | Zen rotation attempt: pasted values turned out to be the old leaked keys; one new key rejected (403/Cloudflare 1010) | No wiring performed; see `04-rotation-status.md` |
| Sep 12 | Built this backup repo (secret-free), installer, wiki | `workstation-backup` → private repo `marktantongco/workstation-backup` |

## Where everything lives

- **Transcripts archive**: `~/workspace/opencode-history/` (60 sessions, redacted, git-committed)
- **Rotation checklist**: `~/workspace/opencode-history/API_KEY_ROTATION_CHECKLIST.md` (git-committed)
- **Secret scanner**: `~/workspace/hooks/pre-commit` (active via `core.hooksPath=hooks`)
- **Live token source of truth**: `~/.env-tokens/ai-agent-tokens-full.env` (chmod 600, never commit)
- **Backup of all of it**: this repo

## Open items (as of Sep 12)

1. 🔴 Revoke the 12 leaked GitHub tokens — checklist tier 1
2. 🟡 Rotate 5 OpenCode Zen-family keys (attempt failed; redo carefully)
3. 🟡 Rotate remaining third-party keys per checklist tiers (Groq, DeepSeek, OpenRouter, Cerebras, MiniMax, Fireworks, HuggingFace, Moonshot)
