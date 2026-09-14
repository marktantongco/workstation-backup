# 14 — Stealth Spike: prox5 Pool + Profile Rotation (2026-09-14)

## What

Two bounded spikes in `freebuff-unified/internal/stealth`, researched in
parallel (web survey + GitHub compare + methods deep-dive) before writing:

1. **prox5 v1.3.0 adapter** (`prox5pool.go`, ~140 lines). `Prox5Pool`
   behind a new `ProxyDispenser` interface (`Next/Size/Replace`) shared
   with `USProxyPool`. Refresher + metrics untouched. Gated by
   `stealth.validator: internal|prox5` (default internal), fail-closed
   with internal fallback on build error.
2. **Native profile expansion** (`profiles.go` 4→11): chrome131/133,
   edge106, firefox102/105, safari16, ios, android + `ProfileByName`,
   lock-free `RotateProfile`, `RandomProfile`, registry. go-stealth
   rejected as a dependency (profiles opaque inside tls-client fork);
   native = same coverage, no 8-module subtree. No prod consumer yet
   (hermes sidecar owns TLS) — rotation-ready library, default pinned.

## Gotchas found by testing (not docs)

- `LoadSingleProxy` wants **schemeless** `host:port` — scheme-prefixed
  input silently rejected (`schemeless()` helper).
- `GetAnySOCKS` **blocks on empty** — `Next()` stats-gated + 500ms cap
  to preserve the nil-miss contract.
- Sparse-data BT-style divergence noted for ratings; tie-prior pattern
  reused conceptually (bounded extremes).
- `tls.go` had pre-existing bad indentation — gofmt fixed in passing.

## Alternatives ranked (research verdict)

| # | Candidate | Verdict |
|---|---|---|
| 1 | prox5 (kept) | Only true embed lib + mid-dial retry, MIT, CI |
| 2 | things-go/go-socks5 | Server only — pair as front, not replacement |
| 3 | elazarl/goproxy | HTTP gateway lib — pair for HTTP front only |
| 4 | Vozec/Flarex | Best engineering, all-`internal/` (fork-only fallback) |
| 5 | yukkcat/socks5-proxy | Unlicensed, no CI — patterns only |

## Verification

- Full `-race` green (7 pkgs); new `profiles_test.go` (registry/ByName/
  rotate-cycle/random) + `prox5pool_test.go` (fail-closed/auth/schemeless).
- Live boot proof: `prox5: loaded 2 proxies, engine started`, gateway
  serves with unroutable endpoints tolerated.
- Commits: `2b94558` (spike, PR #11) + `fbd0ebe` (README §9).
- README §9 documents profiles table, engine table, miss-flow diagram.

## Config

```yaml
stealth:
  profile: "chrome120"   # or random|rotate|named ID
  validator: "internal"  # or "prox5"
```
