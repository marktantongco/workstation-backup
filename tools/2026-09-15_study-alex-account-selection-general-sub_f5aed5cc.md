# Study alex account selection (@general subagent)

- **Session ID:** `ses_f5aed5cc9ffeItkpC2pjoLjNP7`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-15 20:37:37
- **Last activity:** 2026-09-15 20:39:14
- **Messages:** 10

---

### 🧑 User — 2026-09-15 20:37:37

Read and analyze the alex project's account selection and routing policies. Focus on:

1. `/home/x3/workspace/alex/docs/providers-and-routing.md` - how providers are routed
2. `/home/x3/workspace/alex/docs/configuration.md` - configuration structure
3. `/home/x3/workspace/alex/docs/api-and-formats.md` - API formats
4. `/home/x3/workspace/alex/crates/alex-core/src/` - any account selection logic

Extract the key patterns for:
- How accounts are selected (priority, round-robin, threshold, etc.)
- How failover works between accounts
- How provider pools are managed
- How health checks work

Return a concise summary (max 500 words) of the most useful patterns that could improve BlacklistedAIProxy's provider selection.

---

### 🤖 Assistant — 2026-09-15 20:37:38

> The user wants me to analyze the alex project's provider selection and routing patterns. Let me read the specified documentation files and source code to extract the key patterns.

Using parallel-search to read all sources simultaneously.

**tool:octocode_localGetFileContent** (completed) 

```
queries=[{'goal': 'Read providers and routing docs', 'reasoning': 'Extract routing polic
--- output ---
base: /home/x3/workspace/alex/docs

result: 0
data:
  path: providers-and-routing.md
  contentView: none
  totalLines: 212
  sourceChars: 10647
  returnedChars: 10647
  fileType: doc
  modified: 2026-09-15T12:16:44.475Z
content (copy-safe):
# Providers, vault accounts, and routing

Alex routes a model name to a provider, selects an eligible account for
that provider, translates the request if needed, and injects credentials from
the local vault. Provider choice, account choice, and model fallback are three
separate decisions.

See [Configuration](configuration.md) for `[account_policy.*]`,
`[substitution]`, and `[protection]`; see [API and formats](api-and-formats.md)
for dialect conversion.

## Provider implementations

| Provider | Vault material and upstream | Formats accepted at ingress | Notes |
| --- | --- | --- | --- |
| Anthropic / Claude | OAuth subscription or API key; direct Messages API, or supervised Dario for eligible subscription traffic | All four dialects | Anthropic Messages is the translation pivot. Genuine Claude Code requests bypass Dario and preserve an allowlist of CLI headers. |
| OpenAI / Codex | ChatGPT/Codex OAuth or OpenAI API key | All four dialects | OAuth uses the ChatGPT Codex Responses backend and thread/account affinity. API keys use public OpenAI Chat/Responses. |
| Gemini / Google | Gemini CLI OAuth (Code Assist) or Google AI Studio API key | All four dialects | API-key accounts are preferred. OAuth requests use a discovered/configured Google project and the Code Assist envelope. |
| Grok / xAI | Grok OAuth subscription | Anthropic Messages or OpenAI Chat | Upstream is OpenAI-chat-compatible. Responses and Gemini ingress return `501 Not Implemented` for this provider. |
| Kimi Code | Imported or device-flow OAuth | Anthropic Messages or OpenAI Chat | Routes to Kimi's coding Chat Completions endpoint. Responses and Gemini ingress are not implemented. |
| OpenRouter | API key plus optional HTTP-Referer/X-Title attribution | Anthropic Messages or OpenAI Chat | Model IDs are `openrouter/<vendor>/<model>`. Only the configured curated subset is advertised to harnesses. |
| CLIProxyAPI | User-managed URL and bearer credential | Anthropic Messages, OpenAI Chat, or OpenAI Responses | Upstream models use `cliproxyapi/<model>`. The reverse CLIProxyAPI → Alex arrangement is generated with `alex cliproxyapi export`. |
| Amp | Amp access token/API key | None | Billing and reverse-wrap capture only. `alex wrap amp` handles the product protocol; `/v1` routing returns `501`. |
| Exo | No vault account; configured local URL and dummy bearer auth | Anthropic Messages or OpenAI Chat | Local OpenAI-chat-compatible provider, enabled per model with `exo_enabled_models`. |

## Adding credentials

Native import reads installed tool credentials:

```bash
alex auth import all
alex auth import kimi --name work
```

Import sources are `claude`, `codex`, `gemini`, `grok`/`xai`, `amp`, `kimi`,
or `all`. Terminal login supports `claude`, `codex`, `grok`, `gemini`, `amp`,
and `kimi` (provider aliases are accepted):

```bash
alex auth login codex --name work
alex auth login claude --name personal
```

API-key-only registration has dedicated commands:

```bash
GEMINI_API_KEY='redacted' alex auth gemini-key
OPENROUTER_API_KEY='redacted' alex auth openrouter-key \
  --referer https://example.invalid --title 'Local Alex'
AMP_API_KEY='redacted' alex auth amp-key
```

Account names must match `[a-z0-9_-]{1,32}`. `--force` replaces an existing
named login. Account JSON files live under `<data_dir>/accounts/` and are
permission-restricted local secret material; encrypted portability is provided
by `alex vault export`, not by claiming those JSON files are ciphertext.

## Multi-account vault

Each account has a provider, kind (`oauth`, `api_key`, or product-specific),
name, status, pause state, optional refresh/expiry data, observed quota
metadata, and credentials. The vault:

- refreshes eligible OAuth accounts before use;
- skips accounts that are inactive, explicitly paused, disabled by policy, or
  excluded after a failed attempt;
- honors cooldowns after transient failures;
- records removed-account tombstones so historical traces remain attributable;
- can merge duplicate accounts and re-key their trace history with
  `alex auth merge`.

Pausing an account is persistent:

```bash
alex auth pause codex work
alex auth resume codex work
```

`alex provider pause` is different: it is an in-memory provider-wide fault
control used to simulate `down` or `logged_out` behavior and is cleared by
resume or daemon restart.

## Account selection policies

Policies are stored by canonical provider under `[account_policy.<provider>]`.
The implementation recognizes four modes:

| Mode | Selection order |
| --- | --- |
| `priority` | Prefer the configured `order`; reserve-blocked accounts sort after available accounts. This is the general default. |
| `round_robin` | Rotate among ready accounts in the best credential/routing rank. If every ready account is reserve-blocked, rotate through that ready set. |
| `threshold` | Sort accounts at or above `threshold_pct` (default 80) after accounts below it, then apply configured order. |
| `reset_first` | Prefer the account whose binding active quota window resets earliest, after credential and reserve checks. This is the OpenAI default. |

Common fields:

| Key | Meaning |
| --- | --- |
| `order = ["work", "personal"]` | Account-name priority. Unlisted accounts follow listed accounts. |
| `mode = "priority"` | One of the four modes above. |
| `threshold_pct = 80` | Threshold-mode utilization boundary. |
| `reserve_pct = 10` | Provider default capacity reserve. If absent, selection uses 10%. |
| `account_reserve_pct = { work = 20 }` | Per-account override by name or ID. |
| `allow_mid_thread_failover = true` | Whether an already-affined OpenAI/Codex thread can move accounts after an eligible failure. |
| `disabled = ["old-account"]` | Accounts excluded from proxy selection without changing their account file status. |

Example:

```toml
[account_policy.openai]
mode = "reset_first"
order = ["work", "personal"]
reserve_pct = 10
allow_mid_thread_failover = true
disabled = []

[account_policy.openai.account_reserve_pct]
work = 15
personal = 5
```

The CLI exposes reserve changes without requiring a manual TOML edit:

```bash
alex routing set codex --reserve-pct 15 --account work
alex routing get codex --json
```

An account is reserve-blocked when an active observed quota window reaches
`100 - reserve_pct` percent used. A reserve of zero disables this gate. `alex
limits` reports the captured/discovered windows and reset times used by the
router. Multiple accounts increase aggregate usable subscription capacity
(the project calls this tokenmax), but they remain independently metered
accounts rather than one upstream credential.

## Model-to-provider routing

`route_model` first strips a harness namespace (`alex/`,
`cove/`, or Claude-compatible `claude-alex/`), then resolves an explicit
provider prefix.

| Example client model | Provider | Upstream model |
| --- | --- | --- |
| `alex/claude/sonnet-5` | Anthropic | `claude-sonnet-5` |
| `openai/gpt-5.6-sol` | OpenAI | `gpt-5.6-sol` |
| `gemini:gemini-2.5-flash` | Gemini | `gemini-2.5-flash` |
| `openrouter/deepseek/deepseek-v4-pro` | OpenRouter | `deepseek/deepseek-v4-pro` |
| `kimi/k3` | Kimi | `k3` |
| `exo/local-model` | Exo | `local-model` |

Accepted explicit aliases include `claude`/`anthropic`,
`openai`/`codex`/`chatgpt`, `gemini`/`google`, `grok`/`xai`, `openrouter`,
`exo`, and `kimi`. Short Anthropic aliases such as `sonnet-5` and `opus-4.8`
are expanded after their provider prefix.

Without a provider prefix, names beginning with `claude`, `gpt`, `codex`,
`chatgpt`, `o<digit>`, `gemini`, or `grok` are inferred. Otherwise the client
dialect decides: Anthropic ingress defaults to Anthropic, OpenAI ingress to
OpenAI, and Gemini ingress to Gemini.

## Affinity and failover

Codex Responses conversations use a derived session key to remain on the same
OpenAI account for prompt-cache continuity. An eligible preferred account wins
unless it is paused, disabled, excluded, or (normally) cooling. The mapping is
bounded and expires after 30 days. When mid-thread failover is enabled, a
successful failover rebinds the session to the replacement account.

The proxy retries another account only for its coarse `capacity` and `server`
error classes. Auth, bad-request, client-disconnect, network, and other errors
are not ordinary account-failover triggers. A retry account must be ready and
not reserve-blocked; the selector's degraded "soonest cooldown" escape hatch is
not used for retries.

## Fable 5 → GPT-5.6 Sol fallback

Alex ships one default middleware rule: `alex.fable-5-to-gpt-5.6-sol`.
Anthropic returns Fable safeguards as an HTTP `200` SSE stream whose terminal
`message_delta` has `delta.stop_reason = "refusal"`. Alex incrementally parses
that event and matches the normalized `upstream_refusal` kind regardless of
category (`bio`, `cyber`, or a future category). It then retries with
high-effort `gpt-5.6-sol` through OpenAI and keeps that route for the same
stable session for 24 hours. The request header `x-alex-no-substitute: 1`
disables interception and rerouting for that request.

This is structured SSE parsing, not substring matching. Alex holds only the
undecided prefix. A refusal is intercepted before any bytes reach the harness;
a normal response resumes unchanged as soon as text or a tool call proves it
```

**tool:glob** (completed) alex/crates/alex-core/src

```
pattern=**/*.rs; path=/home/x3/workspace/alex/crates/alex-core/src
--- output ---
/home/x3/workspace/alex/crates/alex-core/src/testing_overrides.rs
/home/x3/workspace/alex/crates/alex-core/src/quota.rs
/home/x3/workspace/alex/crates/alex-core/src/translate.rs
/home/x3/workspace/alex/crates/alex-core/src/resume_context.rs
/home/x3/workspace/alex/crates/alex-core/src/lib.rs
/home/x3/workspace/alex/crates/alex-core/src/openrouter_catalog.rs
/home/x3/workspace/alex/crates/alex-core/src/grok_billing.rs
/home/x3/workspace/alex/crates/alex-core/src/exec.rs
/home/x3/workspace/alex/crates/alex-core/src/amp_usage.rs
```

---

### 🤖 Assistant — 2026-09-15 20:37:55

> I have the docs. Let me check the quota.rs for the actual account selection logic since that's where reserve thresholds would be implemented.

**tool:read** (completed) alex/crates/alex-core/src/quota.rs

```
filePath=/home/x3/workspace/alex/crates/alex-core/src/quota.rs
--- output ---
<path>/home/x3/workspace/alex/crates/alex-core/src/quota.rs</path>
<type>file</type>
<content>
1: //! The single, normalized presentation state for a provider's binding quota.
2: //!
3: //! A request-rate window is not useful evidence that a credit-metered account
4: //! can serve traffic.  Keep that decision at the daemon boundary so every
5: //! client presents the same primary constraint.
6: 
7: use serde_json::{json, Value};
8: 
9: use crate::Provider;
10: 
11: fn boolish(value: &Value) -> Option<bool> {
12:     value.as_bool().or_else(|| {
13:         value
14:             .as_str()
15:             .and_then(|s| match s.trim().to_ascii_lowercase().as_str() {
16:                 "true" => Some(true),
17:                 "false" => Some(false),
18:                 _ => None,
19:             })
20:     })
21: }
22: 
23: fn non_empty_display(value: &Value) -> Option<String> {
24:     if let Some(s) = value.as_str() {
25:         let s = s.trim();
26:         return (!s.is_empty()).then(|| s.to_string());
27:     }
28:     value.as_f64().map(|n| n.to_string())
29: }
30: 
31: fn top_up_url(provider: Provider) -> &'static str {
32:     match provider {
33:         Provider::Xai => "https://grok.com/settings/billing",
34:         Provider::Amp => "https://ampcode.com/settings",
35:         _ => "",
36:     }
37: }
38: 
39: /// Return the quota a user should treat as binding for this limits entry.
40: ///
41: /// Only xAI/SuperGrok and Amp are credit-metered here.  OpenAI's captured
42: /// `credits` headers must not make its subscription 5h/7d windows disappear.
43: pub fn quota_state(provider: Provider, limits: &Value) -> Value {
44:     if !matches!(provider, Provider::Xai | Provider::Amp) {
45:         return json!({"kind": "rate_window", "label": "Rate window"});
46:     }
47: 
48:     let credits = &limits["credits"];
49:     if boolish(&credits["unlimited"]) == Some(true) {
50:         return json!({"kind": "unlimited", "label": "Unlimited credits"});
51:     }
52:     if boolish(&credits["has_credits"]) == Some(false) {
53:         return json!({
54:             "kind": "out_of_credits",
55:             "label": "Out of credits",
56:             "top_up_url": top_up_url(provider),
57:         });
58:     }
59:     if let Some(balance) = non_empty_display(&credits["balance"]) {
60:         return json!({"kind": "balance", "label": "Credit balance", "balance": balance});
61:     }
62: 
63:     // Grok's billing endpoint reports a credit percentage even when it cannot
64:     // report a currency balance.  It is still a credit quota, not a rate limit.
65:     if let Some(used_pct) = credits["used_pct"].as_f64() {
66:         return json!({
67:             "kind": "credit_window",
68:             "label": "Credit quota",
69:             "used_pct": used_pct,
70:             "remaining_pct": (100.0 - used_pct).clamp(0.0, 100.0),
71:         });
72:     }
73: 
74:     json!({"kind": "rate_window", "label": "Rate window"})
75: }
76: 
77: #[cfg(test)]
78: mod tests {
79:     use super::*;
80: 
81:     #[test]
82:     fn out_of_credits_is_binding_even_when_a_window_looks_empty() {
83:         let state = quota_state(
84:             Provider::Xai,
85:             &json!({
86:                 "credits": {"has_credits": false, "unlimited": false},
87:                 "windows": [{"window": "7d", "used_pct": 1.0}],
88:             }),
89:         );
90:         assert_eq!(state["kind"], "out_of_credits");
91:     }
92: 
93:     #[test]
94:     fn unlimited_credits_win() {
95:         let state = quota_state(
96:             Provider::Xai,
97:             &json!({
98:                 "credits": {"has_credits": false, "unlimited": true},
99:             }),
100:         );
101:         assert_eq!(state["kind"], "unlimited");
102:     }
103: 
104:     #[test]
105:     fn balance_is_presented_for_credit_providers() {
106:         let state = quota_state(
107:             Provider::Amp,
108:             &json!({
109:                 "credits": {"has_credits": true, "balance": "$20.95"},
110:             }),
111:         );
112:         assert_eq!(state["kind"], "balance");
113:         assert_eq!(state["balance"], "$20.95");
114:     }
115: 
116:     #[test]
117:     fn missing_credit_evidence_falls_back_to_rate_window() {
118:         let state = quota_state(
119:             Provider::Amp,
120:             &json!({
121:                 "windows": [{"window": "free", "used_pct": 20.0}],
122:             }),
123:         );
124:         assert_eq!(state["kind"], "rate_window");
125:     }
126: 
127:     #[test]
128:     fn subscription_providers_keep_their_rate_windows() {
129:         let state = quota_state(
130:             Provider::Openai,
131:             &json!({
132:                 "credits": {"has_credits": false, "unlimited": false},
133:                 "windows": [{"window": "7d", "used_pct": 1.0}],
134:             }),
135:         );
136:         assert_eq!(state["kind"], "rate_window");
137:     }
138: 
139:     #[test]
140:     fn credit_provider_quota_variants_are_normalized() {
141:         let cases = [
142:             (
143:                 "string unlimited",
144:                 Provider::Xai,
145:                 json!({"credits": {"unlimited": " TRUE "}}),
146:                 "unlimited",
147:                 None,
148:             ),
149:             (
150:                 "string out of credits",
151:                 Provider::Amp,
152:                 json!({"credits": {"has_credits": "false"}}),
153:                 "out_of_credits",
154:                 None,
155:             ),
156:             (
157:                 "numeric balance",
158:                 Provider::Amp,
159:                 json!({"credits": {"has_credits": true, "balance": 12.5}}),
160:                 "balance",
161:                 Some("12.5"),
162:             ),
163:             (
164:                 "credit utilization",
165:                 Provider::Xai,
166:                 json!({"credits": {"has_credits": true, "used_pct": 37.25}}),
167:                 "credit_window",
168:                 None,
169:             ),
170:             (
171:                 "unknown boolean text",
172:                 Provider::Xai,
173:                 json!({"credits": {"has_credits": "unknown"}}),
174:                 "rate_window",
175:                 None,
176:             ),
177:         ];
178: 
179:         for (name, provider, limits, kind, balance) in cases {
180:             let state = quota_state(provider, &limits);
181:             assert_eq!(state["kind"], kind, "{name}");
182:             assert_eq!(state["balance"].as_str(), balance, "{name}");
183:             if name == "credit utilization" {
184:                 assert_eq!(state["remaining_pct"], 62.75);
185:             }
186:         }
187:     }
188: }

(End of file - total 188 lines)
</content>
```

**tool:read** (completed) alex/crates/alex-core/src/lib.rs

```
filePath=/home/x3/workspace/alex/crates/alex-core/src/lib.rs
--- output ---
<path>/home/x3/workspace/alex/crates/alex-core/src/lib.rs</path>
<type>file</type>
<content>
1: pub mod amp_usage;
2: pub mod exec;
3: pub mod grok_billing;
4: pub mod openrouter_catalog;
5: pub mod quota;
6: pub mod resume_context;
7: pub mod testing_overrides;
8: pub mod translate;
9: 
10: pub use amp_usage::{
11:     parse_usage_api_response, parse_usage_display_text, usage_to_limits_entry, AmpUsageSnapshot,
12:     AmpWorkspaceBalance,
13: };
14: pub use grok_billing::{
15:     grok_credits_endpoint, parse_grpc_web_response, validate_grpc_status_headers, window_label,
16:     GrokWebBillingError, GrokWebBillingSnapshot, GROK_CREDITS_ENDPOINT, GROK_CREDITS_REQUEST_BODY,
17: };
18: pub use openrouter_catalog::parse_models_response as parse_openrouter_models_response;
19: pub use quota::quota_state;
20: pub use resume_context::{
21:     build_resume_context, build_resume_context_from_captures, request_entries, ResumeCapture,
22:     ResumeContext, ResumeEntry,
23: };
24: pub use testing_overrides::{
25:     allowed_override_url, resolve_endpoint_override, resolve_endpoint_url, ALLOW_REMOTE_ENV,
26:     FAKE_UPSTREAM_ENV,
27: };
28: 
29: use serde::{Deserialize, Serialize};
30: use serde_json::Value;
31: 
32: #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
33: #[serde(rename_all = "lowercase")]
34: pub enum Provider {
35:     Anthropic,
36:     Openai,
37:     Gemini,
38:     Xai,
39:     Openrouter,
40:     /// A user-managed CLIProxyAPI instance exposed as an OpenAI-compatible
41:     /// upstream. Kept distinct so traces preserve the integration boundary.
42:     Cliproxyapi,
43:     Exo,
44:     /// Amp subscription / credits (billing + wrap harness; not a /v1 upstream route yet).
45:     Amp,
46:     /// Kimi Code (Moonshot AI) subscription — OAuth device flow, OpenAI-compatible
47:     /// upstream at `https://api.kimi.com/coding/v1`.
48:     Kimi,
49: }
50: 
51: impl Provider {
52:     pub fn as_str(self) -> &'static str {
53:         match self {
54:             Provider::Anthropic => "anthropic",
55:             Provider::Openai => "openai",
56:             Provider::Gemini => "gemini",
57:             Provider::Xai => "xai",
58:             Provider::Openrouter => "openrouter",
59:             Provider::Cliproxyapi => "cliproxyapi",
60:             Provider::Exo => "exo",
61:             Provider::Amp => "amp",
62:             Provider::Kimi => "kimi",
63:         }
64:     }
65: 
66:     pub fn from_str_loose(s: &str) -> Option<Provider> {
67:         match s.to_lowercase().as_str() {
68:             "anthropic" | "claude" => Some(Provider::Anthropic),
69:             "openai" | "codex" | "chatgpt" => Some(Provider::Openai),
70:             "gemini" | "google" => Some(Provider::Gemini),
71:             "xai" | "grok" => Some(Provider::Xai),
72:             "openrouter" | "or" => Some(Provider::Openrouter),
73:             "cliproxyapi" | "cliproxy" | "cpa" => Some(Provider::Cliproxyapi),
74:             "exo" => Some(Provider::Exo),
75:             "amp" | "ampcode" => Some(Provider::Amp),
76:             "kimi" | "kimi-code" | "moonshot" => Some(Provider::Kimi),
77:             _ => None,
78:         }
79:     }
80: }
81: 
82: #[derive(Debug, Clone, Copy, PartialEq, Eq)]
83: pub enum ClientFormat {
84:     AnthropicMessages,
85:     OpenaiChat,
86:     OpenaiResponses,
87:     GeminiGenerate,
88: }
89: 
90: impl ClientFormat {
91:     pub fn as_str(self) -> &'static str {
92:         match self {
93:             ClientFormat::AnthropicMessages => "anthropic",
94:             ClientFormat::OpenaiChat => "openai-chat",
95:             ClientFormat::OpenaiResponses => "openai-responses",
96:             ClientFormat::GeminiGenerate => "gemini",
97:         }
98:     }
99: 
100:     pub fn default_provider(self) -> Provider {
101:         match self {
102:             ClientFormat::AnthropicMessages => Provider::Anthropic,
103:             ClientFormat::OpenaiChat | ClientFormat::OpenaiResponses => Provider::Openai,
104:             ClientFormat::GeminiGenerate => Provider::Gemini,
105:         }
106:     }
107: }
108: 
109: const PREFIXES: &[(&str, Provider)] = &[
110:     ("claude:", Provider::Anthropic),
111:     ("anthropic:", Provider::Anthropic),
112:     ("openai:", Provider::Openai),
113:     ("codex:", Provider::Openai),
114:     ("gemini:", Provider::Gemini),
115:     ("grok:", Provider::Xai),
116:     ("xai:", Provider::Xai),
117:     ("openrouter:", Provider::Openrouter),
118:     ("cliproxyapi:", Provider::Cliproxyapi),
119:     ("cliproxy:", Provider::Cliproxyapi),
120:     ("exo:", Provider::Exo),
121:     ("kimi:", Provider::Kimi),
122:     ("claude/", Provider::Anthropic),
123:     ("anthropic/", Provider::Anthropic),
124:     ("openai/", Provider::Openai),
125:     ("codex/", Provider::Openai),
126:     ("chatgpt/", Provider::Openai),
127:     ("gemini/", Provider::Gemini),
128:     ("google/", Provider::Gemini),
129:     ("grok/", Provider::Xai),
130:     ("xai/", Provider::Xai),
131:     ("openrouter/", Provider::Openrouter),
132:     ("cliproxyapi/", Provider::Cliproxyapi),
133:     ("cliproxy/", Provider::Cliproxyapi),
134:     ("exo/", Provider::Exo),
135:     ("kimi/", Provider::Kimi),
136: ];
137: 
138: // Claude Code gateway discovery only accepts model ids beginning with
139: // `claude` or `anthropic`. Alex publishes `claude-alex/<model>` aliases
140: // to that client and removes the compatibility prefix before normal routing.
141: const PASSTHROUGH: &[&str] = &["claude-alex/", "cove/", "alex/"];
142: 
143: const ALIASES: &[(&str, &str)] = &[
144:     ("opus-4.8", "claude-opus-4-8"),
145:     ("opus-4.5", "claude-opus-4-5"),
146:     ("sonnet-5", "claude-sonnet-5"),
147:     ("sonnet-4.5", "claude-sonnet-4-5"),
148:     ("haiku-4.5", "claude-haiku-4-5"),
149: ];
150: 
151: pub fn model_aliases() -> &'static [(&'static str, &'static str)] {
152:     ALIASES
153: }
154: 
155: fn hs<'a>(h: &'a Value, key: &str) -> Option<&'a str> {
156:     h.get(key).and_then(|v| v.as_str())
157: }
158: 
159: fn hf(h: &Value, key: &str) -> Option<f64> {
160:     hs(h, key).and_then(|s| s.parse().ok())
161: }
162: 
163: fn hi(h: &Value, key: &str) -> Option<i64> {
164:     hs(h, key).and_then(|s| s.parse().ok())
165: }
166: 
167: pub fn parse_limit_headers(provider: Provider, h: &Value) -> Value {
168:     match provider {
169:         Provider::Anthropic => {
170:             let mut windows = Vec::new();
171:             for (name, prefix) in [
172:                 ("5h", "anthropic-ratelimit-unified-5h"),
173:                 ("7d", "anthropic-ratelimit-unified-7d"),
174:             ] {
175:                 if let Some(util) = hf(h, &format!("{prefix}-utilization")) {
176:                     windows.push(serde_json::json!({
177:                         "window": name,
178:                         "used_pct": util * 100.0,
179:                         "status": hs(h, &format!("{prefix}-status")),
180:                         "resets_at_s": hi(h, &format!("{prefix}-reset")),
181:                     }));
182:                 }
183:             }
184:             serde_json::json!({
185:                 "windows": windows,
186:                 "representative_window": hs(h, "anthropic-ratelimit-unified-representative-claim"),
187:                 "overage": {
188:                     "status": hs(h, "anthropic-ratelimit-unified-overage-status"),
189:                     "reason": hs(h, "anthropic-ratelimit-unified-overage-disabled-reason"),
190:                 },
191:             })
192:         }
193:         Provider::Openai => {
194:             let mut windows = Vec::new();
195:             for prefix in ["x-codex-primary", "x-codex-secondary"] {
196:                 if let Some(used) = hf(h, &format!("{prefix}-used-percent")) {
197:                     let minutes = hi(h, &format!("{prefix}-window-minutes"));
```

---

### 🤖 Assistant — 2026-09-15 20:38:04

> Now let me look for the actual vault/account selection implementation, which would be in the proxy crate rather than alex-core.

Let me find the actual vault selection implementation:

**tool:grep** (completed) fn select_account|fn pick_account|fn choose_account|round_robin|reserve_pct|threshold_pct|cooldown

```
pattern=fn select_account|fn pick_account|fn choose_account|round_robin|reserve_pct|thre; path=/home/x3/workspace/alex/crates; include=*.rs
--- output ---
Found 100 matches (more matches available)
/home/x3/workspace/alex/crates/alex-auth/src/login.rs:
  Line 484:         account.cooldown_until_ms = None;

  Line 601:         cooldown_until_ms: None,

  Line 998:         cooldown_until_ms: None,

  Line 1195:         account.cooldown_until_ms = None;

  Line 1289:         cooldown_until_ms: None,

  Line 1501:         cooldown_until_ms: None,

  Line 1807:             cooldown_until_ms: None,

  Line 1829:             cooldown_until_ms: None,


/home/x3/workspace/alex/crates/alex-auth/src/lib.rs:
  Line 96:     pub cooldown_until_ms: Option<i64>,

  Line 360: pub fn routing_reserve_pct(account: &Account, policy: &AccountPolicy) -> u8 {

  Line 362:         .account_reserve_pct

  Line 364:         .or_else(|| policy.account_reserve_pct.get(&account.id))

  Line 366:         .or(policy.reserve_pct)

  Line 371: pub fn routing_reserve_blocked(account: &Account, reserve_pct: u8, now_s: i64) -> bool {

  Line 372:     if reserve_pct == 0 {

  Line 384:                 .map(|used| used >= 100.0 - reserve_pct as f64)

  Line 448:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),

  Line 456:             let threshold = policy.threshold_pct.unwrap_or(80);

  Line 472:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),

  Line 483:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),

  Line 495:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),

  Line 548:     pub threshold_pct: Option<u8>,

  Line 550:     pub reserve_pct: Option<u8>,

  Line 552:     pub account_reserve_pct: HashMap<String, u8>,

  Line 568:             threshold_pct: None,

  Line 569:             reserve_pct: None,

  Line 570:             account_reserve_pct: HashMap::new(),

  Line 581:             reserve_pct: Some(10),

  Line 962:             survivor.cooldown_until_ms = None;

  Line 1018:     /// A preferred account never bypasses pause/eligibility/cooldown or the

  Line 1044:         preferred_ignores_cooldown: bool,

  Line 1072:             .filter(|a| a.cooldown_until_ms.map(|c| c <= now).unwrap_or(true))

  Line 1079:                     preferred_ignores_cooldown

  Line 1080:                         || account.cooldown_until_ms.map(|c| c <= now).unwrap_or(true)

  Line 1089:                 .min_by_key(|a| a.cooldown_until_ms.unwrap_or(i64::MAX))

  Line 1108:                             routing_reserve_pct(account, &policy),

  Line 1136:     pub async fn mark_cooldown(&self, id: &str, until_ms: i64) -> Result<()> {

  Line 1138:             .update(id, |account| account.cooldown_until_ms = Some(until_ms))

  Line 1149:     pub async fn clear_cooldown(&self, id: &str) -> Result<()> {

  Line 1151:             .update(id, |account| account.cooldown_until_ms = None)

  Line 1864:         cooldown_until_ms: None,

  Line 1925:             cooldown_until_ms: None,

  Line 1950:             cooldown_until_ms: None,

  Line 1999:         cooldown_until_ms: None,

  Line 2071:         cooldown_until_ms: None,

  Line 2193:         cooldown_until_ms: None,

  Line 2235:         cooldown_until_ms: None,

  Line 2316:         cooldown_until_ms: None,

  Line 2391:         cooldown_until_ms: None,

  Line 2448:         cooldown_until_ms: None,

  Line 2533:             cooldown_until_ms: None,

  Line 2753:             cooldown_until_ms: None,

  Line 2775:             cooldown_until_ms: None,

  Line 3059:             reserve_pct: Some(17),

  Line 3060:             account_reserve_pct: HashMap::from([("work".into(), 23), (account.id.clone(), 31)]),

  Line 3063:         assert_eq!(routing_reserve_pct(&account, &policy), 23);

  Line 3064:         policy.account_reserve_pct.remove("work");

  Line 3065:         assert_eq!(routing_reserve_pct(&account, &policy), 31);

  Line 3066:         policy.account_reserve_pct.clear();

  Line 3067:         assert_eq!(routing_reserve_pct(&account, &policy), 17);

  Line 3068:         policy.reserve_pct = None;

  Line 3069:         assert_eq!(routing_reserve_pct(&account, &policy), 10);

  Line 3107:                         reserve_pct: Some(10),

  Line 3330:     async fn round_robin_and_cooldown() {

  Line 3362:             .mark_cooldown("openai-key-a", now_ms() + 60_000)

  Line 3371:             .mark_cooldown("openai-key-b", now_ms() + 120_000)

  Line 3400:             .mark_cooldown("openai-key-a", now + 30_000)

  Line 3404:             .mark_cooldown("openai-key-b", now + 20_000)

  Line 3408:             .mark_cooldown("openai-key-c", now + 10_000)

  Line 3438:     async fn preferred_account_never_bypasses_pause_policy_cooldown_or_exclusion() {

  Line 3490:         second.cooldown_until_ms = Some(now_ms() + 60_000);

  Line 3520:         second.cooldown_until_ms = None;

  Line 3596:     async fn policy_selection_priority_round_robin_threshold() {

  Line 3634:             .mark_cooldown("openai-api_key-work", now_ms() + 60_000)

  Line 3646:             .mark_cooldown("openai-api_key-work", now_ms() - 1)

  Line 3684:                     threshold_pct: Some(80),

  Line 3736:             "reserve_pct": 17,

  Line 3740:         assert_eq!(policy.reserve_pct, Some(17));

  Line 3741:         assert!(policy.account_reserve_pct.is_empty());

  Line 3784:                     reserve_pct: Some(10),

  Line 3785:                     account_reserve_pct: HashMap::from([("soon".into(), 0), ("later".into(), 10)]),

  Line 3815:                     reserve_pct: Some(10),

  Line 3851:                     reserve_pct: Some(10),

  Line 3882:                         reserve_pct: Some(15),

  Line 3883:                         account_reserve_pct: HashMap::from([("work".into(), 23)]),

  Line 3904:         assert_eq!(policy.reserve_pct, Some(15));

  Line 3905:         assert_eq!(policy.account_reserve_pct["work"], 23);


/home/x3/workspace/alex/crates/alex-auth/src/vault_bundle.rs:
  Line 338:             cooldown_until_ms: None,


/home/x3/workspace/alex/crates/alex-proxy/tests/fakeprov_router.rs:
  Line 44:         cooldown_until_ms: None,


/home/x3/workspace/alex/crates/alex/src/dario.rs:
  Line 867:     /// the durable cooldown/debounce policy.


/home/x3/workspace/alex/crates/alex/src/harness_connect.rs:
  Line 5889:             notification_cooldown_seconds: alex_proxy::notify::default_cooldown_seconds(),


/home/x3/workspace/alex/crates/alex-proxy/examples/cliproxyapi_v1_fixture.rs:
  Line 61:         cooldown_until_ms: None,


/home/x3/workspace/alex/crates/alex/src/reset.rs:
```

---

### 🤖 Assistant — 2026-09-15 20:38:16

> The actual vault selection logic is in `alex-auth/src/lib.rs`. Let me read the relevant section.

**tool:read** (completed) alex/crates/alex-auth/src/lib.rs

```
filePath=/home/x3/workspace/alex/crates/alex-auth/src/lib.rs; offset=350; limit=250
--- output ---
<path>/home/x3/workspace/alex/crates/alex-auth/src/lib.rs</path>
<type>file</type>
<content>
350: }
351: 
352: fn routing_window_values(account: &Account) -> impl Iterator<Item = &Value> {
353:     routing_limit_snapshot(account)
354:         .and_then(|snapshot| snapshot.get("windows"))
355:         .and_then(Value::as_array)
356:         .into_iter()
357:         .flatten()
358: }
359: 
360: pub fn routing_reserve_pct(account: &Account, policy: &AccountPolicy) -> u8 {
361:     policy
362:         .account_reserve_pct
363:         .get(&account.name)
364:         .or_else(|| policy.account_reserve_pct.get(&account.id))
365:         .copied()
366:         .or(policy.reserve_pct)
367:         .unwrap_or(10)
368:         .min(100)
369: }
370: 
371: pub fn routing_reserve_blocked(account: &Account, reserve_pct: u8, now_s: i64) -> bool {
372:     if reserve_pct == 0 {
373:         return false;
374:     }
375:     routing_window_values(account).any(|window| {
376:         let future_window = window
377:             .get("resets_at_s")
378:             .and_then(Value::as_i64)
379:             .map(|reset| reset > now_s)
380:             .unwrap_or(true);
381:         let used_pct = window.get("used_pct").and_then(Value::as_f64);
382:         future_window
383:             && used_pct
384:                 .map(|used| used >= 100.0 - reserve_pct as f64)
385:                 .unwrap_or(false)
386:     })
387: }
388: 
389: /// The binding quota window is the active window closest to exhaustion.
390: /// Ties use the earlier reset. This avoids always picking the short window
391: /// when a weekly/monthly window is the actual constraint.
392: pub fn routing_reset_selection(account: &Account, now_s: i64) -> Option<Value> {
393:     let mut selected: Option<(f64, i64, Option<String>)> = None;
394:     for window in routing_window_values(account) {
395:         let Some(used_pct) = window.get("used_pct").and_then(Value::as_f64) else {
396:             continue;
397:         };
398:         let Some(resets_at_s) = window.get("resets_at_s").and_then(Value::as_i64) else {
399:             continue;
400:         };
401:         if resets_at_s <= now_s {
402:             continue;
403:         }
404:         let label = window
405:             .get("window")
406:             .and_then(Value::as_str)
407:             .map(String::from);
408:         let replace = selected
409:             .as_ref()
410:             .map(|(current_used, current_reset, _)| {
411:                 used_pct > *current_used
412:                     || (used_pct == *current_used && resets_at_s < *current_reset)
413:             })
414:             .unwrap_or(true);
415:         if replace {
416:             selected = Some((used_pct, resets_at_s, label));
417:         }
418:     }
419:     selected.map(|(used_pct, resets_at_s, window)| {
420:         json!({"window": window, "used_pct": used_pct, "resets_at_s": resets_at_s})
421:     })
422: }
423: 
424: fn routing_binding_reset(account: &Account, now_s: i64) -> Option<i64> {
425:     routing_reset_selection(account, now_s)?["resets_at_s"].as_i64()
426: }
427: 
428: fn routing_binding_used_basis_points(account: &Account, now_s: i64) -> Option<u32> {
429:     routing_reset_selection(account, now_s)?["used_pct"]
430:         .as_f64()
431:         .map(|used| (used.clamp(0.0, 100.0) * 100.0).round() as u32)
432: }
433: 
434: fn account_proxy_eligible(account: &Account, policy: &AccountPolicy) -> bool {
435:     !policy
436:         .disabled
437:         .iter()
438:         .any(|name| name == &account.name || name == &account.id)
439: }
440: 
441: fn sort_by_policy(accounts: &mut Vec<Account>, policy: &AccountPolicy, prefer_oauth: bool) {
442:     let now_s = now_ms() / 1000;
443:     match policy.mode {
444:         AccountPolicyMode::RoundRobin => {
445:             accounts.sort_by_key(|a| {
446:                 (
447:                     oauth_rank(a, prefer_oauth),
448:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),
449:                     policy_rank(policy, &a.name),
450:                     a.name.clone(),
451:                     a.id.clone(),
452:                 )
453:             });
454:         }
455:         AccountPolicyMode::Threshold => {
456:             let threshold = policy.threshold_pct.unwrap_or(80);
457:             accounts.sort_by_key(|a| {
458:                 let over = utilization_pct(a).map(|p| p >= threshold).unwrap_or(false);
459:                 (
460:                     oauth_rank(a, prefer_oauth),
461:                     over,
462:                     policy_rank(policy, &a.name),
463:                     a.name.clone(),
464:                     a.id.clone(),
465:                 )
466:             });
467:         }
468:         AccountPolicyMode::Priority => {
469:             accounts.sort_by_key(|a| {
470:                 (
471:                     oauth_rank(a, prefer_oauth),
472:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),
473:                     policy_rank(policy, &a.name),
474:                     a.name.clone(),
475:                     a.id.clone(),
476:                 )
477:             });
478:         }
479:         AccountPolicyMode::ResetFirst => {
480:             accounts.sort_by_key(|a| {
481:                 (
482:                     oauth_rank(a, prefer_oauth),
483:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),
484:                     routing_binding_reset(a, now_s).unwrap_or(i64::MAX),
485:                     policy_rank(policy, &a.name),
486:                     a.name.clone(),
487:                     a.id.clone(),
488:                 )
489:             });
490:         }
491:         AccountPolicyMode::HighestQuota => {
492:             accounts.sort_by_key(|a| {
493:                 (
494:                     oauth_rank(a, prefer_oauth),
495:                     routing_reserve_blocked(a, routing_reserve_pct(a, policy), now_s),
496:                     // The quota APIs expose percentages rather than absolute
497:                     // plan allowances. Lowest usage in the binding (most
498:                     // consumed) active window therefore means the greatest
499:                     // reliably observable remaining quota.
500:                     routing_binding_used_basis_points(a, now_s).unwrap_or(u32::MAX),
501:                     policy_rank(policy, &a.name),
502:                     a.name.clone(),
503:                     a.id.clone(),
504:                 )
505:             });
506:         }
507:     }
508: }
509: 
510: pub fn rfc3339_to_ms(s: &str) -> Option<i64> {
511:     chrono::DateTime::parse_from_rfc3339(s)
512:         .ok()
513:         .map(|dt| dt.timestamp_millis())
514: }
515: 
516: pub fn jwt_exp_ms(token: &str) -> Option<i64> {
517:     let payload = token.split('.').nth(1)?;
518:     let bytes = base64::engine::general_purpose::URL_SAFE_NO_PAD
519:         .decode(payload)
520:         .ok()?;
521:     let v: Value = serde_json::from_slice(&bytes).ok()?;
522:     v.get("exp")?.as_i64().map(|s| s * 1000)
523: }
524: 
525: #[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
526: #[serde(rename_all = "snake_case")]
527: pub enum AccountPolicyMode {
528:     Priority,
529:     RoundRobin,
530:     Threshold,
531:     ResetFirst,
532:     HighestQuota,
533: }
534: 
535: impl Default for AccountPolicyMode {
536:     fn default() -> Self {
537:         Self::Priority
538:     }
539: }
540: 
541: #[derive(Debug, Clone, Serialize, Deserialize)]
542: pub struct AccountPolicy {
543:     #[serde(default)]
544:     pub order: Vec<String>,
545:     #[serde(default)]
546:     pub mode: AccountPolicyMode,
```

---

### 🤖 Assistant — 2026-09-15 20:38:23

> Let me read the vault selection method to understand how accounts are actually selected during failover.

**tool:read** (completed) alex/crates/alex-auth/src/lib.rs

```
filePath=/home/x3/workspace/alex/crates/alex-auth/src/lib.rs; offset=1000; limit=200
--- output ---
<path>/home/x3/workspace/alex/crates/alex-auth/src/lib.rs</path>
<type>file</type>
<content>
1000:         let excluded = HashSet::new();
1001:         self.account_for_excluding(provider, prefer_oauth, &excluded)
1002:             .await
1003:     }
1004: 
1005:     pub async fn account_for_excluding(
1006:         &self,
1007:         provider: Provider,
1008:         prefer_oauth: bool,
1009:         excluded: &HashSet<String>,
1010:     ) -> Result<Account> {
1011:         self.account_for_excluding_preferred(provider, prefer_oauth, excluded, None)
1012:             .await
1013:     }
1014: 
1015:     /// Select an account using the provider policy, while keeping an existing
1016:     /// conversation on `preferred_id` when that account is still usable.
1017:     ///
1018:     /// A preferred account never bypasses pause/eligibility/cooldown or the
1019:     /// caller's exclusion set. This lets the proxy preserve prompt-cache
1020:     /// affinity without defeating routing controls or retry failover.
1021:     pub async fn account_for_excluding_preferred(
1022:         &self,
1023:         provider: Provider,
1024:         prefer_oauth: bool,
1025:         excluded: &HashSet<String>,
1026:         preferred_id: Option<&str>,
1027:     ) -> Result<Account> {
1028:         self.account_for_excluding_preferred_mode(
1029:             provider,
1030:             prefer_oauth,
1031:             excluded,
1032:             preferred_id,
1033:             false,
1034:         )
1035:         .await
1036:     }
1037: 
1038:     pub async fn account_for_excluding_preferred_mode(
1039:         &self,
1040:         provider: Provider,
1041:         prefer_oauth: bool,
1042:         excluded: &HashSet<String>,
1043:         preferred_id: Option<&str>,
1044:         preferred_ignores_cooldown: bool,
1045:     ) -> Result<Account> {
1046:         let now = now_ms();
1047:         let candidates: Vec<Account> = {
1048:             let map = self.accounts.read().await;
1049:             let mut v: Vec<Account> = map
1050:                 .values()
1051:                 .filter(|a| {
1052:                     a.provider == provider
1053:                         && a.status == "active"
1054:                         && !a.paused
1055:                         && !excluded.contains(&a.id)
1056:                 })
1057:                 .cloned()
1058:                 .collect();
1059:             let policy = self.policy(provider);
1060:             v.retain(|account| account_proxy_eligible(account, &policy));
1061:             sort_by_policy(&mut v, &policy, prefer_oauth);
1062:             v
1063:         };
1064:         if candidates.is_empty() {
1065:             bail!(
1066:                 "no active {} account; run `alex auth import`",
1067:                 provider.as_str()
1068:             );
1069:         }
1070:         let ready: Vec<&Account> = candidates
1071:             .iter()
1072:             .filter(|a| a.cooldown_until_ms.map(|c| c <= now).unwrap_or(true))
1073:             .collect();
1074:         let preferred = preferred_id.and_then(|preferred_id| {
1075:             candidates
1076:                 .iter()
1077:                 .find(|account| account.id == preferred_id)
1078:                 .filter(|account| {
1079:                     preferred_ignores_cooldown
1080:                         || account.cooldown_until_ms.map(|c| c <= now).unwrap_or(true)
1081:                 })
1082:                 .cloned()
1083:         });
1084:         let account = if let Some(preferred) = preferred {
1085:             preferred
1086:         } else if ready.is_empty() {
1087:             let account = candidates
1088:                 .iter()
1089:                 .min_by_key(|a| a.cooldown_until_ms.unwrap_or(i64::MAX))
1090:                 .unwrap()
1091:                 .clone();
1092:             tracing::warn!(
1093:                 "all {} accounts cooling down; using {} (soonest expiry) in degraded mode",
1094:                 provider.as_str(),
1095:                 account.id
1096:             );
1097:             account
1098:         } else {
1099:             let policy = self.policy(provider);
1100:             let policy_mode = policy.mode.clone();
1101:             if policy_mode == AccountPolicyMode::RoundRobin {
1102:                 let unblocked: Vec<&Account> = ready
1103:                     .iter()
1104:                     .copied()
1105:                     .filter(|account| {
1106:                         !routing_reserve_blocked(
1107:                             account,
1108:                             routing_reserve_pct(account, &policy),
1109:                             now / 1000,
1110:                         )
1111:                     })
1112:                     .collect();
1113:                 let pool: Vec<&Account> = if unblocked.is_empty() {
1114:                     ready.clone()
1115:                 } else {
1116:                     unblocked
1117:                 };
1118:                 let top_rank = oauth_rank(pool[0], prefer_oauth);
1119:                 let group: Vec<&Account> = pool
1120:                     .iter()
1121:                     .copied()
1122:                     .filter(|account| oauth_rank(account, prefer_oauth) == top_rank)
1123:                     .collect();
1124:                 let idx = self.rr_counter.fetch_add(1, Ordering::Relaxed) % group.len();
1125:                 group[idx].clone()
1126:             } else {
1127:                 ready[0].clone()
1128:             }
1129:         };
1130:         if account.needs_refresh() {
1131:             return self.refresh(&account.id, false).await;
1132:         }
1133:         Ok(account)
1134:     }
1135: 
1136:     pub async fn mark_cooldown(&self, id: &str, until_ms: i64) -> Result<()> {
1137:         if !self
1138:             .update(id, |account| account.cooldown_until_ms = Some(until_ms))
1139:             .await?
1140:         {
1141:             bail!("unknown account {id}");
1142:         }
1143:         Ok(())
1144:     }
1145: 
1146:     /// A successful health probe makes the account immediately eligible again.
1147:     /// This prevents a transient capacity/server failure from becoming a
1148:     /// sticky downgrade after the upstream has recovered.
1149:     pub async fn clear_cooldown(&self, id: &str) -> Result<()> {
1150:         if !self
1151:             .update(id, |account| account.cooldown_until_ms = None)
1152:             .await?
1153:         {
1154:             bail!("unknown account {id}");
1155:         }
1156:         Ok(())
1157:     }
1158: 
1159:     pub async fn refresh(&self, id: &str, force: bool) -> Result<Account> {
1160:         self.refresh_inner(id, force, true, None).await
1161:     }
1162: 
1163:     pub async fn refresh_without_native_reimport(
1164:         &self,
1165:         id: &str,
1166:         force: bool,
1167:         expected_workspace_id: &str,
1168:     ) -> Result<Account> {
1169:         self.refresh_inner(id, force, false, Some(expected_workspace_id))
1170:             .await
1171:     }
1172: 
1173:     async fn refresh_inner(
1174:         &self,
1175:         id: &str,
1176:         force: bool,
1177:         allow_native_reimport: bool,
1178:         expected_workspace_id: Option<&str>,
1179:     ) -> Result<Account> {
1180:         let lock = self.account_lock(id).await;
1181:         let guard = lock.lock().await;
1182: 
1183:         let account = self
1184:             .accounts
1185:             .read()
1186:             .await
1187:             .get(id)
1188:             .cloned()
1189:             .ok_or_else(|| anyhow!("unknown account {id}"))?;
1190:         if let Some(expected_workspace_id) = expected_workspace_id {
1191:             if account.chatgpt_account_id().as_deref() != Some(expected_workspace_id) {
1192:                 bail!("Codex workspace identity changed while refreshing account {id}");
1193:             }
1194:         }
1195:         if !force && !account.needs_refresh() {
1196:             return Ok(account);
```

---

### 🤖 Assistant — 2026-09-15 20:38:37

> Now I have a good understanding of Alex's account selection and routing patterns. Let me also check for health check logic.

**tool:grep** (completed) fn health_check|fn probe|heartbeat|fn ping

```
path=/home/x3/workspace/alex/crates; include=*.rs; pattern=fn health_check|fn probe|heartbeat|fn ping
--- output ---
Found 100 matches (more matches available)
/home/x3/workspace/alex/crates/alex/src/dario.rs:
  Line 1568:     async fn probe_tick(&self) {

  Line 1667: async fn probe_messages(

  Line 1680: async fn probe_messages_outcome(

  Line 1826: fn probe_escalation(consecutive_failures: u32, threshold: u32) -> ProbeEscalation {

  Line 2978:     async fn probe_ready_on_2xx() {

  Line 2986:     async fn probe_auth_on_401() {

  Line 2998:     async fn probe_wedged_on_hung_connection() {

  Line 3019:     async fn probe_wedged_on_connection_refused() {


/home/x3/workspace/alex/crates/alex/src/reset.rs:
  Line 107:             "heartbeats": counts.heartbeats,

  Line 117:             "traces": selection.traces.then_some("delete traces and heartbeats; remove data_dir/bodies recursively"),

  Line 363:             .insert_heartbeat(1, "openai", None, true, Some(200), 1, "ok")

  Line 425:     async fn traces_remove_rows_heartbeats_and_body_files_only() {

  Line 442:             (counts.traces, counts.heartbeats, counts.body_files),

  Line 644:             (counts.traces, counts.heartbeats, counts.run_keys),


/home/x3/workspace/alex/crates/alex/src/tui.rs:
  Line 82:         Some("ping") | Some("health") | Some("preflight") | Some("heartbeat") => {

  Line 1342:             "heartbeat",

  Line 1356:         let hb = match a.get("last_heartbeat").filter(|h| h.is_object()) {


/home/x3/workspace/alex/crates/alex/src/commands.rs:
  Line 437:                     last_heartbeat: serde_json::Value::Null,


/home/x3/workspace/alex/crates/alex-store/src/lib.rs:
  Line 180: CREATE TABLE IF NOT EXISTS heartbeats (

  Line 189: CREATE INDEX IF NOT EXISTS heartbeats_ts ON heartbeats(ts_ms);

  Line 386:     pub heartbeats: Vec<Value>,

  Line 396:     pub heartbeats_imported: u64,

  Line 397:     pub heartbeats_skipped: u64,

  Line 869:     pub heartbeats: u64,

  Line 955:     pub heartbeats: u64,

  Line 1065:             heartbeats: count("heartbeats")?,

  Line 1117:     /// Deletes trace rows and heartbeats and removes every captured body file.

  Line 1135:              DELETE FROM heartbeats;",

  Line 1159:             heartbeats: export_table_rows(

  Line 1161:                 "heartbeats",

  Line 1188:     /// Trace and tool-call uniqueness is enforced by SQLite; heartbeats use

  Line 1256:         let heartbeat_match = format!(

  Line 1257:             "SELECT 1 FROM heartbeats WHERE {} LIMIT 1",

  Line 1265:         let heartbeat_insert = format!(

  Line 1266:             "INSERT INTO heartbeats ({}) VALUES ({})",

  Line 1273:         for row in &rows.heartbeats {

  Line 1274:             let values = checked_sql_values(row, "heartbeats", BACKUP_HEARTBEAT_COLS)?;

  Line 1277:                     &heartbeat_match,

  Line 1284:                 counts.heartbeats_skipped += 1;

  Line 1287:                     .execute(&heartbeat_insert, rusqlite::params_from_iter(values.iter()))?;

  Line 1288:                 counts.heartbeats_imported += 1;

  Line 1564:     /// Reassign every trace/heartbeat/catalogue reference from `from_id` to

  Line 1590:         let heartbeats = tx.execute(

  Line 1591:             "UPDATE heartbeats SET account_id=?2 WHERE account_id=?1",

  Line 1603:             heartbeats,

  Line 2639:     pub fn insert_heartbeat(

  Line 2651:             "INSERT INTO heartbeats (ts_ms, provider, account_id, ok, status, latency_ms, message)

  Line 2658:     pub fn last_heartbeats(&self) -> Result<Vec<Value>> {

  Line 2662:              FROM heartbeats h

  Line 2663:              JOIN (SELECT provider, MAX(ts_ms) AS ts FROM heartbeats GROUP BY provider) latest

  Line 3950:             .insert_heartbeat(900, "anthropic", Some("account"), true, Some(200), 12, "ok")

  Line 3956:         assert_eq!(backup.heartbeats.len(), 1);

  Line 3970:         assert_eq!(imported.heartbeats_imported, 1);

  Line 3972:         assert_eq!(store.reset_counts().unwrap().heartbeats, 1);

  Line 3983:         assert_eq!(repeated.heartbeats_skipped, 1);

  Line 4911:             .insert_heartbeat(

  Line 4922:             .insert_heartbeat(

  Line 4948:         assert_eq!(counts.heartbeats, 1);

  Line 4970:         let dup_heartbeats: i64 = conn

  Line 4972:                 "SELECT COUNT(*) FROM heartbeats WHERE account_id='anthropic-oauth-2'",

  Line 4977:         assert_eq!(dup_heartbeats, 0);


/home/x3/workspace/alex/crates/alex/src/harness_connect.rs:
  Line 5171: pub(crate) fn probe_safe_dir(dir: &Path) -> bool {

  Line 5695:     fn probe_skips_network_volumes_and_protected_folders() {

  Line 5855:             heartbeat_minutes: crate::default_heartbeat_minutes(),


/home/x3/workspace/alex/crates/alex/src/status.rs:
  Line 34:     pub last_heartbeat: Value,

  Line 98:             let last_heartbeat = heartbeat_for(admin_health.as_ref(), &account.id);

  Line 110:                 health: heartbeat_health(&last_heartbeat),

  Line 114:                 last_heartbeat,

  Line 185: fn heartbeat_for(admin_health: Option<&Value>, account_id: &str) -> Value {

  Line 193:         .map(|account| account["last_heartbeat"].clone())

  Line 197: fn heartbeat_health(heartbeat: &Value) -> String {

  Line 198:     match heartbeat["ok"].as_bool() {

  Line 244:     pub(crate) fn ping_text(&self) -> String {

  Line 296:     let ping_failed = account.last_heartbeat["ok"].as_bool() == Some(false);

  Line 305:             let message = account.last_heartbeat["message"]

  Line 618:                 last_heartbeat: serde_json::json!({"ok": true}),

  Line 735:         summary.accounts[0].last_heartbeat = serde_json::json!({


/home/x3/workspace/alex/crates/alex/src/main.rs:
  Line 317:         /// Remove trace rows, heartbeats, and captured request/response bodies

  Line 1165:     #[serde(default = "default_heartbeat_minutes")]

  Line 1166:     heartbeat_minutes: u64,

  Line 1580: fn default_heartbeat_minutes() -> u64 {

  Line 1759:             heartbeat_minutes: default_heartbeat_minutes(),

  Line 1790:     fn ping_models(&self) -> alex_proxy::PingModels {

  Line 2562:     fn probe(&self, model: &str) -> alex_proxy::DarioProbeFuture {

  Line 4073:             if config.heartbeat_minutes > 0 {

  Line 4076:                 let minutes = config.heartbeat_minutes;

  Line 4083:                         alex_proxy::heartbeat_once(&hb_state, &models).await;

  Line 4087:                     "heartbeat: every {}m (set heartbeat_minutes = 0 to disable)",

  Line 4088:                     config.heartbeat_minutes

  Line 4091:                 eprintln!("heartbeat: disabled (set heartbeat_minutes in config.toml to enable)");

  Line 4240:                 // Any in-flight provider heartbeat that aborts from here on is

  Line 8576:         let heartbeats_jsonl = staging.join("heartbeats.jsonl");

```

---

### 🤖 Assistant — 2026-09-15 20:38:43

> Now let me look at the heartbeat implementation to understand the health check pattern.

**tool:grep** (completed) fn heartbeat_once|heartbeat

```
include=*.rs; path=/home/x3/workspace/alex/crates/alex-proxy/src; pattern=fn heartbeat_once|heartbeat
--- output ---
Found 49 matches
/home/x3/workspace/alex/crates/alex-proxy/src/lib.rs:
  Line 733:     /// Daemon-configured low-cost models used by both scheduled heartbeats and

  Line 3592:     // 2. Re-key every trace/heartbeat/catalogue reference in one transaction.

  Line 5272: /// Kimi usage for the Providers snapshot. The 15-minute heartbeat records the

  Line 5276: /// for the next heartbeat. A failure backoff keeps a broken usage endpoint from

  Line 7897:     let heartbeats = state.store.last_heartbeats().unwrap_or_default();

  Line 7904:             let last_heartbeat = heartbeat_for_account(&heartbeats, &a);

  Line 7936:                 // Reachability derived from the last heartbeat/ping, distinct

  Line 7939:                 "health": account_health(&a, last_heartbeat),

  Line 9289:     let heartbeats = state.store.last_heartbeats().unwrap_or_default();

  Line 9296:             let last = heartbeat_for_account(&heartbeats, &a).cloned();

  Line 9306:                 "last_heartbeat": last,

  Line 9361:             account.status == "active" && !account.paused && heartbeat_provider(account.provider)

  Line 9370:         record_heartbeat_result(&state, &result).await;

  Line 9768: fn heartbeat_provider(provider: Provider) -> bool {

  Line 9782: pub async fn heartbeat_once(state: &Arc<AppState>, models: &PingModels) -> Vec<PingResult> {

  Line 9786:             if a.status == "active" && heartbeat_provider(a.provider) && !seen.contains(&a.provider)

  Line 9799:         record_heartbeat_result(state, &r).await;

  Line 9805: /// Persist one completed heartbeat unless daemon shutdown has begun. In-flight

  Line 9808: async fn record_heartbeat_result(state: &Arc<AppState>, r: &PingResult) {

  Line 9814:             "discarding heartbeat result during daemon shutdown"

  Line 9831:             "discarding heartbeat result after daemon shutdown began"

  Line 9835:     if let Err(e) = state.store.insert_heartbeat(

  Line 9844:         tracing::warn!("failed to record heartbeat: {e}");

  Line 9852:         "heartbeat"

  Line 10011: fn heartbeat_for_account<'a>(heartbeats: &'a [Value], account: &Account) -> Option<&'a Value> {

  Line 10012:     heartbeats

  Line 10014:         .find(|heartbeat| heartbeat["account_id"].as_str() == Some(account.id.as_str()))

  Line 10016:             heartbeats.iter().find(|heartbeat| {

  Line 10017:                 heartbeat["account_id"].is_null()

  Line 10018:                     && heartbeat["provider"].as_str() == Some(account.provider.as_str())

  Line 10023: fn account_health(account: &Account, last_heartbeat: Option<&Value>) -> String {

  Line 10035:     match last_heartbeat.and_then(|heartbeat| heartbeat["ok"].as_bool()) {

  Line 17343: /// of the heartbeat/ping loop, so it fires even when heartbeats are disabled)

  Line 18175:         // Stand in for a heartbeat that has already recorded /usages windows.

  Line 27297:     async fn heartbeat_result_is_not_recorded_after_shutdown_begins() {

  Line 27298:         let state = test_state("heartbeat-shutdown-discard");

  Line 27306:         record_heartbeat_result(

  Line 27319:         assert!(state.store.last_heartbeats().unwrap().is_empty());

  Line 27339:         let heartbeats = state.store.last_heartbeats().unwrap_or_default();

  Line 27340:         account_health(&account, heartbeat_for_account(&heartbeats, &account))

  Line 27616:     async fn heartbeat_only_account_reports_healthy_or_unreachable() {

  Line 27619:                 "heartbeat-only-healthy"

  Line 27621:                 "heartbeat-only-unreachable"

  Line 27630:                 .insert_heartbeat(

  Line 27637:                     "heartbeat evidence",

  Line 27650:     async fn probe_evidence_wins_over_newer_heartbeat() {

  Line 27651:         let state = test_state("probe-wins-over-heartbeat");

  Line 27660:             .insert_heartbeat(

  Line 27667:                 "later heartbeat failed",
```

---

### 🤖 Assistant — 2026-09-15 20:38:55

> Now let me check the heartbeat_once function to understand how health checks work.

**tool:read** (completed) alex/crates/alex-proxy/src/lib.rs

```
filePath=/home/x3/workspace/alex/crates/alex-proxy/src/lib.rs; offset=9760; limit=120
--- output ---
<path>/home/x3/workspace/alex/crates/alex-proxy/src/lib.rs</path>
<type>file</type>
<content>
9760:     None
9761: }
9762: 
9763: fn snippet(text: &str) -> String {
9764:     let t: String = text.chars().take(200).collect();
9765:     t.replace('\n', " ")
9766: }
9767: 
9768: fn heartbeat_provider(provider: Provider) -> bool {
9769:     matches!(
9770:         provider,
9771:         Provider::Anthropic
9772:             | Provider::Openai
9773:             | Provider::Xai
9774:             | Provider::Gemini
9775:             | Provider::Openrouter
9776:             | Provider::Cliproxyapi
9777:             | Provider::Amp
9778:             | Provider::Kimi
9779:     )
9780: }
9781: 
9782: pub async fn heartbeat_once(state: &Arc<AppState>, models: &PingModels) -> Vec<PingResult> {
9783:     let providers: Vec<Provider> = {
9784:         let mut seen = Vec::new();
9785:         for a in state.vault.list().await {
9786:             if a.status == "active" && heartbeat_provider(a.provider) && !seen.contains(&a.provider)
9787:             {
9788:                 seen.push(a.provider);
9789:             }
9790:         }
9791:         seen
9792:     };
9793:     let mut results = Vec::new();
9794:     for provider in providers {
9795:         if state.is_shutting_down() {
9796:             break;
9797:         }
9798:         let r = ping_provider(state, provider, models).await;
9799:         record_heartbeat_result(state, &r).await;
9800:         results.push(r);
9801:     }
9802:     results
9803: }
9804: 
9805: /// Persist one completed heartbeat unless daemon shutdown has begun. In-flight
9806: /// requests commonly lose their transport while axum drains; those failures
9807: /// describe daemon lifecycle, not provider reachability.
9808: async fn record_heartbeat_result(state: &Arc<AppState>, r: &PingResult) {
9809:     if state.is_shutting_down() {
9810:         tracing::debug!(
9811:             provider = r.provider,
9812:             status = r.status,
9813:             detail = %r.message,
9814:             "discarding heartbeat result during daemon shutdown"
9815:         );
9816:         return;
9817:     }
9818: 
9819:     if r.ok {
9820:         if let Some(account_id) = r.account_id.as_deref() {
9821:             if let Err(error) = state.vault.clear_cooldown(account_id).await {
9822:                 tracing::warn!(%error, %account_id, "could not clear recovered account cooldown");
9823:             }
9824:         }
9825:     }
9826:     // Re-check after the async vault operation: shutdown may have started
9827:     // while it yielded, in which case this probe must not enter health history.
9828:     if state.is_shutting_down() {
9829:         tracing::debug!(
9830:             provider = r.provider,
9831:             "discarding heartbeat result after daemon shutdown began"
9832:         );
9833:         return;
9834:     }
9835:     if let Err(e) = state.store.insert_heartbeat(
9836:         now_ms(),
9837:         r.provider,
9838:         r.account_id.as_deref(),
9839:         r.ok,
9840:         r.status.map(|s| s as i64),
9841:         r.latency_ms,
9842:         &r.message,
9843:     ) {
9844:         tracing::warn!("failed to record heartbeat: {e}");
9845:     }
9846:     tracing::info!(
9847:         provider = r.provider,
9848:         ok = r.ok,
9849:         status = r.status,
9850:         latency_ms = r.latency_ms,
9851:         reply = %r.message,
9852:         "heartbeat"
9853:     );
9854:     // Reachability, not credential-presence, is what the status dot must
9855:     // reflect: persist the probe outcome and — for an auth-class failure —
9856:     // reuse the proactive re-auth dispatcher (same cooldown as the request
9857:     // path and the idle-expiry watchdog).
9858:     record_probe_outcome(state, r).await;
9859: }
9860: 
9861: /// Health an account's last probe implies. This is reachability, distinct from
9862: /// the credential-presence `status` field: a live credential that fails its
9863: /// ping is not "healthy". `Unknown` is never recorded — it is the read-side
9864: /// default for an account that has never been probed.
9865: #[derive(Debug, Clone, Copy, PartialEq, Eq)]
9866: enum ProbeHealth {
9867:     Healthy,
9868:     Unreachable,
9869:     AuthFailed,
9870: }
9871: 
9872: impl ProbeHealth {
9873:     fn as_str(self) -> &'static str {
9874:         match self {
9875:             Self::Healthy => "healthy",
9876:             Self::Unreachable => "unreachable",
9877:             Self::AuthFailed => "auth_failed",
9878:         }
9879:     }

(Showing lines 9760-9879 of 27694. Use offset=9880 to continue.)
</content>
```

---

### 🤖 Assistant — 2026-09-15 20:39:01

> Now I have enough information to provide a comprehensive summary. Let me compile the key patterns from Alex's account selection and routing.

Here's the summary of Alex's most transferable patterns:

## Account Selection Patterns

**5 selection modes**, each a sort-key strategy:
- **Priority** — ordered by `order` list, reserve-blocked accounts sink to bottom
- **Round-robin** — rotate among top-ranked ready accounts using atomic counter
- **Threshold** — sort accounts below `threshold_pct` (default 80%) before those above, then apply order
- **ResetFirst** — prefer the account whose binding quota window resets soonest (default for OpenAI)
- **HighestQuota** — prefer the account with lowest `used_pct` in its most-consumed window

All modes share the same pre-filter: exclude paused, inactive, disabled-by-policy, and excluded-by-caller accounts.

## Reserve Capacity Gate

Reserve blocks accounts proactively. An account is blocked when `used_pct >= 100 - reserve_pct` on any future expiry window. The resolution order:
1. `account_reserve_pct[name]` (by account name)
2. `account_reserve_pct[id]` (by account ID)
3. `reserve_pct` (provider-level, default 10%)
4. Fallback: 10

Reserve of 0 disables the gate entirely. Reserve-blocked accounts sink in sort but are still selectable as last resort.

## Failover

Only `capacity` and `server` error classes trigger account failover. Auth, bad-request, network errors do not. Failover reuses the sorted candidate list minus the failed account. A degraded "soonest cooldown" escape hatch activates when all accounts are cooling down — uses whichever account expires cooldown earliest.

**Mid-thread affinity**: Codex Responses conversations bind to a session key for prompt-cache continuity. `allow_mid_thread_failover` controls whether a failed preferred account can be replaced mid-conversation. On success, the new account rebinds the session.

## Health Checks

Periodic heartbeat pings each provider with a configured ping model (`ping_openai_model`, etc.). On success, clears the account's cooldown immediately (prevents sticky downgrades after recovery). Heartbeat results are persisted to SQLite for status display. Three health states: `healthy`, `unreachable`, `auth_failed`.

## Cooldown

Failed accounts get a timestamp-based cooldown (`cooldown_until_ms`). During cooldown, an account is excluded from the ready pool but remains a candidate if all accounts are cooling. Selection picks the soonest-expiry account in that degraded case. Health probes clear cooldown on success.

## Key Config Shapes

```toml
[account_policy.openai]
mode = "reset_first"
order = ["work", "personal"]
reserve_pct = 10
threshold_pct = 80
allow_mid_thread_failover = true
disabled = []

[account_policy.openai.account_reserve_pct]
work = 15
```

The vault reloads policies from both `config.toml` and a `.routing-policies` sidecar file (CLI `alex routing set` writes the sidecar; config.toml overrides on conflict).

---
