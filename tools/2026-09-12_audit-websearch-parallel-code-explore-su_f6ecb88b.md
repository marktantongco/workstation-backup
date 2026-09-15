# Audit websearch+parallel code (@explore subagent)

- **Session ID:** `ses_f6ecb88b8ffeP1g1MDH5LQCVBt`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-12 00:02:09
- **Last activity:** 2026-09-12 08:45:40
- **Messages:** 10

---

### 🧑 User — 2026-09-12 00:02:10

Thorough audit of the freebuff-unified codebase at /home/x3/freebuff-unified focusing on search/extract performance characteristics. I need concrete data, not vague observations.

For each package below, report:
- File paths and line counts
- Structs/interfaces (names, fields, methods)
- Concurrency patterns (goroutines, channels, mutexes, worker pools)
- Memory allocation patterns (string concat, byte slices, buffer reuse, sync.Pool)
- HTTP client configuration (timeouts, transport, connection pooling, TLS)
- Error handling paths (retry logic, fallback chains)
- Any caching (in-memory, file, redis, etc.)
- Any rate limiting (client-side)
- Any batching or fan-out/fan-in patterns

Packages to audit:
1. internal/websearch/ — DDG stealth search, all files
2. internal/parallel/ — Parallel API client, all files
3. internal/httpapi/research.go — The deep-research orchestrator (lines 700-1178), especially: planQueries, searchAll, extractAll, synthesize, and the stream dispatch
4. internal/proxy/ — passthrough handler, proxy pool

Also check:
- go.mod for memory-heavy dependencies (fasthttp, pgx, etc.)
- Any sync.Pool usage across the codebase
- Any goroutine leak patterns (context cancellation without cleanup)
- Any string concatenation in hot paths (use strings.Builder instead)

Return exact file:line references for every finding.

---

### 🤖 Assistant — 2026-09-12 00:02:10

> Let me start by exploring the codebase structure to understand what we're working with.

**tool:todowrite** (completed) 6 todos

```
todos=[{'content': 'Map codebase structure and file inventory', 'status': 'in_progress
--- output ---
[
  {
    "content": "Map codebase structure and file inventory",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Audit internal/websearch/ — DDG stealth search",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Audit internal/parallel/ — Parallel API client",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Audit internal/httpapi/research.go — deep-research orchestrator",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Audit internal/proxy/ — passthrough handler, proxy pool",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Cross-cutting: go.mod deps, sync.Pool, goroutine leaks, string concat hot paths",
    "status": "pending",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-12 00:02:43

> Let me explore the codebase structure first.

**tool:read** (completed) ../freebuff-unified

```
filePath=/home/x3/freebuff-unified
--- output ---
<path>/home/x3/freebuff-unified</path>
<type>directory</type>
<entries>
.git/
.gitignore
auths/
bin/
cmd/
config.example.yaml
config.yaml
deploy/
deps/
go.mod
go.sum
internal/
planning/
proxies.txt
README.md
scripts/
SESSION_SUMMARY.md

(17 entries)
</entries>
```

**tool:glob** (completed) ../freebuff-unified

```
pattern=**/*.go; path=/home/x3/freebuff-unified
--- output ---
/home/x3/freebuff-unified/internal/dashboard/dashboard.go
/home/x3/freebuff-unified/internal/oauth/flow.go
/home/x3/freebuff-unified/cmd/freebuff/main.go
/home/x3/freebuff-unified/internal/proxy/passthrough.go
/home/x3/freebuff-unified/internal/proxy/passthrough_test.go
/home/x3/freebuff-unified/internal/config/config.go
/home/x3/freebuff-unified/internal/hermes/client.go
/home/x3/freebuff-unified/internal/hermes/client_test.go
/home/x3/freebuff-unified/internal/config/watcher.go
/home/x3/freebuff-unified/internal/websearch/ddg.go
/home/x3/freebuff-unified/internal/session/manager.go
/home/x3/freebuff-unified/internal/websearch/ddg_test.go
/home/x3/freebuff-unified/internal/session/pool.go
/home/x3/freebuff-unified/internal/parallel/client.go
/home/x3/freebuff-unified/internal/anthropic/types.go
/home/x3/freebuff-unified/internal/anthropic/mapper.go
/home/x3/freebuff-unified/internal/credentials/lock.go
/home/x3/freebuff-unified/internal/credentials/store.go
/home/x3/freebuff-unified/internal/openai/types.go
/home/x3/freebuff-unified/internal/httpapi/ratelimit.go
/home/x3/freebuff-unified/internal/cache/run_cache.go
/home/x3/freebuff-unified/internal/httpapi/parallel_handlers_test.go
/home/x3/freebuff-unified/internal/httpapi/passthrough_wiring_test.go
/home/x3/freebuff-unified/internal/httpapi/hermes_handlers_test.go
/home/x3/freebuff-unified/internal/httpapi/handlers_test.go
/home/x3/freebuff-unified/internal/httpapi/serve_stale_test.go
/home/x3/freebuff-unified/internal/httpapi/ratelimit_test.go
/home/x3/freebuff-unified/internal/httpapi/backend_chat.go
/home/x3/freebuff-unified/internal/httpapi/handlers.go
/home/x3/freebuff-unified/internal/httpapi/research.go
/home/x3/freebuff-unified/internal/httpapi/server.go
/home/x3/freebuff-unified/internal/httpapi/research_test.go
/home/x3/freebuff-unified/internal/httpapi/chat_service.go
/home/x3/freebuff-unified/internal/httpapi/middleware.go
/home/x3/freebuff-unified/internal/httpapi/serve_stale.go
/home/x3/freebuff-unified/internal/httpapi/backend_chat_test.go
/home/x3/freebuff-unified/internal/stealth/usproxy.go
/home/x3/freebuff-unified/internal/stealth/proxy.go
/home/x3/freebuff-unified/internal/stealth/metrics.go
/home/x3/freebuff-unified/internal/stealth/hermes_roundtrip.go
/home/x3/freebuff-unified/internal/stealth/refresher.go
/home/x3/freebuff-unified/internal/stealth/randomizer.go
/home/x3/freebuff-unified/internal/stealth/profiles.go
/home/x3/freebuff-unified/internal/freebuff/client.go
/home/x3/freebuff-unified/internal/stealth/headers.go
/home/x3/freebuff-unified/internal/stealth/client.go
/home/x3/freebuff-unified/internal/stealth/sanitizer.go
/home/x3/freebuff-unified/internal/stealth/refresher_test.go
/home/x3/freebuff-unified/internal/stealth/hermes_roundtrip_test.go
/home/x3/freebuff-unified/internal/stealth/tls.go
```

**tool:read** (completed) ../freebuff-unified/go.mod

```
filePath=/home/x3/freebuff-unified/go.mod
--- output ---
<path>/home/x3/freebuff-unified/go.mod</path>
<type>file</type>
<content>
1: module freebuff-unified
2: 
3: go 1.26
4: 
5: require (
6: 	github.com/fsnotify/fsnotify v1.9.0
7: 	github.com/gofiber/fiber/v3 v3.3.0
8: 	github.com/joho/godotenv v1.5.1
9: 	github.com/refraction-networking/utls v1.6.7
10: 	golang.org/x/net v0.54.0
11: 	golang.org/x/sys v0.44.0
12: 	gopkg.in/yaml.v3 v3.0.1
13: )
14: 
15: require (
16: 	github.com/andybalholm/brotli v1.2.1 // indirect
17: 	github.com/cloudflare/circl v1.3.7 // indirect
18: 	github.com/gofiber/schema v1.7.1 // indirect
19: 	github.com/gofiber/utils/v2 v2.0.6 // indirect
20: 	github.com/google/uuid v1.6.0 // indirect
21: 	github.com/klauspost/compress v1.18.6 // indirect
22: 	github.com/mattn/go-colorable v0.1.14 // indirect
23: 	github.com/mattn/go-isatty v0.0.22 // indirect
24: 	github.com/philhofer/fwd v1.2.0 // indirect
25: 	github.com/tinylib/msgp v1.6.4 // indirect
26: 	github.com/valyala/bytebufferpool v1.0.0 // indirect
27: 	github.com/valyala/fasthttp v1.71.0 // indirect
28: 	golang.org/x/crypto v0.51.0 // indirect
29: 	golang.org/x/text v0.37.0 // indirect
30: )

(End of file - total 30 lines)
</content>
```

---

### 🤖 Assistant — 2026-09-12 00:03:45

> Now let me read all the target files in parallel.

Now reading all target files in parallel:

**tool:read** (completed) ../freebuff-unified/internal/websearch/ddg.go

```
filePath=/home/x3/freebuff-unified/internal/websearch/ddg.go
--- output ---
<path>/home/x3/freebuff-unified/internal/websearch/ddg.go</path>
<type>file</type>
<content>
1: // Package websearch provides a keyless web search backend that runs through
2: // the hermes stealth sidecar (browser-like TLS 1.3 / HTTP2 fingerprint and
3: // optional SOCKS5 egress). It scrapes DuckDuckGo's HTML endpoints — no API
4: // key, no signup — and normalizes results into the same shape as the
5: // Parallel Search API so callers can switch between them transparently.
6: package websearch
7: 
8: import (
9: 	"context"
10: 	"fmt"
11: 	"html"
12: 	"net/url"
13: 	"regexp"
14: 	"strings"
15: 	"time"
16: 
17: 	"freebuff-unified/internal/hermes"
18: )
19: 
20: // Result mirrors the Parallel Search result shape.
21: type Result struct {
22: 	Title    string   `json:"title"`
23: 	URL      string   `json:"url"`
24: 	Snippet  string   `json:"snippet"`
25: 	Excerpts []string `json:"excerpts"`
26: }
27: 
28: // Response is the normalized search reply.
29: type Response struct {
30: 	Query     string   `json:"query"`
31: 	Backend   string   `json:"backend"`
32: 	Results   []Result `json:"results"`
33: 	LatencyMS int64    `json:"latency_ms"`
34: }
35: 
36: // Searcher performs keyless web searches via the stealth sidecar.
37: type Searcher struct {
38: 	sidecar *hermes.Client
39: 	// Proxy returns the egress proxy for a search request (optional).
40: 	Proxy func() string
41: 	// Timeout per fetch (default 12s).
42: 	Timeout time.Duration
43: }
44: 
45: // New builds a keyless searcher on top of the hermes sidecar.
46: func New(sidecar *hermes.Client) *Searcher {
47: 	return &Searcher{sidecar: sidecar, Timeout: 12 * time.Second}
48: }
49: 
50: var (
51: 	// html/links.duckduckgo.com/html/?q=... result rows.
52: 	reResult = regexp.MustCompile(`(?s)<a[^>]+class="result__a"[^>]+href="([^"]+)"[^>]*>(.*?)</a>`)
53: 	// Snippet block following each result anchor.
54: 	reSnippet = regexp.MustCompile(`(?s)<a[^>]+class="result__snippet"[^>]*>(.*?)</a>`)
55: 	// Anti-blocking lite endpoint results: <a rel="nofollow" class="result-link" href="...">title</a>
56: 	reLite = regexp.MustCompile(`(?s)<a[^>]+class="result-link"[^>]+href="([^"]+)"[^>]*>(.*?)</a>`)
57: 	reTag  = regexp.MustCompile(`<[^>]+>`)
58: 	// DDG wraps URLs as /l/?uddg=<urlencoded>&...
59: 	reUddg = regexp.MustCompile(`uddg=([^&]+)`)
60: 	// <title> fallback for pages without a usable heading.
61: 	reTitle = regexp.MustCompile(`(?is)<title[^>]*>(.*?)</title>`)
62: 	// Collapse runs of whitespace left after tag stripping.
63: 	reSpaces = regexp.MustCompile(`\s+`)
64: 	// Block these page regions to keep only readable article content. Go's
65: 	// RE2 has no backreferences, so each (non-nesting) block tag gets its own
66: 	// pattern rather than one `<(script|...)>.*?</\1>`.
67: 	blockTags = []string{"script", "style", "noscript", "svg", "head", "nav", "footer", "aside", "header"}
68: 	reBlocks  = func() []*regexp.Regexp {
69: 		out := make([]*regexp.Regexp, 0, len(blockTags))
70: 		for _, t := range blockTags {
71: 			out = append(out, regexp.MustCompile(`(?is)<`+t+`[^>]*>.*?</`+t+`>`))
72: 		}
73: 		return out
74: 	}()
75: )
76: 
77: // maxPageChars caps how much of a fetched page is kept for synthesis.
78: const maxPageChars = 16_000
79: 
80: // Search runs one query and returns normalized results.
81: func (s *Searcher) Search(ctx context.Context, query string, maxResults int) (*Response, error) {
82: 	if s.sidecar == nil {
83: 		return nil, fmt.Errorf("websearch: stealth sidecar not configured")
84: 	}
85: 	if strings.TrimSpace(query) == "" {
86: 		return nil, fmt.Errorf("websearch: empty query")
87: 	}
88: 	if maxResults <= 0 {
89: 		maxResults = 10
90: 	}
91: 	start := time.Now()
92: 
93: 	body, err := s.fetchDDG(ctx, query)
94: 	if err != nil {
95: 		return nil, err
96: 	}
97: 	results := parseResults(body, maxResults)
98: 	return &Response{
99: 		Query:     query,
100: 		Backend:   "duckduckgo-stealth",
101: 		Results:   results,
102: 		LatencyMS: time.Since(start).Milliseconds(),
103: 	}, nil
104: }
105: 
106: func (s *Searcher) fetchDDG(ctx context.Context, query string) (string, error) {
107: 	timeout := s.Timeout
108: 	if timeout <= 0 {
109: 		timeout = 12 * time.Second
110: 	}
111: 	endpoints := []struct{ url, parser string }{
112: 		{"https://html.duckduckgo.com/html/?q=" + url.QueryEscape(query), "html"},
113: 		{"https://lite.duckduckgo.com/lite/?q=" + url.QueryEscape(query), "lite"},
114: 	}
115: 	var lastErr error
116: 	for _, ep := range endpoints {
117: 		cctx, cancel := context.WithTimeout(ctx, timeout)
118: 		resp, err := s.sidecar.Fetch(cctx, hermes.Request{
119: 			URL:       ep.url,
120: 			Method:    "GET",
121: 			TimeoutMS: int(timeout.Milliseconds()),
122: 			HTTP2:     true,
123: 			Headers:   map[string]string{"Accept": "text/html", "Accept-Language": "en-US,en;q=0.9"},
124: 			JSON:      boolPtr(false),
125: 		})
126: 		cancel()
127: 		if err == nil && resp.Status == 200 {
128: 			text := resp.Text()
129: 			if strings.Contains(text, "result__a") || strings.Contains(text, "result-link") {
130: 				return text, nil
131: 			}
132: 			lastErr = fmt.Errorf("ddg returned no results markup (possible bot challenge)")
133: 			continue
134: 		}
135: 		if err != nil {
136: 			lastErr = err
137: 		} else {
138: 			lastErr = fmt.Errorf("ddg http %d", resp.Status)
139: 		}
140: 	}
141: 	return "", fmt.Errorf("websearch: all ddg endpoints failed: %w", lastErr)
142: }
143: 
144: func parseResults(body string, max int) []Result {
145: 	var out []Result
146: 	matches := reResult.FindAllStringSubmatch(body, -1)
147: 	snippets := reSnippet.FindAllStringSubmatch(body, -1)
148: 	if len(matches) == 0 {
149: 		// Lite endpoint fallback parsing.
150: 		for _, m := range reLite.FindAllStringSubmatch(body, -1) {
151: 			u := unwrapDDG(m[1])
152: 			out = append(out, Result{
153: 				Title:    stripTags(m[2]),
154: 				URL:      u,
155: 				Snippet:  "",
156: 				Excerpts: []string{},
157: 			})
158: 			if len(out) >= max {
159: 				break
160: 			}
161: 		}
162: 		return out
163: 	}
164: 	for i, m := range matches {
165: 		u := unwrapDDG(m[1])
166: 		snip := ""
167: 		if i < len(snippets) {
168: 			snip = stripTags(snippets[i][1])
169: 		}
170: 		out = append(out, Result{
171: 			Title:    stripTags(m[2]),
172: 			URL:      u,
173: 			Snippet:  snip,
174: 			Excerpts: []string{},
175: 		})
176: 		if len(out) >= max {
177: 			break
178: 		}
179: 	}
180: 	return out
181: }
182: 
183: // Page is a single keyless full-page read via the stealth sidecar. It backs
184: // /v1/deep-research extraction when no Parallel API key is configured.
185: type Page struct {
186: 	Title string `json:"title"`
187: 	URL   string `json:"url"`
188: 	Text  string `json:"text"`
189: }
190: 
191: // FetchPage reads one page through the stealth sidecar and returns cleaned
192: // article text (script/style/nav stripped, whitespace collapsed, 16k cap).
193: func (s *Searcher) FetchPage(ctx context.Context, rawURL string) (*Page, error) {
194: 	if s.sidecar == nil {
195: 		return nil, fmt.Errorf("websearch: stealth sidecar not configured")
196: 	}
197: 	if strings.TrimSpace(rawURL) == "" {
```

**tool:read** (completed) ../freebuff-unified/internal/websearch/ddg_test.go

```
filePath=/home/x3/freebuff-unified/internal/websearch/ddg_test.go
--- output ---
<path>/home/x3/freebuff-unified/internal/websearch/ddg_test.go</path>
<type>file</type>
<content>
1: package websearch
2: 
3: import (
4: 	"strings"
5: 	"testing"
6: )
7: 
8: const htmlFixture = `<!DOCTYPE html>
9: <html><body>
10: <div class="result results_links">
11:   <a rel="nofollow" class="result__a" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Fdocs.parallel.ai%2Fsearch%2Fmodes&amp;rut=abc">Parallel <b>Search Modes</b> - Docs</a>
12:   <a class="result__snippet" href="#">Search offers <strong>four modes</strong> in order of latency &amp; cost.</a>
13: </div>
14: <div class="result results_links">
15:   <a rel="nofollow" class="result__a" href="https://example.com/direct">Direct link result</a>
16:   <a class="result__snippet" href="#">No wrapper here &lt;b&gt;plain&lt;/b&gt; text.</a>
17: </div>
18: </body></html>`
19: 
20: const liteFixture = `<html><body>
21: <a rel="nofollow" class="result-link" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Flite.example%2Fone">Lite <em>Result</em> One</a>
22: <a rel="nofollow" class="result-link" href="https://plain.example/two">Plain Two</a>
23: </body></html>`
24: 
25: func TestParseResultsHTML(t *testing.T) {
26: 	got := parseResults(htmlFixture, 10)
27: 	if len(got) != 2 {
28: 		t.Fatalf("results = %d, want 2", len(got))
29: 	}
30: 	if got[0].URL != "https://docs.parallel.ai/search/modes" {
31: 		t.Errorf("uddg unwrap failed: %q", got[0].URL)
32: 	}
33: 	if got[0].Title != "Parallel Search Modes - Docs" {
34: 		t.Errorf("title = %q", got[0].Title)
35: 	}
36: 	if !strings.Contains(got[0].Snippet, "four modes") || strings.Contains(got[0].Snippet, "<strong>") {
37: 		t.Errorf("snippet not stripped/unescaped: %q", got[0].Snippet)
38: 	}
39: 	if got[1].URL != "https://example.com/direct" {
40: 		t.Errorf("direct URL mangled: %q", got[1].URL)
41: 	}
42: }
43: 
44: func TestParseResultsLite(t *testing.T) {
45: 	got := parseResults(liteFixture, 10)
46: 	if len(got) != 2 {
47: 		t.Fatalf("results = %d, want 2", len(got))
48: 	}
49: 	if got[0].URL != "https://lite.example/one" || got[0].Title != "Lite Result One" {
50: 		t.Errorf("lite parse wrong: %+v", got[0])
51: 	}
52: }
53: 
54: func TestParseResultsMaxCap(t *testing.T) {
55: 	big := strings.Repeat(`<a class="result__a" href="https://e.com/x">T</a>`, 25)
56: 	got := parseResults(big, 10)
57: 	if len(got) != 10 {
58: 		t.Fatalf("results = %d, want capped 10", len(got))
59: 	}
60: }
61: 
62: func TestUnwrapDDGPlain(t *testing.T) {
63: 	if u := unwrapDDG("https://a.com/b?c=d"); u != "https://a.com/b?c=d" {
64: 		t.Errorf("plain URL changed: %q", u)
65: 	}
66: }

(End of file - total 66 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/parallel/client.go

```
filePath=/home/x3/freebuff-unified/internal/parallel/client.go
--- output ---
<path>/home/x3/freebuff-unified/internal/parallel/client.go</path>
<type>file</type>
<content>
1: // Package parallel is a thin client for the Parallel Web APIs
2: // (https://docs.parallel.ai): Search (LLM-optimized web excerpts), Extract
3: // (URL -> clean markdown), Task runs (Deep Research) and the Responses API.
4: //
5: // Auth is keyless-first: the x-api-key header is only sent when a key is
6: // configured, so free/no-key deployments can still attempt Task runs and
7: // /v1/responses and fall back to the native harness on auth rejection.
8: //
9: // Docs: https://docs.parallel.ai/api-reference/search/search
10: package parallel
11: 
12: import (
13: 	"bytes"
14: 	"context"
15: 	"encoding/json"
16: 	"errors"
17: 	"fmt"
18: 	"io"
19: 	"net/http"
20: 	"net/url"
21: 	"strings"
22: 	"time"
23: )
24: 
25: const defaultBaseURL = "https://api.parallel.ai"
26: 
27: // Client talks to the Parallel REST API.
28: type Client struct {
29: 	baseURL string
30: 	apiKey  string
31: 	http    *http.Client
32: }
33: 
34: // New creates a Parallel client. baseURL may be empty (default). apiKey is
35: // optional: keyless clients omit the x-api-key header and are primarily used
36: // for the free/no-key Task-run and /v1/responses paths.
37: func New(baseURL, apiKey string) *Client {
38: 	if strings.TrimSpace(baseURL) == "" {
39: 		baseURL = defaultBaseURL
40: 	}
41: 	return &Client{
42: 		baseURL: strings.TrimRight(baseURL, "/"),
43: 		apiKey:  apiKey,
44: 		http:    &http.Client{Timeout: 45 * time.Second},
45: 	}
46: }
47: 
48: // Configured reports whether the client has a base URL. Unlike Enabled() it
49: // does not require an API key: keyless deployments still exercise the
50: // Task-run (Layer A) and /v1/responses paths and fall back to the native
51: // harness when the API rejects the keyless call.
52: func (c *Client) Configured() bool { return c != nil && strings.TrimSpace(c.baseURL) != "" }
53: 
54: // Enabled reports whether the client has credentials (a non-empty API key).
55: func (c *Client) Enabled() bool { return c != nil && c.apiKey != "" }
56: 
57: // ---------------------------------------------------------------------------
58: // Search — POST /v1/search
59: // ---------------------------------------------------------------------------
60: 
61: // SearchRequest is the /v1/search payload.
62: type SearchRequest struct {
63: 	// Objective is a natural-language research goal (max 5000 chars).
64: 	Objective string `json:"objective,omitempty"`
65: 	// SearchQueries: 1-5 keyword queries, 3-6 words each.
66: 	SearchQueries []string `json:"search_queries,omitempty"`
67: 	// Mode: turbo (~200ms) | fast (~700ms) | basic (~1s) | advanced (~3s).
68: 	// Empty defaults to advanced server-side.
69: 	Mode string `json:"mode,omitempty"`
70: 	// MaxCharsTotal caps total excerpt characters (default model-dependent).
71: 	MaxCharsTotal int `json:"max_chars_total,omitempty"`
72: 	// ClientModel tunes excerpt shaping for the consuming model.
73: 	ClientModel string `json:"client_model,omitempty"`
74: 	// SessionID groups related Search/Extract calls for one task.
75: 	SessionID string `json:"session_id,omitempty"`
76: 	// AdvancedSettings: source policy, location, max_results, excerpts.
77: 	AdvancedSettings *AdvancedSettings `json:"advanced_settings,omitempty"`
78: }
79: 
80: // AdvancedSettings mirrors the documented advanced_settings object.
81: type AdvancedSettings struct {
82: 	SourcePolicy *SourcePolicy `json:"source_policy,omitempty"`
83: 	Location     string        `json:"location,omitempty"` // ISO 3166-1 alpha-2
84: 	MaxResults   int           `json:"max_results,omitempty"`
85: }
86: 
87: // SourcePolicy includes/excludes domains; AfterDate bounds freshness.
88: type SourcePolicy struct {
89: 	IncludeDomains []string `json:"include_domains,omitempty"`
90: 	ExcludeDomains []string `json:"exclude_domains,omitempty"`
91: 	AfterDate      string   `json:"after_date,omitempty"` // YYYY-MM-DD
92: }
93: 
94: // SearchResult is one ranked page with LLM-optimized excerpts.
95: type SearchResult struct {
96: 	Title    string   `json:"title"`
97: 	URL      string   `json:"url"`
98: 	Excerpts []string `json:"excerpts"`
99: }
100: 
101: // SearchResponse is the /v1/search reply.
102: type SearchResponse struct {
103: 	SearchID  string         `json:"search_id"`
104: 	SessionID string         `json:"session_id"`
105: 	Results   []SearchResult `json:"results"`
106: 	Warnings  []string       `json:"warnings,omitempty"`
107: }
108: 
109: // Search performs a web search and returns ranked excerpts.
110: func (c *Client) Search(ctx context.Context, req SearchRequest) (*SearchResponse, error) {
111: 	if !c.Enabled() {
112: 		return nil, ErrNotConfigured
113: 	}
114: 	var out SearchResponse
115: 	if err := c.post(ctx, "/v1/search", req, &out); err != nil {
116: 		return nil, err
117: 	}
118: 	return &out, nil
119: }
120: 
121: // ---------------------------------------------------------------------------
122: // Extract — POST /v1/extract
123: // ---------------------------------------------------------------------------
124: 
125: // ExtractRequest is the /v1/extract payload (up to 20 URLs per call).
126: type ExtractRequest struct {
127: 	URLs      []string `json:"urls"`
128: 	Objective string   `json:"objective,omitempty"`
129: 	SessionID string   `json:"session_id,omitempty"`
130: }
131: 
132: // ExtractResult is one fetched page.
133: type ExtractResult struct {
134: 	Title       string   `json:"title"`
135: 	URL         string   `json:"url"`
136: 	Excerpts    []string `json:"excerpts,omitempty"`
137: 	FullContent string   `json:"full_content,omitempty"`
138: 	PublishDate string   `json:"publish_date,omitempty"`
139: }
140: 
141: // ExtractError describes a failed URL fetch.
142: type ExtractError struct {
143: 	URL       string `json:"url"`
144: 	ErrorType string `json:"error_type"`
145: }
146: 
147: // ExtractResponse is the /v1/extract reply.
148: type ExtractResponse struct {
149: 	ExtractID string          `json:"extract_id"`
150: 	SessionID string          `json:"session_id"`
151: 	Results   []ExtractResult `json:"results"`
152: 	Errors    []ExtractError  `json:"errors,omitempty"`
153: }
154: 
155: // Extract fetches up to 20 URLs and returns clean markdown/excerpts.
156: func (c *Client) Extract(ctx context.Context, req ExtractRequest) (*ExtractResponse, error) {
157: 	if !c.Enabled() {
158: 		return nil, ErrNotConfigured
159: 	}
160: 	if len(req.URLs) == 0 {
161: 		return nil, fmt.Errorf("parallel: at least one url is required")
162: 	}
163: 	if len(req.URLs) > 20 {
164: 		req.URLs = req.URLs[:20] // API hard cap; extra URLs are dropped
165: 	}
166: 	var out ExtractResponse
167: 	if err := c.post(ctx, "/v1/extract", req, &out); err != nil {
168: 		return nil, err
169: 	}
170: 	return &out, nil
171: }
172: 
173: // ---------------------------------------------------------------------------
174: // Task runs (Deep Research) — Layer A, keyless-first
175: // ---------------------------------------------------------------------------
176: 
177: // TaskRunRequest is the /v1/tasks/runs payload (Deep Research orchestration).
178: type TaskRunRequest struct {
179: 	Input        string `json:"input"`
180: 	Processor    string `json:"processor"`
181: 	EnableEvents bool   `json:"enable_events,omitempty"`
182: 	// OutputSchema selects the report shape: {"type":"auto"} adds basis +
183: 	// citations, {"type":"text"} returns plain markdown, or a raw JSON schema.
184: 	OutputSchema          json.RawMessage `json:"output_schema,omitempty"`
185: 	PreviousInteractionID string          `json:"previous_interaction_id,omitempty"`
186: 	Webhook               *TaskWebhook    `json:"webhook,omitempty"`
187: }
188: 
189: // TaskWebhook registers an HMAC-SHA256-signed callback for run events.
190: type TaskWebhook struct {
191: 	URL        string   `json:"url"`
192: 	EventTypes []string `json:"event_types,omitempty"`
193: }
194: 
195: // TaskRunStatus is the run object returned by create and status polls.
196: type TaskRunStatus struct {
197: 	RunID         string `json:"run_id"`
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/research.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/research.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/research.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"bufio"
5: 	"context"
6: 	"encoding/json"
7: 	"fmt"
8: 	"io"
9: 	"net/http"
10: 	"sort"
11: 	"strings"
12: 	"sync"
13: 	"time"
14: 
15: 	"freebuff-unified/internal/openai"
16: 	"freebuff-unified/internal/parallel"
17: 
18: 	"github.com/gofiber/fiber/v3"
19: )
20: 
21: // ResearchConfig configures the native /v1/deep-research harness (Layer B).
22: // The gateway LLM plans sub-queries, they fan out to the Parallel Search API
23: // (fast mode) and/or the keyless DDG stealth searcher, the top pages are read,
24: // and the LLM synthesizes a cited markdown report.
25: type ResearchConfig struct {
26: 	Enabled         bool
27: 	Model           string
28: 	MaxQueries      int
29: 	FanOut          int
30: 	ExtractPerQuery int
31: 	Timeout         time.Duration
32: }
33: 
34: // maxEvidence bounds how many deduped sources feed the synthesis prompt.
35: const maxEvidence = 12
36: 
37: // researchEvent is one SSE frame emitted during a streaming deep-research run.
38: type researchEvent struct {
39: 	Type string `json:"type"`
40: }
41: 
42: // researchPlan is the strict-JSON output of the planner LLM call.
43: type researchPlan struct {
44: 	Queries []string `json:"queries"`
45: 	Outline []string `json:"outline"`
46: }
47: 
48: // reference is a public, viewer-friendly source entry in the report.
49: type reference struct {
50: 	Title   string `json:"title"`
51: 	URL     string `json:"url"`
52: 	Query   string `json:"query"`
53: 	Snippet string `json:"snippet"`
54: }
55: 
56: // evidence is an internal source with extracted content for the synthesis.
57: type evidence struct {
58: 	reference
59: 	Content string `json:"-"`
60: }
61: 
62: // researchMetrics summarizes a run for the client.
63: type researchMetrics struct {
64: 	ElapsedMS      int64  `json:"elapsed_ms"`
65: 	Queries        int    `json:"queries"`
66: 	Sources        int    `json:"sources"`
67: 	SearchesRun    int    `json:"searches_run"`
68: 	ExtractsRun    int    `json:"extracts_run"`
69: 	SearchBackend  string `json:"search_backend"`
70: 	ExtractBackend string `json:"extract_backend"`
71: 	PlannerModel   string `json:"planner_model"`
72: 	SynthModel     string `json:"synth_model"`
73: }
74: 
75: // researchReport is the synchronous /v1/deep-research response payload.
76: type researchReport struct {
77: 	Report     string          `json:"report"`
78: 	Queries    []string        `json:"queries"`
79: 	Outline    []string        `json:"outline"`
80: 	References []reference     `json:"references"`
81: 	Metrics    researchMetrics `json:"metrics"`
82: }
83: 
84: // researchOpts is the resolved per-request harness configuration.
85: type researchOpts struct {
86: 	model           string
87: 	input           string
88: 	maxQueries      int
89: 	fanOut          int
90: 	extractPerQuery int
91: 	stream          bool
92: 	emit            func(any) error // frame sink; nil in buffered mode
93: }
94: 
95: // DeepResearch is the two-layer /v1/deep-research orchestrator.
96: //
97: // Layer A runs first whenever a Parallel client is configured (the API key is
98: // optional — keyless requests are attempted and this is the "free/no-key"
99: // path). It creates a Parallel Task run and, with stream:true, relays its SSE
100: // events inline. On any keyless/auth/upstream failure it falls through to
101: // Layer B, the native gateway harness (plan → fan-out → synthesize).
102: //
103: // Body: {"input", "stream", "model"?, "max_queries"?, "fan_out"?,
104: // "extract_per_query"?, "processor"?, "enable_events"?, "webhook_url"?,
105: // "output_schema"?}.
106: func (h *handlers) DeepResearch(c fiber.Ctx) error {
107: 	if !hasJSONBody(c.Get(fiber.HeaderContentType)) {
108: 		return writeOpenAIError(c, http.StatusUnsupportedMediaType, "invalid_request_error", "Content-Type must be application/json")
109: 	}
110: 
111: 	var body struct {
112: 		Input           string          `json:"input"`
113: 		Stream          bool            `json:"stream"`
114: 		Model           string          `json:"model"`
115: 		MaxQueries      int             `json:"max_queries"`
116: 		FanOut          int             `json:"fan_out"`
117: 		ExtractPerQuery int             `json:"extract_per_query"`
118: 		Processor       string          `json:"processor"`
119: 		EnableEvents    bool            `json:"enable_events"`
120: 		WebhookURL      string          `json:"webhook_url"`
121: 		OutputSchema    json.RawMessage `json:"output_schema"`
122: 	}
123: 	if err := json.Unmarshal(c.Body(), &body); err != nil {
124: 		return writeOpenAIError(c, http.StatusBadRequest, "invalid_request_error", "Request body must be valid JSON")
125: 	}
126: 	input := strings.TrimSpace(body.Input)
127: 	if input == "" {
128: 		return writeOpenAIError(c, http.StatusBadRequest, "invalid_request_error", "input field is required")
129: 	}
130: 
131: 	// Layer A: Parallel Task runs (keyless-friendly). Only when the create
132: 	// fails do we fall through to the native Layer B harness.
133: 	if h.parallel != nil && h.parallel.Configured() {
134: 		handled, err := h.parallelTaskResearch(c, body)
135: 		if err == nil {
136: 			return handled
137: 		}
138: 	}
139: 
140: 	// Layer B: native gateway harness.
141: 	if !h.research.Enabled {
142: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
143: 			"error": map[string]any{"message": "deep-research is not enabled (set research.enabled in config)", "type": "research_disabled"},
144: 		})
145: 	}
146: 	if _, stub := h.chat.(notConfiguredChatService); stub {
147: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
148: 			"error": map[string]any{"message": "chat service not configured", "type": "research_unavailable"},
149: 		})
150: 	}
151: 	if !h.searchBackendConfigured() {
152: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
153: 			"error": map[string]any{"message": "no search backend configured (set PARALLEL_API_KEY or enable hermes sidecar)", "type": "research_unavailable"},
154: 		})
155: 	}
156: 
157: 	model := body.Model
158: 	if model == "" {
159: 		model = h.research.Model
160: 	}
161: 	if model == "" {
162: 		model = h.model
163: 	}
164: 	opts := researchOpts{
165: 		model:           model,
166: 		input:           input,
167: 		maxQueries:      clampInt(body.MaxQueries, h.research.MaxQueries, 1, 10),
168: 		fanOut:          clampInt(body.FanOut, h.research.FanOut, 1, 32),
169: 		extractPerQuery: clampInt(body.ExtractPerQuery, h.research.ExtractPerQuery, 1, 5),
170: 		stream:          body.Stream,
171: 	}
172: 
173: 	if opts.stream {
174: 		return h.streamResearch(c, opts)
175: 	}
176: 	return h.bufferedResearch(c, opts)
177: }
178: 
179: // parallelTaskResearch creates a Parallel Task run (Layer A). On success it
180: // writes the client response and returns (nil-handler-nil, nil). On failure it
181: // returns (nil-handler, err) so the caller falls back to the native harness.
182: func (h *handlers) parallelTaskResearch(c fiber.Ctx, body struct {
183: 	Input           string          `json:"input"`
184: 	Stream          bool            `json:"stream"`
185: 	Model           string          `json:"model"`
186: 	MaxQueries      int             `json:"max_queries"`
187: 	FanOut          int             `json:"fan_out"`
188: 	ExtractPerQuery int             `json:"extract_per_query"`
189: 	Processor       string          `json:"processor"`
190: 	EnableEvents    bool            `json:"enable_events"`
191: 	WebhookURL      string          `json:"webhook_url"`
192: 	OutputSchema    json.RawMessage `json:"output_schema"`
193: }) (error, error) {
194: 	processor := strings.TrimSpace(body.Processor)
195: 	if processor == "" {
196: 		processor = h.parallelProcessor
197: 	}
```

**tool:read** (completed) ../freebuff-unified/internal/proxy/passthrough.go

```
filePath=/home/x3/freebuff-unified/internal/proxy/passthrough.go
--- output ---
<path>/home/x3/freebuff-unified/internal/proxy/passthrough.go</path>
<type>file</type>
<content>
1: // Package proxy implements the front-door passthrough: the unified engine
2: // receives /v1/* requests, applies its own policy (rate limits, auth) and
3: // then relays them unchanged to a freebuff-proxy backend. The backend does
4: // the protocol work (OpenAI + Anthropic shapes, SSE streaming, session
5: // lifecycle, token pool, dashboard); this package only moves bytes.
6: package proxy
7: 
8: import (
9: 	"io"
10: 	"log"
11: 	"net/http"
12: 	"net/url"
13: 	"strings"
14: 	"sync"
15: 	"time"
16: )
17: 
18: // hopByHopHeaders must not be forwarded (RFC 7230 §6.1).
19: var hopByHopHeaders = []string{
20: 	"Connection",
21: 	"Keep-Alive",
22: 	"Proxy-Authenticate",
23: 	"Proxy-Authorization",
24: 	"Te",
25: 	"Trailer",
26: 	"Transfer-Encoding",
27: 	"Upgrade",
28: }
29: 
30: type Handler struct {
31: 	mu      sync.RWMutex
32: 	backend *url.URL // nil until SetBackend is called
33: 	client  *http.Client
34: 	logger  *log.Logger
35: }
36: 
37: // NewHandler returns a passthrough handler. Use SetBackend to configure (and
38: // later re-configure, on hot reload) the target freebuff-proxy URL.
39: func NewHandler(logger *log.Logger) *Handler {
40: 	transport := http.DefaultTransport.(*http.Transport).Clone()
41: 	transport.ResponseHeaderTimeout = 60 * time.Second
42: 	return &Handler{
43: 		client: &http.Client{Transport: transport},
44: 		logger: logger,
45: 	}
46: }
47: 
48: // SetBackend updates the target backend URL ("" disables proxying).
49: func (h *Handler) SetBackend(rawURL string) {
50: 	h.mu.Lock()
51: 	defer h.mu.Unlock()
52: 	if strings.TrimSpace(rawURL) == "" {
53: 		h.backend = nil
54: 		return
55: 	}
56: 	u, err := url.Parse(strings.TrimRight(strings.TrimSpace(rawURL), "/"))
57: 	if err != nil {
58: 		if h.logger != nil {
59: 			h.logger.Printf("passthrough: invalid backend URL %q: %v", rawURL, err)
60: 		}
61: 		h.backend = nil
62: 		return
63: 	}
64: 	h.backend = u
65: 	if h.logger != nil {
66: 		h.logger.Printf("passthrough: backend set to %s", u.String())
67: 	}
68: }
69: 
70: func (h *Handler) BackendURL() string {
71: 	h.mu.RLock()
72: 	defer h.mu.RUnlock()
73: 	if h.backend == nil {
74: 		return ""
75: 	}
76: 	return h.backend.String()
77: }
78: 
79: func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
80: 	h.mu.RLock()
81: 	backend := h.backend
82: 	h.mu.RUnlock()
83: 	if backend == nil {
84: 		http.Error(w, "proxy backend not configured (set proxy.backend_url)", http.StatusServiceUnavailable)
85: 		return
86: 	}
87: 
88: 	target := *backend
89: 	target.Path = backend.Path + r.URL.Path
90: 	target.RawQuery = r.URL.RawQuery
91: 
92: 	outReq, err := http.NewRequestWithContext(r.Context(), r.Method, target.String(), r.Body)
93: 	if err != nil {
94: 		http.Error(w, "proxy: build request: "+err.Error(), http.StatusInternalServerError)
95: 		return
96: 	}
97: 	copyHeaders(outReq.Header, r.Header)
98: 	outReq.Host = target.Host
99: 
100: 	if h.logger != nil {
101: 		h.logger.Printf("passthrough: %s %s", r.Method, target.String())
102: 	}
103: 
104: 	resp, err := h.client.Do(outReq)
105: 	if err != nil {
106: 		if h.logger != nil {
107: 			h.logger.Printf("passthrough: backend error: %v", err)
108: 		}
109: 		http.Error(w, "proxy backend unreachable: "+err.Error(), http.StatusBadGateway)
110: 		return
111: 	}
112: 	defer resp.Body.Close()
113: 
114: 	RelayResponse(w, resp)
115: }
116: 
117: // RelayResponse copies an upstream *http.Response to the client verbatim:
118: // headers (minus hop-by-hop and Content-Length), status, and body. SSE
119: // responses are flushed after every chunk so frames arrive immediately.
120: func RelayResponse(w http.ResponseWriter, resp *http.Response) {
121: 	copyHeaders(w.Header(), resp.Header)
122: 	w.Header().Del("Content-Length")
123: 	w.WriteHeader(resp.StatusCode)
124: 
125: 	if isEventStream(resp.Header.Get("Content-Type")) {
126: 		if f, ok := w.(http.Flusher); ok {
127: 			f.Flush()
128: 		}
129: 		copyStream(w, resp.Body)
130: 		return
131: 	}
132: 	io.Copy(w, resp.Body)
133: }
134: 
135: // copyStream copies while flushing after every chunk so SSE frames reach the
136: // client immediately instead of buffering until the stream ends.
137: func copyStream(dst io.Writer, src io.Reader) {
138: 	buf := make([]byte, 32*1024)
139: 	for {
140: 		n, err := src.Read(buf)
141: 		if n > 0 {
142: 			if _, werr := dst.Write(buf[:n]); werr != nil {
143: 				return
144: 			}
145: 			if f, ok := dst.(http.Flusher); ok {
146: 				f.Flush()
147: 			}
148: 		}
149: 		if err != nil {
150: 			return
151: 		}
152: 	}
153: }
154: 
155: func isEventStream(contentType string) bool {
156: 	return strings.Contains(strings.ToLower(contentType), "text/event-stream")
157: }
158: 
159: func copyHeaders(dst, src http.Header) {
160: 	for key, values := range src {
161: 		if isHopByHop(key) {
162: 			continue
163: 		}
164: 		for _, v := range values {
165: 			dst.Add(key, v)
166: 		}
167: 	}
168: }
169: 
170: func isHopByHop(key string) bool {
171: 	for _, h := range hopByHopHeaders {
172: 		if strings.EqualFold(h, key) {
173: 			return true
174: 		}
175: 	}
176: 	return false
177: }

(End of file - total 177 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/proxy/passthrough_test.go

```
filePath=/home/x3/freebuff-unified/internal/proxy/passthrough_test.go
--- output ---
<path>/home/x3/freebuff-unified/internal/proxy/passthrough_test.go</path>
<type>file</type>
<content>
1: package proxy
2: 
3: import (
4: 	"io"
5: 	"net/http"
6: 	"net/http/httptest"
7: 	"strings"
8: 	"sync"
9: 	"testing"
10: 	"time"
11: )
12: 
13: func newBackend(t *testing.T, handler http.HandlerFunc) *httptest.Server {
14: 	t.Helper()
15: 	srv := httptest.NewServer(handler)
16: 	t.Cleanup(srv.Close)
17: 	return srv
18: }
19: 
20: func TestNoBackendConfigured(t *testing.T) {
21: 	h := NewHandler(nil)
22: 	rr := httptest.NewRecorder()
23: 	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions", strings.NewReader(`{}`))
24: 
25: 	h.ServeHTTP(rr, req)
26: 
27: 	if rr.Code != http.StatusServiceUnavailable {
28: 		t.Fatalf("expected 503, got %d", rr.Code)
29: 	}
30: 	if !strings.Contains(rr.Body.String(), "not configured") {
31: 		t.Fatalf("expected 'not configured' message, got %q", rr.Body.String())
32: 	}
33: }
34: 
35: func TestSetBackendInvalidAndEmpty(t *testing.T) {
36: 	h := NewHandler(nil)
37: 
38: 	h.SetBackend("://not-a-url")
39: 	if got := h.BackendURL(); got != "" {
40: 		t.Fatalf("invalid backend should be rejected, got %q", got)
41: 	}
42: 
43: 	h.SetBackend("http://127.0.0.1:3457")
44: 	if got := h.BackendURL(); got != "http://127.0.0.1:3457" {
45: 		t.Fatalf("expected backend set, got %q", got)
46: 	}
47: 
48: 	h.SetBackend("")
49: 	if got := h.BackendURL(); got != "" {
50: 		t.Fatalf("empty backend should disable proxying, got %q", got)
51: 	}
52: }
53: 
54: func TestForwardPathQueryMethodAndBody(t *testing.T) {
55: 	var (
56: 		mu        sync.Mutex
57: 		gotPath   string
58: 		gotQuery  string
59: 		gotMethod string
60: 		gotBody   string
61: 	)
62: 	backend := newBackend(t, func(w http.ResponseWriter, r *http.Request) {
63: 		mu.Lock()
64: 		defer mu.Unlock()
65: 		gotPath = r.URL.Path
66: 		gotQuery = r.URL.RawQuery
67: 		gotMethod = r.Method
68: 		body, _ := io.ReadAll(r.Body)
69: 		gotBody = string(body)
70: 		w.WriteHeader(http.StatusOK)
71: 		io.WriteString(w, "ok")
72: 	})
73: 
74: 	h := NewHandler(nil)
75: 	h.SetBackend(backend.URL)
76: 
77: 	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions?stream=true", strings.NewReader(`{"model":"z-ai/glm-5.3-flash"}`))
78: 	req.Header.Set("Content-Type", "application/json")
79: 	rr := httptest.NewRecorder()
80: 
81: 	h.ServeHTTP(rr, req)
82: 
83: 	if gotPath != "/v1/chat/completions" {
84: 		t.Errorf("path = %q, want /v1/chat/completions", gotPath)
85: 	}
86: 	if gotQuery != "stream=true" {
87: 		t.Errorf("query = %q, want stream=true", gotQuery)
88: 	}
89: 	if gotMethod != http.MethodPost {
90: 		t.Errorf("method = %q, want POST", gotMethod)
91: 	}
92: 	if gotBody != `{"model":"z-ai/glm-5.3-flash"}` {
93: 		t.Errorf("body = %q, want original body", gotBody)
94: 	}
95: 	if rr.Code != http.StatusOK || rr.Body.String() != "ok" {
96: 		t.Errorf("response = %d %q, want 200 ok", rr.Code, rr.Body.String())
97: 	}
98: }
99: 
100: func TestForwardHeadersAndStripHopByHop(t *testing.T) {
101: 	var mu sync.Mutex
102: 	received := http.Header{}
103: 	backend := newBackend(t, func(w http.ResponseWriter, r *http.Request) {
104: 		mu.Lock()
105: 		defer mu.Unlock()
106: 		received = r.Header.Clone()
107: 		w.WriteHeader(http.StatusOK)
108: 	})
109: 
110: 	h := NewHandler(nil)
111: 	h.SetBackend(backend.URL)
112: 
113: 	req := httptest.NewRequest(http.MethodGet, "/v1/models", nil)
114: 	req.Header.Set("Authorization", "Bearer client-token")
115: 	req.Header.Set("X-Custom", "keep-me")
116: 	req.Header.Set("X-Forwarded-For", "203.0.113.7")
117: 	req.Header.Set("Connection", "keep-alive")
118: 	req.Header.Set("Keep-Alive", "timeout=5")
119: 	req.Header.Set("Upgrade", "websocket")
120: 	req.Header.Set("Proxy-Authorization", "Basic dXNlcjpwYXNz")
121: 
122: 	h.ServeHTTP(httptest.NewRecorder(), req)
123: 
124: 	for _, key := range []string{"Connection", "Keep-Alive", "Upgrade", "Proxy-Authorization", "Proxy-Connection", "Te", "Trailer", "Transfer-Encoding"} {
125: 		if got := received.Get(key); got != "" {
126: 			t.Errorf("hop-by-hop header %s forwarded: %q", key, got)
127: 		}
128: 	}
129: 	for key, want := range map[string]string{
130: 		"Authorization":   "Bearer client-token",
131: 		"X-Custom":        "keep-me",
132: 		"X-Forwarded-For": "203.0.113.7",
133: 	} {
134: 		if got := received.Get(key); got != want {
135: 			t.Errorf("header %s = %q, want %q", key, got, want)
136: 		}
137: 	}
138: }
139: 
140: func TestErrorRelay(t *testing.T) {
141: 	backend := newBackend(t, func(w http.ResponseWriter, r *http.Request) {
142: 		w.Header().Set("Content-Type", "application/json")
143: 		w.Header().Set("X-Backend", "yes")
144: 		w.WriteHeader(http.StatusPaymentRequired)
145: 		io.WriteString(w, `{"error":{"message":"insufficient credits"}}`)
146: 	})
147: 
148: 	h := NewHandler(nil)
149: 	h.SetBackend(backend.URL)
150: 
151: 	rr := httptest.NewRecorder()
152: 	h.ServeHTTP(rr, httptest.NewRequest(http.MethodPost, "/v1/chat/completions", strings.NewReader(`{}`)))
153: 
154: 	if rr.Code != http.StatusPaymentRequired {
155: 		t.Errorf("status = %d, want 402", rr.Code)
156: 	}
157: 	if body := strings.TrimSpace(rr.Body.String()); body != `{"error":{"message":"insufficient credits"}}` {
158: 		t.Errorf("body = %q, want upstream error relayed unchanged", body)
159: 	}
160: 	if rr.Header().Get("X-Backend") != "yes" {
161: 		t.Errorf("backend header X-Backend not relayed")
162: 	}
163: 	if rr.Header().Get("Content-Type") != "application/json" {
164: 		t.Errorf("content-type = %q, want application/json", rr.Header().Get("Content-Type"))
165: 	}
166: }
167: 
168: func TestSSEStreamingFlushesPerFrame(t *testing.T) {
169: 	backend := newBackend(t, func(w http.ResponseWriter, r *http.Request) {
170: 		w.Header().Set("Content-Type", "text/event-stream")
171: 		w.WriteHeader(http.StatusOK)
172: 		f := w.(http.Flusher)
173: 		for _, frame := range []string{"data: frame0\n\n", "data: frame1\n\n", "data: [DONE]\n\n"} {
174: 			io.WriteString(w, frame)
175: 			f.Flush()
176: 			time.Sleep(30 * time.Millisecond)
177: 		}
178: 	})
179: 
180: 	h := NewHandler(nil)
181: 	h.SetBackend(backend.URL)
182: 
183: 	rr := httptest.NewRecorder()
184: 	req := httptest.NewRequest(http.MethodPost, "/v1/chat/completions", strings.NewReader(`{"stream":true}`))
185: 	req.Header.Set("Content-Type", "application/json")
186: 	h.ServeHTTP(rr, req)
187: 
188: 	if rr.Code != http.StatusOK {
189: 		t.Fatalf("status = %d, want 200", rr.Code)
190: 	}
191: 	if got := rr.Header().Get("Content-Type"); got != "text/event-stream" {
192: 		t.Errorf("content-type = %q, want text/event-stream", got)
193: 	}
194: 	if !rr.Flushed {
195: 		t.Error("SSE response was never flushed")
196: 	}
197: 	body := rr.Body.String()
```

---

### 🤖 Assistant — 2026-09-12 00:04:47

> Now let me read the remaining files needed: hermes client, stealth, cache, ratelimit, server, middleware, handlers, config, and search for sync.Pool usage and goroutine patterns.

**tool:read** (completed) ../freebuff-unified/internal/hermes/client.go

```
filePath=/home/x3/freebuff-unified/internal/hermes/client.go
--- output ---
<path>/home/x3/freebuff-unified/internal/hermes/client.go</path>
<type>file</type>
<content>
1: // Package hermes is a thin client for the hermes stealth sidecar
2: // (deps/hermes-service), which wraps the vendored @kori_xyz/hermes Node
3: // library (TLS 1.3 / HTTP2 / proxy stealth requests) behind a local HTTP API.
4: package hermes
5: 
6: import (
7: 	"bytes"
8: 	"context"
9: 	"encoding/base64"
10: 	"encoding/json"
11: 	"fmt"
12: 	"io"
13: 	"net/http"
14: 	"net/url"
15: 	"strings"
16: 	"time"
17: )
18: 
19: // Client talks to the hermes sidecar.
20: type Client struct {
21: 	baseURL string
22: 	http    *http.Client
23: }
24: 
25: // New creates a client for the sidecar at baseURL (e.g. http://127.0.0.1:3101).
26: func New(baseURL string) *Client {
27: 	return &Client{
28: 		baseURL: strings.TrimRight(baseURL, "/"),
29: 		http:    &http.Client{Timeout: 60 * time.Second},
30: 	}
31: }
32: 
33: // NewWithTimeout creates a sidecar client with a custom overall HTTP timeout
34: // (useful when relaying long upstream LLM completions through the sidecar).
35: func NewWithTimeout(baseURL string, timeout time.Duration) *Client {
36: 	if timeout <= 0 {
37: 		return New(baseURL)
38: 	}
39: 	return &Client{
40: 		baseURL: strings.TrimRight(baseURL, "/"),
41: 		http:    &http.Client{Timeout: timeout},
42: 	}
43: }
44: 
45: // Request describes a stealth request to execute via the sidecar.
46: type Request struct {
47: 	URL       string            `json:"url"`
48: 	Method    string            `json:"method,omitempty"`
49: 	Headers   map[string]string `json:"headers,omitempty"`
50: 	Payload   json.RawMessage   `json:"payload,omitempty"`
51: 	Proxy     string            `json:"proxy,omitempty"`
52: 	TimeoutMS int               `json:"timeout_ms,omitempty"`
53: 	HTTP2     bool              `json:"http2,omitempty"`
54: 	JSON      *bool             `json:"json,omitempty"`
55: }
56: 
57: // Response is the sidecar's normalized reply.
58: type Response struct {
59: 	Status      int               `json:"status"`
60: 	Headers     map[string]string `json:"headers"`
61: 	HTTPVersion string            `json:"http_version"`
62: 	Data        json.RawMessage   `json:"data"`
63: 	DataB64     string            `json:"data_b64"`
64: 	ElapsedMS   int64             `json:"elapsed_ms"`
65: 
66: 	// Decoded holds the response body: JSON parsed into any, text as string,
67: 	// or binary decoded from DataB64 into []byte.
68: 	Decoded any `json:"-"`
69: }
70: 
71: // Health is the sidecar /healthz payload.
72: type Health struct {
73: 	Status   string `json:"status"`
74: 	Service  string `json:"service"`
75: 	Hermes   string `json:"hermes"`
76: 	Node     string `json:"node"`
77: 	Sessions int    `json:"sessions"`
78: 	UptimeS  int    `json:"uptime_s"`
79: }
80: 
81: // Fetch performs a one-shot stealth request (no cookie jar).
82: func (c *Client) Fetch(ctx context.Context, req Request) (*Response, error) {
83: 	return c.do(ctx, "/v1/fetch", req)
84: }
85: 
86: // FetchWithSession performs a stealth request using (and updating) the named
87: // server-side cookie session. Sessions expire server-side after 30 minutes
88: // of inactivity.
89: func (c *Client) FetchWithSession(ctx context.Context, sessionID string, req Request) (*Response, error) {
90: 	return c.do(ctx, "/v1/session/"+url.PathEscape(sessionID), req)
91: }
92: 
93: // DropSession removes a server-side cookie session.
94: func (c *Client) DropSession(ctx context.Context, sessionID string) error {
95: 	req, err := http.NewRequestWithContext(ctx, http.MethodDelete,
96: 		c.baseURL+"/v1/session/"+url.PathEscape(sessionID), nil)
97: 	if err != nil {
98: 		return err
99: 	}
100: 	resp, err := c.http.Do(req)
101: 	if err != nil {
102: 		return err
103: 	}
104: 	defer resp.Body.Close()
105: 	if resp.StatusCode != http.StatusOK {
106: 		return fmt.Errorf("drop session: http %d", resp.StatusCode)
107: 	}
108: 	return nil
109: }
110: 
111: // Health probes the sidecar.
112: func (c *Client) Health(ctx context.Context) (*Health, error) {
113: 	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.baseURL+"/healthz", nil)
114: 	if err != nil {
115: 		return nil, err
116: 	}
117: 	resp, err := c.http.Do(req)
118: 	if err != nil {
119: 		return nil, err
120: 	}
121: 	defer resp.Body.Close()
122: 	if resp.StatusCode != http.StatusOK {
123: 		return nil, fmt.Errorf("hermes health: http %d", resp.StatusCode)
124: 	}
125: 	var h Health
126: 	if err := json.NewDecoder(resp.Body).Decode(&h); err != nil {
127: 		return nil, err
128: 	}
129: 	return &h, nil
130: }
131: 
132: func (c *Client) do(ctx context.Context, path string, req Request) (*Response, error) {
133: 	body, err := json.Marshal(req)
134: 	if err != nil {
135: 		return nil, err
136: 	}
137: 	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+path, bytes.NewReader(body))
138: 	if err != nil {
139: 		return nil, err
140: 	}
141: 	httpReq.Header.Set("Content-Type", "application/json")
142: 
143: 	httpResp, err := c.http.Do(httpReq)
144: 	if err != nil {
145: 		return nil, err
146: 	}
147: 	defer httpResp.Body.Close()
148: 
149: 	raw, err := io.ReadAll(io.LimitReader(httpResp.Body, 32<<20))
150: 	if err != nil {
151: 		return nil, err
152: 	}
153: 	if httpResp.StatusCode != http.StatusOK {
154: 		return nil, fmt.Errorf("hermes fetch: http %d: %s", httpResp.StatusCode, truncate(raw, 200))
155: 	}
156: 
157: 	var r Response
158: 	if err := json.Unmarshal(raw, &r); err != nil {
159: 		return nil, err
160: 	}
161: 	r.decode()
162: 	return &r, nil
163: }
164: 
165: func (r *Response) decode() {
166: 	switch {
167: 	case r.DataB64 != "":
168: 		if b, err := base64.StdEncoding.DecodeString(r.DataB64); err == nil {
169: 			r.Decoded = b
170: 		}
171: 	case len(r.Data) > 0:
172: 		// The sidecar returns text/HTML bodies as JSON-encoded strings
173: 		// (e.g. data: "<a class=\"result__a\" ...>"). Unwrap the outer JSON
174: 		// string so Text() yields the real body bytes; JSON objects/arrays
175: 		// stay as RawMessage.
176: 		var s string
177: 		if err := json.Unmarshal(r.Data, &s); err == nil {
178: 			r.Decoded = s
179: 			return
180: 		}
181: 		r.Decoded = json.RawMessage(r.Data)
182: 	}
183: }
184: 
185: // Text returns the body as a string (best-effort for JSON bodies too).
186: func (r *Response) Text() string {
187: 	switch v := r.Decoded.(type) {
188: 	case []byte:
189: 		return string(v)
190: 	case string:
191: 		return v
192: 	case json.RawMessage:
193: 		return string(v)
194: 	default:
195: 		return ""
196: 	}
197: }
```

**tool:read** (completed) ../freebuff-unified/internal/cache/run_cache.go

```
filePath=/home/x3/freebuff-unified/internal/cache/run_cache.go
--- output ---
<path>/home/x3/freebuff-unified/internal/cache/run_cache.go</path>
<type>file</type>
<content>
1: package cache
2: 
3: import (
4: 	"fmt"
5: 	"hash/fnv"
6: 	"sync"
7: 	"time"
8: )
9: 
10: // entry holds a cached value with its expiry time.
11: type entry struct {
12: 	value     string
13: 	expiresAt int64
14: }
15: 
16: // RunCache is an in-memory, TTL-aware cache for agent run IDs.
17: type RunCache struct {
18: 	mu      sync.RWMutex
19: 	entries map[string]*entry
20: 	order   []string
21: 	max     int
22: 	ttl     time.Duration
23: 	salt    string
24: }
25: 
26: // Config configures the RunCache.
27: type Config struct {
28: 	MaxEntries int
29: 	TTL        time.Duration
30: 	Salt       string
31: }
32: 
33: // DefaultConfig returns sensible defaults.
34: func DefaultConfig() Config {
35: 	return Config{
36: 		MaxEntries: 512,
37: 		TTL:        30 * time.Minute,
38: 		Salt:       "cmux-use-platform-key",
39: 	}
40: }
41: 
42: // NewRunCache creates a new RunCache.
43: func NewRunCache(cfg Config) *RunCache {
44: 	if cfg.MaxEntries <= 0 {
45: 		cfg.MaxEntries = 512
46: 	}
47: 	if cfg.TTL <= 0 {
48: 		cfg.TTL = 30 * time.Minute
49: 	}
50: 	return &RunCache{
51: 		entries: make(map[string]*entry),
52: 		max:     cfg.MaxEntries,
53: 		ttl:     cfg.TTL,
54: 		salt:    cfg.Salt,
55: 	}
56: }
57: 
58: // Get retrieves a cached value.
59: func (c *RunCache) Get(key string) (string, bool) {
60: 	c.mu.RLock()
61: 	e, ok := c.entries[key]
62: 	if !ok {
63: 		c.mu.RUnlock()
64: 		return "", false
65: 	}
66: 
67: 	now := time.Now().UnixMilli()
68: 	if e.expiresAt > 0 && now > e.expiresAt {
69: 		c.mu.RUnlock()
70: 		c.mu.Lock()
71: 		delete(c.entries, key)
72: 		c.removeOrderLocked(key)
73: 		c.mu.Unlock()
74: 		return "", false
75: 	}
76: 	c.mu.RUnlock()
77: 	return e.value, true
78: }
79: 
80: // Set stores a value with TTL.
81: func (c *RunCache) Set(key, value string) {
82: 	c.mu.Lock()
83: 	defer c.mu.Unlock()
84: 
85: 	if _, ok := c.entries[key]; ok {
86: 		c.entries[key] = &entry{
87: 			value:     value,
88: 			expiresAt: time.Now().Add(c.ttl).UnixMilli(),
89: 		}
90: 		return
91: 	}
92: 
93: 	if len(c.entries) >= c.max {
94: 		for _, oldKey := range c.order {
95: 			if _, ok := c.entries[oldKey]; ok {
96: 				delete(c.entries, oldKey)
97: 				c.removeOrderLocked(oldKey)
98: 				break
99: 			}
100: 		}
101: 	}
102: 
103: 	c.entries[key] = &entry{
104: 		value:     value,
105: 		expiresAt: time.Now().Add(c.ttl).UnixMilli(),
106: 	}
107: 	c.order = append(c.order, key)
108: }
109: 
110: // Delete removes a key from the cache.
111: func (c *RunCache) Delete(key string) {
112: 	c.mu.Lock()
113: 	defer c.mu.Unlock()
114: 	delete(c.entries, key)
115: 	c.removeOrderLocked(key)
116: }
117: 
118: // Len returns the current number of cache entries.
119: func (c *RunCache) Len() int {
120: 	c.mu.RLock()
121: 	defer c.mu.RUnlock()
122: 	return len(c.entries)
123: }
124: 
125: // HashFNV1a returns a salted FNV-1a hash of the input.
126: func (c *RunCache) HashFNV1a(value string) string {
127: 	input := c.salt + ":" + value
128: 	h := fnv.New32a()
129: 	h.Write([]byte(input))
130: 	return fmt.Sprintf("%x", h.Sum32())
131: }
132: 
133: // BuildAgentRunCacheKey builds the cache key for an agent run ID.
134: func BuildAgentRunCacheKey(hashedKey, agentID, clientIdentity string) string {
135: 	return hashedKey + "\x00" + agentID + "\x00" + clientIdentity
136: }
137: 
138: func (c *RunCache) removeOrderLocked(key string) {
139: 	for i, k := range c.order {
140: 		if k == key {
141: 			c.order = append(c.order[:i], c.order[i+1:]...)
142: 			return
143: 		}
144: 	}
145: }

(End of file - total 145 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/ratelimit.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/ratelimit.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/ratelimit.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"fmt"
5: 	"hash/fnv"
6: 	"net/http"
7: 	"sync"
8: 	"time"
9: 
10: 	"github.com/gofiber/fiber/v3"
11: )
12: 
13: // tokenBucket is a per-identity fixed-capacity token bucket (capacity = rpm,
14: // refill = rpm tokens per minute). It is safe for concurrent use.
15: type tokenBucket struct {
16: 	mu     sync.Mutex
17: 	tokens float64
18: 	last   time.Time
19: }
20: 
21: // take consumes one token if available, refilling at rate RPM. The first use
22: // seeds a full bucket so a fresh identity is not throttled on request 1.
23: func (b *tokenBucket) take(rpm float64, now time.Time) bool {
24: 	b.mu.Lock()
25: 	defer b.mu.Unlock()
26: 	if b.last.IsZero() {
27: 		b.last = now
28: 		b.tokens = rpm
29: 	}
30: 	elapsed := now.Sub(b.last).Minutes()
31: 	if elapsed > 0 {
32: 		b.tokens += rpm * elapsed
33: 		if b.tokens > rpm {
34: 			b.tokens = rpm
35: 		}
36: 		b.last = now
37: 	}
38: 	if b.tokens >= 1 {
39: 		b.tokens--
40: 		return true
41: 	}
42: 	return false
43: }
44: 
45: // RateLimiter enforces three-tier RPM limits (global/account/client) with
46: // lazy per-identity token buckets.  RateLimiter may be nil — the middleware
47: // then performs no enforcement.
48: type RateLimiter struct {
49: 	globalRPM  float64
50: 	accountRPM float64
51: 	clientRPM  float64
52: 
53: 	mu      sync.Mutex
54: 	global  tokenBucket
55: 	account map[string]*tokenBucket
56: 	client  map[string]*tokenBucket
57: }
58: 
59: // NewRateLimiter creates a RateLimiter with the configured RPM tiers.  All
60: // tiers are 0-treated as unlimited if the value is <= 0.
61: func NewRateLimiter(global, account, client int) *RateLimiter {
62: 	l := &RateLimiter{
63: 		globalRPM:  safeRPM(global, 120),
64: 		accountRPM: safeRPM(account, 30),
65: 		clientRPM:  safeRPM(client, 60),
66: 		account:    make(map[string]*tokenBucket),
67: 		client:     make(map[string]*tokenBucket),
68: 	}
69: 	return l
70: }
71: 
72: func safeRPM(val, def int) float64 {
73: 	if val <= 0 {
74: 		return float64(def)
75: 	}
76: 	return float64(val)
77: }
78: 
79: // Allow checks all three tiers.  accountID is the presented credential hash;
80: // clientID is typically the source IP or X-Client-Id header.
81: func (l *RateLimiter) Allow(accountID, clientID string) bool {
82: 	if l == nil {
83: 		return true
84: 	}
85: 	now := time.Now()
86: 	if !l.global.take(l.globalRPM, now) {
87: 		return false
88: 	}
89: 	ab := l.getBucket(l.account, accountID, l.accountRPM)
90: 	if !ab.take(l.accountRPM, now) {
91: 		return false
92: 	}
93: 	cb := l.getBucket(l.client, clientID, l.clientRPM)
94: 	if !cb.take(l.clientRPM, now) {
95: 		return false
96: 	}
97: 	return true
98: }
99: 
100: func (l *RateLimiter) getBucket(m map[string]*tokenBucket, key string, rpm float64) *tokenBucket {
101: 	_ = rpm // not used during creation; capacity is rpm on the allow path
102: 	l.mu.Lock()
103: 	defer l.mu.Unlock()
104: 	b, ok := m[key]
105: 	if !ok {
106: 		b = &tokenBucket{}
107: 		m[key] = b
108: 		if len(m) > 512 {
109: 			cutoff := time.Now().Add(-5 * time.Minute)
110: 			for k, v := range m {
111: 				v.mu.Lock()
112: 				idle := v.last.Before(cutoff)
113: 				v.mu.Unlock()
114: 				if idle {
115: 					delete(m, k)
116: 				}
117: 			}
118: 		}
119: 	}
120: 	return b
121: }
122: 
123: // credentialID produces a non-reversible short key for the presented auth
124: // credential.  An empty input returns the single bucket ID "0".
125: func credentialID(auth, apiKey string) string {
126: 	v := apiKey
127: 	if auth != "" {
128: 		v = auth
129: 	}
130: 	h := fnv.New64a()
131: 	_, _ = h.Write([]byte(v))
132: 	return fmt.Sprintf("%x", h.Sum64())
133: }
134: 
135: // rateLimitMiddleware enforces the three-tier RPM policy per request.
136: // Health/status probe paths are always allowed through.
137: func rateLimitMiddleware(l *RateLimiter) fiber.Handler {
138: 	return func(c fiber.Ctx) error {
139: 		if l == nil || isPublicStatusPath(c.Path()) {
140: 			return c.Next()
141: 		}
142: 		account := credentialID(c.Get(fiber.HeaderAuthorization), c.Get("x-api-key"))
143: 		client := c.Get("X-Client-Id")
144: 		if client == "" {
145: 			client = c.IP()
146: 		}
147: 		if !l.Allow(account, client) {
148: 			c.Set("Retry-After", "60")
149: 			return writeOpenAIError(c, http.StatusTooManyRequests, "rate_limit_exceeded", "Rate limit exceeded, please retry later")
150: 		}
151: 		return c.Next()
152: 	}
153: }
154: 
155: // isPublicStatusPath reports whether the path is a non-sensitive probe
156: // endpoint that must always be reachable regardless of quota.
157: func isPublicStatusPath(path string) bool {
158: 	return path == "/healthz" || path == "/ai-stack/status" || path == "/proxy/verify"
159: }

(End of file - total 159 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/server.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/server.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/server.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"time"
5: 
6: 	"github.com/gofiber/fiber/v3"
7: 	"github.com/gofiber/fiber/v3/middleware/adaptor"
8: 
9: 	"freebuff-unified/internal/hermes"
10: 	"freebuff-unified/internal/parallel"
11: 	"freebuff-unified/internal/proxy"
12: 	"freebuff-unified/internal/stealth"
13: 	"freebuff-unified/internal/websearch"
14: )
15: 
16: // Options holds the external dependencies for the HTTP API server.
17: type Options struct {
18: 	Model       string
19: 	ProxyAPIKey string
20: 	Chat        ChatService
21: 	TokenPool   PoolStatsProvider
22: 	ProxyPool   PoolStatsProvider
23: 	// Hermes, when set, exposes the stealth sidecar endpoints
24: 	// (/hermes/healthz, /v1/hermes/fetch, /v1/hermes/session/:id).
25: 	Hermes *hermes.Client
26: 	// Parallel, when enabled, exposes key-gated /v1/parallel/search and
27: 	// /v1/parallel/extract proxies to the Parallel Web APIs, plus the Layer A
28: 	// keyless-first /v1/deep-research Task orchestration and /v1/responses.
29: 	Parallel          *parallel.Client
30: 	ParallelMode      string
31: 	ParallelProcessor string
32: 	// Research tunes the native Layer B harness (/v1/deep-research fallback).
33: 	Research ResearchConfig
34: 	// Limiter, when set, enforces the three-tier RPM policy
35: 	// (global/account/client) on all credentialed routes.
36: 	Limiter *RateLimiter
37: 	// WebSearcher is the keyless stealth search backend (hermes sidecar).
38: 	// /v1/parallel/search falls back to it when Parallel has no API key.
39: 	WebSearcher *websearch.Searcher
40: 	// Stealth, when set, backs GET /stealth/status with transport metrics
41: 	// (sidecar latency, fallback counts, egress IPs used).
42: 	Stealth *stealth.Metrics
43: 	// Refresher, when set, contributes the proxy-pool auto-refresh state to
44: 	// GET /stealth/status.
45: 	Refresher func() map[string]any
46: 	// ExtraHealth, when set, contributes additional fields to the /healthz
47: 	// and /proxy/verify payloads (ai-stack peers, pool sizes, uptime).
48: 	ExtraHealth func() map[string]any
49: 	// AIStack, when set, backs the /ai-stack/status endpoint with a full
50: 	// infrastructure report instead of the plain health summary.
51: 	AIStack func() map[string]any
52: 	// Passthrough, when set, exposes the front-door byte-level relay to a
53: 	// freebuff-proxy backend. Activated only when cfg.Proxy.Mode is
54: 	// "passthrough"; otherwise native routes are registered (default).
55: 	Passthrough *proxy.Handler
56: 	// BackendURL is the freebuff-proxy backend address used when Passthrough
57: 	// is wired (from proxy.backend_url / FREEBUFF_PROXY_BACKEND).
58: 	BackendURL string
59: }
60: 
61: // NewApp creates a Fiber v3 app with health, models, and chat routes.
62: func NewApp(opts Options) *fiber.App {
63: 	app := fiber.New(fiber.Config{
64: 		AppName:      "freebuff-unified",
65: 		ReadTimeout:  30 * time.Second,
66: 		WriteTimeout: 310 * time.Second,
67: 		IdleTimeout:  120 * time.Second,
68: 	})
69: 
70: 	handlers := newHandlers(opts.Model, opts.Chat, opts.TokenPool, opts.ProxyPool)
71: 	handlers.hermes = opts.Hermes
72: 	handlers.parallel = opts.Parallel
73: 	handlers.parallelMode = opts.ParallelMode
74: 	handlers.parallelProcessor = opts.ParallelProcessor
75: 	handlers.research = opts.Research
76: 	handlers.webSearcher = opts.WebSearcher
77: 	handlers.stealth = opts.Stealth
78: 	handlers.refresher = opts.Refresher
79: 	handlers.extraHealth = opts.ExtraHealth
80: 	handlers.aiStack = opts.AIStack
81: 
82: 	if opts.ProxyAPIKey != "" {
83: 		app.Use(func(c fiber.Ctx) error {
84: 			// Health, ai-stack status, and proxy verification endpoints are
85: 			// always public so monitors can probe them without a key.
86: 			if c.Path() == "/healthz" || c.Path() == "/ai-stack/status" || c.Path() == "/proxy/verify" {
87: 				return c.Next()
88: 			}
89: 			return authMiddleware(opts.ProxyAPIKey)(c)
90: 		})
91: 	}
92: 
93: 	// Three-tier RPM policy (global/account/client). Probes stay public.
94: 	if opts.Limiter != nil {
95: 		app.Use(rateLimitMiddleware(opts.Limiter))
96: 	}
97: 
98: 	app.Get("/healthz", handlers.Health)
99: 	app.Get("/ai-stack/status", handlers.AIStackStatus)
100: 	app.Get("/proxy/verify", handlers.Health)
101: 
102: 	// Deep-research (Layer A Task runs, keyless-first, native Layer B
103: 	// fallback) and the /v1/responses surface. Registered before the
104: 	// front-door relay so they stay native — key-gated by the auth middleware
105: 	// above — even in passthrough mode.
106: 	app.Post("/v1/deep-research", handlers.DeepResearch)
107: 	app.Get("/v1/deep-research/:id", handlers.DeepResearchGet)
108: 	app.Get("/v1/deep-research/:id/events", handlers.DeepResearchEvents)
109: 	app.Post("/v1/responses", handlers.ResponsesPassthrough)
110: 
111: 	if opts.Passthrough != nil {
112: 		// Front-door mode: /v1/* is relayed verbatim to the freebuff-proxy
113: 		// backend (its sessions, token pool, and dashboard do the protocol
114: 		// work). Everything else stays native.
115: 		opts.Passthrough.SetBackend(opts.BackendURL)
116: 		app.All("/v1/*", adaptor.HTTPHandler(opts.Passthrough))
117: 		return app
118: 	}
119: 
120: 	app.Get("/v1/models", handlers.Models)
121: 	app.Post("/v1/chat/completions", handlers.ChatCompletions)
122: 	app.Post("/v1/messages", handlers.AnthropicMessages)
123: 	app.Post("/v1/messages/count_tokens", handlers.AnthropicCountTokens)
124: 
125: 	// Hermes stealth sidecar (key-protected, auth middleware above).
126: 	app.Get("/hermes/healthz", handlers.HermesHealth)
127: 	app.Get("/stealth/status", handlers.StealthStatus)
128: 	app.Post("/v1/hermes/fetch", handlers.HermesFetch)
129: 	app.Post("/v1/hermes/session/:id", handlers.HermesSessionFetch)
130: 	app.Delete("/v1/hermes/session/:id", handlers.HermesSessionDelete)
131: 
132: 	// Parallel Web APIs (key-protected, auth middleware above).
133: 	app.Post("/v1/parallel/search", handlers.ParallelSearch)
134: 	app.Post("/v1/parallel/extract", handlers.ParallelExtract)
135: 
136: 	return app
137: }

(End of file - total 137 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/middleware.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/middleware.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/middleware.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"net/http"
5: 
6: 	"github.com/gofiber/fiber/v3"
7: )
8: 
9: const bearerPrefix = "Bearer "
10: 
11: // authMiddleware enforces the proxy API key on all requests.
12: func authMiddleware(proxyAPIKey string) fiber.Handler {
13: 	return func(c fiber.Ctx) error {
14: 		if c.Get(fiber.HeaderAuthorization) != bearerPrefix+proxyAPIKey && c.Get("x-api-key") != proxyAPIKey {
15: 			return writeOpenAIError(c, http.StatusUnauthorized, "invalid_api_key", "A valid Bearer API key is required")
16: 		}
17: 		return c.Next()
18: 	}
19: }

(End of file - total 19 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/handlers.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/handlers.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/handlers.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"bufio"
5: 	"bytes"
6: 	"context"
7: 	"encoding/json"
8: 	"errors"
9: 	"fmt"
10: 	"io"
11: 	"mime"
12: 	"net/http"
13: 	"strings"
14: 	"time"
15: 
16: 	"freebuff-unified/internal/anthropic"
17: 	"freebuff-unified/internal/hermes"
18: 	"freebuff-unified/internal/openai"
19: 	"freebuff-unified/internal/parallel"
20: 	"freebuff-unified/internal/stealth"
21: 	"freebuff-unified/internal/websearch"
22: 	"github.com/gofiber/fiber/v3"
23: )
24: 
25: // ChatService is the interface the HTTP layer expects from the chat adapter.
26: type ChatService interface {
27: 	Complete(ctx context.Context, req openai.ChatCompletionRequest) (string, error)
28: 	Stream(ctx context.Context, req openai.ChatCompletionRequest) (<-chan string, <-chan error)
29: }
30: 
31: // ServiceError carries a service-level error with HTTP status.
32: type ServiceError struct {
33: 	Status  int
34: 	Code    string
35: 	Message string
36: }
37: 
38: func (e *ServiceError) Error() string {
39: 	if e == nil {
40: 		return ""
41: 	}
42: 	if e.Message != "" {
43: 		return e.Message
44: 	}
45: 	if e.Code != "" {
46: 		return e.Code
47: 	}
48: 	return http.StatusText(e.Status)
49: }
50: 
51: const streamHeartbeatInterval = 15 * time.Second
52: 
53: // PoolStatsProvider is the interface for /healthz monitoring providers.
54: type PoolStatsProvider interface {
55: 	Stats() any
56: }
57: 
58: type handlers struct {
59: 	model             string
60: 	chat              ChatService
61: 	tokenPool         PoolStatsProvider
62: 	proxyPool         PoolStatsProvider
63: 	hermes            *hermes.Client
64: 	parallel          *parallel.Client
65: 	parallelMode      string
66: 	parallelProcessor string
67: 	webSearcher       *websearch.Searcher
68: 	research          ResearchConfig
69: 	stealth           *stealth.Metrics
70: 	refresher         func() map[string]any
71: 	extraHealth       func() map[string]any
72: 	aiStack           func() map[string]any
73: }
74: 
75: type notConfiguredChatService struct{}
76: 
77: func newHandlers(model string, chat ChatService, tokenPool, proxyPool PoolStatsProvider) *handlers {
78: 	if chat == nil {
79: 		chat = notConfiguredChatService{}
80: 	}
81: 	return &handlers{
82: 		model:     model,
83: 		chat:      chat,
84: 		tokenPool: tokenPool,
85: 		proxyPool: proxyPool,
86: 	}
87: }
88: 
89: // HermesHealth reports the hermes stealth sidecar liveness.
90: func (h *handlers) HermesHealth(c fiber.Ctx) error {
91: 	if h.hermes == nil {
92: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
93: 			"status": "disabled",
94: 		})
95: 	}
96: 	health, err := h.hermes.Health(c)
97: 	if err != nil {
98: 		return c.Status(http.StatusBadGateway).JSON(map[string]any{
99: 			"status": "unreachable",
100: 			"error":  err.Error(),
101: 		})
102: 	}
103: 	return c.Status(http.StatusOK).JSON(health)
104: }
105: 
106: // ParallelSearch proxies a web search through the Parallel Search API.
107: // Body: {"objective": str, "search_queries": [..], "mode": "fast", "max_results": 10}
108: func (h *handlers) ParallelSearch(c fiber.Ctx) error {
109: 	// No Parallel key AND no keyless stealth backend configured: the endpoint
110: 	// cannot serve anything. When only the key is missing, the keyless
111: 	// stealth search backend (hermes sidecar) takes over below.
112: 	if (h.parallel == nil || !h.parallel.Enabled()) && h.webSearcher == nil {
113: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
114: 			"error": map[string]any{"message": "no search backend configured (set PARALLEL_API_KEY or enable hermes sidecar)", "type": "search_unavailable"},
115: 		})
116: 	}
117: 	var body struct {
118: 		Objective      string   `json:"objective"`
119: 		SearchQueries  []string `json:"search_queries"`
120: 		Mode           string   `json:"mode"`
121: 		MaxResults     int      `json:"max_results"`
122: 		ClientModel    string   `json:"client_model"`
123: 		MaxCharsTotal  int      `json:"max_chars_total"`
124: 		SessionID      string   `json:"session_id"`
125: 		Location       string   `json:"location"`
126: 		ExcludeDomains []string `json:"exclude_domains"`
127: 		Proxy          string   `json:"proxy"`
128: 	}
129: 	if err := json.Unmarshal(c.Body(), &body); err != nil {
130: 		return c.Status(http.StatusBadRequest).JSON(map[string]any{
131: 			"error": map[string]any{"message": "invalid JSON body", "type": "invalid_request_error"},
132: 		})
133: 	}
134: 	if strings.TrimSpace(body.Objective) == "" && len(body.SearchQueries) == 0 {
135: 		return c.Status(http.StatusBadRequest).JSON(map[string]any{
136: 			"error": map[string]any{"message": "objective or search_queries required", "type": "invalid_request_error"},
137: 		})
138: 	}
139: 	// Keyless stealth backend: used when Parallel has no API key. Search
140: 	// queries merge into the objective for keyword-style engines.
141: 	if h.parallel == nil || !h.parallel.Enabled() {
142: 		q := strings.TrimSpace(body.Objective)
143: 		if q == "" && len(body.SearchQueries) > 0 {
144: 			q = strings.Join(body.SearchQueries, " ")
145: 		}
146: 		resp, err := h.webSearcher.Search(c, q, body.MaxResults)
147: 		if err != nil {
148: 			return c.Status(http.StatusBadGateway).JSON(map[string]any{
149: 				"error": map[string]any{"message": err.Error(), "type": "search_upstream_error"},
150: 			})
151: 		}
152: 		return c.JSON(resp)
153: 	}
154: 	mode := body.Mode
155: 	if mode == "" {
156: 		mode = h.parallelMode
157: 	}
158: 	req := parallel.SearchRequest{
159: 		Objective:     body.Objective,
160: 		SearchQueries: body.SearchQueries,
161: 		Mode:          mode,
162: 		MaxCharsTotal: body.MaxCharsTotal,
163: 		ClientModel:   body.ClientModel,
164: 		SessionID:     body.SessionID,
165: 	}
166: 	if body.MaxResults > 0 || body.Location != "" || len(body.ExcludeDomains) > 0 {
167: 		req.AdvancedSettings = &parallel.AdvancedSettings{
168: 			Location:     body.Location,
169: 			MaxResults:   body.MaxResults,
170: 			SourcePolicy: &parallel.SourcePolicy{ExcludeDomains: body.ExcludeDomains},
171: 		}
172: 	}
173: 	resp, err := h.parallel.Search(c, req)
174: 	if err != nil {
175: 		return parallelUpstreamError(c, err)
176: 	}
177: 	return c.JSON(resp)
178: }
179: 
180: // ParallelExtract proxies URL fetching through the Parallel Extract API.
181: // Body: {"urls": [..], "objective": str} (up to 20 URLs per call).
182: func (h *handlers) ParallelExtract(c fiber.Ctx) error {
183: 	// Extract has no keyless fallback (DDG backend is search-only).
184: 	if h.parallel == nil || !h.parallel.Enabled() {
185: 		return c.Status(http.StatusServiceUnavailable).JSON(map[string]any{
186: 			"error": map[string]any{"message": "Parallel API key not configured (PARALLEL_API_KEY)", "type": "parallel_not_configured"},
187: 		})
188: 	}
189: 	var body struct {
190: 		URLs      []string `json:"urls"`
191: 		Objective string   `json:"objective"`
192: 		SessionID string   `json:"session_id"`
193: 	}
194: 	if err := json.Unmarshal(c.Body(), &body); err != nil {
195: 		return c.Status(http.StatusBadRequest).JSON(map[string]any{
196: 			"error": map[string]any{"message": "invalid JSON body", "type": "invalid_request_error"},
197: 		})
```

**tool:grep** (completed) sync\.Pool

```
pattern=sync\.Pool; path=/home/x3/freebuff-unified; include=*.go
--- output ---
No files found
```

---

### 🤖 Assistant — 2026-09-12 00:05:17

> Now let me check for goroutine leak patterns, string concatenation in hot paths, and remaining files.

**tool:read** (completed) ../freebuff-unified/internal/stealth/client.go

```
filePath=/home/x3/freebuff-unified/internal/stealth/client.go
--- output ---
<path>/home/x3/freebuff-unified/internal/stealth/client.go</path>
<type>file</type>
<content>
1: package stealth
2: 
3: import (
4: 	"context"
5: 	"net"
6: 	"net/http"
7: 	"time"
8: )
9: 
10: // ClientConfig configures a stealth http.Client.
11: type ClientConfig struct {
12: 	Profile         *Profile
13: 	Timeout         time.Duration
14: 	MaxIdleConns    int
15: 	IdleConnTimeout time.Duration
16: 	EnableJitter    bool
17: 	JitterMin       time.Duration
18: 	JitterMax       time.Duration
19: 	SanitizeHeaders bool
20: 	CustomUserAgent string
21: 	ExtraHeaders    map[string]string
22: 	PreserveHeaders []string
23: 	RoundTripper    http.RoundTripper
24: 	Resolver        func(ctx context.Context, network, addr string) (net.Conn, error)
25: 	ProxyPool       *ProxyPool
26: }
27: 
28: // DefaultClientConfig returns a ClientConfig with sensible defaults.
29: func DefaultClientConfig() *ClientConfig {
30: 	return &ClientConfig{
31: 		Profile:         DefaultProfile,
32: 		Timeout:         180 * time.Second,
33: 		MaxIdleConns:    100,
34: 		IdleConnTimeout: 90 * time.Second,
35: 		EnableJitter:    false,
36: 		SanitizeHeaders: true,
37: 	}
38: }
39: 
40: // NewClient creates a drop-in replacement for http.Client with JA3 stealth.
41: func NewClient(cfg ClientConfig) *http.Client {
42: 	if cfg.Profile == nil {
43: 		cfg.Profile = DefaultProfile
44: 	}
45: 	if cfg.Timeout == 0 {
46: 		cfg.Timeout = 180 * time.Second
47: 	}
48: 	if cfg.MaxIdleConns == 0 {
49: 		cfg.MaxIdleConns = 100
50: 	}
51: 	if cfg.IdleConnTimeout == 0 {
52: 		cfg.IdleConnTimeout = 90 * time.Second
53: 	}
54: 
55: 	var transport http.RoundTripper
56: 
57: 	if cfg.RoundTripper != nil {
58: 		transport = cfg.RoundTripper
59: 	} else {
60: 		transport = &http.Transport{
61: 			DialTLSContext:    Dialer(cfg.Profile, cfg.Resolver, WithProxyPool(cfg.ProxyPool)),
62: 			MaxIdleConns:      cfg.MaxIdleConns,
63: 			IdleConnTimeout:   cfg.IdleConnTimeout,
64: 			ForceAttemptHTTP2: true,
65: 		}
66: 	}
67: 
68: 	if cfg.SanitizeHeaders {
69: 		sanitizerOpts := []HeaderSanitizerOption{}
70: 		if cfg.CustomUserAgent != "" {
71: 			sanitizerOpts = append(sanitizerOpts, WithCustomUserAgent(cfg.CustomUserAgent))
72: 		}
73: 		for k, v := range cfg.ExtraHeaders {
74: 			sanitizerOpts = append(sanitizerOpts, WithExtraHeader(k, v))
75: 		}
76: 		for _, h := range cfg.PreserveHeaders {
77: 			sanitizerOpts = append(sanitizerOpts, PreserveHeader(h))
78: 		}
79: 		sanitizer := NewHeaderSanitizer(cfg.Profile, sanitizerOpts...)
80: 		transport = &HeaderRoundTripper{
81: 			next:      transport,
82: 			sanitizer: sanitizer,
83: 		}
84: 	}
85: 
86: 	if cfg.EnableJitter {
87: 		jitterMin := cfg.JitterMin
88: 		if jitterMin == 0 {
89: 			jitterMin = 50 * time.Millisecond
90: 		}
91: 		jitterMax := cfg.JitterMax
92: 		if jitterMax == 0 {
93: 			jitterMax = 300 * time.Millisecond
94: 		}
95: 		transport = &jitterRoundTripper{
96: 			next:       transport,
97: 			randomizer: NewRandomizer(WithMinDelay(jitterMin), WithMaxDelay(jitterMax)),
98: 		}
99: 	}
100: 
101: 	return &http.Client{
102: 		Transport: transport,
103: 		Timeout:   cfg.Timeout,
104: 	}
105: }
106: 
107: // NewDefaultClient returns a stealth http.Client with Chrome 120 fingerprint.
108: func NewDefaultClient() *http.Client {
109: 	return NewClient(*DefaultClientConfig())
110: }
111: 
112: type HeaderRoundTripper struct {
113: 	next      http.RoundTripper
114: 	sanitizer *HeaderSanitizer
115: }
116: 
117: func (h *HeaderRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
118: 	req2 := req.Clone(req.Context())
119: 	if req2.Header == nil {
120: 		req2.Header = make(http.Header)
121: 	}
122: 	_ = h.sanitizer.Sanitize(req2.Header)
123: 	return h.next.RoundTrip(req2)
124: }
125: 
126: type jitterRoundTripper struct {
127: 	next       http.RoundTripper
128: 	randomizer *Randomizer
129: }
130: 
131: func (j *jitterRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
132: 	j.randomizer.Wait()
133: 	return j.next.RoundTrip(req)
134: }

(End of file - total 134 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/stealth/proxy.go

```
filePath=/home/x3/freebuff-unified/internal/stealth/proxy.go
--- output ---
<path>/home/x3/freebuff-unified/internal/stealth/proxy.go</path>
<type>file</type>
<content>
1: package stealth
2: 
3: import (
4: 	"bytes"
5: 	"context"
6: 	"encoding/json"
7: 	"fmt"
8: 	"io"
9: 	"log"
10: 	"net"
11: 	"net/http"
12: 	"net/url"
13: 	"strings"
14: 	"sync"
15: 	"time"
16: 
17: 	"golang.org/x/net/proxy"
18: )
19: 
20: // ProxyEntry is a single SOCKS5 proxy with credentials.
21: type ProxyEntry struct {
22: 	Host     string    `json:"host"`
23: 	Port     int       `json:"port"`
24: 	User     string    `json:"user,omitempty"`
25: 	Pass     string    `json:"-"`
26: 	Country  string    `json:"country,omitempty"`
27: 	LastUsed time.Time `json:"last_used"`
28: 	Failures int       `json:"failures"`
29: 	Alive    bool      `json:"alive"`
30: }
31: 
32: // URL returns the SOCKS5 URL for this proxy entry.
33: func (p *ProxyEntry) URL() string {
34: 	if p.User != "" {
35: 		return fmt.Sprintf("socks5://%s:%s@%s:%d", p.User, p.Pass, p.Host, p.Port)
36: 	}
37: 	return fmt.Sprintf("socks5://%s:%d", p.Host, p.Port)
38: }
39: 
40: // Dialer returns a proxy.Dialer for this entry.
41: func (p *ProxyEntry) Dialer() (proxy.Dialer, error) {
42: 	u, err := url.Parse(p.URL())
43: 	if err != nil {
44: 		return nil, err
45: 	}
46: 	return proxy.FromURL(u, proxy.Direct)
47: }
48: 
49: // ProxyPool manages a rotating pool of SOCKS5 proxies with background refresh.
50: type ProxyPool struct {
51: 	mu          sync.RWMutex
52: 	proxies     []*ProxyEntry
53: 	current     int
54: 	refreshURL  string
55: 	interval    time.Duration
56: 	strictGeo   bool
57: 	geoVerify   bool
58: 	fetchClient *http.Client
59: }
60: 
61: // ProxyPoolConfig configures a ProxyPool.
62: type ProxyPoolConfig struct {
63: 	RefreshURL      string
64: 	RefreshInterval time.Duration
65: 	StrictGeo       bool
66: 	GeoVerify       bool
67: 	MaxFailures     int
68: }
69: 
70: // NewProxyPool creates a new ProxyPool.
71: func NewProxyPool(cfg ProxyPoolConfig) *ProxyPool {
72: 	if cfg.RefreshInterval <= 0 {
73: 		cfg.RefreshInterval = 30 * time.Minute
74: 	}
75: 	if cfg.MaxFailures <= 0 {
76: 		cfg.MaxFailures = 3
77: 	}
78: 	return &ProxyPool{
79: 		refreshURL: cfg.RefreshURL,
80: 		interval:   cfg.RefreshInterval,
81: 		strictGeo:  cfg.StrictGeo,
82: 		geoVerify:  cfg.GeoVerify,
83: 		fetchClient: &http.Client{
84: 			Timeout: 30 * time.Second,
85: 			Transport: &http.Transport{
86: 				MaxIdleConns:      5,
87: 				IdleConnTimeout:   30 * time.Second,
88: 				DisableKeepAlives: true,
89: 			},
90: 		},
91: 	}
92: }
93: 
94: // Start begins the background refresh goroutine.
95: func (p *ProxyPool) Start(ctx context.Context) {
96: 	if p.refreshURL == "" {
97: 		return
98: 	}
99: 	if err := p.Refresh(ctx); err != nil {
100: 		log.Printf("[proxy-pool] Initial refresh failed: %v", err)
101: 	}
102: 	go func() {
103: 		ticker := time.NewTicker(p.interval)
104: 		defer ticker.Stop()
105: 		for {
106: 			select {
107: 			case <-ctx.Done():
108: 				return
109: 			case <-ticker.C:
110: 				if err := p.Refresh(ctx); err != nil {
111: 					log.Printf("[proxy-pool] Refresh failed: %v", err)
112: 				}
113: 			}
114: 		}
115: 	}()
116: }
117: 
118: // Refresh fetches a fresh proxy list from the configured URL.
119: func (p *ProxyPool) Refresh(ctx context.Context) error {
120: 	if p.refreshURL == "" {
121: 		return nil
122: 	}
123: 
124: 	req, err := http.NewRequestWithContext(ctx, "GET", p.refreshURL, nil)
125: 	if err != nil {
126: 		return fmt.Errorf("fetch proxy list: %w", err)
127: 	}
128: 	resp, err := p.fetchClient.Do(req)
129: 	if err != nil {
130: 		return fmt.Errorf("fetch proxy list: %w", err)
131: 	}
132: 	defer resp.Body.Close()
133: 
134: 	data, err := io.ReadAll(io.LimitReader(resp.Body, 1<<20))
135: 	if err != nil {
136: 		return fmt.Errorf("read proxy list: %w", err)
137: 	}
138: 
139: 	entries := parseProxyList(string(data))
140: 	if len(entries) == 0 {
141: 		if p.strictGeo {
142: 			return fmt.Errorf("proxy pool: empty proxy list with strict_geo enabled")
143: 		}
144: 		return nil
145: 	}
146: 
147: 	if p.geoVerify && p.strictGeo {
148: 		entries = p.geoVerifyProxies(ctx, entries)
149: 		if len(entries) == 0 {
150: 			return fmt.Errorf("proxy pool: no US proxies after geo-verify (strict_geo)")
151: 		}
152: 	}
153: 
154: 	var healthy []*ProxyEntry
155: 	for _, entry := range entries {
156: 		if p.strictGeo && entry.Country != "" && !strings.EqualFold(entry.Country, "US") {
157: 			continue
158: 		}
159: 		if p.healthCheck(entry) {
160: 			entry.Alive = true
161: 			healthy = append(healthy, entry)
162: 		}
163: 	}
164: 
165: 	if len(healthy) == 0 {
166: 		if p.strictGeo {
167: 			return fmt.Errorf("proxy pool: no healthy US proxies after refresh (strict_geo)")
168: 		}
169: 		healthy = entries
170: 		for _, e := range healthy {
171: 			e.Alive = false
172: 		}
173: 	}
174: 
175: 	p.mu.Lock()
176: 	p.proxies = healthy
177: 	p.current = 0
178: 	p.mu.Unlock()
179: 
180: 	log.Printf("[proxy-pool] Refreshed: %d healthy proxies (strict_geo=%v, geo_verify=%v)", len(healthy), p.strictGeo, p.geoVerify)
181: 	return nil
182: }
183: 
184: // Next returns the next healthy proxy in round-robin order.
185: func (p *ProxyPool) Next() *ProxyEntry {
186: 	p.mu.Lock()
187: 	defer p.mu.Unlock()
188: 
189: 	if len(p.proxies) == 0 {
190: 		return nil
191: 	}
192: 
193: 	for i := 0; i < len(p.proxies); i++ {
194: 		entry := p.proxies[p.current]
195: 		p.current = (p.current + 1) % len(p.proxies)
196: 		if entry.Alive && entry.Failures < 3 {
197: 			entry.LastUsed = time.Now()
```

**tool:read** (completed) ../freebuff-unified/internal/config/config.go

```
filePath=/home/x3/freebuff-unified/internal/config/config.go
--- output ---
<path>/home/x3/freebuff-unified/internal/config/config.go</path>
<type>file</type>
<content>
1: package config
2: 
3: import (
4: 	"os"
5: 	"time"
6: 
7: 	"gopkg.in/yaml.v3"
8: )
9: 
10: type Config struct {
11: 	Server    ServerConfig    `yaml:"server"`
12: 	Upstream  UpstreamConfig  `yaml:"upstream"`
13: 	Auth      AuthConfig      `yaml:"auth"`
14: 	Stealth   StealthConfig   `yaml:"stealth"`
15: 	Limits    LimitsConfig    `yaml:"limits"`
16: 	Proxy     ProxyConfig     `yaml:"proxy"`
17: 	Logging   LoggingConfig   `yaml:"logging"`
18: 	Dashboard DashboardConfig `yaml:"dashboard"`
19: 	Hermes    HermesConfig    `yaml:"hermes"`
20: 	Parallel  ParallelConfig  `yaml:"parallel"`
21: 	Research  ResearchConfig  `yaml:"research"`
22: }
23: 
24: // ParallelConfig points at the Parallel Web APIs (search/extract/task/responses).
25: type ParallelConfig struct {
26: 	Enabled bool   `yaml:"enabled"`
27: 	BaseURL string `yaml:"base_url"`
28: 	// APIKey is read from PARALLEL_API_KEY when empty. Optional: Layer A
29: 	// deep-research + /v1/responses work keyless-first and fall back to the
30: 	// native harness when the API rejects a call without a key.
31: 	APIKey string `yaml:"api_key"`
32: 	// DefaultMode for /v1/parallel/search when the caller omits it
33: 	// (turbo|fast|basic|advanced; server default is advanced).
34: 	DefaultMode string `yaml:"default_mode"`
35: 	// DefaultProcessor for Layer A /v1/deep-research Task runs when the
36: 	// caller omits it (default pro-fast).
37: 	DefaultProcessor string `yaml:"default_processor"`
38: }
39: 
40: // HermesConfig points at the hermes stealth sidecar (deps/hermes-service).
41: type HermesConfig struct {
42: 	Enabled bool   `yaml:"enabled"`
43: 	BaseURL string `yaml:"base_url"`
44: }
45: 
46: // ResearchConfig tunes the native /v1/deep-research harness (Layer B): the
47: // gateway LLM plans sub-queries, they fan out to the Parallel Search API and/or
48: // the keyless DDG stealth searcher, the top pages are read, and the LLM
49: // synthesizes a cited markdown report.
50: type ResearchConfig struct {
51: 	// Enabled turns on /v1/deep-research (default true; requires a chat
52: 	// service plus at least one search backend at request time).
53: 	Enabled bool `yaml:"enabled"`
54: 	// Model overrides the LLM used for planning + synthesis (default:
55: 	// upstream default_model).
56: 	Model string `yaml:"model"`
57: 	// MaxQueries caps the planner's sub-query count (default 5).
58: 	MaxQueries int `yaml:"max_queries"`
59: 	// FanOut caps concurrent search+extract workers (default 8).
60: 	FanOut int `yaml:"fan_out"`
61: 	// ExtractPerQuery is how many top results are deep-read per sub-query
62: 	// (default 3).
63: 	ExtractPerQuery int `yaml:"extract_per_query"`
64: 	// TimeoutMS bounds the whole plan→synthesize run (default 300000).
65: 	TimeoutMS int `yaml:"timeout_ms"`
66: }
67: 
68: type ServerConfig struct {
69: 	ListenAddr  string   `yaml:"listen"`
70: 	APIKeys     []string `yaml:"api_keys"`
71: 	AutoApprove bool     `yaml:"auto_approve"`
72: }
73: 
74: type UpstreamConfig struct {
75: 	BaseURL      string `yaml:"base_url"`
76: 	CostMode     string `yaml:"cost_mode"`
77: 	DefaultModel string `yaml:"default_model"`
78: }
79: 
80: type AuthConfig struct {
81: 	APIKeys []string      `yaml:"api_keys"`
82: 	Dir     string        `yaml:"dir"`
83: 	Breaker BreakerConfig `yaml:"breaker"`
84: }
85: 
86: type BreakerConfig struct {
87: 	Threshold int           `yaml:"threshold"`
88: 	Cooldown  time.Duration `yaml:"cooldown"`
89: }
90: 
91: type StealthConfig struct {
92: 	USProxies        []string `yaml:"us_proxies"`
93: 	StripHeaders     bool     `yaml:"strip_headers"`
94: 	Enabled          bool     `yaml:"enabled"`
95: 	Profile          string   `yaml:"profile"`
96: 	ProxyURL         string   `yaml:"proxy_url"`
97: 	ProxyRefreshMins int      `yaml:"proxy_refresh_mins"`
98: 	StrictGeo        bool     `yaml:"strict_geo"`
99: 	GeoVerify        bool     `yaml:"geo_verify"`
100: 	// AutoRefreshPool enables the background refresher that fetches,
101: 	// probes, and hot-swaps the SOCKS5 pool (default false).
102: 	AutoRefreshPool bool `yaml:"auto_refresh_pool"`
103: 	// MaxPoolProxies caps the refreshed pool size (default 12).
104: 	MaxPoolProxies int `yaml:"max_pool_proxies"`
105: }
106: 
107: type LimitsConfig struct {
108: 	GlobalRPM  int `yaml:"global_rpm"`
109: 	AccountRPM int `yaml:"account_rpm"`
110: 	ClientRPM  int `yaml:"client_rpm"`
111: }
112: 
113: type ProxyConfig struct {
114: 	Enabled    bool   `yaml:"enabled"`
115: 	BackendURL string `yaml:"backend_url"`
116: 	// Mode selects how the gateway treats the backend:
117: 	//   "" or "report"      — health reporting only (default; native path serves /v1/*)
118: 	//   "passthrough"       — front-door mode: /v1/* is relayed byte-level to BackendURL
119: 	Mode string `yaml:"mode"`
120: }
121: 
122: // PassthroughEnabled reports whether the front-door passthrough should be
123: // wired (explicit opt-in via mode: passthrough plus a backend URL).
124: func (c *Config) PassthroughEnabled() bool {
125: 	return c.Proxy.Mode == "passthrough" && c.Proxy.BackendURL != ""
126: }
127: 
128: type DashboardConfig struct {
129: 	Enabled bool   `yaml:"enabled"`
130: 	Addr    string `yaml:"addr"`
131: 	Prefix  string `yaml:"prefix"`
132: }
133: 
134: type LoggingConfig struct {
135: 	Level string `yaml:"level"`
136: }
137: 
138: func (c *Config) ApplyDefaults() {
139: 	if c.Server.ListenAddr == "" {
140: 		c.Server.ListenAddr = ":18080"
141: 	}
142: 	if c.Upstream.BaseURL == "" {
143: 		c.Upstream.BaseURL = "https://www.codebuff.com"
144: 	}
145: 	if c.Upstream.CostMode == "" {
146: 		c.Upstream.CostMode = "free"
147: 	}
148: 	if c.Upstream.DefaultModel == "" {
149: 		c.Upstream.DefaultModel = "deepseek/deepseek-v4-pro"
150: 	}
151: 	if c.Auth.Dir == "" {
152: 		c.Auth.Dir = "auths"
153: 	}
154: 	if c.Auth.Breaker.Threshold <= 0 {
155: 		c.Auth.Breaker.Threshold = 3
156: 	}
157: 	if c.Auth.Breaker.Cooldown <= 0 {
158: 		c.Auth.Breaker.Cooldown = 12 * time.Hour
159: 	}
160: 	if c.Limits.GlobalRPM <= 0 {
161: 		c.Limits.GlobalRPM = 120
162: 	}
163: 	if c.Limits.AccountRPM <= 0 {
164: 		c.Limits.AccountRPM = 30
165: 	}
166: 	if c.Limits.ClientRPM <= 0 {
167: 		c.Limits.ClientRPM = 60
168: 	}
169: 	if c.Logging.Level == "" {
170: 		c.Logging.Level = "info"
171: 	}
172: 	if c.Stealth.ProxyRefreshMins <= 0 {
173: 		c.Stealth.ProxyRefreshMins = 30
174: 	}
175: 	if c.Hermes.BaseURL == "" {
176: 		c.Hermes.BaseURL = "http://127.0.0.1:3101"
177: 	}
178: 	if c.Parallel.BaseURL == "" {
179: 		c.Parallel.BaseURL = "https://api.parallel.ai"
180: 	}
181: 	if c.Parallel.DefaultMode == "" {
182: 		c.Parallel.DefaultMode = "fast"
183: 	}
184: 	if c.Parallel.DefaultProcessor == "" {
185: 		c.Parallel.DefaultProcessor = "pro-fast"
186: 	}
187: 	if c.Dashboard.Addr == "" {
188: 		c.Dashboard.Addr = ":9091"
189: 	}
190: 	if c.Dashboard.Prefix == "" {
191: 		c.Dashboard.Prefix = "/dashboard"
192: 	}
193: 	if c.Research.MaxQueries <= 0 {
194: 		c.Research.MaxQueries = 5
195: 	}
196: 	if c.Research.FanOut <= 0 {
197: 		c.Research.FanOut = 8
```

**tool:grep** (completed) go func

```
include=*.go; path=/home/x3/freebuff-unified; pattern=go func
--- output ---
Found 19 matches
/home/x3/freebuff-unified/internal/dashboard/dashboard.go:
  Line 100: 	go func() {

  Line 147: 		go func(t ProxyTarget) {


/home/x3/freebuff-unified/cmd/freebuff/main.go:
  Line 209: 		go func() {

  Line 357: 	go func() {

  Line 717: 	go func() {


/home/x3/freebuff-unified/internal/session/manager.go:
  Line 91: 	go func() {


/home/x3/freebuff-unified/internal/freebuff/client.go:
  Line 324: 	go func() {


/home/x3/freebuff-unified/internal/httpapi/backend_chat.go:
  Line 89: 	go func() {


/home/x3/freebuff-unified/internal/httpapi/handlers.go:
  Line 419: 	go func() {


/home/x3/freebuff-unified/internal/httpapi/chat_service.go:
  Line 93: 	go func() {


/home/x3/freebuff-unified/internal/httpapi/research.go:
  Line 315: 		go func() {

  Line 440: 		go func() {

  Line 652: 	go func() {

  Line 719: 		go func() {

  Line 817: 		go func() {


/home/x3/freebuff-unified/internal/stealth/refresher.go:
  Line 82: 	go func() {

  Line 305: 		go func(c string) {

  Line 324: 	go func() {


/home/x3/freebuff-unified/internal/stealth/proxy.go:
  Line 102: 	go func() {
```

**tool:grep** (completed) strings\.Builder

```
include=*.go; path=/home/x3/freebuff-unified; pattern=strings\.Builder
--- output ---
Found 9 matches
/home/x3/freebuff-unified/internal/httpapi/parallel_handlers_test.go:
  Line 242: 		body := new(strings.Builder)


/home/x3/freebuff-unified/internal/httpapi/passthrough_wiring_test.go:
  Line 58: 	var sb strings.Builder


/home/x3/freebuff-unified/internal/httpapi/research.go:
  Line 318: 				buf := &strings.Builder{}

  Line 331: 			var chunk strings.Builder

  Line 722: 				buf := &strings.Builder{}

  Line 1047: 	var b strings.Builder

  Line 1079: 	var out strings.Builder


/home/x3/freebuff-unified/internal/httpapi/research_test.go:
  Line 94: 	var sb strings.Builder


/home/x3/freebuff-unified/internal/httpapi/backend_chat_test.go:
  Line 87: 	var got strings.Builder
```

**tool:grep** (completed) string\s*\+|string\(.*\)\s*\+

```
include=*.go; path=/home/x3/freebuff-unified; pattern=string\s*\+|string\(.*\)\s*\+
--- output ---
Found 3 matches
/home/x3/freebuff-unified/internal/hermes/client.go:
  Line 203: 	return string(b[:n]) + "...(truncated)"


/home/x3/freebuff-unified/internal/parallel/client.go:
  Line 401: 	return string(b[:n]) + "...(truncated)"


/home/x3/freebuff-unified/internal/httpapi/research.go:
  Line 1141: 	return string(r[:n]) + "…"
```

---

### 🤖 Assistant — 2026-09-12 00:06:11

> Now let me read the remaining key files: backend_chat.go, chat_service.go, serve_stale.go, and a few other files for a complete picture.

**tool:read** (completed) ../freebuff-unified/internal/httpapi/backend_chat.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/backend_chat.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/backend_chat.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"bufio"
5: 	"bytes"
6: 	"context"
7: 	"encoding/json"
8: 	"fmt"
9: 	"io"
10: 	"net/http"
11: 	"strings"
12: 	"time"
13: 
14: 	"freebuff-unified/internal/openai"
15: )
16: 
17: // BackendChatService issues chat requests to the front-door passthrough
18: // backend (/v1/chat/completions). It backs the native Layer B research
19: // planner and the /v1/responses fallback when proxy.mode is "passthrough":
20: // there the backend owns sessions and chat, so the gateway's native freebuff
21: // client (which is not part of that path) must not be used.
22: type BackendChatService struct {
23: 	baseURL string
24: 	apiKey  string
25: 	client  *http.Client
26: }
27: 
28: // NewBackendChatService dials an OpenAI-compatible /v1/chat/completions
29: // backend. apiKey may be empty; the Authorization header is then omitted.
30: func NewBackendChatService(baseURL, apiKey string) *BackendChatService {
31: 	return &BackendChatService{
32: 		baseURL: strings.TrimSuffix(baseURL, "/"),
33: 		apiKey:  apiKey,
34: 		client: &http.Client{
35: 			Transport: &http.Transport{
36: 				// Planner calls carry a 60s ctx timeout; the backend may hold
37: 				// the connection while composing (heartbeat below).
38: 				ResponseHeaderTimeout: 55 * time.Second,
39: 			},
40: 		},
41: 	}
42: }
43: 
44: func (s *BackendChatService) Complete(ctx context.Context, req openai.ChatCompletionRequest) (string, error) {
45: 	body := req
46: 	body.Stream = false
47: 	payload, err := json.Marshal(body)
48: 	if err != nil {
49: 		return "", serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err))
50: 	}
51: 	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, s.baseURL+"/v1/chat/completions", bytes.NewReader(payload))
52: 	if err != nil {
53: 		return "", serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err))
54: 	}
55: 	httpReq.Header.Set("Content-Type", "application/json")
56: 	if s.apiKey != "" {
57: 		httpReq.Header.Set("Authorization", "Bearer "+s.apiKey)
58: 	}
59: 
60: 	resp, err := s.client.Do(httpReq)
61: 	if err != nil {
62: 		return "", serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err))
63: 	}
64: 	defer resp.Body.Close()
65: 
66: 	if resp.StatusCode != http.StatusOK {
67: 		return "", backendChatStatusError(resp)
68: 	}
69: 	var chatResp struct {
70: 		Choices []struct {
71: 			Message struct {
72: 				Content string `json:"content"`
73: 			} `json:"message"`
74: 		} `json:"choices"`
75: 	}
76: 	if err := json.NewDecoder(resp.Body).Decode(&chatResp); err != nil {
77: 		return "", serviceUnavailable("backend_chat_unavailable", "backend chat: invalid JSON response")
78: 	}
79: 	if len(chatResp.Choices) == 0 || strings.TrimSpace(chatResp.Choices[0].Message.Content) == "" {
80: 		return "", serviceUnavailable("backend_chat_unavailable", "backend chat: empty completion")
81: 	}
82: 	return chatResp.Choices[0].Message.Content, nil
83: }
84: 
85: // Stream relays an SSE chat stream from the backend, yielding content deltas.
86: func (s *BackendChatService) Stream(ctx context.Context, req openai.ChatCompletionRequest) (<-chan string, <-chan error) {
87: 	deltas := make(chan string, 16)
88: 	errs := make(chan error, 1)
89: 	go func() {
90: 		defer close(deltas)
91: 		defer close(errs)
92: 
93: 		body := req
94: 		body.Stream = true
95: 		payload, err := json.Marshal(body)
96: 		if err != nil {
97: 			sendStreamError(ctx, errs, serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err)))
98: 			return
99: 		}
100: 		httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, s.baseURL+"/v1/chat/completions", bytes.NewReader(payload))
101: 		if err != nil {
102: 			sendStreamError(ctx, errs, serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err)))
103: 			return
104: 		}
105: 		httpReq.Header.Set("Content-Type", "application/json")
106: 		if s.apiKey != "" {
107: 			httpReq.Header.Set("Authorization", "Bearer "+s.apiKey)
108: 		}
109: 
110: 		resp, err := s.client.Do(httpReq)
111: 		if err != nil {
112: 			sendStreamError(ctx, errs, serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err)))
113: 			return
114: 		}
115: 		defer resp.Body.Close()
116: 
117: 		if resp.StatusCode != http.StatusOK {
118: 			sendStreamError(ctx, errs, backendChatStatusError(resp))
119: 			return
120: 		}
121: 
122: 		scanner := bufio.NewScanner(resp.Body)
123: 		scanner.Buffer(make([]byte, 4096), 1<<20)
124: 		for scanner.Scan() {
125: 			line := scanner.Text()
126: 			if !strings.HasPrefix(line, "data:") {
127: 				continue
128: 			}
129: 			data := strings.TrimSpace(strings.TrimPrefix(line, "data:"))
130: 			if data == "[DONE]" {
131: 				return
132: 			}
133: 			var chunk struct {
134: 				Choices []struct {
135: 					Delta struct {
136: 						Content string `json:"content"`
137: 					} `json:"delta"`
138: 				} `json:"choices"`
139: 			}
140: 			if json.Unmarshal([]byte(data), &chunk) != nil || len(chunk.Choices) == 0 {
141: 				continue
142: 			}
143: 			if delta := chunk.Choices[0].Delta.Content; delta != "" {
144: 				select {
145: 				case deltas <- delta:
146: 				case <-ctx.Done():
147: 					return
148: 				}
149: 			}
150: 		}
151: 		if err := scanner.Err(); err != nil && ctx.Err() == nil {
152: 			sendStreamError(ctx, errs, serviceUnavailable("backend_chat_unavailable", fmt.Sprintf("backend chat: %v", err)))
153: 		}
154: 	}()
155: 	return deltas, errs
156: }
157: 
158: // backendChatStatusError maps a non-200 backend reply to a ServiceError.
159: func backendChatStatusError(resp *http.Response) error {
160: 	msg := fmt.Sprintf("backend chat: %s", resp.Status)
161: 	var payload struct {
162: 		Error *struct {
163: 			Message string `json:"message"`
164: 		} `json:"error"`
165: 	}
166: 	if b, _ := io.ReadAll(resp.Body); len(b) > 0 && json.Unmarshal(b, &payload) == nil && payload.Error != nil && payload.Error.Message != "" {
167: 		msg = payload.Error.Message
168: 	}
169: 	switch {
170: 	case resp.StatusCode == http.StatusTooManyRequests:
171: 		return &ServiceError{Status: http.StatusTooManyRequests, Code: "rate_limit_exceeded", Message: msg}
172: 	case resp.StatusCode >= http.StatusInternalServerError:
173: 		return &ServiceError{Status: http.StatusServiceUnavailable, Code: "backend_chat_unavailable", Message: msg}
174: 	default:
175: 		return &ServiceError{Status: resp.StatusCode, Code: "backend_chat_error", Message: msg}
176: 	}
177: }

(End of file - total 177 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/chat_service.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/chat_service.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/chat_service.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"context"
5: 	"errors"
6: 	"fmt"
7: 	"net/http"
8: 
9: 	"freebuff-unified/internal/credentials"
10: 	"freebuff-unified/internal/freebuff"
11: 	"freebuff-unified/internal/openai"
12: 	"freebuff-unified/internal/session"
13: )
14: 
15: // SessionEnsurer ensures a Freebuff session is active before chat.
16: type SessionEnsurer interface {
17: 	EnsureActive(ctx context.Context, model string) (freebuff.Session, error)
18: }
19: 
20: // CredentialStore loads the Freebuff auth token.
21: type CredentialStore interface {
22: 	Load(ctx context.Context) (credentials.Credential, error)
23: }
24: 
25: // UpstreamChatClient sends chat requests to the Freebuff upstream.
26: type UpstreamChatClient interface {
27: 	Complete(ctx context.Context, token string, activeSession freebuff.Session, model string, messages []freebuff.ChatMessage) (string, error)
28: 	Stream(ctx context.Context, token string, activeSession freebuff.Session, model string, messages []freebuff.ChatMessage) (<-chan string, <-chan error)
29: }
30: 
31: // FreebuffChatService wires credential store, session manager, and upstream client.
32: type FreebuffChatService struct {
33: 	Store    CredentialStore
34: 	Sessions SessionEnsurer
35: 	Upstream UpstreamChatClient
36: }
37: 
38: func (s FreebuffChatService) Complete(ctx context.Context, req openai.ChatCompletionRequest) (string, error) {
39: 	if err := s.validate(); err != nil {
40: 		return "", err
41: 	}
42: 
43: 	activeSession, err := s.Sessions.EnsureActive(ctx, freebuff.CanonicalModelName(req.Model))
44: 	if err != nil {
45: 		return "", normalizeSessionSetupError(err)
46: 	}
47: 
48: 	cred, err := s.Store.Load(ctx)
49: 	if err != nil {
50: 		return "", fmt.Errorf("load freebuff credentials: %w", err)
51: 	}
52: 
53: 	messages := toFreebuffMessages(req.Messages)
54: 
55: 	text, err := s.Upstream.Complete(ctx, cred.AuthToken, activeSession, freebuff.CanonicalModelName(req.Model), messages)
56: 	if err != nil {
57: 		return "", normalizeUpstreamChatError(err)
58: 	}
59: 
60: 	return text, nil
61: }
62: 
63: func (s FreebuffChatService) Stream(ctx context.Context, req openai.ChatCompletionRequest) (<-chan string, <-chan error) {
64: 	if err := s.validate(); err != nil {
65: 		return failedStream(err)
66: 	}
67: 
68: 	activeSession, err := s.Sessions.EnsureActive(ctx, freebuff.CanonicalModelName(req.Model))
69: 	if err != nil {
70: 		return failedStream(normalizeSessionSetupError(err))
71: 	}
72: 
73: 	cred, err := s.Store.Load(ctx)
74: 	if err != nil {
75: 		return failedStream(fmt.Errorf("load freebuff credentials: %w", err))
76: 	}
77: 
78: 	streamCtx, cancel := context.WithCancel(ctx)
79: 	upstreamDeltas, upstreamErrs := s.Upstream.Stream(streamCtx, cred.AuthToken, activeSession, freebuff.CanonicalModelName(req.Model), toFreebuffMessages(req.Messages))
80: 	if upstreamDeltas == nil && upstreamErrs == nil {
81: 		cancel()
82: 		return failedStream(serviceUnavailable("upstream_chat_unavailable", "Upstream chat stream did not return channels"))
83: 	}
84: 
85: 	start, err := inspectStreamStart(upstreamDeltas, upstreamErrs)
86: 	if err != nil {
87: 		cancel()
88: 		return failedStream(normalizeUpstreamChatError(err))
89: 	}
90: 
91: 	deltas := make(chan string)
92: 	errs := make(chan error, 1)
93: 	go func() {
94: 		defer cancel()
95: 		defer close(deltas)
96: 		defer close(errs)
97: 
98: 		if start.hasFirstDelta && !sendStreamDelta(streamCtx, deltas, start.firstDelta) {
99: 			return
100: 		}
101: 		if start.firstErr != nil && !sendStreamError(streamCtx, errs, normalizeUpstreamChatError(start.firstErr)) {
102: 			return
103: 		}
104: 
105: 		forwardStream(streamCtx, deltas, errs, start.deltas, start.errs)
106: 	}()
107: 
108: 	return deltas, errs
109: }
110: 
111: func (s FreebuffChatService) validate() error {
112: 	if s.Sessions == nil {
113: 		return serviceUnavailable("session_manager_unavailable", "Freebuff session manager not configured")
114: 	}
115: 	if s.Store == nil {
116: 		return serviceUnavailable("credential_store_unavailable", "Freebuff credential store not configured")
117: 	}
118: 	if s.Upstream == nil {
119: 		return serviceUnavailable("upstream_chat_unavailable", "Freebuff upstream chat client not configured")
120: 	}
121: 	return nil
122: }
123: 
124: type streamStart struct {
125: 	deltas        <-chan string
126: 	errs          <-chan error
127: 	firstDelta    string
128: 	hasFirstDelta bool
129: 	firstErr      error
130: }
131: 
132: func failedStream(err error) (<-chan string, <-chan error) {
133: 	deltas := make(chan string)
134: 	close(deltas)
135: 	errs := make(chan error, 1)
136: 	if err != nil {
137: 		errs <- err
138: 	}
139: 	close(errs)
140: 	return deltas, errs
141: }
142: 
143: func inspectStreamStart(upstreamDeltas <-chan string, upstreamErrs <-chan error) (streamStart, error) {
144: 	start := streamStart{deltas: upstreamDeltas, errs: upstreamErrs}
145: 	if upstreamErrs == nil {
146: 		return start, nil
147: 	}
148: 
149: 	select {
150: 	case err, ok := <-upstreamErrs:
151: 		if !ok {
152: 			start.errs = nil
153: 			return start, nil
154: 		}
155: 		if err == nil {
156: 			return start, nil
157: 		}
158: 		if upstreamDeltas == nil {
159: 			return start, err
160: 		}
161: 
162: 		select {
163: 		case delta, ok := <-upstreamDeltas:
164: 			if !ok {
165: 				return start, err
166: 			}
167: 			start.firstDelta = delta
168: 			start.hasFirstDelta = true
169: 			start.firstErr = err
170: 			return start, nil
171: 		default:
172: 			return start, err
173: 		}
174: 	default:
175: 		return start, nil
176: 	}
177: }
178: 
179: func serviceUnavailable(code string, message string) *ServiceError {
180: 	return &ServiceError{Status: http.StatusServiceUnavailable, Code: code, Message: message}
181: }
182: 
183: func normalizeSessionSetupError(err error) error {
184: 	if err == nil {
185: 		return nil
186: 	}
187: 
188: 	wrapped := fmt.Errorf("ensure freebuff session active: %w", err)
189: 
190: 	var serviceErr *ServiceError
191: 	if errors.As(wrapped, &serviceErr) {
192: 		return serviceErr
193: 	}
194: 
195: 	var apiErr *freebuff.APIError
196: 	if errors.As(wrapped, &apiErr) {
197: 		return sanitizedFreebuffAPIError(apiErr)
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/serve_stale.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/serve_stale.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/serve_stale.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"sync"
5: 	"time"
6: )
7: 
8: // ServeStaleCache wraps a status builder so expensive status endpoints
9: // (/ai-stack/status) serve a cached payload for ttl instead of rebuilding —
10: // and re-probing hermes, the proxy backend, and peers — on every request.
11: //
12: // Within the TTL the cached map is returned; on a failed rebuild (nil result)
13: // the last good payload is served (serve-stale semantics). The cached map is
14: // treated as read-only by callers (Fiber serializes JSON rendering).
15: func ServeStaleCache(build func() map[string]any) func() map[string]any {
16: 	return ServeStaleCacheWithTTL(build, 5*time.Second)
17: }
18: 
19: // ServeStaleCacheWithTTL is ServeStaleCache with an explicit TTL. A nil build
20: // function yields a provider that always returns nil.
21: func ServeStaleCacheWithTTL(build func() map[string]any, ttl time.Duration) func() map[string]any {
22: 	if build == nil {
23: 		return func() map[string]any { return nil }
24: 	}
25: 	if ttl <= 0 {
26: 		ttl = 5 * time.Second
27: 	}
28: 	var (
29: 		mu      sync.RWMutex
30: 		payload map[string]any
31: 		builtAt time.Time
32: 	)
33: 	return func() map[string]any {
34: 		mu.RLock()
35: 		p, at := payload, builtAt
36: 		mu.RUnlock()
37: 		if p != nil && time.Since(at) < ttl {
38: 			return p
39: 		}
40: 		fresh := build()
41: 		mu.Lock()
42: 		if fresh != nil {
43: 			payload, builtAt = fresh, time.Now()
44: 		}
45: 		mu.Unlock()
46: 		if fresh == nil {
47: 			return p // rebuild failed: serve last good payload
48: 		}
49: 		return fresh
50: 	}
51: }

(End of file - total 51 lines)
</content>
```

**tool:read** (completed) ../freebuff-unified/internal/httpapi/research_test.go

```
filePath=/home/x3/freebuff-unified/internal/httpapi/research_test.go
--- output ---
<path>/home/x3/freebuff-unified/internal/httpapi/research_test.go</path>
<type>file</type>
<content>
1: package httpapi
2: 
3: import (
4: 	"encoding/json"
5: 	"fmt"
6: 	"net/http"
7: 	"net/http/httptest"
8: 	"strings"
9: 	"testing"
10: 
11: 	"github.com/gofiber/fiber/v3"
12: 
13: 	"freebuff-unified/internal/parallel"
14: )
15: 
16: // fakeParallelAPI is an in-process Parallel API used to exercise the Layer A
17: // Task-run endpoints and the keyed native search/extract paths. createFail
18: // makes POST /v1/tasks/runs return 401 so DeepResearch falls back to Layer B.
19: type fakeParallelAPI struct {
20: 	createFail bool
21: 	createHits int
22: }
23: 
24: func (f *fakeParallelAPI) ServeHTTP(w http.ResponseWriter, r *http.Request) {
25: 	switch {
26: 	case r.Method == http.MethodPost && r.URL.Path == "/v1/tasks/runs":
27: 		f.createHits++
28: 		if f.createFail {
29: 			w.WriteHeader(http.StatusUnauthorized)
30: 			fmt.Fprintln(w, `{"error":{"message":"api key required"}}`)
31: 			return
32: 		}
33: 		w.Header().Set("Content-Type", "application/json")
34: 		fmt.Fprint(w, `{"run_id":"run-1","interaction_id":"int-1","status":"queued","processor":"pro-fast"}`)
35: 
36: 	case r.Method == http.MethodGet && r.URL.Path == "/v1/tasks/runs/run-1":
37: 		w.Header().Set("Content-Type", "application/json")
38: 		fmt.Fprint(w, `{"run_id":"run-1","interaction_id":"int-1","status":"completed","processor":"pro-fast"}`)
39: 
40: 	case r.Method == http.MethodGet && r.URL.Path == "/v1/tasks/runs/run-1/result":
41: 		w.Header().Set("Content-Type", "application/json")
42: 		fmt.Fprint(w, `{"run_id":"run-1","status":"completed","output":{"content":"# Result\n\nBody text","basis":[{"field":"x","value":"y"}]}}`)
43: 
44: 	case r.Method == http.MethodGet && r.URL.Path == "/v1/tasks/runs/run-1/events":
45: 		w.Header().Set("Content-Type", "text/event-stream")
46: 		fmt.Fprint(w, "data: {\"type\":\"task.update\",\"status\":\"completed\"}\n\n")
47: 
48: 	case r.Method == http.MethodPost && r.URL.Path == "/v1/search":
49: 		w.Header().Set("Content-Type", "application/json")
50: 		fmt.Fprint(w, `{"search_id":"s1","session_id":"deep-research","results":[{"title":"Parallel Docs","url":"https://example.com/1","excerpts":["Snippet one"]}]}`)
51: 
52: 	case r.Method == http.MethodPost && r.URL.Path == "/v1/extract":
53: 		w.Header().Set("Content-Type", "application/json")
54: 		fmt.Fprint(w, `{"extract_id":"e1","results":[{"title":"Parallel Docs","url":"https://example.com/1","full_content":"Page content for synthesis."}]}`)
55: 
56: 	case r.Method == http.MethodPost && r.URL.Path == "/v1/responses":
57: 		w.Header().Set("Content-Type", "application/json")
58: 		fmt.Fprint(w, `{"id":"resp_upstream","object":"response","status":"completed"}`)
59: 
60: 	default:
61: 		http.NotFound(w, r)
62: 	}
63: }
64: 
65: // researchApp wires a keyed Parallel client pointing at fake through the real
66: // NewApp with native Layer B research enabled.
67: func researchApp(t *testing.T, fake *fakeParallelAPI) *fiber.App {
68: 	t.Helper()
69: 	ts := httptest.NewServer(fake)
70: 	t.Cleanup(ts.Close)
71: 	return NewApp(Options{
72: 		Model:             "test-model",
73: 		ProxyAPIKey:       "k",
74: 		Chat:              okChatService{},
75: 		Parallel:          parallel.New(ts.URL, "test-key"),
76: 		ParallelMode:      "fast",
77: 		ParallelProcessor: "pro-fast",
78: 		Research: ResearchConfig{
79: 			Enabled:         true,
80: 			MaxQueries:      2,
81: 			FanOut:          2,
82: 			ExtractPerQuery: 1,
83: 		},
84: 	})
85: }
86: 
87: // postDeepResearch posts a JSON body to /v1/deep-research as an authed client.
88: func postDeepResearch(t *testing.T, app *fiber.App, body string) (int, string) {
89: 	t.Helper()
90: 	var m map[string]any
91: 	if err := json.Unmarshal([]byte(body), &m); err != nil {
92: 		t.Fatalf("test body %q is not valid JSON: %v", body, err)
93: 	}
94: 	var sb strings.Builder
95: 	sb.WriteString(body)
96: 	req := httptest.NewRequest(http.MethodPost, "/v1/deep-research", strings.NewReader(sb.String()))
97: 	req.Header.Set("Content-Type", "application/json")
98: 	req.Header.Set("Authorization", "Bearer k")
99: 	return doRequest(t, app, req)
100: }
101: 
102: func mustContain(t *testing.T, body, substr string) {
103: 	t.Helper()
104: 	if !strings.Contains(body, substr) {
105: 		t.Fatalf("response body does not contain %q:\n%s", substr, body)
106: 	}
107: }
108: 
109: // ---------------------------------------------------------------------------
110: // Layer A: Task-run orchestration
111: // ---------------------------------------------------------------------------
112: 
113: func TestDeepResearchLayerACreate202(t *testing.T) {
114: 	app := researchApp(t, &fakeParallelAPI{})
115: 	status, body := postDeepResearch(t, app, `{"input":"top LLM inference engines","stream":false}`)
116: 	if status != http.StatusAccepted {
117: 		t.Fatalf("status = %d, want 202", status)
118: 	}
119: 	mustContain(t, body, `"run_id":"run-1"`)
120: 	mustContain(t, body, `"backend":"parallel"`)
121: 	mustContain(t, body, `"processor":"pro-fast"`)
122: 	mustContain(t, body, `"result_url":"/v1/deep-research/run-1"`)
123: }
124: 
125: func TestDeepResearchLayerAGetStatusAndResult(t *testing.T) {
126: 	app := researchApp(t, &fakeParallelAPI{})
127: 	req := httptest.NewRequest(http.MethodGet, "/v1/deep-research/run-1", nil)
128: 	req.Header.Set("Authorization", "Bearer k")
129: 	status, body := doRequest(t, app, req)
130: 	if status != http.StatusOK {
131: 		t.Fatalf("status = %d, want 200", status)
132: 	}
133: 	m := decodeBody(t, body)
134: 	if m["result"] == nil && m["error"] != nil {
135: 		t.Fatalf("error result payload: %v", m)
136: 	}
137: 	if m["backend"] != "parallel" {
138: 		t.Errorf("backend = %v, want parallel", m["backend"])
139: 	}
140: 	if m["status"] != "completed" {
141: 		t.Errorf("status = %v, want completed", m["status"])
142: 	}
143: 	if res, ok := m["result"].(map[string]any); !ok {
144: 		t.Errorf("result payload missing: %v", m["result"])
145: 	} else if out, ok := res["output"].(map[string]any); !ok || out["content"] == nil {
146: 		t.Errorf("result.output.content missing: %v", m["result"])
147: 	}
148: }
149: 
150: func TestDeepResearchLayerAStreamRelaysEvents(t *testing.T) {
151: 	app := researchApp(t, &fakeParallelAPI{})
152: 	status, body := postDeepResearch(t, app, `{"input":"top LLM inference engines","stream":true}`)
153: 	if status != http.StatusOK {
154: 		t.Fatalf("status = %d, want 200", status)
155: 	}
156: 	mustContain(t, body, `"type":"task.update"`)
157: 	mustContain(t, body, `"type":"done"`)
158: 	mustContain(t, body, `"content":"# Result`)
159: }
160: 
161: // ---------------------------------------------------------------------------
162: // Layer B: native fallback on keyless/auth rejection
163: // ---------------------------------------------------------------------------
164: 
165: func TestDeepResearchKeylessFallbackBuffered(t *testing.T) {
166: 	fake := &fakeParallelAPI{createFail: true}
167: 	app := researchApp(t, fake)
168: 	status, body := postDeepResearch(t, app, `{"input":"top LLM inference engines","stream":false}`)
169: 	if status != http.StatusOK {
170: 		t.Fatalf("status = %d, want 200 (buffered native), body=%s", status, body)
171: 	}
172: 	m := decodeBody(t, body)
173: 	if m["report"] != "ok" {
174: 		t.Errorf("report = %v, want ok (chat service output)", m["report"])
175: 	}
176: 	if fake.createHits == 0 {
177: 		t.Error("Layer A create was never attempted")
178: 	}
179: }
180: 
181: func TestDeepResearchKeylessFallbackStream(t *testing.T) {
182: 	// Reproduces the streaming path (plan → search/extract → synthesis frames)
183: 	// that previously returned an empty body.
184: 	fake := &fakeParallelAPI{createFail: true}
185: 	app := researchApp(t, fake)
186: 	status, body := postDeepResearch(t, app, `{"input":"top LLM inference engines","stream":true,"max_queries":2,"fan_out":2,"extract_per_query":1}`)
187: 	if status != http.StatusOK {
188: 		t.Fatalf("status = %d, want 200, body=%s", status, body)
189: 	}
190: 	mustContain(t, body, `"type":"plan"`)
191: 	mustContain(t, body, `"type":"synthesis"`)
192: 	mustContain(t, body, `"type":"done"`)
193: 	mustContain(t, body, `"report":"ok"`)
194: }
195: 
196: // ---------------------------------------------------------------------------
197: // Guards
```

---

### 🤖 Assistant — 2026-09-12 00:06:46

> Now I have a thorough picture. Let me also check for goroutine leak patterns — specifically goroutines that spawn without proper context cancellation cleanup. Let me look at the key goroutine-spawning locations more carefully, and also check for any potential leak in the research.go fan-out pattern.

Now let me check a couple more things for completeness:

**tool:grep** (completed) fmt\.Sprintf\(.*string\(

```
include=*.go; path=/home/x3/freebuff-unified; pattern=fmt\.Sprintf\(.*string\(
--- output ---
Found 1 matches
/home/x3/freebuff-unified/internal/httpapi/research.go:
  Line 309: 			_ = writeSSE(w, map[string]any{"type": "error", "message": fmt.Sprintf("events http %d: %s", resp.StatusCode, truncate(string(b), 400))})
```

**tool:read** (completed) ../freebuff-unified/internal/stealth/refresher.go

```
filePath=/home/x3/freebuff-unified/internal/stealth/refresher.go
--- output ---
<path>/home/x3/freebuff-unified/internal/stealth/refresher.go</path>
<type>file</type>
<content>
1: package stealth
2: 
3: import (
4: 	"context"
5: 	"encoding/json"
6: 	"fmt"
7: 	"io"
8: 	"log"
9: 	"math/rand"
10: 	"net/http"
11: 	"sort"
12: 	"strings"
13: 	"sync"
14: 	"time"
15: 
16: 	"freebuff-unified/internal/hermes"
17: )
18: 
19: // Refresher periodically fetches SOCKS5 proxy candidates from public
20: // sources, tests them end-to-end through the hermes sidecar (the same SOCKS5
21: // handshake path production traffic uses), and hot-swaps the USProxyPool
22: // with the alive set.
23: type Refresher struct {
24: 	pool      *USProxyPool
25: 	sidecar   *hermes.Client
26: 	logger    *log.Logger
27: 	geofilter string // "us" filters to US egress via ipapi.co country code
28: 	maxProbes int    // cap on candidates tested per cycle
29: 
30: 	// RefreshInterval is how often the pool is refreshed (default 30m).
31: 	RefreshInterval time.Duration
32: 	// ProbeTimeout caps a single candidate probe (default 12s).
33: 	ProbeTimeout time.Duration
34: 	// Concurrency is how many probes run at once. All probes share the one
35: 	// single-threaded sidecar process, so high values inflate per-probe
36: 	// latency and cause mass timeouts (default 6).
37: 	Concurrency int
38: 	// MaxProxies keeps the pool at this size (default 12).
39: 	MaxProxies int
40: 	// OnEgress, when set, is called with the egress IP of every successful
41: 	// probe (feeds the /stealth/status egress-ip metrics).
42: 	OnEgress func(ip string)
43: 	// fetchFn is injectable for tests; nil means use fetchCandidates.
44: 	fetchFn func() ([]string, int)
45: 	// sourceURLs overrides Sources() when non-nil (test hook).
46: 	sourceURLs []string
47: 	// sourceCounts tracks candidates per source (filled by fetchCandidates,
48: 	// merged into the cycle report by Refresh).
49: 	sourceCounts map[string]int
50: 
51: 	// lastCycle records the outcome of the most recent refresh for status.
52: 	mu         sync.Mutex
53: 	lastCycle  map[string]any
54: 	lastRun    time.Time
55: 	lastHadErr bool
56: }
57: 
58: // NewRefresher builds a pool refresher. sidecar may be nil, in which case
59: // probes go direct (plain HTTP CONNECT-less check) — not recommended.
60: // Defaults are tuned to avoid starving the single-threaded hermes sidecar:
61: // Concurrency 2 + ProbeTimeout 8s keeps p95 sidecar latency low so foreground
62: // queries don't hit 5m abort; increase via struct fields after construction
63: // if a dedicated second hermes on :3102 is used.
64: func NewRefresher(pool *USProxyPool, sidecar *hermes.Client, logger *log.Logger) *Refresher {
65: 	return &Refresher{
66: 		pool:            pool,
67: 		sidecar:         sidecar,
68: 		logger:          logger,
69: 		geofilter:       "us",
70: 		maxProbes:       150,
71: 		RefreshInterval: 30 * time.Minute,
72: 		ProbeTimeout:    8 * time.Second,
73: 		Concurrency:     2,
74: 		MaxProxies:      12,
75: 	}
76: }
77: 
78: // Start launches the background refresh loop; it runs an initial refresh
79: // after a short startup delay. Returns a stop function.
80: func (r *Refresher) Start(ctx context.Context) func() {
81: 	done := make(chan struct{})
82: 	go func() {
83: 		// Initial refresh after 20s so boot isn't blocked on probing.
84: 		select {
85: 		case <-time.After(20 * time.Second):
86: 			r.Refresh(ctx)
87: 		case <-done:
88: 			return
89: 		}
90: 		t := time.NewTicker(r.RefreshInterval)
91: 		defer t.Stop()
92: 		for {
93: 			select {
94: 			case <-t.C:
95: 				r.Refresh(ctx)
96: 			case <-done:
97: 				return
98: 			}
99: 		}
100: 	}()
101: 	return func() { close(done) }
102: }
103: 
104: // Status reports the last refresh cycle for /stealth/status.
105: func (r *Refresher) Status() map[string]any {
106: 	if r == nil {
107: 		return nil
108: 	}
109: 	r.mu.Lock()
110: 	defer r.mu.Unlock()
111: 	out := map[string]any{
112: 		"interval_mins": int(r.RefreshInterval.Minutes()),
113: 	}
114: 	if r.lastRun.IsZero() {
115: 		out["last_run"] = nil
116: 		out["state"] = "pending"
117: 		return out
118: 	}
119: 	out["last_run"] = r.lastRun.UTC().Format(time.RFC3339)
120: 	out["state"] = "ok"
121: 	if r.lastHadErr {
122: 		out["state"] = "partial_errors"
123: 	}
124: 	for k, v := range r.lastCycle {
125: 		out[k] = v
126: 	}
127: 	return out
128: }
129: 
130: // Sources returns the candidate sources (mirrors scripts/fetch-proxies.sh).
131: func (r *Refresher) Sources() []string {
132: 	return []string{
133: 		"https://cdn.jsdelivr.net/gh/proxifly/free-proxy-list@main/proxies/protocols/socks5/data.txt",
134: 		"https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=protocolipport&format=text&protocol=socks5&country=us&timeout=5000",
135: 		"https://raw.githubusercontent.com/mohammedcha/ProxRipper/main/full_proxies/socks5.txt",
136: 		"https://raw.githubusercontent.com/monosans/proxy-list/main/proxies/socks5.txt",
137: 		"https://raw.githubusercontent.com/hookzof/socks5_list/master/proxy.txt",
138: 	}
139: }
140: 
141: // perSourceCap bounds how many candidates each source may contribute.
142: // Without it, one huge low-quality dump (e.g. 150k-line lists that are
143: // mostly HTTP proxies) dominates the probe sample and starves the good
144: // sources.
145: const perSourceCap = 50
146: 
147: // fetchCandidates downloads and dedupes proxy candidates from all sources.
148: // Accepts "host:port" and "socks5://host:port" lines. Each source
149: // contributes at most perSourceCap evenly-sampled entries.
150: func (r *Refresher) fetchCandidates() ([]string, int) {
151: 	sources := r.sourceURLs
152: 	if sources == nil {
153: 		sources = r.Sources()
154: 	}
155: 	client := &http.Client{Timeout: 20 * time.Second}
156: 	seen := map[string]struct{}{}
157: 	var out []string
158: 	sourcesErr := 0
159: 	for _, src := range sources {
160: 		resp, err := client.Get(src)
161: 		if err != nil {
162: 			sourcesErr++
163: 			continue
164: 		}
165: 		body, err := io.ReadAll(io.LimitReader(resp.Body, 4<<20))
166: 		resp.Body.Close()
167: 		if err != nil || resp.StatusCode != http.StatusOK {
168: 			sourcesErr++
169: 			continue
170: 		}
171: 		// Per-source candidate tracking lets /stealth/status attribute which
172: 		// sources yield working SOCKS5 (some lists are HTTP-polluted).
173: 		var srcLines []string
174: 		countHere := 0
175: 		for _, line := range strings.Split(string(body), "\n") {
176: 			line = strings.TrimSpace(line)
177: 			if line == "" || strings.HasPrefix(line, "#") {
178: 				continue
179: 			}
180: 			line = strings.TrimPrefix(line, "socks5://")
181: 			line = strings.TrimPrefix(line, "socks5h://")
182: 			if !strings.Contains(line, ":") {
183: 				continue
184: 			}
185: 			// Reject junk entries (e.g. 0.0.0.0, private nets).
186: 			host := line[:strings.Index(line, ":")]
187: 			if host == "0.0.0.0" || strings.HasPrefix(host, "10.") ||
188: 				strings.HasPrefix(host, "192.168.") || strings.HasPrefix(host, "127.") {
189: 				continue
190: 			}
191: 			if _, dup := seen[line]; dup {
192: 				continue
193: 			}
194: 			seen[line] = struct{}{}
195: 			srcLines = append(srcLines, line)
196: 			countHere++
197: 		}
```

---

### 🤖 Assistant — 2026-09-12 00:07:19

> Now I have a comprehensive understanding of the entire codebase. Let me compile the audit report.

**tool:todowrite** (completed) 2 todos

```
todos=[{'content': 'Map codebase structure and file inventory', 'priority': 'high', 's
--- output ---
[
  {
    "content": "Map codebase structure and file inventory",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Audit internal/websearch/ — DDG stealth search",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Audit internal/parallel/ — Parallel API client",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Audit internal/httpapi/research.go — deep-research orchestrator",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Audit internal/proxy/ — passthrough handler, proxy pool",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Cross-cutting: go.mod deps, sync.Pool, goroutine leaks, string concat hot paths",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Compile final report with file:line references",
    "status": "in_progress",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-12 00:07:50

> Compiling final audit report now. All data collected.

# Performance Audit — freebuff-unified

## 1. internal/websearch/ — DDG stealth search

### Files
| File | Lines |
|---|---|
| `/home/x3/freebuff-unified/internal/websearch/ddg.go` | 265 |
| `/home/x3/freebuff-unified/internal/websearch/ddg_test.go` | 66 |

### Structs / Interfaces
- `Result` — `ddg.go:21-26`: Title, URL, Snippet, Excerpts []string.
- `Response` — `ddg.go:29-34`: Query, Backend, Results, LatencyMS.
- `Searcher` — `ddg.go:37-43`: `sidecar *hermes.Client`, `Proxy func() string` (declared, **never used** — dead field), `Timeout time.Duration`.

### Concurrency
- **None.** Search is strictly sequential: `fetchDDG` loops endpoints serially (`ddg.go:116-140`), context timeout per attempt (`ddg.go:117`), `cancel()` called immediately after Fetch returns (`ddg.go:126`). No goroutines, no channels, no mutexes.

### Memory Allocation
- **Regex on full HTML body**: 8 compiled regexes (`ddg.go:52-74`), each `FindAllStringSubmatch` allocates `[][]string`. `parseResults` allocates `out []Result` uninitialized, grows by append (`ddg.go:145`).
- **Regression chain**: `cleanPageText` (`ddg.go:240-247`) does N+2 full-string rewrites in sequence — 9 block-tag regex replaces (script/style/noscript/svg/head/nav/footer/aside/header, `ddg.go:68-74`) each allocate a full copy of the page, then `stripTags` copy, then whitespace collapse copy. A 1MB HTML page → ~11 full copies → ~11MB transient allocation per FetchPage.
- **Byte→string →byte boxing**: `resp.Text()` returns `string(v)` copy from `json.RawMessage` (`hermes/client.go:186-197`, `ddg.go:220`).
- **No buffer reuse, no sync.Pool** anywhere in package.
- Cap `maxPageChars = 16_000` at `ddg.go:78`, applied `ddg.go:222-224`.

### HTTP Client / Transport
- No own http.Client. Delegates to hermes sidecar (`hermes.Client`, `client.go:26-31`: `http.Client{Timeout: 60s}`, **default Transport** — keeps alive, but no response-header timeout).
- Two-step retry chain: html endpoint then lite endpoint (`ddg.go:111-114`); any 200 with markup marker accepted, else fail-over (`ddg.go:127-139`).
- Per-fetch timeout: default 12s (`ddg.go:47`, `ddg.go:108-110`).

### Error Handling / Retries
- Endpoint fallback chain `ddg.go:116-140`: html → lite. Bot-challenge detection: body without `result__a`/`result-link` → treated as failure (`ddg.go:129-134`). Both fail → wrapped `"all ddg endpoints failed"` (`ddg.go:141`).
- No backoff, no retry count beyond the 2 endpoints.

### Caching
- **None.** Every Search hits DDG fresh.

### Rate Limiting
- **None client-side.** DDG anti-bot via UDPG wrapper + stealth fingerprint only.

### Batching / Fan-out
- **None.** One query = one fetch. FetchPage is one fetch per URL (`ddg.go:206-213`).

---

## 2. internal/parallel/ — Parallel API client

### Files
| File | Lines |
|---|---|
| `/home/x3/freebuff-unified/internal/parallel/client.go` | 402 |
| (no test file — exercised via `httpapi/research_test.go` fakeparallel) | |

### Structs / Interfaces
- `Client` — `client.go:28-32`: baseURL, apiKey, `http *http.Client`.
- Request/response DTOs: `SearchRequest` `:62-78`, `AdvancedSettings` `:81-85`, `SourcePolicy` `:88-92`, `SearchResult` `:95-99`, `SearchResponse` `:102-107`, `ExtractRequest` `:126-130`, `ExtractResult` `:133-139`, `ExtractError` `:142-145`, `ExtractResponse` `:148-153`, `TaskRunRequest` `:178-187`, `TaskWebhook` `:190-193`, `TaskRunStatus` `:196-206`, `TaskRunResult` `:209-214`, `TaskOutput` `:217-221`, `TaskBasis` `:224-229`, `APIError` `:388-391`.
- Methods: `Configured` `:52`, `Enabled` `:55`, `Search` `:110`, `Extract` `:156`, `CreateTaskRun` `:232`, `GetTaskRun` `:244`, `GetTaskRunResult` `:256`, `TaskEvents` `:269`, `Responses` `:278`, `HasKey` `:286`, `IsAuthError` `:290`, internal `post` `:305`, `get` `:338`, `raw` `:369`.

### Concurrency
- **None internal.** Single http.Client shared (safe). No goroutines, no pools.
- `TaskEvents` returns live `*http.Response` for SSE relay (`client.go:269-274`) — caller owns body.

### Memory Allocation
- `post`: full request `json.Marshal` → `bytes.NewReader` (`client.go:306-310`); **full response `io.ReadAll` into memory** capped 8MB (`client.go:325`). Extract FullContent + Search excerpts all buffered in RAM.
- `truncate` error body: `string(b[:n]) + "...(truncated)"` allocates concat (`client.go:401`) — cold path only.
- No buffer reuse, no sync.Pool.

### HTTP Client / Transport
- **`client.go:44`: `&http.Client{Timeout: 45 * time.Second}` with DefaultTransport** — no custom transport, no custom MaxIdleConns, no response-header timeout, no TLS tuning. Connection pooling = Go defaults (MaxIdleConnsPerHost 2, IdleConnTimeout 90s default via DefaultTransport basically Zero).
- 45s timeout covers Search (~3s advanced), Extract, Task create/get. Potential concern: `TaskEvents` SSE stream and `Responses` stream:true run under this same 45s **total** deadline (`client.go:44` applies to all requests) — a long SSE relay would abort at 45s. Streaming paths use it via `raw` (`client.go:369-385`).

### Error Handling / Retries
- **No retry, no backoff** anywhere. Single attempt per call.
- Non-200 → `APIError{StatusCode, Body truncated 400}` (`client.go:329-331`, `:358-360`).
- `IsAuthError` (`client.go:290-298`) maps 401/403/402 → fallback trigger for Layer B native harness.

### Caching
- **None.**

### Rate Limiting
- **None client-side.**

### Batching
- Extract batches up to 20 URLs per call (`client.go:163-165` — silently truncates excess; note: caller `researchQuery` already trims to `extractPerQuery` ≤5).

---

## 3. internal/httpapi/research.go — deep-research orchestrator (lines 700-1178)

| File | Lines |
|---|---|
| `/home/x3/freebuff-unified/internal/httpapi/research.go` | 1180 |
| `httpapi/research_test.go` | 237 |

### Structs
- `ResearchConfig` `:25-32`, `researchEvent` `:38-40`, `researchPlan` `:43-46`, `reference` `:49-54`, `evidence` (embeds reference + Content) `:57-60`, `researchMetrics` `:63-73`, `researchReport` `:76-82`, `researchOpts` `:85-93`. `maxEvidence = 12` `:35`.

### Concurrency — fan-out/fan-in (Phase 2, `runResearch`)
- **Worker pool**: semaphore `sem := make(chan struct{}, opts.fanOut)` (`research.go:812`), one goroutine per query with acquisition select `:819-823`, release `:824`. Default fanOut 8 (`config.go:197`), client-clamped 1..32 (`research.go:168`).
- **Fan-in**: `sync.Mutex` guarding `evidenceMap map[string]evidence` + `extractRun` counter `:807-811`, write loop `:834-839`, `wg.Wait()` `:843`.
- **Race condition**: workers send `emitFrame` **outside** the semaphore window `:831`, `:840` — fine (emit is thread-unsafe! `emitFrame` writes SSE frames while the main `streamResearch` loop reads the same `frames` channel — channel is the sync, OK).
- **Potential deadlock**: `researchQuery` result on context-cancel: worker returns early at `:827-829` if `ctx.Err() != nil`, but `researchQuery` itself (via `FetchPage`/`parallel.Extract`) blocks up to its own `Timeout` — bounded by `Searcher.Timeout` 12s (ddg.go:108-110). Whole run bounded by `research.timeout()` default 5m (`research.go:1168-1173`).
- **Goroutine-per-query unbounded count**: up to `maxQueries` (≤10) goroutines — bounded, fine.

### Stream dispatch (`streamResearch` `:709-772`, `relayTaskEvents` `:291-393`)
- `frames := make(chan []byte, 64)` `:717`; producer goroutine `:719-746` with `emit` closure doing **`strings.Builder` + `[]byte(buf.String())` copy per frame** `:722-728` — double allocation per SSE frame (builder buffer + slice copy + channel).
- Heartbeat ticker 15s (`handlers.go:51`) `:748`.
- Consumer writer select on frames/heartbeat/ctx `:751-770`.
- `relayTaskEvents` `:291-393`: same pattern, plus **per-frame `[]byte(blk + "\n\n")`** `:339` and scanner buffer 64KB/1MB `:330`.
- `relayResponses` `:422-483`: 32KB copy per read chunk, `cp := make([]byte, n)` per chunk `:446-447` — one allocation per 32KB chunk, no pooling. On client disconnect, producer blocked on buffered channel send selects on ctx.Done `:448-452`, consumer returns, goroutine exits — **no leak** but relies on ctx propagation through `SendStreamWriter`.

### `bufferedResearch` (`:643-705`)
- Background goroutine `:652-660` with self-contained ctx (`context.WithTimeout(c, ...)` — deliberately not canceled when handler returns; run continues orphaned; result sent to buffered `done` chan size 1, `:651`). **Goroutine runs to completion even if client disconnects** — by design (comment `:653-655`), but means abandoned deep-research continues consuming LLM budget after client leaves. If client disconnects before heartbeat switch, `c.Done()` branch `:702-703` returns 408 while goroutine still runs.
- Note: **`done <- result{rep, err}` at `:659` can block forever** if client disconnected and the heartbeat-switched writer already returned — no, buffered chan size 1 always drains once. OK.

### Search fan-out details (`researchQuery` `:946-1042`)
- Runs Parallel Search AND DDG Search **serially** `:965-988` (both when keyed).
- Extract path: Parallel Extract first `:999-1017`; on failure **falls through to per-URL FetchPage loop** `:1020-1040` — but this is *inside the worker goroutine*, so extract fallback is sequential per query, concurrent across queries (bounded by fanOut).
- **Dedup**: `seen map[string]bool` per query `:951`; global `evidenceMap` keyed by URL `:809`; `sortedEvidence` stable sort query-then-URL `:1108-1120`; `normalizeURL` trims trailing slashes `:1123-1125` (but `map` key vs `normalizeURL` mismatch: evidenceMap keyed by raw `it.URL` while Parallel Extract matching uses normalized — `:1007-1010`; potential duplicate evidence entries for `url` vs `url/`).

### Synthesize (`:1046-1104`)
- Prompt built with `strings.Builder` (correct) `:1047-1058`.
- Stream path accumulates `out strings.Builder` `:1079` + per-delta emit.
- `truncate(e.Content, 4000)` per source `:1055` — `truncate` converts to `[]rune` (allocation) `:1136-1142`.

### Caching / Rate limiting
- **No caching** of search/extract results across runs. Same research brief twice = same upstream calls twice.
- **No client-side rate limiting** on Parallel/DDG fan-out — up to 10 queries × (1 Parallel + 1 DDG) + ≤5 extracts per query, all concurrent at fanOut 8. Only the per-query sequential fallback slows it.

---

## 4. internal/proxy/ — passthrough handler, proxy pool

### Files
| File | Lines |
|---|---|
| `/home/x3/freebuff-unified/internal/proxy/passthrough.go` | 177 |
| `/home/x3/freebuff-unified/internal/proxy/passthrough_test.go` | 265 |

### Structs
- `Handler` — `passthrough.go:30-35`: `mu sync.RWMutex`, `backend *url.URL`, `client *http.Client`, `logger`.
- Methods: `NewHandler` `:39`, `SetBackend` `:49`, `BackendURL` `:70`, `ServeHTTP` `:79`, `RelayResponse` `:120`, `copyStream` `:137`.

### HTTP Client / Transport — **the single biggest finding**
- `passthrough.go:40-41`: `http.DefaultTransport.(*http.Transport).Clone()` + `ResponseHeaderTimeout = 60s`. **No client Timeout** (`client: &http.Client{Transport: transport}` at `:43`) — intentional for SSE, but long-tail stuck upstreams hold goroutines indefinitely; only ResponseHeaderTimeout guards. **No MaxIdleConnsPerHost tuning, no MaxConnsPerHost** — defaults cloned (DefaultTransport.MaxIdleConnsPerHost = 2).
- **Connection reuse problem**: every request to backend re-dials unless keep-alive pools warm; per-host 2 idle conns default throttles LLM streaming under concurrency.

### Concurrency / Memory
- Locking: RLock copies backend pointer `:80-82`, `target := *backend` shallow copy `:88`.
- `copyStream` `:137-153`: 32KB buffer reused per stream (good — single alloc per stream, not per chunk). Per-chunk `Flush()` for SSE.
- Proxy "pool" = single backend URL swap under RWMutex — **not a multi-backend pool** despite package name. No load balancing, no failover across backends; hard 502 on single-backend error (`:109`).
- `isHopByHop` linear scan over 8 headers per header (`:170-176`) — O(8N) per request, negligible.

### Error paths
- No retry, no circuit breaker. Backend error → 502 `:109`. Hop-by-hop stripped both directions (`:159-168`).

### Sync.Pool — none
`grep sync.Pool` across repo: **zero matches**.

---

## 5. Cross-cutting findings

### go.mod memory-heavy deps (`/home/x3/freebuff-unified/go.mod`)
- **fiber v3 + fasthttp + bytebufferpool + klauspost/compress + brotli + msgp** (`go.mod:7,21,26-27`) — fasthttp 1.71.0 pulls bytebufferpool; fiber's compression stack. Memory-heavy relative to net/http but stdlib-backed `adaptor` used for passthrough (`server.go:116`).
- **utls (refraction-networking)** `go.mod:9` — TLS fingerprint lib, used by stealth/`tls.go` (not on the audited hot paths' core fetch since DDG goes through hermes sidecar).
- Notable **absent**: no pgx, no redis, no sqlite in go.mod. Cache layer is pure in-memory.

### sync.Pool usage — none anywhere

### Goroutine leak patterns (audit of all 19 `go func` sites)
| Site | Leak risk |
|---|---|
| `research.go:315` relayTaskEvents producer | **OK** — ctx.Done on both send paths `:325-327`, `:341-343`; consumer exit closes via `close(frames)` after return; scanner loop blocked on `resp.Body.Read` is unblocked by `c.SendStreamWriter` returning? — **risk**: if upstream never sends and never closes, goroutine blocked in `sc.Scan()` (`:345`) until `TaskEvents` http client 45s timeout kills body read. Bounded 45s, but the ctx cancel at `:297-298` does NOT abort the in-flight HTTP read (stdlib cancels via ctx on Request — `TaskEvents` uses `http.NewRequestWithContext` `:374`, so ctx cancel does abort the read. **OK.** |
| `research.go:440` relayResponses producer | **OK** — same ctx-abort via NewRequestWithContext; send select on ctx.Done `:448-452`; per-chunk allocation `:446-447` (see above). |
| `research.go:652` bufferedResearch | **Leak by design** — runResearch continues after client disconnect (`:653-655` comment). Context derived from `c` with timeout — cancel never fired on disconnect. Abandoned runs burn LLM/search budget to completion (up to 5m). |
| `research.go:719` streamResearch producer | **OK** — emit selects ctx.Done `:729`; runResearch honors ctx via its internal timeouts. |
| `research.go:817` fan-out worker | **OK but bounded-race**: `sem <- struct{}{}` select ctx.Done `:819-822`; if ctx dies while worker inside `researchQuery` (12s/45s bounded calls), worker finishes then hits `ctx.Err()` check `:827`. Bounded. |
| `handlers.go:419` ChatCompletions buffer | Same pattern as bufferedResearch — **leak by design** (orphan Complete goroutine on disconnect). |
| `backend_chat.go:89` Stream relay | **OK** — ctx-aware sends `:144-148`, `:151-153`. |
| `chat_service.go:93` forward | **OK** — ctx on all paths, `defer cancel()` `:94`. |
| `stealth/refresher.go:82` Start loop | **OK** — done channel stop func `:101`. |
| `stealth/refresher.go:305,324` probe fan-out | **spot risk** `:305-322`: `results <-` / `errs <-` sends are **not** ctx-guarded — inside semaphore region; if probe completes after ctx cancel, send blocks? No: `results`/`errs` buffered `len(candidates)` (`:295-296`) > maxProbes count, **never blocks**. **OK.** |
| `stealth/proxy.go:102` pool refresh | **OK** — ctx.Done `:107`. |
| `session/manager.go:91`, `freebuff/client.go:324`, `dashboard.go:100,147`, `main.go` sites | Not on audited paths; manager/client goroutines confirmed context/stop-gated in prior structure. |

**Leak summary**: no true unbounded goroutine leaks; two intentional-orbit runs (bufferedResearch, ChatCompletions non-stream) keep burning resources after client disconnect — real cost: LLM tokens + upstream quota on abandoned requests.

### String concatenation hot paths
- **Correct usage** (`strings.Builder`): `research.go:318,331,722,1047,1079`. Good.
- `+` concat only on cold/error paths: `hermes/client.go:203`, `parallel/client.go:401`, `research.go:1141` (truncate suffix).
- **Actual hot-path allocation findings rank**:
  1. `websearch/ddg.go:240-247` — 11 full-page copies per FetchPage (highest per-page memory churn in search path).
  2. `html.UnescapeString` + full-body regex scans `ddg.go:52-74` — regexp over multi-MB bodies per query.
  3. `research.go:722-728` — SSE frame double-copy (builder → []byte → channel).
  4. `research.go:446-447` — per-chunk allocation in relayResponses.
  5. `research.go:1136-1142` — `[]rune` conversion on every truncate (incl. per-source 4000-char truncates in synthesis).

---

## Priority findings (concrete, file:line)

1. **`ddg.go:240-247` cleanPageText** — 11 sequential full-string regex rewrites per page fetch; ~11x body-size transient alloc. Use single-pass scanner or strings.Builder + per-tag removal, or parse with `golang.org/x/net/html` tokenizer.
2. **`parallel/client.go:44` + `hermes/client.go:29`** — default transports; MaxIdleConnsPerHost=2 default; low reuse under fan-out. Tune `MaxIdleConns`, `MaxIdleConnsPerHost`, `IdleConnTimeout`; add `ResponseHeaderTimeout`.
3. **`parallel/client.go:44`** — 45s total client timeout applies to `TaskEvents`/`Responses` SSE relays (`client.go:369-385`); long streams abort at 45s regardless of streamHeartbeatInterval. Needs per-request differentiation.
4. **`research.go:652-660`** — orphaned bufferedResearch goroutine continues to completion after client disconnect; consumes LLM budget. Options: derive ctx from a cancel that fires on `c.Done()`, or accept (documented behavior).
5. **`research.go:722-728, 339`** — double-copy per SSE frame (builder + byte slice per frame). Reuse buffer or write through directly.
6. **`research.go:446-447`** — per-32KB-chunk allocation in relayResponses; use sync.Pool or reuse a single buffer (sequential consumer).
7. **No result caching** across deep-research runs (`runResearch` `:782-881`); repeated briefs re-fetch identical evidence. No cache keyed by query/objective exists beyond `internal/cache/run_cache.go` (agent-run-ID cache, different purpose, `run_cache.go:17-24`).
8. **`research.go:920-925`** — `researchPlan` planner output capped at `maxQueries` but planner LLM may return up to 10; **planQueries** `MaxTokens 4096` `:897` generous vs. planning need.
9. **`passthrough.go:40-43`** — no client Timeout; unbounded goroutine on stuck upstream pre-response (guarded only by 60s ResponseHeaderTimeout; body read after headers unbounded).
10. **`ddg.go:40`** — dead `Proxy func() string` field: dead code, either wire egress proxy selection or delete.

---
