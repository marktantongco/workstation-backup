# 08 — Service Inventory

## Docker Containers

| Container | Image | Port | Status | Purpose |
|-----------|-------|------|--------|---------|
| thermoptic-thermoptic-1 | thermoptic | :1234 | Up | Chrome MITM proxy (Stealth) |
| thermoptic-chrome-1 | chrome | :14111 | Up | Headless Chrome for MITM |
| thermoptic-proxyrouter-1 | proxyrouter | — | Up | Proxy routing for Thermoptic |
| phantomsignal | phantomsignal | :5000 | Up (healthy) | Rotating residential proxy pool |
| obsidian-khoj | khoj | — | Up | AI search over Obsidian vault |
| obsidian-anythingllm | anythingllm | — | Up (healthy) | Local LLM workspace |
| obsidian-qdrant | qdrant | :6333/:6334 | Up | Vector database |
| obsidian-khoj-db | postgres | — | Up | Khoj PostgreSQL backend |
| freebuff-proxy-trefeon | freebuff-proxy | — | Up (healthy) | Freebuff Trefeon proxy |
| image-gen | image-gen | — | Up | Image generation service |
| codex-proxy | codex-proxy | — | Up (healthy) | Codex API proxy |
| chatgpt2api | chatgpt2api | — | Up | ChatGPT → OpenAI API |
| new-api | new-api | — | Up | New API gateway |
| freebuff-proxy | freebuff-proxy | — | Up (healthy) | Freebuff proxy |
| owl-api | owl-api | :3457 | Up (healthy) | OWL API |
| owl-prometheus | prometheus | :9091 | Up (healthy) | OWL Prometheus metrics |
| owl-gateway | owl-gateway | — | Up (healthy) | OWL gateway |
| headroom-default | headroom | :8091 | Up (healthy) | Context compression |
| stepup-ai-gateway | stepup-ai-gateway | :8787 | Up (healthy) | Unified AI gateway |

## Systemd Services (Custom)

| Service | Port | Description |
|---------|------|-------------|
| aiclient2api.service | :3002 | AIClient2API — Kiro/Antigravity/Grok/Codex unified OpenAI-compatible hub |
| autoclaw-proxy.service | :31000 | AutoClaw GLM OpenAI-compatible proxy |
| blacklisted-api.service | :3001/:3101 | BlacklistedAIProxy multi-provider gateway |
| cdp-proxy-interceptor.service | :1455/:1457 | CDP Proxy Interceptor (Deno MITM for Playwright/Puppeteer) |
| freebuff-proxy.service | — | Freebuff Proxy (Go/Fiber + Stealth) |
| freebuff-unified.service | — | Freebuff Unified API Gateway |
| freebuff2api.service | — | Freebuff2API Gateway (Python/FastAPI) |
| freebuff2api-admin.service | — | Freebuff2API Admin Panel |
| hermes-sidecar.service | — | Hermes Stealth Sidecar (@kori_xyz/hermes) |
| kiroproxy.service | :3103/:3113 | KiroProxy — Kiro multi-account OpenAI/Anthropic/Gemini gateway |
| lemonade-server.service | — | Lemonade Server |
| owl-agent.service | — | OWL Agent |
| owl-dns-synergy.service | — | OWL DNS Synergy |
| owl-port-guardian.service | — | OWL Port Guardian |

## OpenCode Providers

| Provider | Endpoint | Auth | Models |
|----------|----------|------|--------|
| opencode (Zen) | remote | `{env:OPENCODE_ZEN_*}` | claude-opus-4-5, gemini-3-flash-preview |
| opencode-go | remote | `{env:OPENCODE_GO_UKAJ}` | qwen3-coder-plus |
| cloudflare | Cloudflare Workers | `{env:CLOUDFLARE_*}` | gemini-3-flash-preview |
| ollama | http://127.0.0.1:11434 | local | qwen2.5:3b, deepseek-r1:1.5b, heretic-qwen3-0.6b, gemma4:e2b |
| blacklisted | http://127.0.0.1:3001 | local | gemini-3-flash-preview, claude-opus-4-5, qwen3-coder-plus, grok-4.6 |

## MCP Servers

| Server | Transport | Capabilities |
|--------|-----------|--------------|
| caveman | stdio | Compressed communication modes |
| headroom | stdio | Context compression/retrieval |
| github | http ({env:GITHUB_PAT}) | 26 tools: repos, issues, PRs, code search |
| octocode | stdio | Code research, GitHub search |
| parallel-search | stdio | Web search + fetch |
| graphify | stdio | Knowledge graph, PR impact |
| serena | stdio (uvx) | Code analysis |
| skillspector | stdio (venv) | Skill lint |
| ruv-swarm | stdio (npx) | Swarm orchestration |
| filesystem | stdio | File I/O |
| memory | stdio | Persistent memory |

## Skills (40 Production)

| Zone | Skills |
|------|--------|
| activate | brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers, verification-before-completion, writing-plans, writing-skills |
| build | scaffold-cli, scaffold-nextjs, codebase-architecture, ui-design, ui-animation, typography-audit, ax-audit, dx-audit, product-design, presentation-creator, copywriting, docs-writing, readme-creator, optimise-seo, seo-program |
| validate | pr-reviewer, pr-creator, pr-babysitter, tidy |
| playbook | autoresearch, canvas, defuddle, document-findings, evaluate-candidates, find-alternatives, search-ai-tools, search-repos |
| monetize | autoship |
| system | agent-skills-creator, agents-md, customize-opencode, save, save-md, think, wiki, wiki-cli, wiki-fold, wiki-ingest, wiki-lint, wiki-mode, wiki-query, wiki-retrieve |

## Listening Ports (61 Total)

| Port | Service | Bind | Protocol |
|------|---------|------|----------|
| 1455 | CDP Proxy | 127.0.0.1 | HTTP |
| 1457 | CDP Proxy | 0.0.0.0 | HTTP |
| 1234 | Thermoptic | 127.0.0.1 | HTTPS |
| 14111 | Chrome | 127.0.0.1 | HTTP |
| 2019 | Headroom | 127.0.0.1 | HTTP |
| 3000 | Grafana | * | HTTP |
| 3001 | BlacklistedAIProxy | 0.0.0.0 | HTTP |
| 3002 | AIClient2API | 0.0.0.0 | HTTP |
| 3030 | OpenCode | * | HTTP |
| 3100 | AIClient2API (master) | * | HTTP |
| 3101 | BlacklistedAIProxy (master) | 127.0.0.1 | HTTP |
| 3103 | KiroProxy | * | HTTP |
| 3113 | KiroProxy (master) | 127.0.0.1 | HTTP |
| 3200 | KiroProxy (alt) | 0.0.0.0 | HTTP |
| 3457 | OWL API | 0.0.0.0 | HTTP |
| 5000 | PhantomSignal | 0.0.0.0 | HTTP |
| 6333 | Qdrant | 0.0.0.0 | HTTP |
| 6334 | Qdrant (gRPC) | 0.0.0.0 | gRPC |
| 7897 | AGPX-Relay | 0.0.0.0 | HTTP |
| 8000 | Autoclaw | 127.0.0.1 | HTTP |
| 8001 | Autoclaw (alt) | 127.0.0.1 | HTTP |
| 8080 | KiroProxy / grokbuild | * | HTTP |
| 8081 | Thermoptic | 0.0.0.0 | HTTP |
| 8091 | Headroom | 127.0.0.1 | HTTP |
| 8443 | Thermoptic (TLS) | * | HTTPS |
| 8648 | OWL | 0.0.0.0 | HTTP |
| 8787 | Freebuff | 127.0.0.1 | HTTP |
| 8788 | Freebuff (alt) | 0.0.0.0 | HTTP |
| 9000 | StepUp | 127.0.0.1 | HTTP |
| 9090 | Prometheus | 0.0.0.0 | HTTP |
| 9091 | OWL Prometheus | * | HTTP |
| 9092 | Grafana (alt) | 127.0.0.1 | HTTP |
| 9093 | Grafana (alt2) | 127.0.0.1 | HTTP |
| 9094 | OWL | 0.0.0.0 | HTTP |
| 9095 | OWL (alt) | 0.0.0.0 | HTTP |
| 9222 | Deno CDP | 127.0.0.1 | HTTP |
