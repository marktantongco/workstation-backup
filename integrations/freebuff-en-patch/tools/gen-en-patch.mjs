#!/usr/bin/env node
/**
 * gen-en-patch.mjs — Build freebuff-en.js by inverting
 * Kfowever/freebuff-zh-patch (d34b01f383388d189bdb763ee6afe773b2d80276, v0.6.1).
 *
 * The zh patch maps English UI strings → Simplified Chinese at DOM level via
 * two surfaces: an `exact` string map and a `patterns` regex array (plus a few
 * replacement helper functions). This generator extracts BOTH, inverts them
 * (zh → original English), and emits a runtime patch with the same DOM-walk
 * architecture plus performance hardening:
 *
 *   - CJK fast-reject: every translation surface is CJK-gated (verified by
 *     audit), so strings without CJK codepoints skip all work. On an English
 *     UI this makes the patch ~zero-cost per node.
 *   - Batched MutationObserver: mutation records are coalesced into sets and
 *     flushed in one microtask instead of spawning a TreeWalker per record.
 *   - Subtree skip: elements inside ignorable regions (code, prose, terminal…)
 *     are not walked at all.
 *
 * Usage: node tools/gen-en-patch.mjs <path-to-freebuff-zh-cn.js> [out-file]
 */
import fs from "node:fs";

const [, , srcPath = "/tmp/fp-research/kfowever/freebuff-zh-cn.js", outPath = new URL("../freebuff-en.js", import.meta.url).pathname] = process.argv;
const src = fs.readFileSync(srcPath, "utf8");

// ── Extraction helpers ─────────────────────────────────────────────────────

/** Resolve a JS single-quoted string literal body (without quotes) to its value. */
function unescapeSq(body) {
  return body.replace(/\\([\s\S])/g, (_, c) => {
    switch (c) {
      case "n": return "\n";
      case "t": return "\t";
      case "r": return "\r";
      default: return c; // \' \\ and any other escaped char
    }
  });
}

/**
 * Parse one `[ /regex/flags, replacement ]` entry at position i.
 * Returns { source, flags, replacement: {kind:'string',v}|{kind:'fn',name}, next }.
 */
function parsePatternEntry(text, i) {
  // expect '[' then optional ws then '/'
  let j = i + 1;
  while (/\s/.test(text[j])) j += 1;
  if (text[j] !== "/") return null;
  j += 1;
  let reBody = "";
  let inClass = false;
  while (j < text.length) {
    const ch = text[j];
    if (ch === "\\") { reBody += ch + text[j + 1]; j += 2; continue; }
    if (ch === "[") inClass = true;
    else if (ch === "]") inClass = false;
    else if (ch === "/" && !inClass) break;
    reBody += ch;
    j += 1;
  }
  if (text[j] !== "/") return null;
  j += 1;
  let flags = "";
  while (/[a-z]/.test(text[j] ?? "")) { flags += text[j]; j += 1; }
  while (/\s/.test(text[j])) j += 1;
  if (text[j] !== ",") return null;
  j += 1;
  while (/\s/.test(text[j])) j += 1;
  // replacement: 'string' | identifier
  if (text[j] === "'" || text[j] === '"') {
    const quote = text[j];
    j += 1;
    let body = "";
    while (j < text.length && text[j] !== quote) {
      if (text[j] === "\\") { body += text[j] + text[j + 1]; j += 2; continue; }
      body += text[j];
      j += 1;
    }
    return { source: reBody, flags, replacement: { kind: "string", v: unescapeSq(body) }, next: j + 1 };
  }
  let name = "";
  while (/[A-Za-z0-9_$]/.test(text[j] ?? "")) { name += text[j]; j += 1; }
  if (!name) return null;
  return { source: reBody, flags, replacement: { kind: "fn", name }, next: j + 1 };
}

/** Extract the zh patterns array entries. */
function extractPatterns(text) {
  const start = text.indexOf("const patterns = [");
  if (start === -1) throw new Error("patterns array not found");
  const end = text.indexOf("\n  ]", start);
  const region = text.slice(start, end);
  const entries = [];
  let i = region.indexOf("[/") ;
  while (i !== -1) {
    const entry = parsePatternEntry(region, i);
    if (!entry) { i = region.indexOf("[/", i + 2); continue; }
    entries.push(entry);
    i = region.indexOf("[/", entry.next);
  }
  return entries;
}

// ── Mechanical regex inversion ─────────────────────────────────────────────

const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/** Tokenize a replacement template into literals and $n refs. */
function parseTemplate(tpl) {
  const tokens = [];
  let buf = "";
  let i = 0;
  while (i < tpl.length) {
    if (tpl[i] === "$" && /\d/.test(tpl[i + 1] ?? "")) {
      if (buf) { tokens.push({ type: "lit", v: buf }); buf = ""; }
      tokens.push({ type: "ref", n: Number(tpl[i + 1]) });
      i += 2;
      continue;
    }
    if (tpl[i] === "$" && tpl[i + 1] === "$") { buf += "$"; i += 2; continue; }
    buf += tpl[i];
    i += 1;
  }
  if (buf) tokens.push({ type: "lit", v: buf });
  return tokens;
}

/** True when the char cannot appear unescaped in a literal we reconstruct. */
const isRegexShorthand = (c) => /[dDwWsSbB]/.test(c);

/**
 * Scan a regex BODY (no ^/$ anchors) into an ordered sequence of top-level
 * literal segments and capturing-group nodes:
 *   [{kind:'lit', v}] | [{kind:'group', n, pat}]
 * Returns null when the pattern is not mechanically invertible:
 *   - regex shorthands (\d, \s…) in a top-level literal
 *   - quantifiers (? * + {) applied to a top-level literal or group
 *   - top-level alternation (|)
 *   - nested capturing groups, or capturing groups the template never uses
 * Group patterns are kept VERBATIM (so (?:…) and classes inside them survive).
 */
function scanRegex(body) {
  const seq = [];
  let lit = "";
  const stack = []; // { capture, start, n }
  let capCount = 0;
  const groupPat = new Map();
  let i = 0;
  const flushLit = () => { if (lit) { seq.push({ kind: "lit", v: lit }); lit = ""; } };
  while (i < body.length) {
    const ch = body[i];
    if (ch === "\\") {
      const n = body[i + 1];
      if (stack.length === 0) {
        if (isRegexShorthand(n)) return null;
        lit += n; // unescaped literal char (\. -> '.', \\$ -> '$')
      }
      i += 2;
      continue;
    }
    if (ch === "[") {
      i += 1;
      while (i < body.length) {
        if (body[i] === "\\") { i += 2; continue; }
        if (body[i] === "]") break;
        i += 1;
      }
      i += 1;
      continue;
    }
    if (ch === "(") {
      flushLit();
      let capture = true;
      let advance = 1;
      if (body[i + 1] === "?") {
        const n2 = body[i + 2];
        if (n2 === ":") { capture = false; advance = 3; }
        else if (n2 === "=" || n2 === "!") { capture = false; advance = 3; }
        else if (n2 === "<" && (body[i + 3] === "=" || body[i + 3] === "!")) { capture = false; advance = 4; }
        else if (n2 === "<") { advance = 1; } // named capture — verbatim slice keeps the name
      }
      if (capture) {
        capCount += 1;
        stack.push({ capture: true, start: i, n: capCount });
      } else {
        stack.push({ capture: false });
      }
      i += advance;
      continue;
    }
    if (ch === ")" && stack.length) {
      const g = stack.pop();
      if (g.capture) {
        const pat = body.slice(g.start, i + 1);
        groupPat.set(g.n, pat);
        // Nested capturing groups make inverse group renumbering unsafe.
        if (/(?<!\\)\((?!\?)/.test(pat.slice(1, -1))) return null;
        if (stack.length === 0) seq.push({ kind: "group", n: g.n, pat });
      }
      i += 1;
      continue;
    }
    if (stack.length === 0) {
      if (ch === "|") return null; // alternation breaks literal reconstruction
      if (ch === "?" || ch === "*" || ch === "+" || ch === "{") return null; // quantifier on literal/group
      lit += ch;
    }
    i += 1;
  }
  flushLit();
  if (stack.length) return null; // unbalanced
  return { seq, groupPat };
}

/**
 * Invert an EN→ZH (regex, template) pair into a ZH→EN pair.
 * Inverse regex = template literals (escaped) + source group patterns
 * (verbatim, renumbered in template order). Inverse replacement = source
 * literals + $refs renumbered to the inverse regex's group order.
 */
function invertPattern(reSource, flags, tpl) {
  const anchoredStart = reSource.startsWith("^");
  const anchoredEnd = reSource.endsWith("$") && !reSource.endsWith("\\$");
  const body = reSource.replace(/^\^/, "").replace(/\$$/, "");
  const tokens = parseTemplate(tpl);
  if (tokens.length === 0) return null;
  const scanned = scanRegex(body);
  if (!scanned) return null;
  const { seq, groupPat } = scanned;
  // Every top-level capture must be referenced by the template.
  const refs = new Set(tokens.filter((t) => t.type === "ref").map((t) => t.n));
  for (const s of seq) if (s.kind === "group" && !refs.has(s.n)) return null;
  // Build inverse regex in template order.
  const reParts = [];
  const newIndex = new Map();
  let invGroup = 0;
  for (const t of tokens) {
    if (t.type === "lit") reParts.push(escapeRe(t.v));
    else {
      const pat = groupPat.get(t.n);
      if (!pat) return null;
      invGroup += 1;
      newIndex.set(t.n, invGroup);
      reParts.push(pat);
    }
  }
  // Build inverse replacement in source order.
  const replParts = [];
  for (const s of seq) {
    if (s.kind === "lit") replParts.push(s.v.replace(/\$/g, "$$"));
    else replParts.push(`$${newIndex.get(s.n)}`);
  }
  // Inside a /…/ literal an unescaped '/' ends the regex early — zh
  // templates can contain bare slashes (e.g. "第 1/2 步"), so escape them
  // in literal parts (group patterns are emitted verbatim).
  const escSlash = (s) => s.replace(/\//g, "\\/");
  const reJoined = reParts.map((p) => (p.startsWith("(") ? p : escSlash(p))).join("");
  return {
    source: (anchoredStart ? "^" : "") + reJoined + (anchoredEnd ? "$" : ""),
    flags: flags.replace(/[gy]/g, ""),
    replacement: replParts.join(""),
  };
}


const CJK_RE = /[\u3000-\u303f\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff01-\uff5e]/;

// ── 1. Extract + invert the exact map ──────────────────────────────────────
const mapStart = src.indexOf("const exact = new Map(");
const mapEndMarker = "\n    }),\n  )";
const mapEnd = src.indexOf(mapEndMarker, mapStart);
if (mapStart === -1 || mapEnd === -1) {
  console.error("Could not locate the `exact` map region in the source file.");
  process.exit(1);
}
const mapRegion = src.slice(mapStart, mapEnd);

const pairRe = /'((?:[^'\\]|\\.)*)'\s*:\s*'((?:[^'\\]|\\.)*)'/g;
const forward = []; // [en, zh] in source order
let m;
while ((m = pairRe.exec(mapRegion)) !== null) {
  const en = unescapeSq(m[1]);
  const zh = unescapeSq(m[2]);
  if (!zh || !en) continue;
  forward.push([en, zh]);
}
console.log(`forward exact pairs extracted: ${forward.length}`);

const inverted = new Map(); // zh → en
for (const [en, zh] of forward) {
  const prev = inverted.get(zh);
  if (prev === undefined) inverted.set(zh, en);
  else if (en.includes("…") && !prev.includes("…")) inverted.set(zh, en);
}

// ── 2. Extract + invert the patterns array ─────────────────────────────────
const zhPatterns = extractPatterns(src);
console.log(`zh pattern entries extracted: ${zhPatterns.length}`);

// Hand-written inverses for the zh patch's replacement FUNCTIONS (their output
// templates embed translated helper words, so mechanical inversion can't see
// through them). Each takes (match, ...captures) and returns the EN string or
// null to leave the node unchanged.
const FN_INVERSES = `
  // ── Hand-written inverses of the zh patch's replacement functions ──
  // Region names zh → en (Intl.DisplayNames, reversed from the zh patch).
  let regionNameTranslations = null
  function translateRegionName(region) {
    if (region === '你所在的地区') return 'your region'
    if (!regionNameTranslations) {
      regionNameTranslations = new Map()
      try {
        const chineseNames = new Intl.DisplayNames(['zh-CN'], { type: 'region' })
        const englishNames = new Intl.DisplayNames(['en'], { type: 'region' })
        for (let first = 65; first <= 90; first += 1) {
          for (let second = 65; second <= 90; second += 1) {
            const code = String.fromCharCode(first, second)
            const chinese = chineseNames.of(code)
            const english = englishNames.of(code)
            if (chinese && chinese !== code && english && english !== code) {
              regionNameTranslations.set(chinese, english)
            }
          }
        }
      } catch {
        // Keep the Chinese region name when Intl.DisplayNames is unavailable.
      }
    }
    return regionNameTranslations.get(region) ?? null
  }

  function restoreUnavailableRegion(_match, zhRegion) {
    const en = translateRegionName(zhRegion)
    return en === null ? null : \`Some models aren't available in \${en} yet\`
  }

  function restorePrivacyConnection(_match, signalList) {
    const labels = {
      '匿名网络': 'anonymized network',
      '代理': 'proxy',
      '中继': 'relay',
      '住宅代理': 'residential proxy',
      'Tor': 'Tor',
      'VPN': 'VPN',
      '托管网络': 'hosting network',
      '隐私服务': 'privacy service',
    }
    const restored = signalList
      .split('、')
      .filter(Boolean)
      .map((signal) => labels[signal] ?? signal)
      .join(', ')
    return \`Using a \${restored}? More models are available on a direct connection\`
  }

  function restoreSessionPeriod(period) {
    return period === '本周' ? 'this week' : 'today'
  }

  function restoreSessionUnit(premium) {
    return premium ? 'premium sessions' : 'sessions'
  }

  function restoreSessionScope(scope) {
    const translations = {
      '此额度仅适用于当前模型。': 'Specific to this model',
      '所有高级模型共享此额度。': 'Shared across all premium models',
      '所有可用免费模型共享此额度。': 'Shared across all available free models',
    }
    return translations[scope] ?? scope
  }

  function restoreSessionTier(tier) {
    const translations = {
      '高级会话': 'premium sessions',
      '当前模型的会话': 'sessions for this model',
      '会话': 'sessions',
    }
    return translations[tier] ?? tier
  }

  function restoreActiveSessionTooltip(_match, cost, activePremium, period, ratio, quotaPremium, scope, reset) {
    const unit = activePremium ? 'premium ' : ''
    const quotaUnit = quotaPremium ? 'premium ' : ''
    return \`Used \${cost} \${unit}sessions so far. Stays active between turns; ends when you close the tab or its 1-hour session expires. \${ratio} \${quotaUnit}sessions used \${restoreSessionPeriod(period)}. \${restoreSessionScope(scope)}. Each lasts up to 1 hour; closing the tab ends it early, counts only time used (rounded up to 0.1). Resets \${reset}.\`
  }

  function restoreSessionQuotaDetails(_match, period, ratio, premium, scope, reset) {
    const unit = premium ? 'premium ' : ''
    return \`\${ratio} \${unit}sessions used \${restoreSessionPeriod(period)}. \${restoreSessionScope(scope)}. Each lasts up to 1 hour; closing the tab ends it early, counts only time used (rounded up to 0.1). Resets \${reset}.\`
  }

  function restoreExhaustedSessionTooltip(_match, period, limit, tier, switchHint, reset) {
    const hint = switchHint ? ' Switch to DeepSeek V4 Flash to keep going.' : ''
    return \`You've used all \${limit} \${restoreSessionTier(tier)} \${restoreSessionPeriod(period)}.\${hint} Resets \${reset}.\`
  }

  function restoreOutOfSessions(_match, period, tier, remaining) {
    return \`Out of \${restoreSessionTier(tier)} \${restoreSessionPeriod(period)} · resets in \${remaining}\`
  }
`;

const FN_PATTERN_INVERSES = [
  { source: "^部分模型暂未在(.+)提供$", fn: "restoreUnavailableRegion" },
  { source: "^检测到正在使用(.+)；使用直连网络可获得更多模型$", fn: "restorePrivacyConnection" },
  { source: "^已使用 ([\\d,.]+) 个(高级)?会话。会话会在多轮对话间保持有效；关闭标签页或 1 小时窗口到期时结束。(今日|本周)已使用 ([\\d./]+) 个(高级)?会话。(此额度仅适用于当前模型。|所有高级模型共享此额度。|所有可用免费模型共享此额度。)每个会话最长持续 1 小时；提前关闭标签页会结束会话，仅按实际使用时长计费（向上取整到 0\\.1）。重置时间：(.+)。$", fn: "restoreActiveSessionTooltip" },
  { source: "^(今日|本周)已使用 ([\\d./]+) 个(高级)?会话。(此额度仅适用于当前模型。|所有高级模型共享此额度。|所有可用免费模型共享此额度。)每个会话最长持续 1 小时；提前关闭标签页会结束会话，仅按实际使用时长计费（向上取整到 0\\.1）。重置时间：(.+)。$", fn: "restoreSessionQuotaDetails" },
  { source: "^你已用尽(今日|本周)的 ([\\d,.]+) 个(高级会话|当前模型的会话|会话)。(切换到 DeepSeek V4 Flash 以继续。)?重置时间：(.+)。$", fn: "restoreExhaustedSessionTooltip" },
  { source: "^(今日|本周)的(高级会话|当前模型的会话|会话)已用尽 · 将在 (.+) 后重置$", fn: "restoreOutOfSessions" },
];

const patternInverted = new Map(); // inverse source → {flags, replacement|fn}
let mechanicalCount = 0;
let fnCount = 0;
let skipped = 0;
for (const entry of zhPatterns) {
  if (entry.replacement.kind === "fn") {
    const inv = FN_PATTERN_INVERSES.find((p) => p.fn === `restore${entry.replacement.name.replace("translate", "")}`);
    if (inv) {
      patternInverted.set(inv.source, { flags: "", fn: inv.fn });
      fnCount += 1;
    } else {
      console.warn(`  ! no hand inverse for function replacement: ${entry.replacement.name}`);
      skipped += 1;
    }
    continue;
  }
  const inv = invertPattern(entry.source, entry.flags, entry.replacement.v);
  if (!inv) {
    console.warn(`  ! not mechanically invertible: /${entry.source}/`);
    skipped += 1;
    continue;
  }
  if (!CJK_RE.test(inv.source)) {
    console.warn(`  ! inverse lacks CJK (zh patch emitted ASCII?): /${inv.source}/`);
    skipped += 1;
    continue;
  }
  if (!patternInverted.has(inv.source)) {
    patternInverted.set(inv.source, { flags: inv.flags, replacement: inv.replacement });
    mechanicalCount += 1;
  }
}
for (const p of FN_PATTERN_INVERSES) {
  if (!patternInverted.has(p.source)) {
    patternInverted.set(p.source, { flags: "", fn: p.fn });
    fnCount += 1;
  }
}
console.log(`inverted patterns: ${mechanicalCount} mechanical + ${fnCount} function-based (${skipped} skipped)`);

// No-capture patterns with a plain-string replacement are exact-string pairs.
let addedExact = 0;
for (const entry of zhPatterns) {
  if (entry.replacement.kind !== "string") continue;
  if (parseTemplate(entry.replacement.v).some((t) => t.type === "ref")) continue;
  if (entry.source.includes("\\d") || entry.source.includes("\\s") || entry.source.includes("\\w")) continue;
  const body = entry.source.replace(/^\^/, "").replace(/\$$/, "");
  if (!/^[^()\\]*$/.test(body)) continue; // only fully-literal sources
  const en = body.replace(/\\(.)/g, "$1");
  const zh = entry.replacement.v;
  if (!inverted.has(zh)) {
    inverted.set(zh, en);
    addedExact += 1;
  }
}
if (addedExact) console.log(`exact pairs recovered from literal patterns: ${addedExact}`);

const escapeSq = (s) => s.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
const mapLiteral = [...inverted.entries()]
  .map(([zh, en]) => `  '${escapeSq(zh)}': '${escapeSq(en)}',`)
  .join("\n");

const patternsLiteral = [...patternInverted.entries()]
  .map(([source, inv]) => {
    const re = `/${source}/${inv.flags}`;
    return inv.fn
      ? `    [/${source}/${inv.flags}, ${inv.fn}],`
      : `    [/${source}/${inv.flags}, '${escapeSq(inv.replacement)}'],`;
  })
  .join("\n");

// ── 3. Emit the runtime patch ──────────────────────────────────────────────
const body = `/*
 * freebuff-en.js — English front-end patch for Freebuff Desktop
 *
 * Runtime DOM localization layer restoring the English UI from a
 * Simplified-Chinese-localized Freebuff Desktop (e.g. after applying
 * Kfowever/freebuff-zh-patch). Same DOM-walk architecture as the zh patch,
 * with the translation direction inverted (zh → en).
 *
 * Derived from Kfowever/freebuff-zh-patch d34b01f (MIT) — translation tables
 * inverted by tools/gen-en-patch.mjs. No network access, no user-data access.
 *
 * Performance notes (vs the zh patch engine):
 *   - CJK fast-reject: every translation surface is CJK-gated, so strings
 *     without CJK codepoints return immediately (audited: all exact keys,
 *     patterns, and label tables require CJK).
 *   - The MutationObserver coalesces records into sets flushed in one
 *     microtask instead of spawning a TreeWalker per record.
 *   - Subtrees inside ignorable regions (code, prose, terminal…) are skipped
 *     wholesale instead of per-node.
 */
(() => {
  'use strict'

  const PATCH_ID = 'freebuff-en'
  const PATCH_VERSION = '0.6.2'
  if (globalThis.__FREEBUFF_EN_PATCH__?.id === PATCH_ID) return

  const CJK_RE = /[\\u3000-\\u303f\\u3400-\\u4dbf\\u4e00-\\u9fff\\uf900-\\ufaff\\uff01-\\uff5e]/

  // zh → en exact strings (inverted from the zh patch exact map).
  const exact = new Map(Object.entries({
${mapLiteral}
  }))

  // zh → en patterns for interpolated strings the zh patch renders via
  // regexes (mechanically inverted + hand-written function inverses).
  // Order matters: most specific first.
  const patterns = [
${patternsLiteral}
  ]

  const translatedAttributes = ['aria-label', 'aria-valuetext', 'data-tooltip', 'placeholder', 'title']

  // zh → en tool-header labels (context-gated, same selectors as the zh patch).
  const toolNameLabels = { 搜索: 'Search', 读取: 'Read', 运行: 'Run' }
  const toolStatusLabels = { 成功: 'success', 失败: 'failure', 运行中: 'running' }

${FN_INVERSES}
  const stats = { text: 0, attributes: 0, contextual: 0, displaced: 0, passes: 0 }

  // Content regions that are user data or code — never translated (same
  // ignore list as the zh patch, so behavior is identical in both directions).
  const ignoredContentSelector = [
    'script', 'style', 'code', 'pre', 'textarea',
    '[data-freebuff-en-ignore]',
    '[contenteditable]:not([contenteditable="false"])',
    '.bubble', '.user-sticky-bubble', '.user-message-text', '.prose',
    '.fold-reasoning-text', '.reasoning-text', '.act-arg',
    '.tool-row-details', '.file-view-body', '.change-diff', '.diff-comment-text',
    '.xterm', '.terminal-context-output', '.note-text', '.qnote',
  ].join(',')

  function shouldIgnoreContent(element) {
    return Boolean(element?.closest?.(ignoredContentSelector) ||
      (element?.closest?.('.byok-saved-heading') && element?.closest?.('strong')))
  }

  function translateValue(value) {
    if (typeof value !== 'string' || value.length === 0) return value
    if (!CJK_RE.test(value)) return value
    const leading = value.match(/^\\s*/)?.[0] ?? ''
    const trailing = value.match(/\\s*$/)?.[0] ?? ''
    const key = value.trim()
    if (!key) return value
    const direct = exact.get(key)
    if (direct !== undefined) return \`\${leading}\${direct}\${trailing}\`
    for (const [pattern, replacement] of patterns) {
      if (!pattern.test(key)) continue
      const out = typeof replacement === 'function'
        ? replacement(key, ...key.match(pattern).slice(1))
        : key.replace(pattern, replacement)
      if (out === null || out === undefined) continue
      return \`\${leading}\${out}\${trailing}\`
    }
    return value
  }

  function translateUiLabel(value, element) {
    const key = value.trim()
    let translated
    const isToolHeader =
      element.parentElement?.matches?.('.tool-row-head') &&
      element.parentElement.parentElement?.matches?.('.tool-row')
    if (isToolHeader && element.matches?.('.act-name') && Object.hasOwn(toolNameLabels, key)) {
      translated = toolNameLabels[key]
    } else if (isToolHeader && element.matches?.('.tool-row-status') && Object.hasOwn(toolStatusLabels, key)) {
      translated = toolStatusLabels[key]
    } else if (element.tagName === 'BUTTON' && element.matches?.('.quote-btn') && key === '引用') {
      translated = 'Quote'
    }
    return translated === undefined ? null : value.replace(key, translated)
  }

  function translateTextNode(node) {
    const before = node.nodeValue
    // Fast reject: no translation surface can change a CJK-free string.
    if (!before || !CJK_RE.test(before)) return
    const parent = node.parentElement
    if (!parent) return
    if (parent.matches?.('.agent-option-title') && parent.closest?.('.agent-provider-option')) return
    if (shouldIgnoreContent(parent)) return
    const after = translateUiLabel(before, parent) ?? translateValue(before)
    if (after !== before) {
      node.nodeValue = after
      stats.text += 1
    }
  }

  function translateAttributes(element) {
    if (shouldIgnoreContent(element)) return
    for (const name of translatedAttributes) {
      if (!element.hasAttribute(name)) continue
      const before = element.getAttribute(name)
      if (!CJK_RE.test(before)) continue
      const after = translateValue(before)
      if (after !== before) {
        element.setAttribute(name, after)
        stats.attributes += 1
      }
    }
  }

  function applyContextRules(scope) {
    if (!scope?.querySelectorAll) return
    // Restore the "Agent changed N files" heading the zh patch localized.
    for (const heading of scope.querySelectorAll('.turn-changes-head')) {
      if (shouldIgnoreContent(heading)) continue
      const label = Array.from(heading.querySelectorAll('span')).find((candidate) =>
        /^智能体修改了\\s+\\d+\\s+个文件$/.test(candidate.textContent.trim()))
      if (!label || shouldIgnoreContent(label)) continue
      const match = label.textContent.trim().match(/^智能体修改了\\s+(\\d+)\\s+个文件$/)
      if (!match) continue
      label.textContent = \`Agent changed \${match[1]} files\`
      stats.contextual += 1
    }
    // Note: the zh patch's .acts-toggle rule strips a trailing 's' child
    // (singular/plural split). Singular/plural is not recoverable from the
    // DOM, so this patch intentionally leaves those labels untouched.
  }

  function isTranslatableRoot(node) {
    return node.nodeType === Node.ELEMENT_NODE ||
      node.nodeType === Node.DOCUMENT_NODE ||
      node.nodeType === Node.DOCUMENT_FRAGMENT_NODE
  }

  function translateTree(root) {
    if (!root) return
    if (root.nodeType === Node.TEXT_NODE) {
      translateTextNode(root)
      applyContextRules(root.parentElement)
      return
    }
    if (!isTranslatableRoot(root)) return
    // Whole ignorable subtrees (user code, prose, terminals) are skipped —
    // every node inside would fail shouldIgnoreContent anyway.
    if (root.nodeType === Node.ELEMENT_NODE && shouldIgnoreContent(root)) return
    if (root.nodeType === Node.ELEMENT_NODE) translateAttributes(root)
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_ELEMENT | NodeFilter.SHOW_TEXT)
    let current
    while ((current = walker.nextNode())) {
      if (current.nodeType === Node.TEXT_NODE) translateTextNode(current)
      else if (!shouldIgnoreContent(current)) translateAttributes(current)
    }
    applyContextRules(root)
    stats.passes += 1
  }

  function start() {
    // Take over from a live zh patch: its observer would re-translate every
    // node this patch restores (mutual ping-pong). Disconnecting it makes
    // this patch a true restore layer.
    const zhObserver = globalThis.__FREEBUFF_ZH_PATCH__?.observer
    if (zhObserver?.disconnect) {
      zhObserver.disconnect()
      stats.displaced += 1
    }
    document.documentElement.lang = 'en'
    translateTree(document.documentElement)
    // Coalesce mutation bursts: dedupe targets in sets, flush in one
    // microtask (before paint, same-frame latency as per-record handling).
    const pendingText = new Set()
    const pendingAttrs = new Set()
    const pendingNodes = new Set()
    let scheduled = false
    const flush = () => {
      scheduled = false
      const text = [...pendingText]; pendingText.clear()
      const attrs = [...pendingAttrs]; pendingAttrs.clear()
      const nodes = [...pendingNodes]; pendingNodes.clear()
      for (const node of nodes) translateTree(node)
      for (const node of text) translateTree(node)
      for (const element of attrs) translateAttributes(element)
    }
    const schedule = () => {
      if (scheduled) return
      scheduled = true
      queueMicrotask(flush)
    }
    const observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (mutation.type === 'characterData') pendingText.add(mutation.target)
        else if (mutation.type === 'attributes') pendingAttrs.add(mutation.target)
        else for (const node of mutation.addedNodes) pendingNodes.add(node)
      }
      schedule()
    })
    observer.observe(document.documentElement, {
      subtree: true,
      childList: true,
      characterData: true,
      attributes: true,
      attributeFilter: translatedAttributes,
    })
    globalThis.__FREEBUFF_EN_PATCH__.observer = observer
  }

  globalThis.__FREEBUFF_EN_PATCH__ = {
    id: PATCH_ID,
    version: PATCH_VERSION,
    stats,
    translate: translateValue,
    translateAll: () => translateTree(document.documentElement),
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start, { once: true })
  else start()
})()
`;

fs.writeFileSync(outPath, body);
console.log(`wrote ${outPath} (${(fs.statSync(outPath).size / 1024).toFixed(1)} KB)`);
