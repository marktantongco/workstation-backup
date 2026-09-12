# AGENTS.md — Unified OpenCode Ecosystem

This file is the canonical instruction set for all agents (opencode `build`, `yolo`, `devops`, `code-reviewer`, `auto-fixer`).
Loaded via `instructions: ["AGENTS.md", ".config/opencode/AGENTS.md"]` in `opencode.jsonc`.

## Stack
- **CLI**: `opencode` 1.18.29 (`~/.opencode/bin/opencode` via `~/.config/opencode/opencode.jsonc`)
- **Providers**: `opencode` (Zen `sk-mrYv...`), `opencode-go` (Go $10 `sk-uKaj...`), `cloudflare` (`{env:CLOUDFLARE_*}`), `ollama` (local `qwen2.5:3b`, `deepseek-r1:1.5b`, `heretic-qwen3-0.6b`, `gemma4:e2b`)
- **MCP**: 11 unified servers in `opencode.jsonc:mcp` — `serena` (uvx), `headroom` (`~/.local/bin/headroom`), `skillspector` (SkillSpector venv), `ruv-swarm` (npx), `filesystem`, `github` (`{env:GITHUB_PAT}`), `fetch`, `brave-search` (`{env:BRAVE_API_KEY}`), `memory`, `sqlite`, `docker`. Legacy `~/.opencode/mcp.json` is now mirrored, canonical is `opencode.jsonc`.
- **Plugins**: `@frankhommers/opencode-yolo` + `file://plugins/rtk.ts` (RTK token saver, `rtk >=0.47`) + `file://plugins/freebuff-plugin.ts`. Auto-discovered from `.config/opencode/plugins/`.
- **Skills**: 30 prod skills from `https://github.com/marktantongco/ai-agent-skills` v24.0.0 at `~/.agents/skills/` (canonical), symlinked to `~/.claude/skills/` (29) and `~/.opencode/skills` (symlink). Zones: activate, build, validate, playbook, monetize, system. See `~/.agents/SKILLS.md` for catalog.
- **Agents**: `build` (primary, default), `yolo` (primary, auto-approve), `devops`/`auto-fixer` (subagent), `code-reviewer` (primary, read-only). Definitions in `~/.config/opencode/agents/*.md` + inline `agent:{}` in `opencode.jsonc`.
- **Env**: `~/.config/opencode/agent-env` (derived from `~/.env-tokens/ai-agent-tokens-full.env`, 30999 bytes, includes `GITHUB_PAT`, `BRAVE_API_KEY`, `CLOUDFLARE_*`, `OPENCODE_*`). Source: do not edit by hand, edit `ai-agent-tokens-full.env` then regenerate.

## Commands
- `opencode` — TUI (default), `opencode run "msg"` — headless, `opencode models` — 46 models, `opencode mcp list` — 11 servers, `opencode debug config` — resolved config, `opencode debug agent <name>` — agent details
- Skills: trigger via natural language per `SKILL.md` frontmatter (e.g. `chain-of-thought`, `ui-design`, `optimise-seo`). Opencode scans `~/.agents/skills/**/SKILL.md` automatically.
- MCP: `serena` (code analysis), `headroom` (headroom), `skillspector` (skill lint), `ruv-swarm` (swarm), `filesystem`/`github`/`fetch` (I/O). Requires env vars from `agent-env`.

## Permissions
Top-level `permission: { "*": "allow", ... }` is permissive (yolo). Per-agent overrides in `agents/*.md` tighten: `code-reviewer` denies edit, `auto-fixer` allows edit but read-only checks. `external_directory: allow` enables `~/`, `/tmp`. See `opencode.jsonc:6` for full matrix.

## Conventions
- Skills are versioned at 24.0.0, do not mix with deprecated `.opencode/config.json` `mcp.servers` list — that file is now synced to 11 servers for legacy parity.
- Plugins are ESM, hot-reloaded; after editing `opencode.jsonc` or `plugins/*.ts`, restart opencode.
- Tokens: `CLOUDFLARE_API_KEY`/`ACCOUNT_ID`, `GITHUB_PAT`, `BRAVE_API_KEY` must be in env or `agent-env`; placeholders `<your-token>` replaced with `{env:VAR}`.

## Validation
After any ecosystem change, run:
```
opencode debug config | python3 -m json.tool | head -n 30
opencode models | wc -l   # expect 46
opencode mcp list          # expect 11, 6 connected
opencode debug skill | head -n 20
```

<!-- caveman-begin -->
Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: [thing] [action] [reason]. [next step].
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: /caveman lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra
Stop: "stop caveman" or "normal mode"

Auto-Clarity: drop caveman for security warnings, irreversible actions, user confused. Resume after.

Boundaries: code/commits/PRs written normal.
<!-- caveman-end -->
