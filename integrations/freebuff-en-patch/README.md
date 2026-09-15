# freebuff-en-patch

English front-end restore patch for **Freebuff Desktop**, derived by inverting
[Kfowever/freebuff-zh-patch](https://github.com/Kfowever/freebuff-zh-patch)
(commit `d34b01f383388d189bdb763ee6afe773b2d80276`, patch v0.6.1, MIT).

Where the zh patch maps English UI strings → Simplified Chinese at DOM level,
`freebuff-en.js` runs the same DOM-walk architecture with the translation
direction inverted (zh → en), restoring the English interface on a machine
where the zh patch (or a zh-localized build) is installed.

## What it covers

| Surface | Handling |
|---|---|
| Exact strings | 880 zh→en pairs auto-inverted from the upstream `exact` map |
| Interpolated patterns | Reverse regexes for the most frequent families (Context %, streaks, updater, queued prompts) |
| Tool-row labels | `搜索/读取/运行` → `Search/Read/Run`, `成功/失败/运行中` → `success/failure/running`, `引用` → `Quote` |
| Region names | Reversed `Intl.DisplayNames` zh→en table |
| Contextual rules | `.turn-changes-head` "智能体修改了 N 个文件" → "Agent changed N files" |
| Protected content | Same ignore list as upstream: user messages, code, diffs, terminal output are never touched |

Known limitation: the zh patch's `.acts-toggle` rule strips a plural "s"
child node; singular/plural is not recoverable from the DOM, so those labels
are intentionally left as rendered.

## Files

- `freebuff-en.js` — the runtime patch (injected the same way as the zh patch)
- `tools/gen-en-patch.mjs` — generator; rerun when upstream updates its tables:
  ```sh
  node tools/gen-en-patch.mjs /path/to/freebuff-zh-cn.js freebuff-en.js
  ```
- `tests/roundtrip.test.mjs` — happy-dom round-trip test: applies the upstream
  zh patch (EN→ZH), then this patch (ZH→EN), and asserts the UI is restored
  and protected regions are untouched:
  ```sh
  mkdir -p /tmp/en-patch-deps && cd /tmp/en-patch-deps && npm i happy-dom@15
  node tests/roundtrip.test.mjs   # auto-finds happy-dom in /tmp/en-patch-deps
  ```

## Safety

Runtime DOM layer only — no network access, no user-data access. The
`document.documentElement.lang` is set to `en` after translation.
