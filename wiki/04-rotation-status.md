# 04 — Rotation Status & Open Items

**Status as of Sep 12, 2026 — rotation is IN PROGRESS, not complete.**

## Done

| Key | Status |
|---|---|
| `fbu_5ace…`, `fbu_e33a…` | ✅ ROTATED + verified (200/401) |

## Pending — GitHub (CRITICAL)

**12 distinct leaked tokens still valid (18/18 env candidates live). Zero revoked.**

Attempted twice via pasted replacement tokens — both times the pasted values matched the **old leaked tokens exactly** (copied from the env file/dashboard list instead of freshly generated). Wiring was correctly refused. A device-flow login was started once but the user code expired un-authorized.

### Correct procedure (device flow — no pasting, no copy mistakes)

```bash
# Agent mints a device code (15-min validity):
curl -s -X POST https://github.com/login/device/code \
  -H "Accept: application/json" \
  -d "client_id=178c6fc778ccc68e1d6a&scope=repo%20workflow%20read%3Aorg%20gist"
# User opens https://github.com/login/device, enters the code, authorizes.
# Agent polls https://github.com/login/oauth/access_token to receive the token
# server-side (never displayed, never pasted) → gh auth login --with-token.
```

Then: `gh auth setup-git` → update `GITHUB_PAT` in `ai-agent-tokens-full.env` → regenerate `agent-env` → **only then** revoke the 12 old tokens in *Settings → Developer settings* (8 classic + 4 fine-grained) → liveness re-check expects 12× 401.

### Replacement token spec (if creating a fine-grained PAT manually)

Resource owner `marktantongco`, All repositories, Contents/Issues/Pull requests/Workflows = Read and write, Metadata = Read (locked), 90-day expiry. Gists need a separate classic token with only the `gist` scope. Org repos require fine-grained PAT access enabled per org.

## Pending — OpenCode Zen family (5 keys)

First attempt on Sep 12 **failed safely**: 4 of 5 pasted values were the old leaked keys (string-identical), and the one genuinely new key was rejected with HTTP 403 (Cloudflare error 1010 on every `opencode.ai` endpoint — also affected the currently-valid keyring key, indicating a probe-side WAF block, not necessarily a dead key).

Keys to rotate (all still valid): `OPENCODE_ZEN_VVCW`, `_MRYV` (= `opencode` keyring credential), `_FLUB`, `_NBVR`, `OPENCODE_GO_UKAJ` (= `opencode-go` keyring credential). Consumers: env file + `agent-env` + 2× `auth.json` + possible `opencode.jsonc.bak*` copies.

⚠️ Rotation rule learned the hard way: a new key exists only on the green post-creation banner. If a pasted value matches the old one, **stop and regenerate** — never wire it.

## Pending — other third-party (low urgency)

Groq ×6, DeepSeek ×4, OpenRouter ×5, Cerebras ×3, MiniMax ×2, Fireworks, Nous, Zenmux, HuggingFace — all valid, no anomalous usage; rotate per checklist when convenient. Moonshot `QHAP` + SiliconFlow ×2 already dead.
