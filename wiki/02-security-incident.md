# 02 — Security Incident: Leaked Keys

## How the leak happened

Past sessions ran `cat`/`export` dumps of `~/.env-tokens/ai-agent-tokens-full.env` to inspect or debug tokens. That tool output was stored verbatim in opencode's DB (`part` + `event` tables), the tool-output cache, and logs — so every key in the file was effectively disclosed to anything that could read the session history (including the markdown archive and any DB backup).

## Inventory at discovery

~39 distinct exposed values across ~25 services, including: 12 GitHub tokens (8 classic `ghp_`, 4 fine-grained), 5–6 OpenCode Zen-family keys, OpenRouter ×5, Groq ×6, DeepSeek ×4, Cerebras ×3, Moonshot ×2, MiniMax ×2, Fireworks, HuggingFace, SiliconFlow ×2, Nous, Zenmux, plus locally-issued `fbu_` proxy keys.

## GitHub audit (Sep 11–12)

**11 of 12 leaked tokens were still valid on `marktantongco`; the Sep 12 re-check found 18/18 candidates live (12 distinct — several env vars share tokens), zero revoked.**

- 7 classic PATs carry **full admin scopes**: `delete_repo`, `admin:org`, `admin:ssh_signing_key`, `workflow`, `admin:enterprise`, `admin:gpg_key`, `admin:org_hook`, `audit_log`, `copilot`, `gist`, `project`, `write:packages`…
- 4 fine-grained `github_pat_11A…` tokens also live
- The **active `gh` CLI keyring credential is itself a leaked token** (`ghp_BPBd…nBKw`) — revoke last, re-auth first

### Abuse evidence check — none found

| Check | Result |
|---|---|
| Account SSH keys | All pre-date the leak window (Feb–Jul), all recognizable (`Termuxcli`, `Termuxandroid`, `opencode`, `x1`) |
| Public + private event history | Matches own work (owl-engine, obsidianvault, heretic-installer, unified-freebuff-proxy) |
| Org audit logs (`sonstone`, `marky-tanky`, `markworthyco`) | API unavailable — requires GitHub Enterprise plan |
| Provider-side usage (OpenRouter/DeepSeek/Groq + 7 more) | Tiny values consistent with own agent traffic; DeepSeek keys at $0.00; free tiers |

## Blast-radius assessment

- **GitHub = critical tier**: 12 private repos, 3 orgs, admin-everything scopes
- **Model APIs = quota burn**: free tiers mean near-zero financial damage potential

## Provider sweep status (Sep 12)

| Status | Keys |
|---|---|
| ✅ VALID (22) | 6× Groq, 4× DeepSeek ($0.00), 5× OpenRouter, 3× Cerebras, 2× MiniMax, Fireworks, Nous, Zenmux, HuggingFace, 6× OpenCode Zen (incl. Go) |
| 💀 Already dead (3) | `MOONSHOT_QHAP`, both SiliconFlow keys — exposure moot |

Dashboard URLs for per-call logs (APIs don't expose them):

- OpenRouter → `openrouter.ai/credits` + `openrouter.ai/activity`
- Groq → `console.groq.com/settings/usage`
- DeepSeek → `platform.deepseek.com/usage`
