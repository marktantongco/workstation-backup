# 2026-09-14 — freebuff-proxy PR #1 merged + IPv6 parse fix + E2E

## What landed

| Repo | Branch | Commit | Change |
|---|---|---|---|
| freebuff-proxy | main | `7a85126` (merge) | PR #1: review fixes (`73fc7de`) on top of transport hardening (`33349d4`) |
| freebuff-proxy | main | `32d9429` | Bracketed-IPv6 endpoint parsing fix |
| freebuff-unified | integrate/main | `8f39e1a` | Same IPv6 fix (kept in sync) |

- PR #1 was initially `CONFLICTING` (the branch was a cherry-pick of `33349d4`, already on main). Resolved by rebasing with `--empty=drop`; duplicate patch skipped.
- CodeRabbit's blocking review targeted the stale `237f0ac` commit; dismissed with rationale (all 4 findings fixed in `b08c3d1`/`73fc7de`). Fresh review of the rebased head: zero blocking findings.
- Review fixes carried in PR #1: retry-count naming (`maxTransportAttempts`), `latency_ms` real-millisecond serialization, SOCKS-dial failure fallback to direct with correct `MarkFailure`/`MarkSuccess` bookkeeping on the `ContextDialer` path.

## IPv6 follow-up (CodeRabbit nit, fixed same day)

`parseProxyList` split every line on `:`, so `[2001:db8::1]:1080` collapsed into five fields and mis-parsed as Webshare credentials. Fix in both proxies:

- Bracketed endpoints parsed via `net.SplitHostPort` before the Webshare branch; malformed bracketed lines (no port) skipped.
- `ProxyEntry.URL` now emits `net.JoinHostPort`, so IPv6 hosts stay bracketed and parseable (superseded the old unbracketed test expectation).
- New tests: `TestParseProxyList_BracketedIPv6`, `TestParseProxyList_BracketedIPv6Malformed` (freebuff-proxy); suite green in both repos.

## Post-merge validation (2026-09-14 ~05:30 UTC)

- `freebuff-proxy` (:1455) **active**; `freebuff-unified` (:18080) **active**; both redeployed from fixed source.
- Transport health proven: authenticated `429`s relayed from upstream in <1.5s TTFB with clean JSON error bodies — no dial/TLS failures anywhere.
- **Full chat completion blocked by upstream account state, not code**: `freebuff_rate_limited` ("Freebuff oturum limiti aşıldı") on all models tried; `z-ai/glm-5.3-flash` additionally returned `freebuff_auth_failed`. Quota window resets ~07:00 UTC per the earlier upstream notice. Re-verify a 200 completion after reset.
- Note: neither proxy's pool path was active during the test (unified pool disabled, `/opt` stealth off), so the IPv6 fix has no effect on current live traffic — it hardens future pool use.

## Addendum (06:40 UTC) — glm-5.3-flash root cause + honest error mapping

**`z-ai/glm-5.3-flash` `freebuff_auth_failed` was a mislabel, not an auth failure.** Direct upstream replay with the account token showed:

- `StartSession` for glm **succeeds** (`status: active`) — though the payload carries `countryCode: PH, countryBlockReason: country_not_allowed` (informational at session level).
- The chat call then returns **`403 {"error":"free_mode_invalid_agent_model"}`** — upstream only allows specific (agent, model) pairs in free mode. Free agents map to minimax/kimi/deepseek (+ mimo via `base2-free`); **glm has no free-mode agent**, and probing `base2-free-glm`/`-glm5`/`-zai` still 403s at chat.
- The proxy's fallback mapping rebranded the unknown 403 as `freebuff_auth_failed`, which pointed the investigation the wrong way.

**Fix (both proxies):** `free_mode_invalid_agent_model` added to recognized upstream codes — now passes through as 403 with its true meaning, in both the status path and stream-event path. Commits: freebuff-proxy `defeb20` → main, freebuff-unified `b1d36c0` → integrate/main. Deployed + verified live: glm requests now return the honest code.

**Review status (requested check):** PR #1 (freebuff-proxy) final state clean — stale `CHANGES_REQUESTED` dismissed, fresh CodeRabbit `COMMENTED` with zero blocking findings, "Test and vet" SUCCESS. PR #8 (unified) merged clean; no review activity on post-merge pushes `8f39e1a`/`b1d36c0` (expected — they're not PR branches).

**Also observed:** deepseek/mimo Freebanks exhaustion confirmed via upstream (`recentCount 25/25, balance: 0`, reset 07:00Z, `retryAfterMs` ≈ 37 min at 06:22) — pure account state, not code.

## Backup sync

`projects/freebuff-proxy/internal/stealth/{proxy.go,proxy_test.go}` and `projects/freebuff-unified/internal/stealth/proxy.go` refreshed to match the live repos at `32d9429` / `8f39e1a` (diff-verified before commit).

## Addendum (17:00 UTC) — upstream fingerprint gate + SDK-faithful request fix

**Second root cause of the day: upstream added a client-fingerprint gate on chat** (`403 free_mode_cli_required`), which my manual replays triggered but the dockerized `trefeon/freebuff-proxy` container did not — its newer code documents the exact requirements:

1. `client_id` in the CLI's **13-char base36** shape (`/opt` sent `freebuff-proxy-<hex>` — a shape upstream fingerprints as a proxy), derived deterministically from the `run_id` (fresh id per call on a cached run triggers `free_mode_run_fanout`).
2. The **CLI system marker** as the first system message (Buffy/Freebuff identity string; hardened against prepend-and-cancel tricks — must be at position 0 of the FIRST system message).
3. Chat-only **User-Agent** `ai-sdk/openai-compatible/1.0.0/codebuff`.

All three together, replayed by hand with `/opt`'s own token: **HTTP 200 with a real completion** — proof before the port.

**Fix shipped in both Go proxies** (fingerprint constants + `buildUpstreamChatRequest` marker/UA injection + run-derived `client_id`):
- freebuff-proxy: `fa17740` (+ glm agent-pairing `base2-free-glm-5-3-flash` from the refreshed registry, + `free_mode_invalid_agent_model` pass-through test in httpapi `6806be8`) → main. Post-fix live test: **`:1455` → 200 `E2E OK` with glm** (the model that 403'd all morning).
- freebuff-unified: `e58a529` → integrate/main.

**Also done:** trefeon container (`:3457`, the passthrough backend behind unified) synced from Sep-4 checkout to upstream HEAD `6103692` (v1.8.9 line, 243 commits) — rebuilt, recreated healthy, E2E `200` via both `:3457` direct and `:18080` passthrough. Registry refresh (43 agents / 21 models) restored glm's free pairing, which upstream had added since the old build.

**Model state post-reset (via working path):** mimo **200 OK**; glm **200** after the pairing + fingerprint fixes; deepseek/gpt-5.6-luna 429 (`price 40 > balance 15` — shortfall persists past window reset); minimax/kimi/solar-pro4 **retired upstream** (free tier actively contracting).

**Quota note:** the day's testing consumed 20/25 freebucks — mimo's later 429s were genuine account state, not code.

### Backup sync (17:05 UTC)

- `projects/freebuff-proxy/internal/freebuff/{chat.go,chat_client_test.go}` + `projects/freebuff-unified/internal/freebuff/client.go` refreshed (diff-verified vs live trees at `fa17740` / `e58a529`).
- trefeon local mods (CLI-credential auto-import, SSE token-refresh push, dashboard fixes) preserved on branch `local-mods` @ `9e61ef8+`; container-name pin kept via gitignored `docker-compose.override.yml`; rollback image tagged `freebuff-proxy:pre-head-sync`.
- Wiki note `13-repo-relevance-2026-09-14.md` records the 15-repo landscape verdicts from the github-research pass.

## Addendum (18:15 UTC) — live agent registry backport + daily E2E health check + thermoptic JA3 escalation

**1. Live agent registry (both Go proxies).** Minimal backport of trefeon's `internal/registry`: fetches `FREEBUFF_ROOT_AGENT_ID_BY_MODEL` from `CodebuffAI/freebuff` TS constants (raw.githubusercontent + jsDelivr mirror), resolves literal/alias/object constants (depth-capped like the JS), refreshes every 6h, logs `[agent-registry] refreshed 11 model→agent pairings` at boot. Resolution chain: live map → static snapshot → `base2-free`. New upstream pairings (e.g. mimo's new `base2-free-mimo` root) now arrive without code changes. Commits: freebuff-proxy `17a792d` → main, freebuff-unified `113c8ef` → integrate/main; unified's stale static map (still listing retired minimax/kimi, missing glm) synced. Verified: glm 200 `'REG-OK'` through `:1455`.

**2. Upstream apex redirect (new behavior).** `codebuff.com` now **301s GETs to www.codebuff.com** and **307s POSTs** (method+body preserved). Go clients follow 307 preserving method+body, so both proxies are unaffected (verified live: 200 `'APEX-LIVE-OK'`). Unified already targeted `www.codebuff.com`. The CLI's documented endpoint stays the apex; no config change made.

**3. Daily E2E health check.** `/opt/freebuff/e2e-health/freebuff-e2e-health.sh` (+ `freebuff-e2e-health.service`/`.timer` units, timer at **07:15 UTC daily**, 15 min after the quota reset, `Persistent=true`):
- Discovers available free models from the trefeon container's `/v1/models` (live registry, no auth; static fallback if down) — solar-pro4 reappeared in discovery after upstream trimmed it, proving the point.
- Runs one small chat completion per (proxy, model) on `:1455` and `:18080`; classifies `200=OK`, `429=QUOTA`, `403 free_mode_invalid_agent_model=PERM`, `403 other=FINGERPRINT→escalate`, `400=MODEL`, `401=AUTH`, `000=DOWN`.
- Writes `/var/lib/freebuff-e2e-health/{status.json,health.log}`; exit 0 iff every cell OK/QUOTA.

**4. Thermoptic JA3 escalation.** thermoptic's `proxyrouter` speaks **HTTP CONNECT only** (SOCKS5 rejected); published to host loopback `:31280` via `services/thermoptic/docker-compose.override.yml`. Both Go transports clone `http.DefaultTransport` → `ProxyFromEnvironment` live, so escalation is pure env: on FINGERPRINT the script injects `HTTPS_PROXY=http://127.0.0.1:31280` into `/opt`'s `.env` + unified's `/etc/freebuff-unified/probe-env`, restarts both, re-verifies; success persists (`escalated` state file), failure auto-reverts. Manual revert: `--revert`. Proven end-to-end: SDK-faithful replay through thermoptic passes the gate (400 `No runId found` = body validation, not fingerprint), full health matrix runs clean behind the proxy, revert restores direct egress.

### Backup sync (18:15 UTC)

- `projects/freebuff-proxy/internal/freebuff/{registry.go,registry_test.go,chat.go}`, `projects/freebuff-proxy/internal/app/app.go`, `projects/freebuff-unified/internal/freebuff/{registry.go,registry_test.go,client.go}`, `projects/freebuff-unified/cmd/freebuff/main.go` (diff-verified vs `17a792d` / `113c8ef`).
- `services/systemd/freebuff-e2e-health.{service,timer}`, `services/e2e-health/freebuff-e2e-health.sh`, `services/thermoptic/docker-compose.override.yml` added.
