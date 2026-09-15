# Study AIClient2API routing (@general subagent)

- **Session ID:** `ses_f5aed52ffffegYR10B87oo1Ail`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-15 20:37:39
- **Last activity:** 2026-09-15 20:39:41
- **Messages:** 7

---

### 🧑 User — 2026-09-15 20:37:40

Read and analyze the AIClient2API project's routing patterns. Focus on:

1. `/home/x3/workspace/AIClient2API/src/core/config-manager.js` - config management
2. `/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js` - provider pool with failover (first 200 lines)
3. `/home/x3/workspace/AIClient2API/src/providers/adapter.js` - unified provider adapter (first 100 lines)
4. `/home/x3/workspace/AIClient2API/src/core/master.js` - master orchestration (first 100 lines)

Extract the key patterns for:
- How provider pools work (rotation, failover, health)
- How config is managed and hot-reloaded
- How multiple providers are unified into one interface
- Any interesting rate limiting or retry patterns

Return a concise summary (max 500 words) of the most useful patterns that could improve BlacklistedAIProxy.

---

### 🤖 Assistant — 2026-09-15 20:37:40

> The user wants me to read and analyze several files from the AIClient2API project to understand its routing patterns, provider pool management, config management, and other architectural patterns. Let me read all four files in parallel.

Reading all four files in parallel.

**tool:read** (completed) AIClient2API/src/core/config-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/core/config-manager.js
--- output ---
<path>/home/x3/workspace/AIClient2API/src/core/config-manager.js</path>
<type>file</type>
<content>
1: import * as fs from 'fs';
2: import { promises as pfs } from 'fs';
3: import { DEFAULT_REQUEST_BODY_MAX_BYTES, INPUT_SYSTEM_PROMPT_FILE } from '../utils/common.js';
4: import { MODEL_PROVIDER } from '../utils/constants.js';
5: import logger from '../utils/logger.js';
6: 
7: export let CONFIG = {}; // Make CONFIG exportable
8: export let PROMPT_LOG_FILENAME = ''; // Make PROMPT_LOG_FILENAME exportable
9: 
10: const ALL_MODEL_PROVIDERS = Object.values(MODEL_PROVIDER);
11: const BYTES_PER_MB = 1024 * 1024;
12: 
13: function parsePositiveInteger(value) {
14:     if (value === undefined || value === null || value === '') {
15:         return null;
16:     }
17: 
18:     const parsed = Number(value);
19:     if (!Number.isFinite(parsed) || parsed <= 0) {
20:         return null;
21:     }
22: 
23:     return Math.floor(parsed);
24: }
25: 
26: function normalizeRequestBodyMaxBytes(config) {
27:     const envBytes = parsePositiveInteger(process.env.REQUEST_BODY_MAX_BYTES);
28:     if (envBytes !== null) {
29:         config.REQUEST_BODY_MAX_BYTES = envBytes;
30:         return;
31:     }
32: 
33:     const envMb = parsePositiveInteger(process.env.REQUEST_BODY_MAX_MB);
34:     if (envMb !== null) {
35:         config.REQUEST_BODY_MAX_BYTES = envMb * BYTES_PER_MB;
36:         return;
37:     }
38: 
39:     const configuredBytes = parsePositiveInteger(config.REQUEST_BODY_MAX_BYTES);
40:     config.REQUEST_BODY_MAX_BYTES = configuredBytes ?? DEFAULT_REQUEST_BODY_MAX_BYTES;
41: }
42: 
43: function normalizeConfiguredProviders(config) {
44:     const fallbackProvider = MODEL_PROVIDER.GEMINI_CLI;
45:     const dedupedProviders = [];
46: 
47:     const addProvider = (value) => {
48:         if (typeof value !== 'string') {
49:             return;
50:         }
51:         const trimmed = value.trim();
52:         if (!trimmed) {
53:             return;
54:         }
55: 
56:         // 1. 优先尝试精确匹配基础类型
57:         const matched = ALL_MODEL_PROVIDERS.find((provider) => provider.toLowerCase() === trimmed.toLowerCase());
58:         if (matched) {
59:             if (!dedupedProviders.includes(matched)) {
60:                 dedupedProviders.push(matched);
61:             }
62:             return;
63:         }
64: 
65:         // 2. 尝试前缀匹配 (支持带后缀的自定义分组，例如 openai-custom-1)
66:         const prefixMatch = ALL_MODEL_PROVIDERS.find((provider) => 
67:             provider !== 'auto' && trimmed.toLowerCase().startsWith(provider.toLowerCase() + '-')
68:         );
69:         
70:         if (prefixMatch) {
71:             if (!dedupedProviders.includes(trimmed)) {
72:                 dedupedProviders.push(trimmed);
73:             }
74:             return;
75:         }
76: 
77:         logger.warn(`[Config Warning] Unknown model provider '${trimmed}'. This entry will be ignored.`);
78:     };
79: 
80:     const rawValue = config.MODEL_PROVIDER;
81:     if (Array.isArray(rawValue)) {
82:         rawValue.forEach((entry) => addProvider(typeof entry === 'string' ? entry : String(entry)));
83:     } else if (typeof rawValue === 'string') {
84:         rawValue.split(',').forEach(addProvider);
85:     } else if (rawValue != null) {
86:         addProvider(String(rawValue));
87:     }
88: 
89:     if (dedupedProviders.length === 0) {
90:         dedupedProviders.push(fallbackProvider);
91:     }
92: 
93:     config.DEFAULT_MODEL_PROVIDERS = dedupedProviders;
94:     config.MODEL_PROVIDER = dedupedProviders[0];
95: }
96: 
97: /**
98:  * Initializes the server configuration from config.json and command-line arguments.
99:  * @param {string[]} args - Command-line arguments.
100:  * @param {string} [configFilePath='configs/config.json'] - Path to the configuration file.
101:  * @returns {Object} The initialized configuration object.
102:  */
103: export async function initializeConfig(args = process.argv.slice(2), configFilePath = 'configs/config.json') {
104:     const defaultConfig = {
105:         REQUIRED_API_KEY: "123456",
106:         SERVER_PORT: 3000,
107:         HOST: '0.0.0.0',
108:         MODEL_PROVIDER: MODEL_PROVIDER.GEMINI_CLI,
109:         SYSTEM_PROMPT_FILE_PATH: INPUT_SYSTEM_PROMPT_FILE, // Default value
110:         SYSTEM_PROMPT_MODE: 'append',
111:         PROXY_URL: null, // HTTP/HTTPS/SOCKS5 代理地址，如 http://127.0.0.1:7890 或 socks5://127.0.0.1:1080
112:         PROXY_ENABLED_PROVIDERS: [], // 启用代理的提供商列表，如 ['gemini-cli-oauth', 'claude-kiro-oauth']
113:         PROMPT_LOG_BASE_NAME: "prompt_log",
114:         PROMPT_LOG_MODE: "none",
115:         REQUEST_MAX_RETRIES: 3,
116:         REQUEST_BASE_DELAY: 1000,
117:         MODEL_FALLBACK_ENABLED: true, // 模型不存在时是否自动 fallback 到默认/映射模型
118:         REQUEST_BODY_MAX_BYTES: DEFAULT_REQUEST_BODY_MAX_BYTES,
119:         CREDENTIAL_SWITCH_MAX_RETRIES: 5, // 坏凭证切换最大重试次数（用于认证错误后切换凭证）
120:         // 上游返回完全空响应（无文本/工具调用/思考）时的独立重试预算，与 CREDENTIAL_SWITCH_MAX_RETRIES 分开计数。
121:         // 该机制是通用的，对任何 provider 抛出 isEmptyUpstreamResponse 错误都生效，不局限于 Kiro。
122:         EMPTY_RESPONSE_MAX_RETRIES: 2,
123:         EMPTY_RESPONSE_RETRY_DELAY_MS: 500, // 空响应重试前的等待时间（毫秒），避免瞬间打满上游
124:         RATE_LIMIT_COOLDOWN_ENABLED: false, // 429 限流后是否短暂冷却账号
125:         RATE_LIMIT_COOLDOWN_MS: 30000, // 429 限流默认冷却时间（毫秒）
126:         RATE_LIMIT_COOLDOWN_JITTER_MS: 5000, // 429 限流冷却随机抖动（毫秒）
127:         RATE_LIMIT_COOLDOWN_MAX_MS: 300000, // Retry-After 允许的最大冷却时间（毫秒）
128:         CRON_NEAR_MINUTES: 15,
129:         CRON_REFRESH_TOKEN: false,
130:         LOGIN_EXPIRY: 3600, // 登录过期时间（秒），默认1小时
131:         LOGIN_MAX_ATTEMPTS: 5, // 最大失败重试次数
132:         LOGIN_LOCKOUT_DURATION: 1800, // 锁定持续时间（秒），默认30分钟
133:         LOGIN_MIN_INTERVAL: 5000, // 两次尝试之间的最小间隔（毫秒），默认1秒
134:         TRUST_PROXY: false, // 是否信任反向代理传入的 x-forwarded-for
135:         TRUSTED_PROXY_IPS: ['127.0.0.1', '::1'], // 允许提供 x-forwarded-for 的反向代理 IP 列表
136:         PROVIDER_POOLS_FILE_PATH: null, // 新增号池配置文件路径
137:         MAX_ERROR_COUNT: 10, // 提供商最大错误次数
138:         CUSTOM_MODELS_FILE_PATH: null, // 自定义模型配置文件路径
139:         SYSTEM_PROMPT_REPLACEMENTS: [], // 系统提示词内容替换规则，例如: [{"old": "AI", "new": "Bot"}, {"old": "OpenAI", "new": "Gemini"}]
140:         SCHEDULED_HEALTH_CHECK: {
141:             enabled: false,
142:             interval: 600000,
143:             startupRun: false
144:         },
145:         providerFallbackChain: {}, // 跨类型 Fallback 链配置
146:         LOG_ENABLED: true,
147:         LOG_OUTPUT_MODE: "all",
148:         LOG_LEVEL: "info",
149:         LOG_DIR: "logs",
150:         LOG_INCLUDE_REQUEST_ID: true,
151:         LOG_INCLUDE_TIMESTAMP: true,
152:         LOG_MAX_FILE_SIZE: 10485760,
153:         LOG_MAX_FILES: 10,
154:         TLS_SIDECAR_ENABLED: false, // 启用 Go uTLS sidecar（需要编译 tls-sidecar 二进制）
155:         TLS_SIDECAR_ENABLED_PROVIDERS: [], // 启用 TLS Sidecar 的提供商列表
156:         TLS_SIDECAR_PORT: 9090,     // sidecar 监听端口
157:         TLS_SIDECAR_BINARY_PATH: null, // 自定义二进制路径（默认自动搜索）
158:         TLS_SIDECAR_PROXY_URL: null,    // TLS Sidecar 专用的上游代理地址
159:         UI_ENABLED: true           // 是否启用前端管理界面
160:     };
161: 
162:     let currentConfig = { ...defaultConfig };
163: 
164:     try {
165:         const configData = fs.readFileSync(configFilePath, 'utf8');
166:         const loadedConfig = JSON.parse(configData);
167:         Object.assign(currentConfig, loadedConfig);
168:         logger.info('[Config] Loaded configuration from configs/config.json');
169:     } catch (error) {
170:         if (error.code !== 'ENOENT') {
171:             logger.error('[Config Error] Failed to load configs/config.json:', error.message);
172:         } else {
173:             logger.info('[Config] configs/config.json not found, using default configuration.');
174:         }
175:     }
176: 
177: 
178:     // CLI argument definitions: { flag, configKey, type, validValues? }
179:     // type: 'string' | 'int' | 'bool' | 'enum'
180:     const cliArgDefs = [
181:         { flag: '--api-key',              configKey: 'REQUIRED_API_KEY',       type: 'string' },
182:         { flag: '--log-prompts',          configKey: 'PROMPT_LOG_MODE',        type: 'enum', validValues: ['console', 'file'] },
183:         { flag: '--port',                 configKey: 'SERVER_PORT',            type: 'int' },
184:         { flag: '--model-provider',       configKey: 'MODEL_PROVIDER',         type: 'string' },
185:         { flag: '--system-prompt-file',   configKey: 'SYSTEM_PROMPT_FILE_PATH', type: 'string' },
186:         { flag: '--system-prompt-mode',   configKey: 'SYSTEM_PROMPT_MODE',     type: 'enum', validValues: ['overwrite', 'append'] },
187:         { flag: '--host',                 configKey: 'HOST',                   type: 'string' },
188:         { flag: '--prompt-log-base-name', configKey: 'PROMPT_LOG_BASE_NAME',   type: 'string' },
189:         { flag: '--request-max-retries',  configKey: 'REQUEST_MAX_RETRIES',    type: 'int' },
190:         { flag: '--model-fallback-enabled', configKey: 'MODEL_FALLBACK_ENABLED', type: 'bool' },
191:         { flag: '--request-body-max-bytes', configKey: 'REQUEST_BODY_MAX_BYTES', type: 'int' },
192:         { flag: '--rate-limit-cooldown-enabled', configKey: 'RATE_LIMIT_COOLDOWN_ENABLED', type: 'bool' },
193:         { flag: '--rate-limit-cooldown-ms', configKey: 'RATE_LIMIT_COOLDOWN_MS', type: 'int' },
194:         { flag: '--rate-limit-cooldown-jitter-ms', configKey: 'RATE_LIMIT_COOLDOWN_JITTER_MS', type: 'int' },
195:         { flag: '--rate-limit-cooldown-max-ms', configKey: 'RATE_LIMIT_COOLDOWN_MAX_MS', type: 'int' },
196:         { flag: '--cron-near-minutes',    configKey: 'CRON_NEAR_MINUTES',      type: 'int' },
197:         { flag: '--cron-refresh-token',   configKey: 'CRON_REFRESH_TOKEN',     type: 'bool' },
```

**tool:read** (completed) AIClient2API/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js; limit=200
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js</path>
<type>file</type>
<content>
1: import * as fs from 'fs';
2: import { getServiceAdapter, getRegisteredProviders, invalidateServiceAdapter } from './adapter.js';
3: import logger from '../utils/logger.js';
4: import { MODEL_PROVIDER, getProtocolPrefix } from '../utils/common.js';
5: import { withFileLock, atomicWriteFile } from '../utils/file-lock.js';
6: import { convertData } from '../convert/convert.js';
7: 
8: import {
9:     getConfiguredSupportedModels,
10:     getCustomModelListProvider,
11:     getProviderModels,
12:     normalizeModelIds
13: } from './provider-models.js';
14: import { broadcastEvent } from '../ui-modules/event-broadcast.js';
15: import { ENDPOINT_TYPE } from '../utils/common.js';
16: 
17: function getCustomModelAliasesForProvider(config, providerType) {
18:     const customModels = Array.isArray(config?.customModels) ? config.customModels : [];
19:     return new Set(
20:         customModels
21:             .filter(model => {
22:                 const listProvider = getCustomModelListProvider(model);
23:                 return model?.alias &&
24:                     model.alias !== model.id &&
25:                     listProvider &&
26:                     (listProvider === providerType || providerType.startsWith(listProvider + '-'));
27:             })
28:             .map(model => model.alias)
29:     );
30: }
31: 
32: function getCustomModelIdsForProvider(config, providerType) {
33:     const customModels = Array.isArray(config?.customModels) ? config.customModels : [];
34:     return customModels
35:         .filter(model => {
36:             const listProvider = getCustomModelListProvider(model);
37:             return model?.id &&
38:                 listProvider &&
39:                 (listProvider === providerType || providerType.startsWith(listProvider + '-'));
40:         })
41:         .map(model => model.id);
42: }
43: 
44: /**
45:  * Manages a pool of API service providers, handling their health and selection.
46:  */
47: export class ProviderPoolManager {
48:     // 默认健康检查模型配置
49:     // 键名必须与 MODEL_PROVIDER 常量值一致
50:     static DEFAULT_HEALTH_CHECK_MODELS = {
51:         'gemini-cli-oauth': 'gemini-3-flash-preview',
52:         'gemini-antigravity': 'gemini-3-flash',
53:         'claude-custom': 'claude-sonnet-4-5',
54:         'claude-kiro-oauth': 'claude-sonnet-4-5',
55:         'openai-custom': 'gpt-5.5',
56:         'atlascloud': 'gpt-5.5',
57:         'qiniu': 'gpt-5.5',
58:         'fenno': 'gpt-5.5',
59:         'openai-qwen-oauth': 'qwen3-coder-plus',
60:         'openai-iflow': 'qwen3-max',
61:         'openai-codex-oauth': 'gpt-5',
62:         'openaiResponses-custom': 'gpt-5.5',
63:         'grok-web': 'grok-4.3',
64:         'grok-cli-oauth': 'grok-4.3',
65:         'forward-api': 'gpt-5.5'
66:     };
67: 
68:     constructor(providerPools, options = {}) {
69:         this.providerPools = providerPools;
70:         this.globalConfig = options.globalConfig || {}; // 存储全局配置
71:         this.providerStatus = {}; // Tracks health and usage for each provider instance
72:         this.roundRobinIndex = {}; // Tracks the current index for round-robin selection for each provider type
73:         // 使用 ?? 运算符确保 0 也能被正确设置，而不是被 || 替换为默认值
74:         this.maxErrorCount = options.maxErrorCount ?? 10; // Default to 10 errors before marking unhealthy
75:         this.healthCheckInterval = options.healthCheckInterval ?? 10 * 60 * 1000; // Default to 10 minutes
76: 
77:             // 日志级别控制
78:         this.logLevel = options.logLevel || 'info'; // 'debug', 'info', 'warn', 'error'
79:         
80:         // 添加防抖机制，避免频繁的文件 I/O 操作
81:         this.saveDebounceTime = options.saveDebounceTime || 1000; // 默认1秒防抖
82:         this.saveTimer = null;
83:         this.pendingSaves = new Set(); // 记录待保存的 providerType
84:         
85:         // Fallback 链配置
86:         this.fallbackChain = options.globalConfig?.providerFallbackChain || {};
87:         
88:         // Model Fallback 映射配置
89:         this.modelFallbackMapping = options.globalConfig?.modelFallbackMapping || {};
90: 
91:         // 并发控制：每个 providerType 的选择锁
92:         // 用于确保 selectProvider 的排序 and 更新操作是原子的
93:         this._selectionLocks = {};
94:         this._isSelecting = {}; // 同步标志位锁
95: 
96:         // --- V2: 读写分离 and 异步刷新队列 ---
97:         // 刷新并发控制配置
98:         this.refreshConcurrency = {
99:             global: options.globalConfig?.REFRESH_CONCURRENCY_GLOBAL ?? 2, // 全局最大并行提供商数
100:             perProvider: options.globalConfig?.REFRESH_CONCURRENCY_PER_PROVIDER ?? 1 // 每个提供商内部最大并行数
101:         };
102:         
103:         this.activeProviderRefreshes = 0; // 当前正在刷新的提供商类型数量
104:         this.globalRefreshWaiters = []; // 等待全局并发槽位的任务
105:         
106:         this.warmupTarget = options.globalConfig?.WARMUP_TARGET || 0; // 默认预热0个节点
107:         this.refreshingUuids = new Set(); // 正在刷新的节点 UUID 集合
108:         
109:         this.refreshQueues = {}; // 按 providerType 分组的队列
110:         // 缓冲队列机制：延迟5秒，去重后再执行刷新
111:         this.refreshBufferQueues = {}; // 按 providerType 分组的缓冲队列
112:         this.refreshBufferTimers = {}; // 按 providerType 分组的定时器
113:         this.bufferDelay = options.globalConfig?.REFRESH_BUFFER_DELAY ?? 5000; // 默认5秒缓冲延迟
114:         this.refreshTaskTimeoutMs = options.globalConfig?.REFRESH_TASK_TIMEOUT_MS ?? 60000; // 默认60秒刷新超时
115:         
116:         // 用于并发选点时的原子排序辅助（自增序列）
117:         this._selectionSequence = 0;
118:  
119:         this.initializeProviderStatus();
120:     }
121: 
122:     /**
123:      * 强制刷新特定节点的令牌
124:      * @param {string} providerType 
125:      * @param {string} uuid 
126:      * @param {boolean} force 
127:      */
128:     async refreshNode(providerType, uuid, force = true) {
129:         const provider = this._findProvider(providerType, uuid);
130:         if (provider) {
131:             this._log('info', `Manually triggering refresh for node ${this._getDisplayName(provider.config)} (${providerType})`);
132:             this._enqueueRefresh(providerType, provider, force);
133:             return true;
134:         }
135:         return false;
136:     }
137: 
138:     /**
139:      * 检查所有节点的配置文件，如果发现即将过期则触发刷新
140:      */
141:     async checkAndRefreshExpiringNodes() {
142:         this._log('info', 'Checking nodes for approaching expiration dates using provider adapters...');
143:         
144:         for (const providerType in this.providerStatus) {
145:             const providers = this.providerStatus[providerType];
146:             for (const providerStatus of providers) {
147:                 const config = providerStatus.config;
148:                 
149:                 // 根据 providerType 确定配置文件路径字段名
150:                 let configPath = null;
151:                 if (providerType.startsWith('claude-kiro')) {
152:                     configPath = config.KIRO_OAUTH_CREDS_FILE_PATH;
153:                 } else if (providerType.startsWith('gemini-cli')) {
154:                     configPath = config.GEMINI_OAUTH_CREDS_FILE_PATH;
155:                 } else if (providerType.startsWith('gemini-antigravity')) {
156:                     configPath = config.ANTIGRAVITY_OAUTH_CREDS_FILE_PATH;
157:                 } else if (providerType.startsWith('openai-qwen')) {
158:                     configPath = config.QWEN_OAUTH_CREDS_FILE_PATH;
159:                 } else if (providerType.startsWith('openai-iflow')) {
160:                     configPath = config.IFLOW_OAUTH_CREDS_FILE_PATH;
161:                 } else if (providerType.startsWith('openai-codex')) {
162:                     configPath = config.CODEX_OAUTH_CREDS_FILE_PATH;
163:                 } else if (providerType.startsWith('grok-cli')) {
164:                     configPath = config.GROK_CLI_OAUTH_CREDS_FILE_PATH;
165:                 }
166:                 
167:                 // logger.info(`Checking node ${this._getDisplayName(config)} (${providerType}) expiry date... configPath: ${configPath}`);
168:                 // 排除禁用的节点（不健康节点也应允许尝试刷新以恢复健康）
169:                 if (config.isDisabled) continue;
170: 
171:                 if (configPath && fs.existsSync(configPath)) {
172:                     try {
173:                         const fileContent = fs.readFileSync(configPath, 'utf-8');
174:                         const credData = JSON.parse(fileContent);
175:                         const rawExpiryTime = credData.expiry_date ?? credData.expiry ?? credData.expires_at ?? credData.expiresAt;
176:                         let expiryTime = null;
177:                         if (typeof rawExpiryTime === 'number') {
178:                             expiryTime = rawExpiryTime;
179:                         } else if (typeof rawExpiryTime === 'string') {
180:                             const parsedDate = Date.parse(rawExpiryTime);
181:                             expiryTime = Number.isNaN(parsedDate) ? Number(rawExpiryTime) : parsedDate;
182:                         }
183:                         const nearExpiryMs = (this.globalConfig?.CRON_NEAR_MINUTES || 10) * 60 * 1000;
184:                         if (!Number.isFinite(expiryTime)) {
185:                             // 凭据文件缺少 expiry 字段，无法判断是否快过期，作为安全措施强制刷新
186:                             this._log('warn', `Node ${this._getDisplayName(config)} (${providerType}) has no expiry field. Forcing refresh as safety measure...`);
187:                             this._enqueueRefresh(providerType, providerStatus);
188:                         } else if ((expiryTime - Date.now()) < nearExpiryMs) {
189:                             this._log('warn', `Node ${this._getDisplayName(config)} (${providerType}) is near expiration. Enqueuing refresh...`);
190:                             this._enqueueRefresh(providerType, providerStatus);
191:                         }
192:                     } catch (err) {
193:                         this._log('error', `Failed to check expiry for node ${this._getDisplayName(config)}: ${err.message}`);
194:                     }
195:                 } else {
196:                     this._log('debug', `Node ${this._getDisplayName(config)} (${providerType}) has no valid config file path or file does not exist.`);
197:                 }
```

**tool:read** (completed) AIClient2API/src/providers/adapter.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/adapter.js; limit=100
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/adapter.js</path>
<type>file</type>
<content>
1: import { OpenAIResponsesApiService } from './openai/openai-responses-core.js';
2: import { GeminiApiService } from './gemini/gemini-core.js';
3: import { AntigravityApiService } from './gemini/antigravity-core.js';
4: import { OpenAIApiService } from './openai/openai-core.js';
5: import { ClaudeApiService } from './claude/claude-core.js';
6: import { KiroApiService } from './claude/claude-kiro.js';
7: import { QwenApiService } from './openai/qwen-core.js';
8: import { IFlowApiService } from './openai/iflow-core.js';
9: import { CodexApiService } from './openai/codex-core.js';
10: import { ForwardApiService } from './forward/forward-core.js';
11: import { GrokApiService } from './grok/grok-core.js';
12: import { GrokCliApiService } from './grok/grok-cli-core.js';
13: import { MODEL_PROVIDER } from '../utils/constants.js';
14: import logger from '../utils/logger.js';
15: 
16: // 适配器注册表
17: const adapterRegistry = new Map();
18: 
19: /**
20:  * 注册服务适配器
21:  * @param {string} provider - 提供商名称 (来自 MODEL_PROVIDER)
22:  * @param {typeof ApiServiceAdapter} adapterClass - 适配器类
23:  */
24: export function registerAdapter(provider, adapterClass) {
25:     logger.info(`[Adapter] Registering adapter for provider: ${provider}`);
26:     adapterRegistry.set(provider, adapterClass);
27: }
28: 
29: /**
30:  * 获取所有已注册的提供商
31:  * @returns {string[]} 已注册的提供商名称列表
32:  */
33: export function getRegisteredProviders() {
34:     return Array.from(adapterRegistry.keys());
35: }
36: 
37: // 定义AI服务适配器接口
38: // 所有的服务适配器都应该实现这些方法
39: export class ApiServiceAdapter {
40:     constructor() {
41:         if (new.target === ApiServiceAdapter) {
42:             throw new TypeError("Cannot construct ApiServiceAdapter instances directly");
43:         }
44:     }
45: 
46:     /**
47:      * 生成内容
48:      * @param {string} model - 模型名称
49:      * @param {object} requestBody - 请求体
50:      * @returns {Promise<object>} - API响应
51:      */
52:     async generateContent(model, requestBody) {
53:         throw new Error("Method 'generateContent()' must be implemented.");
54:     }
55: 
56:     /**
57:      * 流式生成内容
58:      * @param {string} model - 模型名称
59:      * @param {object} requestBody - 请求体
60:      * @returns {AsyncIterable<object>} - API响应流
61:      */
62:     async *generateContentStream(model, requestBody) {
63:         throw new Error("Method 'generateContentStream()' must be implemented.");
64:     }
65: 
66:     /**
67:      * 列出可用模型
68:      * @returns {Promise<object>} - 模型列表
69:      */
70:     async listModels() {
71:         throw new Error("Method 'listModels()' must be implemented.");
72:     }
73: 
74:     /**
75:      * 刷新认证令牌
76:      * @returns {Promise<boolean>} - 是否执行了实际的刷新操作
77:      */
78:     async refreshToken() {
79:         throw new Error("Method 'refreshToken()' must be implemented.");
80:     }
81: 
82:     /**
83:      * 强制刷新认证令牌（不判断是否接近过期）
84:      * @returns {Promise<boolean>} - 是否执行了实际的刷新操作
85:      */
86:     async forceRefreshToken() {
87:         throw new Error("Method 'forceRefreshToken()' must be implemented.");
88:     }
89: 
90:     /**
91:      * 判断日期是否接近过期
92:      * @returns {boolean}
93:      */
94:     isExpiryDateNear() {
95:         throw new Error("Method 'isExpiryDateNear()' must be implemented.");
96:     }
97: }
98: 
99: // Gemini API 服务适配器
100: export class GeminiApiServiceAdapter extends ApiServiceAdapter {

(Showing lines 1-100 of 834. Use offset=101 to continue.)
</content>
```

**tool:read** (completed) AIClient2API/src/core/master.js

```
filePath=/home/x3/workspace/AIClient2API/src/core/master.js; limit=100
--- output ---
<path>/home/x3/workspace/AIClient2API/src/core/master.js</path>
<type>file</type>
<content>
1: /**
2:  * 主进程 (Master Process)
3:  * 
4:  * 负责管理子进程的生命周期，包括：
5:  * - 启动子进程
6:  * - 监控子进程状态
7:  * - 处理子进程重启请求
8:  * - 提供 IPC 通信
9:  * 
10:  * 使用方式：
11:  * node src/core/master.js [原有的命令行参数]
12:  */
13: 
14: import './security-hardening.js';
15: import { fork } from 'child_process';
16: import logger from '../utils/logger.js';
17: import * as http from 'http';
18: import * as path from 'path';
19: import { fileURLToPath } from 'url';
20: import { isRetryableNetworkError } from '../utils/common.js';
21: 
22: const __filename = fileURLToPath(import.meta.url);
23: const __dirname = path.dirname(__filename);
24: 
25: // 子进程实例
26: let workerProcess = null;
27: 
28: // 子进程状态
29: let workerStatus = {
30:     pid: null,
31:     startTime: null,
32:     restartCount: 0,
33:     lastRestartTime: null,
34:     isRestarting: false
35: };
36: 
37: // 配置
38: const config = {
39:     workerScript: path.join(__dirname, '../services/api-server.js'),
40:     maxRestartAttempts: 10,
41:     restartDelay: 1000, // 重启延迟（毫秒）
42:     masterPort: parseInt(process.env.MASTER_PORT) || 3100, // 主进程管理端口
43:     args: process.argv.slice(2) // 传递给子进程的参数
44: };
45: 
46: /**
47:  * 启动子进程
48:  */
49: function startWorker() {
50:     if (workerProcess) {
51:         logger.info('[Master] Worker process already running, PID:', workerProcess.pid);
52:         return;
53:     }
54: 
55:     logger.info('[Master] Starting worker process...');
56:     logger.info('[Master] Worker script:', config.workerScript);
57:     logger.info('[Master] Worker args:', config.args.join(' '));
58: 
59:     workerProcess = fork(config.workerScript, config.args, {
60:         stdio: ['inherit', 'inherit', 'inherit', 'ipc'],
61:         env: {
62:             ...process.env,
63:             IS_WORKER_PROCESS: 'true'
64:         }
65:     });
66: 
67:     workerStatus.pid = workerProcess.pid;
68:     workerStatus.startTime = new Date().toISOString();
69: 
70:     logger.info('[Master] Worker process started, PID:', workerProcess.pid);
71: 
72:     // 监听子进程消息
73:     workerProcess.on('message', (message) => {
74:         logger.info('[Master] Received message from worker:', message);
75:         handleWorkerMessage(message);
76:     });
77: 
78:     // 监听子进程退出
79:     workerProcess.on('exit', (code, signal) => {
80:         logger.info(`[Master] Worker process exited with code ${code}, signal ${signal}`);
81:         workerProcess = null;
82:         workerStatus.pid = null;
83: 
84:         // 如果不是主动重启导致的退出，尝试自动重启
85:         if (!workerStatus.isRestarting && code !== 0) {
86:             logger.info('[Master] Worker crashed, attempting auto-restart...');
87:             scheduleRestart();
88:         }
89:     });
90: 
91:     // 监听子进程错误
92:     workerProcess.on('error', (error) => {
93:         logger.error('[Master] Worker process error:', error.message);
94:     });
95: }
96: 
97: /**
98:  * 停止子进程
99:  * @param {boolean} graceful - 是否优雅关闭
100:  * @returns {Promise<void>}

(Showing lines 1-100 of 396. Use offset=101 to continue.)
</content>
```

---

### 🤖 Assistant — 2026-09-15 20:37:51

> Let me read more of the provider-pool-manager to understand the selectProvider and failover logic.

Need deeper read on pool selection and failover logic.

**tool:read** (completed) AIClient2API/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js; limit=250; offset=200
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js</path>
<type>file</type>
<content>
200:     }
201: 
202:     /**
203:      * 系统预热逻辑：按提供商分组，每组预热 warmupTarget 个节点
204:      * @returns {Promise<void>}
205:      */
206:     async warmupNodes() {
207:         if (this.warmupTarget <= 0) return;
208:         this._log('info', `Starting system warmup (Group Target: ${this.warmupTarget} nodes per provider)...`);
209: 
210:         const nodesToWarmup = [];
211: 
212:         for (const type in this.providerStatus) {
213:             const pool = this.providerStatus[type];
214:             
215:             // 挑选当前提供商下需要预热的节点
216:             const candidates = pool
217:                 .filter(p => p.config.isHealthy && !p.config.isDisabled && !this.refreshingUuids.has(p.uuid))
218:                 .sort((a, b) => {
219:                     // 优先级 A: 明确标记需要刷新的
220:                     if (a.config.needsRefresh && !b.config.needsRefresh) return -1;
221:                     if (!a.config.needsRefresh && b.config.needsRefresh) return 1;
222: 
223:                     // 优先级 B: 按照正常的选择权重排序（最久没用过的优先补）
224:                     const scoreA = this._calculateNodeScore(a);
225:                     const scoreB = this._calculateNodeScore(b);
226:                     return scoreA - scoreB;
227:                 })
228:                 .slice(0, this.warmupTarget);
229: 
230:             candidates.forEach(p => nodesToWarmup.push({ type, status: p }));
231:         }
232: 
233:         this._log('info', `Warmup: Selected total ${nodesToWarmup.length} nodes across all providers to refresh.`);
234: 
235:         for (const node of nodesToWarmup) {
236:             this._enqueueRefresh(node.type, node.status, true);
237:         }
238: 
239:         // 注意：warmupNodes 不等待队列结束，它是异步后台执行的
240:     }
241: 
242:     /**
243:      * 将节点放入缓冲队列，延迟5秒后去重并执行刷新
244:      * @param {string} providerType 
245:      * @param {object} providerStatus 
246:      * @param {boolean} force - 是否强制刷新（跳过缓冲队列）
247:      * @private
248:      */
249:     _enqueueRefresh(providerType, providerStatus, force = false) {
250:         const uuid = providerStatus.uuid;
251:         
252:         // 如果节点被禁用，不进行刷新
253:         if (providerStatus.config.isDisabled) {
254:             this._log('debug', `Skipping refresh for disabled node ${this._getDisplayName(providerStatus.config)}`);
255:             return;
256:         }
257:         
258:         // 如果已经在刷新中，直接返回
259:         if (this.refreshingUuids.has(uuid)) {
260:             this._log('debug', `Node ${this._getDisplayName(providerStatus.config)} is already in refresh queue.`);
261:             return;
262:         }
263: 
264:         // 判断提供商池内的总可用节点数，小于5个时，不等待缓冲，直接加入刷新队列
265:         const healthyCount = this.getHealthyCount(providerType);
266:         if (healthyCount < 5) {
267:             this._log('info', `Provider ${providerType} has only ${healthyCount} healthy nodes. Bypassing buffer and enqueuing refresh for ${this._getDisplayName(providerStatus.config)} immediately.`);
268:             this._enqueueRefreshImmediate(providerType, providerStatus, force);
269:             return;
270:         }
271: 
272:         // 初始化缓冲队列
273:         if (!this.refreshBufferQueues[providerType]) {
274:             this.refreshBufferQueues[providerType] = new Map(); // 使用 Map 自动去重
275:         }
276: 
277:         const bufferQueue = this.refreshBufferQueues[providerType];
278:         
279:         // 检查是否已在缓冲队列中
280:         const existing = bufferQueue.get(uuid);
281:         const isNewEntry = !existing;
282:         
283:         // 更新或添加节点（保留 force: true 状态）
284:         bufferQueue.set(uuid, {
285:             providerStatus,
286:             force: existing ? (existing.force || force) : force
287:         });
288:         
289:         if (isNewEntry) {
290:             this._log('debug', `Node ${this._getDisplayName(providerStatus.config)} added to buffer queue for ${providerType}. Buffer size: ${bufferQueue.size}`);
291:         } else {
292:             this._log('debug', `Node ${this._getDisplayName(providerStatus.config)} already in buffer queue, updated force flag. Buffer size: ${bufferQueue.size}`);
293:         }
294: 
295:         // 只在新增节点或缓冲队列为空时重置定时器
296:         // 避免频繁重置导致刷新被无限延迟
297:         if (isNewEntry || !this.refreshBufferTimers[providerType]) {
298:             // 清除之前的定时器
299:             if (this.refreshBufferTimers[providerType]) {
300:                 clearTimeout(this.refreshBufferTimers[providerType]);
301:             }
302: 
303:             // 设置新的定时器，延迟5秒后处理缓冲队列
304:             this.refreshBufferTimers[providerType] = setTimeout(() => {
305:                 this._flushRefreshBuffer(providerType);
306:             }, this.bufferDelay);
307:         }
308:     }
309: 
310:     /**
311:      * 处理缓冲队列，将去重后的节点放入实际刷新队列
312:      * @param {string} providerType 
313:      * @private
314:      */
315:     _flushRefreshBuffer(providerType) {
316:         const bufferQueue = this.refreshBufferQueues[providerType];
317:         if (!bufferQueue || bufferQueue.size === 0) {
318:             return;
319:         }
320: 
321:         this._log('info', `Flushing refresh buffer for ${providerType}. Processing ${bufferQueue.size} unique nodes.`);
322: 
323:         // 将缓冲队列中的所有节点放入实际刷新队列
324:         for (const [uuid, { providerStatus, force }] of bufferQueue.entries()) {
325:             this._enqueueRefreshImmediate(providerType, providerStatus, force);
326:         }
327: 
328:         // 清空缓冲队列和定时器
329:         bufferQueue.clear();
330:         delete this.refreshBufferTimers[providerType];
331:     }
332: 
333:     /**
334:      * 立即将节点放入刷新队列（内部方法，由缓冲队列调用）
335:      * @param {string} providerType 
336:      * @param {object} providerStatus 
337:      * @param {boolean} force 
338:      * @private
339:      */
340:     _enqueueRefreshImmediate(providerType, providerStatus, force = false) {
341:         const uuid = providerStatus.uuid;
342:         
343:         // 再次检查是否已经在刷新中（防止并发问题）
344:         if (this.refreshingUuids.has(uuid)) {
345:             this._log('debug', `Node ${this._getDisplayName(providerStatus.config)} is already in refresh queue (immediate check).`);
346:             return;
347:         }
348: 
349:         this.refreshingUuids.add(uuid);
350: 
351:         // 初始化提供商队列
352:         if (!this.refreshQueues[providerType]) {
353:             this.refreshQueues[providerType] = {
354:                 activeCount: 0,
355:                 waitingTasks: [],
356:                 ownsGlobalSlot: false,
357:                 waitingForGlobalSlot: false
358:             };
359:         }
360: 
361:         const queue = this.refreshQueues[providerType];
362: 
363:         const runTask = async () => {
364:             try {
365:                 await this._refreshNodeToken(providerType, providerStatus, force);
366:             } catch (err) {
367:                 this._log('error', `Failed to process refresh for node ${this._getDisplayName(providerStatus.config)}: ${err.message}`);
368:             } finally {
369:                 this.refreshingUuids.delete(uuid);
370: 
371:                 // 再次获取当前队列引用
372:                 const currentQueue = this.refreshQueues[providerType];
373:                 if (!currentQueue) return;
374: 
375:                 currentQueue.activeCount--;
376: 
377:                 // 1. 尝试从当前提供商队列中取下一个任务
378:                 if (currentQueue.waitingTasks.length > 0) {
379:                     const nextTask = currentQueue.waitingTasks.shift();
380:                     currentQueue.activeCount++;
381:                     // 使用 Promise.resolve().then 避免过深的递归
382:                     Promise.resolve().then(nextTask).catch(err => {
383:                         this._log('error', `Failed to execute next task for ${providerType}: ${err.message}`);
384:                     });
385:                 } else if (currentQueue.activeCount === 0) {
386:                     const ownsGlobalSlot = currentQueue.ownsGlobalSlot;
387:                     currentQueue.ownsGlobalSlot = false;
388: 
389:                     // 清理空队列：无论是否持有全局槽位，都应删除已无任务的队列对象
390:                     if (currentQueue.waitingTasks.length === 0 &&
391:                         this.refreshQueues[providerType] === currentQueue) {
392:                         delete this.refreshQueues[providerType];
393:                     }
394: 
395:                     // 只有持有全局槽位的任务才能递减计数器
396:                     if (ownsGlobalSlot) {
```

**tool:read** (completed) AIClient2API/src/core/master.js

```
filePath=/home/x3/workspace/AIClient2API/src/core/master.js; limit=150; offset=100
--- output ---
<path>/home/x3/workspace/AIClient2API/src/core/master.js</path>
<type>file</type>
<content>
100:  * @returns {Promise<void>}
101:  */
102: function stopWorker(graceful = true) {
103:     return new Promise((resolve) => {
104:         if (!workerProcess) {
105:             logger.info('[Master] No worker process to stop');
106:             resolve();
107:             return;
108:         }
109: 
110:         logger.info('[Master] Stopping worker process, PID:', workerProcess.pid);
111: 
112:         const timeout = setTimeout(() => {
113:             if (workerProcess) {
114:                 logger.info('[Master] Force killing worker process...');
115:                 workerProcess.kill('SIGKILL');
116:             }
117:             resolve();
118:         }, 5000); // 5秒超时后强制杀死
119: 
120:         workerProcess.once('exit', () => {
121:             clearTimeout(timeout);
122:             workerProcess = null;
123:             workerStatus.pid = null;
124:             logger.info('[Master] Worker process stopped');
125:             resolve();
126:         });
127: 
128:         if (graceful) {
129:             // 发送优雅关闭信号
130:             workerProcess.send({ type: 'shutdown' });
131:             workerProcess.kill('SIGTERM');
132:         } else {
133:             workerProcess.kill('SIGKILL');
134:         }
135:     });
136: }
137: 
138: /**
139:  * 重启子进程
140:  * @returns {Promise<Object>}
141:  */
142: async function restartWorker() {
143:     if (workerStatus.isRestarting) {
144:         logger.info('[Master] Restart already in progress');
145:         return { success: false, message: 'Restart already in progress' };
146:     }
147: 
148:     workerStatus.isRestarting = true;
149:     workerStatus.restartCount++;
150:     workerStatus.lastRestartTime = new Date().toISOString();
151: 
152:     logger.info('[Master] Restarting worker process...');
153: 
154:     try {
155:         await stopWorker(true);
156:         
157:         // 等待一小段时间确保端口释放
158:         await new Promise(resolve => setTimeout(resolve, config.restartDelay));
159:         
160:         startWorker();
161:         workerStatus.isRestarting = false;
162: 
163:         return {
164:             success: true,
165:             message: 'Worker restarted successfully',
166:             pid: workerStatus.pid,
167:             restartCount: workerStatus.restartCount
168:         };
169:     } catch (error) {
170:         workerStatus.isRestarting = false;
171:         logger.error('[Master] Failed to restart worker:', error.message);
172:         return {
173:             success: false,
174:             message: 'Failed to restart worker: ' + error.message
175:         };
176:     }
177: }
178: 
179: /**
180:  * 计划重启（用于崩溃后自动重启）
181:  */
182: function scheduleRestart() {
183:     if (workerStatus.restartCount >= config.maxRestartAttempts) {
184:         logger.error('[Master] Max restart attempts reached, giving up');
185:         return;
186:     }
187: 
188:     const delay = Math.min(config.restartDelay * Math.pow(2, workerStatus.restartCount), 30000);
189:     logger.info(`[Master] Scheduling restart in ${delay}ms...`);
190: 
191:     setTimeout(() => {
192:         restartWorker();
193:     }, delay);
194: }
195: 
196: /**
197:  * 处理来自子进程的消息
198:  * @param {Object} message - 消息对象
199:  */
200: function handleWorkerMessage(message) {
201:     if (!message || !message.type) return;
202: 
203:     switch (message.type) {
204:         case 'ready':
205:             logger.info('[Master] Worker is ready');
206:             break;
207:         case 'restart_request':
208:             logger.info('[Master] Worker requested restart');
209:             restartWorker();
210:             break;
211:         case 'status':
212:             logger.info('[Master] Worker status:', message.data);
213:             break;
214:         default:
215:             logger.info('[Master] Unknown message type:', message.type);
216:     }
217: }
218: 
219: /**
220:  * 获取状态信息
221:  * @returns {Object}
222:  */
223: function getStatus() {
224:     return {
225:         master: {
226:             pid: process.pid,
227:             uptime: process.uptime(),
228:             memoryUsage: process.memoryUsage()
229:         },
230:         worker: {
231:             pid: workerStatus.pid,
232:             startTime: workerStatus.startTime,
233:             restartCount: workerStatus.restartCount,
234:             lastRestartTime: workerStatus.lastRestartTime,
235:             isRestarting: workerStatus.isRestarting,
236:             isRunning: workerProcess !== null
237:         }
238:     };
239: }
240: 
241: /**
242:  * 创建主进程管理 HTTP 服务器
243:  */
244: function createMasterServer() {
245:     const server = http.createServer(async (req, res) => {
246:         const url = new URL(req.url, `http://${req.headers.host}`);
247:         const path = url.pathname;
248:         const method = req.method;
249: 

(Showing lines 100-249 of 396. Use offset=250 to continue.)
</content>
```

---

### 🤖 Assistant — 2026-09-15 20:38:06

> Let me also read the selectProvider logic which is the key routing method.

Reading the selectProvider and scoring logic.

**tool:read** (completed) AIClient2API/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js; limit=300; offset=450
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js</path>
<type>file</type>
<content>
450:                         waitingForGlobalSlot: false
451:                     };
452:                 }
453:                 // 从等待队列启动时持有全局槽位
454:                 const currentQueue = this.refreshQueues[providerType];
455:                 currentQueue.waitingForGlobalSlot = false;
456:                 currentQueue.ownsGlobalSlot = true;
457:                 this.activeProviderRefreshes++;
458:                 tryStartProviderQueue();
459:             });
460:         }
461:     }
462: 
463:     /**
464:      * 实际执行节点刷新逻辑
465:      * @private
466:      */
467:     async _refreshNodeToken(providerType, providerStatus, force = false) {
468:         const config = providerStatus.config;
469:         
470:         // 检查刷新次数是否已达上限（最大5次）
471:         const currentRefreshCount = config.refreshCount || 0;
472:         if (currentRefreshCount >= 5 && !force) {
473:             this._log('warn', `Node ${this._getDisplayName(config)} has reached maximum refresh count (5), marking as unhealthy`);
474:             // 标记为不健康
475:             this.markProviderUnhealthyImmediately(providerType, config, 'Maximum refresh count (5) reached');
476:             return;
477:         }
478:         
479:         // 添加5秒内的随机等待时间，避免并发刷新时的冲突
480:         // const randomDelay = Math.floor(Math.random() * 5000);
481:         // this._log('info', `Starting token refresh for node ${this._getDisplayName(config)} (${providerType}) with ${randomDelay}ms delay`);
482:         // await new Promise(resolve => setTimeout(resolve, randomDelay));
483: 
484:         try {
485:             // 增加刷新计数
486:             config.refreshCount = currentRefreshCount + 1;
487: 
488:             // 使用适配器进行刷新
489:             const tempConfig = {
490:                 ...this.globalConfig,
491:                 ...config,
492:                 MODEL_PROVIDER: providerType
493:             };
494:             delete tempConfig.providerPools;
495:             const serviceAdapter = getServiceAdapter(tempConfig);
496:             
497:             // 调用适配器的 refreshToken 方法（内部封装了具体的刷新逻辑）
498:             if (typeof serviceAdapter.refreshToken === 'function') {
499:                 const startTime = Date.now();
500:                 let refreshOperation;
501:                 if (force) {
502:                     if (typeof serviceAdapter.forceRefreshToken === 'function') {
503:                         refreshOperation = serviceAdapter.forceRefreshToken();
504:                     } else {
505:                         this._log('warn', `forceRefreshToken not implemented for ${providerType}, falling back to refreshToken`);
506:                         refreshOperation = serviceAdapter.refreshToken();
507:                     }
508:                 } else {
509:                     refreshOperation = serviceAdapter.refreshToken();
510:                 }
511:                 const refreshResult = await this._awaitRefreshWithTimeout(refreshOperation, providerType, this._getDisplayName(config));
512: 
513:                 const duration = Date.now() - startTime;
514:                 
515:                 // 只有在真正执行了刷新操作时，才更新 lastRefreshTime
516:                 // 这可以防止 heartbeat 的 no-op 刷新误更新时间，导致后续真正的刷新被 markProviderNeedRefresh 拦截（30秒保护）
517:                 if (refreshResult === true) {
518:                     this._log('info', `Token refresh successful for node ${this._getDisplayName(config)} (Duration: ${duration}ms)`);
519:                     config.lastRefreshTime = Date.now(); // 记录最后实际刷新成功时间
520:                 } else {
521:                     this._log('info', `Token refresh no-op for node ${this._getDisplayName(config)} (Already valid)`);
522:                 }
523:                 
524:                 // 刷新流程结束（无论是否真正刷新），重置状态
525:                 config.needsRefresh = false;
526:                 config.refreshCount = 0;
527:                 config.errorCount = 0; // 成功/无操作也重置错误计数
528:                 
529:                 this._debouncedSave(providerType);
530:             } else {
531:                 throw new Error(`refreshToken method not implemented for ${providerType}`);
532:             }
533: 
534:         } catch (error) {
535:             this._log('error', `Token refresh failed for node ${this._getDisplayName(config)}: ${error.message}`);
536:             
537:             // 记录错误信息
538:             config.lastErrorTime = new Date().toISOString();
539:             config.lastErrorMessage = `Refresh failed: ${error.message}`;
540:             
541:             // 增加错误计数（用于普通的健康检查参考，虽然刷新错误主要参考 refreshCount）
542:             config.errorCount = (config.errorCount || 0) + 1;
543: 
544:             // 只有当刷新重试次数达到上限（5次）时，才标记为不健康
545:             // 注意：refreshCount 在进入本方法后的 try 块前已经自增（L466）
546:             if (config.refreshCount >= 5) {
547:                 this.markProviderUnhealthyImmediately(providerType, config, `Refresh failed after maximum attempts (5): ${error.message}`);
548:             } else {
549:                 // 关键修复：重置 needsRefresh 为 false，允许该节点回到池中
550:                 // 这样它才有机会被下一次请求选中，从而再次触发刷新重试
551:                 config.needsRefresh = false;
552: 
553:                 // 增加冷却保护：更新 lastRefreshTime，利用 markProviderNeedRefresh 中的 30s 保护逻辑，
554:                 // 防止因瞬时高并发请求导致 5 次重试机会在短时间内被耗尽。
555:                 config.lastRefreshTime = Date.now(); 
556:                 
557:                 this._debouncedSave(providerType);
558:             }
559:             throw error;
560:         }
561:     }
562: 
563:     /**
564:      * 为刷新任务附加超时保护，避免单个适配器调用无限挂起。
565:      * @private
566:      */
567:     async _awaitRefreshWithTimeout(refreshOperation, providerType, displayName) {
568:         if (this.refreshTaskTimeoutMs <= 0) {
569:             return await refreshOperation;
570:         }
571: 
572:         let timeoutId = null;
573:         const timeoutPromise = new Promise((_, reject) => {
574:             timeoutId = setTimeout(() => {
575:                 reject(new Error(`Refresh timeout after ${this.refreshTaskTimeoutMs}ms for node ${displayName} (${providerType})`));
576:             }, this.refreshTaskTimeoutMs);
577:         });
578: 
579:         try {
580:             return await Promise.race([Promise.resolve(refreshOperation), timeoutPromise]);
581:         } finally {
582:             if (timeoutId) {
583:                 clearTimeout(timeoutId);
584:             }
585:         }
586:     }
587: 
588:     /**
589:      * 计算节点的权重/评分，用于排序
590:      * 分数越低，优先级越高
591:      * @private
592:      */
593:     _calculateNodeScore(providerStatus, now = Date.now(), minSeqInPool = -1) {
594:         const config = providerStatus.config;
595:         const state = providerStatus.state;
596:         
597:         // 1. 基础健康分：不健康的排最后
598:         if (!config.isHealthy || config.isDisabled) return 1e18;
599:         
600:         // 检查并发限制
601:         const concurrencyLimit = parseInt(config.concurrencyLimit || 0);
602:         const queueLimit = parseInt(config.queueLimit || 0);
603:         
604:         if (concurrencyLimit > 0) {
605:             if (state.activeCount >= concurrencyLimit) {
606:                 // 如果队列也满了，排在最后（但优于不健康节点）
607:                 if (queueLimit > 0 && state.waitingCount >= queueLimit) {
608:                     return 1e17;
609:                 }
610:                 // 没满，但需要排队。排队数量越多，权重越大
611:                 return 1e15 + (state.waitingCount || 0) * 1e10;
612:             }
613:         }
614:         
615:         // 2. 预热/新鲜度判断
616:         const lastHealthCheckTime = config.lastHealthCheckTime ? new Date(config.lastHealthCheckTime).getTime() : 0;
617:         const isFresh = lastHealthCheckTime && (now - lastHealthCheckTime < 60000);
618: 
619:         // 3. 计算统一评分
620:         // 基础分：新鲜节点使用固定负偏移 (-1e14)，普通节点使用上次使用时间 (约 1.7e12)
621:         const lastUsedTime = config.lastUsed ? new Date(config.lastUsed).getTime() : (now - 86400000);
622:         const baseScore = isFresh ? -1e14 : lastUsedTime;
623: 
624:         // 惩罚项 A: 使用次数 (每多用一次增加 10 秒权重)
625:         const usageCount = config.usageCount || 0;
626:         const usageScore = usageCount * 10000;
627: 
628:         // 惩罚项 B: 相对序列号 (用于打破平局，确保轮询)
629:         const lastSelectionSeq = config._lastSelectionSeq || 0;
630:         if (minSeqInPool === -1) {
631:             const pool = this.providerStatus[providerStatus.type] || [];
632:             minSeqInPool = pool.reduce((min, p) => Math.min(min, p.config._lastSelectionSeq || 0), Infinity);
633:         }
634:         const relativeSeq = Math.max(0, lastSelectionSeq - minSeqInPool);
635:         const cappedRelativeSeq = Math.min(relativeSeq, 100);
636:         const sequenceScore = cappedRelativeSeq * 1000;
637: 
638:         // 惩罚项 C: 负载 (每个活跃请求增加 5 秒权重)
639:         const loadScore = (state.activeCount || 0) * 5000;
640: 
641:         // 新鲜节点的微调：配合 usageScore 和 sequenceScore 在多个新鲜节点间轮询
642:         const freshBonus = isFresh ? (now - lastHealthCheckTime) : 0;
643: 
644:         return baseScore + usageScore + sequenceScore + loadScore + freshBonus;
645:     }
646: 
```

---

### 🤖 Assistant — 2026-09-15 20:39:00

> Let me get the selectProvider method - the core routing logic.

Reading the selectProvider method and failover chain.

**tool:read** (completed) AIClient2API/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js; limit=300; offset=750
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js</path>
<type>file</type>
<content>
750:             await axios.post(webhookUrl, payload, {
751:                 timeout: 5000,
752:                 headers: { 'Content-Type': 'application/json' }
753:             });
754:             this._log('info', `Health alert sent to webhook for ${customName}: ${status}`);
755:         } catch (error) {
756:             this._log('error', `Failed to send health alert to webhook: ${error.message}`);
757:         }
758:     }
759: 
760:     /**
761:      * 查找指定的 provider
762:      * @private
763:      */
764:     _findProvider(providerType, uuid) {
765:         if (!providerType || !uuid) {
766:             this._log('error', `Invalid parameters: providerType=${providerType}, uuid=${uuid}`);
767:             return null;
768:         }
769:         const pool = this.providerStatus[providerType];
770:         return pool?.find(p => p.uuid === uuid) || null;
771:     }
772: 
773:     /**
774:      * 根据 UUID 在所有池中查找提供商配置
775:      * @param {string} uuid - 提供商 UUID
776:      * @returns {object|null} 提供商配置对象或 null
777:      */
778:     findProviderByUuid(uuid) {
779:         if (!uuid) return null;
780:         for (const type in this.providerStatus) {
781:             const provider = this.providerStatus[type].find(p => p.uuid === uuid);
782:             if (provider) return provider.config;
783:         }
784:         return null;
785:     }
786: 
787:     /**
788:      * Initializes the status for each provider in the pools.
789:      * Initially, all providers are considered healthy and have zero usage.
790:      * @param {boolean} syncFromConfig - 是否强制从配置同步统计数据（不保留内存中的旧数据）
791:      */
792:     initializeProviderStatus(syncFromConfig = false) {
793:         const oldFullStatus = this.providerStatus || {};
794:         const isColdStart = Object.keys(oldFullStatus).length === 0;
795:         this.providerStatus = {}; // Tracks health and usage for each provider instance
796:         for (const providerType in this.providerPools) {
797:             const oldStatus = oldFullStatus[providerType] || [];
798:             this.providerStatus[providerType] = [];
799:             this.roundRobinIndex[providerType] = 0; // Initialize round-robin index for each type
800:             // 只有在锁不存在时才初始化，避免在运行中被重置导致并发问题
801:             if (!this._selectionLocks[providerType]) {
802:                 this._selectionLocks[providerType] = Promise.resolve();
803:             }
804:             
805:             const pool = this.providerPools[providerType];
806:             
807:             // 如果是同步配置，主动使该类型下所有已有的服务适配器失效，确保代理等设置能即时生效
808:             if (syncFromConfig) {
809:                 this._log('info', `Syncing config for type ${providerType}, invalidating existing service adapters to apply new proxy settings.`);
810:                 pool.forEach(config => {
811:                     if (config.uuid) {
812:                         invalidateServiceAdapter(providerType, config.uuid);
813:                     }
814:                 });
815:             }
816:             
817:             pool.forEach((providerConfig) => {
818:                 try {
819:                     // 尝试从旧状态中恢复活跃请求计数和队列，避免重载配置时重置并发限制
820:                     const existing = oldStatus.find(p => p.uuid === providerConfig.uuid);
821: 
822:                     // Ensure initial health and usage stats are present in the config
823:                     providerConfig.isHealthy = providerConfig.isHealthy !== undefined ? providerConfig.isHealthy : true;
824:                     providerConfig.isDisabled = providerConfig.isDisabled !== undefined ? providerConfig.isDisabled : false;
825:                     
826:                     // --- V3: 统计数据管理 ---
827:                     if (isColdStart && !syncFromConfig) {
828:                         // 冷启动：清空所有统计数据，确保重启后计数重置
829:                         providerConfig.lastUsed = null;
830:                         providerConfig.usageCount = 0;
831:                         providerConfig.errorCount = 0;
832:                         // providerConfig.lastErrorTime = null;
833:                         // providerConfig.lastErrorMessage = null;
834:                     } else if (syncFromConfig) {
835:                         // 强制同步：从配置中恢复统计数据
836:                         providerConfig.lastUsed = providerConfig.lastUsed || null;
837:                         providerConfig.usageCount = providerConfig.usageCount || 0;
838:                         providerConfig.errorCount = providerConfig.errorCount || 0;
839:                         providerConfig.lastErrorTime = providerConfig.lastErrorTime || null;
840:                         providerConfig.lastErrorMessage = providerConfig.lastErrorMessage || null;
841:                     } else if (existing) {
842:                         // 热重载：从旧状态中恢复统计数据，避免被配置文件中的旧数据覆盖
843:                         providerConfig.lastUsed = existing.config.lastUsed;
844:                         providerConfig.usageCount = existing.config.usageCount;
845:                         providerConfig.errorCount = existing.config.errorCount;
846:                         providerConfig.lastErrorTime = existing.config.lastErrorTime;
847:                         providerConfig.lastErrorMessage = existing.config.lastErrorMessage;
848:                     } else {
849:                         // 新增节点或默认初始化
850:                         providerConfig.lastUsed = providerConfig.lastUsed || null;
851:                         providerConfig.usageCount = providerConfig.usageCount || 0;
852:                         providerConfig.errorCount = providerConfig.errorCount || 0;
853:                     }
854:                     
855:                     // --- V2: 刷新监控字段 ---
856:                     const persistedNeedsRefresh = providerConfig.needsRefresh !== undefined ? providerConfig.needsRefresh : false;
857:                     const persistedRefreshCount = providerConfig.refreshCount !== undefined ? providerConfig.refreshCount : 0;
858:                     if (isColdStart && (persistedNeedsRefresh || persistedRefreshCount > 0)) {
859:                         this._log('info', `Resetting stale refresh state for provider ${this._getDisplayName(providerConfig)} (${providerType}) on startup.`);
860:                     }
861:                     providerConfig.needsRefresh = isColdStart ? false : persistedNeedsRefresh;
862:                     providerConfig.refreshCount = isColdStart ? 0 : persistedRefreshCount;
863:                     
864:                     // 优化2: 简化 lastErrorTime 处理逻辑
865:                     providerConfig.lastErrorTime = providerConfig.lastErrorTime instanceof Date
866:                         ? providerConfig.lastErrorTime.toISOString()
867:                         : (providerConfig.lastErrorTime || null);
868:                     
869:                     // 健康检测相关字段
870:                     providerConfig.lastHealthCheckTime = providerConfig.lastHealthCheckTime || null;
871:                     providerConfig.lastHealthCheckModel = providerConfig.lastHealthCheckModel || null;
872:                     providerConfig.lastErrorMessage = providerConfig.lastErrorMessage || null;
873:                     providerConfig.customName = providerConfig.customName || null;
874: 
875:                     this.providerStatus[providerType].push({
876:                         config: providerConfig,
877:                         uuid: providerConfig.uuid, // Still keep uuid at the top level for easy access
878:                         type: providerType, // 保存 providerType 引用
879:                         state: existing ? existing.state : {
880:                             activeCount: 0,
881:                             waitingCount: 0,
882:                             queue: []
883:                         }
884:                     });
885:                 } catch (nodeError) {
886:                     logger.error(`[ProviderPoolManager] Error initializing node for ${providerType}: ${nodeError.message}`);
887:                 }
888:             });
889:             
890:             // 确保初始化时的默认值补全也能写盘
891:             this._debouncedSave(providerType);
892:         }
893:         this._log('info', `Initialized provider statuses: ok (maxErrorCount: ${this.maxErrorCount})`);
894:     }
895: 
896:     /**
897:      * 获取一个可用的提供商插槽，考虑并发限制和队列
898:      * @param {string} providerType 
899:      * @param {string} requestedModel 
900:      * @param {object} options 
901:      */
902:     async acquireSlot(providerType, requestedModel = null, options = {}) {
903:         // 使用 selectProvider 进行初次选择（评分逻辑已经包含了并发考虑）
904:         const selectedConfig = await this.selectProvider(providerType, requestedModel, { ...options, skipUsageCount: true });
905:         
906:         if (!selectedConfig) {
907:             return null;
908:         }
909: 
910:         const provider = this._findProvider(providerType, selectedConfig.uuid);
911:         if (!provider) return selectedConfig;
912: 
913:         const config = provider.config;
914:         const state = provider.state;
915:         const concurrencyLimit = parseInt(config.concurrencyLimit || 0);
916:         const queueLimit = parseInt(config.queueLimit || 0);
917: 
918:         // 如果没有限制，直接增加活跃计数并返回
919:         if (concurrencyLimit <= 0) {
920:             state.activeCount++;
921:             return config;
922:         }
923: 
924:         // 检查是否在并发限制内
925:         if (state.activeCount < concurrencyLimit) {
926:             state.activeCount++;
927:             return config;
928:         }
929: 
930:         // 超过并发限制，尝试进入队列
931:         if (queueLimit > 0 && state.waitingCount < queueLimit) {
932:             this._log('info', `[Concurrency] Node ${this._getDisplayName(config)} busy (${state.activeCount}/${concurrencyLimit}), enqueuing request (queue: ${state.waitingCount + 1}/${queueLimit})`);
933:             
934:             state.waitingCount++;
935:             try {
936:                 // 等待释放信号
937:                 await new Promise((resolve, reject) => {
938:                     // 设置较短的超时用于测试验证，或者由外部控制
939:                     const timeoutMs = options.queueTimeout || 300000;
940:                     const timeout = setTimeout(() => {
941:                         const idx = state.queue.indexOf(handler);
942:                         if (idx !== -1) {
943:                             state.queue.splice(idx, 1);
944:                             reject(new Error(`Queue timeout after ${timeoutMs/1000}s`));
945:                         }
946:                     }, timeoutMs);
```

---

### 🤖 Assistant — 2026-09-15 20:39:06

> Now let me get the rest of selectProvider and the rate limiting patterns.

**tool:read** (completed) AIClient2API/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js; limit=200; offset=1049
--- output ---
<path>/home/x3/workspace/AIClient2API/src/providers/provider-pool-manager.js</path>
<type>file</type>
<content>
1049:         // 如果指定了模型，则排除不支持该模型的提供商
1050:         if (requestedModel) {
1051:             const modelFilteredProviders = availableAndHealthyProviders.filter(p => {
1052:                 const supportedModels = getConfiguredSupportedModels(providerType, p.config);
1053:                 if (supportedModels.length > 0) {
1054:                     return supportedModels.includes(requestedModel);
1055:                 }
1056:                 // 如果提供商没有配置 notSupportedModels，则认为它支持所有模型
1057:                 if (!p.config.notSupportedModels || !Array.isArray(p.config.notSupportedModels)) {
1058:                     return true;
1059:                 }
1060:                 // 检查 notSupportedModels 数组中是否包含请求的模型，如果包含则排除
1061:                 return !p.config.notSupportedModels.includes(requestedModel);
1062:             });
1063: 
1064:             if (modelFilteredProviders.length === 0) {
1065:                 this._log('warn', `No available providers for type: ${providerType} that support model: ${requestedModel}`);
1066:                 return null;
1067:             }
1068: 
1069:             availableAndHealthyProviders = modelFilteredProviders;
1070:             this._log('debug', `Filtered ${modelFilteredProviders.length} providers supporting model: ${requestedModel}`);
1071:         }
1072: 
1073:         if (availableAndHealthyProviders.length === 0) {
1074:             this._log('warn', `No available and healthy providers for type: ${providerType}`);
1075:             return null;
1076:         }
1077: 
1078:         // 改进：使用统一的评分策略进行选择
1079:         // 传入当前时间戳 now 确保一致性
1080:         const selected = availableAndHealthyProviders.sort((a, b) => {
1081:             const scoreA = this._calculateNodeScore(a, now, minSeq);
1082:             const scoreB = this._calculateNodeScore(b, now, minSeq);
1083:             if (scoreA !== scoreB) return scoreA - scoreB;
1084:             // 如果分值相同，使用 UUID 排序确保确定性
1085:             return a.uuid < b.uuid ? -1 : 1;
1086:         })[0];
1087: 
1088:         // 始终更新 lastUsed（确保 LRU 策略生效，避免并发请求选到同一个 provider）
1089:         // usageCount 只在请求成功后才增加（由 skipUsageCount 控制）
1090:         selected.config.lastUsed = new Date().toISOString();
1091:         
1092:         // 更新自增序列号，确保即使毫秒级并发，也能在下一轮排序中被区分开
1093:         this._selectionSequence++;
1094:         selected.config._lastSelectionSeq = this._selectionSequence;
1095:         
1096:         // 强制打印选中日志，方便排查并发问题
1097:         this._log('info', `[Concurrency Control] Atomic selection: ${this._getDisplayName(selected.config)} (Seq: ${this._selectionSequence})`);
1098: 
1099:         if (!options.skipUsageCount) {
1100:             selected.config.usageCount++;
1101:         }
1102:         // 使用防抖保存（文件 I/O 是异步的，但内存已经更新）
1103:         this._debouncedSave(providerType);
1104: 
1105:         this._log('debug', `Selected provider for ${providerType} (LRU): ${this._getDisplayName(selected.config)}${requestedModel ? ` for model: ${requestedModel}` : ''}${options.skipUsageCount ? ' (skip usage count)' : ''}`);
1106:         
1107:         return selected.config;
1108:     }
1109: 
1110:     /**
1111:      * 获取一个可用的提供商插槽，支持 Fallback 机制
1112:      */
1113:     async acquireSlotWithFallback(providerType, requestedModel = null, options = {}) {
1114:         if (!providerType || typeof providerType !== 'string') {
1115:             this._log('error', `Invalid providerType: ${providerType}`);
1116:             return null;
1117:         }
1118: 
1119:         const triedTypes = new Set();
1120:         const typesToTry = [providerType];
1121:         
1122:         const fallbackTypes = this.fallbackChain[providerType] || [];
1123:         if (Array.isArray(fallbackTypes)) {
1124:             typesToTry.push(...fallbackTypes);
1125:         }
1126: 
1127:         for (const currentType of typesToTry) {
1128:             if (triedTypes.has(currentType)) continue;
1129:             triedTypes.add(currentType);
1130: 
1131:             if (!this.providerStatus[currentType] || this.providerStatus[currentType].length === 0) {
1132:                 continue;
1133:             }
1134: 
1135:             if (currentType !== providerType && requestedModel) {
1136:                 const primaryProtocol = getProtocolPrefix(providerType);
1137:                 const fallbackProtocol = getProtocolPrefix(currentType);
1138:                 if (primaryProtocol !== fallbackProtocol) continue;
1139: 
1140:                 const supportedModels = getProviderModels(currentType);
1141:                 if (supportedModels.length > 0 && !supportedModels.includes(requestedModel)) continue;
1142:             }
1143: 
1144:             // 尝试获取插槽
1145:             try {
1146:                 const selectedConfig = await this.acquireSlot(currentType, requestedModel, options);
1147:                 if (selectedConfig) {
1148:                     if (currentType !== providerType) {
1149:                         this._log('info', `Fallback Slot activated (Chain): ${providerType} -> ${currentType} (node: ${this._getDisplayName(selectedConfig)})`);
1150:                     }
1151:                     return {
1152:                         config: selectedConfig,
1153:                         actualProviderType: currentType,
1154:                         isFallback: currentType !== providerType
1155:                     };
1156:                 }
1157:             } catch (err) {
1158:                 if (err.status === 429) {
1159:                     // 如果是因为 429 (并发/队列满)，尝试下一个 Fallback
1160:                     this._log('info', `Type ${currentType} busy (429), trying next fallback...`);
1161:                     continue;
1162:                 }
1163:                 throw err; // 其他错误抛出
1164:             }
1165:         }
1166: 
1167:         // Model Fallback Mapping
1168:         if (requestedModel && this.modelFallbackMapping && this.modelFallbackMapping[requestedModel]) {
1169:             const mapping = this.modelFallbackMapping[requestedModel];
1170:             const targetProviderType = mapping.targetProviderType;
1171:             const targetModel = mapping.targetModel;
1172: 
1173:             if (targetProviderType && targetModel) {
1174:                 if (this.providerStatus[targetProviderType] && this.providerStatus[targetProviderType].length > 0) {
1175:                     try {
1176:                         const selectedConfig = await this.acquireSlot(targetProviderType, targetModel, options);
1177:                         if (selectedConfig) {
1178:                             return {
1179:                                 config: selectedConfig,
1180:                                 actualProviderType: targetProviderType,
1181:                                 isFallback: true,
1182:                                 actualModel: targetModel
1183:                             };
1184:                         }
1185:                     } catch (err) {
1186:                         // 如果目标类型繁忙，尝试它的 fallback chain
1187:                         const targetFallbackTypes = this.fallbackChain[targetProviderType] || [];
1188:                         for (const fallbackType of targetFallbackTypes) {
1189:                              const targetProtocol = getProtocolPrefix(targetProviderType);
1190:                              const fallbackProtocol = getProtocolPrefix(fallbackType);
1191:                              if (targetProtocol !== fallbackProtocol) continue;
1192:                              
1193:                              const supportedModels = getProviderModels(fallbackType);
1194:                              if (supportedModels.length > 0 && !supportedModels.includes(targetModel)) continue;
1195:                              
1196:                              try {
1197:                                 const fallbackSelectedConfig = await this.acquireSlot(fallbackType, targetModel, options);
1198:                                 if (fallbackSelectedConfig) {
1199:                                     return {
1200:                                         config: fallbackSelectedConfig,
1201:                                         actualProviderType: fallbackType,
1202:                                         isFallback: true,
1203:                                         actualModel: targetModel
1204:                                     };
1205:                                 }
1206:                              } catch (e) {
1207:                                  continue;
1208:                              }
1209:                         }
1210:                     }
1211:                 }
1212:             }
1213:         }
1214: 
1215:         return null;
1216:     }
1217: 
1218:     /**
1219:      * Selects a provider from the pool with fallback support.
1220:      * When the primary provider type has no healthy providers, it will try fallback types.
1221:      * @param {string} providerType - The primary type of provider to select.
1222:      * @param {string} [requestedModel] - Optional. The model name to filter providers by.
1223:      * @param {Object} [options] - Optional. Additional options.
1224:      * @param {boolean} [options.skipUsageCount] - Optional. If true, skip incrementing usage count.
1225:      * @returns {object|null} An object containing the selected provider's configuration and the actual provider type used, or null if no healthy provider is found.
1226:      */
1227:     /**
1228:      * Selects a provider from the pool with fallback support.
1229:      * When the primary provider type has no healthy providers, it will try fallback types.
1230:      *
1231:      * 注意：此方法现在返回 Promise，因为内部调用的 selectProvider 是异步的。
1232:      *
1233:      * @param {string} providerType - The primary type of provider to select.
1234:      * @param {string} [requestedModel] - Optional. The model name to filter providers by.
1235:      * @param {Object} [options] - Optional. Additional options.
1236:      * @param {boolean} [options.skipUsageCount] - Optional. If true, skip incrementing usage count.
1237:      * @returns {Promise<object|null>} An object containing the selected provider's configuration and the actual provider type used, or null if no healthy provider is found.
1238:      */
1239:     async selectProviderWithFallback(providerType, requestedModel = null, options = {}) {
1240:         // 参数校验
1241:         if (!providerType || typeof providerType !== 'string') {
1242:             this._log('error', `Invalid providerType: ${providerType}`);
1243:             return null;
1244:         }
1245: 
```

---

### 🤖 Assistant — 2026-09-15 20:39:15

> Now I have a good understanding of the key patterns. Let me also check the health check and cooldown patterns.

Now I have enough context. Here's the concise summary:

---

## AIClient2API Key Patterns

### 1. Provider Pool — Weighted LRU Score Selection

Not simple round-robin. `selectProvider` sorts healthy nodes by composite score (`_calculateNodeScore`):

- **Health gate**: unhealthy/disabled = score `1e18` (always last)
- **Freshness bonus**: nodes health-checked <60s ago get negative offset (`-1e14`) — preferred
- **LRU base**: `lastUsed` timestamp for stale nodes
- **Usage penalty**: +10s weight per use
- **Concurrency penalty**: +5s per active request; +∞ if queue full
- **Sequence breaker**: auto-increment seq ensures no two concurrent requests pick the same node

Mutex lock (`_isSelecting` flag) prevents race conditions during selection. Atomic `lastUsed` + `_lastSelectionSeq` update happens inside lock.

### 2. Two-Tier Fallback

- **Intra-type**: `selectProvider` picks best node within same provider type
- **Cross-type**: `acquireSlotWithFallback` walks `fallbackChain[providerType]` array, trying each type. On 429 (queue full), continues to next. Protocol prefix must match (`getProtocolPrefix`), preventing Gemini credentials hitting OpenAI endpoints
- **Model fallback**: After type chain exhausted, tries `modelFallbackMapping[requestedModel]` — remaps to different provider type + model name

### 3. Concurrency Control with Queue

`acquireSlot` implements semaphore + queue per node:
- `concurrencyLimit` controls max active requests
- `queueLimit` controls max waiting (with 300s timeout)
- `releaseSlot` signals next waiter via `state.queue.shift()` + `setImmediate`

### 4. Config Management — Three-Layer Merge

```
defaults → config.json → CLI args
```
- `Object.assign(defaultConfig, loaded, cliArgs)` — simple, predictable
- Provider normalization: dedupes, validates against `MODEL_PROVIDER` constants, supports prefix-matching for custom groups (e.g. `openai-custom-1`)
- Hot-reload supported: `initializeProviderStatus(syncFromConfig)` preserves in-memory stats (activeCount, usageCount, errorCount) when config file changes, only updates provider list

### 5. Token Refresh — Buffered Queue with Concurrency Gates

- **Buffer queue**: 5s debounce + Map dedup before actual refresh — prevents thundering herd
- **Two-level concurrency**: global limit (default 2 parallel providers) + per-provider limit (default 1)
- **Refresh budget**: Max 5 attempts per node, then mark unhealthy
- **30s cooldown**: After refresh, `lastRefreshTime` prevents immediate re-refresh trigger
- **Timeout protection**: `_awaitRefreshWithTimeout` wraps each adapter call

### 6. Rate Limit / Error Handling

- `errorCount` per node, `MAX_ERROR_COUNT` (default 10) triggers unhealthy
- `RATE_LIMIT_COOLDOWN` with jitter: configurable cooldown + random jitter after 429
- `EMPTY_RESPONSE_MAX_RETRIES` (2) separate from credential-switch retries (5)
- Webhook alerts on health state transitions

### 7. Master Process — Exponential Backoff Restart

`master.js` forks worker as child process with IPC. On crash: restart delay = `min(1000 * 2^restartCount, 30000)` — classic exponential backoff with cap at 30s, max 10 attempts. Graceful shutdown sends `SIGTERM` first, 5s timeout then `SIGKILL`.

---

**Most transferable patterns for BlacklistedAIProxy:**
1. Weighted score selection (not random) with concurrency awareness
2. Buffered/deduped token refresh queue with global + per-provider concurrency gates
3. Protocol-prefix guard preventing cross-protocol fallback
4. Config hot-reload preserving in-memory runtime state
5. Two-level semaphore (active + queue) per provider node

---
