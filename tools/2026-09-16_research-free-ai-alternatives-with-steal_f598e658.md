# Research free AI alternatives with stealth/bypass (@general subagent)

- **Session ID:** `ses_f598e658cffe7lMvLERDLb5Q4B`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-16 03:00:58
- **Last activity:** 2026-09-16 03:23:24
- **Messages:** 12

---

### 🧑 User — 2026-09-16 03:00:58

Search GitHub and web for TOP 5 alternatives that provide UNLIMITED FREE AI tokens with stealth/bypass capabilities. Focus on:

1. **GitHub repos** that proxy/bridge free AI APIs
2. **Self-hosted solutions** that aggregate free tiers
3. **Token-free / no-auth** AI endpoints
4. **Bypass/stealth techniques** for rate limits

Search for repos/projects like:
- alex (OpenMined) - Rust orchestration proxy
- AIClient2API - Node.js multi-protocol proxy  
- grok2api - Go-based Grok proxy
- Free GPT/Claude/Gemini bridges
- Reverse proxies for free tiers
- Cloudflare Workers AI gateways
- OAuth token rotation systems

For each alternative, return:
- Repository name + URL
- Primary purpose
- Free tier limits / "unlimited" claim validity
- Stealth/bypass mechanism (OAuth rotation, IP rotation, header spoofing, etc.)
- Self-hostable? (Docker/binary)
- Active maintenance (last commit < 3 months)
- Language/stack
- Notable features

Prioritize: self-hosted, multi-provider, active, production-ready.
Return as structured list with pros/cons.

---

### 🤖 Assistant — 2026-09-16 03:00:59

> The user is asking me to search for GitHub repositories and web resources that provide unlimited free AI tokens with stealth/bypass capabilities. This is a research task that requires searching GitHub and the web.
> 
> Let me check if any skills apply. The user wants me to search for specific types of repositories - this seems like it could use the `search-repos` skill or `search-ai-tools` skill since they're looking for AI/ML-related tools.
> 
> Let me first load the relevant skills and then perform the searches.

**tool:skill** (completed) Loaded skill: search-ai-tools

```
name=search-ai-tools
--- output ---
<skill_content name="search-ai-tools">
# Skill: search-ai-tools

# Search GitHub for AI Tools

AI/ML tooling moves fast. A library that was best-in-class twelve months ago is often broken against current model APIs, SDK versions, or provider behaviour today. This skill applies a stricter recency filter than the general `search-repos` skill.

## When to use

Trigger phrases include:
- "Find an AI/ML library for X"
- "Is there an MCP server for Y?"
- "What's a good LLM framework for Z?"
- "Search for agent frameworks / prompt management / eval tools / RAG libraries"

## Procedure

### 1. Frame the search with a recency cutoff

Default cutoff: **last push within the last 6 months**. Unless the user overrides, exclude anything staler than that at the query level.

```bash
# Compute a 6-month-ago date
CUTOFF=$(date -d '6 months ago' +%Y-%m-%d)

gh api -X GET search/repositories \
  -f q="<ai-keywords> pushed:>$CUTOFF" \
  -f sort=stars -f order=desc --jq '.items[] | {
    full_name, stars: .stargazers_count, pushed_at, updated_at,
    language, license: .license.spdx_id,
    open_issues: .open_issues_count,
    description, url: .html_url
  }'
```

Useful query operators to combine:
- `topic:llm`, `topic:agents`, `topic:rag`, `topic:mcp`, `topic:prompt-engineering`
- `stars:>50` to strip hobby projects
- `archived:false`

### 2. Tier the results

Sort candidates into three tiers based on recency, then by stars within each tier:

- **Active** — pushed within last 30 days
- **Maintained** — pushed 1–6 months ago
- **Stale (⚠️)** — pushed 6–12 months ago; include only if the user explicitly asked for a complete picture
- **Dead** — pushed > 12 months ago; exclude entirely unless specifically requested

### 3. Look for activity signals beyond last-push

- **Recent releases** — `gh api repos/<owner>/<repo>/releases --jq '.[0].published_at'`
- **Commit cadence** — `gh api repos/<owner>/<repo>/commits --jq '[.[].commit.author.date] | .[:5]'`
- **Open PRs** — healthy projects have a steady stream, not hundreds untouched

Flag projects where last-push is recent but commits are only dependency bumps (Dependabot churn) — that's not real maintenance.

### 4. Present results

Output grouped by tier. For each candidate include:

- Full name, stars, last push ("N days/weeks/months ago")
- Language, license, open-issue count
- One-sentence summary of what it does
- A short note on maintenance signal ("active releases", "only Dependabot commits", "solo maintainer", etc.) where visible

### 5. Offer next steps

- Deeper evaluation via `evaluate-candidates`
- Documentation via `document-findings` (AI research especially benefits from date stamping — what's good today may be obsolete in 3 months)

## Guidance

- **A 2k-star AI project last updated 14 months ago is almost always worse than a 200-star project updated yesterday.** Say so explicitly.
- **Watch for abandoned demos** — viral projects from blog posts or tweet threads often look popular but have no ongoing maintenance.
- **LLM API compatibility rots fast.** Anything predating the current model generations may be broken.
- Do not invent projects. Report only what the CLI returned.

Base directory for this skill: /home/x3/.opencode/skills/search-ai-tools
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

**tool:skill** (completed) Loaded skill: search-repos

```
name=search-repos
--- output ---
<skill_content name="search-repos">
# Skill: search-repos

# Search GitHub Repos

Help the user discover existing GitHub projects that address a stated need, so they can evaluate whether to use, fork, or integrate one instead of building from scratch.

## When to use

Trigger phrases include:
- "Is there already a tool/library/CLI/plugin for X?"
- "Search GitHub for Y"
- "What are the top projects for Z?"
- "Before I build this, check if it already exists"

## Procedure

### 1. Clarify the query if needed

Ask the user at most one short clarifying question only if the target is genuinely ambiguous. Otherwise translate their request into search terms directly.

### 2. Run the search

Use `gh search repos` with sensible defaults. Start broad, then narrow if results are too noisy.

```bash
gh search repos "<keywords>" \
  --sort stars \
  --limit 20 \
  --json name,owner,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt
```

Use `--language=<lang>` when the user specified a language. Use topic filters (`--topic=<topic>`) when a canonical topic tag applies (e.g. `--topic=cli`, `--topic=mcp`).

For richer queries (e.g. combining topic with minimum stars), use `gh api`:

```bash
gh api -X GET search/repositories \
  -f q='<keywords> stars:>100 pushed:>2025-01-01' \
  -f sort=stars -f order=desc --jq '.items[] | {name, full_name: .full_name, stars: .stargazers_count, pushed: .pushed_at, language, license: .license.spdx_id, open_issues: .open_issues_count, description, url: .html_url}'
```

### 3. Rank and filter

From the returned set, build a shortlist of the top 5–10 candidates. For each candidate, capture:

- Full name (`owner/repo`)
- Stars
- Last push date (convert to "N months ago" for readability)
- Open issues
- License (flag missing/unclear licenses)
- Primary language
- One-sentence description

Drop candidates that are obviously off-topic (wrong language, archive/mirror, gist-style one-liners) unless the user explicitly wants all results.

### 4. Present results

Output a compact table or list, ordered by stars, but call out any candidates that look abandoned (last push > 12 months ago) with a ⚠️ marker. Offer the user a next step: dive deeper on a specific candidate (hand off to `evaluate-candidates`), broaden/narrow the search, or document findings to `planning/` (hand off to `document-findings`).

### 5. Keep the exact query

Preserve the exact `gh` command you ran. If the user later asks to document the findings, that query must be recorded alongside the research date so results are reproducible.

## Guidance

- **Stars are a rough signal, not the whole story.** A 500-star repo updated last week often beats a 10k-star repo abandoned in 2022.
- **Archived repos** (`--archived=false` by default on newer `gh`) should be excluded unless the user wants historical context.
- **Forks with more stars than the upstream** sometimes indicate the project has moved — note this.
- Do not invent repository names. Only report what the CLI actually returned.

Base directory for this skill: /home/x3/.opencode/skills/search-repos
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

---

### 🤖 Assistant — 2026-09-16 03:01:56

> Now I need to search for these repositories. Let me use the GitHub search functionality to find the specific repositories mentioned (alex, AIClient2API, grok2api) and also search for broader terms like "free AI proxy", "reverse proxy AI", "token bypass", etc.
> 
> I'll use the GitHub search tools available to me.

**tool:github_search_repositories** (completed) 

```
query=alex OpenMined Rust orchestration proxy AI; perPage=10
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=AIClient2API Node.js multi-protocol proxy; perPage=10
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=grok2api Go Grok proxy; perPage=10
--- output ---
{
  "total_count": 1,
  "incomplete_results": false,
  "items": [
    {
      "id": 1341445986,
      "node_id": "R_kgDOT_TXYg",
      "name": "grok2api-go",
      "full_name": "lison8080/grok2api-go",
      "private": false,
      "owner": {
        "login": "lison8080",
        "id": 198198163,
        "node_id": "U_kgDOC9BDkw",
        "avatar_url": "https://avatars.githubusercontent.com/u/198198163?v=4",
        "url": "https://api.github.com/users/lison8080",
        "html_url": "https://github.com/lison8080",
        "type": "User"
      },
      "html_url": "https://github.com/lison8080/grok2api-go",
      "description": "grok2api Go backend with Webshare proxy pool",
      "fork": false,
      "url": "https://api.github.com/repos/lison8080/grok2api-go",
      "created_at": "2026-08-21T05:45:58Z",
      "updated_at": "2026-08-21T05:51:02Z",
      "pushed_at": "2026-08-21T05:47:14Z",
      "git_url": "git://github.com/lison8080/grok2api-go.git",
      "ssh_url": "git@github.com:lison8080/grok2api-go.git",
      "clone_url": "https://github.com/lison8080/grok2api-go.git",
      "default_branch": "main"
    }
  ]
}
```

---

### 🤖 Assistant — 2026-09-16 03:03:34

> Good, I found grok2api-go. Now let me search for broader terms related to free AI proxies, reverse proxies, token bypass, etc.

**tool:github_search_repositories** (completed) 

```
perPage=15; query=free AI proxy reverse proxy OpenAI Claude Gemini bridge
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
perPage=15; query=token bypass rate limit OAuth rotation AI
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
perPage=15; query=Cloudflare Workers AI gateway free tier
--- output ---
{
  "total_count": 3,
  "incomplete_results": false,
  "items": [
    {
      "id": 1231305466,
      "node_id": "R_kgDOSWQ6-g",
      "name": "FreeRideV3",
      "full_name": "Shaivpidadi/FreeRideV3",
      "private": false,
      "owner": {
        "login": "Shaivpidadi",
        "id": 26166520,
        "node_id": "MDQ6VXNlcjI2MTY2NTIw",
        "avatar_url": "https://avatars.githubusercontent.com/u/26166520?v=4",
        "url": "https://api.github.com/users/Shaivpidadi",
        "html_url": "https://github.com/Shaivpidadi",
        "type": "User"
      },
      "html_url": "https://github.com/Shaivpidadi/FreeRideV3",
      "description": "One free AI endpoint, every free tier behind it. Local OpenAI-compatible gateway routing across OpenRouter, Groq, NVIDIA NIM, Cloudflare Workers AI, and HuggingFace with automatic failover.",
      "fork": false,
      "url": "https://api.github.com/repos/Shaivpidadi/FreeRideV3",
      "created_at": "2026-05-06T20:46:59Z",
      "updated_at": "2026-09-14T13:55:50Z",
      "pushed_at": "2026-09-14T05:28:54Z",
      "git_url": "git://github.com/Shaivpidadi/FreeRideV3.git",
      "ssh_url": "git@github.com:Shaivpidadi/FreeRideV3.git",
      "clone_url": "https://github.com/Shaivpidadi/FreeRideV3.git",
      "default_branch": "main"
    },
    {
      "id": 1281823570,
      "node_id": "R_kgDOTGcTUg",
      "name": "cloudflare-llm-gateway",
      "full_name": "leeguooooo/cloudflare-llm-gateway",
      "private": false,
      "owner": {
        "login": "leeguooooo",
        "id": 9278645,
        "node_id": "MDQ6VXNlcjkyNzg2NDU=",
        "avatar_url": "https://avatars.githubusercontent.com/u/9278645?v=4",
        "url": "https://api.github.com/users/leeguooooo",
        "html_url": "https://github.com/leeguooooo",
        "type": "User"
      },
      "html_url": "https://github.com/leeguooooo/cloudflare-llm-gateway",
      "description": "A serverless, OpenAI-compatible LLM API gateway for Cloudflare Workers — a new-api / one-api alternative that runs on the free tier (Workers + D1, no server).",
      "fork": false,
      "url": "https://api.github.com/repos/leeguooooo/cloudflare-llm-gateway",
      "created_at": "2026-06-27T01:06:47Z",
      "updated_at": "2026-09-07T09:59:43Z",
      "pushed_at": "2026-08-05T08:34:24Z",
      "git_url": "git://github.com/leeguooooo/cloudflare-llm-gateway.git",
      "ssh_url": "git@github.com:leeguooooo/cloudflare-llm-gateway.git",
      "clone_url": "https://github.com/leeguooooo/cloudflare-llm-gateway.git",
      "default_branch": "main"
    },
    {
      "id": 1158400711,
      "node_id": "R_kgDORQvKxw",
      "name": "free-ai",
      "full_name": "sass-maker/free-ai",
      "private": false,
      "owner": {
        "login": "sass-maker",
        "id": 305889503,
        "node_id": "O_kgDOEjuA3w",
        "avatar_url": "https://avatars.githubusercontent.com/u/305889503?v=4",
        "url": "https://api.github.com/users/sass-maker",
        "html_url": "https://github.com/sass-maker",
        "type": "Organization"
      },
      "html_url": "https://github.com/sass-maker/free-ai",
      "description": "OpenAI-compatible gateway across free-tier model providers with health-aware routing on Cloudflare Workers.",
      "fork": false,
      "url": "https://api.github.com/repos/sass-maker/free-ai",
      "created_at": "2026-02-15T10:02:14Z",
      "updated_at": "2026-09-11T21:22:14Z",
      "pushed_at": "2026-09-11T21:22:10Z",
      "git_url": "git://github.com/sass-maker/free-ai.git",
      "ssh_url": "git@github.com:sass-maker/free-ai.git",
      "clone_url": "https://github.com/sass-maker/free-ai.git",
      "default_branch": "main"
    }
  ]
}
```

---

### 🤖 Assistant — 2026-09-16 03:04:44

> Good, I found some relevant Cloudflare Workers AI gateways. Let me search for more specific terms like "one-api", "new-api", "AI gateway", "multi-provider proxy", etc

**tool:github_search_repositories** (completed) 

```
query=one-api new-api AI gateway multi-provider OpenAI compatible; perPage=15
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=openai-reverse-proxy claude-reverse-proxy gemini-reverse-proxy; perPage=15
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=free-gpt free-claude free-gemini no-auth AI endpoint; perPage=15
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

---

### 🤖 Assistant — 2026-09-16 03:05:54

> The search queries with hyphens might not be working well. Let me try broader searches

**tool:github_search_repositories** (completed) 

```
perPage=15; query=oneapi AI gateway LLM proxy
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=openai compatible gateway free tier; perPage=15
--- output ---
{
  "total_count": 28,
  "incomplete_results": false,
  "items": [
    {
      "id": 1231305466,
      "node_id": "R_kgDOSWQ6-g",
      "name": "FreeRideV3",
      "full_name": "Shaivpidadi/FreeRideV3",
      "private": false,
      "owner": {
        "login": "Shaivpidadi",
        "id": 26166520,
        "node_id": "MDQ6VXNlcjI2MTY2NTIw",
        "avatar_url": "https://avatars.githubusercontent.com/u/26166520?v=4",
        "url": "https://api.github.com/users/Shaivpidadi",
        "html_url": "https://github.com/Shaivpidadi",
        "type": "User"
      },
      "html_url": "https://github.com/Shaivpidadi/FreeRideV3",
      "description": "One free AI endpoint, every free tier behind it. Local OpenAI-compatible gateway routing across OpenRouter, Groq, NVIDIA NIM, Cloudflare Workers AI, and HuggingFace with automatic failover.",
      "fork": false,
      "url": "https://api.github.com/repos/Shaivpidadi/FreeRideV3",
      "created_at": "2026-05-06T20:46:59Z",
      "updated_at": "2026-09-14T13:55:50Z",
      "pushed_at": "2026-09-14T05:28:54Z",
      "git_url": "git://github.com/Shaivpidadi/FreeRideV3.git",
      "ssh_url": "git@github.com:Shaivpidadi/FreeRideV3.git",
      "clone_url": "https://github.com/Shaivpidadi/FreeRideV3.git",
      "default_branch": "main"
    },
    {
      "id": 1340213355,
      "node_id": "R_kgDOT-IIaw",
      "name": "freebuff-9router",
      "full_name": "0xgetz/freebuff-9router",
      "private": false,
      "owner": {
        "login": "0xgetz",
        "id": 219692780,
        "node_id": "U_kgDODRg-7A",
        "avatar_url": "https://avatars.githubusercontent.com/u/219692780?v=4",
        "url": "https://api.github.com/users/0xgetz",
        "html_url": "https://github.com/0xgetz",
        "type": "User"
      },
      "html_url": "https://github.com/0xgetz/freebuff-9router",
      "description": "Free OpenAI-compatible LLM access via Codebuff/Freebuff free tier, wired into a 9router gateway: device-code OAuth, local adapter, auto model registration",
      "fork": false,
      "url": "https://api.github.com/repos/0xgetz/freebuff-9router",
      "created_at": "2026-08-20T02:43:20Z",
      "updated_at": "2026-09-04T16:44:45Z",
      "pushed_at": "2026-08-20T02:45:02Z",
      "git_url": "git://github.com/0xgetz/freebuff-9router.git",
      "ssh_url": "git@github.com:0xgetz/freebuff-9router.git",
      "clone_url": "https://github.com/0xgetz/freebuff-9router.git",
      "default_branch": "main"
    },
    {
      "id": 1159802100,
      "node_id": "R_kgDORSEs9A",
      "name": "Hydra-gemini",
      "full_name": "LikithMeruvu/Hydra-gemini",
      "private": false,
      "owner": {
        "login": "LikithMeruvu",
        "id": 110189869,
        "node_id": "U_kgDOBpFdLQ",
        "avatar_url": "https://avatars.githubusercontent.com/u/110189869?v=4",
        "url": "https://api.github.com/users/LikithMeruvu",
        "html_url": "https://github.com/LikithMeruvu",
        "type": "User"
      },
      "html_url": "https://github.com/LikithMeruvu/Hydra-gemini",
      "description": "GeminiHydra is an OpenAI-compatible API gateway that unlocks unlimited free-tier usage by aggregating multiple Google Gemini keys. Features automatic failover, rate-limit rotation, load balancing, and secure Cloudflare tunneling for remote access. includes a local dashboard for real-time monitoring.",
      "fork": false,
      "url": "https://api.github.com/repos/LikithMeruvu/Hydra-gemini",
      "created_at": "2026-02-17T07:10:28Z",
      "updated_at": "2026-09-07T02:09:26Z",
      "pushed_at": "2026-02-17T16:10:55Z",
      "git_url": "git://github.com/LikithMeruvu/Hydra-gemini.git",
      "ssh_url": "git@github.com:LikithMeruvu/Hydra-gemini.git",
      "clone_url": "https://github.com/LikithMeruvu/Hydra-gemini.git",
      "default_branch": "main"
    },
    {
      "id": 1260447354,
      "node_id": "R_kgDOSyDmeg",
      "name": "FreeAIGateway",
      "full_name": "Hansade2005/FreeAIGateway",
      "private": false,
      "owner": {
        "login": "Hansade2005",
        "id": 141965424,
        "node_id": "U_kgDOCHY4cA",
        "avatar_url": "https://avatars.githubusercontent.com/u/141965424?v=4",
        "url": "https://api.github.com/users/Hansade2005",
        "html_url": "https://github.com/Hansade2005",
        "type": "User"
      },
      "html_url": "https://github.com/Hansade2005/FreeAIGateway",
      "description": "FreeAIGateway One gateway, two protocols, sixteen providers — zero cost.  FreeAIGateway — An OpenAI & Anthropic compatible proxy that aggregates free tiers from 16+ LLM providers (~1.7B tokens/month) behind a single /v1 endpoint and a Claude-compatible endpoint. Smart routing, automatic failover, encrypted key storage. For personal experimentation ",
      "fork": false,
      "url": "https://api.github.com/repos/Hansade2005/FreeAIGateway",
      "created_at": "2026-06-05T13:58:39Z",
      "updated_at": "2026-08-31T09:37:49Z",
      "pushed_at": "2026-08-30T18:47:32Z",
      "git_url": "git://github.com/Hansade2005/FreeAIGateway.git",
      "ssh_url": "git@github.com:Hansade2005/FreeAIGateway.git",
      "clone_url": "https://github.com/Hansade2005/FreeAIGateway.git",
      "default_branch": "main"
    },
    {
      "id": 1246903873,
      "node_id": "R_kgDOSlI-QQ",
      "name": "Freeloader",
      "full_name": "Arnav8452/Freeloader",
      "private": false,
      "owner": {
        "login": "Arnav8452",
        "id": 115414384,
        "node_id": "U_kgDOBuEVcA",
        "avatar_url": "https://avatars.githubusercontent.com/u/115414384?v=4",
        "url": "https://api.github.com/users/Arnav8452",
        "html_url": "https://github.com/Arnav8452",
        "type": "User"
      },
      "html_url": "https://github.com/Arnav8452/Freeloader",
      "description": "Freeloader is an OpenAI-compatible AI gateway that maximizes free-tier LLM usage. It intelligently cascades requests across providers like Gemini, Groq, Cerebras, and Ollama. With built-in circuit breakers, automatic failover, and quota tracking, you get enterprise-grade API reliability and zero downtime without paying a single cent.",
      "fork": false,
      "url": "https://api.github.com/repos/Arnav8452/Freeloader",
      "created_at": "2026-05-22T17:25:23Z",
      "updated_at": "2026-06-28T22:50:09Z",
      "pushed_at": "2026-06-04T21:35:59Z",
      "git_url": "git://github.com/Arnav8452/Freeloader.git",
      "ssh_url": "git@github.com:Arnav8452/Freeloader.git",
      "clone_url": "https://github.com/Arnav8452/Freeloader.git",
      "default_branch": "main"
    },
    {
      "id": 1281823570,
      "node_id": "R_kgDOTGcTUg",
      "name": "cloudflare-llm-gateway",
      "full_name": "leeguooooo/cloudflare-llm-gateway",
      "private": false,
      "owner": {
        "login": "leeguooooo",
        "id": 9278645,
        "node_id": "MDQ6VXNlcjkyNzg2NDU=",
        "avatar_url": "https://avatars.githubusercontent.com/u/9278645?v=4",
        "url": "https://api.github.com/users/leeguooooo",
        "html_url": "https://github.com/leeguooooo",
        "type": "User"
      },
      "html_url": "https://github.com/leeguooooo/cloudflare-llm-gateway",
      "description": "A serverless, OpenAI-compatible LLM API gateway for Cloudflare Workers — a new-api / one-api alternative that runs on the free tier (Workers + D1, no server).",
      "fork": false,
      "url": "https://api.github.com/repos/leeguooooo/cloudflare-llm-gateway",
      "created_at": "2026-06-27T01:06:47Z",
      "updated_at": "2026-09-07T09:59:43Z",
      "pushed_at": "2026-08-05T08:34:24Z",
      "git_url": "git://github.com/leeguooooo/cloudflare-llm-gateway.git",
      "ssh_url": "git@github.com:leeguooooo/cloudflare-llm-gateway.git",
      "clone_url": "https://github.com/leeguooooo/cloudflare-llm-gateway.git",
      "default_branch": "main"
    },
    {
      "id": 1261625443,
      "node_id": "R_kgDOSzLgYw",
      "name": "freelm",
      "full_name": "shihabshahrier/freelm",
      "private": false,
      "owner": {
        "login": "shihabshahrier",
        "id": 77823774,
        "node_id": "MDQ6VXNlcjc3ODIzNzc0",
        "avatar_url": "https://avatars.githubusercontent.com/u/77823774?v=4",
        "url": "https://api.github.com/users/shihabshahrier",
        "html_url": "https://github.com/shihabshahrier",
        "type": "User"
      },
      "html_url": "https://github.com/shihabshahrier/freelm",
      "description": "Free, always-up LLM client & gateway for Python and TypeScript — one OpenAI-compatible API over free-tier OpenRouter, Google Gemini, NVIDIA NIM, Groq, Cerebras & Mistral with automatic failover, key rotation, streaming and live model discovery.",
      "fork": false,
      "url": "https://api.github.com/repos/shihabshahrier/freelm",
      "created_at": "2026-06-07T00:09:56Z",
      "updated_at": "2026-09-09T00:16:34Z",
      "pushed_at": "2026-09-09T00:16:24Z",
      "git_url": "git://github.com/shihabshahrier/freelm.git",
      "ssh_url": "git@github.com:shihabshahrier/freelm.git",
      "clone_url": "https://github.com/shihabshahrier/freelm.git",
      "default_branch": "main"
    },
    {
      "id": 1270405751,
      "node_id": "R_kgDOS7jadw",
      "name": "freeapijust",
      "full_name": "kayonarah/freeapijust",
      "private": false,
      "owner": {
```

**tool:github_search_repositories** (completed) 

```
perPage=15; query=llm proxy load balancer free
--- output ---
{
  "total_count": 4,
  "incomplete_results": false,
  "items": [
    {
      "id": 1319547583,
      "node_id": "R_kgDOTqayvw",
      "name": "FreeLLM-Gateway",
      "full_name": "Majidi-star/FreeLLM-Gateway",
      "private": false,
      "owner": {
        "login": "Majidi-star",
        "id": 198458610,
        "node_id": "U_kgDOC9Q88g",
        "avatar_url": "https://avatars.githubusercontent.com/u/198458610?v=4",
        "url": "https://api.github.com/users/Majidi-star",
        "html_url": "https://github.com/Majidi-star",
        "type": "User"
      },
      "html_url": "https://github.com/Majidi-star/FreeLLM-Gateway",
      "description": "Universal free LLM proxy & intelligent load balancer. Auto-discover models, enforce custom rate limits (RPM/RPD), route requests through split-tunnel VPNs, and configure seamless multi-tier fallback chains.",
      "fork": false,
      "url": "https://api.github.com/repos/Majidi-star/FreeLLM-Gateway",
      "created_at": "2026-08-01T18:46:44Z",
      "updated_at": "2026-09-14T10:17:41Z",
      "pushed_at": "2026-09-14T10:17:36Z",
      "git_url": "git://github.com/Majidi-star/FreeLLM-Gateway.git",
      "ssh_url": "git@github.com:Majidi-star/FreeLLM-Gateway.git",
      "clone_url": "https://github.com/Majidi-star/FreeLLM-Gateway.git",
      "default_branch": "main"
    },
    {
      "id": 1269100818,
      "node_id": "R_kgDOS6TxEg",
      "name": "litellm-free-models",
      "full_name": "natorus87/litellm-free-models",
      "private": false,
      "owner": {
        "login": "natorus87",
        "id": 150910178,
        "node_id": "U_kgDOCP604g",
        "avatar_url": "https://avatars.githubusercontent.com/u/150910178?v=4",
        "url": "https://api.github.com/users/natorus87",
        "html_url": "https://github.com/natorus87",
        "type": "User"
      },
      "html_url": "https://github.com/natorus87/litellm-free-models",
      "description": "LiteLLM proxy aggregating 13 free LLM providers (OpenRouter, Cerebras, Groq, Cloudflare, NVIDIA, Mistral, Cohere, GitHub Models, OpenCode Zen, LLM7.io, HuggingFace, OVHcloud, Google AI Studio) with auto load-balancing, fallback chains, and template-based config generation.",
      "fork": false,
      "url": "https://api.github.com/repos/natorus87/litellm-free-models",
      "created_at": "2026-06-14T10:02:01Z",
      "updated_at": "2026-09-09T17:33:28Z",
      "pushed_at": "2026-09-14T06:15:12Z",
      "git_url": "git://github.com/natorus87/litellm-free-models.git",
      "ssh_url": "git@github.com:natorus87/litellm-free-models.git",
      "clone_url": "https://github.com/natorus87/litellm-free-models.git",
      "default_branch": "main"
    },
    {
      "id": 1329530870,
      "node_id": "R_kgDOTz8H9g",
      "name": "free-ai-proxy-gateway",
      "full_name": "freellms/free-ai-proxy-gateway",
      "private": false,
      "owner": {
        "login": "freellms",
        "id": 315023510,
        "node_id": "U_kgDOEsbglg",
        "avatar_url": "https://avatars.githubusercontent.com/u/315023510?v=4",
        "url": "https://api.github.com/users/freellms",
        "html_url": "https://github.com/freellms",
        "type": "User"
      },
      "html_url": "https://github.com/freellms/free-ai-proxy-gateway",
      "description": "Free AI proxy gateway — route requests across 30+ LLM providers (Groq, Gemini, Mistral, Cohere, OpenRouter, NVIDIA NIM) through one OpenAI-compatible endpoint. Build your own LLM proxy, AI router, and multi-provider gateway. Failover & load balancing.",
      "fork": false,
      "url": "https://api.github.com/repos/freellms/free-ai-proxy-gateway",
      "created_at": "2026-08-10T07:08:23Z",
      "updated_at": "2026-08-10T07:15:29Z",
      "pushed_at": "2026-08-10T07:10:58Z",
      "git_url": "git://github.com/freellms/free-ai-proxy-gateway.git",
      "ssh_url": "git@github.com:freellms/free-ai-proxy-gateway.git",
      "clone_url": "https://github.com/freellms/free-ai-proxy-gateway.git",
      "default_branch": "main"
    },
    {
      "id": 1344042423,
      "node_id": "R_kgDOUBx1tw",
      "name": "freemaxxing",
      "full_name": "miiidev/freemaxxing",
      "private": false,
      "owner": {
        "login": "miiidev",
        "id": 92585197,
        "node_id": "U_kgDOBYS87Q",
        "avatar_url": "https://avatars.githubusercontent.com/u/92585197?v=4",
        "url": "https://api.github.com/users/miiidev",
        "html_url": "https://github.com/miiidev",
        "type": "User"
      },
      "html_url": "https://github.com/miiidev/freemaxxing",
      "description": "A local, OpenAI-compatible AI proxy that pools free-tier models across OpenRouter, Groq, Google AI Studio, Mistral, and Cerebras—with smart routing, automatic rate-limit failover, and quota-aware load balancing.",
      "fork": false,
      "url": "https://api.github.com/repos/miiidev/freemaxxing",
      "created_at": "2026-08-23T17:37:39Z",
      "updated_at": "2026-09-05T17:22:53Z",
      "pushed_at": "2026-09-05T17:22:49Z",
      "git_url": "git://github.com/miiidev/freemaxxing.git",
      "ssh_url": "git@github.com:miiidev/freemaxxing.git",
      "clone_url": "https://github.com/miiidev/freemaxxing.git",
      "default_branch": "master"
    }
  ]
}
```

---

### 🤖 Assistant — 2026-09-16 03:07:15

> Now I have a lot of results. Let me also search for the specific projects the user mentioned - "alex (OpenMined)", and also search for some other relevant terms.

**tool:github_search_repositories** (completed) 

```
perPage=10; query=OpenMined alex Rust AI orchestration
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
perPage=10; query=lobe-chat proxy free tier
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
query=big-agi free tier proxy; perPage=10
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

---

### 🤖 Assistant — 2026-09-16 03:08:51

> Let me search for some more specific projects and also do a web search to find additional resources that might not be on GitHub.

**tool:parallel-search_web_search** (completed) 

```
search_queries=['alex OpenMined Rust AI orchestration proxy', 'AIClient2API Node.js multi-proto; objective=Find AI proxy projects that provide unlimited free tokens with stealth/bypass ca
--- output ---
{
  "search_id": "search_bda47c96a8f0caf4793fd1922c48984c",
  "results": [
    {
      "url": "https://github.com/topics/grok2api",
      "title": "grok2api · GitHub Topics · GitHub",
      "publish_date": null,
      "excerpts": [
        "* AaronL725/grok-register: 批量稳定注册 Grok 账号，支持 WebUI/GUI/CLI、多邮箱服务、多线程并发、账号级多协议代理池、grok2api 入池、SSO 风控筛查与CPA OIDC 凭证导出。\n* dairoot/Grok-Mirror: 🚀 一键部署个人的 Grok 镜像站\n* lij768423-svg/grok-register-panel: Grok 批量注册 (Camoufox) + 实时 Web 监控面板 | Batch Grok registration engine with live panel — concurrency · ASN blacklist · proxy pool · token auth\n* FakeOAI/tokens: Tokens管理平台，调度管理号池将各大国外AI平台的模型转化为OpenAI、Anthropic、Gemini等平台的API接口标准格式，支持Claude Code、Codex、GeminiCli等终端调用\n* lij768423-svg/grok2api-egress-enhancements: Grok2API & CPA egress quality guard with proxy recovery, quarantine, migration, and operations UI\n* XeanYu/grok2api-rs: 基于原grok2api项目进行重构的rust版本以及增加了些许功能\n* chukwuemekawisdom/claude2api: 将Claude 的网页服务转为 Api 服务，支持识图，文件上传，思考输出……\n* owen891/grok2api: 二开版，新增2种注册方式的注册机、在线聊天会话、在线生图与管理后台功能。\n* anshulrules/Antigravity2Api: 🚀 Transform Antigravity into standard Claude and Gemini APIs, enabling seamless tool use, structured outputs, and workaround support for MCP issues.\n* AlwanMusyaffa/cursor2api\n* nwz4/claude-code-research-assist: 面向科研检索、论文对比、idea 发散与结论核验的统一 Claude Code skill。\n* shitianyaa/astrbot_plugin_grok2api_sub: 通过 grok2api Client Key 提供联网搜索、生图、改图和生视频，支持 OneBot/NapCat 与 QQ Official\n* CassiopeiaCode/grok2api-resin-egress-enhancements: Grok2API fork with Resin sticky egress, token-speed quality detection, shared Build/Web/Console IP rotation, and timeout protection"
      ]
    },
    {
      "url": "http://45.136.13.115:8083/OpenMined/alex",
      "title": "GitHub - OpenMined/alex: Alex — a local LLM proxy for all your token providers, APIs and harnesses. Route Claude, ChatGPT/Codex, Gemini, Grok, Kimi & OpenRouter subscriptions into any coding tool. Your tokens, your traces, your choice. · GitHub",
      "publish_date": null,
      "excerpts": [
        "Repository files navigation\n* README\n* Code of conduct\n* Contributing\n* Apache-2.0 license\n* MIT license\n  More items\nAlex — a local LLM proxy for AI subscriptions and coding harnesses\nAlex connects supported terminal harnesses to supported LLM providers through one local proxy\ncrates.io CI macOS ARM64 Windows x86-64 alpha Windows ARM64 alpha Linux x86-64 Linux ARM64\nYour tokens, your traces, your choice!\nClick here to see a DEMO\nAlex live demo page with Cove replay player\nProblems Alex fixes\nQuickstart\nExtra Benefits of LLM Proxies\nPAM — Pi Agents Mixed\nuse kimi/k3 instead of fable in ultra mode\nMost AI tools lock together three things that should be separate :\nuse kimi/k3 instead of fable in ultra mode\nIt is a local LLM proxy that connects Claude, ChatGPT/Codex, Gemini, Grok, Kimi, OpenRouter, Exo, and CLIProxyAPI to one loopback service exposing OpenAI-, Anthropic-, and Gemini-compatible ingress.\nuse kimi/k3 instead of fable in ultra mode\nCapture activity from tools like Amp and Cursor.\n* A Rust daemon that stays up.\n* Use Anthropic subscriptions from compatible API clients and connected harnesses. Route eligible traffic through Dario .\n* Analyze or train on your data. Your tokens, your traces.\n* Mix and match token sources.\nuse kimi/k3 instead of fable in ultra mode\nCombine subscriptions and providers such as OpenAI, Anthropic, Grok, and OpenRouter.\nOnce you use more than one coding agent or AI subscription, the setup becomes fragmented:\nuse kimi/k3 instead of fable in ultra mode\neach harness supports different providers and API formats; subscription credentials expire and require different login flows; agent and subagent activity disappears across separate tools; rate limits, usage windows, and costs are difficult to understand; swit"
      ]
    },
    {
      "url": "https://github.com/OpenMined/alex/blob/main/docs/README.md",
      "title": "alex/docs/README.md at main · OpenMined/alex",
      "publish_date": null,
      "excerpts": [
        "alex/docs/README.md at main · OpenMined/alex\n5 days ago — Alex — a local LLM proxy for all your token providers, APIs and harnesses. Route Claude, ChatGPT/Codex, Gemini, Grok, Kimi & OpenRouter\n > \nalex/docs/README.md at main · OpenMined/alex\n7 days ago — Doc, What it covers. Overview, Crate responsibilities, request/data flow, authentication scopes, and the local state model."
      ]
    },
    {
      "url": "https://github.com/justlovemaki/AIClient2API",
      "title": "GitHub - justlovemaki/AIClient2API: Self-hosted multi-protocol AI API proxy for Antigravity, Codex, Grok, Kiro, OpenAI, Claude, and custom providers. Supports OpenAI-compatible API, Claude API, Gemini protocol conversion, GPT, Grok Build, Claude Opus, Gemini Pro, Kimi, MiniMax, provider pools, smart routing, and automatic failover. · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Page: GitHub repository\n* URL: https://github.com/justlovemaki/AIClient2API\n* Description: Self-hosted multi-protocol AI API proxy for Antigravity, Codex, Grok, Kiro, OpenAI, Claude, and custom providers. Supports OpenAI-compatible API, Claude API, Gemini protocol conversion, GPT, Grok B...\n* Stars: 8,723\n* Forks: 1,376\n* License: GPL-3.0 license\nREADME.md\nlogo\nAIClient2API（A2）🚀\nA powerful proxy that can unify the requests of various client-only large model APIs (Antigravity, Codex, Grok, Kiro ...), simulate requests, and encapsulate them into a local OpenAI-compatible interface.\nExclusive benefit: enterprise users can claim 12 million tokens for free , and can earn up to tens of billions of tokens by inviting friends.\n* VMCard Sponsor | VMCard | Enterprise Payment Cards for AI Businesses is built for AI account vendors, AI API providers, and teams managing bulk subscriptions.\nAIClient2API is an API proxy service that breaks through client limitations, converting free large models originally restricted to client use only (such as Gemini, Antigravity, Codex, Grok, Kiro) into standard OpenAI-compatible interfaces that can be called by any application.\nBuilt on Node.js, it supports intelligent conversion between OpenAI, Claude, and Gemini protocols, enabling tools like Cherry-Studio, NextChat, and Cline to freely use advanced models such as Claude Opus and Gemini Pro at scale.\n* OpenAI, Claude, Gemini three-protocol mutual conversion, automatic intelligent switching\n* Multi-Model Unified Interface : Through standard OpenAI-compatible protocol, configure once to access mainstream large models including Gemini, Claude, Grok, Codex, Kimi, MiniMax\n* Flexible Switching Mechanism : Path routing, support dynamic model switching via startup parame"
      ]
    },
    {
      "url": "https://github.com/OpenMined/alex",
      "title": "GitHub - OpenMined/alex: Alex — a local LLM proxy for all ...",
      "publish_date": null,
      "excerpts": [
        "GitHub - OpenMined/alex: Alex — a local LLM proxy for all ...\nBinding Alex to 0.0.0.0 exposes the proxy to the network. Only do this with appropriate authentication and firewall rules, preferably behind TLS or an encrypted private network."
      ]
    },
    {
      "url": "https://github.com/2029193370/AIClient2API",
      "title": "GitHub - 2029193370/AIClient2API: A powerful proxy that unifies client-only LLM APIs (Gemini CLI, Antigravity, Codex, Grok, Kiro...) into OpenAI-compatible interface · GitHub",
      "publish_date": null,
      "excerpts": [
        "README.md\nlogo\nAIClient2API（A2）🚀\nA powerful proxy that can unify the requests of various client-only large model APIs (Gemini CLI, Antigravity, Codex, Grok, Kiro ...), simulate requests, and encapsulate them into a local OpenAI-compatible interface.\nAIClient2API is an API proxy service that breaks through client limitations, converting free large models originally restricted to client use only (such as Gemini, Antigravity, Codex, Grok, Kiro) into standard OpenAI-compatible interfaces that can be called by any application.\nBuilt on Node.js, it supports intelligent conversion between OpenAI, Claude, and Gemini protocols, enabling tools like Cherry-Studio, NextChat, and Cline to freely use advanced models such as Claude Opus and Gemini Pro at scale.\n* OpenAI, Claude, Gemini three-protocol mutual conversion, automatic intelligent switching\n* Multi-Model Unified Interface : Through standard OpenAI-compatible protocol, configure once to access mainstream large models including Gemini, Claude, Grok, Codex, Kimi, MiniMax\n* Flexible Switching Mechanism : Path routing, support dynamic model switching via startup parameters or environment variables to meet different scenario requirements\n* Zero-Cost Migration : Fully compatible with OpenAI API specifications, tools like Cherry-Studio, NextChat, Cline can be used without modification\n* Multi-Protocol Intelligent Conversion : Support intelligent conversion between OpenAI, Claude, and Gemini protocols for cross-protocol model invocation\n🚀 Break Through Limitations, Improve Efficiency\n* Bypass Official Restrictions : Utilize OAuth authorization mechanism to effectively break through rate and quota limits of services like Gemini, Antigravity\n* TLS Fingerprint Bypass : Built-in TLS Sidecar (Go uTLS) to si"
      ]
    },
    {
      "url": "https://github.com/justlovemaki/AIClient2API/blob/main/README.md",
      "title": "AIClient2API/README.md at main · justlovemaki/AIClient2API",
      "publish_date": null,
      "excerpts": [
        "AIClient2API/README.md at main · justlovemaki/AIClient2API\nSelf-hosted multi-protocol AI API proxy for Antigravity, Codex, Grok, Kiro, OpenAI, Claude, and custom providers. Supports OpenAI-compatible API, Claude API\n > \nAIClient2API/README.md at main · justlovemaki ... - GitHub\nAIClient2API is an API proxy service that breaks through client limitations, converting free large models originally restricted to client use only (such as Gemini, Antigravity, Codex, Grok, Kiro) into standard OpenAI-compatible interfaces that can be called by any application.\n > \nBuilt on Node.js, it supports intelligent conversion between OpenAI, Claude, and Gemini protocols, enabling tools like\n > \nAIClient2API/README.md at main · justlovemaki ... - GitHub\nAIClient2API is an API proxy service that breaks through client limitations, converting free large models originally restricted to client use only (such as Gemini, Antigravity, Codex, Grok, Kiro) into standard OpenAI-compatible interfaces that can be called by any application.\n > \nAIClient2API/README.md at main · justlovemaki/AIClient2API\nSelf-hosted multi-protocol AI API proxy for Antigravity, Codex, Grok, Kiro, OpenAI, Claude, and custom providers.\n > \nSupports OpenAI-compatible API, Claude API, Gemini protocol conversion, GPT, Grok Build, Claude Opus, Gemini Pro, Kimi, MiniMax, provider pools, smart routing, and automatic failover."
      ]
    },
    {
      "url": "https://github.com/justlovemaki/AIClient2API/blob/main/configs/config.json.example",
      "title": "AIClient2API/configs/config.json.example at main ... - GitHub",
      "publish_date": null,
      "excerpts": [
        "AIClient2API/configs/config.json.example at main ... - GitHub\nSupports OpenAI-compatible API, Claude API, Gemini protocol conversion, GPT, Grok Build, Claude Opus, Gemini Pro, Kimi, MiniMax, provider pools, smart routing, and automatic failover. - AIClient2API/configs/config.json.example at main · justlovemaki/AIClient2API"
      ]
    },
    {
      "url": "https://github.com/iceahh1030/chenyme_grok2api",
      "title": "GitHub - iceahh1030/chenyme_grok2api: Multi-account API ...",
      "publish_date": null,
      "excerpts": [
        "GitHub - iceahh1030/chenyme_grok2api: Multi-account API ...\nGrok2API is a Go-based Grok API gateway with a built-in React admin console. It organizes Grok Build OAuth, Grok Web SSO, and Grok Console SSO credentials into independent account pools, exposes OpenAI- and Anthropic-style APIs, and provides one place to manage model routes, client keys, quotas, media, audits, and egress proxies."
      ]
    },
    {
      "url": "https://github.com/MrKrugen/BlacklistedAIProxy",
      "title": "GitHub - MrKrugen/BlacklistedAIProxy: Stop paying to use AI in your favorite apps! BlacklistedAPI gives you free, unlimited access to elite models like Gemini, Claude, and Grok without a single paid API key. It spoofs these services into one OpenAI-compatible gateway, supporting thousands of daily requests. Perfect for \"vibe coding\" and AI powered app use FREE. · GitHub",
      "publish_date": null,
      "excerpts": [
        "BlacklistedAPI is an OpenAI-compatible reverse proxy gateway that jailbreaks the client-only restrictions on the world's most powerful AI models — Gemini CLI, Claude Kiro, Grok, Codex, Qwen Code, and more — and wraps them into a single, clean, standard API endpoint your apps can actually call.\nZero code changes on your end. Zero permission slips required.\nBuilt on Node.js , hardened with Go TLS tricks , secured with OpenTelemetry observability , and battle-tested with Promptfoo red-team suites — this is not your grandma's proxy.\n* Ancestor | Language | What They Built | What We Took\n* 🔥 router-for-me/CLIProxyAPI | Go | The original CLI proxy engine — OpenAI/Gemini/Claude/Codex compatible endpoints, multi-account round-robin, OAuth flows for every major provider, reusable Go SDK, and a whole ecosystem of downstream projects built on top of it.\nThe blueprint that proved this was possible. | The core proxy architecture patterns, multi-account load balancing concepts, OAuth flow designs, and provider routing strategy\n* ⚡ justlovemaki/AIClient-2-API | Node.js | The Node.js implementation that brought in the Web UI management console, TLS fingerprint bypass via Go uTLS sidecar, Antigravity/Kiro/Grok protocol support, account pool manager with async refresh queue, and the three-way OpenAI↔Claude↔Gemini protocol conversion engine.\n❌ Grok = Cloudflare wall                Claude   Codex    Kimi\n❌ Five different API formats             Qwen    Kiro     More\n❌ Rate limits everywhere                   │\n❌ Your wallet, crying                      ▼\nOpenAI-compatible\nStandard Response\n(FREE models edition)\nThe Money Shot: What You Get Free\n┌─────────────────────────────────────────────────────────────────┐\n│  MODEL            │  NORMAL PRICE  │  BLACKL"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "session_bda47c96a8f0caf4793fd1922c48984c"
}
```

---

### 🤖 Assistant — 2026-09-16 03:10:29

> Excellent! I found a lot of great information from the web search. Now I have a comprehensive view of the landscape. Let me also search for a few more specific projects that were mentioned or are related.

**tool:github_search_repositories** (completed) 

```
query=BlacklistedAIProxy MrKrugen; perPage=5
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

**tool:github_search_repositories** (completed) 

```
perPage=5; query=CLIProxyAPI router-for-me
--- output ---
{
  "total_count": 14,
  "incomplete_results": false,
  "items": [
    {
      "id": 1218247683,
      "node_id": "R_kgDOSJz8Aw",
      "name": "CLIProxyAPIPlus",
      "full_name": "kaitranntt/CLIProxyAPIPlus",
      "private": false,
      "owner": {
        "login": "kaitranntt",
        "id": 61256810,
        "node_id": "MDQ6VXNlcjYxMjU2ODEw",
        "avatar_url": "https://avatars.githubusercontent.com/u/61256810?v=4",
        "url": "https://api.github.com/users/kaitranntt",
        "html_url": "https://github.com/kaitranntt",
        "type": "User"
      },
      "html_url": "https://github.com/kaitranntt/CLIProxyAPIPlus",
      "description": "CCS-maintained fork of CLIProxyAPIPlus (MIT snapshot, Apr 2026) with daily auto-sync from router-for-me/CLIProxyAPI. See plans for context.",
      "fork": false,
      "url": "https://api.github.com/repos/kaitranntt/CLIProxyAPIPlus",
      "created_at": "2026-04-22T17:24:02Z",
      "updated_at": "2026-09-14T08:58:04Z",
      "pushed_at": "2026-09-09T22:55:20Z",
      "git_url": "git://github.com/kaitranntt/CLIProxyAPIPlus.git",
      "ssh_url": "git@github.com:kaitranntt/CLIProxyAPIPlus.git",
      "clone_url": "https://github.com/kaitranntt/CLIProxyAPIPlus.git",
      "default_branch": "main"
    },
    {
      "id": 1118593096,
      "node_id": "R_kgDOQqxgSA",
      "name": "cliproxycli",
      "full_name": "MisonL/cliproxycli",
      "private": false,
      "owner": {
        "login": "MisonL",
        "id": 35633790,
        "node_id": "MDQ6VXNlcjM1NjMzNzkw",
        "avatar_url": "https://avatars.githubusercontent.com/u/35633790?v=4",
        "url": "https://api.github.com/users/MisonL",
        "html_url": "https://github.com/MisonL",
        "type": "User"
      },
      "html_url": "https://github.com/MisonL/cliproxycli",
      "description": "fork from https://github.com/router-for-me/CLIProxyAPI",
      "fork": false,
      "url": "https://api.github.com/repos/MisonL/cliproxycli",
      "created_at": "2025-12-18T02:02:24Z",
      "updated_at": "2026-05-27T08:38:15Z",
      "pushed_at": "2026-01-09T12:02:06Z",
      "git_url": "git://github.com/MisonL/cliproxycli.git",
      "ssh_url": "git@github.com:MisonL/cliproxycli.git",
      "clone_url": "https://github.com/MisonL/cliproxycli.git",
      "default_branch": "main"
    },
    {
      "id": 1192669158,
      "node_id": "R_kgDORxav5g",
      "name": "CLIProxyAPI",
      "full_name": "jtnetcc/CLIProxyAPI",
      "private": false,
      "owner": {
        "login": "jtnetcc",
        "id": 33725352,
        "node_id": "MDQ6VXNlcjMzNzI1MzUy",
        "avatar_url": "https://avatars.githubusercontent.com/u/33725352?v=4",
        "url": "https://api.github.com/users/jtnetcc",
        "html_url": "https://github.com/jtnetcc",
        "type": "User"
      },
      "html_url": "https://github.com/jtnetcc/CLIProxyAPI",
      "description": "Mirror of router-for-me/CLIProxyAPI",
      "fork": false,
      "url": "https://api.github.com/repos/jtnetcc/CLIProxyAPI",
      "created_at": "2026-03-26T12:53:55Z",
      "updated_at": "2026-03-28T14:59:40Z",
      "pushed_at": "2026-03-28T14:59:39Z",
      "git_url": "git://github.com/jtnetcc/CLIProxyAPI.git",
      "ssh_url": "git@github.com:jtnetcc/CLIProxyAPI.git",
      "clone_url": "https://github.com/jtnetcc/CLIProxyAPI.git",
      "default_branch": "main"
    },
    {
      "id": 1138227875,
      "node_id": "R_kgDOQ9f6ow",
      "name": "cliproxyapi_docker",
      "full_name": "XCQ0607/cliproxyapi_docker",
      "private": false,
      "owner": {
        "login": "XCQ0607",
        "id": 125746521,
        "node_id": "U_kgDOB369WQ",
        "avatar_url": "https://avatars.githubusercontent.com/u/125746521?v=4",
        "url": "https://api.github.com/users/XCQ0607",
        "html_url": "https://github.com/XCQ0607",
        "type": "User"
      },
      "html_url": "https://github.com/XCQ0607/cliproxyapi_docker",
      "description": "Docker wrapper for router-for-me/CLIProxyAPI.                      router-for-me/CLIProxyAPI 的 Docker 封装版本",
      "fork": false,
      "url": "https://api.github.com/repos/XCQ0607/cliproxyapi_docker",
      "created_at": "2026-01-20T12:02:08Z",
      "updated_at": "2026-09-15T11:41:25Z",
      "pushed_at": "2026-09-15T11:41:21Z",
      "git_url": "git://github.com/XCQ0607/cliproxyapi_docker.git",
      "ssh_url": "git@github.com:XCQ0607/cliproxyapi_docker.git",
      "clone_url": "https://github.com/XCQ0607/cliproxyapi_docker.git",
      "default_branch": "main"
    },
    {
      "id": 1351241069,
      "node_id": "R_kgDOUIpNbQ",
      "name": "CLIProxyAPI",
      "full_name": "zengwenliang416/CLIProxyAPI",
      "private": false,
      "owner": {
        "login": "zengwenliang416",
        "id": 126878617,
        "node_id": "U_kgDOB5ADmQ",
        "avatar_url": "https://avatars.githubusercontent.com/u/126878617?v=4",
        "url": "https://api.github.com/users/zengwenliang416",
        "html_url": "https://github.com/zengwenliang416",
        "type": "User"
      },
      "html_url": "https://github.com/zengwenliang416/CLIProxyAPI",
      "description": "Independent derivative of router-for-me/CLIProxyAPI for secondary development",
      "fork": false,
      "url": "https://api.github.com/repos/zengwenliang416/CLIProxyAPI",
      "created_at": "2026-08-30T08:47:28Z",
      "updated_at": "2026-09-12T03:53:51Z",
      "pushed_at": "2026-09-12T03:53:47Z",
      "git_url": "git://github.com/zengwenliang416/CLIProxyAPI.git",
      "ssh_url": "git@github.com:zengwenliang416/CLIProxyAPI.git",
      "clone_url": "https://github.com/zengwenliang416/CLIProxyAPI.git",
      "default_branch": "main"
    }
  ]
}
```

**tool:github_search_repositories** (completed) 

```
query=Antigravity2Api anshulrules; perPage=5
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

---

### 🤖 Assistant — 2026-09-16 03:12:23

> Now I have a comprehensive set of results. Let me also search for the original router-for-me/CLIProxyAPI and get more details on some key projects.

**tool:github_search_repositories** (completed) 

```
query=router-for-me CLIProxyAPI; perPage=5
--- output ---
{
  "total_count": 14,
  "incomplete_results": false,
  "items": [
    {
      "id": 1218247683,
      "node_id": "R_kgDOSJz8Aw",
      "name": "CLIProxyAPIPlus",
      "full_name": "kaitranntt/CLIProxyAPIPlus",
      "private": false,
      "owner": {
        "login": "kaitranntt",
        "id": 61256810,
        "node_id": "MDQ6VXNlcjYxMjU2ODEw",
        "avatar_url": "https://avatars.githubusercontent.com/u/61256810?v=4",
        "url": "https://api.github.com/users/kaitranntt",
        "html_url": "https://github.com/kaitranntt",
        "type": "User"
      },
      "html_url": "https://github.com/kaitranntt/CLIProxyAPIPlus",
      "description": "CCS-maintained fork of CLIProxyAPIPlus (MIT snapshot, Apr 2026) with daily auto-sync from router-for-me/CLIProxyAPI. See plans for context.",
      "fork": false,
      "url": "https://api.github.com/repos/kaitranntt/CLIProxyAPIPlus",
      "created_at": "2026-04-22T17:24:02Z",
      "updated_at": "2026-09-14T08:58:04Z",
      "pushed_at": "2026-09-09T22:55:20Z",
      "git_url": "git://github.com/kaitranntt/CLIProxyAPIPlus.git",
      "ssh_url": "git@github.com:kaitranntt/CLIProxyAPIPlus.git",
      "clone_url": "https://github.com/kaitranntt/CLIProxyAPIPlus.git",
      "default_branch": "main"
    },
    {
      "id": 1118593096,
      "node_id": "R_kgDOQqxgSA",
      "name": "cliproxycli",
      "full_name": "MisonL/cliproxycli",
      "private": false,
      "owner": {
        "login": "MisonL",
        "id": 35633790,
        "node_id": "MDQ6VXNlcjM1NjMzNzkw",
        "avatar_url": "https://avatars.githubusercontent.com/u/35633790?v=4",
        "url": "https://api.github.com/users/MisonL",
        "html_url": "https://github.com/MisonL",
        "type": "User"
      },
      "html_url": "https://github.com/MisonL/cliproxycli",
      "description": "fork from https://github.com/router-for-me/CLIProxyAPI",
      "fork": false,
      "url": "https://api.github.com/repos/MisonL/cliproxycli",
      "created_at": "2025-12-18T02:02:24Z",
      "updated_at": "2026-05-27T08:38:15Z",
      "pushed_at": "2026-01-09T12:02:06Z",
      "git_url": "git://github.com/MisonL/cliproxycli.git",
      "ssh_url": "git@github.com:MisonL/cliproxycli.git",
      "clone_url": "https://github.com/MisonL/cliproxycli.git",
      "default_branch": "main"
    },
    {
      "id": 1192669158,
      "node_id": "R_kgDORxav5g",
      "name": "CLIProxyAPI",
      "full_name": "jtnetcc/CLIProxyAPI",
      "private": false,
      "owner": {
        "login": "jtnetcc",
        "id": 33725352,
        "node_id": "MDQ6VXNlcjMzNzI1MzUy",
        "avatar_url": "https://avatars.githubusercontent.com/u/33725352?v=4",
        "url": "https://api.github.com/users/jtnetcc",
        "html_url": "https://github.com/jtnetcc",
        "type": "User"
      },
      "html_url": "https://github.com/jtnetcc/CLIProxyAPI",
      "description": "Mirror of router-for-me/CLIProxyAPI",
      "fork": false,
      "url": "https://api.github.com/repos/jtnetcc/CLIProxyAPI",
      "created_at": "2026-03-26T12:53:55Z",
      "updated_at": "2026-03-28T14:59:40Z",
      "pushed_at": "2026-03-28T14:59:39Z",
      "git_url": "git://github.com/jtnetcc/CLIProxyAPI.git",
      "ssh_url": "git@github.com:jtnetcc/CLIProxyAPI.git",
      "clone_url": "https://github.com/jtnetcc/CLIProxyAPI.git",
      "default_branch": "main"
    },
    {
      "id": 1138227875,
      "node_id": "R_kgDOQ9f6ow",
      "name": "cliproxyapi_docker",
      "full_name": "XCQ0607/cliproxyapi_docker",
      "private": false,
      "owner": {
        "login": "XCQ0607",
        "id": 125746521,
        "node_id": "U_kgDOB369WQ",
        "avatar_url": "https://avatars.githubusercontent.com/u/125746521?v=4",
        "url": "https://api.github.com/users/XCQ0607",
        "html_url": "https://github.com/XCQ0607",
        "type": "User"
      },
      "html_url": "https://github.com/XCQ0607/cliproxyapi_docker",
      "description": "Docker wrapper for router-for-me/CLIProxyAPI.                      router-for-me/CLIProxyAPI 的 Docker 封装版本",
      "fork": false,
      "url": "https://api.github.com/repos/XCQ0607/cliproxyapi_docker",
      "created_at": "2026-01-20T12:02:08Z",
      "updated_at": "2026-09-15T11:41:25Z",
      "pushed_at": "2026-09-15T11:41:21Z",
      "git_url": "git://github.com/XCQ0607/cliproxyapi_docker.git",
      "ssh_url": "git@github.com:XCQ0607/cliproxyapi_docker.git",
      "clone_url": "https://github.com/XCQ0607/cliproxyapi_docker.git",
      "default_branch": "main"
    },
    {
      "id": 1351241069,
      "node_id": "R_kgDOUIpNbQ",
      "name": "CLIProxyAPI",
      "full_name": "zengwenliang416/CLIProxyAPI",
      "private": false,
      "owner": {
        "login": "zengwenliang416",
        "id": 126878617,
        "node_id": "U_kgDOB5ADmQ",
        "avatar_url": "https://avatars.githubusercontent.com/u/126878617?v=4",
        "url": "https://api.github.com/users/zengwenliang416",
        "html_url": "https://github.com/zengwenliang416",
        "type": "User"
      },
      "html_url": "https://github.com/zengwenliang416/CLIProxyAPI",
      "description": "Independent derivative of router-for-me/CLIProxyAPI for secondary development",
      "fork": false,
      "url": "https://api.github.com/repos/zengwenliang416/CLIProxyAPI",
      "created_at": "2026-08-30T08:47:28Z",
      "updated_at": "2026-09-12T03:53:51Z",
      "pushed_at": "2026-09-12T03:53:47Z",
      "git_url": "git://github.com/zengwenliang416/CLIProxyAPI.git",
      "ssh_url": "git@github.com:zengwenliang416/CLIProxyAPI.git",
      "clone_url": "https://github.com/zengwenliang416/CLIProxyAPI.git",
      "default_branch": "main"
    }
  ]
}
```

**tool:github_search_repositories** (completed) 

```
query=fake-oai tokens management; perPage=5
--- output ---
{
  "total_count": 0,
  "incomplete_results": false,
  "items": []
}
```

---

### 🤖 Assistant — 2026-09-16 03:14:34

> The original router-for-me/CLIProxyAPI seems to be private or not showing up in search. Let me try to get more details on some of the key projects I've found. I have enough information now to provide a comprehensive answer. Let me organize the findings and present them in a structured format.
> 
> Let me compile all the information I've gathered from both GitHub searches and the web search.

Now I have comprehensive data. Let me organize the findings into a structured list.



**tool:github_get_file_contents** (completed) 

```
path=README.md; repo=alex; owner=OpenMined
--- output ---
{
  "name": "README.md",
  "path": "README.md",
  "sha": "536d6119ab3d9616be50565395ddf447fcd498eb",
  "size": 26698,
  "url": "https://api.github.com/repos/OpenMined/alex/contents/README.md?ref=main",
  "html_url": "https://github.com/OpenMined/alex/blob/main/README.md",
  "git_url": "https://api.github.com/repos/OpenMined/alex/git/blobs/536d6119ab3d9616be50565395ddf447fcd498eb",
  "download_url": "https://raw.githubusercontent.com/OpenMined/alex/main/README.md",
  "type": "file",
  "content": "# Alex — a local LLM proxy for AI subscriptions and coding harnesses\n\n<p align=\"center\">\n  <img src=\"images/header.jpg\" alt=\"Alex connects supported terminal harnesses to supported LLM providers through one local proxy\" width=\"100%\">\n</p>\n\n<p align=\"center\">\n  <a href=\"https://crates.io/crates/alex\"><img src=\"https://img.shields.io/crates/v/alex.svg\" alt=\"crates.io\"></a>\n  <a href=\"https://github.com/madhavajay/alex/actions/workflows/ci.yml\"><img src=\"https://github.com/madhavajay/alex/actions/workflows/ci.yml/badge.svg\" alt=\"CI\"></a>\n  <a href=\"#quickstart\"><img src=\"https://img.shields.io/badge/macOS-ARM64-black?logo=apple\" alt=\"macOS ARM64\"></a>\n  <a href=\"#quickstart\"><img src=\"https://img.shields.io/badge/Windows-x86--64%20alpha-0078D4?logo=windows11&amp;logoColor=white\" alt=\"Windows x86-64 alpha\"></a>\n  <a href=\"#quickstart\"><img src=\"https://img.shields.io/badge/Windows-ARM64%20alpha-0078D4?logo=windows11&amp;logoColor=white\" alt=\"Windows ARM64 alpha\"></a>\n  <a href=\"#quickstart\"><img src=\"https://img.shields.io/badge/Linux-x86--64-FCC624?logo=linux&amp;logoColor=black\" alt=\"Linux x86-64\"></a>\n  <a href=\"#quickstart\"><img src=\"https://img.shields.io/badge/Linux-ARM64-FCC624?logo=linux&amp;logoColor=black\" alt=\"Linux ARM64\"></a>\n</p>\n\n<h2 align=\"center\">Your tokens, your traces, your choice!</h2>\n\n<p align=\"center\">\n  <a href=\"https://madhavajay.github.io/alex/\"><strong>Click here to see a DEMO</strong></a>\n</p>\n\n<p align=\"center\">\n  <a href=\"https://madhavajay.github.io/alex/\">\n    <img src=\"https://raw.githubusercontent.com/madhavajay/alex/main/images/demo.jpg\" alt=\"Alex live demo page with Cove replay player\" width=\"100%\">\n  </a>\n</p>\n\n## Problems Alex fixes\n\n**Problem:** Fable 5 guardrails kill your session.  \n**Solution:** Alex can transparently **switch** to GPT-5.6 Sol, or **fork** the session into another harness or model.\n\n`pi` · `claude` · `codex` · `grok`\n\n**Problem:** Your subscription logs out mid-run.  \n**Solution:** Alex pings you on Telegram to re-auth from your phone and can reroute traffic until it reconnects.\n\n`anthropic` · `openai` · `gemini` · `grok`\n\n**Problem:** You cannot use your Anthropic subscription from other harnesses.  \n**Solution:** Alex routes through Dario so requests match Anthropic's expected wire format.\n\n`pi` · `codex` · `claude` · `opencode`\n\n**Problem:** You hit five-hour or weekly limits and start juggling accounts.  \n**Solution:** Alex bonds multiple subscriptions and fails over automatically.\n\n`account-1` · `account-2` · `account-3`\n\n**Problem:** You cannot see what agents and subagents are really doing.  \n**Solution:** Alex shows every message, tool call, response, and subagent as one readable chat thread.\n\n`claude` · `codex` · `pi` · `amp` · `cursor`\n\n## Quickstart\n\nInstall the macOS app or Linux daemon with one command:\n\n```sh\ncurl -fsSL https://raw.githubusercontent.com/madhavajay/alex/main/install-release.sh | sh\n```\n\nWindows support is alpha. In a normal PowerShell window, download the latest\nx86-64 or ARM64 installer and open it with:\n\n```powershell\nInvoke-RestMethod 'https://raw.githubusercontent.com/madhavajay/alex/main/install-windows.ps1' | Invoke-Expression\n```\n\n## Extra Benefits of LLM Proxies\n### PAM — Pi Agents Mixed\n\n[![PAM capability dial](https://github.com/madhavajay/pam/raw/main/assets/demo2.webp)](https://github.com/madhavajay/pam)\n\nAlex gives you the ability to easily combine subscriptions so you can experiment with SOTA techniques and MoA patterns without the fear of token bills.\n\n[PAM](https://github.com/madhavajay/pam) is an extension for the [Pi coding harness](https://pi.dev/) with an Agent ↔ Oracle mixture-of-agents dial, inspired by Amp Code's The Dial: your primary work stays on the faster agent while a smarter, slower oracle gives second opinions. Turn it up to 11 with `Ctrl+S`.\n\n```sh\npi install npm:@madhavajay/pam\n```\n\nPAM works with whatever providers Pi has — and works best with Alex, where a single dial can mix providers and benefit from subscription bonding, automatic failover, and middleware reroutes.\n\n### Easily change PAM to use any model\n```\n# use kimi/k3 instead of fable in ultra mode\npi --mode u --modes='{\"u\":[\"alex:alex/kimi/k3\",\"sol\"],\"h\":[\"sol@xhigh\",\"fable\"]}'\n```\n\n## e2e Harness ↔️ Provider Traces\n\n![Alex capturing a wrapped Amp session alongside its full conversation trace](https://raw.githubusercontent.com/madhavajay/alex/main/images/amp.png)\n\nEven in closed harnesses you can see whats going on!\n\n## Your Tokens, Your Traces, Your Choice!\n\nMost AI tools **lock together three things that should be separate**:\n\n- the **harness** you work in;\n- the **model** you use; and\n- the **provider account** that pays for it.\n\n**Alex separates them.**\n\nIt is a local LLM proxy that connects Claude, ChatGPT/Codex, Gemini, Grok, Kimi, OpenRouter, Exo, and CLIProxyAPI to one loopback service exposing OpenAI-, Anthropic-, and Gemini-compatible ingress. After connecting a provider and compatible harness, choose a supported model without manually copying upstream credentials or losing visibility into captured agent work.\n\n<table align=\"right\">\n  <tr>\n    <td align=\"center\">\n      <img src=\"https://raw.githubusercontent.com/madhavajay/alex/main/images/menu.png\" alt=\"Alex macOS menu showing providers, accounts, harnesses, usage, and recent traces\" width=\"260\">\n      <br>\n      <sub>Inspired by <a href=\"https://x.com/steipete\">@steipete</a>'s <a href=\"https://github.com/steipete/CodexBar\">CodexBar</a></sub>\n    </td>\n  </tr>\n</table>\n\n## Why use Alex?\n\n### At a glance\n\n- **Use supported models across compatible harnesses, like Fable 5 in Codex.**\n- **Fork any session.** `alex resume SESSION pi` — captured Pi, Claude Code, and Codex conversations can be reconstructed into native sessions in any of those three harnesses. History, tool calls, model, and a verified working directory carry over when the target format supports them; unsupported or changed private formats fall back visibly to prompt hand-off.\n- **See captured work.** Inspect traffic routed or wrapped through Alex and the turn and tool events each integration exposes.\n- **Have your agents meta-analyze all your traces in an outer loop.**\n- **Tokenmax across accounts.** Bond multiple subscriptions for more aggregate capacity.\n- **Trace closed harnesses.** Capture activity from tools like Amp and Cursor.\n- **A Rust daemon that stays up.**\n- **Use Anthropic subscriptions from compatible API clients and connected harnesses.** Route eligible traffic through [Dario](https://github.com/askalf/dario).\n- **Analyze or train on your data.** Your tokens, your traces.\n- **Mix and match token sources.** Combine subscriptions and providers such as OpenAI, Anthropic, Grok, and OpenRouter.\n\nOnce you use more than one coding agent or AI subscription, the setup becomes fragmented:\n\neach harness supports different providers and API formats;\nsubscription credentials expire and require different login flows;\nagent and subagent activity disappears across separate tools;\nrate limits, usage windows, and costs are difficult to understand;\nswitching models often means switching the tool you work in.\n\nAlex becomes the local control plane between your tools and your subscriptions.\n\nUse a Claude model from Pi. Use a GPT model from Claude Code. Route across multiple Codex accounts. Capture Amp or Cursor runs that do not support custom endpoints. Inspect every captured model request and the executed-tool events exposed by each harness in one trace browser.\n\n<br clear=\"right\">\n\n![Alex Trace Browser showing model requests, tool calls, token usage, and latency](https://raw.githubusercontent.com/madhavajay/alex/main/images/trace-browser.png)\n\n\n### Harness tracing support\n\nAfter a harness is connected or wrapped through Alex, Alex records each captured request as a trace. **Session grouping** stitches a harness's\nrequests into one conversation; **subagent tracing** additionally reconstructs the parent→child tree when a\nharness spawns subagents.\n\n| Harness | Traces | Subagents |\n| --- | :---: | :---: |\n| `claude` (Claude Code) | ✅ | ✅ |\n| `codex` | ✅ | ✅ |\n| `pi` | ✅ | ✅ |\n| `grok` | ✅ | ✅ |\n| `amp` | ✅ | ✅ |\n| `gemini` | ✅ | — |\n| `cursor` | ✅ | — |\n| `droid` | ✅ | — |\n| `goose` | ✅ | — |\n| `kimi` | ✅ | — |\n| `qwen` | ✅ | — |\n| `opencode` | ✅ | — |\n| `mini-swe-agent` | ✅ | — |\n| `hermes` | ✅ | — |\n| `pydantic-ai` | ✅ | — |\n| `opensage` | ✅ | — |\n| `stirrup` | ✅ | — |\n| `jcode` | ✅ | — |\n| `omp` | ✅ | — |\n\nSubagent tracing sources: Claude Code sends native `x-claude-code-agent-id`/`x-claude-code-parent-agent-id`\nheaders (recorded as `SubagentStart`/`SubagentStop`); codex, pi, and grok report sessions and sub-agents through\nthe lifecycle hook installed by `alex connect`; amp reports lineage via the Alex system plugin. Harnesses that\nsend no session id (e.g. Qwen Code driving a benchmark) get an `auto-<hash>` session per connection, so many\nparallel/retried runs surface as many short sessions rather than one grouped job.\n\n## What makes Alex different?\n\nUse subscriptions, not only API keys.\nAlex imports and refreshes credentials from the official Claude, Codex, Gemini, and Grok CLIs, allowing compatible tools to use the subscriptions you already pay for.\n\nSupported models across compatible harnesses.\nAlex translates between Anthropic Messages, OpenAI Chat Completions, OpenAI Responses, and Gemini generateContent, including streaming responses.\n\n## Examples\n\n| Terminal | Description |\n| --- | --- |\n| <img src=\"https://raw.githubusercontent.com/madhavajay/alex/main/images/claude.png\" alt=\"OpenAI GPT-5.6 running in Claude Code through Alex\" width=\"500\"> | **GPT-5.6 in Claude Code.** Mix OpenAI models into an Anthropic-native harness. |\n| <img src=\"https://raw.githubusercontent.com/madhavajay/alex/main/images/codex.png\" alt=\"Claude Fable 5 running in Codex through Alex\" width=\"500\"> | **Fable 5 in Codex.** Run Fable 5 from a compatible connected harness such as Codex. Your tokens, your choice! |\n| <img src=\"https://github.com/madhavajay/pam/raw/main/assets/pi.png\" alt=\"The PAM mixture-of-agents plugin running in Pi through Alex\" width=\"500\"> | **[PAM](https://github.com/madhavajay/pam) in Pi.** Experiment with custom MoA plugins like PAM (the AMP Dial). |\n\nA complete record of agent work.\nRequests, responses, token usage, latency, cost, sessions, subagents, requested tools, and executed tool results can all be captured locally and inspected as a coherent transcript.\n\nLocal and inspectable by default.\nThe daemon listens on 127.0.0.1, stores traces in local SQLite, and keeps provider credentials on your machine.\n\nOpen the shared local status, onboarding, and Trace Browser preview on macOS or Linux:\n\n```bash\nalex web\n```\n\nUse `alex web --no-open` to print the loopback URL. Linux can also install a\nlightweight status tray with Web UI, onboarding, trace, refresh, and daemon menu\nactions:\n\n```bash\nalex tray install\n```\n\nThe full native menu-bar app remains macOS-only; see [Shared web UI](docs/web-ui.md)\nfor desktop compatibility details.\n\nBuilt for real multi-agent workflows.\nScoped run keys, session tagging, remote trace ingestion, account routing, rate-limit failover, harness integrations, and regression tests make Alex useful beyond simple API forwarding.\n\nOne operational view across providers.\nThe CLI and macOS menu bar app show account health, authentication failures, subscription usage windows, reset times, routing state, and live traffic.\n\nalex auth import\nalex daemon --background\nalex connect pi\npi --model alex/gpt-5.6-sol\n\nOne proxy. Your subscriptions. Compatible harnesses. Every captured trace.\n\n![Alex capturing a wrapped Amp session alongside its full conversation trace](https://raw.githubusercontent.com/madhavajay/alex/main/images/amp.png)\n\n## How to use Alex Wrap on AMP or Cursor\n\n### Capture traces from Amp, Cursor, and other wrapped harnesses\n\nHarnesses that don't take a custom endpoint are captured with a reverse wrap. Alex records the conversation detail each wrapper exposes without changing the tool's normal model route:\n\n```bash\nalex wrap amp   -- -x 'refactor the auth module'      # Amp, fully traced\nalex wrap agent -- --print 'summarize this repo'      # Cursor Agent, fully traced\n```\n\n## From installed to working\n\nAfter running the installer, import your existing CLI logins, start Alex, and connect a harness:\n\n```bash\nalex auth import\nalex daemon --background\nalex status\nalex doctor\n\nalex connect pi\npi --model alex/gpt-5.6-sol\n```\n\n`alex status` shows daemon health, accounts, limits, and Dario state. `alex doctor` checks the executable, service, local port, credential state, provider health, storage integrity, permissions, and Dario prerequisites without displaying secrets. For a guided setup that can install, connect, configure, and launch a supported harness, run `alex up pi`.\n\n## Compatibility\n\n### Providers & subscriptions\n\nAlex stores credentials for the integrations below. Routable model upstreams accept traffic from the supported client APIs; wrap and billing integrations are explicitly labelled. OAuth providers use an existing subscription login, while API-key and endpoint providers use the auth shown in the table.\n\n| Provider | Plan / auth | Status |\n| --- | --- | --- |\n| Anthropic (Claude) | Claude subscription OAuth | ✅ Supported |\n| OpenAI (Codex / ChatGPT) | ChatGPT subscription OAuth | ✅ Supported |\n| Google Gemini | Gemini CLI OAuth import | ✅ Supported |\n| xAI (Grok) | Grok CLI subscription login | ✅ Supported |\n| Moonshot (Kimi) | Kimi subscription | ✅ Supported |\n| OpenRouter | API key | ✅ Supported |\n| Exo | Local / LAN cluster (no auth) | ✅ Supported |\n| CLIProxyAPI | URL + bearer credential | ✅ Supported in both directions |\n| Amp | Amp CLI credentials | ✅ Wrap + billing only; not a `/v1` model upstream |\n| Hugging Face | — | ⏳ Coming soon |\n| Meta (Llama) | — | ⏳ Coming soon |\n| Groq | — | ⏳ Coming soon |\n| LM Studio | — | ⏳ Coming soon |\n| AWS Bedrock | — | ⏳ Coming soon |\n| Ollama | — | ⏳ Coming soon |\n| Cursor | — | ⏳ Coming soon |\n\n### API formats\n\nFor the client/upstream pairs below, Alex translates requests, responses, and streaming events between the client API and the provider selected by the model name. Unsupported pairs return an explicit `501 Not Implemented` response.\n\n| Client API | Alex endpoint | Supported upstreams |\n| --- | --- | --- |\n| Anthropic Messages | `POST /v1/messages` | Anthropic, OpenAI, Gemini, xAI, OpenRouter, Exo, Kimi, CLIProxyAPI |\n| OpenAI Chat Completions | `POST /v1/chat/completions` | Anthropic, OpenAI, Gemini, xAI, OpenRouter, Exo, Kimi, CLIProxyAPI |\n| OpenAI Responses | `POST /v1/responses` | Anthropic, OpenAI, Gemini, CLIProxyAPI |\n| Gemini generateContent | `POST /v1beta/models/{model}:generateContent` | Anthropic, OpenAI, Gemini |\n\n### Primary harness integration depth\n\n| Harness | Custom models | Full trace | Executed tools |\n| --- | --- | --- | --- |\n| Pi | Yes | Yes | Yes |\n| Claude Code | Yes | Yes | Yes |\n| Codex | Yes | Yes | Yes |\n| Amp | Wrapped | Yes | Yes |\n| Cursor Agent | Wrapped | Yes | Partial |\n\nAmp and Cursor use `alex wrap` because they do not expose a normal custom model endpoint. Executed-tool detail depends on what each harness exposes. Cursor currently provides requested calls without complete execution results.\n\n## Requested tools and executed tools are different\n\n**See what agents actually did, not only what models requested.**\n\nA model trace may contain a request such as `call_tool(\"edit_file\", ...)`, but that does not prove the harness executed it. On supported integrations, Alex captures harness execution events alongside model traffic, including the tool name, arguments, result, failure status, and corresponding conversation turn when the harness exposes them.\n\n## Get proxy credentials from the UI or CLI\n\n![Proxy credential controls for copying an environment block or tagged run-key command](https://raw.githubusercontent.com/madhavajay/alex/main/images/credentials.png)\n\nThe macOS app can copy a complete environment block for generic API clients or a ready-to-edit command for minting a tagged run key. The CLI prints the same connection exports with `alex credentials`, also available as `alex creds`:\n\n```bash\nalex credentials\n\n# Output shape, with the credential redacted here:\nexport ANTHROPIC_BASE_URL=http://127.0.0.1:4100\nexport ANTHROPIC_API_KEY=<local-key>\nexport OPENAI_BASE_URL=http://127.0.0.1:4100/v1\nexport OPENAI_API_KEY=<local-key>\nexport XAI_API_KEY=<local-key>\nexport GROK_MODELS_BASE_URL=http://127.0.0.1:4100/v1\nexport GOOGLE_GEMINI_BASE_URL=http://127.0.0.1:4100\nexport GOOGLE_GENAI_API_VERSION=v1beta\nexport GEMINI_API_KEY=<local-key>\nexport GEMINI_API_KEY_AUTH_MECHANISM=bearer\nexport GOOGLE_GENAI_USE_GCA=false\n```\n\nThe local key has administrative access to your daemon. Keep it on the local machine. For a model-only, tagged credential, prefer the CLI:\n\n```bash\nalex keys mint \\\n  --kind run \\\n  --run-id demo-run-001 \\\n  --tag harness=pi \\\n  --tag project=my-project \\\n  --ttl 24h \\\n  --label 'example tagged run'\n```\n\nThe equivalent HTTP request is:\n\n```bash\ncurl -sS -X POST \\\n  -H 'x-api-key: <local-key>' \\\n  -H 'content-type: application/json' \\\n  --data '{\"run_id\":\"demo-run-001\",\"tags\":{\"harness\":\"pi\",\"project\":\"my-project\"},\"ttl_seconds\":86400,\"label\":\"example tagged run\"}' \\\n  'http://127.0.0.1:4100/admin/run-keys'\n```\n\nRun keys are shown once. Store them as secrets and revoke them with `alex keys revoke <key-id>` when they are no longer needed.\n\n## Give your agents access to traces\n\nA trusted local agent can use the trace API as an outer loop over previous work. It can find recurring failures, compare models and harnesses, inspect what tools actually ran, and prepare trace data for analysis or training.\n\nSet the daemon URL and local key copied from the UI or `alex credentials`:\n\n```bash\nexport ALEX_URL=http://127.0.0.1:4100\nexport ALEX_TRACE_KEY='<local-key>'\n```\n\nThen let the agent query the API:\n\n```bash\n# Find recent failures\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/search?since=24h&errors=1&limit=100\"\n\n# Read a complete turn-by-turn transcript, including executed tools\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/sessions/<session-id>/transcript\"\n\n# Search request and response text\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/search?text=authentication&limit=100\"\n\n# Inspect the exact client request or model response\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/<trace-id>/body/request\"\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/<trace-id>/body/response\"\n\n# Export traces as NDJSON for analysis, evals, or training\ncurl -sS -H \"x-api-key: $ALEX_TRACE_KEY\" \\\n  \"$ALEX_URL/traces/export.ndjson?since=24h&bodies=1\" > traces.ndjson\n```\n\nTrace-read endpoints currently require the local administrative key. Only give that key to a trusted agent running on the same machine or across a secured connection. Model-only, harness, and wrap keys cannot read trace history.\n\n## Remote agents and scoped keys\n\nAlex can act as a control plane for agents on other machines. Mint a model-only run key on the Alex host, then configure the remote harness:\n\n```bash\nalex up codex \\\n  --url https://alex.example.net \\\n  --key '<model-only-scoped-key>'\n```\n\n- Model-only run keys can invoke models but cannot administer Alex or read traces.\n- Harness keys can submit lifecycle and executed-tool events but cannot administer the daemon.\n- Wrap keys can upload traces but cannot invoke models or browse existing traces.\n- Remote wrapped sessions spool locally when the central daemon is unavailable and can be replayed with `alex traces push`.\n- Use HTTPS or an encrypted private network such as Tailscale for remote access.\n\nCreate an ingest-only wrap credential on the central machine with:\n\n```bash\nalex keys mint --kind wrap --label remote-mac\n```\n\n## Local and secure by default\n\n- Alex listens only on `127.0.0.1` unless you explicitly configure another interface.\n- Traces are stored locally in SQLite, with large bodies kept in the local data directory.\n- Provider and harness credentials stay on your machine with restricted file permissions.\n- Scoped credentials separate model access, harness events, and remote trace ingestion.\n- Alex does not require Alex-operated cloud infrastructure.\n\nBinding Alex to `0.0.0.0` exposes the proxy to the network. Only do this with appropriate authentication and firewall rules, preferably behind TLS or an encrypted private network. Never give a remote worker the local administrative key.\n\n## Tokenmax across accounts\n\nBond multiple accounts using `round_robin`, `priority`, or `reset_first` routing. When an account reaches a rate limit, Alex can cool it down and route eligible traffic through another account. The CLI and app expose utilization and reset windows so routing decisions remain visible.\n\n## Reliability\n\nThe Rust daemon includes the operational behavior needed for long-running agent work:\n\n- automatic OAuth token refresh;\n- provider health checks and authentication-error classification;\n- account cooldown and failover after rate limits;\n- graceful draining of in-flight requests during supported updates and restarts;\n- subscription utilization and reset-window visibility; and\n- local spooling when a remote trace destination is unavailable.\n\n### Error simulation lab and opt-in protection\n\nCapture a real error body as a named fixture, then inject it into the next\nrequest for a live session without exposing a simulation header to the harness:\n\n```bash\nalex fixtures list\nalex simulate inject <session-id> anthropic-relogin-401\nalex simulate pending <session-id>\n```\n\nFixtures live under `<data_dir>/fixtures`; the daemon seeds a small starter\nlibrary on first use. The admin API is local-key gated. Cross-provider\nprotection is opt-in; ordinary account failover remains limited to capacity and\nserver errors. The symmetric Claude/OpenAI example can be installed with\n`alex protection preset anthropic-openai` (it does not enable protection):\n\n```toml\n# [protection]\n# enabled = true\n# reroute_on_auth = true # explicitly permit auth/subscription failover\n# retries = 1\n# auto_return = true\n#\n# [protection.equivalencies]\n# \"claude-fable-5\" = { openai = \"gpt-5.6-sol\" }\n# \"gpt-5.6-sol\" = { anthropic = \"claude-fable-5\" }\n```\n\nEven with protection enabled, a single request can demand the exact model it\nasked for: send `x-alex-no-substitute: 1` to disable both account failover\nand cross-provider substitution for that call, so the real model is used and the\nreal error (if any) is returned unchanged. This is intended for **benchmark\nsuites** that must run against a specific model (e.g. `claude-fable-5`) and must\nnever be silently rerouted.\n\n### Optional request headers\n\nAny harness pointed at Alex can set these per request:\n\n- `x-alex-no-substitute: 1` — pin the model: disable failover and\n  cross-provider substitution, returning the real response or the real error\n  (benchmarks).\n- `x-session-id: <id>` — group requests into one session/transcript.\n- `x-alex-run-id: <id>` — attach your own external run id for correlation.\n- `x-alex-trace-tag`, `x-alex-job`, `x-alex-task`,\n  `x-alex-phase` — tag traces for later filtering and analytics.\n- `x-alex-harness`, `x-alex-harness-version` — label the calling\n  harness in traces.\n- `x-alex-simulate-error: STATUS[:kind]` — return a synthetic error with no\n  upstream call, for testing harness and failover behavior (local/harness-key\n  gated).\n\n## Platforms and alternative installation\n\nRelease binaries and installers are available for macOS ARM64, Windows x86-64\nand ARM64 (alpha), and Linux x86-64 and ARM64. Linux GNU and static musl builds\nare available for both architectures; the packaged variants exercise the user\nservice, onboarding, routing, middleware, and Trace Browser path in release CI.\nThe native menu-bar app and native notifications remain macOS-only; Linux uses\nthe shared web UI.\n\nAlternative installation methods:\n\n```bash\nbrew install madhavajay/alex/alex        # CLI and daemon\nbrew install --cask madhavajay/alex/alex # Alex.app\ncargo install alex                              # CLI from crates.io\n./install.sh --service                          # build this checkout and install its service\n```\n\n## Documentation\n\nIn-depth reference docs live in [`docs/`](docs/) (see the [docs index](docs/README.md)):\n\n| Doc | What it covers |\n| --- | --- |\n| [Overview](docs/overview.md) | Crate responsibilities, request/data flow, auth scopes, and the local state model |\n| [CLI reference](docs/cli.md) | The complete `alex` command tree, flags, defaults, and examples |\n| [Providers and routing](docs/providers-and-routing.md) | Vault accounts, selection policies, reserves, model routing, and failover |\n| [API and formats](docs/api-and-formats.md) | Model ingress, the four API dialects, Anthropic-pivot translation, SSE, usage, and cost |\n| [Configuration](docs/configuration.md) | Full `config.toml` key/default reference and on-disk layout |\n| [Dario](docs/dario.md) | The Dario broker: routing modes, the three-block prompt rewrite, headers, and fallback |\n| [Traces](docs/traces.md) | Trace rows and bodies, redaction, transcripts, the browser API, scoped keys, and export |\n| [Harness integration](docs/harnesses.md) | Provider headers, lifecycle hooks, and session/sub-agent identity |\n| [Amp wrap](docs/amp-wrap.md) | `alex wrap amp` reverse HTTP/WebSocket capture for closed harnesses |\n| [Signed macOS build](docs/build-signed.md) | `build-signed.sh`, Developer ID signing, and notarization |\n\n## Workspace\n\n| Crate | Purpose |\n| --- | --- |\n| [`alex`](crates/alex) | Daemon and CLI binaries |\n| [`alex-core`](crates/alex-core) | Routing, translation, quota, and pricing logic |\n| [`alex-auth`](crates/alex-auth) | Credential vault and login flows |\n| [`alex-store`](crates/alex-store) | SQLite traces and analytics |\n| [`alex-proxy`](crates/alex-proxy) | API ingress, admin API, and upstream clients |\n| [`alex-wrap`](crates/alex-wrap) | Reverse wrapping and capture for closed harnesses |\n\n## Development\n\n```bash\n./test.sh\n./scripts/harness-regression.sh\ncd macos && swift test\n```\n\n## Contributing\n\nBug reports, ideas, and feature requests are welcome through [GitHub Issues](https://github.com/madhavajay/alex/issues/new).\n\nBuilt by [madhavajay](https://github.com/madhavajay). Follow [@madhavajay](https://x.com/madhavajay) on X.\n\n## License\n\nDual-licensed under [MIT](LICENSE-MIT) or [Apache-2.0](LICENSE-APACHE), at your option.\n",
  "encoding": "base64",
  "_links": {
    "self": "https://api.github.com/repos/OpenMined/alex/contents/README.md?ref=main",
    "git": "https://api.github.com/repos/OpenMined/alex/git/blobs/536d6119ab3d9616be50565395ddf447fcd498eb",
    "html": "https://github.com/OpenMined/alex/blob/main/README.md"
  }
}
```

**tool:github_get_file_contents** (completed) 

```
path=README.md; repo=AIClient2API; owner=justlovemaki
--- output ---
{
  "name": "README.md",
  "path": "README.md",
  "sha": "19786aef5d7a87195603857a84ce1251e12ed2f1",
  "size": 50737,
  "url": "https://api.github.com/repos/justlovemaki/AIClient2API/contents/README.md?ref=main",
  "html_url": "https://github.com/justlovemaki/AIClient2API/blob/main/README.md",
  "git_url": "https://api.github.com/repos/justlovemaki/AIClient2API/git/blobs/19786aef5d7a87195603857a84ce1251e12ed2f1",
  "download_url": "https://raw.githubusercontent.com/justlovemaki/AIClient2API/main/README.md",
  "type": "file",

...52490 bytes truncated...

The tool call succeeded but the output was truncated. Full output saved to: /home/x3/.local/share/opencode/tool-output/tool_0a681b7ab00194epEQxINXdLYX
Use the Task tool to have explore agent process this file with Grep and Read (with offset/limit). Do NOT read the full file yourself - delegate to save context.
```

---

### 🤖 Assistant — 2026-09-16 03:18:34

> I have comprehensive data now. Let me compile the structured list of the top alternatives based on all my research. I have information from GitHub searches and web searches. Let me now present the final answer.

Based on my comprehensive GitHub and web research, here are the **TOP 5 alternatives** for unlimited free AI tokens with stealth/bypass capabilities:

---

### 1. **OpenMined/alex** — *Rust Local LLM Proxy* ⭐⭐⭐⭐⭐
- **URL**: https://github.com/OpenMined/alex
- **Primary Purpose**: Local LLM proxy connecting Claude, ChatGPT/Codex, Gemini, Grok, Kimi, OpenRouter, Exo, CLIProxyAPI to one loopback service (OpenAI/Anthropic/Gemini-compatible ingress)
- **Free Tier / "Unlimited"**: Uses YOUR existing subscriptions (OAuth imports from official CLIs) — no free tier limits, bypasses via subscription bonding across multiple accounts
- **Stealth/Bypass Mechanism**: 
  - OAuth token auto-refresh from official CLIs
  - Subscription bonding (round_robin/priority/reset_first routing)
  - Automatic failover on rate limits with account cooldown
  - Dario broker for Anthropic wire-format translation
  - Reverse wrap for closed harnesses (Amp, Cursor)
- **Self-Hostable**: ✅ Native binaries (macOS/Windows/Linux ARM64+x86), Docker, Cargo install
- **Active Maintenance**: ✅ Last push <1 week ago, active CI, 20+ harness integrations
- **Language/Stack**: Rust (daemon), Swift (macOS app), SQLite traces
- **Notable Features**: Session forking across harnesses, trace browser, remote agent control plane, scoped run keys, tokenmax across accounts, PAM MoA dial integration

---

### 2. **justlovemaki/AIClient2API** — *Node.js Multi-Protocol Proxy* ⭐⭐⭐⭐⭐
- **URL**: https://github.com/justlovemaki/AIClient2API (8.7k ⭐)
- **Primary Purpose**: Self-hosted proxy converting client-only LLMs (Gemini, Antigravity, Codex, Grok, Kiro) → OpenAI/Claude/Gemini compatible APIs
- **Free Tier / "Unlimited"**: Converts free client-tier access (Gemini CLI, Antigravity, Grok, Codex) into standard APIs — claims "enterprise users can claim 12M tokens free, earn billions via referrals"
- **Stealth/Bypass Mechanism**:
  - **OAuth authorization bypass** for Gemini/Antigravity rate/quota limits
  - **TLS fingerprint bypass** via built-in Go uTLS sidecar
  - Three-protocol mutual conversion (OpenAI↔Claude↔Gemini)
  - Multi-account pools with async refresh queue
  - Path-based dynamic model switching
- **Self-Hostable**: ✅ Node.js + Go uTLS sidecar, Docker support
- **Active Maintenance**: ✅ Very active (8.7k stars, recent pushes)
- **Language/Stack**: Node.js (main), Go (uTLS sidecar)
- **Notable Features**: Web UI management console, Cherry-Studio/NextChat/Cline compatible, provider pools, smart routing, auto failover

---

### 3. **Shaivpidadi/FreeRideV3** — *Multi-Provider Free Tier Aggregator* ⭐⭐⭐⭐
- **URL**: https://github.com/Shaivpidadi/FreeRideV3
- **Primary Purpose**: Single OpenAI-compatible gateway routing across OpenRouter, Groq, NVIDIA NIM, Cloudflare Workers AI, HuggingFace with automatic failover
- **Free Tier / "Unlimited"**: Aggregates multiple free tiers behind one endpoint — "One free AI endpoint, every free tier behind it"
- **Stealth/Bypass Mechanism**:
  - Health-aware routing with automatic failover
  - Multi-provider load balancing
  - Quota-aware request routing
- **Self-Hostable**: ✅ Local gateway, Docker support
- **Active Maintenance**: ✅ Pushed 2 days ago (Sep 14, 2026)
- **Language/Stack**: TypeScript/Node.js
- **Notable Features**: 5+ free providers, auto failover, health monitoring, OpenAI-compatible

---

### 4. **LikithMeruvu/Hydra-gemini** — *Gemini Key Rotation Gateway* ⭐⭐⭐⭐
- **URL**: https://github.com/LikithMeruvu/Hydra-gemini
- **Primary Purpose**: OpenAI-compatible gateway unlocking "unlimited free-tier usage by aggregating multiple Google Gemini keys"
- **Free Tier / "Unlimited"**: Aggregates multiple Gemini API keys for unlimited free-tier usage (~1.7B tokens/month claimed by similar projects)
- **Stealth/Bypass Mechanism**:
  - **Automatic rate-limit rotation** across multiple Gemini keys
  - **Load balancing** with automatic failover
  - **Secure Cloudflare tunneling** for remote access
  - Local dashboard for real-time monitoring
- **Self-Hostable**: ✅ Docker, local deployment
- **Active Maintenance**: ⚠️ Last push Feb 2026 (7 months ago) — still functional but slower updates
- **Language/Stack**: Python/Go
- **Notable Features**: Multi-key aggregation, Cloudflare tunnel, monitoring dashboard, OpenAI-compatible

---

### 5. **router-for-me/CLIProxyAPI** (and forks) — *Go CLI Proxy Engine* ⭐⭐⭐⭐
- **URL**: https://github.com/router-for-me/CLIProxyAPI (mirrors: jtnetcc/CLIProxyAPI, kaitranntt/CLIProxyAPIPlus, XCQ0607/cliproxyapi_docker)
- **Primary Purpose**: Original Go-based CLI proxy engine — OpenAI/Gemini/Claude/Codex compatible endpoints, multi-account round-robin, OAuth flows for every major provider
- **Free Tier / "Unlimited"**: Uses OAuth subscriptions + multi-account round-robin for aggregated capacity
- **Stealth/Bypass Mechanism**:
  - Multi-account round-robin load balancing
  - OAuth flows for all major providers (Claude, Codex, Gemini, Grok)
  - Reusable Go SDK for downstream projects
  - TLS fingerprint handling
- **Self-Hostable**: ✅ Go binary, Docker (XCQ0607/cliproxyapi_docker updated Sep 15, 2026)
- **Active Maintenance**: ✅ Active forks with daily auto-sync (CLIProxyAPIPlus)
- **Language/Stack**: Go
- **Notable Features**: Blueprint for entire ecosystem, powers AIClient2API, BlacklistedAIProxy, FreeRideV3 descendants

---

### Honorable Mentions (Active & Notable)

| Project | Stars | Key Differentiator |
|---------|-------|-------------------|
| **MrKrugen/BlacklistedAIProxy** | New | "Jailbreaks client-only restrictions" — Grok, Claude, Codex, Qwen Code → single OpenAI gateway; Go TLS tricks + Promptfoo red-team tested |
| **natorus87/litellm-free-models** | - | LiteLLM proxy aggregating 13 free providers (OpenRouter, Cerebras, Groq, Cloudflare, NVIDIA, Mistral, Cohere, GitHub Models, OpenCode Zen, LLM7, HF, OVHcloud, Google AI Studio) with auto LB/fallback |
| **vinaygiri/freeway** | - | 26 free-tier providers, auto-failover, quota-aware routing, request auto-fit for Claude Code/Codex |
| **0xgetz/freebuff-9router** | - | Codebuff/Freebuff free tier via 9router gateway: device-code OAuth, local adapter, auto model registration |
| **Majidi-star/FreeLLM-Gateway** | - | Universal proxy with split-tunnel VPNs, custom rate limits (RPM/RPD), multi-tier fallback chains |
| **sass-maker/free-ai** | - | Cloudflare Workers deployment, health-aware routing, serverless free tier |

---

### Summary Comparison

| Criteria | alex | AIClient2API | FreeRideV3 | Hydra-gemini | CLIProxyAPI |
|----------|------|--------------|------------|--------------|-------------|
| **Multi-Provider** | ✅ 8+ | ✅ 7+ | ✅ 5+ | ⚠️ Gemini only | ✅ 4+ |
| **OAuth Subscriptions** | ✅ Native | ✅ Native | ❌ API keys | ✅ Multi-key | ✅ Native |
| **Rate Limit Bypass** | ✅ Bonding | ✅ OAuth+TLS | ✅ Failover | ✅ Key rotation | ✅ Round-robin |
| **TLS Fingerprint Bypass** | ❌ | ✅ uTLS sidecar | ❌ | ❌ | ⚠️ Partial |
| **Self-Hosted** | ✅ Binary | ✅ Docker | ✅ Local | ✅ Docker | ✅ Binary |
| **Active (Sep 2026)** | ✅ | ✅ | ✅ | ⚠️ Stale | ✅ (forks) |
| **Best For** | Devs with subscriptions | Free client-tier maxing | Simple free aggregation | Gemini-heavy users | Go ecosystem |

---

**Recommendation**: 
- **If you have paid subscriptions** → **alex** (best UX, session forking, traces, subscription bonding)
- **If you want maximum free client-tier** → **AIClient2API** (most providers, TLS bypass, web UI)
- **If you want simplest free aggregation** → **FreeRideV3** or **freeway** (26 providers)
- **If you're Gemini-heavy** → **Hydra-gemini** (multi-key rotation)

---
