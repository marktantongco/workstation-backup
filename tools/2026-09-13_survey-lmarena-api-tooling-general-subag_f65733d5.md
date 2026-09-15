# Survey lmarena API tooling (@general subagent)

- **Session ID:** `ses_f65733d5effeVo3gSwO4ILP3r4`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-13 19:35:11
- **Last activity:** 2026-09-13 19:36:32
- **Messages:** 6

---

### 🧑 User — 2026-09-13 19:35:12

Survey the external landscape for programmatic LMArena (lmarena.ai) access options as of 2026. Use web_search (and webfetch only where excerpts insufficient) to answer:

1. Does lmarena.ai offer any official public API? (pricing/API docs?)
2. What known open-source projects reverse-engineer lmarena.ai chat endpoints (e.g. lmdeploy, unofficial APIs, browser-automation, har-replay tools)? Name 3-6 with one-line mechanism each (websocket replay? Next.js data channel? polling?).
3. What is lmarena.ai built on (Next.js? Cloudflare? known chat protocol)? Any public writeups of its network protocol.
4. ToS / rate-limit / anti-abuse posture relevant to server-side fetching.

Report facts with source URLs. Under 1200 words. No file changes.

---

### 🤖 Assistant — 2026-09-13 19:35:12

Need programmatic LMArena access survey. I'll run web searches covering official API, unofficial projects, stack, ToS.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Find if lmarena.ai offers official public API, pricing, docs; search_queries=['lmarena.ai official API docs pricing', 'LMArena API access 2026', 'lmarena.ai 
--- output ---
{
  "search_id": "search_b4268bafff03aa7ff0599dd91177efa6",
  "results": [
    {
      "url": "https://github.com/lmarena",
      "title": "Arena · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Page: GitHub organization profile\n* URL: https://github.com/lmarena\n* Location: United States of America\n* Website: https://arena.ai/blog/\n* Links: https://x.com/arena/, https://discord.gg/arena-ai, https://linkedin.com/company/arenaai/, https://www.youtube.com/@ArenaAIOfficial\n* Top languages: Python, TypeScript, Jupyter Notebook, HTML, Go, Clojure, JavaScript\nWhere AI meets the real world. Formerly LMArena. We measure and advance the frontier of AI through community-driven evaluation. - Arena\nRepositories\n* lmarena/arena-rank: Source Code of Arena Leaderboard Methodology\n* lmarena/list: The Public Suffix List\n* lmarena/shap-clj: A Clojure equivalent to Python's SHAP library to evaluate deep neural net input performance\n* lmarena/homework-intake\n* lmarena/search-arena: ⚔️ [ICLR 2026] Official code of \"Search Arena: Analyzing Search-Augmented LLMs\".\n* lmarena/lmarena.github.io\n* lmarena/arena-catalog\n* lmarena/copilot-arena\n* lmarena/micromark-extension-math: micromark extension to support math ($C_L$)\n* lmarena/nextjs-tailwind-starter"
      ]
    },
    {
      "url": "https://parse.bot/marketplace/f4504720-6673-4f4c-bca2-323669b31876/lmarena-ai-api",
      "title": "LMArena API – AI Model Leaderboards · Parse",
      "publish_date": "2026-07-23",
      "excerpts": [
        "Parse Parse\nDiscover\nDocs Talk to us Log In Get Started\nOn this page\n* Playground\n* Call over HTTP\n* Python SDK\n* Endpoints\n* Ask the agent\n  Discover / LMArena API\n  live\nLMArena API lmarena.ai ↗\nAccess LMArena.ai leaderboard rankings across text, code, vision, image, video, and search arenas. Get model ratings, votes, licenses, and capabilities via 13 endpoints.\nThis API takes change requests — ask its agent to add endpoints, fields, or filters .\nDeveloper Tools reviews ratings other\nMCP Subscribe\nEndpoint health\nverified 31m ago\n+ 8 more endpoints\n  13/13 passing latest check self-healing\n  Endpoints\n  13\n  Updated\n  1mo ago\nWhat is the LMArena API?\nThis API exposes 13 endpoints covering every leaderboard category on lmarena.ai — text, code, vision, image editing, text-to-image, text-to-video, image-to-video, and search — plus a full model catalog.\n* Fully typed · autocompletes\n* Objects link to objects\n* Typed errors & pagination\nTyped Python client. Set up the SDK in your uv project, then pull this API’s typed client:\nCopy\nuv add parse-sdk\nuv run parse init\nuv run parse add --marketplace lmarena-ai-api\nclient =  LMArena ()\nHandle a bad category gracefully\nThis endpoint gives a complete, modality-aware picture of what is active on the platform at any moment.\nReliability & maintenance Verified 31m ago\nThe LMArena API is a managed, monitored endpoint for lmarena.ai — not a raw scraper you maintain.\nHandle a bad category gracefully\nThis isn't an officiallmarena.aiAPI — it's an independent, maintained REST wrapper over public data. Where the source has no official API (or only a limited one), Parse gives you a stable contract over a source that never promised one, and keeps it current. Need a new endpoint or field?\nHandle a bad category gracefully\n* Identify which image-generation models are currently selectable by users by joining get_text_to_image_leaderboard entries with list_available_models on model id.\nPricing & limits See full pricing →\n* Tier | Price | Credits/month | Rate limit\n* Free | $0/mo | 200 | 5 req/min\nHandle a bad category gracefully\nEach endpoint has a fixed posted price per successful call — most fall between 1 and 10 credits — shown on this API's page before you run it. Exceeding the rate limit returns a 429 response. Authenticate with the X-API-Key header.\nFrequently asked questions\nDoes lmarena.ai have an official developer API? +\nHandle a bad category gracefully\nNo. lmarena.ai does not publish a documented public developer API or SDK. This Parse API is how developers access its leaderboard and model data programmatically. What does list_available_models return that the leaderboard endpoints don't? +\nHandle a bad category gracefully\nWhen provided, it scopes the match to that specific arena. The match is a case-insensitive substring against both modelDisplayName and modelOrganization fields in the response entries.\nPage content last updated June 11, 2026 . Spec covers 13 endpoints from lmarena.ai."
      ]
    },
    {
      "url": "https://github.com/tawer-blog/lmarena-2api",
      "title": "GitHub - tawer-blog/lmarena-2api · GitHub",
      "publish_date": null,
      "excerpts": [
        "tawer-blog/lmarena-2api\n* Page: GitHub repository\n* URL: https://github.com/tawer-blog/lmarena-2api\n* Stars: 28\n* Forks: 4\n* License: MIT license\n* Default branch: main\n* Created: 2025-08-01T05:48:38.000Z\n* Commits: 4\nTop-level files\n* LICENSE\n* README.md\n* lmarena_injector.user.js\n* proxy_server.py\n* requirements.txt\n* start.sh\n* start_windows.bat\nREADME.md\nLMArena Reverse Proxy Server\nPython FastAPI License Platform\n一个功能强大的 LMArena 反向代理服务器，提供 OpenAI 兼容的 API 接口、实时监控面板、动态配置管理等企业级功能。\nEnglish | 功能特性 | 快速开始 | API文档 | 监控面板 | 配置管理\n✨ 功能特性\n🚀 核心功能\n* OpenAI API 兼容 ：完全兼容 OpenAI API 格式，支持流式和非流式响应，无缝接入现有应用。\n* 多模型支持 ：支持 LMArena 上的 100+ AI 模型，包括 Claude、GPT、Gemini、DeepSeek 等。\n* 智能请求管理 ：强大的断线重连、请求持久化和自动重试机制，从容应对 Cloudflare 验证和网络波动。\n* 实时监控面板 ：提供美观的 Web 界面，实时监控系统状态、请求日志、性能指标。\n📊 监控与分析\n* 断线重连 ：浏览器与服务器之间的 WebSocket 连接拥有强大的自动重连机制。\n* 请求持久化 ：即使浏览器刷新或关闭，正在处理的 API 请求也不会丢失，会在重连后继续执行。\n* 完善的错误处理 ：对网络错误、Cloudflare 挑战、速率限制等问题有专门的处理逻辑。\n* 健康检查 ：内置详细的健康检查和评分系统，随时掌握服务状态。\n🏗️ 系统架构\n* Python 服务端 ( proxy_server.py ): 核心 FastAPI 服务器，负责处理 API 请求和与浏览器脚本的 WebSocket 通信。\n* 浏览器脚本 ( lmarena_injector.user.js ): 通过 Tampermonkey 注入到 LMArena 网站，作为服务器的“手臂”，执行实际的 AI 请求。\n* 监控面板 : 一个 Vue.js 单页应用，用于实时显示系统状态和性能指标。\n📦 安装要求\n* Python 3.8+\n* 支持的操作系统 : Windows, Linux, macOS\n* 浏览器 : 最新版的 Chrome / Edge / Firefox\n* 浏览器扩展 : Tampermonkey\n🚀 快速开始\n1. 克隆项目\ngit clone https://github.com/zhongruichen/lmarena-proxy.git\ncd lmarena-proxy\n2. 安装 Python 依赖\npip install -r requirements.txt\n3. 安装浏览器脚本 (Tampermonkey)\n这是最关键的一步。此脚本负责连接代理服务器并执行请求。\n推荐方式 (自动更新):\n1. 点击此链接进行安装: Install Script from GitHub\n2. Tampermonkey 会自动打开一个页面，显示脚本信息，点击 “安装” 按钮。\n  手动方式:\n3. 安装 Tampermonkey 浏览器扩展。\n4. 打开项目中的 lmarena_injector.user.js 文件。\n5. 复制文件的 全部 内容。\n6. 点击 Tampermonkey 浏览器图标，选择 “创建新脚本” 。\n7. 将复制的内容粘贴到编辑器中，替换掉所有默认内容。\n8. 保存脚本 (Ctrl+S)。\n9. 启动服务器\n* Windows 用户: 直接双击运行 start_windows.bat 文件。\n* Linux / macOS 用户:\n启动脚本\n./start.sh\n脚本会自动启动 Python 服务器，并尝试打开 LMArena 和监控面板页面。\n5. 检查连接状态\n6. 打开或刷新 LMArena 网站 。\n7. 打开浏览器开发者工具 (F12)，切换到 Console (控制台) 。\n8. 如果你看到 [Injector] ✅ Connection established with local server. 的绿色消息，说明连接成功！\n9. 使用 API\n现在，你可以使用任何兼容 OpenAI 的客户端来调用 API。\nfrom openai import OpenAI"
      ]
    },
    {
      "url": "https://github.com/l3nn0n009/lmarena",
      "title": "GitHub - l3nn0n009/lmarena · GitHub",
      "publish_date": null,
      "excerpts": [
        "l3nn0n009/lmarena\n* Page: GitHub repository\n* URL: https://github.com/l3nn0n009/lmarena\n* Stars: 0\n* Forks: 0\n* Default branch: master\n* Created: 2025-12-30T22:32:55.000Z\n* Commits: 8\nTop-level files\nA local application that provides free, unlimited access to AI models (Claude Opus 4.5, GPT 5.2, Gemini 3 Pro, etc.) through LMArena by controlling a real browser session in the background.\n🚀 Features\nOpen http://localhost:5173\n└────────────────────────────┬────────────────────────────────┘\n│ Puppeteer (Stealth)\n┌────────────────────────────┴────────────────────────────────┐\n│              Hidden Chrome Browser → lmarena.ai             │\n└─────────────────────────────────────────────────────────────┘\nChrome profile to copy from (default: Profile 3)\n* Check if LMArena updated their DOM structure\n* The SSE endpoint /nextjs-api/stream/create-evaluation may change\n* Fallback: Use original server/lmarena.js (slower but more resilient)\nCLI Not Connecting\nThen in new terminal\nlmarena/\n├── cli/\n│   └── cli.js              # Grove CLI (Claude Code alternative)\n├── server/\n│   ├── index.js            # Express + Socket.io server\n│   ├── browser.js          # Puppeteer controller\n│   ├── lmarena-optimized.js # Optimized LMArena controller\nThen in new terminal\n│   └── lmarena.js          # Original controller (backup)\n├── client/                 # React web UI (optional)\n└── chrome-profile/         # Persistent browser data"
      ]
    },
    {
      "url": "https://github.com/virtual-byte/LMArena-Api",
      "title": "GitHub - virtual-byte/LMArena-Api: Proxying LMArena to access many models · GitHub",
      "publish_date": null,
      "excerpts": [
        "virtual-byte/LMArena-Api\n* Page: GitHub repository\n* URL: https://github.com/virtual-byte/LMArena-Api\n* Description: Proxying LMArena to access many models\n* Stars: 11\n* Forks: 3\n* Default branch: main\n* Created: 2025-08-20T13:40:00.000Z\n* Commits: 10\nTop-level files\n* Userscript/\n* browser/\n* server/\n* templates/\n* .gitattributes\n* README.md\n* example.py\n* starter.py\nREADME.md\nFree LMArena Api\ndownloads badge All logs from https://github.com/zhongruichen/lmarena-proxy have been translated into English and a portable browser has been built-in.\nInstall & Use"
      ]
    },
    {
      "url": "https://github.com/lmarena/arena-catalog",
      "title": "GitHub - lmarena/arena-catalog · GitHub",
      "publish_date": null,
      "excerpts": [
        "lmarena/arena-catalog\n* Page: GitHub repository\n* URL: https://github.com/lmarena/arena-catalog\n* Stars: 15\n* Forks: 8\n* Default branch: main\n* Created: 2024-09-30T22:40:54.000Z\n* Commits: 384\nTop-level files\nscatterplot-data.json\nYou can add new models or update pricing information of existing models in this file. Models must be in this file to appear in the scatterplot.\nvisiblity-data.json\nTweak this file to control which models receive labels on the scatterplot and what direction (left / right) they show up in.\nArena Score v. Cost Scatterplot\nTo update model prices or add a model to the Arena Score v. Cost scatterplot at feel free to add to data/scatterplot-data.json\nFor example, if I wanted to add test-model to the scatterplot I would add the following object:\n{\n\"name\": \"Test Model\",\n\"model_api_key\": \"test-model\",\n\"input_token_price\": \"1\",\n\"output_token_price\": \"10\",\n\"organization\": \"Test Organization\",\n\"license\": \"Proprietary\",\n\"price_source\": \"www.pricesource.com\",\n\"model_source\": \"www.modelsource.com\",\n}\nNote: for text2img models, \"input_token_price\" and \"output_token_price\" refer to the price per input image and the price per output image."
      ]
    },
    {
      "url": "https://github.com/BrunoRakotomalala62/Lmarena",
      "title": "GitHub - BrunoRakotomalala62/Lmarena · GitHub",
      "publish_date": null,
      "excerpts": [
        "BrunoRakotomalala62/Lmarena\n* Page: GitHub repository\n* URL: https://github.com/BrunoRakotomalala62/Lmarena\n* Stars: 0\n* Forks: 0\n* License: MIT license\n* Default branch: main\n* Created: 2026-01-22T05:26:23.000Z\n* Commits: 22\nTop-level files\n* .gitignore\n* LICENSE\n* README.md\n* config.json\n* lmarena_finder.py\n* requirements.txt\n* setup.sh\nREADME.md\nLMArena Riftrunner Finder - AI Model Detection & Identification Tool(Retired)\n**Gemini 3 released, this repo retired. Python License: MIT Selenium\nAutomated AI Model Fingerprinting & Detection Tool - Python-based web scraper to identify anonymous LLM models on lmarena.ai blind testing platform. Specifically designed to detect the \"riftrunner\" anonymous model through response pattern analysis.\nIf you’re looking for the anonymous LMArena checkpoint codenamed \"riftrunner\" – the model many in the community believe to be a Gemini 3.0 Pro release-candidate – this tool automates the process of finding it on lmarena.ai’s blind testing platform.\nIn this repository, any mentions of \"Gemini 3\" or \"Gemini 3 Pro\" are just shorthand for this anonymous LMArena model ( riftrunner ), not for any officially released Google Gemini 3 product. Some community posts also refer to it as \"Rift Runner\" , which this README treats as the same model.\nTerminology note: throughout this README, \"Gemini 3\" / \"Gemini 3 Pro\" always refer to the anonymous LMArena model codenamed riftrunner , as speculated by the community – not to any officially released Google product.\n🎯 Purpose\nThis tool automates the process of finding the \"riftrunner\" anonymous model on LMArena's blind testing platform by:\n* Submitting custom prompts with images\n* Analyzing AI responses for specific fingerprint patterns\n* Automatically retrying until a match is found\n* Supporting proxy configurations for network access\n✨ Features\n📋 Requirements\n* Python 3.8+\n* Google Chrome browser (installed on your system)\n* macOS, Linux, or Windows\n* Internet connection (proxy optional)\n🚀 Quick Start\n1. Clone the Repository\ngit clone https://github.com/aezizhu/lmarena-riftrunner-finder.git\ncd lmarena-riftrunner-finder\n2. Install Dependencies"
      ]
    },
    {
      "url": "https://github.com/jtostrings/LMarenaBridge/blob/master/README_EN.md",
      "title": "LMarenaBridge/README_EN.md at master · jtostrings/LMarenaBridge · GitHub",
      "publish_date": null,
      "excerpts": [
        "jtostrings/LMarenaBridge — README_EN.md\n* Page: GitHub code file\n* URL: https://github.com/jtostrings/LMarenaBridge/blob/master/README_EN.md\n* Repository: jtostrings/LMarenaBridge\n* Path: README_EN.md\n* Ref: master\n* Lines: 444\n  中文 | English\n🤖 LMArena-API\nDesktop tool for free access to top AI models like Claude, GPT-4, Gemini, etc.\nLMArena-API is a desktop application that allows you to use various top-tier large language models such as Claude, GPT-4, and Gemini in any AI client without a paid subscription.\nIt uses reverse engineering to convert all models from the LMArena.ai platform into an OpenAI-compatible format, enabling API calls."
      ]
    },
    {
      "url": "https://github.com/virtual-byte/LMArena-Api/blob/main/README.md",
      "title": "LMArena-Api/README.md at main · virtual-byte ... - GitHub",
      "publish_date": null,
      "excerpts": [
        "LMArena-Api/README.md at main · virtual-byte ... - GitHub\nProxying LMArena to access many models. Contribute to virtual-byte/LMArena-Api development by creating an account on GitHub."
      ]
    },
    {
      "url": "https://github.com/lmarena/search-arena",
      "title": "GitHub - lmarena/search-arena: ⚔️ [ICLR 2026] Official code of \"Search Arena: Analyzing Search-Augmented LLMs\". · GitHub",
      "publish_date": null,
      "excerpts": [
        "lmarena/search-arena\n* Page: GitHub repository\n* URL: https://github.com/lmarena/search-arena\n* Description: ⚔️ [ICLR 2026] Official code of \"Search Arena: Analyzing Search-Augmented LLMs\". - lmarena/search-arena\n* Stars: 59\n* Forks: 9\n* Default branch: main\n* Created: 2025-06-04T04:54:24.000Z\n* Commits: 6\nTop-level files\nSearch Arena arXiv Dataset X (Twitter) ICLR 2026\nWelcome to the official code repository of Search Arena . Explore ⚔️ Search Arena and experiment with state-of-the-art Search-Augmented LLMs (new UI integration is coming soon)!\nPaper : Search Arena: Analyzing Search-Augmented LLMs (ICLR 2026)"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90123"
}
```

---

### 🤖 Assistant — 2026-09-13 19:35:34

First batch done. Now searching stack, protocol, ToS.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Find lmarena.ai tech stack Next.js Cloudflare and network protocol writeups; search_queries=['lmarena.ai Next.js Cloudflare tech stack', 'lmarena.ai stream create-evaluatio
--- output ---
{
  "search_id": "search_1efcc1a61c426a921d5d4c32e5bb3e48",
  "results": [
    {
      "url": "https://github.com/l3nn0n009/lmarena",
      "title": "GitHub - l3nn0n009/lmarena · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Grove CLI : Claude Code-like terminal interface for AI-powered coding\n* Tool Calling : AI can create/edit files directly via structured tool calls\n* Optimized Streaming : Network-level SSE interception (no DOM scraping lag)\n* Browser Automation : Puppeteer with stealth plugins for anti-bot evasion\n* Real-time Streaming : WebSocket-based token streaming for live responses\n* Web UI : Beautiful dark theme with glassmorphism effects (optional)\nOpen http://localhost:5173\nThe AI can create files directly. When it detects you need a file created, it outputs:\n📄 create_file: src/server.js\n✓ Created: src/server.js (25 lines)\nThe file is instantly written to your working directory.\n🏗️ Architecture\nOpen http://localhost:5173\n└────────────────────────────┬────────────────────────────────┘\n│ Puppeteer (Stealth)\n┌────────────────────────────┴────────────────────────────────┐\n│              Hidden Chrome Browser → lmarena.ai             │\n└─────────────────────────────────────────────────────────────┘\nOpen http://localhost:5173\n1. SSE Interception : Captures tokens directly from network responses\n2. Resource Blocking : Blocks images, fonts, media, analytics\n3. DOM Hiding : Hides chat UI to prevent layout thrashing\n4. Real-time Cleanup : Removes old messages from DOM periodically\n⚙️ Configuration\nEnvironment Variables\nChrome profile to copy from (default: Profile 3)\n* Text : GPT 5.2, Claude Opus 4.5, Gemini 3 Pro, DeepSeek V3.2, Grok 4.1\n* Image : GPT Image 1.5, DALL-E 3, FLUX 2, Gemini Image\n* Search : GPT Search, Perplexity Sonar, Gemini Grounding\n🔧 Troubleshooting\nCloudflare Challenge\nChrome profile to copy from (default: Profile 3)\n1. First run opens Chrome visibly\n2. Complete the challenge manually if needed\n3. Session saved in ./chrome-profile/\nNo Response\nChrome profile to copy from (default: Profile 3)\n* Check if LMArena updated their DOM structure\n* The SSE endpoint /nextjs-api/stream/create-evaluation may change\n* Fallback: Use original server/lmarena.js (slower but more resilient)\nCLI Not Connecting\nMake sure server is running first\nnpm start\nThen in new terminal\nnpm run grove\n📁 Project Structure\nThen in new terminal\nlmarena/\n├── cli/\n│   └── cli.js              # Grove CLI (Claude Code alternative)\n├── server/\n│   ├── index.js            # Express + Socket.io server\n│   ├── browser.js          # Puppeteer controller\n│   ├── lmarena-optimized.js # Optimized LMArena controller\nThen in new terminal\n│   └── lmarena.js          # Original controller (backup)\n├── client/                 # React web UI (optional)\n└── chrome-profile/         # Persistent browser data"
      ]
    },
    {
      "url": "https://developers.cloudflare.com/agents/model-context-protocol",
      "title": "Model Context Protocol (MCP)",
      "publish_date": null,
      "excerpts": [
        " > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nJun 3, 2026 · Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. What is the Model Context... · MCP Terminology · Best Practices\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nJun 3, 2026 · Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. deploy your first remote MCP server to\n > \nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\n > \nModel Context Protocol (MCP)\nJun 3, 2026 — Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\nModel Context Protocol (MCP)\nModel Context Protocol (MCP)\nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. https://developers.cloudflare.com/\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nMay 18, 2026 · Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. What is the Model Context... · MCP Terminology · Best Practices\n > \nModel Context Protocol (MCP)\n2026. 6. 3. — Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\n > \nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services.\nModel Context Protocol (MCP) · Cloudflare Agents docs\nModel Context Protocol (MCP) is an open standard that connects AI systems with external applications.\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\n3 Jun 2026 — Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. You can build and deploy Model Context\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\nJun 3, 2026 · Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. API reference Harnesses Overview … is\n > \nModel Context Protocol (MCP) · Cloudflare Agents docs\n4 days ago · Build and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services. What is the Model Context... · MCP Terminology · Best Practices\n > \nBuild and deploy remote MCP servers on Cloudflare to connect AI agents with external tools and services."
      ]
    },
    {
      "url": "https://community.cloudflare.com/t/the-ai-engineering-stack-we-built-internally-on-the-platform-we-ship/921820",
      "title": "The AI engineering stack we built internally — on the platform we ship - Developers / Workers AI - Cloudflare Community",
      "publish_date": null,
      "excerpts": [
        "The AI engineering stack we built internally — on the platform we ship\nDevelopers Workers AI\n* Blog\n  cloudflare.com\n  You have selected 0 posts.\n  select all\n  cancel selecting\npost by CF_Team 1 day ago\nCF_Team Community Team\n1\n1d\nThe Cloudflare Blog – 20 Apr 26\nThe AI engineering stack we built internally — on the platform we ship\n* Workers AI returns 4006 / free neuron limit exceeded but dashboard usage is 0/10k\nWorkers AI\n* workers | 3 | 69 | Apr 10\n* Cloudflare Worker AI is slow\nWorkers AI\n* workers | 0 | 29 | Apr 10\n* Beyond the pipe: Cloudflare’s vision for the AI future of connection\nWorkers AI\n* Connect2025 |0 |32 |Jan 6 |\nIn addition, we may also provide these marketing and advertising partners with your email address or other limited account information. You may opt out of such sharing by emailing us at sar@cloudflare.com.\nTo learn more about the cookies we use on our site, please read our Cookie Policy. Cloudflare's Cookie Policy\nAdvertising and Marketing Cookies\nLike many companies, Cloudflare uses services that help deliver interest-based ads to you and may transfer Personal Information to business partners for their use, including via advertising and marketing cookies."
      ]
    },
    {
      "url": "https://developers.cloudflare.com/agents/model-context-protocol/transport",
      "title": "Transport · Cloudflare Agents docs",
      "publish_date": null,
      "excerpts": [
        "Documentation Index Fetch the complete documentation index at: https://developers.cloudflare.com/agents/llms.txt Use this file to discover all available pages before exploring further.\nSkip to content\nTransport\nThe Model Context Protocol (MCP) specification defines two standard transport mechanisms ↗ for communication between clients and servers:\nImplementing remote MCP transport\nUse createMcpHandler to create an MCP server that handles Streamable HTTP transport. This is the recommended approach for new MCP servers.\nGet started quickly\nYou can use the \"Deploy to Cloudflare\" button to create a remote MCP server.\n<Deploy to Workers>\nRemote MCP server (without authentication)\nStreamable HTTP streams are resumable: configure an EventStore so clients can reconnect with a Last-Event-ID header and replay missed events, keeping in-flight tool calls alive across the edge idle-stream watchdog. DurableObjectEventStore is exported from agents/mcp for stateful WorkerTransport callers. Refer to McpAgent: Stream resumability.\nconst result = streamText({      model,      tools: allTools,      // ... });\nreturn createUIMessageStreamResponse({ stream: result });  }}\nTypeScript\nimport { AIChatAgent } from \"@cloudflare/ai-chat\";\n* Transport | Use when | Pros | Cons\n* Streamable HTTP | External MCP servers, production apps | Standard protocol, secure, supports auth | Slight network overhead\n* RPC | Internal agents on Cloudflare | Fastest, simplest setup | No auth, Durable Object bindings only\n{\"@context\":\"https://schema.org\",\"@type\":\"TechArticle\",\"@id\":\"https://developers.cloudflare.com/agents/model-context-protocol/protocol/transport/#page\",\"headline\":\"Transport · Cloudflare Agents docs\",\"description\":\"Configure Streamable HTTP transport for remote MCP servers built with the Agents\nSDK.\",\"url\":\"https://developers.cloudflare.com/agents/model-context-protocol/protocol/transport/\",\"inLanguage\":\"en\",\"image\":\"https://developers.cloudflare.com/dev-products-preview.png\",\"dateModified\":\"2026-06-03\",\"publisher\":{\"@type\":\"Organization\",\"name\":\"Cloudflare\",\"url\":\"https://www.cloudflare.com/\"},\"isPartOf\":{\"@type\":\"WebSite\",\"@id\":\"https:/\n(MCP)\"}},{\"@type\":\"ListItem\",\"position\":4,\"item\":{\"@id\":\"/agents/model-context-protocol/protocol/\",\"name\":\"Protocol\"}},{\"@type\":\"ListItem\",\"position\":5,\"item\":{\"@id\":\"/agents/model-context-protocol/protocol/transport/\",\"name\":\"Transport\"}}]}"
      ]
    },
    {
      "url": "https://developers.cloudflare.com/llms.txt?trk=public_post_comment-text",
      "title": "llms.txt",
      "publish_date": null,
      "excerpts": [
        "* API Shield: Identify and address your API vulnerabilities\n* Bots: Protect your domain from bad bot traffic\n* Client-side security: Provide client-side protection for your website visitors\n* Challenges: Verify visitors are not bots with lightweight challenges\n* Email Service: Send transactional emails at scale with Cloudflare Email Service\n* Flagship: Feature flags evaluated at the edge for Cloudflare Workers\n* Hyperdrive: Accelerate database queries to make databases fast globally\n* Cloudflare Images: Store, transform, optimize, and deliver images at scale\n* KV: Global, low-latency, key-value data storage\n* MoQ: Protocol for live media\n* Pages: Build full-stack, serverless applications globally with minimal configuration\n* Pipelines: Ingest real time data streams and load into R2\n* Privacy Gateway: Implement the Oblivious HTTP IETF standard to improve client privacy"
      ]
    },
    {
      "url": "https://developers.cloudflare.com/stream/changelog",
      "title": "Changelog · Cloudflare Stream docs",
      "publish_date": null,
      "excerpts": [
        " > \nChangelog · Cloudflare Stream docs\nApr 21, 2026 — Cloudflare Stream now supports the SRT live streaming protocol. SRT is a modern, actively maintained streaming video protocol that delivers\n > \nChangelog - Stream\n2024-04-11. Live Instant Clipping for live broadcasts and recordings . Clipping is now available in open beta for live broadcasts and recordings. For more\nChangelog - Stream\nApr 21, 2026 — Cloudflare Stream now has no limit on the number of live inputs you can create. Stream is designed to allow your end-users to go live — live\n > \nChangelog - Stream\nCloudflare Stream now has no limit on the number of live inputs you can create. Stream is designed to allow your end-users to go live. Removed\nChangelog · Cloudflare Stream docs\nStream now supports full HD encoding for portrait/vertical videos. Videos with a height greater than their width will now be constrained and prepared for\n > \nChangelog · Cloudflare Stream docs\nSRT is a modern, actively maintained streaming video protocol that delivers lower latency, and better resilience against unpredictable network conditions. SRT"
      ]
    },
    {
      "url": "https://developers.cloudflare.com/directory",
      "title": "Docs directory",
      "publish_date": null,
      "excerpts": [
        "Automatic Platform OptimizationImprove WordPress site performance by serving it from Cloudflare's global network\nBillingManage billing, plans, and subscriptions for your account\nBotsProtect your domain from bad bot traffic\nBrowser IsolationExecute active webpage content in a secure, isolated browser\nEmail ServiceSend transactional emails at scale with Cloudflare Email Service\nFlagshipFeature flags evaluated at the edge for Cloudflare Workers\nFFraud DetectionSequence rules use cookies to track the order and timing of requests\nGatewaySet up policies to inspect DNS, Network, HTTP, and Egress traffic\nPagesBuild full-stack, serverless applications globally with minimal configuration\nPipelinesIngest real time data streams and load into R2\nPrivacy GatewayImplement the Oblivious HTTP IETF standard to improve client privacy\nPrivacy PassPrivacy Pass tokens let users prove a claim without revealing their identity or being tracked across requests.\nRandomness BeaconExplore drand, a distributed service providing randomness to applications\nRRate limitingControl the rate of incoming requests matching an expression\nRealtimeRealtimeKit, SFU and TURN\nRealtime SFUInfrastructure for real-time serverless video, audio, and data applications"
      ]
    },
    {
      "url": "https://www.cloudflare.com/learning",
      "title": "Learning Center | Cloudflare",
      "publish_date": null,
      "excerpts": [
        "SSL, known today as TLS, is an encryption protocol that runs on top of HTTP to protect Internet communication between servers and clients.\nLearn about bots\nBots are automated applications that can browse the web. Some bots are helpful, but there are also malicious bots which can harm sites and applications.\nLearn about the cloud"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90123"
}
```

---

### 🤖 Assistant — 2026-09-13 19:35:42

Second search noisy. Need targeted fetches for ToS, stack, extra projects.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Find lmarena.ai terms of use automation prohibition and Cloudflare bot protectio; search_queries=['site:lmarena.ai terms use', 'lmarena.ai Cloudflare challenge bot protection by
--- output ---
{
  "search_id": "search_7df87fdc902dda4b9452b74f6a315376",
  "results": [
    {
      "url": "https://lmarena.ai/terms-of-use",
      "title": "Arena: Terms of Use Agreement",
      "publish_date": null,
      "excerpts": [
        "301 Moved Permanently\ncloudflare"
      ]
    },
    {
      "url": "https://news.lmarena.ai/multimodal",
      "title": "The Multimodal Arena is Here!",
      "publish_date": "2025-08-02",
      "excerpts": [
        "* LMArena.ai\n* Terms of Use\n* Privacy Policy\n* Cookie Policy\n  LMArena Blog © 2025. Powered by Ghost"
      ]
    },
    {
      "url": "https://blog.lmarena.ai/about",
      "title": "About LMArena",
      "publish_date": "2026-01-28",
      "excerpts": [
        "Join the team: arena.ai/jobs Follow us on X: @arena Follow us on LinkedIn: @ArenaAI Join the conversation: discord.gg/lmarena\n* arena.ai\n* Terms of Use\n* Privacy Policy\n* Cookie Policy\n  Ⓒ Arena Intelligence 2026"
      ]
    },
    {
      "url": "https://news.lmarena.ai/policy",
      "title": "Arena Leaderboard Policy",
      "publish_date": null,
      "excerpts": [
        "301 Moved Permanently\ncloudflare"
      ]
    },
    {
      "url": "http://lmarena.ai/leaderboard/text/overall-no-style-control",
      "title": "Text Arena | LMArena",
      "publish_date": null,
      "excerpts": [
        "Stay updated on frontier AI capabilities For frontier AI news Follow us on\n* New Chat\n* Leaderboard\n  Terms of Use Privacy Policy Cookies\n  Start Voting\n  Overview Text WebDev Vision Text-to-Image Image Edit Search Text-to-Video Image-to-Video\n  Start Voting\n  Overview Text WebDev Vision Text-to-Image Image Edit Search Text-to-Video Image-to-Video"
      ]
    },
    {
      "url": "https://news.lmarena.ai/hard-prompts",
      "title": "Introducing Hard Prompts Category in Chatbot Arena",
      "publish_date": "2025-08-02",
      "excerpts": [
        "* LMArena.ai\n* Terms of Use\n* Privacy Policy\n* Cookie Policy\n  LMArena Blog © 2025. Powered by Ghost"
      ]
    },
    {
      "url": "https://news.lmarena.ai/arena-hard",
      "title": "From Live Data to High-Quality Benchmarks - The Arena-Hard Pipeline",
      "publish_date": "2025-08-02",
      "excerpts": [
        "* LMArena.ai\n* Terms of Use\n* Privacy Policy\n* Cookie Policy\n  LMArena Blog © 2025. Powered by Ghost"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90123"
}
```

---

### 🤖 Assistant — 2026-09-13 19:36:09

Excerpts thin on ToS and protocol. Fetching key pages direct.

**tool:parallel-search_web_fetch** (completed) 

```
allow_live_fetch=True; model_name=opencode/muse-spark-1.3-contributor-free; objective=Get LMArena terms prohibition, proxy mechanisms, official API status
--- output ---
{
  "extract_id": "extract_dd79f143b02055a7ed7f6382038a4768",
  "results": [
    {
      "url": "https://lmarena.ai/terms-of-use",
      "title": "Arena: Terms of Use Agreement | Arena Help Center",
      "publish_date": "2026-02-23",
      "excerpts": [
        "# Arena: Terms of Use Agreement\n## Terms of Use Agreement\nThis Terms of Use Agreement ( **“Terms of Use”** , and together with any applicable Supplemental Terms (as defined in Section 1.1 (Supplemental Terms)), the **“Agreement”** ) describes the terms and conditions that apply to your use of (i) the website located at [**https://arena.ai/**](https://lmarena.ai/) and its\nsubdomains and any of Company’s other websites on which a link to these Terms of Use appears (collectively, the **“Website”** ), (ii) the Company’s Discord server located at [**[https://discord.com/invite/arena-ai]**](https://discord.com/invite/LMArena) and bot made available through such Discord server, and other\n\n...\n\ndefined below) side-by-side and vote for such AI Services based on preference, (such services, collectively, with our Website, and the Arena Discord Bot, the **“Service”** ).\n\n...\n\n**USER CONDUCT AND CERTAIN RESTRICTIONS.** As a condition of use, you agree not to use the Service for any purpose that is prohibited by this Agreement or by applicable law.\n\n...\n\nrestrictions are expressly prohibited by applicable law; (vi) access the Services through programmatic or automated means or automatically query the Services, (vii) use any manual or automated software, devices or other processes (including but not limited to spiders, robots, scrapers, crawlers, avatars, data mining\ntools, or the like) to “scrape”, extract, or download data, including AI Service names, identifiers, or versions, from any web pages contained in the Service (except that we grant the operators of public search engines revocable permission to use spiders to copy materials from the Service for the sole purpose of and\n\n...\n\nCompany is not responsible for any Third-Party Services. When you use a Third-Party Service, you become subject to the terms and conditions (including privacy policies) of another website or destination."
      ],
      "full_content": null
    },
    {
      "url": "https://parse.bot/marketplace/f4504720-6673-4f4c-bca2-323669b31876/lmarena-ai-api",
      "title": "LMArena API – AI Model Leaderboards · Parse",
      "publish_date": "2026-07-23",
      "excerpts": [
        "# LMArena API [lmarena.ai ↗](https://lmarena.ai)\nAccess LMArena.ai leaderboard rankings across text, code, vision, image, video, and search arenas. Get model ratings, votes, licenses, and capabilities via 13 endpoints.\nThis API takes change requests — ask its agent to add endpoints, fields, or filters .\nDeveloper Tools reviews ratings other\nMCP Subscribe\nEndpoint health\nverified 31m ago\nget_text_leaderboard\nlist_available_models\nsearch_leaderboard_models\nget_top_models_by_category\nget_leaderboard_overview\n+ 8 more endpoints\n13/13 passing latest check self-healing\nEndpoints\n13\nUpdated\n1mo ago\n\n## What is the LMArena API?\nThis API exposes 13 endpoints covering every leaderboard category on lmarena.ai — text, code, vision, image editing, text-to-image, text-to-video, image-to-video, and search — plus a full model catalog.\nThe `get_top_models_by_category` endpoint lets you query any arena by name and cap results with a `limit` parameter, while `list_available_models` returns per-model capability flags, organization, and cross-modality rank in a single call.\nGET get_leaderboard_overview GET get_text_leaderboard GET get_code_leaderboard GET get_vision_leaderboard GET get_text_to_image_leaderboard GET get_image_edit_leaderboard GET get_search_leaderboard GET get_text_to_video_leaderboard GET get_image_to_video_leaderboard GET get_top_models_by_category GET\n\n...\n\n## Typed, relational, agent-ready\nA generated client with real types, enums, and the links between objects — the structure a flat JSON response can't carry. Autocompletes in your editor and reads cleanly to coding agents.\n* Fully typed · autocompletes\n* Objects link to objects\n* Typed errors & pagination\nTyped Python client. Set up the SDK in your uv project, then pull this API’s typed client:\nCopy\n```\nuv add parse-sdk\nuv run parse init\nuv run parse add --marketplace lmarena-ai-api\n```\n`uv run parse add --marketplace` pulls a pinned snapshot of this canonical API — it won’t change underneath you. To customize it, subscribe and swap to your own copy.\nPrompt for your agent — hand this to Claude Code, Cursor, Codex…\nCopy\n```\n\"\"\"LMArena leaderboard exploration: compare models across categories.\"\"\"\nfrom parse_apis.lmarena_leaderboard_api import LMArena, Category, CategoryInvalid\n\nclient =  LMArena ()\n\n# Get top 5 text models by rating using the parametric endpoint\n```\n\n...\n\nGET get_leaderboard_overview Fetch the default leaderboard overview showing ranked models on the main leaderboard page. Returns the full entries array and metadata. Useful as a quick summary of top-performing models across the default category. 10credits / call\nFetch the default leaderboard overview showing ranked models on the main leaderboard page. Returns the full entries array and metadata. Useful as a quick summary of top-performing models across the default category.\nInput\nNo input parameters required.\nResponse\n\n...\n\n```\n          \"outputPricePerMillion\": null\n        }\n      ],\n      \"metadata\": {}\n    },\n    \"status\": \"success\"\n  }\n}\n```\nGET get_text_leaderboard Fetch the Text Arena leaderboard showing model rankings for text generation tasks. Returns entries and the full initialModels list of available models. 10credits / call\nGET get_code_leaderboard Fetch the Code Arena leaderboard showing model rankings for code generation tasks. Returns entries and available model list. 1credit / call\nGET get_vision_leaderboard Fetch the Vision Arena leaderboard showing model rankings for vision/multimodal tasks. 1credit / call\nGET get_text_to_image_leaderboard Fetch the Text-to-Image Arena leaderboard showing model rankings for image generation tasks. 1credit / call\nGET get_image_edit_leaderboard Fetch the Image Edit Arena leaderboard showing model rankings for image editing tasks. 1credit / call\nGET get_search_leaderboard Fetch the Search Arena leaderboard showing model rankings for search/retrieval tasks. 1credit / call\nGET get_text_to_video_leaderboard Fetch the Text-to-Video Arena leaderboard showing model rankings for video generation from text prompts. 1credit / call\nGET get_image_to_video_leaderboard Fetch the Image-to-Video Arena leaderboard showing model rankings for video generation from images. 1credit / call\nGET get_top_models_by_category Get the top N models from a specific category leaderboard, sorted by rank. Accepts any leaderboard category and a limit. The most flexible ranked-model endpoint — equivalent to fetching a category-specific leaderboard and slicing to the requested count. 1credit / call\nGET get_best_coding_models Get a combined summary of the best AI coding models from the Code Arena leaderboard alongside a snapshot of the top 10 models from the Text Arena leaderboard. Useful for comparing code-focused models to general text leaders. 1credit / call\nGET search_leaderboard_models Search for models in a leaderboard category by matching a query string against model display names and organization names (case-insensitive substring match). Returns all matching entries from the specified category. 1credit / call\nGET list_available_models List all models available for direct interaction on LMArena, including their capabilities (input/output modalities), organization, selectability status, and per-modality rank. This is the full model catalog independent of leaderboard rankings. 1credit / call\n\n...\n\n## About the LMArena API\n### Leaderboard Endpoints\nEach arena has a dedicated endpoint: `get_text_leaderboard` , `get_code_leaderboard` , `get_vision_leaderboard` , `get_text_to_image_leaderboard` , `get_image_edit_leaderboard` , `get_search_leaderboard` , `get_text_to_video_leaderboard` , and `get_image_to_video_leaderboard` .\n\n...\n\n### Flexible Querying\n`search_leaderboard_models` takes a required `query` and an optional `category` , performing a case-insensitive substring match against model display names and organization names — useful for tracking a specific provider's models across an arena without fetching the full leaderboard.\n\n...\n\n### Full Model Catalog\nThe LMArena API is a **managed, monitored endpoint** for lmarena.ai — not a raw scraper you maintain. Every endpoint is automatically health-checked on a schedule, and whenlmarena.ai changes and a check fails, the API is **automatically queued for repair and re-verified** .\n\n...\n\nThis isn't an officiallmarena.aiAPI — it's an independent, maintained REST wrapper over public data. Where the source has no official API (or only a limited one), Parse gives you a stable contract over a source that never promised one, and keeps it current. Need a new endpoint or field?\n\n...\n\nIt's built not to. Every endpoint is health-checked on a schedule with automated test probes. When the source site changes and a check fails, the API is automatically queued for repair and re-verified — that's the self-healing layer. Each API page shows when its endpoints were last verified.\nAnd because marketplace APIs are shared, any fix reaches everyone using it. Is this an official API from the source site? +\nNo — Parse APIs are independent, managed REST wrappers over publicly available data.\nThat is the point: where a site has no official API (or only a limited one), Parse gives you a maintained, monitored endpoint for that data and keeps it working as the site changes — so you get a stable contract over a source that never promised one. Can I fix or extend this API myself if I need a new endpoint or field?\n\n...\n\nErrors are machine-readable: a bad call returns a clean status with the list of available endpoints and a repair hint, so an agent (or you) can recover or trigger a fix instead of failing silently. Confirmed failures feed the automatic repair queue.\nCommon use cases\n\n...\n\nNo. lmarena.ai does not publish a documented public developer API or SDK. This Parse API is how developers access its leaderboard and model data programmatically. What does `list\\_available\\_models` return that the leaderboard endpoints don't? +\n\n...\n\nNot currently. The API returns the current state of each leaderboard — rank, rating, and vote counts as they stand now — without historical snapshots or time-series data. You can fork this API on Parse and revise it to add a scheduled polling endpoint that stores snapshots for trend analysis.\n\n...\n\nNot currently. The API covers aggregate leaderboard metrics (rank, rating, votes) and model metadata; individual battle transcripts or per-prompt results are not exposed. You can fork it on Parse and revise to add an endpoint targeting that detail if lmarena surfaces it.\n\n...\n\nTrack how leading models from OpenAI, Anthropic, Google DeepMind, and other providers perform on different difficulty levels with their release dates. openai.com API Access data from openai.com. mastra.ai API Discover and browse AI model providers and their available models from Mastra's comprehensive registry.\n\n...\n\nAsk the agent\nAPI Agent\nchanges ship in minutes · chats are private to you\nAsk me anything about the lmarena.ai API — or tell me what it's missing. I built it, and I can add endpoints, fields, and filters. I'll propose the change first; nothing happens until you approve it.\nwhat can this API do? add a filter to @get_leaderboard_overview how much does this cost / what are credits?\nYour chats are private to you — only you can see them, even on public APIs. Changes you ship are public on this API.\n​\ntype @ to mention an endpoint · Enter to send Send"
      ],
      "full_content": null
    },
    {
      "url": "https://github.com/jtostrings/LMarenaBridge/blob/master/README_EN.md",
      "title": "LMarenaBridge/README_EN.md at master · jtostrings/LMarenaBridge · GitHub",
      "publish_date": null,
      "excerpts": [
        "# 🤖 LMArena-API\nLMArena-API is a desktop application that allows you to use various top-tier large language models such as Claude, GPT-4, and Gemini in any AI client without a paid subscription. It uses reverse engineering to convert all models from the LMArena.ai platform into an OpenAI-compatible format, enabling API calls.\n\n...\n\n## ✨ Features\n- ✅ Cross-platform support (Windows / macOS)\n- ✅ Portable version, unzip and run, no installation required\n- ✅ Compatible with OpenAI API format\n- ✅ Built-in web client, no external dependencies\n- ✅ Supports multi-client load balancing\n- ✅ Modern dark theme interface\n- ✅ Real-time log viewing\n\n...\n\n## 🚀 30-Second Quick Start\n### Step 2: Start and Configure\n1. **Start App** → Run LMArena-API\n2. **Create Client** → Go to \"Web Client\" page → Click \"New Client\"\n3. **Verify Terms** → Send any message in the popped-up page\n4. **Start Service** → Go back to \"Service Control\" page → Click \"Start Service\"\n5.\n\n...\n\n### Step 3: Configure Your AI Client\nFill in the following in any OpenAI API compatible client:\n| Config Item | Value |\n| **API URL** | `http://127.0.0.1:61001` or `http://127.0.0.1:61001/v1` |\n| **API Key** | `123456` (Can be modified in \"Config Management\") |\n| **Model** | Select any model from \"Model Management\" |\n\n...\n\n## 📱 Mainstream Client Configuration Guide\n### Cherry Studio (AI Chat Client)\n1. Open Cherry Studio → Settings → Add new API provider\n2. Select \"OpenAI Compatible\"\n3. Fill in configuration info:\n  - **API URL:** `http://127.0.0.1:61001`\n  - **API Key:** `123456`\n4. Save and test connection\n!Cherry Studio Test\n\n...\n\n### Immersive Translate (Web/Document Translation)\n1. Install Immersive Translate browser extension\n2. Open extension settings → Translation Service → Select \"OpenAI\"\n3. Switch to \"Custom API\"\n4. Fill in configuration:\n- **API URL:** `http://127.0.0.1:61001/v1/chat/completions`\n- **API Key:** `123456`\n\n...\n\n## 💻 Developer API Guide\n### API Endpoints\n| Endpoint | Method | Description |\n| `/v1/chat/completions` | POST | OpenAI compatible chat interface |\n| `/v1/models` | GET | Get list of available models |\n\n...\n\n### Python Code Examples\n#### Non-Streaming Response (Wait for Complete Reply)\n```python\nimport requests\n\n# API Config\nurl = \"http://127.0.0.1:61001/v1/chat/completions\"\nAPI_KEY = \"123456\"\n\nheaders = {\n    \"Content-Type\": \"application/json\",\n    \"Authorization\": f\"Bearer {API_KEY}\"\n}\n\npayload = {\n    \"model\": \"claude-sonnet-4-20250514\",\n    \"messages\": [\n```\n\n...\n\n## ⚙️ App Function Description\n### Service Control\n- One-click start/stop API service\n- Real-time display of service running status and duration\n\n### Web Client Management\n- **New Client:** Create independent browser sessions\n- **Preview/Hide:** Real-time view of client page status\n- **Multi-client Support:** Creating multiple clients can improve concurrency\n> **📖 Detailed Config Guide:** For manual configuration of browser-side Tampermonkey scripts or enabling concurrency mode, please refer to Websocket-client.md documentation.\n\n...\n\n## ❓ FAQ\n### Usage Issues\n**Advanced Config:** To enable concurrency mode and configure multiple browser clients, please refer to the \"Advanced Features - Concurrency Mode\" section in Websocket-client.md.\n</details>\n<details>\n<summary><b>Encounter 429 Error (Too Many Requests)?</b></summary>\n429 error is because the LMArena platform has request frequency limits for each session. Solution:\n**Method 1 (Recommended):** Create a new session in the AI client and continue asking. The system will automatically assign the new session to a different client, bypassing the frequency limit.\n**Method 2:** Wait for 10-20 minutes, the limit will be lifted automatically.\n**Method 3:** Delete the corresponding web client and create a new one to bypass the frequency limit. For detailed steps, please refer to Websocket-client.md.\n</details>\n\n...\n\n**If using Websocket Client Mode:**\n- Manually complete human verification in the browser, refresh the page to restore usage.\n- If verification is triggered frequently, it is recommended to check usage frequency, or consider switching to Websocket Client Mode (Websocket Client can effectively reduce human verification trigger rate).\n**Long-term Solution:**\nIf you frequently encounter 403 errors, it is recommended to switch to **Websocket Client Mode**, which can effectively reduce the trigger rate of human verification. For detailed configuration, please refer to Websocket-client.md.\n</details>\n<details>\n<summary><b>How to solve 401 Error?</b></summary>\nStarting from March 2026, you must be logged in to call the interfaces under the direct mode of the arena platform. Therefore, you need to first log in with a Google account on the web page, and then use websocket as its client. For detailed configuration, please refer to the Websocket-client.md document.\n</details>\n\n...\n\n1. **Backup Auth Credentials:** Copy `.auth` and `.client_id` files from the software directory to a temporary desktop directory, then delete the existing software package and its associated directories\n2.\n\n...\n\n> **Note:** macOS users do not need to move auth files, just update the LMArena.js script if necessary.\n**WebSocket Client Update Script (Optional):**\nIf you are using WebSocket Client Mode, you also need to update the Tampermonkey script:\n1. Remove the old LMArena.js in Tampermonkey script manager\n2. Get the latest script from [script/LMArena.js](https://github.com/jtostrings/LMarenaBridge/blob/master/script/LMArena.js), add to script management page\n3. Completely restart the browser instance to apply script update\n</details>\n\n## 📚 Related Docs\n- Websocket-client.md - Browser Client Configuration Guide (Tampermonkey script installation, concurrency mode configuration, etc.)\n- UsageGuide.md - Usage Guide (Best practices, common issues, money-saving tips, etc.)"
      ],
      "full_content": null
    },
    {
      "url": "https://github.com/tawer-blog/lmarena-2api",
      "title": "GitHub - tawer-blog/lmarena-2api · GitHub",
      "publish_date": null,
      "excerpts": [
        "# tawer-blog/lmarena-2api\n- Page: GitHub repository\n- URL: https://github.com/tawer-blog/lmarena-2api\n- Stars: 30\n- Forks: 4\n- License: MIT license\n- Default branch: main\n- Created: 2025-08-01T05:48:38.000Z\n- Commits: 4\n\n## Top-level files\n- LICENSE\n- README.md\n- lmarena_injector.user.js\n- proxy_server.py\n- requirements.txt\n- start.sh\n- start_windows.bat\n\n# LMArena Reverse Proxy Server\n[Python](https://www.python.org/) [FastAPI](https://fastapi.tiangolo.com/) [License](https://github.com/zhongruichen/lmarena-proxy/blob/main/LICENSE) Platform\n一个功能强大的 LMArena 反向代理服务器，提供 OpenAI 兼容的 API 接口、实时监控面板、动态配置管理等企业级功能。\n\n...\n\n## ✨ 功能特性\n### 🚀 核心功能\n* **OpenAI API 兼容** ：完全兼容 OpenAI API 格式，支持流式和非流式响应，无缝接入现有应用。\n* **多模型支持** ：支持 LMArena 上的 100+ AI 模型，包括 Claude、GPT、Gemini、DeepSeek 等。\n* **智能请求管理** ：强大的断线重连、请求持久化和自动重试机制，从容应对 Cloudflare 验证和网络波动。\n* **实时监控面板** ：提供美观的 Web 界面，实时监控系统状态、请求日志、性能指标。\n\n...\n\n### 🛡️ 可靠性保障\n* **断线重连** ：浏览器与服务器之间的 WebSocket 连接拥有强大的自动重连机制。\n* **请求持久化** ：即使浏览器刷新或关闭，正在处理的 API 请求也不会丢失，会在重连后继续执行。\n* **完善的错误处理** ：对网络错误、Cloudflare 挑战、速率限制等问题有专门的处理逻辑。\n* **健康检查** ：内置详细的健康检查和评分系统，随时掌握服务状态。\n\n...\n\n## 🏗️ 系统架构\n* **Python 服务端** ( `proxy_server.py` ): 核心 FastAPI 服务器，负责处理 API 请求和与浏览器脚本的 WebSocket 通信。\n* **浏览器脚本** ( `lmarena_injector.user.js` ): 通过 Tampermonkey 注入到 LMArena 网站，作为服务器的“手臂”，执行实际的 AI 请求。\n* **监控面板** : 一个 Vue.js 单页应用，用于实时显示系统状态和性能指标。\n\n## 📦 安装要求\n* **Python 3.8+**\n* **支持的操作系统** : Windows, Linux, macOS\n* **浏览器** : 最新版的 Chrome / Edge / Firefox\n* **浏览器扩展** : [Tampermonkey](https://www.tampermonkey.net/)\n\n...\n\n## 🚀 快速开始\n### 3. 安装浏览器脚本 (Tampermonkey)\n这是最关键的一步。此脚本负责连接代理服务器并执行请求。\n**推荐方式 (自动更新):**\n1. 点击此链接进行安装: [**Install Script from GitHub**](https://raw.githubusercontent.com/zhongruichen/lmarena-proxy/main/lmarena_injector.user.js)\n2. Tampermonkey 会自动打开一个页面，显示脚本信息，点击 **“安装”** 按钮。\n**手动方式:**\n1. 安装 [Tampermonkey](https://www.tampermonkey.net/) 浏览器扩展。\n2. 打开项目中的 `lmarena_injector.user.js` 文件。\n3. 复制文件的 **全部** 内容。\n4. 点击 Tampermonkey 浏览器图标，选择 **“创建新脚本”** 。\n5. 将复制的内容粘贴到编辑器中，替换掉所有默认内容。\n6. 保存脚本 (Ctrl+S)。\n\n### 4. 启动服务器\n* **Windows 用户:** 直接双击运行 `start_windows.bat` 文件。\n* **Linux / macOS 用户:**\n  ```shell\n  # 首次运行需要给脚本添加执行权限\n  chmod +x start.sh\n  \n  # 启动脚本\n  ./start.sh\n  ```\n脚本会自动启动 Python 服务器，并尝试打开 LMArena 和监控面板页面。\n\n...\n\n### 6. 使用 API\n现在，你可以使用任何兼容 OpenAI 的客户端来调用 API。\n```python\nfrom openai import OpenAI\n\n# 如果你的服务器在另一台机器上，请修改 base_url\nclient = OpenAI(\n    base_url=\"http://localhost:9080/v1\",\n    api_key=\"***REDACTED***\" # api_key 可以是任意字符串\n)\n\ntry:\n    response = client.chat.completions.create(\n        model=\"claude-3-5-sonnet-20241022\", # 使用你需要的模型\n        messages=[{\"role\": \"user\", \"content\": \"Hello, what can you do?\"}],\n        stream=True\n    )\n\n    print(\"Response from model:\")\n    for chunk in response:\n        content = chunk.choices[0].delta.content\n        if content:\n            print(content, end=\"\", flush=True)\n    print()\n\nexcept Exception as e:\n    print(f\"An error occurred: {e}\")\n```\n\n...\n\n## ⚙️ 配置管理\n### 用户脚本配置 ( `lmarena_injector.user.js` )\n如果你在另一台电脑上运行代理服务器，你需要修改用户脚本的配置。\n1. 点击 Tampermonkey 图标，进入“管理面板”。\n2. 找到 `LMArena Proxy Injector` 脚本，点击编辑按钮。\n3. 修改顶部的 `CONFIG` 对象：\n  ```js\n  // --- CONFIGURATION ---\n  // 如果你的代理服务器不在本机运行，请修改此处的 IP 地址。\n  const CONFIG = {\n      SERVER_URL: \"ws://192.168.1.100:9080/ws\", // 修改为你的服务器IP\n  };\n  ```\n4. 保存脚本。"
      ],
      "full_content": null
    }
  ],
  "errors": [],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90123"
}
```

---

### 🤖 Assistant — 2026-09-13 19:36:16

Survey 2026. Server fetch hostile. No official chat API.

1. Official public API? No.
- lmarena.ai publish no documented developer API or SDK for chat. Parse FAQ: "No. lmarena.ai does not publish documented public developer API or SDK." https://parse.bot/marketplace/f4504720-6673-4f4c-bca2-323669b31876/lmarena-ai-api
- Official GitHub `github.com/lmarena` hold leaderboard method, catalog, research code only: `arena-rank`, `arena-catalog`, `search-arena`, `copilot-arena`. No chat endpoint, pricing. https://github.com/lmarena
- Only third-party leaderboard wrappers exist. Parse expose 13 endpoints over public leaderboard data, 1-10 credits/call, Free 200 credits/mo 5 req/min. Self-describe: "not official", "independent maintained REST wrapper". https://parse.bot/marketplace/f4504720-6673-4f4c-bca2-323669b31876/lmarena-ai-api
- `lmdeploy` not related. Inference toolkit, no lmarena bridge.

2. Reverse projects. All unofficial, break often.
- `zhongruichen/lmarena-proxy` origin, forks `tawer-blog/lmarena-2api`, `virtual-byte/LMArena-Api`: Tampermonkey injector inside real browser as arm + FastAPI proxy via local WebSocket, OpenAI-compatible streaming. Handles Cloudflare, reconnect, persistence. https://github.com/tawer-blog/lmarena-2api https://github.com/virtual-byte/LMArena-Api
- `jtostrings/LMarenaBridge`: Desktop app + browser WebSocket client (`script/LMArena.js` via Tampermonkey), local OpenAI server at `127.0.0.1:61001`, multi-client load balance. https://github.com/jtostrings/LMarenaBridge/blob/master/README_EN.md
- `l3nn0n009/lmarena`: Puppeteer stealth hidden Chrome + SSE interception, no DOM scrape lag. Express + Socket.io front. https://github.com/l3nn0n009/lmarena
- `BrunoRakotomalala62/Lmarena` riftrunner finder: Selenium Chrome poller, submit prompts + fingerprint anonymous models. Scraper pattern example. https://github.com/BrunoRakotomalala62/Lmarena

Mechanism one-line:
- Injector+WS: browser executes chat, local server relays OpenAI format.
- Bridge: same, plus multi-session rotate for 429.
- Puppeteer SSE: capture `/nextjs-api/stream/create-evaluation` network tokens direct.
- Selenium poll: loop prompt/vote, regex response.

3. Stack / protocol.
- Built on Next.js behind Cloudflare. Evidence: SSE path `/nextjs-api/stream/create-evaluation` named in code. https://github.com/l3nn0n009/lmarena
- `lmarena.ai/*` return `301 Moved Permanently cloudflare`. Search excerpts show Cloudflare challenge flow. Proxies document Cloudflare verification handling. https://github.com/tawer-blog/lmarena-2api
- Protocol: no public spec. Knowledge lives in injector scripts:chat create-evaluation call, SSE token stream, WebSocket bridge to local proxy. Writeups are READMEs/issues only, no formal doc.

4. ToS / anti-abuse. Server fetch violates.
- Terms: "access Services through programmatic or automated means or automatically query Services" prohibited. Also ban "scrape, extract, or download data, including AI Service names, identifiers, or versions". Search-engine exception only. https://lmarena.ai/terms-of-use
- Enforced: per-session 429, lift 10-20 min or rotate client. 403 human verification / Cloudflare challenge on high frequency. Login with Google required since March 2026 per Bridge FAQ. https://github.com/jtostrings/LMarenaBridge/blob/master/README_EN.md
- Posture: Cloudflare bot check + auth gate + session throttling + frequent DOM/endpoint churn. Server-side datacenter fetch likely blocked. All tools require real residential browser profile, manual challenge solve, persistent cookies.


---
