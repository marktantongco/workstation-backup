# Review upstream integration hooks (@general subagent)

- **Session ID:** `ses_f657346a2ffepv3gzmldB1MLS4`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-13 19:35:08
- **Last activity:** 2026-09-13 19:35:56
- **Messages:** 4

---

### 🧑 User — 2026-09-13 19:35:09

Review the vendored sidecar at /home/x3/freebuff-unified/deps/lmarena-stealth-proxy/ for real-fetch integration hooks. Read index.js and test-server.js in FULL (they are ~8-10KB each, small). Also read SAMPLES.md and package.json.

Report:
1. Exact location + code of the placeholder fetchModelResponse (quote it).
2. What session/cookie infrastructure already exists (Session class, getOrCreateSession) — what a real fetch implementation would reuse vs replace.
3. What test-server.js covers — does it test against real lmarena.ai or localhost stub?
4. SAMPLES.md findings: what do the authors claim the HARs document? Any endpoint URLs or protocol notes quoted?
5. Gaps: streaming? conversation history? model listing? auth? List each as present/missing.

Keep factual, quote exact code/paths, under 1200 words. Do not modify any files.

---

### 🤖 Assistant — 2026-09-13 19:35:12

Need files.

**tool:read** (completed) ../freebuff-unified/deps/lmarena-stealth-proxy

```
filePath=/home/x3/freebuff-unified/deps/lmarena-stealth-proxy
--- output ---
<path>/home/x3/freebuff-unified/deps/lmarena-stealth-proxy</path>
<type>directory</type>
<entries>
.env
.env.example
.gitignore
index.js
node_modules/
package-lock.json
package.json
README.md
SAMPLES.md
samples/
test-server.js

(11 entries)
</entries>
```

---

### 🤖 Assistant — 2026-09-13 19:35:19

Files located. Reading full contents now.

**tool:read** (completed) ../freebuff-unified/deps/lmarena-stealth-proxy/index.js

```
filePath=/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/index.js
--- output ---
<path>/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/index.js</path>
<type>file</type>
<content>
1: const express = require('express');
2: const axios = require('axios');
3: const { v4: uuidv4 } = require('uuid');
4: require('dotenv').config();
5: 
6: const app = express();
7: const PORT = process.env.PORT || 3000;
8: const RATE_LIMIT_REQUESTS = parseInt(process.env.RATE_LIMIT_REQUESTS || '10');
9: const RATE_LIMIT_WINDOW_MS = parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000');
10: const LMARENA_BASE_URL = 'https://lmarena.ai';
11: 
12: // Session management
13: const sessions = new Map();
14: const rateLimitMap = new Map();
15: 
16: // Middleware
17: app.use(express.json());
18: 
19: /**
20:  * Session class to manage user state and cookies
21:  */
22: class Session {
23:   constructor() {
24:     this.id = uuidv4();
25:     this.cookies = {};
26:     this.createdAt = Date.now();
27:     this.lastActivity = Date.now();
28:   }
29: 
30:   updateActivity() {
31:     this.lastActivity = Date.now();
32:   }
33: 
34:   addCookie(name, value) {
35:     this.cookies[name] = value;
36:     this.updateActivity();
37:   }
38: 
39:   getCookieString() {
40:     return Object.entries(this.cookies)
41:       .map(([name, value]) => `${name}=${value}`)
42:       .join('; ');
43:   }
44: }
45: 
46: /**
47:  * Rate limiter class
48:  */
49: class RateLimiter {
50:   constructor(maxRequests, windowMs) {
51:     this.maxRequests = maxRequests;
52:     this.windowMs = windowMs;
53:     this.requests = [];
54:   }
55: 
56:   isAllowed() {
57:     const now = Date.now();
58:     // Remove old requests outside the window
59:     this.requests = this.requests.filter(time => now - time < this.windowMs);
60:     
61:     if (this.requests.length < this.maxRequests) {
62:       this.requests.push(now);
63:       return true;
64:     }
65:     return false;
66:   }
67: 
68:   getRemainingRequests() {
69:     const now = Date.now();
70:     this.requests = this.requests.filter(time => now - time < this.windowMs);
71:     return Math.max(0, this.maxRequests - this.requests.length);
72:   }
73: 
74:   getResetTime() {
75:     if (this.requests.length === 0) return 0;
76:     return this.requests[0] + this.windowMs;
77:   }
78: }
79: 
80: /**
81:  * Get or create a session
82:  */
83: function getOrCreateSession(sessionId) {
84:   if (!sessionId || !sessions.has(sessionId)) {
85:     const newSession = new Session();
86:     sessions.set(newSession.id, newSession);
87:     return newSession;
88:   }
89:   const session = sessions.get(sessionId);
90:   session.updateActivity();
91:   return session;
92: }
93: 
94: /**
95:  * Get or create a rate limiter for a session
96:  */
97: function getOrCreateRateLimiter(sessionId) {
98:   if (!rateLimitMap.has(sessionId)) {
99:     rateLimitMap.set(sessionId, new RateLimiter(RATE_LIMIT_REQUESTS, RATE_LIMIT_WINDOW_MS));
100:   }
101:   return rateLimitMap.get(sessionId);
102: }
103: 
104: /**
105:  * Fetch a model response from lmarena.ai
106:  * This is a placeholder implementation that would need to be updated
107:  * with the actual API endpoint once identified
108:  */
109: async function fetchModelResponse(model, input, session) {
110:   try {
111:     // This is a placeholder - the actual implementation would depend on
112:     // the correct API endpoint from lmarena.ai
113:     // For now, we'll simulate a response based on the model name
114:     
115:     const response = {
116:       model: model,
117:       input: input,
118:       output: `[Simulated response from ${model}] This is a placeholder response. The actual implementation requires the correct lmarena.ai API endpoint.`,
119:       timestamp: new Date().toISOString(),
120:       sessionId: session.id,
121:       metadata: {
122:         model_codename: model,
123:         response_time_ms: Math.random() * 5000,
124:         tokens_generated: Math.floor(Math.random() * 100),
125:       }
126:     };
127: 
128:     return response;
129:   } catch (error) {
130:     throw new Error(`Failed to fetch response from model ${model}: ${error.message}`);
131:   }
132: }
133: 
134: /**
135:  * POST /v1/responses - Main endpoint for getting model responses
136:  * Request body: { model: "string", input: "string", sessionId?: "string" }
137:  * Response: { model, input, output, timestamp, sessionId, metadata }
138:  */
139: app.post('/v1/responses', async (req, res) => {
140:   try {
141:     const { model, input, sessionId } = req.body;
142: 
143:     // Validation
144:     if (!model || !input) {
145:       return res.status(400).json({
146:         error: 'Missing required fields: model and input',
147:         code: 'INVALID_REQUEST'
148:       });
149:     }
150: 
151:     // Get or create session
152:     const session = getOrCreateSession(sessionId);
153: 
154:     // Check rate limit
155:     const limiter = getOrCreateRateLimiter(session.id);
156:     if (!limiter.isAllowed()) {
157:       const resetTime = limiter.getResetTime();
158:       return res.status(429).json({
159:         error: 'Rate limit exceeded',
160:         code: 'RATE_LIMIT_EXCEEDED',
161:         retryAfter: Math.ceil((resetTime - Date.now()) / 1000),
162:         resetTime: new Date(resetTime).toISOString()
163:       });
164:     }
165: 
166:     // Fetch response from model
167:     const response = await fetchModelResponse(model, input, session);
168: 
169:     // Return response with session info
170:     res.status(200).json({
171:       success: true,
172:       sessionId: session.id,
173:       ...response
174:     });
175: 
176:   } catch (error) {
177:     console.error('Error in /v1/responses:', error);
178:     res.status(500).json({
179:       error: error.message,
180:       code: 'INTERNAL_SERVER_ERROR'
181:     });
182:   }
183: });
184: 
185: /**
186:  * GET /v1/session/:sessionId - Get session information
187:  */
188: app.get('/v1/session/:sessionId', (req, res) => {
189:   const { sessionId } = req.params;
190:   
191:   if (!sessions.has(sessionId)) {
192:     return res.status(404).json({
193:       error: 'Session not found',
194:       code: 'SESSION_NOT_FOUND'
195:     });
196:   }
197: 
```

**tool:read** (completed) ../freebuff-unified/deps/lmarena-stealth-proxy/test-server.js

```
filePath=/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/test-server.js
--- output ---
<path>/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/test-server.js</path>
<type>file</type>
<content>
1: #!/usr/bin/env node
2: 
3: /**
4:  * Integration test suite for LMArena Stealth Proxy
5:  * Tests the server with various scenarios including:
6:  * - Health check
7:  * - Session creation
8:  * - Model responses with different models
9:  * - Rate limiting
10:  * - Error handling
11:  */
12: 
13: const axios = require('axios');
14: const { spawn } = require('child_process');
15: const path = require('path');
16: 
17: const BASE_URL = 'http://localhost:3000';
18: const TEST_TIMEOUT = 30000; // 30 seconds
19: const MODELS = ['zenith', 'summit', 'quasar'];
20: const TEST_INPUT = 'Hello, world!';
21: 
22: let serverProcess = null;
23: let testsPassed = 0;
24: let testsFailed = 0;
25: 
26: /**
27:  * Color codes for console output
28:  */
29: const colors = {
30:   reset: '\x1b[0m',
31:   green: '\x1b[32m',
32:   red: '\x1b[31m',
33:   yellow: '\x1b[33m',
34:   blue: '\x1b[34m',
35:   cyan: '\x1b[36m'
36: };
37: 
38: function log(color, message) {
39:   console.log(`${color}${message}${colors.reset}`);
40: }
41: 
42: function logTest(name, passed, details = '') {
43:   const status = passed ? `${colors.green}✓ PASS${colors.reset}` : `${colors.red}✗ FAIL${colors.reset}`;
44:   console.log(`${status}: ${name}`);
45:   if (details) {
46:     console.log(`  ${details}`);
47:   }
48:   if (passed) {
49:     testsPassed++;
50:   } else {
51:     testsFailed++;
52:   }
53: }
54: 
55: /**
56:  * Start the server
57:  */
58: function startServer() {
59:   return new Promise((resolve, reject) => {
60:     log(colors.cyan, '\n📦 Starting server...');
61:     
62:     serverProcess = spawn('node', ['index.js'], {
63:       cwd: __dirname,
64:       stdio: 'pipe'
65:     });
66: 
67:     serverProcess.stdout.on('data', (data) => {
68:       const message = data.toString().trim();
69:       if (message.includes('listening')) {
70:         log(colors.green, `✓ Server started: ${message}`);
71:         setTimeout(resolve, 1000); // Give server time to fully initialize
72:       }
73:     });
74: 
75:     serverProcess.stderr.on('data', (data) => {
76:       const message = data.toString().trim();
77:       if (message && !message.includes('ExperimentalWarning')) {
78:         log(colors.yellow, `⚠ Server warning: ${message}`);
79:       }
80:     });
81: 
82:     serverProcess.on('error', reject);
83:     
84:     setTimeout(() => {
85:       reject(new Error('Server startup timeout'));
86:     }, TEST_TIMEOUT);
87:   });
88: }
89: 
90: /**
91:  * Stop the server
92:  */
93: function stopServer() {
94:   return new Promise((resolve) => {
95:     if (serverProcess) {
96:       log(colors.cyan, '\n🛑 Stopping server...');
97:       serverProcess.kill();
98:       serverProcess.on('exit', resolve);
99:       setTimeout(resolve, 2000);
100:     } else {
101:       resolve();
102:     }
103:   });
104: }
105: 
106: /**
107:  * Test: Health check
108:  */
109: async function testHealthCheck() {
110:   try {
111:     const response = await axios.get(`${BASE_URL}/health`);
112:     const passed = response.status === 200 && response.data.status === 'ok';
113:     logTest('Health Check', passed, `Status: ${response.data.status}`);
114:     return passed;
115:   } catch (error) {
116:     logTest('Health Check', false, error.message);
117:     return false;
118:   }
119: }
120: 
121: /**
122:  * Test: Root endpoint
123:  */
124: async function testRootEndpoint() {
125:   try {
126:     const response = await axios.get(`${BASE_URL}/`);
127:     const passed = response.status === 200 && response.data.name === 'LMArena Stealth Proxy';
128:     logTest('Root Endpoint', passed, `API version: ${response.data.version}`);
129:     return passed;
130:   } catch (error) {
131:     logTest('Root Endpoint', false, error.message);
132:     return false;
133:   }
134: }
135: 
136: /**
137:  * Test: Session creation
138:  */
139: async function testSessionCreation() {
140:   try {
141:     const response = await axios.post(`${BASE_URL}/v1/session`);
142:     const passed = response.status === 201 && response.data.sessionId;
143:     logTest('Session Creation', passed, `Session ID: ${response.data.sessionId}`);
144:     return response.data.sessionId;
145:   } catch (error) {
146:     logTest('Session Creation', false, error.message);
147:     return null;
148:   }
149: }
150: 
151: /**
152:  * Test: Get session info
153:  */
154: async function testGetSessionInfo(sessionId) {
155:   try {
156:     const response = await axios.get(`${BASE_URL}/v1/session/${sessionId}`);
157:     const passed = response.status === 200 && response.data.sessionId === sessionId;
158:     logTest('Get Session Info', passed, `Remaining requests: ${response.data.rateLimit.remaining}`);
159:     return passed;
160:   } catch (error) {
161:     logTest('Get Session Info', false, error.message);
162:     return false;
163:   }
164: }
165: 
166: /**
167:  * Test: Model responses
168:  */
169: async function testModelResponses(sessionId) {
170:   const results = [];
171:   
172:   for (const model of MODELS) {
173:     try {
174:       const response = await axios.post(`${BASE_URL}/v1/responses`, {
175:         model: model,
176:         input: TEST_INPUT,
177:         sessionId: sessionId
178:       });
179: 
180:       const passed = response.status === 200 &&
181:                      response.data.model === model &&
182:                      response.data.output &&
183:                      response.data.metadata;
184: 
185:       logTest(`Model Response (${model})`, passed, `Output length: ${response.data.output.length} chars`);
186:       results.push(passed);
187:     } catch (error) {
188:       logTest(`Model Response (${model})`, false, error.message);
189:       results.push(false);
190:     }
191:   }
192: 
193:   return results.every(r => r);
194: }
195: 
196: /**
197:  * Test: Rate limiting
```

**tool:read** (completed) ../freebuff-unified/deps/lmarena-stealth-proxy/SAMPLES.md

```
filePath=/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/SAMPLES.md
--- output ---
<path>/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/SAMPLES.md</path>
<type>file</type>
<content>
1: # Network Traffic Samples
2: 
3: This directory contains HAR (HTTP Archive) files captured from actual lmarena.ai sessions. These files document the network requests and responses used by the platform and serve as reference material for understanding the API structure.
4: 
5: ## Files
6: 
7: ### `lmarena.ai.har`
8: **Initial session and page load**
9: - Captures the first visit to lmarena.ai
10: - Includes page load, resource fetching, and initial analytics
11: - Shows Cloudflare security verification
12: - Documents session initialization
13: 
14: ### `lmarena.ai2.har`
15: **Blind A/B test run**
16: - Captures a blind A/B test session where two anonymous models are compared
17: - Shows battle mode interaction
18: - Includes voting/feedback submission
19: - Demonstrates the comparison interface flow
20: 
21: ### `lmarena.ai3.har`
22: **Direct chat run**
23: - Captures a direct chat session with a single model
24: - Shows model selection and conversation flow
25: - Includes streaming response handling
26: - Documents the chat interface interaction
27: 
28: ## Key Endpoints Identified
29: 
30: ### Analytics & Telemetry
31: - **`/ingest/i/v0/e/`** - Event tracking (gzip-compressed)
32: - **`/ingest/decide/`** - Experiment/feature decision endpoint
33: - **Google Analytics** - External tracking service
34: 
35: ### User Management
36: - **`/nextjs-api/sign-up`** - User registration/anonymous session creation
37: 
38: ### Expected (Not Captured)
39: Based on the research report and community findings:
40: - **`/queue/join`** - Join a queue for model interaction
41: - **`/queue/data`** - Retrieve response data from queue
42: - **WebSocket endpoints** - For real-time streaming responses
43: 
44: ## How to Use These Samples
45: 
46: ### 1. Analyze with HAR Viewer
47: ```bash
48: # Online HAR viewer
49: # Visit: http://www.softwareishard.com/blog/har-viewer/
50: # Upload any .har file to inspect requests/responses
51: ```
52: 
53: ### 2. Extract Specific Requests
54: ```bash
55: # Using jq to extract POST requests
56: jq '.log.entries[] | select(.request.method == "POST")' lmarena.ai3.har
57: 
58: # Extract URLs
59: jq -r '.log.entries[] | .request.url' lmarena.ai3.har | sort | uniq
60: ```
61: 
62: ### 3. Inspect Request/Response Pairs
63: ```bash
64: # Get a specific request with headers and body
65: jq '.log.entries[] | select(.request.url | contains("/queue/")) | {
66:   url: .request.url,
67:   headers: .request.headers,
68:   body: .request.postData.text,
69:   response: .response.content.text
70: }' lmarena.ai3.har
71: ```
72: 
73: ## Request/Response Structure
74: 
75: ### Typical Request Format
76: ```json
77: {
78:   "method": "POST",
79:   "url": "https://lmarena.ai/api/endpoint",
80:   "headers": [
81:     {
82:       "name": "content-type",
83:       "value": "application/json"
84:     },
85:     {
86:       "name": "authorization",
87:       "value": "Bearer <token>"
88:     }
89:   ],
90:   "postData": {
91:     "mimeType": "application/json",
92:     "text": "{...}"
93:   }
94: }
95: ```
96: 
97: ### Typical Response Format
98: ```json
99: {
100:   "status": 200,
101:   "statusText": "OK",
102:   "headers": [
103:     {
104:       "name": "content-type",
105:       "value": "application/json"
106:     }
107:   ],
108:   "content": {
109:     "size": 1234,
110:     "mimeType": "application/json",
111:     "text": "{...}"
112:   }
113: }
114: ```
115: 
116: ## Important Headers
117: 
118: ### Request Headers
119: - **`User-Agent`**: Browser identification
120: - **`Authorization`**: Session token (if required)
121: - **`Content-Type`**: Request payload format
122: - **`Accept-Encoding`**: Compression support (gzip, deflate, br, zstd)
123: - **`Origin`**: Request origin (https://lmarena.ai)
124: - **`Referer`**: Referring page
125: 
126: ### Response Headers
127: - **`Content-Type`**: Response format (application/json, text/event-stream, etc.)
128: - **`Content-Encoding`**: Compression used (gzip, br, etc.)
129: - **`Cache-Control`**: Caching directives
130: - **`Set-Cookie`**: Session cookies
131: - **`X-RateLimit-*`**: Rate limit information
132: 
133: ## Session Management
134: 
135: ### Session Identification
136: Sessions are tracked via:
137: 1. **Cookies** - Persistent session identifiers
138: 2. **URL Parameters** - Session hashes in query strings
139: 3. **Request Headers** - Custom session headers
140: 
141: ### Session Flow
142: ```
143: 1. Initial page load
144:    ↓
145: 2. Cloudflare security verification
146:    ↓
147: 3. Create anonymous session
148:    ↓
149: 4. Fetch available models
150:    ↓
151: 5. Select model or start comparison
152:    ↓
153: 6. Send message/prompt
154:    ↓
155: 7. Receive response (streaming or complete)
156:    ↓
157: 8. Submit feedback/voting
158: ```
159: 
160: ## Rate Limiting
161: 
162: ### Observed Limits
163: - **Daily limits per model**: ~32 requests (varies by model)
164: - **Concurrent requests**: Limited
165: - **Request frequency**: Throttled to prevent abuse
166: 
167: ### Rate Limit Headers
168: ```
169: X-RateLimit-Limit: 10
170: X-RateLimit-Remaining: 8
171: X-RateLimit-Reset: 1760961300
172: ```
173: 
174: ## Compression
175: 
176: ### Supported Encodings
177: - **gzip**: Standard compression
178: - **deflate**: Alternative compression
179: - **br**: Brotli compression
180: - **zstd**: Zstandard compression
181: 
182: ### Decompression
183: ```bash
184: # Decompress gzip
185: gunzip < compressed.gz > decompressed.txt
186: 
187: # Decompress with jq
188: jq '.log.entries[] | select(.response.content.encoding == "gzip")' file.har
189: ```
190: 
191: ## Privacy & Security Notes
192: 
193: ### What's Included
194: - ✅ Public API endpoints
195: - ✅ Request/response structure
196: - ✅ Header information
197: - ✅ Timing data
```

**tool:read** (completed) ../freebuff-unified/deps/lmarena-stealth-proxy/package.json

```
filePath=/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/package.json
--- output ---
<path>/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/package.json</path>
<type>file</type>
<content>
1: {
2:   "name": "lmarena-stealth-proxy",
3:   "version": "1.0.0",
4:   "main": "index.js",
5:   "scripts": {
6:     "start": "node index.js",
7:     "dev": "nodemon index.js",
8:     "test": "npm run test:integration",
9:     "test:integration": "node test-server.js"
10:   },
11:   "repository": {
12:     "type": "git",
13:     "url": "git+https://github.com/YourBoiiLevi/lmarena-stealth-proxy.git"
14:   },
15:   "keywords": [
16:     "lmarena",
17:     "api",
18:     "proxy",
19:     "benchmarking",
20:     "ai",
21:     "models"
22:   ],
23:   "author": "YourBoiiLevi",
24:   "license": "ISC",
25:   "bugs": {
26:     "url": "https://github.com/YourBoiiLevi/lmarena-stealth-proxy/issues"
27:   },
28:   "homepage": "https://github.com/YourBoiiLevi/lmarena-stealth-proxy#readme",
29:   "description": "A local HTTP API proxy for lmarena.ai benchmarking",
30:   "dependencies": {
31:     "axios": "^1.6.0",
32:     "dotenv": "^16.3.1",
33:     "express": "^4.18.2",
34:     "uuid": "^9.0.0"
35:   },
36:   "devDependencies": {
37:     "nodemon": "^3.0.1"
38:   },
39:   "engines": {
40:     "node": ">=14.0.0",
41:     "npm": ">=6.0.0"
42:   }
43: }

(End of file - total 43 lines)
</content>
```

---

### 🤖 Assistant — 2026-09-13 19:35:29

Sidecar: `/home/x3/freebuff-unified/deps/lmarena-stealth-proxy/`

**1. Placeholder `fetchModelResponse`**

Location: `index.js:104-132`

```js
/**
 * Fetch a model response from lmarena.ai
 * This is a placeholder implementation that would need to be updated
 * with the actual API endpoint once identified
 */
async function fetchModelResponse(model, input, session) {
  try {
    // This is a placeholder - the actual implementation would depend on
    // the correct API endpoint from lmarena.ai
    // For now, we'll simulate a response based on the model name
    
    const response = {
      model: model,
      input: input,
      output: `[Simulated response from ${model}] This is a placeholder response. The actual implementation requires the correct lmarena.ai API endpoint.`,
      timestamp: new Date().toISOString(),
      sessionId: session.id,
      metadata: {
        model_codename: model,
        response_time_ms: Math.random() * 5000,
        tokens_generated: Math.floor(Math.random() * 100),
      }
    };

    return response;
  } catch (error) {
    throw new Error(`Failed to fetch response from model ${model}: ${error.message}`);
  }
}
```

Zero real fetch. `axios` imported, `LMARENA_BASE_URL='https://lmarena.ai'` defined `index.js:10`, neither used inside function.

**2. Session/cookie infra already exists**

`index.js:13-14`: `sessions = new Map()`, `rateLimitMap = new Map()` in-memory only, no persistence/cleanup.

`Session` class `index.js:22-44`:
```js
class Session {
  constructor() {
    this.id = uuidv4();
    this.cookies = {};
    this.createdAt = Date.now();
    this.lastActivity = Date.now();
  }
  updateActivity() { this.lastActivity = Date.now(); }
  addCookie(name, value) { this.cookies[name] = value; this.updateActivity(); }
  getCookieString() {
    return Object.entries(this.cookies)
      .map(([name, value]) => `${name}=${value}`)
      .join('; ');
  }
}
```

`getOrCreateSession(sessionId)` `index.js:83-92`: new `Session()` if missing/unknown, else `updateActivity()` + return. `getOrCreateRateLimiter()` `index.js:97-102` similar per-session `RateLimiter`.

Reuse: `Session.id`, `getOrCreateSession`, Express `POST /v1/responses`, `POST|GET|DELETE /v1/session`, per-session `RateLimiter` all reusable. `getCookieString()` reusable for `Cookie` header once real login captured.
Replace: `cookies={}` never populated — no `Set-Cookie` parsing, no Cloudflare clearance handling, no `addCookie` call site, no history/message array, no upstream `axios` call at all.

**3. `test-server.js` coverage**

Localhost stub only, no real `lmarena.ai` traffic. `test-server.js:17`: `const BASE_URL = 'http://localhost:3000'`. `startServer()` `test-server.js:58-88` spawns `node index.js`, waits for `listening`, then hits local endpoints. Models fake: `test-server.js:19` `MODELS=['zenith','summit','quasar']`.

Covers: `GET /health`, `GET /`, `POST /v1/session`, `GET /v1/session/:id`, `POST /v1/responses` shape check (`model`, `output`, `metadata`), `DELETE /v1/session/:id`, 400 on missing `input`, 404 on bogus session, 429 loop (up to 20 `POST /v1/responses` on fresh session).

**4. `SAMPLES.md` findings**

Claims `samples/` holds 3 HARs from actual sessions:
- `lmarena.ai.har`: first visit, page load, Cloudflare verification, session init.
- `lmarena.ai2.har`: blind A/B battle mode, voting/feedback.
- `lmarena.ai3.har`: direct single-model chat, streaming.

Quoted identified endpoints (`SAMPLES.md:30-42`):
- `"/ingest/i/v0/e/"` — event tracking (gzip)
- `"/ingest/decide/"` — experiment/feature decision
- `"/nextjs-api/sign-up"` — registration/anonymous session
- Expected not captured: `"/queue/join"`, `"/queue/data"`, `"WebSocket endpoints - For real-time streaming responses"`
No full `https://lmarena.ai/...` chat-submit URL quoted, no request body schema, no protocol decode. Only generic HAR tooling (`jq` filters) + 8-step session flow diagram + observed `~32 req/day/model` limit.

`package.json`: `express ^4.18.2`, `axios ^1.6.0`, `uuid ^9.0.0`, `dotenv ^16.3.1`. No WS/SSE/streaming lib.

**5. Gaps**

- Real fetch: missing. No upstream HTTP call.
- Streaming: missing. No SSE/WebSocket/chunked handling in code or tests. Only mentioned as expectation in `SAMPLES.md`.
- Conversation history: missing. `POST /v1/responses` takes single `{model,input}` string, no messages array, no server-side history store.
- Model listing: missing. No `GET /v1/models`, tests hardcode fake names.
- Auth: missing. No sign-up call, token handling, Cloudflare bypass, cookie jar wiring. `Session.cookies` empty stub.


---
