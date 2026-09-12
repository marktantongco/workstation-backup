# 05 — Hardening & Layout

## Preventive controls now in place

| Control | Where | Notes |
|---|---|---|
| Pre-commit secret scanner | `hooks/pre-commit` + `core.hooksPath=hooks` | 11 secret families, tab-separated pattern table, blocks on match |
| Transcript redaction | `opencode-history/export.py` | Every archive run scrubs `fbu_/sk-/csk-/gsk_/ghp_/github_pat_/AKIA/Slack/hf_/fw_` before writing |
| Backup hygiene | This repo | Env files install as templates; `<REPLACE_ME>` placeholders; installer verifies and refuses to "silently succeed" with placeholders |
| File perms | `.env-tokens/` 700, env files 600, handoff files 600 umask 077 | |

## Standing rules (learned from this incident)

1. **Never `cat` a token file into a chat/agent session.** Tool output is stored permanently in the session DB. If you must inspect, print masked values only (`${VAR:0:7}…${VAR: -4}`).
2. **Treat every session transcript, DB copy, and log as a disclosure surface.** Rotate anything that ever appeared in one.
3. **Block-test every scanner** — a scanner that can't block is decoration. (The v1 pipe-separator bug passed a "clean" scan on a file containing a fake key.)
4. **A new secret exists exactly once** — on the post-creation banner. If a pasted replacement equals the old value, stop and regenerate.
5. **Verify rotation with positive+negative tests**: new key → 200, old key → 401.
6. **Redact before commit, not after** — git history is forever, and GitHub retains pushed content even after deletion.

## Restore layout (what install.sh builds)

```
~/.config/opencode/            opencode.jsonc, opencode.json, AGENTS.md,
                               agents/ (6), commands/ (24), plugins/ (4 + caveman/), agent-env
~/.env-tokens/                 ai-agent-tokens-full.env, ai-agent-tokens.env,
                               cloudflare-agents.env        ← templates, fill manually
~/freebuff-unified/config.yaml redacted template → fill, then restart service
~/workspace/hooks/pre-commit   secret scanner (core.hooksPath=hooks)
~/workspace/opencode-history/  export.py (from tools/)
/etc/systemd/system/           freebuff-unified, freebuff-proxy, freebuff2api,
                               freebuff2api-admin, aiclient2api
~/.config/systemd/user/        agpx-relay.service
```

Post-install verification:

```bash
opencode debug config | head -n 30
opencode models | wc -l        # ~46
opencode mcp list              # 11 servers
systemctl status freebuff-unified
```
