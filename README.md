# workstation-backup

Complete, **secret-free** backup of the `x3` workstation AI-agent ecosystem (opencode + Freebuff stack), with a one-command installer and a wiki documenting every security action taken in September 2026.

> 🔐 No API keys are stored here. All env files install as `.template` files with `<REPLACE_ME>` placeholders — fill them from your password manager after install.

## What's inside

| Path | Contents |
|---|---|
| `opencode/` | `opencode.jsonc`, `opencode.json`, `AGENTS.md`, 6 agent defs, 24 commands, 4 plugins (incl. caveman) — all verbatim, `{env:VAR}`-referenced |
| `env/` | Redacted templates: `ai-agent-tokens-full.env`, `ai-agent-tokens.env`, `cloudflare-agents.env`, `agent-env` |
| `services/systemd/` | freebuff-unified, freebuff-proxy, freebuff2api, freebuff2api-admin, aiclient2api (system) + agpx-relay (user) |
| `services/freebuff-unified/` | Live `config.yaml` as redacted template + upstream `config.example.yaml` |
| `workspace/` | Git `pre-commit` secret scanner (11 secret families, tab-separated patterns) |
| `tools/` | `export.py` — opencode session-history → markdown exporter with secret redaction |
| `wiki/` | Full action log: history recovery, leak, scrub, rotation status, hardening |
| `install.sh` | One-command restore |

## Restore on a fresh machine

```bash
git clone git@github.com:marktantongco/workstation-backup.git
cd workstation-backup
./install.sh          # backs up any existing files, installs everything
nano ~/.env-tokens/ai-agent-tokens-full.env   # replace <REPLACE_ME> with real keys
sudo systemctl restart freebuff-unified
opencode debug config  # verify
```

## Verify after install

```bash
opencode debug config | head -n 30   # config parses, providers resolve
opencode models | wc -l              # expect ~46
opencode mcp list                    # expect 11 servers
systemctl status freebuff-unified    # active (running)
```
