# 2026-09-16 — App-tier auth audit (the nine LAN-exposed UIs/APIs)

Method: owner mapping (container/unit/process) + unauthenticated endpoint
probes from the LAN address + default-credential tests + config inspection.
Root HTML 200 alone is NOT a finding (login shells render 200); the
question is what the APIs behind them allow without credentials.

## Verdicts

| Port | Service | Auth verdict | Evidence |
|---|---|---|---|
| 3200 | aiclient2api (unit) | ✅ gated | `/v1/models` → 401 invalid/missing key |
| 23001 | new-api (container) | ✅ gated | `/v1/models` → 401; factory `root/123456` **rejected**; `/api/status` public-info only |
| 3005 | blacklisted-api (unit) | ✅ gated | `/v1/models` → 401 without + with wrong key (loopback-verified) |
| 3030 | StepUP AI Gateway (x1) | ✅ gated | `/v1/models`, `/api/status` → 401 missing Authorization |
| 8648 | Hermes (x1) | ✅ gated | same → 401 Unauthorized |
| 60001 | owl-api | ✅ gated | 401 without key (prior scan) |
| 18080 | freebuff-unified | ✅ gated by design | 401 without fbu_ key |
| **3002** | **obsidian-anythingllm** | 🚨 **open session** | `/api/setup-complete`: `RequiresAuth:false, AuthToken:false, JWTSecret:false, MultiUserMode:false` — full workspace access to any LAN client |
| **42110** | **obsidian-khoj** | 🚨 **anonymous mode** | `/api/settings`, `/api/agents` → 200 as `default@example.com` |
| **5000** | phantomsignal dashboard | ⚠️ open UI | "Dashboard // PHANTOM SIGNAL" serves unauthenticated; no auth layer found on probed API paths |
| **28088** | image-gen "AI Studio" | ⚠️ open UI | generation UI serves unauthenticated (title: 智能配图) |

## Recommended remediation (decisions, not executed)

1. **anythingllm**: enable multi-user mode + admin password in its admin
   UI (or set `AUTH_TOKEN`/`JWT_SECRET` env and restart) — keeps LAN
   access but adds a gate. Simplest alternative: pin :3002 loopback.
2. **khoj**: set `KHOJ_ADMIN_EMAIL`/`KHOJ_ADMIN_PASSWORD` (or disable
   anonymous mode) — currently it exposes settings/agents state.
3. **phantomsignal / image-gen**: hobby dashboards — either accept the
   LAN trust model explicitly or pin to loopback. If they proxy any
   upstream keys, gate them first.
4. Trust-model note: all four are x3-owned obsidian/ hobby services;
   the LLM gateways that hold provider keys are the ones properly gated.

## Also this session

- **v2.2.0 tagged & released**: CI all green (mermaid, Arch+Debian
  container smoke, shellcheck, release job) →
  github.com/marktantongco/workstation-backup/releases/tag/v2.2.0 —
  release notes auto-built from the README version table.
