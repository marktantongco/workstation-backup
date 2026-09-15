# 08 — Service Inventory

> Refreshed **2026-09-15** after the proxy-consolidation cleanup (see `12-proxy-transport-review-2026-09-14.md` and the 2026-09-15 session record). Every survivor has 24h traffic evidence or an active-session owner.

## Production chain (verified live traffic)

```
clients ──► freebuff-unified :18080 (auth + rate-limit, passthrough)
              └──► freebuff-proxy-trefeon :3457 (Go pool/sessions/quota + admin UI, en-patch baked in)
                     └──► codebuff.com
```

## Docker Containers (live)

| Container | Image | Port | Status | Purpose |
|-----------|-------|------|--------|---------|
| freebuff-proxy-trefeon | freebuff-proxy:latest | 127.0.0.1:3457 (loopback-pinned 2026-09-16) | Up (healthy) | **Production Freebuff proxy** (pool/sessions/quota + admin dashboard; EN UI patch v0.6.2 baked into image) |
| thermoptic-thermoptic-1 | thermoptic-thermoptic | 127.0.0.1:1234 | Up | Chrome MITM proxy (Stealth) |
| thermoptic-chrome-1 | thermoptic-chrome | 127.0.0.1:14111 | Up | Headless Chrome for MITM |
| thermoptic-proxyrouter-1 | thermoptic-proxyrouter | 127.0.0.1:31280 | Up | Proxy routing for Thermoptic |
| phantomsignal | phantomsignal | 0.0.0.0:5000 | Up (healthy) | Rotating residential proxy pool |
| turnstile-solver | turnstile-solver | 0.0.0.0:8088 | Up (healthy) | Turnstile CAPTCHA solver |
| obsidian-khoj | khoj | 0.0.0.0:42110 | Up | AI search over Obsidian vault |
| obsidian-anythingllm | anythingllm | 0.0.0.0:3002 | Up (healthy) | Local LLM workspace |
| obsidian-qdrant | qdrant | 0.0.0.0:6333/:6334 | Up (healthy) | Vector database |
| obsidian-khoj-db | pgvector | (internal) | Up (healthy) | Khoj PostgreSQL backend |
| new-api | calciumion/new-api | 0.0.0.0:23001 | Up | New API gateway |
| image-gen | image-gen | 0.0.0.0:28088 | Up | Image generation service |
| owl-api | owl-dns-synergy-api-server | 0.0.0.0:60001, 0.0.0.0:9094 | Up (healthy) | OWL API |
| owl-prometheus | prom/prometheus | 0.0.0.0:9095 | Up (healthy) | OWL Prometheus metrics |
| owl-gateway | owl-dns-synergy-gateway | 0.0.0.0:60010 | Up (healthy) | OWL gateway |
| headroom-default | headroom | (none published) | Up (healthy) | Context compression |

**Removed 2026-09-15** (evidence-backed, recoverable from notes below):
`freebuff-proxy` (ghcr.io/hengxin666 — unhealthy 2 days, EACCES crash-loop, no ports; data dir bind-mount at `/home/x3/aiworkspace/freebuff-proxy/data/` preserved on disk), `codex-proxy`, `chatgpt2api`, `stepup-ai-gateway`, `obsidian-orchestrator`, `owl-dns-tunnel` + stray exited containers (pruned).

## Systemd Services (Custom)

| Service | Port | Status | Description |
|---------|------|--------|-------------|
| freebuff-unified.service | :18080 | active | Freebuff Unified API Gateway — production front door (auth/rate-limit) |
| blacklisted-api.service | :3005 | active | BlacklistedAIProxy multi-provider gateway (9.4k req/24h) |
| grokbuild-proxy.service | :8080 | active | GrokBuild proxy (108 req/24h) |
| nim-relay (codex-nvidia-proxy) | :15721 | active | NVIDIA NIM relay |
| kiropool.service | :8092 | active | Kiro CLI pool proxy |
| cdp-proxy-interceptor.service | :9222 | active | Deno CDP MITM hook for Playwright sessions (idle; revisit if unused a week) |
| freebuff-proxy.service | — | **disabled** | Was crash-looping on the :3457 port conflict with the container long before 2026-09-15; container is the canonical serving instance |
| freebuff2api.service | :8000/:8001 | **disabled** | Zero requests in 24h; superseded by the trefeon Go proxy |
| freebuff2api-admin.service | — | **disabled** | Companion admin panel (same evidence) |
| hermes-sidecar.service | :3101 | **disabled** | Zero traffic in 24h; stealth transport off in config |
| lmarena-stealth-proxy.service | :3103 | **disabled** | Zero traffic in 24h (journal "3101/3103" hits were timestamp false-positives) |
| aiclient2api.service | :3002 | see live state | AIClient2API hub |
| autoclaw-proxy.service | :31000 | see live state | AutoClaw GLM proxy |
| kiroproxy.service | :3103/:3113 | see live state | KiroProxy gateway |
| lemonade-server.service | — | see live state | Lemonade Server |
| owl-agent.service | — | active | OWL Agent (Prometheus+Grafana monitoring, 206 MB) |
| owl-dns-synergy.service | — | see live state | OWL DNS Synergy |
| owl-port-guardian.service | — | see live state | OWL Port Guardian |

## OpenCode Providers

| Provider | Endpoint | Auth | Models |
|----------|----------|------|--------|
| opencode (Zen) | remote | `{env:OPENCODE_ZEN_*}` | claude-opus-4-5, gemini-3-flash-preview |
| opencode-go | remote | `{env:OPENCODE_GO_UKAJ}` | qwen3-coder-plus |
| cloudflare | Cloudflare Workers | `{env:CLOUDFLARE_*}` | gemini-3-flash-preview |
| ollama | http://127.0.0.1:11434 | local | qwen2.5:3b, deepseek-r1:1.5b, heretic-qwen3-0.6b, gemma4:e2b |
| blacklisted | http://127.0.0.1:3005 | local | gemini-3-flash-preview, claude-opus-4-5, qwen3-coder-plus, grok-4.6 |

## MCP Servers

| Server | Transport | Capabilities |
|--------|-----------|--------------|
| caveman | stdio | Compressed communication modes |
| headroom | stdio | Context compression/retrieval |
| github | http ({env:GITHUB_PAT}) | 26 tools: repos, issues, PRs, code search (enabled 2026-09-13) |
| octocode | stdio | Code research, GitHub search |
| parallel-search | stdio | Web search + fetch |
| graphify | stdio | Knowledge graph, PR impact |
| serena | stdio (uvx) | Code analysis (disabled) |
| skillspector | stdio (venv) | Skill lint (disabled) |
| ruv-swarm | stdio (npx) | Swarm orchestration (disabled) |
| filesystem | stdio | File I/O (disabled) |
| memory | stdio | Persistent memory (disabled) |

## Skills

**Production (40)**: marktantongco/ai-agent-skills v24.0.0 at `~/.agents/skills/`, symlinked to `~/.claude/skills/` and `~/.opencode/skills`. Zones: activate, build, validate, playbook, monetize, system. Catalog: `~/.agents/SKILLS.md` (mirrored in `agents/SKILLS.md` in this repo).

**External (6, installed 2026-09-15 via skills.sh)**: find-skills (vercel-labs/skills), github-research (lingzhi227), parallel-web (k-dense-ai/scientific-skills), parallel-deep-research + parallel-web-search (parallel-web/parallel-agent-skills), deep-researcher (zenobi-us/dotfiles).

## Integrations

**freebuff-en-patch** (`integrations/freebuff-en-patch/`): English UI patch for the trefeon admin dashboard, generated by inverting Kfowever/freebuff-zh-patch v0.6.1. 90 inverse patterns (84 mechanical + 6 function-based), CJK fast-reject runtime, zh-patch observer displacement. Baked into the canonical build (`frontend/index.html` tag + `frontend/public/assets/freebuff-en.js`) and shipped in image `freebuff-proxy:latest` (built 2026-09-15). Served at `/admin/assets/freebuff-en.js` (auth-exempt route). Tools: `tools/gen-en-patch.mjs` (regenerate), `tools/patch-admin-en.sh` (install/status/restore), `tests/roundtrip.test.mjs` (passes).
