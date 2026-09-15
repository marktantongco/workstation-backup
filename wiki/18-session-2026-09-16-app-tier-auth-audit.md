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
| **3002** | **obsidian-anythingllm** | ✅ **resolved**: AUTH_TOKEN+JWT_SECRET wired from gitignored .env; setup-complete now `RequiresAuth/AuthToken/JWTSecret` all true; keyless API → 403 JSON |
| **42110** | **obsidian-khoj** | ✅ **resolved**: `--anonymous-mode` dropped, admin creds moved from hardcoded `admin123` (was committed) to .env; `/api/settings` + `/api/v1/user` → 403 unauthenticated |
| **5000** | phantomsignal dashboard | ✅ **resolved**: publish pinned to `127.0.0.1:5000` (compose, fork-pushed `367d74e`); external refused |
| **28088** | image-gen "AI Studio" | ✅ **resolved**: standalone container recreated with `127.0.0.1:28088:8088` (no compose file existed; run config preserved); external refused |

## Remediation — ALL EXECUTED same day (2026-09-16)

1. **anythingllm**: `AUTH_TOKEN` + `JWT_SECRET` generated into gitignored
   `.env`, wired in compose; container recreated. Verified: setup-complete
   flags all true, keyless API 403, SPA catch-all no longer the API layer.
2. **khoj**: admin creds from .env (weak hardcoded `admin123` removed from
   compose), `--anonymous-mode` dropped. Verified: 403 on settings/user.
3. **phantomsignal**: publish pinned loopback (committed; no write access
   to getphantomsignal upstream → forked to marktantongco/phantomsignal,
   pushed `367d74e`).
4. **image-gen**: had no compose file — recreated via `docker run` with
   identical image/env/restart, publish `127.0.0.1:28088:8088`.
   Peer audit (zero established connections) preceded every recreate.
   Every LAN-facing management/UI surface on this host is now either
   loopback-pinned or auth-gated.

## Also this session

- **v2.2.0 tagged & released**: CI all green (mermaid, Arch+Debian
  container smoke, shellcheck, release job) →
  github.com/marktantongco/workstation-backup/releases/tag/v2.2.0 —
  release notes auto-built from the README version table.

## Addendum: remediation executed (same session)

All four flags above resolved and LAN-verified: anythingllm gated via
.env secrets, khoj de-anonymized + creds from .env, phantomsignal and
image-gen pinned to loopback (zero peers before each recreate).
Remotes: wiki `55f14b9`, phantomsignal fork `367d74e`. **The LAN is now
either loopback-only or auth-gated for every management surface.**
