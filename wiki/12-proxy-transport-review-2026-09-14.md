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
