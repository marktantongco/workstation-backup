#!/usr/bin/env node
/**
 * Round-trip test: apply the upstream zh patch (EN→ZH), then the EN patch
 * (ZH→EN) in a simulated DOM (happy-dom), and verify the UI text is restored.
 * Run: node tests/roundtrip.test.mjs [path-to-zh-patch]
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..");
const zhPath = process.argv[2] ?? "/tmp/fp-research/kfowever/freebuff-zh-cn.js";
const enPath = path.join(root, "freebuff-en.js");

// happy-dom does not resolve via NODE_PATH for ESM imports, so try a local
// install first, then common dev-deps locations.
function loadHappyDom() {
  try {
    return require("happy-dom");
  } catch {}
  for (const base of ["/tmp/en-patch-deps/node_modules", path.join(root, "node_modules")]) {
    try {
      return createRequire(path.join(base, "noop.js"))("happy-dom");
    } catch {}
  }
  return null;
}
const happydom = loadHappyDom();
if (!happydom) {
  console.error("happy-dom is required. Install once, then rerun:");
  console.error("  mkdir -p /tmp/en-patch-deps && cd /tmp/en-patch-deps && npm i happy-dom@15");
  process.exit(2);
}
const { Window } = happydom;

const win = new Window({ url: "https://freebuff.local/" });
const doc = win.document;
doc.documentElement.lang = "zh-CN";
doc.body.innerHTML = `
  <button class="btn">Smart &amp; Fast</button>
  <span class="tool-row"><span class="tool-row-head"><span class="act-name">Search</span><span class="tool-row-status">success</span></span></span>
  <input placeholder="Your API key" title="Freebucks balance" aria-label="Connect a provider">
  <span class="turn-changes-head"><span>Agent changed 3 files</span></span>
  <div class="user-message-text">Never touch this user text</div>
  <code>never translate code 智能且快速</code>
  <span id="interp">Context 87%</span>
  <span id="interp2">Account: alice</span>
`;
await new Promise((r) => setTimeout(r, 25));

const run = (scriptPath) => win.eval(fs.readFileSync(scriptPath, "utf8"));

const fail = (msg) => { console.error(`FAIL ${msg}`); process.exitCode = 1; };

// ── Phase 0: EN baseline ──
const before = doc.querySelector(".btn").textContent.trim();
if (before !== "Smart & Fast") fail(`fixture sanity: expected EN start, got "${before}"`);

// ── Phase 1: upstream zh patch EN→ZH ──
run(zhPath);
await new Promise((r) => setTimeout(r, 25));
const zhBtn = doc.querySelector(".btn").textContent.trim();
if (zhBtn !== "智能且快速") fail(`zh patch did not translate button: got "${zhBtn}"`);

// ── Phase 2: EN patch ZH→EN restore ──
run(enPath);
await new Promise((r) => setTimeout(r, 25));

let failures = 0;
const expectText = (sel, want) => {
  const got = doc.querySelector(sel)?.textContent.trim();
  if (got !== want) { fail(`${sel}: got "${got}" want "${want}"`); failures++; }
};
expectText(".btn", "Smart & Fast");
expectText(".act-name", "Search");
expectText(".tool-row-status", "success");

const el = doc.querySelector("input");
for (const [attr, want] of [["placeholder", "Your API key"], ["title", "Freebucks balance"], ["aria-label", "Connect a provider"]]) {
  const got = el.getAttribute(attr);
  if (got !== want) { fail(`input[${attr}]: got "${got}" want "${want}"`); failures++; }
}

expectText(".turn-changes-head span", "Agent changed 3 files");

const protectedText = doc.querySelector(".user-message-text").textContent.trim();
if (protectedText !== "Never touch this user text") { fail(`user content altered: "${protectedText}"`); failures++; }

const codeText = doc.querySelector("code").textContent.trim();
if (codeText !== "never translate code 智能且快速") { fail(`code content altered: "${codeText}"`); failures++; }

// Mechanical pattern inversions (regex families restored in v0.6.2).
expectText("#interp", "Context 87%");
expectText("#interp2", "Account: alice");

// Region-name inversion via Intl.DisplayNames (restoreUnavailableRegion).
const api = win.__FREEBUFF_EN_PATCH__;
if (api?.translate) {
  const zhRegion = new Intl.DisplayNames(["zh-CN"], { type: "region" }).of("JP");
  const restored = api.translate(`部分模型暂未在${zhRegion}提供`);
  if (restored !== "Some models aren't available in Japan yet") {
    fail(`region inverse: got "${restored}"`);
    failures++;
  }
  // Pure-English input must pass through untouched (CJK fast-reject).
  const en = "Totally ordinary English sentence with 123 numbers.";
  if (api.translate(en) !== en) { fail("fast-reject: English string was modified"); failures++; }
}

const lang = doc.documentElement.getAttribute("lang");
if (lang !== "en") { fail(`lang: ${lang}`); failures++; }

const stats = win.__FREEBUFF_EN_PATCH__?.stats;
console.log("en patch stats:", stats);
if (!stats || stats.text === 0) { fail("en patch recorded no translations"); failures++; }

// ── Phase 3: MutationObserver reactivity — inject a new zh node post-patch ──
const dyn = doc.createElement("div");
dyn.textContent = "你的 API 密钥";
doc.body.appendChild(dyn);
await new Promise((r) => setTimeout(r, 25));
if (dyn.textContent.trim() !== "Your API key") { fail(`observer: got "${dyn.textContent.trim()}" want "Your API key"`); failures++; }

const failed = failures + (process.exitCode === 1 ? 1 : 0);
console.log(failed === 0 ? "\nROUND-TRIP OK: EN→ZH→EN restored the UI" : `\n${failed} check(s) failed`);
process.exit(process.exitCode ?? 0);
