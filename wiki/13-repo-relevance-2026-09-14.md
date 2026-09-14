# 2026-09-14 — GitHub repo-relevance verdicts (15-repo landscape pass)

Question asked: *will these links help this project?* Evaluated live metadata (stars, last push, language) against the actual ecosystem components. Verdicts below, grouped by action.

## Directly load-bearing (act on these)

| Repo | Role | Action taken |
|---|---|---|
| **trefeon/freebuff-proxy** (184★, Go, pushed that day) | The container `freebuff-proxy-trefeon` on `:3457` is the passthrough backend behind unified's `:18080` — the only chat path that completed that day. Source contains the full anti-fingerprint playbook (`#103` cf-worker client_id shape, `#106` chat UA pinning, `#110` system-marker hardening, per-run client_id, capacity-deferred retries). | Synced Sep-4 checkout → upstream HEAD `6103692` (v1.8.9, 243 commits); rebuilt container; used as reference implementation for the `/opt` + unified fingerprint fix. Local mods preserved on branch `local-mods`. |
| **mandatoryprogrammer/thermoptic** (1045★) | Already deployed on this box (`thermoptic-thermoptic-1`, `-chrome-1`, `-proxyrouter-1` on :1234/:14111/:3128). Escalation layer if upstream's gate moves from header/body checks to TLS/JA3 fingerprinting — its Chrome-cloaked egress would sit between the Go proxies and upstream. | Keep warm; no change (today's gate is body-level, in-process `chrome120` utls + SDK-faithful shape is enough). |
| **ulixee/secret-agent** (736★, stale 2023) | Stealth browser layer for the generate-random.org fetcher in BlacklistedAIProxy. Upstream renamed it `@ulixee/hero`; unmaintained as `secret-agent`. | Keep the playwright+stealth fallback alive; fetcher already wired and working. |

## Useful situational tools (park, don't integrate yet)

| Repo | When it helps |
|---|---|
| odell0111/turnstile_solver (52★) | Cloudflare Turnstile targets (~2s solve, self-hosted Python). Nothing in the pipeline is CAPTCHA-blocked; the freebuff gate is **not** a CAPTCHA. Future case: phantomsignal scans on CF-protected sites. |
| njraladdin/recaptcha-v2-solver (49★) | Same category for reCAPTCHA v2 (audio route + 2captcha fallback). Park. |
| yunginnanet/prox5 (81★, Go) | Battle-tested SOCKS5 validating pool — cleaner reference than hand-rolled if the proxy pool (now fail-closed/latency-scored) is ever re-enabled. Could replace health-check internals. |
| phase3dev/advanced-sitemap-parser (87★) | Sitemap harvesting with anti-bot bypass — fits phantomsignal's discovery/recon phase. Side tool. |

## Little/no help for this project

- **tholian-network/stealth** (1146★, stale since 2023) — already evaluated vs secret-agent and passed; nothing changed.
- **WhyY0u/funBrowser** (4★) — overlaps secret-agent's role, less established. Backup-of-the-backup at best.
- **madeye/https_proxy** — single-purpose HTTP proxy; Go stdlib + existing pool already cover it.
- **anatolykoptev/go-stealth**, **annurdien/stealth** — minimal/niche stealth libs; the trefeon-derived shape fix supersedes what they'd offer here.
- **zackiles/cdp-proxy-interceptor** (21★) — CDP MitM; only if the fetcher browser's traffic ever needs interception.
- **fluential/telegram-tor-proxy** (9★) — Tor for Telegram alerting; trefeon's notify webhook already covers alerts.

## Recommended sequence (as executed)

1. ✅ Sync the trefeon container to upstream HEAD — done, validated E2E.
2. ✅ Finish the fingerprint fix in both Go proxies using trefeon's documented shapes — done, `:1455` completes with glm.
3. Keep thermoptic warm as the JA3-escalation fallback; park CAPTCHA solvers until a target needs them.
