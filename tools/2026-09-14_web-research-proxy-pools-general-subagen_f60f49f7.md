# Web research proxy pools (@general subagent)

- **Session ID:** `ses_f60f49f77ffeDX2kl4DsAOvokS`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-14 16:31:58
- **Last activity:** 2026-09-14 16:33:13
- **Messages:** 8

---

### 🧑 User — 2026-09-14 16:31:58

Use web_search (and webfetch only where excerpts insufficient) to find the top Go libraries for SOCKS5 proxy pool validation + rotation (2024-2026). For each candidate report: repo URL, stars, last commit date, license, validation method (TCP dial? HTTPS echo? which echo endpoint?), rotation strategy, health tracking, mid-dial retry support, Go module path, notable deps. Cover at least: prox5 (yunginnanet), go-proxypool / ProxyPool variants, goproxy-based pools, jacklul/proxy-manager, free-proxy-list tooling with validation, any Cloudflare-worker or sidecar-based validators. Rank top 5 by maintenance + API fit for embedding in a Go gateway (library, not CLI). Under 1200 words, facts + URLs.

---

### 🤖 Assistant — 2026-09-14 16:32:04

Need web data. Firing searches now.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Find Go SOCKS5 proxy pool validation rotation libraries 2024-2026; search_queries=['Go SOCKS5 proxy pool validation library', 'yunginnanet prox5 Go SOCKS5 proxy',
--- output ---
{
  "search_id": "search_6e27fffa5623ae20731dae8514d47660",
  "results": [
    {
      "url": "https://github.com/yunginnanet/Prox5",
      "title": "GitHub - yunginnanet/prox5: SOCKS5/4/4a validating proxy ...",
      "publish_date": null,
      "excerpts": [
        "GitHub - yunginnanet/prox5: SOCKS5/4/4a validating proxy ...\nProx5 is a golang library for managing, validating, and utilizing a very large amount of arbitrary SOCKS proxies. Notably it features interface compatible dialer functions that dial out from different proxies for every connection, and a SOCKS5 server that utilizes those functions."
      ]
    },
    {
      "url": "https://github.com/yunginnanet/prox5",
      "title": "GitHub - yunginnanet/prox5: 🧮 SOCKS5/4/4a 🌾 validating proxy pool and upstream SOCKS5 server for 🤽 LOLXDsoRANDum connections 🎋 · GitHub",
      "publish_date": null,
      "excerpts": [
        "yunginnanet/prox5\n* Page: GitHub repository\n* URL: https://github.com/yunginnanet/prox5\n* Description: 🧮 SOCKS5/4/4a 🌾 validating proxy pool and upstream SOCKS5 server for 🤽 LOLXDsoRANDum connections 🎋  - yunginnanet/prox5\n* Stars: 81\n* Forks: 8\n* License: MIT license\n* Default branch: main\n* Created: 2021-09-13T14:59:24.000Z\n* Commits: 452\n* .github/\n* example/\n* internal/\n* logger/\n* .gitignore\n* LICENSE\n* README.md\n* conductor.go\n* daemons.go\n* debug.go\n* defs.go\n* dispense.go\n* getters.go\n* go.mod\n* go.sum\n* list_management.go\n* mr_worldwide.go\n* mystery_dialer.go\n* mystery_resolver.go\n* parse.go\n* parse_test.go\n* proto.go\n* proto_test.go\n* prox5_test.go\n* proxy.go\n* scale_util.go\n* setters.go\n* socks5_server.go\n* stats.go\n* validator_engine.go\nREADME.md\nProx5\nSOCKS5/4/4a validating proxy pool + SOCKS5 server\nAnimated Screenshot of Prox5 Example\nGoDoc Go Report Card IRC Test Status five\nimport git.tcp.direct/kayos/prox5\nProx5 is a golang library for managing, validating, and utilizing a very large amount of arbitrary SOCKS proxies.\nNotably it features interface compatible dialer functions that dial out from different proxies for every connection, and a SOCKS5 server that utilizes those functions.\nCaution\nUsing prox5 to proxy connections from certain offsec tools may cause denial of service. Please spazz out responsibly.\nAuto Scaler\nThe validation has an optional auto scale feature that allows for the automatic tuning of validation worker count as more proxies are dispensed. This feature is still new, but seems to work well. It can be enabled with [...].EnableAutoScaler() .\nPlease refer to the autoscale related items within the documentation for more info.\nRate Limiting\nUsing Rate5 , prox5 naturally reduces the frequency of proxies that fail to validate. It does this by reducing the frequency proxies are accepted into the validation pipeline the more they fail to verify or fail to successfully connect to an endpoint. This is not yet adjustable, but will be soon.\nSee the documentation for Rate5 , and the source code for this project (defs.go is a good place to start) for more info.\nAccessing Validated Proxies\n* Retrieve validated 4/4a/5 proxies as simple strings for generic use\n* Use one of the dialer functions with any golang code that calls for a net.Dialer\n* Spin up a SOCKS5 server that will then make rotating use of your validated proxies\nAdditional info\nThe Secret Sauce\n```\ngo func() {\n\tif err := p5.StartSOCKS5Server(\"127.0.0.1:42069\", \"\", \"\"); err != nil {\n\t\t"
      ]
    },
    {
      "url": "https://github.com/yukkcat/socks5-proxy",
      "title": "GitHub - yukkcat/socks5-proxy: Self-rotating SOCKS5 proxy pool with auto-failover, health checks, and web dashboard · GitHub",
      "publish_date": null,
      "excerpts": [
        "yukkcat/socks5-proxy\n* Page: GitHub repository\n* URL: https://github.com/yukkcat/socks5-proxy\n* Description: Self-rotating SOCKS5 proxy pool with auto-failover, health checks, and web dashboard - yukkcat/socks5-proxy\n* Stars: 193\n* Forks: 90\n* Default branch: main\n* Created: 2026-02-07T07:44:07.000Z\n* Commits: 5\nTop-level files\n* .gitattributes\n* .gitignore\n* Dockerfile\n* README.md\n* checker.go\n* config.go\n* go.mod\n* main.go\n* pool.go\n* railway.toml\n* scraper.go\n* server.go\n* status.go\nREADME.md\nsocks5-pool\nA self-rotating SOCKS5 proxy pool. Scrapes free SOCKS5 proxies, verifies Google connectivity, filters out CN/HK IPs, and exposes a local SOCKS5 endpoint that automatically rotates upstream proxies.\nimage\nFeatures\n* Scrapes proxy lists from configurable source (default: socks5-proxy.github.io )\n* Concurrent health checks with Google connectivity verification\n* Auto-filters China/Hong Kong proxies\n* IP auto-rotation every 3-6 minutes (random)\n* Pool refresh every 20 minutes (auto-refresh if pool is empty)\n* Auto-failover: switches proxy on connection failure (up to 3 retries)\n* Web dashboard with manual switch/refresh controls\n* Zero external dependencies (Go stdlib only)\nBuild\ngo build -o socks5-pool .\nCustom config\n├── main.go        # Entry point, refresh & rotation loops\n├── config.go      # CLI flag parsing\n├── server.go      # SOCKS5 protocol implementation\n├── pool.go        # Proxy pool management\n├── scraper.go     # Proxy list scraping\n├── checker.go     # Health checks & geo lookup\n├── status.go      # Web dashboard & API"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/netzilo/go-socks5",
      "title": "socks5 package - github.com/netzilo/go-socks5 - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/netzilo/go-socks5\n  Go\nsocks5\npackage module\nVersion: v1.0.3 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Jun 7, 2026 License: MIT Imports: 12 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\nRepository\ngithub.com/netzilo/go-socks5\nLinks\nREADME ¶\ngo-socks5\nGoDoc Go.Dev reference Action Status codecov Go Report Card License Tag\nProvides the socks5 package that implements a SOCKS5 . SOCKS (Secure Sockets) is used to route traffic between a client and server through an intermediate proxy layer. This can be used to bypass firewalls or NATs.\nFeature\nThe package has the following features:\n* Support socks5 server\n* Support TCP/UDP and IPv4/IPv6\n* Unit tests\n* \"No Auth\" mode\n* User/Password authentication optional user addr limit\n* Support for the CONNECT command\n* Support for the ASSOCIATE command\n* Rules to do granular filtering of commands\n* Custom DNS resolution\n* Custom goroutine pool\n* buffer pool design and optional custom buffer pool\n* Custom logger\nTODO\nThe package still needs the following:\n* Support for the BIND command\nInstallation\nUse go get.\ngo get github.com/things-go/go-socks5\nThen import the socks5 server package into your own code.\nimport \"github.com/things-go/go-socks5\"\nExample\nBelow is a simple example of usage, more see example\npackage main\nimport (\n\"log\"\n\"os\"\n```\n\"github.com/things-go/go-socks5\"\n```\n)\nfunc main() {\n// Create a SOCKS5 server\nserver := socks5.NewServer(\nsocks5.WithLogger(socks5.NewLogger(log.New(os.Stdout, \"socks5: \", log.LstdFlags))),\n)\n```\n// Create SOCKS5 proxy on localhost port 8000\nif err := server.ListenAndServe(\"tcp\", \":8000\"); err != nil {\n\tpanic(err)\n}\n```\n}\nReference\n* rfc1928\n* original armon's go-sock5 library\nLicense\nThis project is under MIT License. See the LICENSE file for the full license text.\nExpand ▾ Collapse ▴\nDocumentation ¶\nIndex ¶\ntype AddressRewriter interface {\nRewrite(ctx  [context](/context) . [Context](/context#Context) , request * [Request](#Request) ) ( [context](/context) . [Context](/context#Context) , * [statute](/github.com/things-go/go-socks5/statute) . [AddrSpec](/github.com/things-go/go-socks5/statute#AddrSpec) )\n}\nfunc WithBufferPool(bufferPool [bufferpool](/github.com/things-go/go-socks5/bufferpool) . [BufPool](/github.com/things-go/go-socks5/bufferpool#BufPool) ) [Option](#Option)\nWithBufferPool can be provided to implement custom buffer pool By default, buffer pool use size is 32k\nfunc Wit"
      ]
    },
    {
      "url": "https://112.cachefly.net/yukkcat/socks5-proxy",
      "title": "GitHub - yukkcat/socks5-proxy: Self-rotating SOCKS5 proxy pool with auto-failover, health checks, and web dashboard · GitHub",
      "publish_date": null,
      "excerpts": [
        "GET /api/status # Pool status JSON POST /api/refresh # Trigger pool refresh GET /api/switch # Switch to next proxy GET /api/switch?index=N # Switch to specific proxy\nDocker\ndocker build -t socks5-pool . docker run -p 1080:1080 -p 8080:8080 socks5-pool\nDeploy to Railway\nThe project includes railway.toml for one-click Railway deployment.\nProject Structure\n├── main.go # Entry point, refresh & rotation loops ├── config.go # CLI flag parsing ├── server.go # SOCKS5 protocol implementation ├── pool.go # Proxy pool management ├── scraper.go # Proxy list scraping ├── checker.go # Health checks & geo lookup ├── status.go # Web dashboard & API ├── Dockerfile # Multi-stage Docker build └── railway.toml # Railway deployment config\nAbout"
      ]
    },
    {
      "url": "https://go.googlesource.com/net/+/master/proxy/socks5.go",
      "title": "proxy/socks5.go - net - Git at Google",
      "publish_date": null,
      "excerpts": [
        "Google Git\nSign in\ngo / net / master / . / proxy / socks5.go\nblob: c91651f96db9264945ded8692569dc021dac08cf [ file ]\n* // Copyright 2011 The Go Authors. All rights reserved.\n* // Use of this source code is governed by a BSD-style\n* // license that can be found in the LICENSE file.\n* | package proxy\n* |\n* | import (\n* | \"context\"\n* | \"net\"\n* |\n* | \"golang.org/x/net/internal/socks\"\n* | )\n* |\n* | // SOCKS5 returns a Dialer that makes SOCKSv5 connections to the given\n* | // address with an optional username and password.\n* | // See RFC 1928 and RFC 1929.\n* | func SOCKS5(network, address string, auth *Auth, forward Dialer) (Dialer, error) {\n* | d := socks.NewDialer(network, address)\n* | if forward != nil {\n* | if f, ok := forward.(ContextDialer); ok {\n* | d.ProxyDial = func(ctx context.Context, network string, address string) (net.Conn, error) {\n* | return f.DialContext(ctx, network, address)\n* | }\n* | } else {\n* | d.ProxyDial = func(ctx context.Context, network string, address string) (net.Conn, error) {\n* | return dialContext(ctx, forward, network, address)\n* | }\n* | }\n* | }\n* | if auth != nil {\n* | up := socks.UsernamePassword{\n* | Username: auth.User,\n* | Password: auth.Password,\n* | }\n* | d.AuthMethods = []socks.AuthMethod{\n* | socks.AuthMethodNotRequired,\n* | socks.AuthMethodUsernamePassword,\n* | }\n* | d.Authenticate = up.Authenticate\n* | }\n* | return d, nil\n* | }\nPowered by Gitiles | Privacy | Terms txt json"
      ]
    },
    {
      "url": "https://toolhunter.cc/tools/proxygo",
      "title": "ProxyGo: Best Proxy Pools for Backend Developers in 2026",
      "publish_date": "2026-03-29",
      "excerpts": [
        "ProxyGo is an open-source proxy pool service built in Go by jonasen1988, aggregating HTTP and SOCKS5 proxies from public sources, validating them against endpoints like https://cursor.com/api/auth/me , and persisting valid ones in SQLite for rotation via a single HTTP proxy endpoint. It targets backend developers and web scrapers needing reliable proxy rotation without external paid services, with 79 GitHub stars as of October 2024. ProxyGo is one of the best Proxy Pools tools for backend developers and web scrapers handling high-volume requests.\nQuick Overview ToolHunter icon TOOL HUNTER Browse Trending Categories Bookmarks Submit Submit ProxyGo — Proxy Pools tool screenshot Proxy Pools\nProxyGo: Best Proxy Pools for Backend Developers in 2026\n6 min read · Updated at: 03/27/2026 - 14:40"
      ]
    },
    {
      "url": "https://github.com/galang-rs/socks5",
      "title": "GitHub - galang-rs/socks5: Modular SOCKS5 proxy server in Go - multi-auth, pluggable VPN backends (WireGuard/OpenVPN/Direct), custom userspace TCP/IP netstack, zero gVisor. · GitHub",
      "publish_date": null,
      "excerpts": [
        "Credential Authentication\nMultiple Passwords Per User — Same username can authenticate with different passwords\nVariadic Credential Setup — Flexible auth.Credential() functional builder\nConcurrent Safe — Thread-safe credential validation for high-throughput proxying 5 Log Levels — Disabled , Error , Warn , Info , Debug\nProduction Ready — Default Warn level silences verbose packet traces\nDebug Mode — LogLevelDebug enables full per-packet UDP relay tracing\nCustom Logger — Implement the Logger interface for custom log backends\nPer-Level Prefixes — [SOCKS5] , [SOCKS5:WARN] , [SOCKS5:ERR] , [SOCKS5:DBG]\n⚙️ Architecture\nFunctional Options Pattern — socks5.WithAddr() , socks5.WithAuth() , socks5.WithBackend() , socks5.WithLogLevel()\nModular Package Design — Separated auth"
      ]
    },
    {
      "url": "https://github.com/JackDrogon/socks5-go",
      "title": "GitHub - JackDrogon/socks5-go · GitHub",
      "publish_date": null,
      "excerpts": [
        "JackDrogon/socks5-go\n* Page: GitHub repository\n* URL: https://github.com/JackDrogon/socks5-go\n* Stars: 0\n* Forks: 0\n* Default branch: master\n* Created: 2025-08-01T13:07:36.000Z\n* Commits: 7\nTop-level files\n* socks5/\n* tests/\n* README.md\n* go.mod\n* main.go\nREADME.md\nGo SOCKS5 Proxy Server & Client\nA complete SOCKS5 proxy server and client implementation in Go following RFC 1928 specifications.\nQuick Start\nOr build manually\ngo build -o build/socks5-server bin/socks5-server.go\nBasic Usage (No Authentication)\nRun examples (requires server to be running)\nLibrary Usage\nBasic HTTP Client\npackage main\nimport (\n\"fmt\"\n\"io\"\n\"net/http\"\n\"time\"\n\"github.com/JackDrogon/socks5-go/socks5\"\n)\nfunc main() {\nconfig := &socks5.ClientConfig{\nServerAddr: \"localhost:1080\",\nTimeout:    30 * time.Second,\n}\nRun examples (requires server to be running)\n│   └── README.md           # Examples documentation\n├── socks5/                 # Core library\n│   ├── server.go           # Server implementation\n│   ├── client.go           # Client implementation\n│   ├── udp_client.go       # UDP client wrapper\nRun examples (requires server to be running)\n* Client : SOCKS5 proxy client with full RFC 1928 support\n* Connection Management : TCP and UDP connection handling through proxy\n* Authentication : Support for No Auth and Username/Password methods\n* Address Resolution : IPv4, IPv6, and domain name support\nBuild server manually\ngo build -o build/socks5-server bin/socks5-server.go"
      ]
    },
    {
      "url": "https://pkg.go.dev/tailscale.com/net/socks5",
      "title": "socks5 package - tailscale.com/net/socks5 - Go Packages",
      "publish_date": null,
      "excerpts": [
        "A complete introduction to building software with Go\n* Standard library\nReference documentation for Go's standard library\n* Release Notes\nLearn what's new in each Go release\n* API\nReference documentation for the pkg.go.dev API\n* Packages\n* Community submenu dropdown icon\n* Recorded Talks\nVideos from prior events\n* Meetups\n1. Discover Packages\n2. tailscale.com\n3. net\n4. socks5\n  Go\nsocks5\npackage\nVersion: v1.102.3 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Aug 19, 2026 License: BSD-3-Clause Imports: 12 Imported by: 20\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\n```\n // Username and Password, if set, are the credential clients must provide. \nUsername  [string](/builtin#string) \tPassword  [string](/builtin#string) }\n```\nServer is a SOCKS5 proxy server.\nfunc (*Server) Serve ¶\n* socks5.go\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:12

First batch done. Probing remaining candidates.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Go proxypool ProxyPool goproxy jacklul proxy-manager details; search_queries=['go-proxypool github Go proxy pool', 'jacklul proxy-manager github proxy', 'ela
--- output ---
{
  "search_id": "search_fb6c7f093b3fd938870e12c994956ba5",
  "results": [
    {
      "url": "https://github.com/elazarl/goproxy/blob/master/proxy.go",
      "title": "goproxy/proxy.go at master · elazarl/goproxy · GitHub",
      "publish_date": null,
      "excerpts": [
        "elazarl/goproxy — proxy.go\n* Page: GitHub code file\n* URL: https://github.com/elazarl/goproxy/blob/master/proxy.go\n* Repository: elazarl/goproxy\n* Path: proxy.go\n* Ref: master\n* Lines: 181\n  package goproxy\nimport (\n\"io\"\n\"log\"\n\"net\"\n\"net/http\"\n\"os\"\n```\n\"golang.org/x/net/http2\"\n```\n)"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/asdlokj1qpi23/proxypool@v0.7.25",
      "title": "proxypool command - github.com/asdlokj1qpi23/proxypool - Go Packages",
      "publish_date": null,
      "excerpts": [
        "A complete introduction to building software with Go\n* Standard library\nReference documentation for Go's standard library\n* Release Notes\nLearn what's new in each Go release\n* API\nReference documentation for the pkg.go.dev API\n* Packages\n* Community submenu dropdown icon\n* Recorded Talks\nVideos from prior events\n* Meetups\n1. Discover Packages\n2. github.com/asdlokj1qpi23/proxypool\n  Go\nproxypool\ncommand module\nVersion: v0.7.25 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Dec 22, 2023 License: GPL-3.0 Imports: 10 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/asdlokj1qpi23/proxypool\nLinks\n* Open Source Insights Logo Open Source Insights\n  Jump to ...\n* README\n* Change Log\n* v0.7.21\n* v0.7.20\n* v0.7.19\n* v0.7.18\n* Features\n* About Streaming Media\n* Run\n* Disclaimer\n* Documentation\n* Source Files\n* Directories\n  README\nREADME ¶\nChange Log\nv0.7.21\n* add vless support\nv0.7.20\nRun\ndocker run -d --restart=always \n--name=proxypool \n-p 12580:12580 \n-v /path/to/config:/config \nasdlokj1qpi23/proxypool \n-c /config/config.yaml\nDisclaimer\n* Path | Synopsis\n* api |\n* config |\n* internal |\n* app |\n* cache |\n* cloudflare |\n* cron |\n* database |\n* log |\n* pkg |\n* geoIp |\n* getter |\n* healthcheck |\n* healthcheck/stream |\n* provider |\n* proxy |\n* tool |\n* utils |\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/One-Piecs/proxypool@v1.1.51",
      "title": "proxypool command - github.com/One-Piecs/proxypool - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/One-Piecs/proxypool\n  Go\nproxypool\ncommand module\nVersion: v1.1.51 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Aug 23, 2026 License: GPL-3.0 Imports: 11 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/One-Piecs/proxypool\nLinks\n* Open Source Insights Logo Open Source Insights\n  Jump to ...\n* README\n* 支持\n* 安装\n  1. 使用Heroku\n  2. 使用fly.io\n  3. 从源码编译\n  4. 下载预编译程序\n  5. 使用docker\n* 使用\n* 修改配置文件\n* 启动程序\n* Clash配置文件\n* 本地检查节点可用性\n* 截图\n* 声明\n* Documentation\n* Source Files\n* Directories\n  README\nREADME ¶\nproxypool\n自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan、vless节点信息，聚合去重测试可用性后提供节点列表\nGithub Actions\n支持\n* 支持ss、ssr、vmess、trojan、vless多种类型\n* Telegram频道抓取\n* 订阅地址抓取解析\n* 公开互联网页面模糊抓取\n* 定时抓取自动更新\n* 通过配置文件设置抓取源\n* 自动检测节点可用性\n* 提供clash、surge配置文件\n* 提供ss、ssr、vmess、sip002订阅\n安装\n以下五选一。\n1. 使用Heroku\n注册fly.io需要绑定银行卡，支持银联借记卡。同时使用fly.io主要通过命令行工具flyctl，详情到 fly.io 官网了解。\n下载仓库源代码，修改 fly.toml 中的app与domain。在终端使用 flyctl deploy 部署即可。\n3. 从源码编译\n需要安装Golang\n$ go get -u -v github.com/Sansui233/proxypool\n运行\n$ go run main.go -c ./config/config.yaml\n编译\nmake\n4. 下载预编译程序\n从这里下载预编译好的程序 release 。\n5. 使用docker\ndocker pull ghcr.io/sansui233/proxypool:v0.6.0\n使用\n* Path | Synopsis\n* api |\n* config |\n* internal |\n* app |\n* cache |\n* cron |\n* database |\n* log |\n* pkg |\n* cdn |\n* geoIp |\n* getter |\n* healthcheck |\n* provider |\n* proxy |\n* tool |\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    },
    {
      "url": "https://github.com/elazarl/goproxy",
      "title": "GitHub - elazarl/goproxy: An HTTP proxy library for Go · GitHub",
      "publish_date": null,
      "excerpts": [
        "elazarl/goproxy\n* Page: GitHub repository\n* URL: https://github.com/elazarl/goproxy\n* Description: An HTTP proxy library for Go\n* Stars: 6,752\n* Forks: 1,219\n* Default branch: master\n* Created: 2012-03-22T22:05:00.000Z\n* Commits: 441\nTop-level files\n* .github/\n* certs/\n* examples/\n* ext/\n* internal/\n* regretable/\n* test_data/\n* transport/\n* .gitignore\n* .golangci.yml\n* LICENSE\n* README.md\n* actions.go\n* all.bash\n* ca.pem\n* certs.go\n* ctx.go\n* dispatcher.go\n* dispatcher_test.go\n* doc.go\n* go.mod\n* go.sum\n* http.go\n* http2.go\n* http2_test.go\n* https.go\n* https_head_test.go\n* key.pem\n* logger.go\n* proxy.go\n* proxy_test.go\n* responses.go\n* websocket.go\n* websocket_test.go\nStatus GoDoc Go Report BSD-3 License Pull Requests Awesome Go\nGoProxy is a library to create a customized HTTP/HTTPS proxy server using Go (aka Golang), with several configurable settings available. The target of this project is to offer an optimized proxy server, usable with reasonable amount of traffic, yet customizable and programmable .\nIf you have any trouble, suggestion, or if you find a bug, feel free to reach out by opening a GitHub issue . This is an open source project managed by volunteers, and we're happy to discuss anything that can improve it.\nA taste of GoProxy\nTo get a taste of goproxy , here you are a basic HTTP/HTTPS proxy that just forward data to the destination:\npackage main\nimport (\n\"log\"\n\"net/http\"\n```\n\"github.com/elazarl/goproxy\"\n```\n)\nfunc main() {\nproxy := goproxy.NewProxyHttpServer()\nproxy.Verbose = true\nlog.Fatal(http.ListenAndServe(\":8080\", proxy))\n}\nRequest handler\nLet's start\nimport \"github.com/elazarl/goproxy\"\nThere are some proxy usage examples in the examples folder, which cover the most common cases. Take a look at them and good luck!\nRequest & Response manipulation"
      ]
    },
    {
      "url": "https://github.com/elazarl/goproxy/blob/master/https.go",
      "title": "goproxy/https.go at master · elazarl/goproxy · GitHub",
      "publish_date": null,
      "excerpts": [
        "elazarl/goproxy — https.go\n* Page: GitHub code file\n* URL: https://github.com/elazarl/goproxy/blob/master/https.go\n* Repository: elazarl/goproxy\n* Path: https.go\n* Ref: master\n* Lines: 857\n  package goproxy\nimport (\n\"bufio\"\n\"bytes\"\n\"context\"\n\"crypto/tls\"\n\"errors\"\n\"fmt\"\n\"io\"\n\"net\"\n\"net/http\"\n\"net/url\"\n\"os\"\n\"slices\"\n\"strings\"\n\"sync\"\n\"sync/atomic\"\n\"time\"\n```\n\"github.com/elazarl/goproxy/internal/http1parser\"\n\"github.com/elazarl/goproxy/internal/signer\"\n\"golang.org/x/net/http2\"\n```\n)\nvar responseHeadTerminator = []byte(\"\\r\\n\\r\\n\")"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/8812488/proxypool/pkg/proxy",
      "title": "proxy package - github.com/8812488/proxypool/pkg/proxy - Go Packages",
      "publish_date": null,
      "excerpts": [
        "A complete introduction to building software with Go\n* Standard library\nReference documentation for Go's standard library\n* Release Notes\nLearn what's new in each Go release\n* API\nReference documentation for the pkg.go.dev API\n* Packages\n* Community submenu dropdown icon\n* Recorded Talks\nVideos from prior events\n* Meetups\n1. Discover Packages\n2. github.com/8812488/proxypool\n3. pkg\n4. proxy\n  Go\nproxy\npackage\nVersion: v0.0.0-...-e06b9d4 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: May 17, 2023 License: GPL-3.0 Imports: 21 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* unchecked Tagged version\nRepository\ngithub.com/8812488/proxypool\nLinks\n* (b) SetIP(ip)\n* (b) SetName(name)\n* (b) SetUseable(useable)\n* (b) TypeName()\n* type CountryEmoji\n* type GeoIP\n* NewGeoIP(geodb, flags)\n* (g) Find(ipORdomain)\n* type HTTPOptions\n* type Proxy\n* CleanBadProxies(proxies)\n* CleanBadProxiesWithGrpool(proxies)\n* type ProxyList\n* Deduplication(src)\n* (ps) Clone()\n* (ps) Deduplication()\n* (ps) Len()\n* (ps) Less(i, j)\n* (ps) NameAddCounrty()\n* (ps) NameAddIndex()\n* (ps) NameAddTG()\n* (ps) NameReIndex()\n* (ps) Sort()\n* (ps) Swap(i, j)\n* (ps) TypeLen(t)\n* type Shadowsocks\n* ParseSSLink(link)\n* SSR2SS(ssr)\n* (ss) Clone()\n* (ss) Identifier()\n* (ss) Link()\n* (ss) String()\n* (ss) ToClash()\n* (ss) ToSurge()\n* type ShadowsocksR\n* ParseSSRLink(link)\nView all Source files\n* base.go\n* check.go\n* convert.go\n* geoip.go\n* proxies.go\n* shadowsocks.go\n* shadowsocksr.go\n* trojan.go\n* vmess.go\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    },
    {
      "url": "https://112.cachefly.net/elazarl/goproxy",
      "title": "GitHub - elazarl/goproxy: An HTTP proxy library for Go · GitHub",
      "publish_date": null,
      "excerpts": [
        "To get a taste of goproxy , here you are a basic HTTP/HTTPS proxy that just forward data to the destination: package main\nimport ( \"log\" \"net/http\"\n\"github.com/elazarl/goproxy\"\n)\nfunc main () { proxy := goproxy . NewProxyHttpServer () proxy . Verbose = true log . Fatal ( http . ListenAndServe ( \":8080\" , proxy )) }\nRequest handler\nStatus GoDoc Go Report BSD-3 License Pull Requests Awesome Go GoProxy is a library to create a customized HTTP/HTTPS proxy server using Go (aka Golang), with several configurable settings available. The target of this project is to offer an optimized proxy server, usable with reasonable amount of traffic, yet customizable and programmable . The proxy itself is simply a net/http handler, so you can add multiple middlewares (panic recover, logging, compression, etc.) over it. It can be easily integrated with any other HTTP network library. In order to use goproxy, one should set their browser (or any other client) to use goproxy as an HTTP proxy. Here is how you do that in Chrome and in Firefox ."
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/elazarl/goproxy",
      "title": "goproxy package - github.com/elazarl/goproxy - Go Packages",
      "publish_date": null,
      "excerpts": [
        "Go\nSkip to Main Content\nA complete introduction to building software with Go\n* Standard library\nReference documentation for Go's standard library\n* Release Notes\nLearn what's new in each Go release\n* API\nReference documentation for the pkg.go.dev API\n* Packages\n* Community submenu dropdown icon\n* Recorded Talks\nVideos from prior events\n* Meetups\n1. Discover Packages\n2. github.com/elazarl/goproxy\n  Go\ngoproxy\npackage module\nVersion: v1.9.0 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Aug 6, 2026 License: BSD-3-Clause Imports: 22 Imported by: 2,140\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/elazarl/goproxy\nLinks\nStatus GoDoc Go Report BSD-3 License Pull Requests Awesome Go\nGoProxy is a library to create a customized HTTP/HTTPS proxy server using Go (aka Golang), with several configurable settings available. The target of this project is to offer an optimized proxy server, usable with reasonable amount of traffic, yet customizable and programmable .\nIf you have any trouble, suggestion, or if you find a bug, feel free to reach out by opening a GitHub issue . This is an open source project managed by volunteers, and we're happy to discuss anything that can improve it.\nA taste of GoProxy\nTo get a taste of goproxy , here you are a basic HTTP/HTTPS proxy that just forward data to the destination:\npackage main\nimport (\n\"log\"\n\"net/http\"\n```\n\"github.com/elazarl/goproxy\"\n```\n)\nfunc main() {\nproxy := goproxy.NewProxyHttpServer()\nproxy.Verbose = true\nlog.Fatal(http.ListenAndServe(\":8080\", proxy))\n}\nRequest handler\nLet's start\nimport \"github.com/elazarl/goproxy\"\nThere are some proxy usage examples in the examples folder, which cover the most common cases. Take a look at them and good luck!\nRequest & Response manipulation\nAll requests to your web servers should be directed through the proxy, when the proxy will detect html pieces sent as a response to AJAX request, it'll send a warning email.\n3. https://github.com/elazarl/goproxy/blob/master/examples/goproxy-httpdump/\nGenerate a real traffic to your website by real users using through proxy.\nRecord the traffic, and try it again for more real load testing.\n4. https://github.com/elazarl/goproxy/tree/master/examples/goproxy-no-reddit-at-worktime\nWill allow browsing to reddit.com between 8:00am and 17:00pm\n5. https://github.com/elazarl/goproxy/tree/master/examples/goproxy-jquery-version\n* actions.go\n* certs.go\n* ctx.go\n* dispatcher.go\n* doc.go\n* http.go\n* http2.go\n* https.go\n* logger.go\n* proxy.go\n* responses.go\n* websocket.go\nDirectori"
      ]
    },
    {
      "url": "https://releasealert.dev/github/elazarl/goproxy",
      "title": "Releases · elazarl/goproxy - GitHub | Release Alert",
      "publish_date": null,
      "excerpts": [
        "Skip to content release alert Search / CtrlK Sign in elazarl/goproxy\nelazarl/goproxy\nGitHub GitHub GitHub github.com Releases 31 Frequency 4 months 3 weeks Last Release 28 minutes ago Friday, 4 September 2026, 16:26 Stars 6.75K An HTTP proxy library for Go | v1.7.2 | Feb 24, 2025 Monday, 24 February 2025, 16:34 | Stable\n| v1.7.1 | Feb 22, 2025 Saturday, 22 February 2025, 17:23 | Stable\n| v1.7.0 | Jan 26, 2025 Sunday, 26 January 2025, 07:17 | Stable\n| v1.6.1 | Jan 24, 2025 Friday, 24 January 2025, 20:32 | Stable\n| v1.6.0 | Jan 21, 2025 Tuesday, 21 January 2025, 10:26 | Stable\n| v1.5.0 | Jan 16, 2025 Thursday, 16 January 2025, 21:26 | Stable\n| v1.4.0 | Jan 13, 2025 Monday, 13 January 2025, 13:09 | Stable\n| v1.4.0-beta.3 | Jan 12, 2025 Sunday, 12 January 2025, 23:27 | Beta\n| v1.4.0-beta.2"
      ]
    },
    {
      "url": "https://download.plaud.ai/elazarl/goproxy",
      "title": "GitHub - elazarl/goproxy: An HTTP proxy library for Go · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Name | Name | Last commit message | Last commit date\n* .github | .github |  |\n* certs | certs |  |\n* examples | examples |  |\n* ext | ext |  |\n* internal | internal |  |\n* regretable | regretable |  |\n* test_data | test_data |  |\n* transport | transport |  |\n* .gitignore | .gitignore |  |\n* .golangci.yml | .golangci.yml |  |\n* LICENSE | LICENSE |  |\n* README.md | README.md |  |\n* actions.go | actions.go |  |\n* all.bash | all.bash |  |\n* ca.pem | ca.pem |  |\n* certs.go | certs.go |  |\n* ctx.go | ctx.go |  |\n* dispatcher.go | dispatcher.go |  |\n* dispatcher_test.go | dispatcher_test.go |  |\n* doc.go | doc.go |  |\n* go.mod | go.mod |  |\n* go.sum | go.sum |  |\n* http.go | http.go |  |\n* http2.go | http2.go |  |\n* http2_test.go | http2_test.go |  |\n* https.go | https.go |  |\n* https_head_test.go | https_head_test.go |  |\n* key.pem | key.pem |  |\n* logger.go | logger.go |  |\n* proxy.go | proxy.go |  |\n* proxy_test.go | proxy_test.go |  |\n* responses.go | responses.go |  |\n* websocket.go | websocket.go |  |\n* websocket_test.go | websocket_test.go |  |\n* View all files\nStatus GoDoc Go Report BSD-3 License Pull Requests Awesome Go\nGoProxy is a library to create a customized HTTP/HTTPS proxy server using Go (aka Golang), with several configurable settings available. The target of this project is to offer an optimized proxy server, usable with reasonable amount of traffic, yet customizable and programmable .\nIf you have any trouble, suggestion, or if you find a bug, feel free to reach out by opening a GitHub issue . This is an open source project managed by volunteers, and we're happy to discuss anything that can improve it.\nThe codebase uses an automatic lint check over your Pull Request code. Before opening it, you should check if your changes respect it, by running the linter in your local machine, so you won't have any surprise.\nTo install the linter:\ngo install github.com/golangci/golangci-lint/cmd/golangci-lint@latest\nA taste of GoProxy\nTo get a taste of goproxy , here you are a basic HTTP/HTTPS proxy that just forward data to the destination:\npackage main\nimport (\n\"log\"\n\"net/http\"\n```\n\"github.com/elazarl/goproxy\" \n```\n)\nfunc main () {\nproxy := goproxy . NewProxyHttpServer ()\nproxy . Verbose = true\nlog . Fatal ( http . ListenAndServe ( \":8080\" , proxy ))\n}\nLet's start\nimport \"github.com/elazarl/goproxy\"\nThere are some proxy usage examples in the examples folder, which cover the most common cases. Take a look at them and good luck!\nRequest & Response manipulation\nStripe Dependabot Go Git Google Grafana Fly.io Kubernetes / Minikube New Relic\nAbout\nAn HTTP proxy library for Go\nResources\nReadme\nLicense\nActivity\nStars\n6.8k stars\nWatchers\n148 watching\nForks\n1.2k forks\nReport repository\nReleases\nSponsor this project\nPackages\nUsed by\nContributors\nLanguages\nFooter\n© 2026 GitHub, Inc.\nFooter navigation"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:20

Second batch done. Fetching specifics on last candidates.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=jacklul proxy-manager prox5 validation method last commit license; search_queries=['jacklul proxy-manager proxy validator socks5', 'jonasen1988 ProxyGo github pro
--- output ---
{
  "search_id": "search_11b2914fbe10ae732890673d3dd7ea47",
  "results": [
    {
      "url": "https://github.com/things-go/go-socks5",
      "title": "GitHub - things-go/go-socks5: socks5 server in pure Golang with much custom optional. Full TCP/UDP and IPv4/IPv6 support. · GitHub",
      "publish_date": null,
      "excerpts": [
        "things-go/go-socks5\n* Page: GitHub repository\n* URL: https://github.com/things-go/go-socks5\n* Description: socks5 server in pure Golang with much custom optional. Full TCP/UDP and IPv4/IPv6 support.  - things-go/go-socks5\n* Stars: 612\n* Forks: 102\n* License: MIT license\n* Default branch: master\n* Created: 2020-04-19T06:05:29.000Z\n* Commits: 285\n* .github/\n* _example/\n* bufferpool/\n* statute/\n* .gitignore\n* .goreleaser.yaml\n* AGENTS.md\n* LICENSE\n* README.md\n* auth.go\n* auth_test.go\n* credentials.go\n* credentials_test.go\n* go.mod\n* go.sum\n* handle.go\n* handle_test.go\n* logger.go\n* option.go\n* resolver.go\n* resolver_test.go\n* ruleset.go\n* ruleset_test.go\n* server.go\n* server_test.go\nREADME.md\ngo-socks5\nGoDoc Go.Dev reference Action Status codecov Go Report Card License Tag\nProvides the socks5 package that implements a SOCKS5 . SOCKS (Secure Sockets) is used to route traffic between a client and server through an intermediate proxy layer. This can be used to bypass firewalls or NATs.\nFeature\nTODO\nThe package still needs the following:\n* Support for the BIND command\nInstallation\nUse go get.\ngo get github.com/things-go/go-socks5\nThen import the socks5 server package into your own code.\nimport \"github.com/things-go/go-socks5\"\nExample\nBelow is a simple example of usage, more see example\npackage main\nimport (\n\"log\"\n\"os\"\n```\n\"github.com/things-go/go-socks5\"\n```\n)\nfunc main() {\n// Create a SOCKS5 server\nserver := socks5.NewServer(\nsocks5.WithLogger(socks5.NewLogger(log.New(os.Stdout, \"socks5: \", log.LstdFlags))),\n)\n```\n// Create SOCKS5 proxy on localhost port 8000\nif err := server.ListenAndServe(\"tcp\", \":8000\"); err != nil {\n\tpanic(err)\n}\n```\n}\nReference\n* rfc1928\n* original armon's go-sock5 library\nLicense\nThis project is under MIT License. See the LICENSE file for the full license text."
      ]
    },
    {
      "url": "https://go.googlesource.com/net/+/master/proxy/socks5.go",
      "title": "proxy/socks5.go - net - Git at Google",
      "publish_date": null,
      "excerpts": [
        "Google Git\nSign in\ngo / net / master / . / proxy / socks5.go\nblob: c91651f96db9264945ded8692569dc021dac08cf [ file ]\n* // Copyright 2011 The Go Authors. All rights reserved.\n* // Use of this source code is governed by a BSD-style\n* // license that can be found in the LICENSE file.\n* | package proxy\n* |\n* | import (\n* | \"context\"\n* | \"net\"\n* |\n* | \"golang.org/x/net/internal/socks\"\n* | )\n* |\n* | // SOCKS5 returns a Dialer that makes SOCKSv5 connections to the given\n* | // address with an optional username and password.\n* | // See RFC 1928 and RFC 1929.\n* | func SOCKS5(network, address string, auth *Auth, forward Dialer) (Dialer, error) {\n* | d := socks.NewDialer(network, address)\n* | if forward != nil {\n* | if f, ok := forward.(ContextDialer); ok {\n* | d.ProxyDial = func(ctx context.Context, network string, address string) (net.Conn, error) {\n* | return f.DialContext(ctx, network, address)\n* | }\n* | } else {\n* | d.ProxyDial = func(ctx context.Context, network string, address string) (net.Conn, error) {\n* | return dialContext(ctx, forward, network, address)\n* | }\n* | }\n* | }\n* | if auth != nil {\n* | up := socks.UsernamePassword{\n* | Username: auth.User,\n* | Password: auth.Password,\n* | }\n* | d.AuthMethods = []socks.AuthMethod{\n* | socks.AuthMethodNotRequired,\n* | socks.AuthMethodUsernamePassword,\n* | }\n* | d.Authenticate = up.Authenticate\n* | }\n* | return d, nil\n* | }\nPowered by Gitiles | Privacy | Terms txt json"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/things-go/go-socks5@v0.0.4",
      "title": "socks5 package - github.com/things-go/go-socks5 - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/things-go/go-socks5\n  Go\nsocks5\npackage module\nVersion: v0.0.4 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Sep 11, 2023 License: MIT Imports: 11 Imported by: 107\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/things-go/go-socks5\nLinks\n* WithGPool(pool)\n* WithLogger(l)\n* WithResolver(res)\n* WithRewriter(rew)\n* WithRule(rule)\n* type PermitCommand\n* (p) Allow(ctx, req)\n* type Request\n* ParseRequest(bufConn)\n* type RuleSet\n* NewPermitAll()\n* NewPermitConnAndAss()\n* NewPermitNone()\n* type Server\n* NewServer(opts)\n* (sf) ListenAndServe(network, addr)\n* (sf) Proxy(dst, src)\nREADME ¶\ngo-socks5\nGoDoc Go.Dev reference Action Status codecov Go Report Card License Tag\nProvides the socks5 package that implements a SOCKS5 . SOCKS (Secure Sockets) is used to route traffic between a client and server through an intermediate proxy layer. This can be used to bypass firewalls or NATs.\nFeature\n* Support socks5 server\n* Support TCP/UDP and IPv4/IPv6\n* Unit tests\n* \"No Auth\" mode\n* User/Password authentication optional user addr limit\n* Support for the CONNECT command\n* Support for the ASSOCIATE command\n* Rules to do granular filtering of commands\n* Custom DNS resolution\n* Custom goroutine pool\nTODO\nThe package still needs the following:\n* Support for the BIND command\nInstallation\nUse go get.\ngo get github.com/things-go/go-socks5\nThen import the socks5 server package into your own code.\nimport \"github.com/things-go/go-socks5\"\nExample\nBelow is a simple example of usage, more see example\npackage main\nimport (\n\"log\"\n\"os\"\n```\n\"github.com/things-go/go-socks5\"\n```\n)\nfunc main() {\n// Create a SOCKS5 server\nserver := socks5.NewServer(\nsocks5.WithLogger(socks5.NewLogger(log.New(os.Stdout, \"socks5: \", log.LstdFlags))),\n)\n```\n// Create SOCKS5 proxy on localhost port 8000\nif err := server.ListenAndServe(\"tcp\", \":8000\"); err != nil {\n\tpanic(err)\n}\n```\n}\nReference\nfunc WithBufferPool(bufferPool [bufferpool](/github.com/things-go/go-socks5@v0.0.4/bufferpool) . [BufPool](/github.com/things-go/go-socks5@v0.0.4/bufferpool#"
      ]
    },
    {
      "url": "https://toolhunter.cc/tools/proxygo",
      "title": "ProxyGo: Best Proxy Pools for Backend Developers in 2026",
      "publish_date": "2026-03-29",
      "excerpts": [
        "ProxyGo is an open-source proxy pool service built in Go by jonasen1988, aggregating HTTP and SOCKS5 proxies from public sources, validating them against endpoints like https://cursor.com/api/auth/me , and persisting valid ones in SQLite for rotation via a single HTTP proxy endpoint. It targets backend developers and web scrapers needing reliable proxy rotation without external paid services, with 79 GitHub stars as of October 2024. ProxyGo is one of the best Proxy Pools tools for backend developers and web scrapers handling high-volume requests.\nQuick Overview ToolHunter icon TOOL HUNTER Browse Trending Categories Bookmarks Submit Submit ProxyGo — Proxy Pools tool screenshot Proxy Pools\nProxyGo: Best Proxy Pools for Backend Developers in 2026\n6 min read · Updated at: 03/27/2026 - 14:40"
      ]
    },
    {
      "url": "https://github.com/things-go/go-socks5/blob/master/README.md",
      "title": "go-socks5/README.md at master · things-go/go-socks5 · GitHub",
      "publish_date": null,
      "excerpts": [
        "go-socks5/README.md at master · things-go/go-socks5 · GitHub\nProvides the socks5 package that implements a SOCKS5. SOCKS (Secure Sockets) is used to route traffic between a client and server through an intermediate proxy layer. Section:  > \ngo-socks5/README.md at master · things-go/go-socks5 · GitHub\ngo-socks5 Provides the socks5 package that implements a SOCKS5. SOCKS (Secure Sockets) is used to route traffic between a client and server through an intermediate proxy layer. This can be used to bypass firewalls or NATs"
      ]
    },
    {
      "url": "https://github.com/JackDrogon/socks5-go",
      "title": "GitHub - JackDrogon/socks5-go · GitHub",
      "publish_date": null,
      "excerpts": [
        "JackDrogon/socks5-go\n* Page: GitHub repository\n* URL: https://github.com/JackDrogon/socks5-go\n* Stars: 0\n* Forks: 0\n* Default branch: master\n* Created: 2025-08-01T13:07:36.000Z\n* Commits: 7\nTop-level files\n* socks5/\n* tests/\n* README.md\n* go.mod\n* main.go\nREADME.md\nGo SOCKS5 Proxy Server & Client\nA complete SOCKS5 proxy server and client implementation in Go following RFC 1928 specifications.\nQuick Start\nOr build manually\ngo build -o build/socks5-server bin/socks5-server.go\nBasic Usage (No Authentication)\nRun examples (requires server to be running)\nLibrary Usage\nBasic HTTP Client\npackage main\nimport (\n\"fmt\"\n\"io\"\n\"net/http\"\n\"time\"\n\"github.com/JackDrogon/socks5-go/socks5\"\n)\nfunc main() {\nconfig := &socks5.ClientConfig{\nServerAddr: \"localhost:1080\",\nTimeout:    30 * time.Second,\n}\nRun examples (requires server to be running)\nsocks5-go/\n├── bin/                     # Server executables\n│   └── socks5-server.go    # SOCKS5 server main\n├── build/                   # Build output (created by Makefile)\n│   ├── socks5-server       # Server binary\n│   └── examples/           # Client example binaries\nRun examples (requires server to be running)\n│   └── README.md           # Examples documentation\n├── socks5/                 # Core library\n│   ├── server.go           # Server implementation\n│   ├── client.go           # Client implementation\n│   ├── udp_client.go       # UDP client wrapper\nRun examples (requires server to be running)\n* Client : SOCKS5 proxy client with full RFC 1928 support\n* Connection Management : TCP and UDP connection handling through proxy\n* Authentication : Support for No Auth and Username/Password methods\n* Address Resolution : IPv4, IPv6, and domain name support"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy/socks5",
      "title": "socks5 package - github.com/e1732a364fed/v2ray_simple/proxy/socks5 - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/e1732a364fed/v2ray_simple\n3. proxy\n4. socks5\n  Go\nsocks5\npackage\nVersion: v1.2.4-beta.5 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Nov 1, 2022 License: MIT Imports: 11 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nDocumentation ¶\nOverview ¶\n* Reference\n* Off Topic\n  Package socks5 provies socks5 proxy for proxy.Client and proxy.Server.\n  Supports USER/PASSWORD authentication.\nReference ¶\n* func (ClientCreator) NewClient(dc *proxy.DialConf) (proxy.Client, error)\n* func (ClientCreator) URLToDialConf(u *url.URL, dc *proxy.DialConf, format int) (*proxy.DialConf, error)\n* type ClientUDPConn\n* func (cpc *ClientUDPConn) Associate() (err error)\n* func (cpc *ClientUDPConn) CloseConnWithRaddr(raddr netLayer.Addr) error\n* func (*Server) Name() string\n* type ServerCreator\n* func (ServerCreator) NewServer(lc *proxy.ListenConf) (proxy.Server, error)\n* func (ServerCreator) URLToListenConf(u *url.URL, lc *proxy.ListenConf, format int) (*proxy.ListenConf, error)\n* type ServerUDPConn\n* func (u *ServerUDPConn) CloseConnWithRaddr(raddr netLayer.Addr) error\nconst Name = \"socks5\"\nView Source\nconst Version5 = 0x05\nsocks5 version number.\nfunc ( [ClientCreator](#ClientCreator) ) NewClient(dc * [proxy](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy) . [DialConf](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy#DialConf) ) ( [proxy](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy) .\ntype Server struct {\n[proxy](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy) . [Base](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy#Base) \t* [utils](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/utils) . [MultiUserMap](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/utils#MultiUserMap)\nfunc ( [ServerCreator](#ServerCreator) ) NewServer(lc * [proxy](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy) . [ListenConf](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy#ListenConf) ) ( [proxy](/github.com/e1732a364fed/v2ray_simple@v1.2.4-beta.5/proxy) .\n[Server](/gith"
      ]
    },
    {
      "url": "https://libraries.io/go/github.com/JC5LZiy3HVfV5ux/socks5",
      "title": "github.com/JC5LZiy3HVfV5ux/socks5 v0.9.3-0.20250411160403 ...",
      "publish_date": null,
      "excerpts": [
        "github.com/JC5LZiy3HVfV5ux/socks5 v0.9.3-0.20250411160403 ...\nA fully featured implementation of the SOCKS 5 protocol in golang. Command CONNECT , BIND 🛠, UDP ASSOCIATE . - v0.9.3-0.20250411160403-e67301fb38d1 - a Go"
      ]
    },
    {
      "url": "https://download.plaud.ai/genevieve/go-socks5",
      "title": "GitHub - genevieve/go-socks5: SOCKS5 server in Golang · GitHub",
      "publish_date": null,
      "excerpts": [
        "// Create SOCKS5 proxy on localhost port 8000 if err := server . ListenAndServe ( \"tcp\" , \"127.0.0.1:8000\" ); err != nil { panic ( err ) }\nAbout\nSOCKS5 server in Golang\nResources\nReadme MIT license Activity\nStars\n1 star\nWatchers\n1 watching\nForks\n3 forks Report repository\nReleases\nPackages\nContributors\nLanguages\nFooter\n© 2026 GitHub, Inc.\nFooter navigation\nTerms\nPrivacy\nSecurity\nStatus\nCommunity\nDocs\nContact\nManage cookies\nDo not share my personal information"
      ]
    },
    {
      "url": "https://github.com/AI-QL/go-socks5-proxy",
      "title": "GitHub - AI-QL/go-socks5-proxy: Socks5 Proxy Server in Golang · GitHub",
      "publish_date": null,
      "excerpts": [
        "AI-QL/go-socks5-proxy\nPage: GitHub repository\nURL: https://github.com/AI-QL/go-socks5-proxy\nDescription: Socks5 Proxy Server in Golang\nStars: 1\nForks: 0\nTopics: docker, golang, socks5-proxy-server\nLicense: Apache-2.0 license\nDefault branch: main\nCreated: 2024-11-01T06:08:37.000Z\nCommits: 3\nTop-level files\n.github/workflows/\n.gitignore\nDockerfile\nLICENSE\nREADME.md\ndocker-compose.build.yml\ngo-socks5-proxy\ngo.mod\ngo.sum\nruleset.go\nserver.go\nREADME.md\nGo Socks5 Proxy\nSocks5 Proxy Server in Golang\nExamples"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:26

Core pool data gathered. Fetching repo specifics for ranking.

**tool:parallel-search_web_fetch** (completed) 

```
allow_live_fetch=True; model_name=opencode/muse-spark-1.3-contributor-free; objective=Get stars last commit license validation rotation health retry module deps for G
--- output ---
{
  "extract_id": "extract_49044576abf01b9fc179e6fa18d94c68",
  "results": [
    {
      "url": "https://github.com/yunginnanet/Prox5",
      "title": "GitHub - yunginnanet/prox5: 🧮 SOCKS5/4/4a 🌾 validating proxy pool and upstream SOCKS5 server for 🤽 LOLXDsoRANDum connections 🎋",
      "publish_date": null,
      "excerpts": [
        "GitHub - yunginnanet/prox5: 🧮🧮 SOCKS5/4/4a 🌾🌾 validating proxy pool and upstream SOCKS5 server for 🤽🤽 LOLXDsoRANDum connections 🎋🎋\nSkip to content\n\n...\n\n# Saved searches\n## Use saved searches to filter your results more quickly\n🧮🧮 SOCKS5/4/4a 🌾🌾 validating proxy pool and upstream SOCKS5 server for 🤽🤽 LOLXDsoRANDum connections 🎋🎋\n[git.tcp.direct/kayos/prox5](https://git.tcp.direct/kayos/prox5 \"https://git.tcp.direct/kayos/prox5\")\n\n### License\nMIT license\n79 stars 8 forks Branches Tags Activity\n[Star](https://github.com/login?return_to=%2Fyunginnanet%2Fprox5)\n[Notifications](https://github.com/login?return_to=%2Fyunginnanet%2Fprox5) You must be signed in to change notification settings\n\n...\n\n# yunginnanet/prox5\n## Folders and files\n| Name |  | Name | Last commit message | Last commit date |\n| ## Latest commit |  |  |  |  |\n\n## History\n[452 Commits](https://github.com/yunginnanet/prox5/commits/main/)\n|  |  |  |  |\n| .github |  | .github |  |  |\n| example |  | example |  |  |\n| internal |  | internal |  |  |\n| logger |  | logger |  |  |\n| .gitignore |  | .gitignore |  |  |\n| LICENSE |  | LICENSE |  |  |\n| README.md |  | README.md |  |  |\n| conductor.go |  | conductor.go |  |  |\n| daemons.go |  | daemons.go |  |  |\n| debug.go |  | debug.go |  |  |\n| defs.go |  | defs.go |  |  |\n| dispense.go |  | dispense.go |  |  |\n| getters.go |  | getters.go |  |  |\n| go.mod |  | go.mod |  |  |\n| go.sum |  | go.sum |  |  |\n| list_management.go |  | list_management.go |  |  |\n| mr_worldwide.go |  | mr_worldwide.go |  |  |\n| mystery_dialer.go |  | mystery_dialer.go |  |  |\n| mystery_resolver.go |  | mystery_resolver.go |  |  |\n| parse.go |  | parse.go |  |  |\n| parse_test.go |  | parse_test.go |  |  |\n| proto.go |  | proto.go |  |  |\n| proto_test.go |  | proto_test.go |  |  |\n| prox5_test.go |  | prox5_test.go |  |  |\n| proxy.go |  | proxy.go |  |  |\n| scale_util.go |  | scale_util.go |  |  |\n| setters.go |  | setters.go |  |  |\n| socks5_server.go |  | socks5_server.go |  |  |\n| stats.go |  | stats.go |  |  |\n| validator_engine.go |  | validator_engine.go |  |  |\n| View all files |  |  |  |  |\n\n## Repository files navigation\n* README\n* MIT license\n\n# Prox5\n## SOCKS5/4/4a validating proxy pool + SOCKS5 server\n[<img src='https://camo.githubusercontent.com/b0e2161253cd8b528708eccb7091bf729d51e31bd4743ec1c076c4373209b08a/68747470733a2f2f7463702e61632f692f335752667a2e676966' alt='Animated Screenshot of Prox5 Example' width='500' height='250'\n/>](https://camo.githubusercontent.com/b0e2161253cd8b528708eccb7091bf729d51e31bd4743ec1c076c4373209b08a/68747470733a2f2f7463702e61632f692f335752667a2e676966)\n[![GoDoc](https://camo.githubusercontent.com/10749fbcb7884e1a3adcd77ed5843166856e04bdca377049a93df42d83226a9d/68747470733a2f2f676f646f632e6f72672f6769742e7463702e6469726563742f6b61796f732f70726f78353f7374617475732e737667)](https://pkg.go.dev/git.tcp.direct/kayos/prox5) [![Go Report\nCard](https://camo.githubusercontent.com/2bb383be056c5426c09bdaeb914ad9b6d9bcae0c0270f1b0456929812b8c99ca/68747470733a2f2f676f7265706f7274636172642e636f6d2f62616467652f6769746875622e636f6d2f79756e67696e6e616e65742f70726f7835)](https://goreportcard.com/report/github.com/yunginnanet/prox5)\n\n...\n\nStatus](https://github.com/yunginnanet/prox5/actions/workflows/go.yml/badge.svg)](https://github.com/yunginnanet/prox5/actions/workflows/go.yml)\n\n...\n\ne91624f96625f6/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f66686a6f6e65732d35353535352d626c7565)\n`import git.tcp.direct/kayos/prox5`\nProx5 is a golang library for managing, validating, and utilizing a very large amount of arbitrary SOCKS proxies.\nNotably it features interface compatible dialer functions that dial out from different proxies for every connection, and a SOCKS5 server that utilizes those functions.\nCaution\n**Using prox5 to proxy connections from certain offsec tools may cause denial of service.** Please spazz out responsibly.\n\n## Table of Contents\n1. Overview\n  1. Validation Engine\n  2. Auto Scaler\n  3. Rate Limiting\n  4. Accessing Validated Proxies\n2. Additional info\n  1. The Secret Sauce\n  2. External Integrations\n3. Status and Final Thoughts\n\n## Overview\n### Validation Engine\n1. TCP Dial to the endpoint, if successful, reuse net.Conn down for step 2\n2. HTTPS GET request to a list of IP echo endpoints\n3. Store the IP address discovered during step 2\n4. Allocate a new `prox5.Proxy` type || update an existing one, store latest info\n5.\nEnqueue a pointer to this `proxy.Proxy` instance, instantiating it for further use\n\n### Auto Scaler\nThe validation has an optional auto scale feature that allows for the automatic tuning of validation worker count as more proxies are dispensed.\nThis feature is still new, but seems to work well. It can be enabled with `[...].EnableAutoScaler()` .\nPlease refer to the autoscale related items within [the documentation](https://pkg.go.dev/git.tcp.direct/kayos/prox5) for more info.\n\n### Rate Limiting\nUsing [Rate5](https://github.com/yunginnanet/Rate5) , prox5 naturally reduces the frequency of proxies that fail to validate. It does this by reducing the frequency proxies are accepted into the validation pipeline the more they fail to verify or fail to successfully connect to an endpoint.\nThis is not yet adjustable, but will be soon. See [the documentation for Rate5](https://pkg.go.dev/git.tcp.direct/kayos/rate5) , and the source code for this project (defs.go is a good place to start) for more info.\n\n### Accessing Validated Proxies\n* Retrieve validated 4/4a/5 proxies as simple strings for generic use\n* Use one of the dialer functions with any golang code that calls for a net.Dialer\n* Spin up a SOCKS5 server that will then make rotating use of your validated proxies\n\n## Additional info\n### The Secret Sauce\nWhat makes Prox5 special is largely the Mystery Dialer. This dialer satisfies the net.Dialer and ContextDialer interfaces. The implementation is a little bit different from your average dialer. Here's roughly what happens when you dial out with a ProxyEngine;\n* Loads up a previously verified proxy\n* Attempts to make connection with the dial endpoint using said proxy\n* Upon failure, prox5:\n+ repeats this process _mid-dial_\n+ does not drop connection to the client\n\n...\n\n### External Integrations\nMullvad\nTake a look at [mullsox](https://git.tcp.direct/kayos/mullsox) for an easy way to access all of the mullvad proxies reachable from any one VPN endpoint. It is trivial to feed the results of `GetAndVerifySOCKS` into prox5.\nHere's a snippet that should just about get you there:\n```\npackage main\n\nimport (\n    \"os\"\n    \"time\"\n\n    \"git.tcp.direct/kayos/mullsox\"\n    \"git.tcp.direct/kayos/prox5\"\n)\n\nfunc main () {\n\tp5 := prox5 . NewProxyEngine ()\n\tmc := mullsox . NewChecker ()\n\n\tif err := mc . Update (); err != nil {\n\t\tprintln ( err . Error ())\n\t\treturn\n\t}\n\n\tincoming , _ := mc . GetAndVerifySOCKS ()\n\n\tvar count = 0\n\tfor line := range incoming {\n\t\tif p5 . LoadSingleProxy ( line . String ()) {\n\t\t\tcount ++\n\t\t}\n\t}\n\n\tif count == 0 {\n\t\tprintln ( \"failed to load any proxies\" )\n\t\treturn\n\t}\n\n\tif err := p5 . Start (); err != nil {\n\t\tprintln ( err . Error ())\n\t\treturn\n\t}\n\t\n\tgo func () {\n\t\tif err := p5 . StartSOCKS5Server ( \"127.0.0.1:42069\" , \"\" , \"\" ); err != nil {\n\t\t\tprintln ( err . Error ())\n\t\t\tos . Exit ( 1 )\n\t\t}\n\t}()\n\t\n\ttime . Sleep ( time . Millisecond * 500 )\n\t\n\tprintln ( \"proxies loaded and socks server started\" )\n}\n```\n\n...\n\n## Status and Final Thoughts\n**This project is in development.**\nIt \"works\" and has been used in \"production\", but still needs some love.\nPlease break it and let me know what broke.\nThe way you choose to use this lib is yours. The API is fairly extensive for you to be able to customize runtime configuration without having to do any surgery.\nThings like the amount of validation workers that are concurrently operating, timeouts, and proxy re-use policies may be tuned in real-time.\n\n# **Please see [the docs](https://pkg.go.dev/git.tcp.direct/kayos/prox5) and the example for more details.**\n## About\n🧮🧮 SOCKS5/4/4a 🌾🌾 validating proxy pool and upstream SOCKS5 server for 🤽🤽 LOLXDsoRANDum connections 🎋🎋\n[git.tcp.direct/kayos/prox5](https://git.tcp.direct/kayos/prox5 \"https://git.tcp.direct/kayos/prox5\")\n\n### Topics\ngo golang proxy proxy-server socks socks5 enumeration stealth bypass socks4a socks4 proxy-pool\n\n### Resources\nReadme\n\n### License\nMIT license\n\n...\n\n## Languages\n* [Go 100.0%](https://github.com/yunginnanet/prox5/search?l=go)"
      ],
      "full_content": null
    },
    {
      "url": "https://github.com/things-go/go-socks5",
      "title": "GitHub - things-go/go-socks5: socks5 server in pure Golang with much custom optional. Full TCP/UDP and IPv4/IPv6 support. · GitHub",
      "publish_date": null,
      "excerpts": [
        "# things-go/go-socks5\n- Page: GitHub repository\n- URL: https://github.com/things-go/go-socks5\n- Description: socks5 server in pure Golang with much custom optional. Full TCP/UDP and IPv4/IPv6 support. - things-go/go-socks5\n- Stars: 612\n- Forks: 102\n- License: MIT license\n- Default branch: master\n- Created: 2020-04-19T06:05:29.000Z\n- Commits: 285\n\n## Top-level files\n- .github/\n- _example/\n- bufferpool/\n- statute/\n- .gitignore\n- .goreleaser.yaml\n- AGENTS.md\n- LICENSE\n- README.md\n- auth.go\n- auth_test.go\n- credentials.go\n- credentials_test.go\n- go.mod\n- go.sum\n- handle.go\n- handle_test.go\n- logger.go\n- option.go\n- resolver.go\n- resolver_test.go\n- ruleset.go\n- ruleset_test.go\n- server.go\n\n...\n\n# go-socks5\nCard](https://goreportcard.com/report/github.com/things-go/go-socks5) [License](https://github.com/things-go/go-socks5/raw/master/LICENSE) [Tag](https://github.com/things-go/go-socks5/tags)\nProvides the `socks5` package that implements a [SOCKS5](http://en.wikipedia.org/wiki/SOCKS) .\nSOCKS (Secure Sockets) is used to route traffic between a client and server through\nan intermediate proxy layer. This can be used to bypass firewalls or NATs.\n\n## Feature\nThe package has the following features:\n* Support socks5 server\n* Support TCP/UDP and IPv4/IPv6\n* Unit tests\n* \"No Auth\" mode\n* User/Password authentication optional user addr limit\n* Support for the CONNECT command\n* Support for the ASSOCIATE command\n* Rules to do granular filtering of commands\n* Custom DNS resolution\n* Custom goroutine pool\n* buffer pool design and optional custom buffer pool\n* Custom logger\n\n### TODO\nThe package still needs the following:\n* Support for the BIND command\n\n### Installation\nUse go get.\n```shell\n    go get github.com/things-go/go-socks5\n```\nThen import the socks5 server package into your own code.\n```shell\n    import \"github.com/things-go/go-socks5\"\n```\n\n...\n\n### Example\n```go\n\tif err := server.ListenAndServe(\"tcp\", \":8000\"); err != nil {\n\t\tpanic(err)\n\t}\n}\n```\n\n### Reference\n* [rfc1928](https://www.ietf.org/rfc/rfc1928.txt)\n* original armon's [go-sock5](https://github.com/armon/go-socks5) library\n\n## License\nThis project is under MIT License. See the [LICENSE](https://github.com/things-go/go-socks5/blob/master/LICENSE) file for the full license text."
      ],
      "full_content": null
    },
    {
      "url": "https://github.com/elazarl/goproxy",
      "title": "GitHub - elazarl/goproxy: An HTTP proxy library for Go · GitHub",
      "publish_date": null,
      "excerpts": [
        "# elazarl/goproxy\n- Page: GitHub repository\n- URL: https://github.com/elazarl/goproxy\n- Description: An HTTP proxy library for Go\n- Stars: 6,752\n- Forks: 1,219\n- Default branch: master\n- Created: 2012-03-22T22:05:00.000Z\n- Commits: 441\n\n## Top-level files\n- .github/\n- certs/\n- examples/\n- ext/\n- internal/\n- regretable/\n- test_data/\n- transport/\n- .gitignore\n- .golangci.yml\n- LICENSE\n- README.md\n- actions.go\n- all.bash\n- ca.pem\n- certs.go\n- ctx.go\n- dispatcher.go\n- dispatcher_test.go\n- doc.go\n- go.mod\n- go.sum\n- http.go\n- http2.go\n- http2_test.go\n- https.go\n- https_head_test.go\n- key.pem\n- logger.go\n- proxy.go\n- proxy_test.go\n- responses.go\n- websocket.go\n- websocket_test.go\n\n# GoProxy\n[Status](https://github.com/elazarl/goproxy/workflows/Go/badge.svg) [GoDoc](https://pkg.go.dev/github.com/elazarl/goproxy) [Go Report](https://goreportcard.com/report/github.com/elazarl/goproxy) [BSD-3 License](https://opensource.org/licenses/BSD-3-Clause) [Pull Requests](https://makeapullrequest.com/) [Awesome\nGo](https://github.com/avelino/awesome-go?tab=readme-ov-file)\nGoProxy is a library to create a `customized` HTTP/HTTPS `proxy server` using\nGo (aka Golang), with several configurable settings available.\nThe target of this project is to offer an `optimized` proxy server, usable with\nreasonable amount of traffic, yet `customizable` and `programmable` .\nThe proxy itself is simply a `net/http` handler, so you can add multiple\nmiddlewares (panic recover, logging, compression, etc.) over it. It can be\neasily integrated with any other HTTP network library.\n\n...\n\n> [✈️ Telegram Group](https://telegram.me/goproxygroup)[🎁 Become a Sponsor](https://opencollective.com/goproxy)\n\n## Features\n* Perform certain actions only on `specific hosts` , with a single equality comparison or with regex evaluation\n* Manipulate `requests` and `responses` before sending them to the browser\n* Use a `custom http.Transport` to perform requests to the target server\n* You can specify a `MITM certificates cache` , to reuse them later for other requests to the same host, thus saving CPU. Not enabled by default, but you should use it in production!\n* Redirect normal HTTP traffic to a `custom handler` , when the target is a `relative path` (e.g. `/ping` )\n* You can choose the logger to use, by implementing the `Logger` interface\n* You can `disable` the HTTP request headers `canonicalization` , by setting `PreventCanonicalization` to true\n\n## Proxy modes\n1. Regular HTTP proxy\n2. HTTPS through CONNECT\n3. HTTPS MITM (\"Man in the Middle\") proxy server, in which the server generate TLS certificates to parse request/response data and perform actions on them\n4. \"Hijacked\" proxy connection, where the configured handler can access the raw net.Conn data\n\n...\n\n## Maintainers\n* [Elazar Leibovich](https://github.com/elazarl) : Creator of the project, Software Engineer\n* [Erik Pellizzon](https://github.com/ErikPelli) : Maintainer, Freelancer (open to collaborations!)\n\n...\n\n## Contributions\nThe code for this project is released under the `BSD 3-Clause` license,\nmaking it useful for `commercial` uses as well.\n\n...\n\n## A taste of GoProxy\nTo get a taste of `goproxy` , here you are a basic HTTP/HTTPS proxy\nthat just forward data to the destination:\n```go\npackage main\n\nimport (\n    \"log\"\n    \"net/http\"\n\n    \"github.com/elazarl/goproxy\"\n)\n\nfunc main() {\n    proxy := goproxy.NewProxyHttpServer()\n    proxy.Verbose = true\n    log.Fatal(http.ListenAndServe(\":8080\", proxy))\n}\n```\n\n### Request handler\nThis line will add `X-GoProxy: yxorPoG-X` header to all requests sent through the proxy,\nbefore sending them to the destination:\n```go\nproxy.OnRequest().DoFunc(\n    func(r *http.Request,ctx *goproxy.ProxyCtx)(*http.Request,*http.Response) {\n        r.Header.Set(\"X-GoProxy\",\"yxorPoG-X\")\n        return r,nil\n    })\n```\n\n...\n\n### Let's start\n```go\nimport \"github.com/elazarl/goproxy\"\n```\nThere are some proxy usage examples in the `examples` folder, which\ncover the most common cases. Take a look at them and good luck!\n\n...\n\n## Request & Response manipulation\n```go\n// handler called after receiving HTTP CONNECT from the client, and\n// before proxy establishes connection with the destination host\nhttpsHandlers   []HttpsHandler\n\n// handler called before proxy sends HTTP request to destination host\nreqHandlers     []ReqHandler \n\n```\n\n...\n\nDepending on what you want to manipulate, the ways to add handlers to each of the previous lists are:\n```go\n// Add handlers to httpsHandlers \nproxy.OnRequest(some ReqConditions).HandleConnect(YourHandlerFunc())\n\n// Add handlers to reqHandlers\nproxy.OnRequest(some ReqConditions).Do(YourReqHandlerFunc())\n\n// Add handlers to respHandlers\nproxy.OnResponse(some RespConditions).Do(YourRespHandlerFunc())\n```\n\n...\n\n```go\n// This rejects the HTTPS request to *.reddit.com during HTTP CONNECT phase.\n// Reddit URL check is case-insensitive because of (?i), so the block will work also if the user types something like rEdDit.com.\nproxy.OnRequest(goproxy.ReqHostMatches(regexp.MustCompile(\"(?i)reddit.*:443$\"))).HandleConnect(goproxy.AlwaysReject)\n\n// Be careful about this example! It shows you a common error that you\n// need to avoid.\n// This will NOT reject the HTTPS request with URL ending with .gif because,\n// if the scheme is HTTPS, the proxy will receive only URL.Hostname\n// and URL.Port during the HTTP CONNECT phase.\nproxy.OnRequest(goproxy.UrlMatches(regexp.MustCompile(`.*gif$`))).HandleConnect(goproxy.AlwaysReject)\n\n// To fix the previous example, here there is the correct way to manipulate\n// an HTTP request using URL.Path (target path) as a condition.\nproxy.OnRequest(goproxy.UrlMatches(regexp.MustCompile(`.*gif$`))).Do(YourReqHandlerFunc())\n```\n\n...\n\n## Error handling\n### Connection error\nIf an error occurs while sending data to the target remote server (or to\nthe proxy client), the `proxy.ConnectionErrHandler` is called to handle the\nerror, if present, else a `default handler` will be used.\nThe error is passed as `function parameter` and not inside the proxy context,\n\n...\n\n## Project Status\nThis project has been created `10 years` ago, and has reached a stage of `maturity` . It can be safely used in `production` , and many projects\nalready do that.\nIf there will be any `breaking change` in the future, a `new version` of the\nGo module will be released (e.g. v2).\n\n## Trusted, as a direct dependency, by:\n[Stripe](https://github.com/stripe/goproxy) [Dependabot](https://github.com/dependabot/goproxy) [Go Git](https://github.com/go-git/go-git) [Google](https://github.com/google/oss-rebuild) [Grafana](https://github.com/grafana/grafana-plugin-sdk-go) [Fly.io](https://github.com/superfly/tokenizer)\n[Kubernetes / Minikube](https://github.com/kubernetes/minikube) [New Relic](https://github.com/newrelic/newrelic-client-go)"
      ],
      "full_content": null
    }
  ],
  "errors": [],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:34

Main libs covered. Checking dates, modules, edge cases.

**tool:parallel-search_web_fetch** (completed) 

```
allow_live_fetch=True; model_name=opencode/muse-spark-1.3-contributor-free; objective=Last commit module path license for proxy-manager ProxyGo proxypool free proxy v
--- output ---
{
  "extract_id": "extract_c8d42f3aaae1bdc520c7285c44a132c9",
  "results": [
    {
      "url": "https://github.com/Sansui233/proxypool",
      "title": "GitHub - Sansui233/proxypool: 自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan节点信息，聚合去重后提供节点列表",
      "publish_date": null,
      "excerpts": [
        "# Sansui233/proxypool\n## Folders and files\n| Name | Name | Last commit message | Last commit date |\n| ## Latest commit |  |  |  |\n\n## History\n[3 Commits](https://github.com/Sansui233/proxypool/commits/rm/)\n|\n|.keep |.keep | | |\n|README.md |README.md | | |\n|never_love_again.txt |never_love_again.txt | | |\n|View all files |"
      ],
      "full_content": null
    }
  ],
  "errors": [
    {
      "url": "https://github.com/jacklul/proxy-manager",
      "error_type": "http_error",
      "http_status_code": 404,
      "content": null
    },
    {
      "url": "https://github.com/jonasen1988/ProxyGo",
      "error_type": "http_error",
      "http_status_code": 404,
      "content": null
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:50

Two URLs 404. Resolving correct repos.

**tool:parallel-search_web_search** (completed) 

```
model_name=opencode/muse-spark-1.3-contributor-free; objective=Correct repo URLs jacklul proxy ProxyGo jonasen proxypool maintained fork; search_queries=['jacklul github proxy manager', 'ProxyGo proxy pool Go github', 'Sansui233 prox
--- output ---
{
  "search_id": "search_51072b60c0c7aef818cb0e1ba910a718",
  "results": [
    {
      "url": "https://pkg.go.dev/github.com/Sansui233/proxypool/pkg/proxy",
      "title": "proxy package - github.com/Sansui233/proxypool/pkg/proxy - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/Sansui233/proxypool\n3. pkg\n4. proxy\n  Go\nproxy\npackage\nVersion: v0.7.3 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Jun 2, 2021 License: GPL-3.0 Imports: 13 Imported by: 3\nMain Versions Licenses Imports Imported By\nDetails\nRepository\ngithub.com/Sansui233/proxypool\nLinks"
      ]
    },
    {
      "url": "https://toolhunter.cc/tools/proxygo",
      "title": "ProxyGo: Best Proxy Pools for Backend Developers in 2026",
      "publish_date": "2026-03-29",
      "excerpts": [
        "Home / Proxy Pools / ProxyGo ProxyGo fetches HTTP/SOCKS5 proxies from public sources, validates availability in batches of 300 concurrent checks, stores in SQLite, and exposes a unified HTTP proxy on port 7777 with web UI management. Visit Homepage GitHub 79 39 Bookmark Pricing Open-Source Tech Stack Go, SQLite Target backend developers and web scrapers Category Proxy Pools\nWhat Is ProxyGo? Attribute | Details\nType | Proxy Pools\nBest For | backend developers and web scrapers\nLanguage/Stack | Go, SQLite\nLicense | N/A\nGitHub Stars | 79 as of Oct 2024\nPricing | Open-Source\nLast Release | f2c3fba — Oct 2024\nWho Should Use ProxyGo? Tool | Best For | Key Differentiator | Pricing\nProxyGo | Web scraping rotation | Go-based, SQLite, web UI for free public proxies | Open-Source\nmitmproxy"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/Sansui233/proxypool/config",
      "title": "config package - github.com/Sansui233/proxypool/config - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/Sansui233/proxypool\n3. config\n  Go\nconfig\npackage\nVersion: v0.7.3 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Jun 2, 2021 License: GPL-3.0 Imports: 8 Imported by: 2\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/Sansui233/proxypool\nLinks\n* Open Source Insights Logo Open Source Insights\n  Jump to ...\n* Documentation\n* Index\n* Constants\n* Variables\n* Functions\n* Parse(path)\n* ReadFile(path)\n* Types\n* type ConfigOptions\n* type Source\n* Source Files\n  Documentation\nDocumentation ¶\nIndex ¶\nActiveMaxNumber        [uint16](/builtin#uint16)    `json:\"active-max-number\" yaml:\"active-max-number\"`\n}\nvar Config  [ConfigOptions](#ConfigOptions)\nConfig 配置\ntype Source ¶\ntype Source struct {\nType     [string](/builtin#string)        `json:\"type\" yaml:\"type\"`\nOptions  [tool](/github.com/Sansui233/proxypool@v0.7.3/pkg/tool) . [Options](/github.com/Sansui233/proxypool@v0.7.3/pkg/tool#Options)  `json:\"options\" yaml:\"options\"`\n}\nSource Files ¶\nView all Source files"
      ]
    },
    {
      "url": "https://112.cachefly.net/Sansui233/proxypool",
      "title": "GitHub - Sansui233/proxypool: 自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan节点信息，聚合去重后提供节点列表 · GitHub",
      "publish_date": null,
      "excerpts": [
        "Skip to content ## Navigation Menu\nSansui233 / proxypool Public\nforked from yourp112/proxypool\n* Notifications You must be signed in to change notification settings\n* Fork 609\n* Star 774\n* Code\n* Pull requests\n* Actions\n* Projects\n* Wiki\n* Security and quality\n* Insights\n  rm\n  Branches Tags\nGo to file\nCode\nOpen more actions menu\nLatest commit\nHistory\n3 Commits\n3 Commits\nFolders and files\n* Name | Name | Last commit message | Last commit date\n* .keep | .keep |  |\n* README.md | README.md |  |\n* never_love_again.txt | never_love_again.txt |  |\n* View all files\nRepository files navigation\n* README\n  More items\n  效果不佳，停止开发\nAbout\n自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan节点信息，聚合去重后提供节点列表\nResources\nReadme\nActivity\nStars\n774 stars\nWatchers\n55 watching\nForks\n609 forks\nReport repository\nContributors\nLanguages\nFooter\n© 2026 GitHub, Inc.\nFooter navigation\n* Terms\n* Privacy\n* Security\n* Status\n* Community\n* Docs\n* Contact\n* Manage cookies\n* Do not share my personal information"
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/One-Piecs/proxypool@v1.1.51",
      "title": "proxypool command - github.com/One-Piecs/proxypool - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/One-Piecs/proxypool\n  Go\nproxypool\ncommand module\nVersion: v1.1.51 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Aug 23, 2026 License: GPL-3.0 Imports: 11 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nRepository\ngithub.com/One-Piecs/proxypool\nLinks\n* Open Source Insights Logo Open Source Insights\n  Jump to ...\n* README\n* 支持\n* 安装\n  1. 使用Heroku\n  2. 使用fly.io\n  3. 从源码编译\n  4. 下载预编译程序\n  5. 使用docker\n* 使用\n* 修改配置文件\n* 启动程序\n* Clash配置文件\n* 本地检查节点可用性\n* 截图\n* 声明\n* Documentation\n* Source Files\n* Directories\n  README\nREADME ¶\nproxypool\n自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan、vless节点信息，聚合去重测试可用性后提供节点列表\nGithub Actions\n支持\n* 支持ss、ssr、vmess、trojan、vless多种类型\n* Telegram频道抓取\n* 订阅地址抓取解析\n* 公开互联网页面模糊抓取\n* 定时抓取自动更新\n* 通过配置文件设置抓取源\n* 自动检测节点可用性\n* 提供clash、surge配置文件\n* 提供ss、ssr、vmess、sip002订阅\n安装\n以下五选一。\n1. 使用Heroku\n注册fly.io需要绑定银行卡，支持银联借记卡。同时使用fly.io主要通过命令行工具flyctl，详情到 fly.io 官网了解。\n下载仓库源代码，修改 fly.toml 中的app与domain。在终端使用 flyctl deploy 部署即可。\n3. 从源码编译\n需要安装Golang\n$ go get -u -v github.com/Sansui233/proxypool\n运行\n$ go run main.go -c ./config/config.yaml\n编译\nmake\n4. 下载预编译程序\n从这里下载预编译好的程序 release 。\n5. 使用docker\ndocker pull ghcr.io/sansui233/proxypool:v0.6.0\n使用\n运行该程序需要具有访问完整互联网的能力。\n修改配置文件\n首先修改 config.yaml 中的必要配置信息。带有默认值的字段均可不填写。完整的配置选项见 配置文件说明\n启动程序\n使用 -c 参数指定配置文件路径，支持http链接\nproxypool -c ./config/config.yaml\n如果需要部署到VPS，更多细节请 查看wiki 。\nClash配置文件\n远程部署时Clash配置文件访问： https://domain/clash/config\n本地运行时Clash配置文件访问：http://127.0.0.1:[端口]/clash/localconfig\n本地检查节点可用性\n* Path | Synopsis\n* api |\n* config |\n* internal |\n* app |\n* cache |\n* cron |\n* database |\n* log |\n* pkg |\n* cdn |\n* geoIp |\n* getter |\n* healthcheck |\n* provider |\n* proxy |\n* tool |\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    },
    {
      "url": "https://github.com/Sansui233/proxypoolCheck",
      "title": "GitHub - Sansui233/proxypoolCheck: 本地检测proxypool节点的可用性",
      "publish_date": null,
      "excerpts": [
        "GitHub - Sansui233/proxypoolCheck: 本地检测proxypool节点的可用性\nThis is proxy health check and provider part of proxypool. You should have had a proxypool server available at first."
      ]
    },
    {
      "url": "https://pkg.go.dev/github.com/asdlokj1qpi23/proxypool@v0.7.23",
      "title": "proxypool command - github.com/asdlokj1qpi23/proxypool - Go Packages",
      "publish_date": null,
      "excerpts": [
        "1. Discover Packages\n2. github.com/asdlokj1qpi23/proxypool\n  Go\nproxypool\ncommand module\nVersion: v0.7.23 Latest Latest Warning\nThis package is not in the latest version of its module. Go to latest Published: Dec 20, 2023 License: GPL-3.0 Imports: 10 Imported by: 0\nMain Versions Licenses Imports Imported By\nDetails\n* checked Valid go.mod file\nThe Go module system was introduced in Go 1.11 and is the official dependency management solution for Go.\n* checked Redistributable license\nRedistributable licenses place minimal restrictions on how software can be used, modified, and redistributed.\n* checked Tagged version\nModules with tagged versions give importers more predictable builds.\n* unchecked Stable version\nWhen a project reaches major version v1 it is considered stable.\n* Learn more about best practices\nRepository\ngithub.com/asdlokj1qpi23/proxypool\nLinks\n* Open Source Insights Logo Open Source Insights\n  Jump to ...\n* README\n* Change Log\n* v0.7.21\n* v0.7.20\n* v0.7.19\n* v0.7.18\n* Features\n* About Streaming Media\n* Run\n* Disclaimer\n* Documentation\n* Source Files\n* Directories\n  README\nREADME ¶\nChange Log\nv0.7.21\n* add vless support\nv0.7.20\nIf you are using Clash, it is recommended to use the Streaming Media Enhanced Rules for better compatibility with streaming services.\nStream\nRun\ndocker run -d --restart=always \n--name=proxypool \n-p 12580:12580 \n-v /path/to/config:/config \nasdlokj1qpi23/proxypool \n-c /config/config.yaml\nDisclaimer\n* Path | Synopsis\n* api |\n* config |\n* internal |\n* app |\n* cache |\n* cloudflare |\n* cron |\n* database |\n* log |\n* pkg |\n* geoIp |\n* getter |\n* healthcheck |\n* healthcheck/stream |\n* provider |\n* proxy |\n* tool |\n* utils |\n  go.dev uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic. Learn more.\n  Okay"
      ]
    },
    {
      "url": "https://112.cachefly.net/orgs/goproxy/repositories",
      "title": "goproxy repositories · GitHub",
      "publish_date": null,
      "excerpts": [
        "Skip to content ## Navigation Menu\n* All\n* Contributed by me\n* Admin access\n* [Public](?q=visibility:public archived:false)\n* [Sources](?q=mirror:false fork:false archived:false)\n* [Forks](?q=fork:true archived:false)\n* Archived\n* [Templates](?q=template:true archived:false)\n* Collapse sidebar\nAll\nSearch repositories\nSearch\nRepositories list\n2 repositories\nLast pushed\n* Comfortable display density\n* Compact display density\ngoproxy\nPublic\nA minimalist Go module proxy handler.\ngo module proxy + 3\ngo module proxy handler minimalist goproxy\nGo\n•\nMIT License\n• 136 136 forks • 1.5k 1.5k stars • 2 2 issues • 1 1 pull request • Updated Jul 26, 2026 Jul 26, 2026\n*\ngoproxy.cn\nPublic\nThe most trusted Go module proxy in China.\ngo module proxy + 2\ngo module proxy china goproxy\nHTML\n•\nMIT License\n• 400 400 forks • 7.1k 7.1k stars • 9 9 issues • 0 0 pull requests • Updated Aug 20, 2025 Aug 20, 2025\nProTip! When viewing an organization's repositories, you can use the props. filter to filter by custom property.\nFooter\n© 2026 GitHub, Inc.\nFooter navigation\n* Terms\n* Privacy\n* Security\n* Status\n* Community\n* Docs\n* Contact\n* Manage cookies\n* Do not share my personal information"
      ]
    },
    {
      "url": "https://cdn.akaere.online/https://github.com/josbu",
      "title": "josbu · GitHub",
      "publish_date": null,
      "excerpts": [
        "pool) Python 2\nproxypool proxypool Public Forked from Sansui233/proxypool 自动抓取tg频道、订阅地址、公开互联网上的ss、ssr、vmess、trojan节点信息，聚合去重后提供节点列表，每小时更新 Go 1\nproxypool-okteto proxypool-okteto Public Forked from danxiaonuo/proxypool-okteto Dockerfile 1\nFooter\n© 2026 GitHub, Inc.\nFooter navigation\nTerms\nPrivacy\nSecurity\nStatus\nCommunity\nDocs\nContact\nManage cookies\nDo not share my personal information"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90"
}
```

---

### 🤖 Assistant — 2026-09-14 16:32:55

Ranked by maintenance + library fit for Go gateway embed. Sidecars noted where not library.

**1. prox5 — yunginnanet — best fit**
- URL: https://github.com/yunginnanet/Prox5 — mirror `git.tcp.direct/kayos/prox5`
- Stars: ~79-81, forks 8, commits 452. License MIT.
- Module: `git.tcp.direct/kayos/prox5` (GitHub path also works). Deps: `yunginnanet/Rate5`, stdlib, SOCKS4/4a/5 dial code. No heavy deps.
- Validation: TCP dial to endpoint, reuse `net.Conn`, HTTPS GET to IP-echo list, store discovered IP, enqueue `Proxy` instance. Configurable workers, timeouts, reuse policies, `EnableAutoScaler()`.
- Rotation: per-connection dispense — `MysteryDialer` implements `net.Dialer` / `ContextDialer`, loads verified proxy each dial. Plus `StartSOCKS5Server(addr,user,pass)` upstream rotating SOCKS5.
- Health: Rate5 backoff — failing proxies accepted into validation pipeline less often. Stats API, live tuning.
- Mid-dial retry: yes — only candidate with explicit mid-dial retry. On failure repeats with next proxy without dropping client connection. Includes `MysteryResolver`.
- Use: library first. `NewProxyEngine()`, `LoadSingleProxy()`, `Start()`, use dialer funcs or validated string list.

**2. things-go/go-socks5 — server block**
- URL: https://github.com/things-go/go-socks5
- Stars ~612, forks 102, commits 285. License MIT. Last activity 2024-2026 branch (imported by 107 modules).
- Module: `github.com/things-go/go-socks5`. Deps: stdlib + buffer pool, minimal.
- Validation: none built-in. Server only.
- Rotation / health / retry: none. Provides hooks to build own: `WithRule`, `WithResolver`, `WithRewriter`, `WithLogger`, `WithGPool`, custom DNS, granular `PermitCommand`.
- Supports TCP/UDP, IPv4/IPv6, CONNECT + ASSOCIATE, NoAuth + user/pass. No BIND.
- Use: pair with prox5 dialer or own pool. Front gateway with this, upstream rotation via prox5.

**3. elazarl/goproxy — HTTP(S) gateway lib, no SOCKS pool**
- URL: https://github.com/elazarl/goproxy
- Stars ~6750, forks ~1219, commits 441. License BSD-3-Clause. v1.9.0 Aug 2026, release Sep 4 2026. Maintained.
- Module: `github.com/elazarl/goproxy`. Deps: `golang.org/x/net/http2`, else stdlib. Imported by 2140 modules.
- Validation: none. HTTP proxy handler (`net/http` handler): regular proxy, CONNECT, MITM, hijacked `net.Conn`.
- Rotation / health / retry: none native. Add via custom `http.Transport` + external pool. `ConnectionErrHandler` hook for failover logic.
- Use: only if gateway is HTTP forward proxy. Combine: goproxy front, prox5 SOCKS dialer as transport.

**4. ProxyGo (jonasen1988) — sidecar, not library**
- Ref: https://toolhunter.cc/tools/proxygo — upstream GitHub search 404 on guessed `jonasen1988/ProxyGo`, use ToolHunter link + code search. Reported ~79 stars Oct 2024, last commit `f2c3fba` Oct 2024. License unstated.
- Validation: batch 300 concurrent checks against endpoints e.g. `https://cursor.com/api/auth/me`. TCP + HTTP/SOCKS5 aggregate from public sources.
- Rotation: single HTTP proxy endpoint `:7777` + web UI, SQLite persistence of valid proxies.
- Health: SQLite store, periodic recheck. Mid-dial retry: no (per-request proxy at endpoint level only).
- Use: sidecar next to gateway. Not embeddable. Good reference for validator concurrency pattern.

**5. yukkcat/socks5-proxy — sidecar reference, stdlib only**
- URL: https://github.com/yukkcat/socks5-proxy
- Stars ~193, forks 90, created Feb 2026, 5 commits. License unstated (check repo). Deps zero (stdlib only).
- Validation: TCP dial + Google connectivity check, geo filter CN/HK via lookup, scraper default `socks5-proxy.github.io`, configurable source.
- Rotation: upstream switch every 3-6 min random, pool refresh 20 min (immediate if empty).
- Health: concurrent checker, pool struct. Mid-dial retry: partial — auto-failover up to 3 retries on connection failure, then switch upstream. Local SOCKS5 endpoint + web dashboard `/api/status|refresh|switch`.
- Files: `pool.go checker.go scraper.go server.go status.go`. Use: copy patterns, not library. No module API.

Covered, not ranked as library:

- `go-proxypool` variants — service, GPL-3.0, Clash/ss/ssr/vmess/trojan/vless focus, not SOCKS5 gateway lib. Original https://github.com/Sansui233/proxypool (~774 stars, archived message "effect poor, stop dev"). Active forks: https://github.com/asdlokj1qpi23/proxypool (v0.7.25 Dec 2023, adds Cloudflare + `healthcheck/stream`), https://github.com/One-Piecs/proxypool (v1.1.51 Aug 2026). Validation: HTTP availability + streaming-media checks, cron, GeoIP. Rotation via Clash/surge configs + subscriptions. Health: `pkg/proxy check.go`, `CleanBadProxies`, dedup/sort. License GPL-3.0 blocks embed in closed gateway. Use as scraper source only. Local checker split: https://github.com/Sansui233/proxypoolCheck.
- `jacklul/proxy-manager` — https://github.com/jacklul/proxy-manager returns 404. No Go repo with that exact name found 2024-2026. Do not use. If meant PHP `jacklul/proxy` or other, clarify.
- Free-proxy-list validators — scrapers (`socks5-proxy.github.io`, ProxyScrape) + `checker.go` pattern from yukkcat above. No stable Go library; vendor scraper, validate with `golang.org/x/net/proxy` SOCKS5 dialer + HTTPS echo to `https://api.ipify.org` / `https://ifconfig.me` / `https://cursor.com/api/auth/me`.
- Cloudflare-worker / sidecar validators — no dominant Go library. Pattern: `asdlokj1qpi23/proxypool` `cloudflare/` + `healthcheck/` packages, or `proxypoolCheck` sidecar, or own worker hitting echo endpoint then pushing to gateway. For stdlib dial primitive use `golang.org/x/net/proxy.SOCKS5()` — no pool, no health, no retry.

Pick: embed `prox5` + `things-go/go-socks5` front (or `goproxy` if HTTP). Run `proxypool` forks / ProxyGo / yukkcat as sidecar scraper only.


---
