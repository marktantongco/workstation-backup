# 2026-09-16 — ADMIN_TOKEN rotation + :3457 loopback hardening

## What changed

1. **ADMIN_TOKEN rotated to a random 20-char token** (256-bit sample from
   `/dev/urandom`, base64-stripped) via the real
   `POST /admin/api/change-password` flow (login → `fb_csrf` cookie →
   `X-CSRF-Token` header → JSON `{current_password,new_password}`).
   The plaintext token never entered a shell log, the vault, or any file
   outside the proxy's own dual-layer persistence (`.env` 0600 + settings
   overlay `source: db`).
2. **`docker-compose.yml`: host publish pinned to loopback**
   `"3457:3457"` → `"127.0.0.1:3457:3457"` (commit `63d43d4`, pushed to
   `marktantongco/freebuff-proxy` branch `trefeon-enpatch`). Rationale:
   `/healthz` + `/metrics` are unauthenticated by design, so a 0.0.0.0
   publish exposed them to the LAN; admin rode the same port.

## Verified after rotation + rebind

| Check | Result |
|---|---|
| Listener | `127.0.0.1:3457` (docker-proxy) |
| External probe `http://192.168.1.17:3457/healthz` | refused ✅ |
| Loopback `/healthz` | 200 ✅ |
| Login with new token | 302 ✅ |
| Login with previous value | 401 ✅ |
| Store integrity after recreate | `fresh=false noop=true` (history intact) |
| en-patch asset on auth-exempt route | 200 ✅ |
| unified → trefeon passthrough | 72 calls in 10 min post-change ✅ |

## Credential consumers audited (none needed updating)

- `freebuff-unified` `config.yaml`: `proxy.backend_url: http://127.0.0.1:3457`
  is **credential-free passthrough** — it stores no trefeon admin token.
  Its `fbu_…` keys are client API keys, a separate credential space.
- No script outside the trefeon repo referenced `ADMIN_TOKEN`
  (grep across `/home/x3/freebuff-unified`, `/etc/freebuff-unified`,
  `/opt/freebuff`).
- Off-loopback connection audit before the rebind: only unified
  (127.0.0.1) and Docker's own healthcheck were connected.

## Operational notes

- `.env` file modes tightened to 0600 during rotation (the atomic write);
  scripts reading it must use `sudo grep '^ADMIN_TOKEN='`.
- The `marktantongco` git remote had been dropped from the trefeon clone
  at some point; re-added as
  `https://github.com/marktantongco/freebuff-proxy.git` before pushing.
- ~~Known remaining exposure (flagged, not changed):~~ **Resolved same
  day:** freebuff-unified's dashboard `addr` was pinned to
  `127.0.0.1:9091` in its gitignored instance `config.yaml` and the unit
  restarted (zero established peers beforehand, so nothing broke).
  `:18080` remains the one intentional LAN-facing surface (API-key
  gated). Post-change: external probe refused, loopback dashboard 307,
  chain healthy.
- Rotation procedure is repeatable: the change-password endpoint requires
  only the current token + CSRF pair; no container restart needed.
