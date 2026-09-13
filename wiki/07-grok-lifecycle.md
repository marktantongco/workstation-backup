# 07 — Grok Account Lifecycle Pipeline

## Overview

Automated Grok account registration, OAuth token management, and production serving.
Replaces manual MV3 cookie-extract extension with fully automated pipeline.

## Components

### 1. grok-register (Python) — Account Factory

**Location:** `/home/x3/workspace/grok-register` (TBD — clone from github.com/aidil2105/grok-register)

**Purpose:** Register new Grok accounts, extract SSO, mint OAuth tokens.

| Script | Function | Dependencies |
|--------|----------|--------------|
| `grok.py` | Register accounts via curl_cffi + YesCaptcha | curl_cffi, YesCaptcha API key |
| `sso_to_cpa.py` | Convert SSO → OAuth (PKCE flow) | curl_cffi, account credentials |
| `auto_replenish.py` | Daemon: monitor pool, register on demand | grok.py, sso_to_cpa.py |
| `token_daemon.py` | Daemon: background token refresh | OAuth refresh_token |

**Output files:**
```
keys/
├── grok.txt              # Grok API keys (one per line)
├── accounts.txt          # Account credentials (email:password)
auths/
├── xai-{uuid1}.json      # OAuth tokens (access + refresh)
├── xai-{uuid2}.json
└── ...
```

**Required secrets (from user):**
- `YESCAPTCHA_KEY` — YesCaptcha API key for CAPTCHA solving
- Email provider credentials (for account registration)

### 2. grokbuild-proxy (Go) — Production Server

**Location:** `/home/x3/workspace/grokbuild-proxy` (TBD — clone from github.com/GreyGunG/grokbuild-proxy)

**Purpose:** Serve Grok API with multi-account management, Anthropic protocol support.

**Port:** `:8080`

**Features:**
- Anthropic `/v1/messages` (Claude Code native)
- OpenAI `/v1/chat/completions`
- OAuth Device Login
- Multi-account pool with session stickiness
- Failover + cooldown
- Admin Web UI (`:8080/admin`)
- Prometheus metrics (`:8080/metrics`)
- Health checks (`:8080/healthz`, `/readyz`)
- SSO batch import sidecar

**Config:** `.env` file with imported SSO tokens or auth JSON files.

### 3. BlacklistedAIProxy — Gateway

**Port:** `:3001` (public) / `:3101` (master)

**Role:** Routes `grok` provider requests to `grokbuild-proxy :8080`.

**Config:** `configs/config.json` → `PROXY_URL` points to grokbuild-proxy.

## Token Lifecycle

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│ 1. REGISTER │────▶│ 2. EXTRACT   │────▶│ 3. MINT OAUTH   │
│ grok.py     │     │ SSO token    │     │ sso_to_cpa.py   │
│ curl_cffi   │     │ from cookie  │     │ PKCE flow       │
│ YesCaptcha  │     │              │     │                 │
└─────────────┘     └──────────────┘     └────────┬────────┘
                                                   │
                                                   ▼
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│ 6. SERVE    │◀────│ 5. REFRESH   │◀────│ 4. STORE        │
│ grokbuild-  │     │ token_daemon │     │ auths/xai-*.json│
│ proxy :8080 │     │ + on-demand  │     │ keys/grok.txt   │
└─────────────┘     └──────────────┘     └─────────────────┘
```

### Stage Details

| Stage | Action | Frequency | Failure Mode |
|-------|--------|-----------|--------------|
| 1. Register | New account via curl_cffi | On demand (pool < threshold) | YesCaptcha timeout → retry |
| 2. Extract SSO | Parse session cookie | After registration | Invalid cookie → re-register |
| 3. Mint OAuth | PKCE flow → access + refresh token | After SSO extraction | Expired SSO → re-register |
| 4. Store | Write to auths/ and keys/ | Immediate | Disk full → alert |
| 5. Refresh | Use refresh_token → new access_token | Before expiry + on-demand | Revoked → re-register |
| 6. Serve | Route request to account | Per-request | All accounts exhausted → 429 |

## Integration with BlacklistedAIProxy

```json
// configs/config.json
{
  "PROXY_URL": "http://127.0.0.1:8080",
  "PROXY_ENABLED_PROVIDERS": ["grok", "grok-custom"],
  "GROK_COOKIE_TOKEN": "",
  "GROK_CF_CLEARANCE": ""
}
```

## Systemd Units (TBD)

| Unit | Type | Command | Port |
|------|------|---------|------|
| `grok-register.service` | oneshot | `python3 grok.py --batch` | — |
| `grok-replenish.service` | daemon | `python3 auto_replenish.py` | — |
| `grok-token-daemon.service` | daemon | `python3 token_daemon.py` | — |
| `grokbuild-proxy.service` | daemon | `./grokbuild-proxy` | :8080 |

## Alternative: grok_proxy.py (Backup)

If grokbuild-proxy is unavailable, `grok_proxy.py` from grok-register provides basic serving:

```bash
python3 grok_proxy.py --port 8099 --daemon
# OpenAI-compatible endpoint at :8099
```

**Limitations:** No Anthropic protocol, no admin UI, no multi-account stickiness, Python runtime.

## Port Allocation

| Service | Port | Bind | Protocol |
|---------|------|------|----------|
| grokbuild-proxy | :8080 | 0.0.0.0 | HTTP |
| grok_proxy.py (backup) | :8099 | 127.0.0.1 | HTTP |
| BlacklistedAIProxy → grok | :3001 → :8080 | — | HTTP internal |
