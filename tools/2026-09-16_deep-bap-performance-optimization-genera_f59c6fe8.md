# Deep BAP performance optimization (@general subagent)

- **Session ID:** `ses_f59c6fe82ffe2yPR6IXODfyqFN`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-16 01:59:08
- **Last activity:** 2026-09-16 02:00:13
- **Messages:** 5

---

### 🧑 User — 2026-09-16 01:59:09

Deep-dive performance optimization for BlacklistedAIProxy at /home/x3/workspace/BlacklistedAIProxy. Find advanced optimizations beyond basic ones.

Check these specific areas:

1. **Event loop blocking**: 
   - `grep -rn "JSON.parse\|JSON.stringify" src/ --include="*.js"` — count per-file
   - `grep -rn "fs\.\(read\|write\|stat\|exists\)" src/ --include="*.js"` — find sync ops
   - Check `src/utils/logger.js` for formatMessage overhead

2. **Memory leaks**:
   - Check for growing arrays/maps without cleanup
   - Check event listener accumulation
   - Check `setInterval`/`setTimeout` without cleanup
   - `grep -rn "setInterval\|setTimeout" src/ --include="*.js"`

3. **Connection pooling**:
   - Check `src/services/service-manager.js` for HTTP client reuse
   - Check if axios/fetch instances are shared or created per-request
   - Check DNS caching

4. **Hot path optimization**:
   - `src/utils/common.js` — model resolution, custom model lookup frequency
   - `src/providers/provider-pool-manager.js` — provider selection on every request
   - Check for unnecessary string operations in request routing

5. **Startup optimization**:
   - Check if provider health checks can be lazy-loaded
   - Check if config parsing can be cached
   - Check `src/core/master.js` for worker spawn overhead

6. **Garbage collection**:
   - Check for large buffer allocations
   - Check stream handling (request/response bodies)
   - Check if request bodies are fully buffered vs streamed

Return: exact file:line findings with code snippets, impact assessment, and concrete fix suggestions.

---

### 🤖 Assistant — 2026-09-16 01:59:13

> The user wants a deep-dive performance optimization analysis of BlacklistedAIProxy. Let me first check if the brainstorming skill applies here, but this is an analysis/review task, not a creative/building task. Let me also check if systematic-debugging applies.
> 
> Actually, looking at this more carefully - this is an analysis task. The user wants me to trace behavior and find performance issues. Let me check if the systematic-debugging skill or pr-reviewer skill might apply.
> 
> But actually, the user is asking for a specific codebase analysis. Let me just do the work directly - search the codebase systematically.
> 
> Let me start by exploring the project structure and running the specific grep commands they asked for.

**tool:todowrite** (completed) 6 todos

```
todos=[{'content': 'Event loop blocking: JSON.parse/stringify counts, sync FS ops, log
--- output ---
[
  {
    "content": "Event loop blocking: JSON.parse/stringify counts, sync FS ops, logger overhead",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Memory leaks: growing arrays/maps, event listener accumulation, timers without cleanup",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Connection pooling: HTTP client reuse, axios instances, DNS caching",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Hot path optimization: model resolution, provider selection, string ops in routing",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Startup optimization: lazy health checks, config caching, worker spawn overhead",
    "status": "pending",
    "priority": "medium"
  },
  {
    "content": "Garbage collection: large buffers, stream handling, request body buffering",
    "status": "pending",
    "priority": "medium"
  }
]
```

---

### 🤖 Assistant — 2026-09-16 01:59:23

> Let me start by running all the grep commands and reading key files in parallel.

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "JSON.parse\|JSON.stringify" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "JSON.parse\|JSON.stringify; description=Count JSON.parse/stringify calls
--- output ---
src/providers/grok/ws-imagine.js:73:            ws.send(JSON.stringify(resetPayload));
src/providers/grok/ws-imagine.js:103:                ws.send(JSON.stringify(payload));
src/providers/grok/ws-imagine.js:109:                const msg = JSON.parse(data.toString());
src/providers/grok/grok-core.js:75:        ? JSON.stringify(requestBody.tools) : "";
src/providers/grok/grok-core.js:305:                    parts.push(`[tool_call] ${fn.name || call.name} ${typeof fn.arguments === 'string' ? fn.arguments : JSON.stringify(fn.arguments)}`);
src/providers/grok/grok-core.js:468:            const detail = error.response?.data ? JSON.stringify(error.response.data) : error.message;
src/providers/grok/grok-core.js:521:            const detail = error.response?.data ? JSON.stringify(error.response.data) : error.message;
src/providers/grok/grok-core.js:750:                    // logger.info(`[Grok Raw Output] Response chunk: ${JSON.stringify(resp)}`);
src/providers/grok/grok-core.js:793:                                    const parsed = JSON.parse(raw);
src/providers/grok/grok-core.js:819:                        const parsed = typeof resp.cardAttachment.jsonData === 'string' ? JSON.parse(resp.cardAttachment.jsonData) : resp.cardAttachment.jsonData;
src/providers/grok/grok-core.js:878:                        const parsed = typeof att.jsonData === 'string' ? JSON.parse(att.jsonData) : att.jsonData;
src/providers/grok/grok-core.js:897:                        const parsed = typeof att.jsonData === 'string' ? JSON.parse(att.jsonData) : att.jsonData;
src/providers/grok/grok-core.js:923:                        const parsed = JSON.parse(raw);
src/providers/grok/grok-core.js:1089:            const jsonStr = JSON.stringify(cardData);
src/providers/grok/grok-core.js:1099:                logger.info(`[Grok WS Raw] Item: ${JSON.stringify(item)}`);
src/providers/grok/grok-core.js:1176:                // logger.info(`[Grok WS Stream Raw] Item: ${JSON.stringify(item)}`);
src/providers/grok/grok-core.js:1241:                                    jsonData: JSON.stringify(cardData)
src/providers/grok/grok-core.js:1355:                    const json = JSON.parse(dataStr);
src/providers/grok/grok-core.js:1382:                                const parsed = typeof resp.cardAttachment.jsonData === 'string' ? JSON.parse(resp.cardAttachment.jsonData) : resp.cardAttachment.jsonData;
src/providers/grok/grok-core.js:1398:                                    const parsed = JSON.parse(raw);
src/providers/grok/grok-core.js:1447:                    const s = JSON.stringify(this._grokLastStreamJsonForDebug);
src/providers/provider-pool-manager.js:169:                        const credData = JSON.parse(fileContent);
src/providers/provider-pool-manager.js:2356:                    currentPools = JSON.parse(fileContent);
src/providers/provider-pool-manager.js:2390:                await atomicWriteFile(filePath, JSON.stringify(currentPools, null, 2), 'utf8');
src/providers/claude/claude-core.js:181:                            const parsedChunk = JSON.parse(data);
src/providers/claude/claude-kiro.js:350:        const argumentsObj = JSON.parse(repairedJson);
src/providers/claude/claude-kiro.js:362:                arguments: JSON.stringify(argumentsObj)
src/providers/claude/claude-kiro.js:459:                const parsedCreds = JSON.parse(decodedCreds);
src/providers/claude/claude-kiro.js:554:                return JSON.parse(fileContent);
src/providers/claude/claude-kiro.js:556:                logger.warn('[Kiro Auth] JSON parse failed, attempting repair...');
src/providers/claude/claude-kiro.js:559:                    const result = JSON.parse(repaired);
src/providers/claude/claude-kiro.js:691:            existingData = JSON.parse(fileContent);
src/providers/claude/claude-kiro.js:693:            logger.warn('[Kiro Auth] JSON parse failed, attempting repair...');
src/providers/claude/claude-kiro.js:696:                existingData = JSON.parse(repaired);
src/providers/claude/claude-kiro.js:718:    await fs.writeFile(filePath, JSON.stringify(mergedData, null, 2), 'utf8');
src/providers/claude/claude-kiro.js:1428:        // fs.writeFile('claude-kiro-request'+Date.now()+'.json', JSON.stringify(request));
src/providers/claude/claude-kiro.js:1463:                    const eventData = JSON.parse(jsonCandidate);
src/providers/claude/claude-kiro.js:1482:                                const args = JSON.parse(currentToolCallDict.function.arguments);
src/providers/claude/claude-kiro.js:1483:                                currentToolCallDict.function.arguments = JSON.stringify(args);
src/providers/claude/claude-kiro.js:1645:            if (error.response && error.response.data) { logger.error('[Kiro] 400 Response body:', typeof error.response.data === 'string' ? error.response.data.substring(0, 500) : JSON.stringify(error.response.data).substring(0, 500)); }
src/providers/claude/claude-kiro.js:1663:            return JSON.stringify(data);
src/providers/claude/claude-kiro.js:1894:        //logger.info(`[Kiro] Final tool calls after deduplication: ${JSON.stringify(uniqueToolCalls)}`);
src/providers/claude/claude-kiro.js:2018:                const parsed = JSON.parse(jsonStr);
src/providers/claude/claude-kiro.js:2523:                                    parsedInput = JSON.parse(currentToolCall.input);
src/providers/claude/claude-kiro.js:2578:                                parsedInput = JSON.parse(currentToolCall.input);
src/providers/claude/claude-kiro.js:2625:                            parsedInput = JSON.parse(currentToolCall.input);
src/providers/claude/claude-kiro.js:2649:                    parsedInput = JSON.parse(currentToolCall.input);
src/providers/claude/claude-kiro.js:2704:                        input: JSON.parse(btc.function.arguments || '{}')
src/providers/claude/claude-kiro.js:2721:                outputTokens += this.countTextTokens(JSON.stringify(tc.input || {}));
src/providers/claude/claude-kiro.js:2844:                        inputObject = typeof args === 'string' ? JSON.parse(args) : args;
src/providers/claude/claude-kiro.js:2870:                            partial_json: JSON.stringify(inputObject)
src/providers/claude/claude-kiro.js:2879:                    totalOutputTokens += this.countTextTokens(JSON.stringify(inputObject));
src/providers/claude/claude-kiro.js:2934:                        inputObject = typeof args === 'string' ? JSON.parse(args) : args;
src/providers/claude/claude-kiro.js:3113:                    errorMessage = typeof responseData.error === 'string' ? responseData.error : responseData.error.message || JSON.stringify(responseData.error);
src/providers/lmarena/lmarena-core.js:211:                    yield JSON.parse(jsonData);
src/providers/lmarena/lmarena-core.js:224:                    yield JSON.parse(jsonData);
src/providers/openai/qwen-core.js:379:            const credentials = JSON.parse(creds);
src/providers/openai/qwen-core.js:518:                        const creds = JSON.parse(data);
src/providers/openai/qwen-core.js:557:            const credentials = JSON.parse(creds);
src/providers/openai/qwen-core.js:572:            const credString = JSON.stringify(credentials, null, 2);
src/providers/openai/qwen-core.js:850:                        yield JSON.parse(jsonData);
src/providers/openai/qwen-core.js:1011:            context.memoryCache.credentials = JSON.parse(content);
src/providers/openai/qwen-core.js:1083:            await fs.writeFile(context.credentialFilePath, JSON.stringify(credentials, null, 2), { mode: 0o600 });
src/providers/openai/openai-strategy.js:41:                    return JSON.stringify(content);
src/providers/openai/openai-core.js:149:                            const parsedChunk = JSON.parse(jsonData);
src/providers/openai/codex-core.js:77:                creds = JSON.parse(await fs.readFile(credsPath, 'utf8'));
src/providers/openai/codex-core.js:93:                creds = JSON.parse(await fs.readFile(credsPath, 'utf8'));
src/providers/openai/codex-core.js:531:            JSON.stringify(
src/providers/openai/codex-core.js:580:                            const parsed = JSON.parse(data);
src/providers/openai/codex-core.js:596:                        const parsed = JSON.parse(data);
src/providers/openai/codex-core.js:626:                    const parsed = JSON.parse(jsonData);
src/providers/openai/openai-responses-core.js:134:                            const parsedChunk = JSON.parse(jsonData);
src/providers/openai/iflow-core.js:95:        const json = JSON.parse(data);
src/providers/openai/iflow-core.js:137:        await fs.writeFile(absolutePath, JSON.stringify(json, null, 2), 'utf-8');
src/providers/openai/iflow-core.js:189:        // logger.info('[iFlow] Token response:', JSON.stringify(tokenResp));
src/providers/openai/iflow-core.js:191:            logger.error('[iFlow] Token response:', JSON.stringify(tokenResp));
src/providers/openai/iflow-core.js:253:        // logger.info('[iFlow] User info response:', JSON.stringify(result));
src/providers/openai/iflow-core.js:934:                            const parsedChunk = JSON.parse(jsonData);
src/providers/openai/iflow-core.js:957:                            const parsedChunk = JSON.parse(jsonData);
src/providers/gemini/gemini-core.js:55:        const data = typeof errorBody === 'string' ? JSON.parse(errorBody) : errorBody;
src/providers/gemini/gemini-core.js:365:                const credentials = JSON.parse(decoded);
src/providers/gemini/gemini-core.js:377:            const credentials = JSON.parse(data);
src/providers/gemini/gemini-core.js:473:                    const credentials = JSON.parse(data);
src/providers/gemini/gemini-core.js:585:                body: JSON.stringify(body),
src/providers/gemini/gemini-core.js:663:                body: JSON.stringify(body),
src/providers/gemini/gemini-core.js:741:                try { yield JSON.parse(buffer.join('\n')); } catch (e) { logger.error("[Stream] Failed to parse JSON chunk:", buffer.join('\n')); }
src/providers/gemini/gemini-core.js:746:            try { yield JSON.parse(buffer.join('\n')); } catch (e) { logger.error("[Stream] Failed to parse final JSON chunk:", buffer.join('\n')); }
src/providers/gemini/gemini-core.js:877:            await fs.writeFile(filePath, JSON.stringify(credentials, null, 2));
src/providers/gemini/gemini-core.js:933:                    body: JSON.stringify(requestBody)
src/providers/gemini/gemini-core.js:938:                // logger.info(`[Gemini] retrieveUserQuota success`, JSON.stringify(res.data));
src/providers/gemini/antigravity-core.js:231:    let template = JSON.parse(JSON.stringify(payload));
src/providers/gemini/antigravity-core.js:356:        const data = JSON.parse(jsonStr);
src/providers/gemini/antigravity-core.js:370:            return 'data: ' + JSON.stringify(data);
src/providers/gemini/antigravity-core.js:447:            data = JSON.parse(trimmed);
src/providers/gemini/antigravity-core.js:460:        responseTemplate = JSON.stringify(responseNode);
src/providers/gemini/antigravity-core.js:529:    let result = JSON.parse(responseTemplate);
src/providers/gemini/antigravity-core.js:792:            const credentials = JSON.parse(data);
src/providers/gemini/antigravity-core.js:883:                    const credentials = JSON.parse(data);
src/providers/gemini/antigravity-core.js:919:            await fs.writeFile(filePath, JSON.stringify(credentials, null, 2));
src/providers/gemini/antigravity-core.js:1016:                    body: JSON.stringify({})
```

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "fs\.\(read\|write\|stat\|exists\)" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "fs\.\(read\|write\|stat\|e; description=Find sync FS operations
--- output ---
src/providers/claude/claude-kiro.js:552:            const fileContent = await fs.readFile(filePath, 'utf8');
src/providers/claude/claude-kiro.js:608:            const files = await fs.readdir(dirPath);
src/providers/claude/claude-kiro.js:689:        const fileContent = await fs.readFile(filePath, 'utf8');
src/providers/claude/claude-kiro.js:718:    await fs.writeFile(filePath, JSON.stringify(mergedData, null, 2), 'utf8');
src/providers/claude/claude-kiro.js:1428:        // fs.writeFile('claude-kiro-request'+Date.now()+'.json', JSON.stringify(request));
src/providers/openai/qwen-core.js:378:            const creds = await fs.readFile(keyFile, 'utf-8');
src/providers/openai/qwen-core.js:517:                        const data = await fs.readFile(credPath, 'utf8');
src/providers/openai/qwen-core.js:556:            const creds = await fs.readFile(keyFile, 'utf-8');
src/providers/openai/qwen-core.js:573:            await fs.writeFile(filePath, credString);
src/providers/openai/qwen-core.js:988:            const stats = await fs.stat(context.credentialFilePath);
src/providers/openai/qwen-core.js:1010:            const content = await fs.readFile(context.credentialFilePath, 'utf-8');
src/providers/openai/qwen-core.js:1083:            await fs.writeFile(context.credentialFilePath, JSON.stringify(credentials, null, 2), { mode: 0o600 });
src/providers/openai/qwen-core.js:1084:            const stats = await fs.stat(context.credentialFilePath);
src/providers/openai/qwen-core.js:1099:                await fs.writeFile(context.lockFilePath, randomUUID(), { flag: 'wx' });
src/providers/openai/qwen-core.js:1104:                        const stats = await fs.stat(context.lockFilePath);
src/providers/openai/codex-core.js:77:                creds = JSON.parse(await fs.readFile(credsPath, 'utf8'));
src/providers/openai/codex-core.js:82:                const files = await fs.readdir(targetDir);
src/providers/openai/codex-core.js:93:                creds = JSON.parse(await fs.readFile(credsPath, 'utf8'));
src/providers/openai/codex-core.js:529:        await fs.writeFile(
src/providers/openai/iflow-core.js:94:        const data = await fs.readFile(absolutePath, 'utf-8');
src/providers/openai/iflow-core.js:137:        await fs.writeFile(absolutePath, JSON.stringify(json, null, 2), 'utf-8');
src/providers/gemini/gemini-core.js:376:            const data = await fs.readFile(credPath, "utf8");
src/providers/gemini/gemini-core.js:472:                    const data = await fs.readFile(credPath, 'utf8');
src/providers/gemini/gemini-core.js:877:            await fs.writeFile(filePath, JSON.stringify(credentials, null, 2));
src/providers/gemini/antigravity-core.js:791:            const data = await fs.readFile(credPath, "utf8");
src/providers/gemini/antigravity-core.js:882:                    const data = await fs.readFile(credPath, 'utf8');
src/providers/gemini/antigravity-core.js:919:            await fs.writeFile(filePath, JSON.stringify(credentials, null, 2));
src/services/service-manager.js:58:            if (!fs.existsSync(configsPath)) {
src/services/service-manager.js:136:        if (!fs.existsSync(absolutePath)) {
src/services/service-manager.js:225:        const files = await pfs.readdir(dirPath, { withFileTypes: true });
src/services/service-manager.js:558:        } else if (filePath && fs.existsSync(filePath)) {
src/services/service-manager.js:559:            const poolsData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
src/ui-modules/upload-config-api.js:62:        const content = await fs.readFile(fullPath, 'utf-8');
src/ui-modules/upload-config-api.js:63:        const stats = await fs.stat(fullPath);
src/ui-modules/upload-config-api.js:118:        const content = await fs.readFile(fullPath);
src/ui-modules/upload-config-api.js:217:            const items = await fs.readdir(dirPath, { withFileTypes: true });
src/ui-modules/upload-config-api.js:223:                    const content = await fs.readFile(fullPath);
src/ui-modules/auth.js:26:        const password = await fs.readFile(pwdFilePath, 'utf8');
src/ui-modules/auth.js:122:            const content = await fs.readFile(TOKEN_STORE_FILE, 'utf8');
src/ui-modules/auth.js:140:        await fs.writeFile(TOKEN_STORE_FILE, JSON.stringify(tokenStore, null, 2), 'utf8');
src/ui-modules/usage-cache.js:16:            const content = await fs.readFile(USAGE_CACHE_FILE, 'utf8');
src/ui-modules/usage-cache.js:32:        await fs.writeFile(USAGE_CACHE_FILE, JSON.stringify(usageData, null, 2), 'utf8');
src/ui-modules/update-api.js:466:                await fs.writeFile(tarballPath, buffer);
src/ui-modules/update-api.js:485:        const extractedItems = await fs.readdir(tempDir);
src/ui-modules/update-api.js:524:        const sourceItems = await fs.readdir(sourcePath);
src/ui-modules/update-api.js:538:                const stat = await fs.stat(destItemPath);
src/ui-modules/update-api.js:609:    const stat = await fs.stat(src);
src/ui-modules/update-api.js:613:        const items = await fs.readdir(src);
src/ui-modules/config-scanner.js:73:        const stats = await fs.stat(filePath);
src/ui-modules/config-scanner.js:110:            content = await fs.readFile(filePath, 'utf8');
src/ui-modules/config-scanner.js:482:        const files = await fs.readdir(dirPath, { withFileTypes: true });
src/utils/provider-utils.js:298:        const content = await fs.readFile(filePath, 'utf8');
src/utils/generate-random-fetcher.js:125:      fs.writeFileSync(outPath, JSON.stringify(result, null, 2), 'utf-8');
src/utils/common.js:557:        // fs.writeFile('request'+Date.now()+'.json', JSON.stringify(requestBody));
src/utils/common.js:878:        // fs.writeFile('oldResponseChunk'+Date.now()+'.json', fullOldResponseJson);
src/utils/common.js:879:        // fs.writeFile('responseChunk'+Date.now()+'.json', fullResponseJson);
src/utils/common.js:895:        // fs.writeFile('oldRequest'+Date.now()+'.json', JSON.stringify(requestBody));
src/utils/common.js:925:        // fs.writeFile('oldResponse'+Date.now()+'.json', JSON.stringify(clientResponse));
src/utils/common.js:1294:    // fs.writeFile('originalRequestBody'+Date.now()+'.json', JSON.stringify(originalRequestBody));
src/utils/provider-strategy.js:65:            currentSystemText = await fs.readFile(FETCH_SYSTEM_PROMPT_FILE, 'utf8');
src/utils/provider-strategy.js:74:                await fs.writeFile(FETCH_SYSTEM_PROMPT_FILE, incomingSystemText);
src/utils/provider-strategy.js:77:                await fs.writeFile(FETCH_SYSTEM_PROMPT_FILE, '');
src/utils/file-lock.js:131:        await pfs.writeFile(tempPath, data, encoding);
src/utils/tls-sidecar.js:223:                if (fs.existsSync(p) && fs.statSync(p).isFile()) {
src/utils/logger.js:60:            if (!fs.existsSync(this.config.logDir)) {
src/utils/logger.js:244:            if (!this.currentLogFile || !fs.existsSync(this.currentLogFile)) {
src/utils/logger.js:248:            const stats = fs.statSync(this.currentLogFile);
src/utils/logger.js:387:            if (!fs.existsSync(this.config.logDir)) {
src/utils/logger.js:391:            const files = fs.readdirSync(this.config.logDir)
src/utils/logger.js:396:                    time: fs.statSync(path.join(this.config.logDir, file)).mtime.getTime()
src/utils/logger.js:421:            if (!this.currentLogFile || !fs.existsSync(this.currentLogFile)) {
src/utils/logger.js:432:            fs.writeFileSync(this.currentLogFile, '');
src/plugins/model-usage-stats/stats-manager.js:197:                await fs.writeFile(tempFile, snapshot, 'utf8');
src/plugins/api-potluck/key-manager.js:255:        await fs.writeFile(tempFile, JSON.stringify(keyStore, null, 2), 'utf8');
src/scripts/kiro-idc-token-refresh.js:134:            if (fs.existsSync(jsonPath)) {
src/scripts/kiro-idc-token-refresh.js:136:                const fileContent = fs.readFileSync(jsonPath, 'utf-8');
src/scripts/kiro-idc-token-refresh.js:264:        fs.writeFileSync(outputFilePath, JSON.stringify(result, null, 2), 'utf-8');
src/scripts/kiro-token-refresh.js:167:        fs.writeFileSync(outputFilePath, JSON.stringify(result, null, 2), 'utf-8');
src/scripts/merge-json-files.js:39:    if (!fs.existsSync(targetDir)) {
src/scripts/merge-json-files.js:45:        const files = fs.readdirSync(targetDir);
src/scripts/merge-json-files.js:70:                const content = fs.readFileSync(filePath, 'utf-8');
src/scripts/merge-json-files.js:109:        fs.writeFileSync(outputFilePath, JSON.stringify(mergedData, null, 2), 'utf-8');
src/core/plugin-manager.js:76:                const content = await fs.readFile(PLUGINS_CONFIG_FILE, 'utf8');
src/core/plugin-manager.js:116:            const entries = await fs.readdir(pluginsDir, { withFileTypes: true });
src/core/plugin-manager.js:165:            await fs.writeFile(PLUGINS_CONFIG_FILE, JSON.stringify(this.pluginsConfig, null, 2), 'utf8');
src/core/plugin-manager.js:563:        const entries = await fs.readdir(pluginsDir, { withFileTypes: true });
src/core/config-manager.js:225:            const poolsData = await pfs.readFile(currentConfig.PROVIDER_POOLS_FILE_PATH, 'utf8');
src/core/config-manager.js:304:        const content = await pfs.readFile(filePath, 'utf8');
src/auth/gemini-oauth.js:424:        if (!fs.existsSync(targetDir)) {
src/auth/kiro-oauth.js:763:        if (!fs.existsSync(kiroDir)) {
src/auth/codex-oauth.js:620:            if (!fs.existsSync(targetDir)) {
src/auth/session-import.js:30:            if (fs.existsSync(CONFIG_FILE)) {
src/auth/session-import.js:31:                config = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
src/auth/session-import.js:41:        fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 4), 'utf8');
```

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "setInterval\|setTimeout" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "setInterval\|setTimeout" s; description=Find timer usage
--- output ---
src/providers/grok/ws-imagine.js:76:            setTimeout(() => {
src/providers/grok/grok-core.js:1476:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/grok/grok-core.js:1484:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/grok/grok-core.js:1493:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/provider-pool-manager.js:299:            this.refreshBufferTimers[providerType] = setTimeout(() => {
src/providers/provider-pool-manager.js:463:        // await new Promise(resolve => setTimeout(resolve, randomDelay));
src/providers/provider-pool-manager.js:554:            timeoutId = setTimeout(() => {
src/providers/provider-pool-manager.js:909:                    const timeout = setTimeout(() => {
src/providers/provider-pool-manager.js:2284:            const timeoutId = setTimeout(() => abortController.abort(), healthCheckTimeout);
src/providers/provider-pool-manager.js:2325:        this.saveTimer = setTimeout(() => {
src/providers/claude/claude-core.js:114:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-core.js:122:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-core.js:131:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-core.js:210:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-core.js:219:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-core.js:229:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-kiro.js:1619:                await new Promise(resolve => setTimeout(resolve, baseDelay));
src/providers/claude/claude-kiro.js:1629:                await new Promise(resolve => setTimeout(resolve, baseDelay));
src/providers/claude/claude-kiro.js:1641:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/claude/claude-kiro.js:2210:                await new Promise(resolve => setTimeout(resolve, baseDelay));
src/providers/claude/claude-kiro.js:2220:                await new Promise(resolve => setTimeout(resolve, baseDelay));
src/providers/claude/claude-kiro.js:2232:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/lmarena/lmarena-core.js:161:                await new Promise(r => setTimeout(r, delay));
src/providers/lmarena/lmarena-core.js:171:                await new Promise(r => setTimeout(r, delay));
src/providers/openai/qwen-core.js:515:                const checkInterval = setInterval(async () => {
src/providers/openai/qwen-core.js:530:                setTimeout(() => {
src/providers/openai/qwen-core.js:783:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/qwen-core.js:1110:                    await new Promise(resolve => setTimeout(resolve, attemptInterval));
src/providers/openai/openai-core.js:90:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-core.js:98:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-core.js:107:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-core.js:177:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-core.js:186:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-core.js:196:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/codex-core.js:717:        this.cleanupInterval = setInterval(() => {
src/providers/openai/openai-responses-core.js:84:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-responses-core.js:92:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-responses-core.js:156:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/openai-responses-core.js:165:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:845:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:853:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:862:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:1003:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:1012:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/openai/iflow-core.js:1022:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:470:            const checkInterval = setInterval(async () => {
src/providers/gemini/gemini-core.js:485:            setTimeout(() => {
src/providers/gemini/gemini-core.js:541:                await new Promise(resolve => setTimeout(resolve, 2000));
src/providers/gemini/gemini-core.js:624:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:632:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:641:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:707:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:716:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/gemini-core.js:726:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:880:            const checkInterval = setInterval(async () => {
src/providers/gemini/antigravity-core.js:895:            setTimeout(() => {
src/providers/gemini/antigravity-core.js:977:                await new Promise(resolve => setTimeout(resolve, 2000));
src/providers/gemini/antigravity-core.js:1139:                    await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:1154:                    await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:1162:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:1243:                    await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:1260:                    await new Promise(resolve => setTimeout(resolve, delay));
src/providers/gemini/antigravity-core.js:1269:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/forward/forward-core.js:96:                await new Promise(resolve => setTimeout(resolve, delay));
src/providers/forward/forward-core.js:152:                await new Promise(resolve => setTimeout(resolve, delay));
src/services/api-server.js:214:        setTimeout(() => {
src/services/api-server.js:353:                setTimeout(() => {
src/services/api-server.js:375:            setInterval(heartbeatAndRefreshToken, CONFIG.CRON_NEAR_MINUTES * 60 * 1000);
src/services/api-server.js:409:                healthCheckTimerId = setInterval(async () => {
src/services/api-server.js:448:                    setTimeout(async () => {
src/services/api-manager.js:72:            await new Promise(resolve => setTimeout(resolve, 1000 * context.retryCount));
src/ui-modules/event-broadcast.js:53:    const keepAlive = setInterval(() => {
src/ui-modules/auth.js:433:setInterval(cleanupExpiredTokens, 5 * 60 * 1000); // 每5分钟清理一次
src/utils/common.js:761:            await new Promise(resolve => setTimeout(resolve, randomDelay));
src/utils/common.js:975:            await new Promise(resolve => setTimeout(resolve, randomDelay));
src/utils/file-lock.js:56:            setTimeout(() => reject(new Error(`Operation timeout after ${ms}ms`)), ms)
src/utils/file-lock.js:72:                await new Promise(resolve => setTimeout(resolve, delay * (i + 1)));
src/utils/tls-sidecar.js:99:                    setTimeout(() => this.start(options), RESTART_DELAY);
src/utils/tls-sidecar.js:135:                const timeout = setTimeout(() => {
src/utils/tls-sidecar.js:263:        this.healthCheckTimer = setInterval(async () => {
src/utils/tls-sidecar.js:284:    return new Promise(resolve => setTimeout(resolve, ms));
src/utils/logger.js:154:        this._contextCleanupTimer = setInterval(() => {
src/plugins/token-optimizer/index.js:130:        this._sweepTimer = setInterval(() => {
src/plugins/model-usage-stats/stats-manager.js:148:        persistTimer = setInterval(() => {
src/plugins/ai-monitor/index.js:62:                setTimeout(() => {
src/plugins/ensemble-synthesizer/fanout.js:86:        const timer = setTimeout(() => {
src/plugins/ensemble-synthesizer/index.js:313:            const timer = setTimeout(() => { req.destroy(); reject(new Error('judge timeout')); }, this._cfg.timeoutMs);
src/plugins/api-potluck/key-manager.js:219:        persistTimer = setInterval(persistIfDirty, currentPersistInterval);
src/plugins/universal-guard/budget-guard.js:60:        this._timer = setInterval(() => this._persist(), 5000);
src/plugins/universal-guard/alerting.js:113:            const timer = setTimeout(() => ctrl.abort(), REQUEST_TIMEOUT);
src/core/stealth-logic.js:72:    return new Promise(resolve => setTimeout(resolve, delay));
src/core/master.js:111:        const timeout = setTimeout(() => {
src/core/master.js:157:        await new Promise(resolve => setTimeout(resolve, config.restartDelay));
src/core/master.js:190:    setTimeout(() => {
src/auth/gemini-oauth.js:65:            setTimeout(() => {
src/auth/gemini-oauth.js:71:            const timer = setInterval(() => {
src/auth/gemini-oauth.js:145:                setTimeout(() => reject(new Error('Server close timeout after 2s')), 2000);
src/auth/gemini-oauth.js:309:            pollTimer = setInterval(() => {
src/auth/kiro-oauth.js:135:            const timer = setInterval(() => {
src/auth/kiro-oauth.js:465:                await new Promise(resolve => setTimeout(resolve, interval * 1000));
```

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "axios\|fetch\|http\.request\|https\.request" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "axios\|fetch\|http\.reques; description=Find HTTP client usage
--- output ---
src/providers/grok/grok-core.js:1:import axios from 'axios';
src/providers/grok/grok-core.js:206:    _applySidecar(axiosConfig) {
src/providers/grok/grok-core.js:207:        return configureTLSSidecar(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.GROK_CUSTOM);
src/providers/grok/grok-core.js:233:        const axiosConfig = { 
src/providers/grok/grok-core.js:243:        if (responseType) axiosConfig.responseType = responseType;
src/providers/grok/grok-core.js:245:        configureAxiosProxy(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.GROK_CUSTOM);
src/providers/grok/grok-core.js:246:        this._applySidecar(axiosConfig);
src/providers/grok/grok-core.js:248:        return await axios(axiosConfig);
src/providers/grok/grok-core.js:412:            'sec-fetch-dest': 'empty',
src/providers/grok/grok-core.js:413:            'sec-fetch-mode': 'cors',
src/providers/grok/grok-core.js:414:            'sec-fetch-site': 'same-origin',
src/providers/provider-pool-manager.js:718:            const axios = (await import('axios')).default;
src/providers/provider-pool-manager.js:719:            await axios.post(webhookUrl, payload, {
src/providers/provider-pool-manager.js:1461:                                this._log('debug', `Skipping model fetch for poolable provider ${providerType} with empty pool to avoid reading default config.`);
src/providers/provider-pool-manager.js:1478:                                const fetchedModels = convertedData.data.map(m => m.id);
src/providers/provider-pool-manager.js:1479:                                if (fetchedModels.length > 0) {
src/providers/provider-pool-manager.js:1480:                                    models = fetchedModels;
src/providers/provider-pool-manager.js:1485:                        this._log('debug', `Failed to fetch model list for ${providerType} from service: ${err.message}`);
src/providers/claude/claude-core.js:1:import axios from 'axios';
src/providers/claude/claude-core.js:49:        const axiosConfig = {
src/providers/claude/claude-core.js:62:            axiosConfig.proxy = false;
src/providers/claude/claude-core.js:66:        configureAxiosProxy(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.CLAUDE_CUSTOM);
src/providers/claude/claude-core.js:68:        return axios.create(axiosConfig);
src/providers/claude/claude-core.js:71:    _applySidecar(axiosConfig) {
src/providers/claude/claude-core.js:72:        return configureTLSSidecar(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.CLAUDE_CUSTOM, this.baseUrl);
src/providers/claude/claude-core.js:88:            const axiosConfig = {
src/providers/claude/claude-core.js:93:            this._applySidecar(axiosConfig);
src/providers/claude/claude-core.js:94:            const response = await this.client.request(axiosConfig);
src/providers/claude/claude-core.js:153:            const axiosConfig = {
src/providers/claude/claude-core.js:159:            this._applySidecar(axiosConfig);
src/providers/claude/claude-core.js:160:            const response = await this.client.request(axiosConfig);
src/providers/claude/claude-kiro.js:1:import axios from 'axios';
src/providers/claude/claude-kiro.js:471:        this.axiosInstance = null; // Initialize later in async method
src/providers/claude/claude-kiro.js:472:        this.axiosSocialRefreshInstance = null;
src/providers/claude/claude-kiro.js:505:        const axiosConfig = {
src/providers/claude/claude-kiro.js:524:            axiosConfig.proxy = false;
src/providers/claude/claude-kiro.js:528:        configureAxiosProxy(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.KIRO_API);
src/providers/claude/claude-kiro.js:530:        this.axiosInstance = axios.create(axiosConfig);
src/providers/claude/claude-kiro.js:532:        axiosConfig.headers = new Headers();
src/providers/claude/claude-kiro.js:533:        axiosConfig.headers.set('Content-Type', KIRO_CONSTANTS.CONTENT_TYPE_JSON);
src/providers/claude/claude-kiro.js:534:        this.axiosSocialRefreshInstance = axios.create(axiosConfig);
src/providers/claude/claude-kiro.js:538:    _applySidecar(axiosConfig) {
src/providers/claude/claude-kiro.js:539:        return configureTLSSidecar(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.KIRO_API);
src/providers/claude/claude-kiro.js:756:            const axiosConfig = {
src/providers/claude/claude-kiro.js:762:            this._applySidecar(axiosConfig);
src/providers/claude/claude-kiro.js:765:                response = await this.axiosSocialRefreshInstance.request(axiosConfig);
src/providers/claude/claude-kiro.js:768:                response = await this.axiosInstance.request(axiosConfig);
src/providers/claude/claude-kiro.js:1565:            const axiosConfig = {
src/providers/claude/claude-kiro.js:1571:            this._applySidecar(axiosConfig);
src/providers/claude/claude-kiro.js:1572:            const response = await this.axiosInstance.request(axiosConfig);
src/providers/claude/claude-kiro.js:2119:            const axiosConfig = {
src/providers/claude/claude-kiro.js:2126:            this._applySidecar(axiosConfig);
src/providers/claude/claude-kiro.js:2127:            const response = await this.axiosInstance.request(axiosConfig);
src/providers/claude/claude-kiro.js:3089:        const axiosConfig = {
src/providers/claude/claude-kiro.js:3094:        this._applySidecar(axiosConfig);
src/providers/claude/claude-kiro.js:3097:            const response = await this.axiosInstance.request(axiosConfig);
src/providers/claude/claude-kiro.js:3098:            logger.info('[Kiro] Usage limits fetched successfully');
src/providers/claude/claude-kiro.js:3135:            logger.error('[Kiro] Failed to fetch usage limits:', formattedError.message, error);
src/providers/lmarena/lmarena-core.js:20:import axios from 'axios';
src/providers/lmarena/lmarena-core.js:61:        const axiosConfig = {
src/providers/lmarena/lmarena-core.js:69:        configureAxiosProxy(axiosConfig, config, MODEL_PROVIDER.LMARENA_BRIDGE);
src/providers/lmarena/lmarena-core.js:70:        this.axiosInstance = axios.create(axiosConfig);
src/providers/lmarena/lmarena-core.js:73:    _applySidecar(axiosConfig) {
src/providers/lmarena/lmarena-core.js:74:        return configureTLSSidecar(axiosConfig, this.config, MODEL_PROVIDER.LMARENA_BRIDGE, this.baseUrl);
src/providers/lmarena/lmarena-core.js:83:            const axiosConfig = { method: 'get', url: '/health', timeout: LMARENA_HEALTH_TIMEOUT_MS };
src/providers/lmarena/lmarena-core.js:84:            this._applySidecar(axiosConfig);
src/providers/lmarena/lmarena-core.js:85:            await this.axiosInstance.request(axiosConfig);
src/providers/lmarena/lmarena-core.js:102:            const axiosConfig = { method: 'get', url: '/health', timeout: LMARENA_HEALTH_TIMEOUT_MS };
src/providers/lmarena/lmarena-core.js:103:            this._applySidecar(axiosConfig);
src/providers/lmarena/lmarena-core.js:104:            await this.axiosInstance.request(axiosConfig);
src/providers/lmarena/lmarena-core.js:142:            const axiosConfig = {
src/providers/lmarena/lmarena-core.js:149:                axiosConfig.responseType = 'stream';
src/providers/lmarena/lmarena-core.js:151:            this._applySidecar(axiosConfig);
src/providers/lmarena/lmarena-core.js:152:            const response = await this.axiosInstance.request(axiosConfig);
src/providers/lmarena/lmarena-core.js:234:            const axiosConfig = {
src/providers/lmarena/lmarena-core.js:239:            this._applySidecar(axiosConfig);
src/providers/lmarena/lmarena-core.js:240:            const response = await this.axiosInstance.request(axiosConfig);
src/providers/openai/qwen-core.js:1:import axios from 'axios';
src/providers/openai/qwen-core.js:180:// 封装公共的 await fetch 方法
src/providers/openai/qwen-core.js:201:    // 注意: Node.js 的 fetch 实现会自动使用环境变量中的代理设置
src/providers/openai/qwen-core.js:204:        // 对于 Node.js fetch,我们可以通过设置 dispatcher 来控制代理
src/providers/openai/qwen-core.js:206:        logger.debug('[Qwen] System proxy disabled for fetch request');
src/providers/openai/qwen-core.js:209:    const response = await fetch(url, mergedOptions);
src/providers/openai/qwen-core.js:344:        const axiosConfig = {
src/providers/openai/qwen-core.js:356:            axiosConfig.proxy = false;
src/providers/openai/qwen-core.js:360:        configureAxiosProxy(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.QWEN_API);
src/providers/openai/qwen-core.js:362:        this.currentAxiosInstance = axios.create(axiosConfig);
src/providers/openai/qwen-core.js:368:    _applySidecar(axiosConfig) {
src/providers/openai/qwen-core.js:369:        return configureTLSSidecar(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.QWEN_API, this.baseUrl);
src/providers/openai/qwen-core.js:692:            const axiosConfig = {
src/providers/openai/qwen-core.js:695:                // axios 默认不传 proxy 配置时会遵循环境变量，这里明确控制
src/providers/openai/qwen-core.js:700:            configureAxiosProxy(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.QWEN_API);
src/providers/openai/qwen-core.js:702:            const instance = axios.create(axiosConfig);
src/providers/openai/openai-core.js:1:import axios from 'axios';
src/providers/openai/openai-core.js:34:        const axiosConfig = {
src/providers/openai/openai-core.js:46:            axiosConfig.proxy = false;
src/providers/openai/openai-core.js:50:        configureAxiosProxy(axiosConfig, config, config.MODEL_PROVIDER || MODEL_PROVIDER.OPENAI_CUSTOM);
src/providers/openai/openai-core.js:52:        this.axiosInstance = axios.create(axiosConfig);
src/providers/openai/openai-core.js:55:    _applySidecar(axiosConfig) {
src/providers/openai/openai-core.js:56:        return configureTLSSidecar(axiosConfig, this.config, this.config.MODEL_PROVIDER || MODEL_PROVIDER.OPENAI_CUSTOM, this.baseUrl);
```

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "new Map\|new Set\|\.push(\|\.splice(" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "new Map\|new Set\|\.push(\; description=Find growing data structures
--- output ---
src/providers/adapter.js:16:const adapterRegistry = new Map();
src/providers/provider-models.js:184:    return [...new Set(
src/providers/provider-models.js:291:                    models.push(m.id);
src/providers/provider-models.js:324:                allModels[targetProvider].push(m.id);
src/providers/grok/ws-imagine.js:110:                queue.push(msg);
src/providers/grok/ws-imagine.js:131:            queue.push({ type: 'error', error: err.message });
src/providers/grok/grok-core.js:294:            if (typeof content === 'string') { if (content.trim()) parts.push(content.trim()); }
src/providers/grok/grok-core.js:297:                    if (item.type === 'text' && item.text?.trim()) parts.push(item.text.trim());
src/providers/grok/grok-core.js:298:                    else if (item.type === 'image_url' && item.image_url?.url) imageAttachments.push(item.image_url.url);
src/providers/grok/grok-core.js:299:                    else if (item.type === 'file' && item.file?.file_data) localFileAttachments.push(item.file.file_data);
src/providers/grok/grok-core.js:305:                    parts.push(`[tool_call] ${fn.name || call.name} ${typeof fn.arguments === 'string' ? fn.arguments : JSON.stringify(fn.arguments)}`);
src/providers/grok/grok-core.js:308:            if (parts.length > 0) extracted.push({ role, text: parts.join("\n") });
src/providers/grok/grok-core.js:394:        if (this.cfClearance) cookie.push(`cf_clearance=${this.cfClearance}`);
src/providers/grok/grok-core.js:731:        const seenCardIds = new Set();
src/providers/grok/grok-core.js:732:        const seenImageUrls = new Set();
src/providers/grok/grok-core.js:795:                                        collected.modelResponse.cardAttachmentsJson.push(raw);
src/providers/grok/grok-core.js:798:                                } catch(e) { collected.modelResponse.cardAttachmentsJson.push(raw); }
src/providers/grok/grok-core.js:807:                                collected.generatedImageUrls.push(url);
src/providers/grok/grok-core.js:825:                            collected.cardAttachments.push(resp.cardAttachment);
src/providers/grok/grok-core.js:832:                        collected.cardAttachments.push(resp.cardAttachment);
src/providers/grok/grok-core.js:871:        const seenCardIds = new Set();
src/providers/grok/grok-core.js:872:        const seenImageUrls = new Set();
src/providers/grok/grok-core.js:900:                            collected.cardAttachments.push(att);
src/providers/grok/grok-core.js:903:                    } catch (e) { collected.cardAttachments.push(att); }
src/providers/grok/grok-core.js:910:                        collected.generatedImageUrls.push(url);
src/providers/grok/grok-core.js:926:                            collected.modelResponse.cardAttachmentsJson.push(raw);
src/providers/grok/grok-core.js:929:                    } catch (e) { collected.modelResponse.cardAttachmentsJson.push(raw); }
src/providers/grok/grok-core.js:971:                    tasks.push(this._generateAndCollect(model, subRequestBody));
src/providers/grok/grok-core.js:1066:        const latestImages = new Map(); // 用于缓存每个 imageId 的最新状态
src/providers/grok/grok-core.js:1090:            collected.cardAttachments.push({ jsonData: jsonStr });
src/providers/grok/grok-core.js:1091:            collected.modelResponse.cardAttachmentsJson.push(jsonStr);
src/providers/grok/grok-core.js:1319:                if (res?.fileMetadataId) fileAttachments.push(res.fileMetadataId);
src/providers/grok/grok-core.js:1407:                                        extractedUrls.push(fullUrl);
src/providers/provider-pool-manager.js:19:    return new Set(
src/providers/provider-pool-manager.js:79:        this.pendingSaves = new Set(); // 记录待保存的 providerType
src/providers/provider-pool-manager.js:103:        this.refreshingUuids = new Set(); // 正在刷新的节点 UUID 集合
src/providers/provider-pool-manager.js:225:            candidates.forEach(p => nodesToWarmup.push({ type, status: p }));
src/providers/provider-pool-manager.js:269:            this.refreshBufferQueues[providerType] = new Map(); // 使用 Map 自动去重
src/providers/provider-pool-manager.js:410:                queue.waitingTasks.push(runTask);
src/providers/provider-pool-manager.js:428:            this.globalRefreshWaiters.push(() => {
src/providers/provider-pool-manager.js:844:                    this.providerStatus[providerType].push({
src/providers/provider-pool-manager.js:912:                            state.queue.splice(idx, 1);
src/providers/provider-pool-manager.js:921:                    state.queue.push(handler);
src/providers/provider-pool-manager.js:1101:        const triedTypes = new Set();
src/providers/provider-pool-manager.js:1106:            typesToTry.push(...fallbackTypes);
src/providers/provider-pool-manager.js:1233:        const triedTypes = new Set();
src/providers/provider-pool-manager.js:1238:            typesToTry.push(...fallbackTypes);
src/providers/provider-pool-manager.js:1430:        const allProviderTypes = Array.from(new Set([...registeredProviders]));
src/providers/provider-pool-manager.js:1491:                    allModels.push({
src/providers/provider-pool-manager.js:2108:                providersToCheck.push({ providerType, provider, uuid: provider.config.uuid, customName: provider.config.customName });
src/providers/provider-pool-manager.js:2165:            requests.push({
src/providers/provider-pool-manager.js:2176:            requests.push({
src/providers/provider-pool-manager.js:2186:            requests.push({
src/providers/provider-pool-manager.js:2200:            requests.push(convertData(
src/providers/provider-pool-manager.js:2210:        requests.push({
src/providers/claude/claude-kiro.js:384:        callPositions.push(pos);
src/providers/claude/claude-kiro.js:415:            toolCalls.push(parsedCall);
src/providers/claude/claude-kiro.js:422:    const seen = new Set();
src/providers/claude/claude-kiro.js:429:            uniqueToolCalls.push(tc);
src/providers/claude/claude-kiro.js:912:        if (before && !isWhitespaceOnly(before)) blocks.push({ type: "text", text: before });
src/providers/claude/claude-kiro.js:913:        blocks.push({ type: "thinking", thinking });
src/providers/claude/claude-kiro.js:914:        if (after && !isWhitespaceOnly(after)) blocks.push({ type: "text", text: after });
src/providers/claude/claude-kiro.js:972:                mergedMessages.push(currentMsg);
src/providers/claude/claude-kiro.js:981:                        lastMsg.content.push(...currentMsg.content);
src/providers/claude/claude-kiro.js:987:                        lastMsg.content.push({ type: 'text', text: currentMsg.content });
src/providers/claude/claude-kiro.js:994:                    mergedMessages.push(currentMsg);
src/providers/claude/claude-kiro.js:1001:        processedMessages.push(...mergedMessages);
src/providers/claude/claude-kiro.js:1118:                history.push({
src/providers/claude/claude-kiro.js:1129:                history.push({
src/providers/claude/claude-kiro.js:1163:                            toolResults.push({
src/providers/claude/claude-kiro.js:1171:                                images.push({
src/providers/claude/claude-kiro.js:1205:                    const seenIds = new Set();
src/providers/claude/claude-kiro.js:1209:                            uniqueToolResults.push(tr);
src/providers/claude/claude-kiro.js:1215:                history.push({ userInputMessage });
src/providers/claude/claude-kiro.js:1230:                            toolUses.push({
src/providers/claude/claude-kiro.js:1252:                history.push({ assistantResponseMessage });
src/providers/claude/claude-kiro.js:1281:                        assistantResponseMessage.toolUses.push({
src/providers/claude/claude-kiro.js:1299:            history.push({ assistantResponseMessage });
src/providers/claude/claude-kiro.js:1311:                    history.push({
src/providers/claude/claude-kiro.js:1325:                        currentToolResults.push({
src/providers/claude/claude-kiro.js:1331:                        currentToolUses.push({
src/providers/claude/claude-kiro.js:1337:                        currentImages.push({
src/providers/claude/claude-kiro.js:1387:            const seenToolUseIds = new Set();
src/providers/claude/claude-kiro.js:1391:                    uniqueToolResults.push(tr);
src/providers/claude/claude-kiro.js:1487:                            toolCalls.push(currentToolCallDict);
src/providers/claude/claude-kiro.js:1510:            toolCalls.push(currentToolCallDict);
src/providers/claude/claude-kiro.js:1516:            toolCalls.push(...bracketToolCalls);
src/providers/claude/claude-kiro.js:1873:            allToolCalls.push(...rawBracketToolCalls);
src/providers/claude/claude-kiro.js:2025:                    events.push({ type: 'content', data: decodedContent });
src/providers/claude/claude-kiro.js:2029:                    events.push({ 
src/providers/claude/claude-kiro.js:2041:                    events.push({
src/providers/claude/claude-kiro.js:2050:                    events.push({
src/providers/claude/claude-kiro.js:2059:                    events.push({
src/providers/claude/claude-kiro.js:2296:            stoppedBlocks: new Set(),
src/providers/claude/claude-kiro.js:2335:            events.push(...ensureBlockStart('text'));
src/providers/claude/claude-kiro.js:2336:            events.push({
src/providers/claude/claude-kiro.js:2346:            events.push(...ensureBlockStart('thinking'));
src/providers/claude/claude-kiro.js:2347:            events.push({
src/providers/claude/claude-kiro.js:2366:            const toolUseBlockIndexes = new Map(); // toolUseId -> content block index
src/providers/claude/claude-kiro.js:2412:                                    events.push(...createTextDeltaEvents(beforeCombined));
```

**tool:bash** (completed) cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "\.on(\|\.once(\|\.removeListener\|\.removeAllListeners\|\.off(" src/ --include="*.js" | head -100

```
command=cd /home/x3/workspace/BlacklistedAIProxy && grep -rn "\.on(\|\.once(\|\.removeLi; description=Find event listener usage
--- output ---
src/providers/grok/ws-imagine.js:61:        ws.on('open', () => {
src/providers/grok/ws-imagine.js:107:        ws.on('message', (data) => {
src/providers/grok/ws-imagine.js:120:        ws.on('close', (code, reason) => {
src/providers/grok/ws-imagine.js:129:        ws.on('error', (err) => {
src/providers/openai/qwen-core.js:500:                        childProcess.on('error', () => showFallbackMessage());
src/providers/openai/qwen-core.js:950:        process.on('exit', this.cleanupFunction);
src/providers/openai/qwen-core.js:951:        process.on('SIGINT', this.sigintHandler);
src/providers/gemini/gemini-core.js:459:                    childProcess.on('error', () => showFallbackMessage());
src/providers/gemini/antigravity-core.js:869:                    childProcess.on('error', () => showFallbackMessage());
src/services/api-server.js:150:    process.on('message', (message) => {
src/services/api-server.js:176:    process.on('disconnect', () => {
src/services/api-server.js:227:    process.on('SIGTERM', () => {
src/services/api-server.js:232:    process.on('SIGINT', () => {
src/services/api-server.js:237:    process.on('uncaughtException', (error) => {
src/services/api-server.js:251:    process.on('unhandledRejection', (reason, promise) => {
src/services/hybrid-gateway.js:251:            upstreamRes.on('data', (chunk) => {
src/services/hybrid-gateway.js:262:            upstreamRes.on('end', () => {
src/services/hybrid-gateway.js:281:            upstreamRes.on('error', (error) => {
src/services/hybrid-gateway.js:293:        upstreamReq.on('timeout', () => {
src/services/hybrid-gateway.js:297:        upstreamReq.on('error', (error) => {
src/services/api-manager.js:111:        req.on('data', chunk => { body += chunk.toString(); });
src/services/api-manager.js:112:        req.on('end', () => { resolve(body); });
src/services/api-manager.js:113:        req.on('error', err => { reject(err); });
src/ui-modules/event-broadcast.js:68:    req.on('close', () => {
src/ui-modules/auth.js:81:        req.on('data', chunk => {
src/ui-modules/auth.js:84:        req.on('end', () => {
src/ui-modules/auth.js:95:        req.on('error', reject);
src/telemetry/otel.js:78:    process.once('SIGTERM', shutdownTelemetry);
src/telemetry/otel.js:79:    process.once('SIGINT',  shutdownTelemetry);
src/handlers/request-handler.js:31:        req.on('data', chunk => { body += chunk.toString(); });
src/handlers/request-handler.js:32:        req.on('end', () => {
src/handlers/request-handler.js:39:        req.on('error', reject);
src/utils/common.js:376:        req.on('data', chunk => {
src/utils/common.js:379:        req.on('end', () => {
src/utils/common.js:389:        req.on('error', err => {
src/utils/common.js:544:        res.on('close', onClientClose);
src/utils/common.js:545:        res.on('error', onClientError);
src/utils/common.js:836:            res.off('close', onClientClose);
src/utils/common.js:837:            res.off('error', onClientError);
src/utils/grok-assets-proxy.js:107:        response.data.on('error', (err) => {
src/utils/tls-sidecar.js:81:            this.process.stdout.on('data', (data) => {
src/utils/tls-sidecar.js:86:            this.process.stderr.on('data', (data) => {
src/utils/tls-sidecar.js:91:            this.process.on('exit', (code, signal) => {
src/utils/tls-sidecar.js:103:            this.process.on('error', (err) => {
src/utils/tls-sidecar.js:143:                this.process.once('exit', () => {
src/utils/tls-sidecar.js:248:                res.on('data', (chunk) => body += chunk);
src/utils/tls-sidecar.js:249:                res.on('end', () => {
src/utils/tls-sidecar.js:253:            req.on('error', () => resolve(false));
src/utils/tls-sidecar.js:254:            req.on('timeout', () => {
src/utils/logger.js:76:            this.logStream.on('error', (err) => {
src/utils/logger.js:264:                this.logStream.on('error', (err) => {
src/utils/logger.js:436:            this.logStream.on('error', (err) => {
src/plugins/token-optimizer/api-routes.js:36:        req.on('data', c => { data += c.toString(); });
src/plugins/token-optimizer/api-routes.js:37:        req.on('end', () => {
src/plugins/token-optimizer/api-routes.js:41:        req.on('error', reject);
src/plugins/token-optimizer/index.js:79:        req.on('data', c => chunks.push(c));
src/plugins/token-optimizer/index.js:80:        req.on('end', () => resolve(Buffer.concat(chunks)));
src/plugins/token-optimizer/index.js:81:        req.on('error', reject);
src/plugins/model-usage-stats/stats-manager.js:155:        process.on('beforeExit', () => syncWriteToFile());
src/plugins/model-usage-stats/stats-manager.js:156:        process.on('SIGINT', () => { syncWriteToFile(); process.exit(0); });
src/plugins/model-usage-stats/stats-manager.js:157:        process.on('SIGTERM', () => { syncWriteToFile(); process.exit(0); });
src/plugins/ensemble-synthesizer/api-routes.js:31:        req.on('data', c => { data += c.toString(); });
src/plugins/ensemble-synthesizer/api-routes.js:32:        req.on('end', () => {
src/plugins/ensemble-synthesizer/api-routes.js:36:        req.on('error', reject);
src/plugins/ensemble-synthesizer/fanout.js:65:            res.on('data', c => chunks.push(c));
src/plugins/ensemble-synthesizer/fanout.js:66:            res.on('end', () => {
src/plugins/ensemble-synthesizer/fanout.js:76:            res.on('error', (err) => {
src/plugins/ensemble-synthesizer/fanout.js:81:        req.on('error', (err) => {
src/plugins/ensemble-synthesizer/fanout.js:91:        req.on('close', () => clearTimeout(timer));
src/plugins/ensemble-synthesizer/index.js:273:            req.on('data', c => chunks.push(c));
src/plugins/ensemble-synthesizer/index.js:274:            req.on('end', () => {
src/plugins/ensemble-synthesizer/index.js:280:            req.on('error', () => resolve(null));
src/plugins/ensemble-synthesizer/index.js:303:                res2.on('data', c => chunks.push(c));
src/plugins/ensemble-synthesizer/index.js:304:                res2.on('end', () => {
src/plugins/ensemble-synthesizer/index.js:310:                res2.on('error', reject);
src/plugins/ensemble-synthesizer/index.js:314:            req.on('close', () => clearTimeout(timer));
src/plugins/ensemble-synthesizer/index.js:315:            req.on('error', reject);
src/plugins/api-potluck/api-routes.js:34:        req.on('data', chunk => {
src/plugins/api-potluck/api-routes.js:37:        req.on('end', () => {
src/plugins/api-potluck/api-routes.js:44:        req.on('error', reject);
src/plugins/api-potluck/key-manager.js:221:        process.on('beforeExit', () => persistIfDirty());
src/plugins/api-potluck/key-manager.js:222:        process.on('SIGINT', () => { persistIfDirty(); process.exit(0); });
src/plugins/api-potluck/key-manager.js:223:        process.on('SIGTERM', () => { persistIfDirty(); process.exit(0); });
src/plugins/universal-guard/budget-guard.js:65:        process.on('beforeExit', saveOnExit);
src/plugins/universal-guard/budget-guard.js:66:        process.on('SIGINT',  () => { saveOnExit(); });
src/plugins/universal-guard/budget-guard.js:67:        process.on('SIGTERM', () => { saveOnExit(); });
src/plugins/universal-guard/api-routes.js:35:        req.on('data', c => { data += c.toString(); });
src/plugins/universal-guard/api-routes.js:36:        req.on('end', () => {
src/plugins/universal-guard/api-routes.js:40:        req.on('error', reject);
src/plugins/universal-guard/index.js:83:        req.on('data', c => chunks.push(c));
src/plugins/universal-guard/index.js:84:        req.on('end', () => {
src/plugins/universal-guard/index.js:91:        req.on('error', () => resolve(null));
src/core/master.js:72:    workerProcess.on('message', (message) => {
src/core/master.js:78:    workerProcess.on('exit', (code, signal) => {
src/core/master.js:91:    workerProcess.on('error', (error) => {
src/core/master.js:119:        workerProcess.once('exit', () => {
src/core/master.js:333:    process.on('SIGTERM', async () => {
src/core/master.js:339:    process.on('SIGINT', async () => {
src/core/master.js:346:    process.on('uncaughtException', (error) => {
src/core/master.js:359:    process.on('unhandledRejection', (reason, promise) => {
```

---

### 🤖 Assistant — 2026-09-16 01:59:45

> Now let me read the critical files in parallel to understand the actual code patterns.

Now let me read the critical hot-path and infrastructure files:

**tool:read** (completed) BlacklistedAIProxy/src/utils/logger.js

```
filePath=/home/x3/workspace/BlacklistedAIProxy/src/utils/logger.js
--- output ---
<path>/home/x3/workspace/BlacklistedAIProxy/src/utils/logger.js</path>
<type>file</type>
<content>
1: import * as fs from 'fs';
2: import * as path from 'path';
3: import { randomUUID } from 'crypto';
4: import { AsyncLocalStorage } from 'node:async_hooks';
5: 
6: /**
7:  * 统一日志工具类
8:  * 支持控制台和文件输出，自动添加请求ID和时间戳
9:  */
10: class Logger {
11:     constructor() {
12:         this.config = {
13:             enabled: true,
14:             outputMode: 'all', // 'console', 'file', 'all', 'none'
15:             logDir: 'logs',
16:             logLevel: 'info', // 'debug', 'info', 'warn', 'error'
17:             includeRequestId: true,
18:             includeTimestamp: true,
19:             maxFileSize: 10 * 1024 * 1024, // 10MB
20:             maxFiles: 10
21:         };
22:         this.currentLogFile = null;
23:         this.logStream = null;
24:         this.asyncStorage = new AsyncLocalStorage(); // 使用 AsyncLocalStorage 存储请求上下文
25:         this.requestContext = new Map(); // 存储请求上下文
26:         this.contextTTL = 5 * 60 * 1000; // 请求上下文 TTL：5 分钟
27:         this._contextCleanupTimer = null;
28:         this.levels = {
29:             debug: 0,
30:             info: 1,
31:             warn: 2,
32:             error: 3
33:         };
34:     }
35: 
36: 
37:     /**
38:      * 初始化日志配置
39:      * @param {Object} config - 日志配置对象
40:      */
41:     initialize(config = {}) {
42:         this.config = { ...this.config, ...config };
43:         
44:         if (this.config.outputMode === 'none') {
45:             this.config.enabled = false;
46:             return;
47:         }
48: 
49:         if (this.config.outputMode === 'file' || this.config.outputMode === 'all') {
50:             this.initializeFileLogging();
51:         }
52:     }
53: 
54:     /**
55:      * 初始化文件日志
56:      */
57:     initializeFileLogging() {
58:         try {
59:             // 确保日志目录存在
60:             if (!fs.existsSync(this.config.logDir)) {
61:                 fs.mkdirSync(this.config.logDir, { recursive: true });
62:             }
63: 
64:             // 创建日志文件名（按本地日期）
65:             const date = new Date();
66:             const year = date.getFullYear();
67:             const month = String(date.getMonth() + 1).padStart(2, '0');
68:             const day = String(date.getDate()).padStart(2, '0');
69:             const dateStr = `${year}-${month}-${day}`;
70:             this.currentLogFile = path.join(this.config.logDir, `app-${dateStr}.log`);
71: 
72:             // 创建写入流
73:             this.logStream = fs.createWriteStream(this.currentLogFile, { flags: 'a' });
74:             
75:             // 监听错误
76:             this.logStream.on('error', (err) => {
77:                 console.error('[Logger] Failed to write to log file:', err.message);
78:             });
79:         } catch (error) {
80:             console.error('[Logger] Failed to initialize file logging:', error.message);
81:         }
82:     }
83: 
84:     /**
85:      * 在请求上下文中运行
86:      * @param {string} requestId - 请求ID
87:      * @param {Function} callback - 回调函数
88:      * @returns {any}
89:      */
90:     runWithContext(requestId, callback) {
91:         if (!requestId) {
92:             requestId = randomUUID().substring(0, 8);
93:         }
94:         this.requestContext.set(requestId, { _createdAt: Date.now() });
95:         this._ensureContextCleanup();
96:         return this.asyncStorage.run(requestId, callback);
97:     }
98: 
99:     /**
100:      * 设置请求上下文 (不推荐直接使用，建议使用 runWithContext)
101:      * @param {string} requestId - 请求ID
102:      * @param {Object} context - 上下文信息
103:      */
104:     setRequestContext(requestId, context = {}) {
105:         if (!requestId) {
106:             requestId = randomUUID().substring(0, 8);
107:         }
108:         this.asyncStorage.enterWith(requestId);
109:         this.requestContext.set(requestId, { ...context, _createdAt: Date.now() });
110:         this._ensureContextCleanup();
111:         return requestId;
112:     }
113: 
114:     /**
115:      * 获取当前请求ID
116:      * @returns {string} 请求ID
117:      */
118:     getCurrentRequestId() {
119:         // 从 AsyncLocalStorage 中获取当前请求ID
120:         return this.asyncStorage.getStore();
121:     }
122: 
123:     /**
124:      * 获取当前请求上下文
125:      * @param {string} requestId - 请求ID
126:      * @returns {Object} 上下文信息
127:      */
128:     getRequestContext(requestId) {
129:         if (!requestId) {
130:             requestId = this.getCurrentRequestId();
131:         }
132:         return this.requestContext.get(requestId) || {};
133:     }
134: 
135:     /**
136:      * 清除请求上下文
137:      * @param {string} requestId - 请求ID
138:      */
139:     clearRequestContext(requestId) {
140:         if (requestId) {
141:             this.requestContext.delete(requestId);
142:         }
143:         // AsyncLocalStorage 不需要手动清除，run() 会在结束时自动处理
144:         // 如果使用了 enterWith，则没有简单的方法在该异步路径中清除
145:     }
146: 
147: 
148:     /**
149:      * 启动定期清理过期请求上下文的定时器（防止内存泄漏）
150:      * 每 60 秒扫描一次，清除超过 contextTTL 的条目
151:      */
152:     _ensureContextCleanup() {
153:         if (this._contextCleanupTimer) return;
154:         this._contextCleanupTimer = setInterval(() => {
155:             const now = Date.now();
156:             let cleaned = 0;
157:             for (const [id, ctx] of this.requestContext) {
158:                 if (now - (ctx._createdAt || 0) > this.contextTTL) {
159:                     this.requestContext.delete(id);
160:                     cleaned++;
161:                 }
162:             }
163:             if (cleaned > 0) {
164:                 this.log('warn', [`[Logger] Cleaned ${cleaned} stale request context(s) (TTL: ${this.contextTTL}ms)`]);
165:             }
166:             // 当 Map 为空时停止定时器
167:             if (this.requestContext.size === 0) {
168:                 clearInterval(this._contextCleanupTimer);
169:                 this._contextCleanupTimer = null;
170:             }
171:         }, 60_000);
172:         // 不阻止进程退出
173:         if (this._contextCleanupTimer.unref) {
174:             this._contextCleanupTimer.unref();
175:         }
176:     }
177: 
178:     /**
179:      * 格式化日志消息
180:      * @param {string} level - 日志级别
181:      * @param {Array} args - 日志参数
182:      * @param {string} requestId - 请求ID
183:      * @returns {string} 格式化后的日志
184:      */
185:     formatMessage(level, args, requestId) {
186:         const parts = [];
187: 
188:         // 添加本地时间戳
189:         if (this.config.includeTimestamp) {
190:             const now = new Date();
191:             const year = now.getFullYear();
192:             const month = String(now.getMonth() + 1).padStart(2, '0');
193:             const day = String(now.getDate()).padStart(2, '0');
194:             const hours = String(now.getHours()).padStart(2, '0');
195:             const minutes = String(now.getMinutes()).padStart(2, '0');
196:             const seconds = String(now.getSeconds()).padStart(2, '0');
197:             const ms = String(now.getMilliseconds()).padStart(3, '0');
```

**tool:read** (completed) BlacklistedAIProxy/src/utils/common.js

```
filePath=/home/x3/workspace/BlacklistedAIProxy/src/utils/common.js
--- output ---
<path>/home/x3/workspace/BlacklistedAIProxy/src/utils/common.js</path>
<type>file</type>
<content>
1: export { MODEL_PROTOCOL_PREFIX, MODEL_PROVIDER } from './constants.js';
2: import { promises as fs } from 'fs';
3: import * as path from 'path';
4: import * as http from 'http'; // Add http for IncomingMessage and ServerResponse types
5: import * as crypto from 'crypto'; // Import crypto for MD5 hashing
6: import logger from './logger.js';
7: import { convertData, getOpenAIStreamChunkStop } from '../convert/convert.js';
8: import { ProviderStrategyFactory } from './provider-strategies.js';
9: import { getPluginManager } from '../core/plugin-manager.js';
10: import { MODEL_PROTOCOL_PREFIX, MODEL_PROVIDER } from './constants.js';
11: 
12: // ==================== 时间与时区 ====================
13: 
14: /**
15:  * 获取北京时间 (UTC+8) 的日期字符串 (YYYY-MM-DD)
16:  * @returns {string} - YYYY-MM-DD 格式的日期字符串
17:  */
18: export function getBeijingDateString() {
19:     const now = new Date();
20:     // 强制增加 8 小时偏移来模拟 UTC+8
21:     const utc8Time = new Date(now.getTime() + (8 * 60 * 60 * 1000));
22:     return utc8Time.toISOString().split('T')[0];
23: }
24: 
25: // ==================== 网络错误处理 ====================
26: 
27: /**
28:  * 可重试的网络错误标识列表
29:  * 这些错误可能出现在 error.code 或 error.message 中
30:  */
31: export const RETRYABLE_NETWORK_ERRORS = [
32:     'ECONNRESET',      // 连接被重置
33:     'ETIMEDOUT',       // 连接超时
34:     'ECONNREFUSED',    // 连接被拒绝
35:     'ENOTFOUND',       // DNS 解析失败
36:     'ENETUNREACH',     // 网络不可达
37:     'EHOSTUNREACH',    // 主机不可达
38:     'EPIPE',           // 管道破裂
39:     'EAI_AGAIN',       // DNS 临时失败
40:     'ECONNABORTED',    // 连接中止
41:     'ESOCKETTIMEDOUT', // Socket 超时
42: ];
43: 
44: /**
45:  * 检查是否为可重试的网络错误
46:  * @param {Error} error - 错误对象
47:  * @returns {boolean} - 是否为可重试的网络错误
48:  */
49: export function isRetryableNetworkError(error) {
50:     if (!error) return false;
51:     
52:     const errorCode = error.code || '';
53:     const errorMessage = error.message || '';
54:     
55:     return RETRYABLE_NETWORK_ERRORS.some(errId =>
56:         errorCode === errId || errorMessage.includes(errId)
57:     );
58: }
59: 
60: // ==================== API 常量 ====================
61: 
62: export const API_ACTIONS = {
63:     GENERATE_CONTENT: 'generateContent',
64:     STREAM_GENERATE_CONTENT: 'streamGenerateContent',
65: };
66: 
67: import {
68:     usesManagedModelList,
69:     getConfiguredSupportedModels,
70:     getCustomModelConfig,
71:     getCustomModelActualProvider,
72:     getCustomModelListProvider,
73:     normalizeModelIds
74: } from '../providers/provider-models.js';
75: 
76: /**
77:  * 获取指定提供商类型下，所有节点配置的已选模型列表（去重聚合）
78:  * @param {object} providerPoolManager - 提供商池管理器
79:  * @param {string} providerType - 提供商类型
80:  * @returns {string[]} 聚合后的模型 ID 列表
81:  */
82: function getConfiguredSupportedModelsFromPool(providerPoolManager, providerType) {
83:     if (!providerPoolManager?.providerStatus?.[providerType]) {
84:         return [];
85:     }
86: 
87:     return [...new Set(
88:         providerPoolManager.providerStatus[providerType]
89:             .flatMap(providerStatus => getConfiguredSupportedModels(providerType, providerStatus.config))
90:     )].sort((a, b) => a.localeCompare(b));
91: }
92: 
93: function getCustomModelEntriesForProvider(config, providerType = null, options = {}) {
94:     const customModels = Array.isArray(config?.customModels) ? config.customModels : [];
95:     const entries = [];
96: 
97:     customModels.forEach(modelConfig => {
98:         if (!modelConfig?.id) {
99:             return;
100:         }
101: 
102:         const modelProvider = getCustomModelListProvider(modelConfig);
103:         const actualProvider = getCustomModelActualProvider(modelConfig);
104:         const isMatch = !providerType ||
105:             modelProvider === providerType ||
106:             (modelProvider && providerType.startsWith(modelProvider + '-'));
107: 
108:         if (!isMatch) {
109:             return;
110:         }
111: 
112:         const modelId = modelConfig.id;
113:         if (!modelId) {
114:             return;
115:         }
116: 
117:         const responseId = options.prefixProvider && modelProvider
118:             ? `${modelProvider}:${modelId}`
119:             : modelId;
120: 
121:         entries.push({
122:             id: responseId,
123:             modelId,
124:             provider: modelProvider || providerType || MODEL_PROVIDER.AUTO,
125:             actualProvider: actualProvider || modelProvider || providerType || MODEL_PROVIDER.AUTO,
126:             config: modelConfig
127:         });
128:     });
129: 
130:     return entries;
131: }
132: 
133: export function resolveCustomModelRouting(model, currentProvider, customModelConfig = getCustomModelConfig(model, currentProvider)) {
134:     if (!customModelConfig) {
135:         return {
136:             isCustomModel: false,
137:             model,
138:             provider: currentProvider,
139:             actualModel: model,
140:             actualProvider: currentProvider,
141:             config: null
142:         };
143:     }
144: 
145:     const customActualProvider = getCustomModelActualProvider(customModelConfig);
146:     const customActualModel = customModelConfig.actualModel || customModelConfig.id || model;
147: 
148:     return {
149:         isCustomModel: true,
150:         model: customActualModel,
151:         provider: customActualProvider || currentProvider,
152:         actualModel: customActualModel,
153:         actualProvider: customActualProvider || currentProvider,
154:         config: customModelConfig
155:     };
156: }
157: 
158: function appendCustomModelsToModelList(clientModelList, customEntries, providerType, listEndpointType) {
159:     const entries = Array.isArray(customEntries) ? customEntries : [];
160:     const hasMetadataValue = (value) => value !== undefined && value !== null;
161: 
162:     if (!entries.length) {
163:         return clientModelList;
164:     }
165: 
166:     if (listEndpointType === ENDPOINT_TYPE.GEMINI_MODEL_LIST) {
167:         const models = Array.isArray(clientModelList?.models) ? clientModelList.models : [];
168: 
169:         entries.forEach(entry => {
170:             const existingModel = models.find(model => {
171:                 const existingId = model?.baseModelId || model?.name;
172:                 if (!existingId) return false;
173:                 const normalizedId = existingId.startsWith('models/') ? existingId.substring(7) : existingId;
174:                 return normalizedId === entry.id;
175:             });
176:             if (existingModel) {
177:                 existingModel.displayName = entry.config.name || existingModel.displayName || entry.id;
178:                 existingModel.description = entry.config.description || existingModel.description || `Model ${entry.modelId} provided by ${entry.provider || providerType}`;
179:                 if (hasMetadataValue(entry.config.contextLength)) existingModel.inputTokenLimit = entry.config.contextLength;
180:                 if (hasMetadataValue(entry.config.maxTokens)) existingModel.outputTokenLimit = entry.config.maxTokens;
181:                 return;
182:             }
183: 
184:             const modelResponse = {
185:                 name: `models/${entry.id}`,
186:                 baseModelId: entry.id,
187:                 version: 'v1',
188:                 displayName: entry.config.name || entry.id,
189:                 description: entry.config.description || `Model ${entry.modelId} provided by ${entry.provider || providerType}`,
190:                 supportedGenerationMethods: ['generateContent', 'countTokens']
191:             };
192: 
193:             if (hasMetadataValue(entry.config.contextLength)) modelResponse.inputTokenLimit = entry.config.contextLength;
194:             if (hasMetadataValue(entry.config.maxTokens)) modelResponse.outputTokenLimit = entry.config.maxTokens;
195: 
196:             models.push(modelResponse);
197:         });
```

**tool:read** (completed) BlacklistedAIProxy/src/services/service-manager.js

```
filePath=/home/x3/workspace/BlacklistedAIProxy/src/services/service-manager.js
--- output ---
<path>/home/x3/workspace/BlacklistedAIProxy/src/services/service-manager.js</path>
<type>file</type>
<content>
1: import { getServiceAdapter, serviceInstances } from '../providers/adapter.js';
2: import logger from '../utils/logger.js';
3: import { ProviderPoolManager } from '../providers/provider-pool-manager.js';
4: import deepmerge from 'deepmerge';
5: import * as fs from 'fs';
6: import { promises as pfs } from 'fs';
7: import * as path from 'path';
8: import {
9:     PROVIDER_MAPPINGS,
10:     createProviderConfig,
11:     addToUsedPaths,
12:     isPathUsed,
13:     getFileName,
14:     formatSystemPath
15: } from '../utils/provider-utils.js';
16: import { withFileLock, atomicWriteFile } from '../utils/file-lock.js';
17: import { MODEL_PROVIDER } from '../utils/constants.js';
18: 
19: // 存储 ProviderPoolManager 实例
20: let providerPoolManager = null;
21: 
22: /**
23:  * 扫描 configs 目录并自动关联未关联的配置文件到对应的提供商
24:  * @param {Object} config - 服务器配置对象
25:  * @param {Object} options - 可选参数
26:  * @param {boolean} options.onlyCurrentCred - 为 true 时，只自动关联当前凭证
27:  * @param {string} options.credPath - 当前凭证的路径（当 onlyCurrentCred 为 true 时必需）
28:  * @returns {Promise<Object>} 更新后的 providerPools 对象
29:  */
30: export async function autoLinkProviderConfigs(config, options = {}) {
31:     // 确保 providerPools 对象存在
32:     if (!config.providerPools) {
33:         config.providerPools = {};
34:     }
35:     
36:     let totalNewProviders = 0;
37:     const allNewProviders = {};
38:     
39:     // 如果只关联当前凭证
40:     if (options.onlyCurrentCred && options.credPath) {
41:         const result = await linkSingleCredential(config, options.credPath);
42:         if (result) {
43:             totalNewProviders = 1;
44:             allNewProviders[result.displayName] = [result.provider];
45:         }
46:     } else {
47:         // 遍历所有提供商映射
48:         for (const mapping of PROVIDER_MAPPINGS) {
49:             const configsPath = path.join(process.cwd(), 'configs', mapping.dirName);
50:             const { providerType, credPathKey, defaultCheckModel, displayName, needsProjectId } = mapping;
51:             
52:             // 确保提供商类型数组存在
53:             if (!config.providerPools[providerType]) {
54:                 config.providerPools[providerType] = [];
55:             }
56:             
57:             // 检查目录是否存在
58:             if (!fs.existsSync(configsPath)) {
59:                 continue;
60:             }
61:             
62:             // 获取已关联的配置文件路径集合
63:             const linkedPaths = new Set();
64:             for (const provider of config.providerPools[providerType]) {
65:                 if (provider[credPathKey]) {
66:                     // 使用公共方法添加路径的所有变体格式
67:                     addToUsedPaths(linkedPaths, provider[credPathKey]);
68:                 }
69:             }
70:             
71:             // 递归扫描目录
72:             const newProviders = [];
73:             await scanProviderDirectory(configsPath, linkedPaths, newProviders, {
74:                 credPathKey,
75:                 defaultCheckModel,
76:                 needsProjectId
77:             });
78:             
79:             // 如果有新的配置文件需要关联
80:             if (newProviders.length > 0) {
81:                 config.providerPools[providerType].push(...newProviders);
82:                 totalNewProviders += newProviders.length;
83:                 allNewProviders[displayName] = newProviders;
84:             }
85:         }
86:     }
87:     
88:     // 如果有新的配置文件需要关联，保存更新后的 provider_pools.json
89:     if (totalNewProviders > 0) {
90:         const filePath = config.PROVIDER_POOLS_FILE_PATH || 'configs/provider_pools.json';
91:         try {
92:             await withFileLock(filePath, async () => {
93:                 await atomicWriteFile(filePath, JSON.stringify(config.providerPools, null, 2), 'utf8');
94:             });
95:             logger.info(`[Auto-Link] Added ${totalNewProviders} new config(s) to provider pools:`);
96:             for (const [displayName, providers] of Object.entries(allNewProviders)) {
97:                 logger.info(`  ${displayName}: ${providers.length} config(s)`);
98:                 providers.forEach(p => {
99:                     // 获取凭据路径键（支持 _CREDS_FILE_PATH 和 _TOKEN_FILE_PATH 两种格式）
100:                     const credKey = Object.keys(p).find(k =>
101:                         k.endsWith('_CREDS_FILE_PATH') || k.endsWith('_TOKEN_FILE_PATH')
102:                     );
103:                     if (credKey) {
104:                         logger.info(`    - ${p[credKey]}`);
105:                     }
106:                 });
107:             }
108:         } catch (error) {
109:             logger.error(`[Auto-Link] Failed to save provider_pools.json: ${error.message}`);
110:         }
111:     } else {
112:         logger.info('[Auto-Link] No new configs to link');
113:     }
114:     
115:     // Update provider pool manager if available
116:     if (providerPoolManager) {
117:         providerPoolManager.providerPools = config.providerPools;
118:         providerPoolManager.initializeProviderStatus();
119:     }
120:     return config.providerPools;
121: }
122: 
123: /**
124:  * 关联单个凭证文件到对应的提供商
125:  * @param {Object} config - 服务器配置对象
126:  * @param {string} credPath - 凭证文件路径（相对或绝对路径）
127:  * @returns {Promise<Object|null>} 返回关联结果或 null
128:  */
129: async function linkSingleCredential(config, credPath) {
130:     try {
131:         // 规范化路径
132:         const absolutePath = path.isAbsolute(credPath) ? credPath : path.join(process.cwd(), credPath);
133:         const relativePath = path.relative(process.cwd(), absolutePath);
134:         
135:         // 检查文件是否存在
136:         if (!fs.existsSync(absolutePath)) {
137:             logger.warn(`[Auto-Link] Credential file not found: ${relativePath}`);
138:             return null;
139:         }
140:         
141:         // 检查文件扩展名
142:         const ext = path.extname(absolutePath).toLowerCase();
143:         if (ext !== '.json') {
144:             logger.warn(`[Auto-Link] Only JSON files are supported: ${relativePath}`);
145:             return null;
146:         }
147:         
148:         // 根据文件路径确定提供商类型
149:         let matchedMapping = null;
150:         for (const mapping of PROVIDER_MAPPINGS) {
151:             const configsPath = path.join(process.cwd(), 'configs', mapping.dirName);
152:             // 检查文件是否在该提供商的配置目录下
153:             if (absolutePath.startsWith(configsPath)) {
154:                 matchedMapping = mapping;
155:                 break;
156:             }
157:         }
158:         
159:         if (!matchedMapping) {
160:             logger.warn(`[Auto-Link] Could not determine provider type for: ${relativePath}`);
161:             return null;
162:         }
163:         
164:         const { providerType, credPathKey, defaultCheckModel, displayName, needsProjectId } = matchedMapping;
165:         
166:         // 确保提供商类型数组存在
167:         if (!config.providerPools[providerType]) {
168:             config.providerPools[providerType] = [];
169:         }
170:         
171:         // 检查是否已关联
172:         const linkedPaths = new Set();
173:         for (const provider of config.providerPools[providerType]) {
174:             if (provider[credPathKey]) {
175:                 addToUsedPaths(linkedPaths, provider[credPathKey]);
176:             }
177:         }
178:         
179:         const fileName = getFileName(absolutePath);
180:         const isLinked = isPathUsed(relativePath, fileName, linkedPaths);
181:         
182:         if (isLinked) {
183:             logger.info(`[Auto-Link] Credential already linked: ${relativePath}`);
184:             return null;
185:         }
186:         
187:         // 创建新的提供商配置
188:         const newProvider = createProviderConfig({
189:             credPathKey,
190:             credPath: formatSystemPath(relativePath),
191:             defaultCheckModel,
192:             needsProjectId
193:         });
194:         
195:         // 添加到配置
196:         config.providerPools[providerType].push(newProvider);
197:         
```

**tool:read** (completed) BlacklistedAIProxy/src/providers/provider-pool-manager.js

```
filePath=/home/x3/workspace/BlacklistedAIProxy/src/providers/provider-pool-manager.js
--- output ---
<path>/home/x3/workspace/BlacklistedAIProxy/src/providers/provider-pool-manager.js</path>
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
51:         'gemini-cli-oauth': 'gemini-2.5-flash',
52:         'gemini-antigravity': 'gemini-2.5-flash',
53:         'openai-custom': 'gpt-4o-mini',
54:         'claude-custom': 'claude-3-7-sonnet-20250219',
55:         'claude-kiro-oauth': 'claude-haiku-4-5',
56:         'openai-qwen-oauth': 'qwen3-coder-flash',
57:         'openai-iflow': 'qwen3-coder-plus',
58:         'openai-codex-oauth': 'gpt-5-codex-mini',
59:         'openaiResponses-custom': 'gpt-4o-mini',
60:         'forward-api': 'gpt-4o-mini',
61:         'grok-custom': 'grok-4.1-mini',
62:     };
63: 
64:     constructor(providerPools, options = {}) {
65:         this.providerPools = providerPools;
66:         this.globalConfig = options.globalConfig || {}; // 存储全局配置
67:         this.providerStatus = {}; // Tracks health and usage for each provider instance
68:         this.roundRobinIndex = {}; // Tracks the current index for round-robin selection for each provider type
69:         // 使用 ?? 运算符确保 0 也能被正确设置，而不是被 || 替换为默认值
70:         this.maxErrorCount = options.maxErrorCount ?? 10; // Default to 10 errors before marking unhealthy
71:         this.healthCheckInterval = options.healthCheckInterval ?? 10 * 60 * 1000; // Default to 10 minutes
72: 
73:             // 日志级别控制
74:         this.logLevel = options.logLevel || 'info'; // 'debug', 'info', 'warn', 'error'
75:         
76:         // 添加防抖机制，避免频繁的文件 I/O 操作
77:         this.saveDebounceTime = options.saveDebounceTime || 1000; // 默认1秒防抖
78:         this.saveTimer = null;
79:         this.pendingSaves = new Set(); // 记录待保存的 providerType
80:         
81:         // Fallback 链配置
82:         this.fallbackChain = options.globalConfig?.providerFallbackChain || {};
83:         
84:         // Model Fallback 映射配置
85:         this.modelFallbackMapping = options.globalConfig?.modelFallbackMapping || {};
86: 
87:         // 并发控制：每个 providerType 的选择锁
88:         // 用于确保 selectProvider 的排序 and 更新操作是原子的
89:         this._selectionLocks = {};
90:         this._isSelecting = {}; // 同步标志位锁
91: 
92:         // --- V2: 读写分离 and 异步刷新队列 ---
93:         // 刷新并发控制配置
94:         this.refreshConcurrency = {
95:             global: options.globalConfig?.REFRESH_CONCURRENCY_GLOBAL ?? 2, // 全局最大并行提供商数
96:             perProvider: options.globalConfig?.REFRESH_CONCURRENCY_PER_PROVIDER ?? 1 // 每个提供商内部最大并行数
97:         };
98:         
99:         this.activeProviderRefreshes = 0; // 当前正在刷新的提供商类型数量
100:         this.globalRefreshWaiters = []; // 等待全局并发槽位的任务
101:         
102:         this.warmupTarget = options.globalConfig?.WARMUP_TARGET || 0; // 默认预热0个节点
103:         this.refreshingUuids = new Set(); // 正在刷新的节点 UUID 集合
104:         
105:         this.refreshQueues = {}; // 按 providerType 分组的队列
106:         // 缓冲队列机制：延迟5秒，去重后再执行刷新
107:         this.refreshBufferQueues = {}; // 按 providerType 分组的缓冲队列
108:         this.refreshBufferTimers = {}; // 按 providerType 分组的定时器
109:         this.bufferDelay = options.globalConfig?.REFRESH_BUFFER_DELAY ?? 5000; // 默认5秒缓冲延迟
110:         this.refreshTaskTimeoutMs = options.globalConfig?.REFRESH_TASK_TIMEOUT_MS ?? 60000; // 默认60秒刷新超时
111:         
112:         // 用于并发选点时的原子排序辅助（自增序列）
113:         this._selectionSequence = 0;
114:  
115:         this.initializeProviderStatus();
116:     }
117: 
118:     /**
119:      * 强制刷新特定节点的令牌
120:      * @param {string} providerType 
121:      * @param {string} uuid 
122:      * @param {boolean} force 
123:      */
124:     async refreshNode(providerType, uuid, force = true) {
125:         const provider = this._findProvider(providerType, uuid);
126:         if (provider) {
127:             this._log('info', `Manually triggering refresh for node ${uuid} (${providerType})`);
128:             this._enqueueRefresh(providerType, provider, force);
129:             return true;
130:         }
131:         return false;
132:     }
133: 
134:     /**
135:      * 检查所有节点的配置文件，如果发现即将过期则触发刷新
136:      */
137:     async checkAndRefreshExpiringNodes() {
138:         this._log('info', 'Checking nodes for approaching expiration dates using provider adapters...');
139:         
140:         for (const providerType in this.providerStatus) {
141:             const providers = this.providerStatus[providerType];
142:             for (const providerStatus of providers) {
143:                 const config = providerStatus.config;
144:                 
145:                 // 根据 providerType 确定配置文件路径字段名
146:                 let configPath = null;
147:                 if (providerType.startsWith('claude-kiro')) {
148:                     configPath = config.KIRO_OAUTH_CREDS_FILE_PATH;
149:                 } else if (providerType.startsWith('gemini-cli')) {
150:                     configPath = config.GEMINI_OAUTH_CREDS_FILE_PATH;
151:                 } else if (providerType.startsWith('gemini-antigravity')) {
152:                     configPath = config.ANTIGRAVITY_OAUTH_CREDS_FILE_PATH;
153:                 } else if (providerType.startsWith('openai-qwen')) {
154:                     configPath = config.QWEN_OAUTH_CREDS_FILE_PATH;
155:                 } else if (providerType.startsWith('openai-iflow')) {
156:                     configPath = config.IFLOW_OAUTH_CREDS_FILE_PATH;
157:                 } else if (providerType.startsWith('openai-codex')) {
158:                     configPath = config.CODEX_OAUTH_CREDS_FILE_PATH;
159:                 }
160:                 
161:                 // logger.info(`Checking node ${providerStatus.uuid} (${providerType}) expiry date... configPath: ${configPath}`);
162:                 // 排除禁用的节点（不健康节点也应允许尝试刷新以恢复健康）
163:                 if (config.isDisabled) continue;
164: 
165:                 if (configPath) {
166:                     try {
167:                         const { readFile } = await import('node:fs/promises');
168:                         const fileContent = await readFile(configPath, 'utf-8');
169:                         const credData = JSON.parse(fileContent);
170:                         const rawExpiryTime = credData.expiry_date ?? credData.expiry ?? credData.expires_at ?? credData.expiresAt;
171:                         let expiryTime = null;
172:                         if (typeof rawExpiryTime === 'number') {
173:                             expiryTime = rawExpiryTime;
174:                         } else if (typeof rawExpiryTime === 'string') {
175:                             const parsedDate = Date.parse(rawExpiryTime);
176:                             expiryTime = Number.isNaN(parsedDate) ? Number(rawExpiryTime) : parsedDate;
177:                         }
178:                         const nearExpiryMs = (this.globalConfig?.CRON_NEAR_MINUTES || 10) * 60 * 1000;
179:                         if (!Number.isFinite(expiryTime)) {
180:                             // 凭据文件缺少 expiry 字段，无法判断是否快过期，作为安全措施强制刷新
181:                             this._log('warn', `Node ${providerStatus.uuid} (${providerType}) has no expiry field. Forcing refresh as safety measure...`);
182:                             this._enqueueRefresh(providerType, providerStatus);
183:                         } else if ((expiryTime - Date.now()) < nearExpiryMs) {
184:                             this._log('warn', `Node ${providerStatus.uuid} (${providerType}) is near expiration. Enqueuing refresh...`);
185:                             this._enqueueRefresh(providerType, providerStatus);
186:                         }
187:                     } catch (err) {
188:                         this._log('error', `Failed to check expiry for node ${providerStatus.uuid}: ${err.message}`);
189:                     }
190:                 } else {
191:                     this._log('debug', `Node ${providerStatus.uuid} (${providerType}) has no valid config file path or file does not exist.`);
192:                 }
193:             }
194:         }
195:     }
196: 
197:     /**
```

**tool:read** (completed) BlacklistedAIProxy/src/core/master.js

```
filePath=/home/x3/workspace/BlacklistedAIProxy/src/core/master.js
--- output ---
<path>/home/x3/workspace/BlacklistedAIProxy/src/core/master.js</path>
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
14: import { fork } from 'child_process';
15: import logger from '../utils/logger.js';
16: import * as http from 'http';
17: import * as path from 'path';
18: import { fileURLToPath } from 'url';
19: import { isRetryableNetworkError } from '../utils/common.js';
20: 
21: const __filename = fileURLToPath(import.meta.url);
22: const __dirname = path.dirname(__filename);
23: 
24: // 子进程实例
25: let workerProcess = null;
26: 
27: // 子进程状态
28: let workerStatus = {
29:     pid: null,
30:     startTime: null,
31:     restartCount: 0,
32:     lastRestartTime: null,
33:     isRestarting: false
34: };
35: 
36: // 配置
37: const config = {
38:     workerScript: path.join(__dirname, '../services/api-server.js'),
39:     maxRestartAttempts: 10,
40:     restartDelay: 1000, // 重启延迟（毫秒）
41:     masterPort: parseInt(process.env.MASTER_PORT) || 3100, // 主进程管理端口
42:     args: process.argv.slice(2) // 传递给子进程的参数
43: };
44: 
45: /**
46:  * 启动子进程
47:  */
48: function startWorker() {
49:     if (workerProcess) {
50:         logger.info('[Master] Worker process already running, PID:', workerProcess.pid);
51:         return;
52:     }
53: 
54:     logger.info('[Master] Starting worker process...');
55:     logger.info('[Master] Worker script:', config.workerScript);
56:     logger.info('[Master] Worker args:', config.args.join(' '));
57: 
58:     workerProcess = fork(config.workerScript, config.args, {
59:         stdio: ['inherit', 'inherit', 'inherit', 'ipc'],
60:         env: {
61:             ...process.env,
62:             IS_WORKER_PROCESS: 'true'
63:         }
64:     });
65: 
66:     workerStatus.pid = workerProcess.pid;
67:     workerStatus.startTime = new Date().toISOString();
68: 
69:     logger.info('[Master] Worker process started, PID:', workerProcess.pid);
70: 
71:     // 监听子进程消息
72:     workerProcess.on('message', (message) => {
73:         logger.info('[Master] Received message from worker:', message);
74:         handleWorkerMessage(message);
75:     });
76: 
77:     // 监听子进程退出
78:     workerProcess.on('exit', (code, signal) => {
79:         logger.info(`[Master] Worker process exited with code ${code}, signal ${signal}`);
80:         workerProcess = null;
81:         workerStatus.pid = null;
82: 
83:         // 如果不是主动重启导致的退出，尝试自动重启
84:         if (!workerStatus.isRestarting && code !== 0) {
85:             logger.info('[Master] Worker crashed, attempting auto-restart...');
86:             scheduleRestart();
87:         }
88:     });
89: 
90:     // 监听子进程错误
91:     workerProcess.on('error', (error) => {
92:         logger.error('[Master] Worker process error:', error.message);
93:     });
94: }
95: 
96: /**
97:  * 停止子进程
98:  * @param {boolean} graceful - 是否优雅关闭
99:  * @returns {Promise<void>}
100:  */
101: function stopWorker(graceful = true) {
102:     return new Promise((resolve) => {
103:         if (!workerProcess) {
104:             logger.info('[Master] No worker process to stop');
105:             resolve();
106:             return;
107:         }
108: 
109:         logger.info('[Master] Stopping worker process, PID:', workerProcess.pid);
110: 
111:         const timeout = setTimeout(() => {
112:             if (workerProcess) {
113:                 logger.info('[Master] Force killing worker process...');
114:                 workerProcess.kill('SIGKILL');
115:             }
116:             resolve();
117:         }, 5000); // 5秒超时后强制杀死
118: 
119:         workerProcess.once('exit', () => {
120:             clearTimeout(timeout);
121:             workerProcess = null;
122:             workerStatus.pid = null;
123:             logger.info('[Master] Worker process stopped');
124:             resolve();
125:         });
126: 
127:         if (graceful) {
128:             // 发送优雅关闭信号
129:             workerProcess.send({ type: 'shutdown' });
130:             workerProcess.kill('SIGTERM');
131:         } else {
132:             workerProcess.kill('SIGKILL');
133:         }
134:     });
135: }
136: 
137: /**
138:  * 重启子进程
139:  * @returns {Promise<Object>}
140:  */
141: async function restartWorker() {
142:     if (workerStatus.isRestarting) {
143:         logger.info('[Master] Restart already in progress');
144:         return { success: false, message: 'Restart already in progress' };
145:     }
146: 
147:     workerStatus.isRestarting = true;
148:     workerStatus.restartCount++;
149:     workerStatus.lastRestartTime = new Date().toISOString();
150: 
151:     logger.info('[Master] Restarting worker process...');
152: 
153:     try {
154:         await stopWorker(true);
155:         
156:         // 等待一小段时间确保端口释放
157:         await new Promise(resolve => setTimeout(resolve, config.restartDelay));
158:         
159:         startWorker();
160:         workerStatus.isRestarting = false;
161: 
162:         return {
163:             success: true,
164:             message: 'Worker restarted successfully',
165:             pid: workerStatus.pid,
166:             restartCount: workerStatus.restartCount
167:         };
168:     } catch (error) {
169:         workerStatus.isRestarting = false;
170:         logger.error('[Master] Failed to restart worker:', error.message);
171:         return {
172:             success: false,
173:             message: 'Failed to restart worker: ' + error.message
174:         };
175:     }
176: }
177: 
178: /**
179:  * 计划重启（用于崩溃后自动重启）
180:  */
181: function scheduleRestart() {
182:     if (workerStatus.restartCount >= config.maxRestartAttempts) {
183:         logger.error('[Master] Max restart attempts reached, giving up');
184:         return;
185:     }
186: 
187:     const delay = Math.min(config.restartDelay * Math.pow(2, workerStatus.restartCount), 30000);
188:     logger.info(`[Master] Scheduling restart in ${delay}ms...`);
189: 
190:     setTimeout(() => {
191:         restartWorker();
192:     }, delay);
193: }
194: 
195: /**
196:  * 处理来自子进程的消息
197:  * @param {Object} message - 消息对象
```

---

### 🤖 Assistant — 2026-09-16 02:00:13

---
