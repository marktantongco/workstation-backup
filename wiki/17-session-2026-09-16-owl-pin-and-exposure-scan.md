# 2026-09-16 — Rotation procedure scripted; OWL pins; full exposure scan

## Repeatable ADMIN_TOKEN rotation (the standing procedure)

`scripts/rotate-admin-token.sh` (trefeon repo, commit `584e339`, mirrored
to `tools/` here). Login → `fb_csrf` → `X-CSRF-Token` →
`POST /admin/api/change-password`, then self-verifies: new token 302,
old token rejected, `.env` matches. Token material never appears in
argv or output (0600 tmpfs files + curl `@file` bodies). Optional
`TOKEN_FILE=` supplies a specific token. **Live-run twice today** —
both rotations verified end-to-end; no restart needed.

## :9093 identified

`python3 /home/x1/.owl-agent/monitoring/alertmanager/alertmanager_dispatcher.py`
(x1's owl-agent alerting dispatcher, under `user@1000.service`),
loopback-bound, 404 on root — API service, no exposure. Previously
unverified in the port table.

## OWL :9094/:9095 pinned to loopback

`/home/x1/owl-dns-synergy/docker-compose.yml` publishes changed:
- owl-api metrics: `"127.0.0.1:${OWL_DNS_PROMETHEUS_PORT:-9090}:9090"` (env → 9094)
- prometheus: `"127.0.0.1:${PROMETHEUS_PORT:-9095}:9090"` (9095)

Zero established peers beforehand (verified). Gotcha recorded: the
prometheus **service** is named `prometheus`, not `owl-prometheus`
(container name) — first `compose up` recreated only owl-api.
Post-pin: external probes refused, loopback `/metrics` 200 both,
owl-api health 200. owl-api's `:60001` main API publish intentionally
left LAN-facing (key-gated, verified 401 without key).

## Full external-surface scan (LAN view of 192.168.1.17)

Monitoring tier is now clean: every :909x port refuses external
connections; the only 0.0.0.0 surfaces left are app services.

| 0.0.0.0/* port | Owner | External result | Verdict |
|---|---|---|---|
| 18080 | freebuff-unified front door | 401 without key | ✅ gated by design |
| 60001 | owl-api | 401 without key | ✅ gated |
| 60010 | owl proxy | 407 proxy-auth | ✅ gated |
| 7897 | agpx-relay | refused (non-HTTP) | ⚠️ verify auth separately |
| 6334 | qdrant gRPC | refused externally | ⚠️ gRPC unauth? same gap as 6333 |
| 8081 / 8443 | mitmdump / caddy | 400 (proxy/TLS handshake) | ✅ expected |
| 3000 | **grafana** | **200 login page** | ✅ verified 2026-09-16: `admin:admin` → 401; custom password set in x1's grafana.ini |
| **6333** | **qdrant** | **200 API + version banner** | ✅ **resolved 2026-09-16: publishes pinned to loopback (6333+6334); external refused, in-compose consumers unaffected** |
| 3002/3005/3030/3200/5000/8648/23001/28088/42110/8095 | various app UIs/APIs | 200 | ⚠️ open surface — per-app auth review needed |
| 3100/3101/9101/30080/8080/60000 | misc | 404 | ⚠️ APIs answering; root 404 only |

**Recommended next:** pin qdrant (6333/6334) to loopback or enable its
API key; audit the eleven 200-answering app UIs for their own auth;
confirm Grafana admin creds are not factory defaults. Not executed —
needs per-service go-ahead.

Port table (`10-port-allocation.md`) updated for 9094/9095.

## Addendum: scheduled rotation + remaining flags (same day)

- **Rotation now scheduled**: `freebuff-admin-token-rotation.timer`
  (weekly, Mon 04:17 +≤30m jitter, Persistent) → oneshot service →
  `runbook.sh admin-token-rotation` → trefeon `rotate-admin-token.sh`.
  Live test-run via systemd: OK (rotation + chain-health self-verify).
  Also fixed en route: `scripts/operations/runbook.sh` resolved
  `runbooks/` relative to itself and listed nothing — symlinked to the
  real `scripts/runbooks/` collection.
- **qdrant 6333/6334 pinned to loopback** (compose `beb35a5`, pushed);
  Grafana admin confirmed non-factory (custom password in grafana.ini,
  `admin:admin` → 401). Both scan flags above resolved.
- 🚨 **Action needed by user: revoke the leaked PAT.** x1's
  `obsidian-llm-wiki` clone had a live `ghp_…` token embedded in its
  git remote URL. Removed from `.git/config` (auth now via gh
  keyring, verified); **the token itself must be revoked at
  github.com/settings/tokens** since it sat on disk.
- Timer units mirrored under `services/systemd/`; runbook mirrored to
  `scripts/runbook-admin-token-rotation.sh`.
