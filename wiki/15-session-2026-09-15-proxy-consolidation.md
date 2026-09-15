# 15 — Session 2026-09-15: Proxy Consolidation & EN Patch

## What happened
1. **Research pass** over freebuff-proxy ecosystem repos (rayss868, kisworo/freebuff2apiworker, Vixort/pi-freebuff, jhopan/PanRouter, Kfowever/freebuff-zh-patch) with skills.sh tooling installed (`find-skills`, `github-research`, `parallel-*`, `deep-researcher` — 6 external skills now in `~/.agents/skills/`).
2. **EN UI patch**: generated `freebuff-en.js` by mechanically inverting the Kfowever zh patch (90 inverse patterns: 84 regex + 6 function-based; region names, privacy/quota tooltips). Optimized runtime: CJK fast-reject (audit-proven safe — all 880 exact keys + 20 patterns are CJK-gated), batched MutationObserver, zh-patch observer displacement. Roundtrip test passes.
3. **Deployment reality check**: the patchable UI is the :3457 admin dashboard (Vite/Svelte, `go:embed`-ded). Two instances existed: systemd `freebuff-proxy.service` (127.0.0.1:3457, crash-looping on port conflict since before 2026-09-15) and Docker `freebuff-proxy-trefeon` (0.0.0.0:3457, the real server). **Fix: asset placed in `frontend/public/assets/` → served on the auth-exempt `/admin/assets/` route (no 302), tag cache-busted with `?v=`. Patch baked into the canonical build — future rebuilds carry it.**
4. **systemd freebuff-proxy.service disabled** (was crash-looping; container is canonical).
5. **Cleanup** (evidence-backed): removed ghcr `freebuff-proxy` container (unhealthy 2d, EACCES loop, no ports; bind-mount data preserved), disabled `freebuff2api` + `freebuff2api-admin` (0 req/24h, superseded), disabled `hermes-sidecar` + `lmarena-stealth-proxy` (0 traffic/24h — the "3101/3103" journal hits were timestamp false-positives), pruned 10 exited containers. ~185 MB recovered.
6. **materialgram** v7.0.5.1 installed to `/usr/local/bin` + desktop entry.
7. **Vixort gap analysis**: trefeon already implements 4 of 5 anti-ban shield layers in stronger form (shutdown keeps sessions for resume; pre-admission Freebucks guard; per-token cooldowns; REQUEST_JITTER pacer). One real gap adopted as config knob: **`UNFIT_EGRESS`** — makes egress identity configurable (default `direct`) so per-egress unfit marking is multi-proxy-ready.

## State changes to mirror on restore
- `systemctl disable --now freebuff-proxy.service freebuff2api.service freebuff2api-admin.service hermes-sidecar.service lmarena-stealth-proxy.service`
- EN patch is baked into the trefeon repo build (no post-hoc patching needed).
- Container image rebuilt from patched tree: `freebuff-proxy:latest` (2026-09-15).

## Follow-ups (same day)
- **UNFIT_EGRESS set through the real dashboard flow** (login → CSRF → `POST /admin/api/settings`): confirmed in resolved settings (`source: db`, restart_only: true) and `/admin/api/config` effective rows. Value equals the default ("direct"), so no restart was required.
- **Browser verification (Playwright + system Chrome)**: patch global `__FREEBUFF_EN_PATCH__` v0.6.2 live on login page + dashboard, observer alive, zero CJK text nodes, zero console errors — after fixing a real render defect the check surfaced: CSP `font-src 'self'` blocked the vite-inlined `data:` Geist fonts (silent system-font fallback). Fix: `font-src 'self' data:` (mirrors img-src posture).
- **trefeon commits** (deployed lineage, 4): `7ffd6d1` UNFIT_EGRESS knob · `53bac1c` en-patch bake-in · `6774607` drop stray public-root copy · `f81bb9c` CSP font fix. Upstream `trefeon/freebuff-proxy` denies `marktantongco` (403), and `marktantongco/freebuff-proxy` is a **separate fork lineage** (ferdiunal-based, unrelated histories — do not force-push). Pushed non-destructively as branch **`trefeon-enpatch`** at `f81bb9c` on `marktantongco/freebuff-proxy`.
