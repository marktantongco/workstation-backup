# 2026-09-16 — Final external-surface certification

Full re-scan after all hardening: enumerated every listener, probed each
externally-bound port from the LAN, identified every unknown process,
and fixed five stragglers found only by this deeper pass.

## Stragglers found & fixed during certification

| Port | What it was | Fix | Verified |
|---|---|---|---|
| 60000/9101 | owl_server.py (x1 host proc) `--host 0.0.0.0` — health + Python metrics unauth | supervisor.sh arg → `--host 127.0.0.1`, unit restarted | ext refused; owl Prometheus unaffected (scrapes the *container* `owl-gateway:60000`, not the host proc) |
| 8081 | **mitmdump — open HTTP proxy**: relayed http://example.com for any LAN client (`--mode upstream:18181`) | `--listen-host 127.0.0.1` in owl-mitm.service | ext refused; open-proxy test now impossible |
| 30080 | ai-gateway-multiplexer gateway-addr 0.0.0.0 — served `/v1/models` unauth, chat → 503-upstream (not 401) | unit arg → `127.0.0.1:30080` | ext refused |
| 8080 | x1's second freebuff-unified `listen: ":8080"` — healthz/model list public; chat not key-gated (503 upstream, no 401) | config.yaml listen → `127.0.0.1:8080`, engine restarted | ext refused; its local loopback client survives |
| 8095 | owl-mcp: full MCP initialize handshake accepted unauth | compose publish → `127.0.0.1:8095` | ext refused |
| 60001 | owl-api: `/api/*` gated but **`/v1/chat/completions` accepted a bogus-key chat 200** — mislabeled "key-gated" in wiki 17/18 | compose publish → `127.0.0.1:60001` | ext refused |

Peer audits (zero established connections) preceded every recreate/pin.

## Certified final state — every external-bound port

| Port | Service | Verdict |
|---|---|---|
| 18080 | freebuff-unified front door | ✅ 401 without fbu_ key — the intentional door |
| 3000 | Grafana (x1) | ✅ login page only; factory creds rejected (wiki 17) |
| 3002 | anythingllm | ✅ auth-gated: keyless API 403 JSON; root 200 = SPA shell |
| 3030 | StepUP AI Gateway (x1) | ✅ 401 |
| 3100/3101 | aiclient2api / blacklisted-api internal master ports | ✅ 404 JSON on every probed path incl. POST chat — no API surface; optional: pin later |
| 3200 | aiclient2api | ✅ 401 |
| 42110 | khoj | ✅ auth-gated (settings/user 403) |
| 7897 | agpx-relay (SOCKS) | ✅ anonymous handshake fails ("Failed to receive SOCKS response") |
| 8088 | turnstile-solver | ✅ 403 |
| 8443 | caddy | ✅ TLS handshake only |
| 8648 | Hermes (x1) | ✅ 401 |
| 23001 | new-api | ✅ 401; factory creds rejected |
| 60010 | owl proxy | ✅ 407 proxy-auth required |

**Everything else on the host is bound to 127.0.0.1** (3457, 9091-9095,
6333/6334, 5000, 28088, 14111, 31280, 18181/18182, 1234, 9222, 8005, …).

## Verdict

**Certified**: no unauthenticated surface remains reachable from the LAN.
Every listening port is loopback-only, auth-gated, TLS/proxy-handshake-only,
or a 404-only internal port. Production chain (18080 → 3457) verified
untouched after all changes (live passthrough traffic confirmed).

Residual follow-ups (optional): pin 3100/3101 in their unit configs;
revoke the leaked ghp_ PAT (user action, pending).
