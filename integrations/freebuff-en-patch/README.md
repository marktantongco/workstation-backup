# freebuff-en-patch

English front-end patch for the **trefeon freebuff-proxy admin dashboard**
(:3457), derived by inverting
[Kfowever/freebuff-zh-patch](https://github.com/Kfowever/freebuff-zh-patch)
(commit `d34b01f383388d189bdb763ee6afe773b2d80276`, patch v0.6.1, MIT).

Where the zh patch maps English UI strings → Simplified Chinese at DOM level,
`freebuff-en.js` runs the same DOM-walk architecture with the translation
direction inverted (zh → en).

> **Current state (2026-09-15): the patch is baked into the canonical build.**
> The asset lives at `frontend/public/assets/freebuff-en.js` with a cache-busted
> tag in `frontend/index.html`, served on the auth-exempt `/admin/assets/`
> route, and ships in every container image. `tools/patch-admin-en.sh` is now
> **legacy/restore tooling only** — use it to patch an *older* image or a
> checkout missing the bake-in, never on a current build.

## Current capabilities (v0.6.2)

| Surface | Handling |
|---|---|
| Exact strings | 880 zh→en pairs auto-inverted from the upstream `exact` map |
| Interpolated patterns | 84 mechanical regex inversions + 6 function-based families (region names via `Intl.DisplayNames`, privacy-connection, session-quota tooltips, Freebucks costs) |
| Runtime optimizations | CJK fast-reject (audit-proven: every key/pattern is CJK-gated, so English nodes skip all work), batched MutationObserver, subtree skip |
| zh-patch coexistence | Disconnects a live `__FREEBUFF_ZH_PATCH__` observer at startup so both observers can't fight |
| Tool-row labels | `搜索/读取/运行` → `Search/Read/Run`, `成功/失败/运行中` → `success/failure/running`, `引用` → `Quote` |
| Contextual rules | `.turn-changes-head` "智能体修改了 N 个文件" → "Agent changed N files" |
| Protected content | Same ignore list as upstream: user messages, code, diffs, terminal output are never touched |

Known limitation: the zh patch's `.acts-toggle` rule strips a plural "s"
child node; singular/plural is not recoverable from the DOM, so those labels
are intentionally left as rendered.

## Verification

- `tests/roundtrip.test.mjs` — happy-dom round-trip: applies the upstream zh
  patch (EN→ZH), then this patch (ZH→EN), asserts full restoration, protected
  regions untouched, fast-reject invariant, and zh-observer displacement:
  ```sh
  mkdir -p /tmp/en-patch-deps && cd /tmp/en-patch-deps && npm i happy-dom@15
  node tests/roundtrip.test.mjs   # auto-finds happy-dom in /tmp/en-patch-deps
  ```
- Browser-verified (2026-09-15) with Playwright + system Chrome against the
  running :3457 dashboard: patch global `__FREEBUFF_EN_PATCH__` live, observer
  alive, zero CJK text nodes, zero console errors (after the CSP
  `font-src 'self' data:` fix in the proxy).

## Safety

Runtime DOM layer only — no network access, no user-data access. The
`document.documentElement.lang` is set to `en` after translation.
