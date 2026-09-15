# 06 — Ecosystem Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    OMARCHY WORKSTATION (ThinkPad T16v Gen I)        │
│                    Intel Core Ultra 9 285HX / RTX Pro 3500         │
│                    93GB RAM / 16TB RAID0 NVMe / NVIDIA 580.86.04   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐ │
│  │ OpenCode CLI │  │ Claude Code  │  │ Cursor / Codex / Codex-   │ │
│  │ (1.18.29)    │  │ (CLI)        │  │ CLI (Vercel)             │ │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────────┘ │
│         │                 │                      │                  │
│         ▼                 ▼                      ▼                  │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │              BLACKLISTED AIPROXY (:3001/:3101)              │  │
│  │              Multi-provider AI gateway                      │  │
│  │  gemini-3-flash-preview (Cloudflare)                       │  │
│  │  claude-opus-4-5 (OpenCode Zen)                            │  │
│  │  qwen3-coder-plus (OpenCode-Go)                            │  │
│  │  grok-4.6 (via grokbuild-proxy :8080)                      │  │
│  └─────────────────────────────┬───────────────────────────────┘  │
│                                │                                   │
│  ┌─────────────────────────────┼───────────────────────────────┐  │
│  │              PROVIDER LAYER                                  │  │
│  │                                                              │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────────┐ │  │
│  │  │ Cloudflare│  │ OpenCode │  │OpenCode- │  │ Ollama     │ │  │
│  │  │ Workers  │  │ Zen      │  │Go (¥10)  │  │ (local)    │ │  │
│  │  │ :443     │  │ (remote) │  │ (remote) │  │ :11434     │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └────────────┘ │  │
│  │                                                              │  │
│  │  ┌──────────────────────────────────────────────────────┐   │  │
│  │  │ GROK BUILD PIPELINE                                   │   │  │
│  │  │ grokbuild-proxy (:8080) ← grok-register (daemon)     │   │  │
│  │  │ Multi-account, OAuth, Anthropic protocol              │   │  │
│  │  └──────────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              PROXY / EGRESS LAYER                            │  │
│  │                                                              │  │
│  │  Thermoptic (:1234) ─── Chrome MITM ─── Chrome (:14111)    │  │
│  │  PhantomSignal (:5000) ─── Rotating residential proxies     │  │
│  │  Mullvad VPN ─── WireGuard tunnel                           │  │
│  │  Tailscale ─── Mesh VPN (100.x.x.x)                        │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              APPLICATION LAYER                               │  │
│  │                                                              │  │
│  │  AIClient2API (:3002) ─── Kiro/Antigravity/Grok/Codex hub  │  │
│  │  Freebuff stack ─── 4 services (proxy, unified, 2api, admin)│  │
│  │  KiroProxy ─── Kiro multi-account gateway                   │  │
│  │  AutoClaw (:31000) ─── GLM proxy                            │  │
│  │  Hermes-sidecar ─── Stealth for freebuff-unified            │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              DATA / STORAGE LAYER                            │  │
│  │                                                              │  │
│  │  Obsidian stack ─── Khoj + AnythingLLM + Qdrant            │  │
│  │  Headroom (:8091) ─── Context compression                   │  │
│  │  StepUp AI Gateway (:8787) ─── Unified AI gateway           │  │
│  │  OWL stack ─── Gateway + Prometheus + API (:3457)           │  │
│  │  Qdrant (:6333/:6334) ─── Vector database                   │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              MONITORING / OPS LAYER                          │  │
│  │                                                              │  │
│  │  Prometheus (:9090) ─── Metrics                              │  │
│  │  Grafana (:3000) ─── Dashboards                             │  │
│  │  Prometheus (:9092, loopback) ─── AI metrics                 │  │
│  │  freebuff-unified dashboard (:9091, loopback) ─── Gateway UI  │  │
│  │  Headroom (:8091) ─── Context stats                         │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Request Path (OpenCode → Provider)
```
User → OpenCode CLI
  → opencode.jsonc (provider selection)
    → provider endpoint (Cloudflare Workers / OpenCode Zen / OpenCode-Go / BlacklistedAIProxy)
      → if BlacklistedAIProxy:
          → ensemble-synthesizer.json (model routing)
          → provider-specific handler
          → if Grok: → grokbuild-proxy (:8080) → Grok API
          → if Gemini: → Cloudflare Workers → Gemini API
          → if Claude: → OpenCode Zen → Anthropic API
          → if Qwen: → OpenCode-Go → Alibaba API
      → response → OpenCode CLI → user
```

### Grok Account Lifecycle
```
grok.py (register)
  → curl_cffi + YesCaptcha → new grok.com account
  → writes keys/grok.txt, keys/accounts.txt
  → sso_to_cpa.py
      → extracts SSO token
      → PKCE flow → OAuth access_token + refresh_token
      → writes auths/xai-*.json
  → auto_replenish.py (daemon)
      → monitors pool size
      → registers new accounts on demand
      → converts SSO → OAuth automatically
  → token_daemon.py (daemon)
      → background refresh loop
      → grokbuild-proxy also does on-demand refresh
  → grokbuild-proxy (:8080)
      → multi-account pool with session stickiness
      → failover + cooldown
      → Anthropic /v1/messages + OpenAI /v1/chat/completions
      → Admin Web UI (:8080/admin)
```

### Proxy Egress Path
```
Browser/App → Thermoptic (:1234, MITM)
  → Chrome fingerprint injection
  → TLS interception (own CA)
  → upstream via PhantomSignal
    → rotating residential proxy pool
    → or direct (no proxy)
```

## Network Topology

```
                    ┌─────────────────┐
                    │   Internet      │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────┴────┐   ┌────┴────┐   ┌────┴────┐
         │ Mullvad │   │Tailscale│   │ Direct  │
         │ VPN     │   │ Mesh    │   │         │
         └────┬────┘   └────┬────┘   └────┬────┘
              │              │              │
              └──────────────┼──────────────┘
                             │
                    ┌────────┴────────┐
                    │  NIC (enp0s31f6)│
                    │  10.220.104.168 │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────┴────┐   ┌────┴────┐   ┌────┴────┐
         │ Docker  │   │ Systemd │   │ GNOME   │
         │ Bridge  │   │ Services│   │ Desktop │
         └────┬────┘   └────┬────┘   └─────────┘
              │              │
    ┌─────────┼─────────┐   │
    │         │         │   │
┌───┴───┐ ┌───┴───┐ ┌───┴───┐
│Thermo │ │Owl    │ │StepUp │
│optic  │ │Stack  │ │AI GW  │
│Phanto │ │Obsidian│ │Freebuff│
│Signal │ │Stack  │ │Stack  │
└───────┘ └───────┘ └───────┘
```

## Port Allocation Summary

| Port Range | Services | Bind |
|------------|----------|------|
| 1000-1999 | Thermoptic (1234), Chrome (14111), CDP (1455,1457) | loopback |
| 2000-2999 | Headroom (:2019, :8091) | loopback |
| 3000-3999 | AIClient2API (:3002), BlacklistedAIProxy (:3001/:3101), KiroProxy (:3103/:3113), OpenCode (:3030) | mixed |
| 5000-5999 | PhantomSignal (:5000) | 0.0.0.0 |
| 6000-6999 | Qdrant (:6333/:6334) | 0.0.0.0 |
| 7000-7999 | AGPX-Relay (:7897) | 0.0.0.0 |
| 8000-8999 | Autoclaw (:8000/:8001), KiroProxy (:8080), Thermoptic (:8443), Headroom (:8091), Freebuff (:8787/:8788) | mixed |
| 9000-9999 | freebuff-unified dashboard (:9091), Prometheus (:9092), OWL (:9094/:9095) | mixed |
