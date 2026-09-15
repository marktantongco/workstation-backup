# Research prod-readiness checklist (@general subagent)

- **Session ID:** `ses_f633d625affeb3vgxnw66udn6s`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-14 05:53:15
- **Last activity:** 2026-09-14 05:53:42
- **Messages:** 3

---

### 🧑 User — 2026-09-14 05:53:15

Research production-readiness criteria for a self-hosted AI gateway stack (multi-component: gateway, multiple sidecars, multi-provider failover, eval harness, agent orchestration). Use web_search for current best practices (2025-2026 era).

Cover these categories with concrete, actionable criteria:

1. **Observability**: metrics (Prometheus/OpenTelemetry), health endpoints, alert thresholds, log aggregation, request tracing
2. **Reliability**: restart guarantees, dependency health checks, circuit breakers, graceful degradation, backup/recovery, SLO definitions
3. **Security**: secrets management (Vault vs env vs KMS), key rotation, secret scanning in CI, RBAC, rate limiting, audit logs, TLS everywhere
4. **Operations**: runbooks, incident playbooks, on-call rotation, change management, rollback procedures
5. **Testing**: unit/integration/E2E coverage thresholds, chaos testing, load testing, contract testing
6. **Release**: CI/CD, semantic versioning, deprecation policy, feature flags, canary deploys
7. **Documentation**: README quality, API docs, architecture diagrams (C4), decision records (ADRs)
8. **Multi-tenancy**: namespace isolation, quota per tenant, per-tenant logging

For each category, give 3-5 specific actionable items. Quote sources. Under 1500 words.

---

### 🤖 Assistant — 2026-09-14 05:53:16

> User asks for research on production-readiness criteria for self-hosted AI gateway stack. Need to use web_search via parallel-search MCP. Should follow caveman mode (terse, drop articles). But user wants a research document with quotes and citations - that goes outside chat (technical substance stays). Will respond in caveman style but the deliverable is a research doc.
> 
> Actually, looking at caveman rules: "Persisted outside chat: write normal prose code, comments, commits, docs..." So if saving to file, write normal. But user didn't ask to save to file - they want the answer in chat. So caveman applies but need to convey research substance.
> 
> Under 1500 words. Use web_search. Let me do parallel searches for each category to gather evidence, then synthesize.
> 
> Let me kick off parallel searches.

**tool:parallel-search_web_search** (completed) 

```
objective=Production-readiness observability criteria for AI gateway: Prometheus metrics, ; search_queries=['AI gateway production readiness observability Prometheus OpenTelemetry 2025', 
--- output ---
{
  "search_id": "search_824a409feead946eb36b35470bcc65d0",
  "results": [
    {
      "url": "https://platform.tracxn.com/a/d/company/697d4119c519122987d533b7/langsage?utm_source=parallel&utm_medium=ai#a:about",
      "title": "Langsage",
      "publish_date": null,
      "excerpts": [
        "All Locations: India  \nSpecial Flags: Tech YES Enterprise YES SaaS YES Software YES\nName: Langsage\nWebsite Url: https://langsage.ai\nShort Description: Provider of an intelligent AI gateway and LLM observability platform\nDetailed Description: Provider of an intelligent AI gateway and LLM observability platform. This platform enables users to route requests to various large language model providers seamlessly using a single SDK. It offers complete visibility into LLM applications through detailed logs, traces, real-time monitoring, and performance metrics. The platform includes a comprehensive evaluation framework for prompts, workflows, and agents, ensuring quality and reliability. Additionally, it provides tools for monitoring and analyzing LLM costs, managing budgets, setting rate limits, and implementing automatic fallbacks to substitute models when primary LLMs fail. It integrates with numerous AI infrastructure components and LLM providers.\nStage: Unfunded\nLocation Country: India\nAll Locations: [{\"country\":\"India\"}]\nCountries Count: 1\nSubsidiary Count: 0\nSpecial Flags: [{\"flag_name\":\"Tech\",\"flag_value\":\"YES\"},{\"flag_name\":\"Enterprise\",\"flag_value\":\"YES\"},{\"flag_name\":\"SaaS\",\"flag_value\":\"YES\"},{\"flag_name\":\"Software\",\"flag_value\":\"YES\"}]\nAcquisitions As Target Count: 0\nAcquisitions As Acquirer Count: 0\nBoard Member Count: 0\nPatent Count: 0\nTrademark Count: 0\nLoan Count: 0\nActive Loan Count: 0\nEmail: ashutosh@langsage.ai"
      ]
    },
    {
      "url": "https://aigateway.envoyproxy.io/docs/capabilities/observability/metrics",
      "title": "AI/LLM Metrics | Envoy AI Gateway - aigateway.envoyproxy.io",
      "publish_date": null,
      "excerpts": [
        "When using the Envoy AI Gateway, it will collect AI specific metrics and expose them to Prometheus for monitoring by default. This guide provides an overview of the metrics collected by the AI Gateway and how to monitor them using Prometheus.\nOverview ​\nEnvoy AI Gateway is designed to intercept and process AI/LLM requests, that enables it to collect metrics for monitoring and observability. Currently, it collects metrics and exports them to Prometheus for monitoring in the OpenTelemetry format as specified by the OpenTelemetry Gen AI Semantic Conventions .\nNot all metrics are supported yet, but the Envoy AI Gateway will continue to add more metrics in the future.\nSupported Endpoints ​\nMetrics are collected for the following LLM endpoints:\n* /v1/chat/completions - Chat completions (streaming and non-streaming)\n* /v1/completions - Legacy text completions (streaming and non-streaming)\n* /v1/embeddings - Text embeddings\n* /cohere/v2/rerank - Rerank\n* /anthropic/v1/messages - Anthropic messages (streaming and non-streaming)\nFor example, the Envoy AI Gateway collects metrics such as:\n* gen_ai.client.token.usage : Number of tokens processed. The attribute gen_ai.token.type can be used to differentiate between input, output, and total tokens.\n* gen_ai.server.request.duration : Measured from the start of the received request headers in the E"
      ]
    },
    {
      "url": "https://aigateway.envoyproxy.io/blog/openinference-for-ai-observability",
      "title": "Enhancing AI Gateway Observability - OpenTelemetry Tracing Arrives in Envoy AI Gateway | Envoy AI Gateway",
      "publish_date": null,
      "excerpts": [
        "The v0.3 release of Envoy AI Gateway brings comprehensive OpenTelemetry tracing support with OpenInference semantic conventions , extending the existing metrics foundation to provide complete visibility into LLM application behavior.\n* LLM requests have complicated costs based on token usage\n* Responses can vary and may stream out tokens slowly\n* Semantic failures occur when the AI fails to understand or produce the correct answer\n* These issues don't show up as HTTP errors\nEnvoy AI Gateway has addressed some of these challenges.\nIt collects a set of robust metrics through OpenTelemetry. It tracks token use, request times, and provider performance data.\nThe v0.1.3 update added GenAI-specific metrics. These include time-to-first-token, available via Prometheus endpoints.\nTo enable you to gain traffic insights in the best way, Envoy AI Gateway chooses to stay close to standards. Instead of creating custom trace formats, Envoy AI Gateway uses OpenInference. This is a widely accepted standard for AI applications, compatible with OpenTelemetry. Many frameworks, like BeeAI and HuggingFace SmolAgents, support it.\nHow it All Fits Together: Envoy AI Gateway OpenTelemetry Tracing Architecture ​\nDiagram showing how it all fits together\nHere's an example of a simple trace that includes both application and gateway spans, shown in Arize Phoenix:"
      ]
    },
    {
      "url": "https://aigateway.envoyproxy.io/docs/1.0/capabilities/observability",
      "title": "Observability | Envoy AI Gateway",
      "publish_date": null,
      "excerpts": [
        "Envoy AI Gateway extends the capabilities of Envoy Gateway, and as you run Envoy Gateway you have access to the foundational observability in the Envoy Gateway system. We recommend you familiarize yourself with the Envoy Gateway Observability Documentation .\nAI/LLM Observability Features ​\nThe Envoy AI Gateway provides specialized observability capabilities for AI and LLM workloads:\n* GenAI Metrics - Prometheus metrics following OpenTelemetry Gen AI semantic conventions for monitoring token usage, latency, and model performance.\n* GenAI Tracing - OpenTelemetry integration with OpenInference semantic conventions for LLM request tracing and evaluation.\n* Access Logs with AI/LLM metadata - AI metadata produced by the AI gateway (model name, token usage, etc.) can be included in the Envoy Access Logs.\n* Gateway Configuration - Per-gateway configuration of the external processor container, including environment variables for tracing and resource requirements.\nPrevious Extension Fields Next AI/LLM Metrics\n* AI/LLM Observability Features\nEnvoy Ecosystem\n* Gateway\n* Proxy\n* Mobile\nCommunity\n* Join us on Slack\n* Weekly Meeting (Mondays)\n* Meeting Notes\n* LinkedIn\n* Talks and Presentations\nMore\n* Blog\n* GitHub\nCopyright © 2026 Envoy AI Gateway"
      ]
    },
    {
      "url": "https://aigateway.envoyproxy.io/docs/0.3/capabilities/observability/metrics",
      "title": "AI/LLM Metrics | Envoy AI Gateway",
      "publish_date": null,
      "excerpts": [
        "Skip to main content\nThis is documentation for Envoy AI Gateway 0.3 , which is no longer actively maintained.\nFor up-to-date documentation, see the latest version (1.1).\n*\n* Capabilities\n* Observability\n* AI/LLM Metrics\n  Version: 0.3\n  On this page\nAI/LLM Metrics\nWhen using the Envoy AI Gateway, it will collect AI specific metrics and expose them to Prometheus for monitoring by default. This guide provides an overview of the metrics collected by the AI Gateway and how to monitor them using Prometheus.\nOverview ​\nEnvoy AI Gateway is designed to intercept and process AI/LLM requests, that enables it to collect metrics for monitoring and observability. Currently, it collects metrics and exports them to Prometheus for monitoring in the OpenTelemetry format as specified by the OpenTelemetry Gen AI Semantic Conventions .\nNot all metrics are supported yet, but the Envoy AI Gateway will continue to add more metrics in the future.\nFor example, the Envoy AI Gateway collects metrics such as:\n* gen_ai.client.token.usage : Number of tokens processed. The label gen_ai_token_type can be used to differentiate between input, output, and total tokens.\n* gen_ai.server.request.duration : Measured from the start of the received request headers in the Envoy AI Gateway filter to the end of the processed response body processing.\n* gen_ai.server.time_to_f"
      ]
    },
    {
      "url": "https://platform.tracxn.com/a/d/company/69e883cc5d75112ca3364033/gateway?utm_source=parallel&utm_medium=ai#a:about",
      "title": "Gateway",
      "publish_date": null,
      "excerpts": [
        "Special Flags: Tech YES Enterprise YES Software YES Artificial Intelligence YES\nName: Gateway\nWebsite Url: https://gateway-llm.com\nShort Description: Provider of an LLM gateway for smart routing of model requests\nDetailed Description: Provider of an LLM gateway for smart routing of model requests. This open-source platform connects various LLM providers, automatically selecting the most cost-effective and fastest model that meets quality standards for each request. It offers features like multi-provider failover, virtual API keys with budgets, semantic caching, and comprehensive observability. The gateway is designed for seamless integration with existing OpenAI SDKs, enabling efficient management and governance of LLM traffic.\nStage: Unfunded\nCountries Count: 0\nPrimary Sector: High Tech\nPrimary Subsector: AI Infrastructure\nOther Taxonomy Tags: [\"High Tech\",\"Deep Tech\",\"Enterprise Applications\",\"Enterprise Software\"]\nSubsidiary Count: 0\nSpecial Flags: [{\"flag_name\":\"Tech\",\"flag_value\":\"YES\"},{\"flag_name\":\"Enterprise\",\"flag_value\":\"YES\"},{\"flag_name\":\"Software\",\"flag_value\":\"YES\"},{\"flag_name\":\"Artificial Intelligence\",\"flag_value\":\"YES\"}]\nEmail: mitshawtechnologies@gmail.com\nAcquisitions As Target Count: 0\nAcquisitions As Acquirer Count: 0\nBoard Member Count: 0\nPatent Count: 0\nTrademark Count: 0\nLoan Count: 0\nActive Loan Count: 0"
      ]
    },
    {
      "url": "https://platform.tracxn.com/a/d/company/69cf66c69730f87b6ca64743/ingateai.com?utm_source=parallel&utm_medium=ai#a:about",
      "title": "ingateai.com",
      "publish_date": null,
      "excerpts": [
        "Special Flags: Tech YES Enterprise YES SaaS YES Software YES Artificial Intelligence YES\nName: ingateai.com\nWebsite Url: https://www.ingateai.com/\nFounded Year: 2026\nShort Description: Provider of an AI gateway for enterprise LLM routing and governance\nDetailed Description: Provider of an AI gateway for enterprise LLM routing and governance. This platform sits between applications and large language model providers, offering complete observability, prompt versioning, automated evaluations, and provider fallback. It functions as a transparent proxy, enabling routing of any LLM request with sub-millisecond overhead. The system includes features for cost tracking, budget controls, security guardrails like PII redaction and prompt injection detection, and multi-tenancy with role-based access control. Integration requires a single URL change, supporting various HTTP-based LLM providers. The platform aims to provide visibility, control, and resilience across all AI interactions.\nStage: Unfunded\nCountries Count: 0\nPrimary Sector: High Tech\nPrimary Subsector: AI Infrastructure\nOther Taxonomy Tags: [\"Enterprise Applications\",\"SaaS\",\"High Tech\",\"Deep Tech\",\"Enterprise Software\",\"AI as a Service\",\"Native AI\"]\nSubsidiary Count: 0\nSpecial Flags: [{\"flag_name\":\"Tech\",\"flag_value\":\"YES\"},{\"flag_name\":\"Enterprise\",\"flag_value\":\"YES\"},{\"flag_name\":\"SaaS\",\"flag_value\":\"YES\"},{\"flag_name\":\"Software\",\"flag_value\":\"YES\"},{\"flag_name\":\"Artificial Intelligence\",\"flag_value\":\"YES\"}]\nEmail: careers@ingateai.com\nAcquisitions As Target Count: 0\nAcquisitions As Acquirer Count: 0\nBoard Member Count: 0\nPatent Count: 0\nTrademark Count: 0\nLoan Count: 0\nActive Loan Count: 0"
      ]
    },
    {
      "url": "https://aigateway.envoyproxy.io/docs/0.3/capabilities/observability",
      "title": "Observability | Envoy AI Gateway",
      "publish_date": null,
      "excerpts": [
        "Envoy AI Gateway extends the capabilities of Envoy Gateway, and as you run Envoy Gateway you have access to the foundational observability in the Envoy Gateway system. We recommend you familiarize yourself with the Envoy Gateway Observability Documentation .\nAI/LLM Observability Features ​\nThe Envoy AI Gateway provides specialized observability capabilities for AI and LLM workloads:\n* GenAI Metrics - Prometheus metrics following OpenTelemetry Gen AI semantic conventions for monitoring token usage, latency, and model performance.\n* GenAI Tracing - OpenTelemetry integration with OpenInference semantic conventions for LLM request tracing and evaluation.\nPrevious Vendor-Specific Fields Next AI/LLM Metrics"
      ]
    },
    {
      "url": "http://opentelemetry.io/blog/2026/genai-observability",
      "title": "Inside the LLM Call: GenAI Observability with OpenTelemetry",
      "publish_date": null,
      "excerpts": [
        "Inside the LLM Call: GenAI Observability with OpenTelemetry The OpenTelemetry [Semantic Conventions for Generative AI](/docs/specs/semconv/gen-ai/) give you that visibility. They standardize how GenAI operations are recorded — the model being called, input and output token counts, and when opted in, the full content of prompts, completions, tool calls, and tool results. ... Exporting GenAI telemetry Configure telemetry export By default, no prompt content or tool arguments are captured with GenAI telemetry, as these can contain sensitive data. Only metadata like model names, token counts, and durations are included. Enabling content capture populates span attributes with full prompt messages, system prompts, tool schemas, tool ... Exploring GenAI telemetry The dashboard collects telemetry sent to `http://localhost:4318`, and you can view telemetry by visiting `http://localhost:18888`. The dashboard also requires authentication by default. Use `-e ASPIRE_DASHBOARD_UNSECURED_ALLOW_ANONYMOUS=true` to allow anonymous access during local development. Explore traces GenAI operations from VS Code Copilot are now recorded and observable. Ask Copilot a question in VS Code, then open the **Traces** page in the dashboard. You will see entries for each LLM interaction. Selecting a trace reveals the span tree: the top-level `invoke_agent` span with child `chat` spans for each LLM call and `execute_tool` spans for each tool invocation. ![Aspire Dashboard showing the span tree for a GenAI trace](dashboard-spans.png) The span details show GenAI semantic convention attributes: **`gen_ai.request.model`** — the model used (for example, `gpt-4o`). **`gen_ai.usage.input_tokens`** and **`gen_ai.usage.output_tokens`** — token counts for each LLM call. **`gen_ai.response.finish_reasons`** — why the model stopped generating (for example, `stop` or `tool_calls`). When an app is configured to record content, messages and tool calls are captured as structured span attributes such as `gen_ai.system_instructions`, `gen_ai.input.messages`, and `gen_ai.output.messages`. This content is valuable for debugging, but these attributes can be large, and many observability ... Observability tools can include specialized UI for viewing GenAI telemetry. We'll use a [GenAI telemetry visualizer](https://aspire.dev/dashboard/explore/#genai-telemetry-visualization) that parses these attributes and renders a chat-style view of the conversation, ... ![Aspire Dashboard GenAI telemetry visualizer showing a chat-style view of prompts and responses](dashboard-genai-visualizer.png) No more guessing about LLM usage or digging through raw JSON. With GenAI telemetry, every prompt, response, and tool call is visible at a glance. Explore metrics Navigate to the **Metrics** page and select the `copilot-chat` service. The GenAI metrics are prefixed with `gen_ai`: **`gen_ai.client.operation.duration`** — histogram of LLM call latencies. Filter by `gen_ai.request.model` to compare models. **`gen_ai.client.token.usage`** — histogram of token consumption. Filter by `gen_ai.token.type` to separate `input` from `output` tokens. These metrics let you estimate per-request cost, catch token-hungry prompts before they hit production, detect latency regressions, and monitor usage patterns across models and agents. ![Dashboard metrics page showing GenAI metrics](dashboard-metrics.png) Beyond this demo The GenAI semantic conventions are already in use today and under active development — your feedback on real-world usage directly shapes what gets standardized next. Test GenAI instrumentation in your own applications and"
      ]
    },
    {
      "url": "https://opentelemetry.io/blog/2024/llm-observability",
      "title": "An Introduction to Observability for LLM-based applications using OpenTelemetry",
      "publish_date": null,
      "excerpts": [
        "Seeing the growing use of LLMs in production, it’s important for users to learn how to understand and monitor how these models behave.\nIn the following example, we'll use Prometheus and Jaeger as the target backend for metrics and traces generated by an auto-instrumentation LLM monitoring library OpenLIT.\nWhy Observability Matters for LLM Applications\nMonitoring LLM applications is crucial for several reasons.\nWhat are the signals that you should be looking at?\nIt is crucial to capture the sequence of events (using traces), especially in a RAG-based application where there can be events before and after LLM usage. Also, analyzing the aggregated data (through metrics) provides a quick overview like request, tokens and cost is important for optimizing performance and managing costs.\nHere are the key signals to monitor:\nTraces\n* Model Name or Version: Essential for tracking over time, as updates to the LLM might affect performance or response characteristics.\n* Prompt Details: The exact inputs sent to the LLM, which, unlike in-house ML models where inputs might be more controlled and homogeneous, can vary wildly and affect output complexity and cost implications.\n* Cost: Critical for budgeting, as API-based costs can scale with the number of requests and the complexity of each request.\n* Response Details: Similar to the prompt details "
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "session_824a409feead946eb36b35470bcc65d0"
}
```

**tool:parallel-search_web_search** (completed) 

```
objective=Production security criteria for self-hosted AI gateway: secrets management, key; search_queries=['AI API gateway secrets management Vault KMS key rotation 2025', 'LLM rate limi
--- output ---
{
  "search_id": "search_bd21f9a32a8eb24004dce9cbea752a7c",
  "results": [
    {
      "url": "https://developer.hashicorp.com/vault/docs/secrets/key-management",
      "title": "Key management secrets engine | Vault | HashiCorp Developer",
      "publish_date": "2026-04-15",
      "excerpts": [
        "After the secrets engine is mounted and a user/machine has a Vault token with the proper permission, it can use this secrets engine to generate, distribute, and manage the lifecycle of cryptographic keys in supported KMS providers .\n1. Create a named cryptographic key of a specified type:\n$  vault write -f keymgmt/key/example-key type= \"rsa-2048\" Success! Data written to: keymgmt/key/example-key\nKeys created by the secrets engine are considered general-purpose until they're distributed to a KMS provider.\n2. Configure a KMS provider:\nThe protection defines where cryptographic operations are performed with the key in the KMS provider. See the API documentation for a list of supported purpose and protection values.\nNote: The amount of time it takes to distribute a key to a KMS provider is proportional to the number of versions that the key has.\nIf a timeout occurs when distributing a key to a KMS provider, you may need to increase the VAULT_CLIENT_TIMEOUT .\n4. Rotate a key:\n$  vault write -f keymgmt/key/example-key/rotate\nRotating a key creates a new key version that contains new key material. The key will be rotated in both Vault and the KMS provider that the key has been distributed to.\nThe new key version will be enabled and set as the current version for cryptographic operations in the KMS provider.\n5. Enable or disable key versions:\n$  vault write keymgmt/key/example-key min_enabled_version=2\nThe min_enabled_version of a key can be updated in order to enable or disable"
      ]
    },
    {
      "url": "https://github.com/voidmind-io/voidllm",
      "title": "GitHub - voidmind-io/voidllm: Privacy-first LLM proxy and AI gateway - load balancing, multi-provider routing, API key management, usage tracking, rate limiting. Self-hosted. Zero knowledge of your prompts. · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Page: GitHub repository\n* URL: https://github.com/voidmind-io/voidllm\n* Description: Privacy-first LLM proxy and AI gateway - load balancing, multi-provider routing, API key management, usage tracking, rate limiting. Self-hosted. Zero knowledge of your prompts. - voidmind-io/voidllm\n* Stars: 129\n* Forks: 14\n* Default branch: main\nCI codecov Go Report Card Artifact Hub OpenSSF Scorecard Snyk Release Go License: BSL 1.1\nA privacy-first LLM proxy and AI gateway for teams that take control seriously.\nVoidLLM is a self-hosted LLM proxy that sits between your applications and LLM providers - OpenAI, Anthropic, Azure, Ollama, vLLM, or any custom endpoint.\nIt gives you organization-wide access control, API key management, usage tracking, rate limiting, and multi-deployment load balancing. One Go binary, sub-2ms proxy overhead, zero knowledge of your prompts.\nVoidLLM Dashboard\nMore screenshots\nUsage Analytics API Keys Playground\n* Problem | How VoidLLM solves it\n* Teams share raw API keys in Slack | Virtual keys with org/team/user scoping and RBAC\n* No visibility into who's spending what | Per-key, per-team, per-org usage tracking + cost estimation\n* One runaway script burns the monthly budget | Rate limits + token budgets enforced by the proxy at every level\n* Self-host LLM infrastructure (vLLM, Ollama) or use managed providers and need one control plane\n* Cannot log prompts or responses for privacy or compliance reasons\n* Need org/team/user/key RBAC, budgets, and model routi"
      ]
    },
    {
      "url": "https://github.com/hashicorp/web-unified-docs/blob/main/content/vault/v2.x/content/docs/secrets/gcpkms.mdx",
      "title": "web-unified-docs/content/vault/v2.x/content/docs/secrets/gcpkms.mdx at main · hashicorp/web-unified-docs · GitHub",
      "publish_date": null,
      "excerpts": [
        "Google Cloud KMS secrets engine\nThe Google Cloud KMS Vault secrets engine provides encryption and key management\nvia [Google Cloud KMS][kms]. It supports management of keys, including creation,\nrotation, and revocation, as well as encrypting and decrypting data with managed\nkeys.\nGoogle Cloud KMS secrets engine\nThis enables management of KMS keys through Vault's policies and IAM\nsystem.\nGoogle Cloud KMS secrets engine > Setup\nplaintext    hello world\nFor easier scripting, it is also possible to extract the plaintext directly:\n$ vault write -field=plaintext gcpkms/decrypt/my-key ciphertext=CiQAuMv0lTiKjrF43Lgr4...\nhello world\n4. Rotate the underlying encryption key.\nGoogle Cloud KMS secrets engine > Setup\nThis will generate a new crypto key version on Google Cloud KMS and set that version as the active key.\n$ vault write -f gcpkms/keys/rotate/my-key\nWARNING! The following warnings were returned from Vault:\nGoogle Cloud KMS secrets engine > Setup\n* The crypto key version was rotated successfully, but it can take up to 2\n  hours for the new crypto key version to become the primary. In practice, it\n  is usually much shorter. Be sure to issue a read operation and verify the\n  key version if you require new data to be encrypted with this key.\nKey            Value\nGoogle Cloud KMS secrets engine > Setup\nkey_version    2\nAs the message says, rotation is not immediate. Depending on a number of factors, the propagation of the new key can take quite some time. If you have a need t"
      ]
    },
    {
      "url": "https://developer.hashicorp.com/vault/docs/secrets/key-management/awskms",
      "title": "AWS KMS | Vault | HashiCorp Developer",
      "publish_date": "2026-04-15",
      "excerpts": [
        "Enterprise\nAppropriate Vault Enterprise license or HCP Vault Dedicated cluster required.\nAWS KMS secrets engine requires Vault Enterprise with the Advanced Data Protection (ADP) module.\nThe Key Management secrets engine supports lifecycle management of keys in AWS KMS regions.\nAuthentication\nThe Key Management secrets engine must be configured with credentials that have sufficient permissions to manage keys in an AWS KMS region. The authentication parameters are described in the credentials section of the API documentation. The authentication parameters will be set with the following order of precedence:\nThe following is an example of how to configure the KMS provider resource using the Vault CLI:\n$  vault write keymgmt/kms/example-kms \\     provider=\"awskms\" \\     key_collection=\"us-west-1\" \\     credentials=access_key=\"ASIADJO3WTX6WPLJM42V\" \\     credentials=secret_key=\"bCiYmNroLxLmPNQ47VIvjlm8mQu5oktZcQdq195w\"\nRefer to the AWS KMS API documentation for a detailed description of individual configuration parameters.\nKey transfer specification\nKeys are securely transferred from the secrets engine to AWS KMS regions in accordance with the AWS KMS Bring Your Own Key specification.\nKey rotation\nAWS KMS keys with imported key material are not eligible for automatic key rotation within AWS KMS. As such, key rotations performed by the secrets engine use the manual key rotation process. Applications should refer to the alias associated with imported keys. Aliases will always ha"
      ]
    },
    {
      "url": "https://github.com/teasru/Secure-LLM-Gateway",
      "title": "GitHub - teasru/Secure-LLM-Gateway: Secure, policy-driven LLM gateway with authentication, rate limiting, caching, and observability. · GitHub",
      "publish_date": null,
      "excerpts": [
        "A production-style, modular backend service that acts as a secure gateway in front of a Large Language Model (LLM).\nThis system enforces authentication, role-based access control, rate limiting, prompt inspection, output filtering, caching, and observability before allowing access to an LLM provider.\nOverview\nThis project implements a secure AI gateway layer between clients and an LLM API.\nInstead of directly exposing a model endpoint, all requests pass through:\nClient\n↓\nJWT Authentication\n↓\nRBAC\n↓\nRate Limiter (Redis)\n↓\nPrompt Inspection\n↓\nPolicy Engine\n↓\nCache Layer (Redis)\n↓\nLLM Provider (OpenAI / Local Fallback)\n↓\nOutput Filtering\n↓\nStructured Logging + Tracing\n↓\nResponse\nThe goal is to simulate real-world AI governance and infrastructure patterns used in production systems.\nThis is implemented as a modular monolith , not microservices.\nAll components run in a single FastAPI application, but are separated into modules:\napp/\n├── auth/          # JWT handling and RBAC\n├── core/          # Rate limiting, caching, policy engine, filtering\n├── llm/           # OpenAI client + fallback\nFeatures\nJWT Authentication\n* Stateless authentication using signed JWT tokens\n* Tokens include user_id and role\n* Signature validated on every request\nRole-Based Access Control (RBAC)\n* Roles: user , admin\n* Endpoint access enforced via dependency injection\n* Strongly typed role validation using Literal\nRedis Rate Limiting\n* Per-user request limits\n* Configurable via environment variables\n*"
      ]
    },
    {
      "url": "https://owasp.org/www-project-llm-verification-standard/LLMSVS-v2.0-en.html",
      "title": "LLMSVS v2.0 — OWASP Large Language Model Security ...",
      "publish_date": null,
      "excerpts": [
        "V1. Secure configuration and maintenance\nControl objective\nEnsure that LLMs, hosted by a model provider or self-hosted, are configured and maintained securely to prevent unauthorized access and leakage of sensitive information.\n* | Requirement | L1 | L2 | L3\n* 1.1 | Identify any components that store secrets, like API keys, for third-party systems, like hosted LLMs and vector databases, and ensure the secure handling of these credentials according to OWASP ASVS requirements for service credentials and secrets (see OWASP ASVS cross-references ). |  | ✓ | ✓\n* 1.2 | For self-hosted LLMs, ensure they are appropriately segregated within the network to prevent direct exposure to end-users unless such access is required. |  | ✓ | ✓\n* 1.3 | Maintain an up-to-date inventory of all LLM instances and apply regular updates and patches to self-hosted models. |  |  | ✓\n* 2.8 | Ensure that model training resources are audited for sensitive data (such as PII, internal company data, etc.) and cleaned before training to mitigate sensitive data exposure in model responses. |  | ✓ | ✓\n* 2.9 | Ensure secure acquisition and storage of foundational or pre-trained models. | ✓ | ✓ | ✓\n* 2.10 | Where possible, prefer secure model formats such as SafeTensors over formats that use unsafe serialization, like PyTorch’s Pickle format. | ✓ | ✓ | ✓\n* 2.11 | Ensure that foundational models are fine-tuned to limit irrelevant data points which may lead to poor model performance. |  | ✓ | ✓\n|  |  | ✓\n* 4.4 "
      ]
    },
    {
      "url": "https://konghq.com/blog/engineering/owasp-top-10-ai-and-llm-guide",
      "title": "OWASP AI Security Project: Top 10 LLM Vulnerabilities Guide  | Kong Inc.",
      "publish_date": "2025-12-12",
      "excerpts": [
        "Securing Enterprise AI: OWASP Top 10 LLM Vulnerabilities Guide > Introduction to OWASP Top 10 for LLM Applications 2025 > Kong AI Gateway's Enterprise-Ready Architecture\nKong AI Gateway extends Kong's proven enterprise API management platform with specialized AI-aware capabilities, providing a provider-agnostic interface that normalizes interactions across OpenAI, Anthropic, Azure AI, AWS Bedrock, GCP Vertex, and self-hosted models like LLaMA and Ollama.\nSecuring Enterprise AI: OWASP Top 10 LLM Vulnerabilities Guide > Introduction to OWASP Top 10 for LLM Applications 2025 > Kong AI Gateway's Enterprise-Ready Architecture\nKong AI Gateway integrates seamlessly with Kong Konnect, providing unified visibility across traditional APIs and AI services through runtime observability, including logs, metrics, and traces for all API and AI traffic and audit logs for tracking changes to gateway configurations, user\nSecuring Enterprise AI: OWASP Top 10 LLM Vulnerabilities Guide > LLM03:2025 - Supply Chain Vulnerabilities\nThe platform's [comprehensive logging] (https://developer.konghq.com/gateway/logs/#ai-gateway-logs) comprehensive logging captures model identities, providers, and response patterns, creating an audit trail for investigating suspected compromises.\nSecuring Enterprise AI: OWASP Top 10 LLM Vulnerabilities Guide > LLM06:2025 - System Prompt Leakage\n(https://developer.konghq.com/plugins/ai-rate-limiting-advanced/) rate limiting to prevent brute-force extraction attempts,"
      ]
    },
    {
      "url": "https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025",
      "title": "OWASP Top 10 for LLM Applications 2025",
      "publish_date": "2025-04-28",
      "excerpts": [
        "Skip to content\n* GEN AI SECURITY\n* resources\n* Whitepapers/Guides\nOWASP Top 10 for LLM Applications 2025\n* November 17, 2024\nAbout\nOWASP GenAI LLM Top 10 2026 > State of Agentic AI Security and Governance 2.01\n– Copyright © 2025 OWASP Foundation, Inc.\nScroll to Top\nOWASP GenAI LLM Top 10 2026 > State of Agentic AI Security and Governance 2.01\nOWASP Top 10 for LLM Applications 2025"
      ]
    },
    {
      "url": "https://genai.owasp.org/resource/llm-and-generative-ai-security-solutions-landscape-q12025",
      "title": "LLM and Generative AI Security Solutions Landscape - Q1,2025",
      "publish_date": "2026-06-13",
      "excerpts": [
        "Skip to content\n* GEN AI SECURITY\n* resources\n* Whitepapers/Guides\nLLM and Generative AI Security Solutions Landscape – Q1,2025\n* January 5, 2025\nAbout\nUpdated for Q1, 2025 – The LLM and Generative AI Security Solutions Landscape is tailored for a diverse audience comprising developers, AppSec professionals, DevSecOps and MLSecOps teams, data engineers, data scientists, CISOs, and security leaders who are focused on developing strategies to secure Large Language Models (LLMs) and Generative AI\nOWASP GenAI LLM Top 10 2026 > State of Agentic AI Security and Governance 2.01\n– Copyright © 2025 OWASP Foundation, Inc.\nScroll to Top\nOWASP GenAI LLM Top 10 2026 > State of Agentic AI Security and Governance 2.01\nLLM and Generative AI Security Solutions Landscape – Q1,2025"
      ]
    },
    {
      "url": "https://learn.microsoft.com/en-us/answers/questions/5686419/architecture-devsecops-patterns-for-secure-multi-t",
      "title": "Architecture & DevSecOps Patterns for Secure, Multi-tenant AI/LLM Platform on Azure - Microsoft Q&A",
      "publish_date": null,
      "excerpts": [
        "Architecture & DevSecOps Patterns for Secure, Multi-tenant AI/LLM Platform on Azure\nAzure DevOps: For an AI-centric workload involving Model deployment and drift detection, which platform offers better native integration?\nDiagram Request: Could you share a reference workflow or diagram for a \"Secure CI/CD Pipeline\" that includes SAST/DAST, secret scanning, and specifically AI Model evaluation steps before production release?\nNotes: Any more as secure pipeline stages such as plus:\n1. Client / Tenant Isolation Strategies\nTo ensure data privacy between tenants, common production patterns include:\nStrong isolation : Dedicated subscriptions or resource groups per tenant, with separate Azure OpenAI, AI Search, and Storage resources (recommended for regulated or high-security workloads).\nAzure DevOps , Azure DevOps generally offers better native integration for Azure-centric AI workloads:\nBuilt-in support for Azure RBAC, Managed Identities, and Key Vault\nEasier CI/CD integration with Azure AI and container-based deployments\nStrong support for Terraform, Bicep, and Kubernetes workflows\nFor a secure CI/CD pipeline , there is no single prescriptive diagram, but best practices include:\nCode quality checks\nSAST, DAST, dependency, container, and IaC scanning\nSecret scanning\nInfrastructure provisioning\nApplication and model deployment with progressive release strategies (blue/green, canary)\nFor an enterprise-grade LLM backend, IaC should provision not only AKS and networking but also:"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "session_bd21f9a32a8eb24004dce9cbea752a7c"
}
```

**tool:parallel-search_web_search** (completed) 

```
objective=Reliability and operations criteria for self-hosted AI gateway: chaos testing, l; search_queries=['chaos engineering LLM inference platform production 2025', 'AI model gateway c
--- output ---
{
  "search_id": "search_ebe707e5c4a383e11772f2fb18ffc8c3",
  "results": [
    {
      "url": "https://vercel.com/blog/ai-gateway-is-now-generally-available",
      "title": "AI Gateway: Production-ready reliability for your AI apps",
      "publish_date": null,
      "excerpts": [
        "Published: August 21, 2025 | Authors: Walter Korman , Harpreet Arora\nBuilding an AI app can now take just minutes. With developer tools like the AI SDK, teams can build both AI frontends and backends that accept prompts and context, reason with an LLM, call actions, and stream back results.\nBut going to production requires reliability and stability at scale. Teams that connect directly to a single LLM provider for inference create a fragile dependency: if that provider goes down or hits rate limits, so does the app. As AI workloads become mission-critical, the focus shifts from integration to reliability and consistent model access.\nFortunately, there's a better way to run.\nAI Gateway, now generally available, ensures availability when a provider fails, avoiding low rate limits and providing consistent reliability for AI workloads. It's the same system that has powered v0.app for millions of users, now battle-tested, stable, and ready for production for our customers.\nThe case for flexibility\nWhether AI native or leveraging AI integrations, teams want the ability to use the best model available at any given time while keeping systems composable and avoiding lock-in.\nBuilding in the flexibility to switch between models requires sophisticated engineering.\nAPIs can fail without warning, rate limits vary by provider, and keys must be managed and secured per vendor. Even trac"
      ]
    },
    {
      "url": "https://github.com/leshchenko1979/ai-gateway",
      "title": "GitHub - leshchenko1979/ai-gateway: OpenAI-compatible API gateway (Go) · GitHub",
      "publish_date": null,
      "excerpts": [
        "leshchenko1979/ai-gateway\n* Page: GitHub repository\n* URL: https://github.com/leshchenko1979/ai-gateway\n* Description: OpenAI-compatible API gateway (Go)\n* Stars: 2\n* Forks: 0\n* License: MIT license\n* Default branch: main\n* Created: 2026-02-04T09:31:11.000Z\n* Commits: 73\nTop-level files\n* .cursor/\n* .github/workflows/\n* .vscode/\n* app/\n* docs/\n* scripts/\n* .dockerignore\n* .env.example\n* .gitignore\n* CONTRIBUTING.md\n* Dockerfile\n* LICENSE\n* README.md\n* SECURITY.md\n* ai-gateway.service\n* config.yaml.example\n* docker-compose.yml\n* ops.sh\nREADME.md\nAI Gateway\nBuild and deploy License: MIT Go version\nAI Gateway is a lightweight, OpenAI-compatible gateway you can self-host. You define one route per model name your app uses, and the gateway tries providers in order until one succeeds. This is useful when you want fewer failures from provider rate limits or temporary outages.\nConnect Your App\nUse this contract in any OpenAI-compatible client (n8n, scripts, apps):\n* Base URL: https://YOUR_DOMAIN/v1 (or http://localhost:8080/v1 locally)\n* Model: a route name from config.yaml (not the upstream provider model id)\n* Auth: X-Api-Key: <GATEWAY_API_KEY> or Authorization: Bearer <GATEWAY_API_KEY>\n  For n8n, set:\n* Base URL: https://YOUR_DOMAIN/v1\n* Model: a route name from config.yaml\n* API key: your GATEWAY_API_KEY\nQuick Start (Docker)\n1. Copy the config template:\ncp config.yaml.example"
      ]
    },
    {
      "url": "https://www.harness.io/products/ai-sre",
      "title": "AI-Powered Site Reliability Engineering (AI SRE) | Harness",
      "publish_date": null,
      "excerpts": [
        "so teams can fix the root cause instead of fighting the same fire again.\nEvery incident tied to a change\nDeploys, flags, config changes, and infrastructure events are automatically correlated and attached at alert time, with no manual digging through change records.\nRunbook-driven, consistent resolution\nKnown failure patterns move from manual response to guided fixes, and eventually to full automation once trusted. Every incident handled consistently, not differently by whoever is on call.\nAlert noise drops Hours saved per incident “AI Scribe eliminated hours of manual postmortem writing. It captures everything from our Slack channels and generates comprehensive incident reports automatically.” — Principal Engineer, SaaS Platform Faster root cause “Change correlation is a game"
      ]
    },
    {
      "url": "https://launchdarkly.com/blog/canary-launches-how-and-why-to-canary-release",
      "title": "Canary Launches: How and Why to Canary Release | LaunchDarkly",
      "publish_date": null,
      "excerpts": [
        "Get a demo\nA canary launch (aka canary deployment or canary release ) is rolling features out to a small number of users to assess the reaction of the overall system. Are users happier? Is more money made? Does the new feature increase system load?\nA canary launch allows you to roll out a feature slowly, and measure the reaction from real user “canaries”, looking for early indicators of danger. If a feature is not good, it can rolled back. Canary launches are a best practice for agile development organizations practicing continuous delivery to move faster.\ncanary\nCanary launches are named after the “canary in a coal mine” - miners would carry canaries into mines, as canaries were more sensitive to fatal gases like methane or carbon monoxide. If the canary stopped singing, miners knew to exit the mine immediately.\nCanary launches are different than internal betas (dog fooding), user testing, QA or performance testing in that all of those methods are done in controlled test environments . Canary launching is done on real users in a production environment, either in a randomized fashion or with users explicitly assigned or opted in to the early launch.\nFor example, Google always releases new versions of Chrome as “Chrome Canary” to allow early adopters to try new features.\nTraditional pre-launch activities to improve product quality like internal betas, user testing, QA and"
      ]
    },
    {
      "url": "https://github.com/lunargate-ai/gateway",
      "title": "GitHub - lunargate-ai/gateway: High-performance self-hosted AI gateway (OpenAI-compatible) with routing, retries, and streaming · GitHub",
      "publish_date": null,
      "excerpts": [
        "LunarGate\nSelf-hosted open-source AI gateway with OpenAI-compatible APIs, Ollama upstream support, routing, fallback, and observability-friendly data sharing.\nDocs | API Reference | Examples | Website\nLicense: MIT\nImportant\nLunarGate is under active development.\nThe core gateway is already usable today, but interfaces and configuration may still evolve.\nLunarGate is a Go-based AI gateway that lets you expose one stable endpoint to your applications while routing requests to different upstream model providers behind the scenes.\nWhat LunarGate does\n* Exposes an OpenAI-compatible API for client apps\n* Routes requests across providers and models with weighted or conditional rules\n* Adds retries, fallbacks, and circuit breakers at the gateway layer\n* Supports streaming and tool-calling flows\n* Keeps a small footprint: the standalone binary is typically around 10-12 MB depending on platform, and the container image is around 12 MB\n* Keeps data local by default, with optional prompt/response sharing for observability\n* Works with providers such as OpenAI, Anthropic, Ollama, and other OpenAI-compatible local backends\nSupported endpoints\n* Chat Completions: create, stored list/retrieve/update/delete, and message listing under /v1/chat/completions\n* Responses: JSON/SSE POST /v1/responses , WebSocket GET /v1/responses , retrieve/delete/cancel/input-items, compaction, and input-toke"
      ]
    },
    {
      "url": "https://www.datadoghq.com/blog/ai-gateways-best-practices",
      "title": "AI gateway best practices: Model routing, reliability, and budget controls for production agents | Datadog",
      "publish_date": "2026-07-23",
      "excerpts": [
        "An AI gateway is a service that exposes a single API to provide an interface between agents and various LLM providers—including model APIs from providers like OpenAI and Anthropic, infrastructure platforms like Azure OpenAI Service and Amazon Bedrock Managed Agents , and self-hosted custom models deployed on Kubernetes.\nGateways are typically deployed in one of two ways: as self-hosted or open-source gateways (e.g., LiteLLM ) deployed inside a team’s own infrastructure, often using a proxy service , or as managed gateways (e.g., OpenRouter , Portkey ) that handle provider relationships, routing, and policy for you.\nIf your org is only reaching for a few models and is short on platform engineering overhead, a shared SDK wrapper —an abstraction in your application code that wraps a few model provider APIs together—can also suffice for standardizing agent request routing.\nAdditionally, you can use gateway-level circuit breakers to temporarily stop routing to a provider that’s failing, preventing cascading timeouts. Pair this with load balancing across multiple deployments of the same model—for example, multi-region Azure OpenAI —to stay under per-deployment rate limits.\nObservability is key as your agent and gateway respond to reliability challenges with retries and failover in production. To understand trends in agent behavior and ensure the gateway is handling them proper"
      ]
    },
    {
      "url": "https://vercel.com/changelog/openai-compatible-api-endpoints-now-supported-in-ai-gateway",
      "title": "OpenAI-compatible API endpoints now supported in AI Gateway ...",
      "publish_date": null,
      "excerpts": [
        "OpenAI-compatible API endpoints now supported in AI Gateway\nPublished: July 21, 2025 | Authors: Walter Korman , Harpreet Arora\nYou can now use OpenAI-compatible client libraries and tools with AI Gateway through a simple URL change, allowing you to access 100s of models with no code rewrites required.\nHere is a Python example with the OpenAI client library:\nfrom openai import OpenAI\nclient = OpenAI(\napi_key='my-ai-gateway-key',\nbase_url='https://ai-gateway.vercel.sh/v1'\n)\nstream = client.chat.completions.create(\nmodel='anthropic/claude-4-sonnet',\nmessages=[\n{\n'role': 'user',\n'content': 'Write a one-sentence bedtime story about a unicorn.'\n}\n],\nstream=True,\n)\nThis makes it easy to keep your current tools and workflows while improving uptime, tokens per minute, quotas, and reliability via provider failover and adding observability through the AI Gateway.\nLearn more in the AI Gateway docs and see more examples here.\n📚 More updates: View all changelog entries | Blog"
      ]
    },
    {
      "url": "https://launchdarkly.com/docs/guides/infrastructure/deployment-strategies",
      "title": "Deployment and release strategies | LaunchDarkly | Documentation",
      "publish_date": null,
      "excerpts": [
        "Using feature flags to deploy code without releasing it publicly is the original meaning of the phrase “dark launching.” When you do a dark launch, your new code or feature is present in your codebase, but not available to everyone.\nThe flags you use for dark launches are temporary tools to help you make sure that the features you release are reliable, stable, and behaving the way you want. After you fully deploy and release a feature, you can remove these flags.\nTo learn more about different use cases for feature flags, read Creating flags .\nIn a percentage rollout, the deployment has already occurred and the release occurs incrementally based on a percentage. The new feature rolls out to 10% of end users, then 25%, then 50%, until all end users receive the new feature.\nIn LaunchDarkly, the end users who get the new feature in a percentage rollout are randomly selected.\nAfter they get the new feature, they retain access to it as long as there is a way to identify them. This kind of sorting is best when your end users must log in to use your product, or have accepted cookies.\nThese releases are useful when you cannot run a beta program, or there is little variation in your targeted user base.\nCanary releases\nA canary release lets you test whether a feature release will have positive impact without affecting your whole user base. Only a small number of your end users can "
      ]
    },
    {
      "url": "https://github.com/FruityMaxine/freellm-gateway",
      "title": "GitHub - FruityMaxine/freellm-gateway: Self-hosted, OpenAI-compatible LLM gateway: policy-driven multi-provider routing (9-dim scoring) + OpenAI-compatible API + full operations console (cost, alerting, multi-tenancy, observability). · GitHub",
      "publish_date": null,
      "excerpts": [
        "* Page: GitHub repository\n* URL: https://github.com/FruityMaxine/freellm-gateway\n* Description: Self-hosted, OpenAI-compatible LLM gateway: policy-driven multi-provider routing (9-dim scoring) + OpenAI-compatible API + full operations console (cost, alerting, multi-tenancy, observability). - ...\n* Stars: 0\n* Forks: 0\n* License: MIT license\nFreeLLM — self-hosted, OpenAI-compatible LLM gateway\nLicense TypeScript Fastify React Prisma PRs welcome\nOne stable OpenAI-compatible API in front of many shifting LLM providers Policy-driven multi-provider routing · cost governance · alerting · multi-tenancy · full operations console.\nQuick start · Architecture · API · Deploy · 中文\nNo vendor lock-in, no per-seat pricing — you run it.\nScreenshots\n* Batch test bench — run one prompt across several models, compared side by side |\nWhy\nCalling LLM providers directly couples your application to one vendor's availability, pricing, and model catalog. Hosted aggregators solve that but are themselves a dependency you cannot inspect, extend, or run on your own infrastructure.\nFreeLLM is the gateway you run yourself:\n* One stable API in front of many shifting providers and models.\n* Routing as policy, not code — weight the dimensions you care about and let the engine pick.\n* Cost and quota control built into the key model, not bolted on.\n* Full visibility — every routing decision, every dollar, ev"
      ]
    },
    {
      "url": "https://developer.harness.io/ai-sre/new-to-ai-sre/overview",
      "title": "Harness AI SRE Overview and Key Features",
      "publish_date": null,
      "excerpts": [
        "A runbook is a sequence of actions that runs automatically when triggered. You define the steps ahead of time so the team does not have to coordinate them manually during an incident. A typical runbook for a major incident might open a Slack channel, post an update, start a Zoom bridge, notify the on-call engineers, and page the service team through PagerDuty.\nActions\nActions are the individual steps inside a runbook. Some are simple, like posting a message to Slack. Others are more involved, like triggering a Harness Pipeline to roll back a deployment or creating a new PagerDuty incident. Actions that talk to external systems run through a Harness Delegate to keep the connection secure.\nOn-call management\nFor the complete documentation index, see llms.txt. Markdown versions of documentation pages are available by appending .md to page URLs; this page is available as Markdown.\nHarness AI SRE Overview and Key Features\nWhat AI SRE does and its key capabilities for incident response.\nOverview\nHarness AI SRE gives you a unified view of incoming signals and active incidents. Alerts identify problems from your monitoring tools and incidents provide a structured workspace for coordinating the response.\nAlerts\nAlerts come in through webhooks from tools like Datadog, PagerDuty, and New Relic. Harness can deduplicate and correlate them so that a single underlying problem does not"
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "session_ebe707e5c4a383e11772f2fb18ffc8c3"
}
```

**tool:parallel-search_web_search** (completed) 

```
objective=Documentation, multi-tenancy, release criteria for AI gateway: C4 architecture d; search_queries=['C4 model architecture diagram ADR template production system', 'multi-tenant L
--- output ---
{
  "search_id": "search_34327333d0ac56962b4d834c0e2507f9",
  "results": [
    {
      "url": "https://www.alibabacloud.com/help/en/api-gateway/ai-gateway/product-overview/new-feature-release-notes-ai-gateway",
      "title": "\n Release notes - API Gateway - Alibaba Cloud Documentation Center\n\n",
      "publish_date": null,
      "excerpts": [
        "Document Center\nAll Products\nSearch\n* Document Center\n* API Gateway\n* AI Gateway\n* Product Overview\n* AI Gateway new feature release notes\n  all-products-head\n  This Product\n  API Gateway:AI Gateway new feature release notes\n  Document Center\nAPI Gateway:AI Gateway new feature release notes\n* Type | Description\n* New feature | The multi-tenant Serverless edition is now in public preview, available in Enterprise and Standard editions. Starting from 0 cost, the service is free to use during the public preview period.\n* Added model asset management, supporting model metadata and provider management, along with Credits quota management for models.\n* FinOps now supports custom period quotas and Credits-based quota management.\n* Custom Model/Agent APIs now support HTTP rewrite.\n* AI Gateway now supports integration with Global Accelerator (GA).\n* Optimization | AI Guardrails now supports parallel detection configuration.\n* Gateway access points can now be removed.\nJune 2026\n* Type | Description\n* New feature | * FinOps with consumer-level Token quotas.\n* Consumer groups with group-level API authorization.\n* Qwen Cloud and Bailian Token Plan integration.\n* Text-to-image/video models (e.g., KlingAI).\n* Vertex AI Claude via OpenAI and Anthropic protocols.\n* Multi-key failover for higher invocation reliability. |\nMay 2026\n* New feature | AI Gateway adds FinOps consumer quota"
      ]
    },
    {
      "url": "https://github.com/softaworks/agent-toolkit/blob/main/skills/c4-architecture/SKILL.md",
      "title": "agent-toolkit/skills/c4-architecture/SKILL.md at main · softaworks/agent-toolkit · GitHub",
      "publish_date": null,
      "excerpts": [
        "name: c4-architecture description: Generate architecture documentation using C4 model Mermaid diagrams. Use when asked to create architecture diagrams, document system architecture, visualize software structure, create C4 diagrams, or generate context/container/component/deployment diagrams.\nTriggers include \"architecture diagram\", \"C4 diagram\", \"system context\", \"container diagram\", \"component diagram\", \"deployment diagram\", \"document architecture\", \"visualize architecture\".\nC4 Architecture Documentation\nGenerate software architecture documentation using C4 model diagrams in Mermaid syntax.\nWorkflow\n1. Understand scope - Determine which C4 level(s) are needed based on audience\n2. Analyze codebase - Explore the system to identify components, containers, and relationships\n3. Generate diagrams - Create Mermaid C4 diagrams at appropriate abstraction levels\n4. Document - Write diagrams to markdown files with explanatory context\nC4 Diagram Levels\nSelect the appropriate level based on the documentation need:\n* Level | Diagram Type | Audience | Shows | When to Create\n* 1 | C4Context | Everyone | System + external actors | Always (required)\n* 2 | C4Container | Technical | Apps, databases, services | Always (required)\n* 3 | C4Component | Developers | Internal components | Only if adds value\n* 4 | C4Deployment | DevOps | Infrastructure nodes | For production systems\n- | C4D"
      ]
    },
    {
      "url": "https://api7.ai/learning-center/ai-gateway-guide",
      "title": "AI Gateway Guide: Architecture, Use Cases, and Best Practices ...",
      "publish_date": null,
      "excerpts": [
        "The gateway validates identity and evaluates access, tenant, token, guardrail, and budget policies.\n* Authentication\n* Policy evaluation\n3. Routing\nRouting logic selects the model or provider based on capability, latency, cost, region, and health.\n* Model routing decision\n* LLM provider\n4. Response\nStep 1\nUser or application sends an AI request\nA chatbot, agent, SaaS feature, or internal workflow sends a request through a stable API endpoint.\nStep 2\nGateway authenticates the caller\nThe gateway validates API keys, service identity, user context, tenant, workspace, environment, or application credentials before model access is allowed.\nStep 3\nGateway evaluates AI traffic policies\nPolicy checks can include model permissions, tenant quotas, token budgets, prompt rules, sensitive data handling, and provider access.\nStep 4\nGateway makes a model routing decision\nRouting rules choose the best backend based on latency, cost, capability, region, availability, or fallback policy.\nStep 5\nAuthentication and tenant isolation work for every migrated caller.\nStreaming, timeout, retry, and cancellation behavior match application expectations.\nPrimary and fallback models meet output compatibility and latency requirements.\nPolicy rejections are observable and return actionable errors to application owners.\nRoute traffic to a specific provider based on customer region, data policy, co"
      ]
    },
    {
      "url": "https://arxiv.org/html/2603.28735v1",
      "title": "RAD-AI: Rethinking Architecture Documentationfor AI-Augmented Ecosystems",
      "publish_date": null,
      "excerpts": [
        "We present RAD-AI, a backward-compatible extension framework that augments arc42 with eight AI-specific sections and C4 with three diagram extensions, complemented by a systematic EU AI Act Annex IV compliance mapping.\n* $\\bullet$\nRC1: RAD-AI, the first backward-compatible extension of arc42 (eight section extensions) and C4 (three diagram types) for documenting AI-augmented ecosystems.\n* $\\bullet$\nRC2: A systematic EU AI Act Annex IV compliance mapping with quantified coverage assessment, providing a concrete documentation path for the August 2026 deadline.\nThe C4 model [ 2 ] complements arc42 with four-level hierarchical visualization (System Context, Container, Component, and Code) plus supplementary Dynamic, Deployment, and System Landscape diagrams, commonly implemented through Structurizr DSL and PlantUML.\n[ 41 , 44 ] survey AI contributions to software architecture and propose an LLM reference architecture, while Autili et al. [ 16 ] propose ethical-aware reference architectures; none extends practitioner documentation frameworks.\n* G1\nNo AI-specific arc42 sections for model lifecycle, data pipelines, or drift.\n* G2\nNo C4 diagram types for ML components or non-determinism boundaries.\n* G3\nNo mapping between EU AI Act Annex IV and arc42/C4 sections.\n* G4\nNo AI-specific Architecture Decision Record templates.\n* G5\nRAD-AI follows three design principles: (1) ba"
      ]
    },
    {
      "url": "https://c4model.com/introduction",
      "title": "Introduction | C4 model",
      "publish_date": null,
      "excerpts": [
        "In contrast, ask a software developer to communicate the software architecture of a software system using diagrams and you’ll likely get a confused mess of boxes and lines.\nThe C4 model was created as a way to help software development teams describe and communicate software architecture, both during up-front design sessions and when retrospectively documenting an existing codebase.\nIt’s a way to create “maps of your code”, at various levels of detail, in the same way you would use something like Google Maps to zoom in and out of an area you are interested in.\n* |  |  |\n* |  |  |\n* A system context diagram provides a starting point, showing how the software system in scope fits into the world around it. | A container diagram zooms into the software system in scope, showing the applications and data stores inside it.\n| A component diagram zooms into an individual container, showing the components inside it. | A code diagram (e.g. UML class) can be used to zoom into an individual component, showing how that component is implemented at the code level.\nUses and benefits\nGood software architecture diagrams assist with communication inside and outside of software development/product teams, efficient onboarding of new staff, architecture reviews/evaluations, risk identification (e.g. risk-storming ), threat modelling, etc.\nThe goal of the C4 model is to raise the level of"
      ]
    },
    {
      "url": "https://arxiv.org/pdf/2603.28735",
      "title": "RAD-AI: Rethinking Architecture Documentation for AI-Augmented Ecosystems",
      "publish_date": null,
      "excerpts": [
        "We present RAD- AI, a backward-compatible extension framework that augments arc42 with eight AI-specific sections and C4 with three diagram extensions, complemented by a systematic EU AI Act Annex IV compliance mapping.\nAI through a structured gap analysis and evaluate it using three complementary analytical methods. Our contributions are:\n• RC1: RAD-AI, the first backward-compatible extension of arc42 (eight section extensions) and C4 (three diagram types) for documenting AI-augmented ecosystems.\nThe C4 model [2] complements arc42 with four-level hierarchical visualization (System Context, Container, Component, and Code) plus supplementary Dynamic, Deployment, and System Landscape diagrams, commonly implemented through Struc- turizr DSL and PlantUML.\n[41], [44] survey AI contributions to software architecture and propose an LLM reference architecture, while Autili et al. [16] propose ethical-aware reference architectures; none extends practitioner documentation frameworks.\nG3 No mapping between EU AI Act Annex IV and arc42/C4 sections.\nG4 No AI-specific Architecture Decision Record templates. G5 No integration of Model/Data Cards into architecture documentation.\nIII. THE RAD-AI FRAMEWORK\nRAD-AI follows three design principles: (1) backward com- patibility : E1–E7 augment existing arc42 sections, E8 adds one new arc42 section, and C4-E1–C4-E3 extend C4 diagrams; al"
      ]
    },
    {
      "url": "https://c4model.com/",
      "title": "Home | C4 model",
      "publish_date": null,
      "excerpts": [
        "Skip to main content\nThe C4 model for visualising software architecture\nThe C4 model is an easy to learn, developer friendly approach to software architecture diagramming:\n1. A set of hierarchical abstractions - software systems , containers , components , and code .\n2. A set of hierarchical diagrams - system context , containers , components , and code .\n3. An additional set of supporting diagrams - system landscape , dynamic , and deployment .\n4. Notation independent .\n5. Tooling independent .\n* Visualising software architecture with the C4 model\n* Recorded at \"Agile on the Beach 2019\", July 2019\n* The C4 model\n* Simon Brown\nAbout this website\nThis is the official website for the “C4 model for visualising software architecture”, written by its creator Simon Brown ."
      ]
    },
    {
      "url": "https://github.com/andminin-engineering/architecture-playbook",
      "title": "GitHub - andminin-engineering/architecture-playbook: Enterprise architecture playbook featuring C4 models, ADRs, architecture patterns, cloud-native design, scalability, observability and engineering governance. · GitHub",
      "publish_date": null,
      "excerpts": [
        "Documentation Index\nCore Architecture\nArchitecture Overview\nC4 Context Diagram\nC4 Container Diagram\nC4 Component Diagram\nArchitecture Patterns\nLayered Architecture\nClean Architecture\nHexagonal Architecture\nMicroservices\nEvent Driven Architecture\nCQRS\nSaga Pattern\nDecision Records and Trade-offs\nADR Index\nTrade-off Analysis\nSecurity, Scalability, Reliability, and Observability\nSecurity Architecture\nScalability Playbook\nReliability Framework\nObservability Playbook\nGovernance and Reviews\nArchitecture Review Checklist\nProduction Readiness Checklist\nDesign Review Template\nArchitecture Governance Model\nOperational Principles\nandminin-engineering/architecture-playbook\nPage: GitHub repository\nURL: https://github.com/andminin-engineering/architecture-playbook\nDescription: Enterprise architecture playbook featuring C4 models, ADRs, architecture patterns, cloud-native design, scalability, observability and engineering governance. - andminin-engineering/architecture-pl...\nStars: 0\nForks: 0\nDefault branch: main\nCreated: 2026-06-07T12:08:39.000Z\nCommits: 1\nTop-level files\ndocs/\nREADME.md\nREADME.md\narchitecture-playbook\nEnterprise architecture knowledge base for transactional platforms built with Java, Spring Boot, microservices, AWS, Docker, PostgreSQL, Redis, RabbitMQ, Terraform, GitHub Actions, and GitLab CI/CD. This repository is structured as an internal playbook used by arc"
      ]
    },
    {
      "url": "https://github.com/AI4EOSC/ai4-architecture",
      "title": "GitHub - AI4EOSC/ai4-architecture: C4 model visualization of the AI4EOSC architecture · GitHub",
      "publish_date": null,
      "excerpts": [
        "AI4EOSC/ai4-architecture\n* Page: GitHub repository\n* URL: https://github.com/AI4EOSC/ai4-architecture\n* Description: C4 model visualization of the AI4EOSC architecture - AI4EOSC/ai4-architecture\n* Stars: 10\n* Forks: 0\n* License: CC-BY-4.0 license\n* Default branch: main\n* Created: 2023-01-11T15:10:01.000Z\n* Commits: 166\nTop-level files\n* .github/workflows/\n* dsl/\n* static-diagrams/\n* .adr-dir\n* .gitignore\n* LICENSE\n* Makefile\n* README.md\nREADME.md\nAI4EOSC Architecture repository\nDOI\nThis repository contains the AI4EOSC project architecture diagrams. An online read-only version is available here .\nInstructions\nThe AI4EOSC architecture is based on the C4 model , follow the C4 guidelines to record changes into the architecture diagrams.\nRecord decisions\nUse adr-tools to record significant architecture changes:\nadr new \"Descriptive title\"\ngit add dsl/decisions/\ngit commit ...\nGenerating the architecture\nTo view the interactive diagrams (for both AI4EOSC and the DEEP legacy architecture):\nmake\nIn either case, browse to http://127.0.0.1:8080 to see what is generated.\nTo validate (the AI4EOSC architecture):\nmake validate\nTo export the static diagrams in HTML format:\nmake generate-static\nTo export in PNG/SVG:\nEXPORT_FORMAT=png make generate-static"
      ]
    },
    {
      "url": "https://help.aliyun.com/en/api-gateway/ai-gateway/product-overview/new-feature-release-notes-ai-gateway",
      "title": "\n    Release notes-API Gateway(API Gateway)-阿里云帮助中心\n  ",
      "publish_date": "2026-07-31",
      "excerpts": [
        "* Type | Description\n* New feature | The multi-tenant Serverless edition is now in public preview, available in Enterprise and Standard editions. Starting from 0 cost, the service is free to use during the public preview period.\n* Added model asset management, supporting model metadata and provider management, along with Credits quota management for models.\n* FinOps now supports custom period quotas and Credits-based quota management.\n* Custom Model/Agent APIs now support HTTP rewrite.\n* AI Gateway now supports integration with Global Accelerator (GA).\n* Optimization | AI Guardrails now supports parallel detection configuration.\n* Gateway access points can now be removed.\n* AI security protection has been upgraded to AI Guardrails.\n* Supports setting Web search to disabled by default, allowing manual enablement through client parameters.\nJune 2026\n* Type | Description\n* New feature | * FinOps with consumer-level Token quotas.\n* Consumer groups with group-level API authorization.\n* Qwen Cloud and Bailian Token Plan integration.\n* Text-to-image/video models (e.g., KlingAI).\n* Vertex AI Claude via OpenAI and Anthropic protocols.\n* Multi-key failover for higher invocation reliability. |\nMay 2026\n* New feature | AI Gateway adds FinOps consumer quota capability, supporting instance-level quota settings for consumers. Token Quota (set limits based on the number of tokens "
      ]
    }
  ],
  "warnings": null,
  "metadata": null,
  "session_id": "session_34327333d0ac56962b4d834c0e2507f9"
}
```

---

### 🤖 Assistant — 2026-09-14 05:53:27

> Got rich material. Have enough to write the deliverable. User wants under 1500 words with quoted sources. This is going to be a substantial research doc - that's the deliverable, not chat fluff. Caveman rules say persisted outside chat = normal prose, but this is delivered inline. Still, the substance is technical research with quotes - I should preserve quote accuracy and technical terms. Let me strike a balance: caveman style for framing/narration, full quotes for sources, accurate technical terms.
> 
> Let me compose. Target ~1400 words. 8 categories × 4 items each.

# Production-Readiness Criteria for Self-Hosted AI Gateway Stack (2025-2026)

## 1. Observability

Metrics, traces, logs = table stakes. LLM work adds token economics, semantic quality, and streaming latency.

1. **Standardize on OTel GenAI semantic conventions.** Emit `gen_ai.client.token.usage` (with `gen_ai.token.type` = input/output/total), `gen_ai.server.request.duration`, `gen_ai.server.time_to_first_token`, `gen_ai.client.operation.duration`. Envoy AI Gateway exposes these in Prometheus by default — "Envoy AI Gateway chooses to stay close to standards… uses OpenInference" (aigateway.envoyproxy.io). Don't invent custom label namespaces; tools like Phoenix, Datadog, Aspire, Grafana already parse these.
2. **Health endpoints with depth.** `/healthz` (liveness), `/readyz` (deps ok — Postgres, Redis, each upstream provider API), `/metrics` (Prometheus). Datadog: "use gateway-level circuit breakers to temporarily stop routing to a provider that's failing, preventing cascading timeouts. Pair this with load balancing across multiple deployments of the same model… to stay under per-deployment rate limits" (datadoghq.com).
3. **Alert on LLM-specific signals, not HTTP alone.** Traces show "semantic failures occur when the AI fails to understand or produce the correct answer… These issues don't show up as HTTP errors" (Envoy AI Gateway blog). Alert on: p95 TTFT regression, token-cost spike per tenant, finish-reason distribution drift, eval-score regression.
4. **Distributed tracing across gateway + agent + sidecars.** Single trace must span gateway ingress → provider call → eval harness → response. Record prompt/response content via `gen_ai.input.messages` / `gen_ai.output.messages` only when opt-in (PII risk).
5. **Log aggregation with PII redaction.** Structured JSON (model, tenant, tokens, latency, request_id, trace_id). Redact `gen_ai.system_instructions` and message bodies by default: "By default, no prompt content or tool arguments are captured with GenAI telemetry, as these can contain sensitive data" (opentelemetry.io).

## 2. Reliability

Treat each provider, sidecar, and the orchestrator as independent failure domains.

1. **Circuit breakers per upstream provider + per model.** Datadog (above) and Vercel both call this out — "ensures availability when a provider fails, avoiding low rate limits and providing consistent reliability" (vercel.com/blog, Aug 2025 GA).
2. **Multi-provider failover with route ordering + retries.** Define ordered route per model alias; on5xx, 429, or timeout, advance to next provider. Exponential backoff with jitter, max-retries-before-failover = 2.
3. **Health-check every dependency at boot and continuously.** Sidecars (vLLM, Ollama, embedder, eval worker) need deep readiness — model loaded, weights readable, warm cache hit in <N ms. Container restart policy = `on-failure` with backoff cap.
4. **Define SLOs explicitly.** Per-endpoint availability (e.g., 99.9% for `/v1/chat/completions` non-streaming, 99.5% streaming), latency (p95 TTFT < 800 ms, p95 full completion < 30 s), error budget burn alerts.
5. **Backup + restore for stateful stores.** Eval results, prompt templates, tenant configs, rate-limit state → Postgres with PITR; restore drill quarterly.

## 3. Security

OWASP LLM Top 10 (2025) + standard infra hygiene.

1. **Centralize secrets — never env vars in repo.** HashiCorp Vault with KMS backend (AWS KMS / GCP KMS) for envelope encryption and lifecycle: "Rotating a key creates a new key version that contains new key material. The key will be rotated in both Vault and the KMS provider" (developer.hashicorp.com). Rotation scheduled, automated, audited.
2. **Per-tenant virtual API keys with scoping.** VoidLLM: "Virtual keys with org/team/user scoping and RBAC" (github.com/voidmind-io/voidllm). Each tenant gets a key bound to: model allowlist, token budget, RPM/TPM, allowed IPs.
3. **OWASP LLMSVS v2.0 compliance.** At minimum L2: "Identify any components that store secrets, like API keys… ensure the secure handling of these credentials" (owasp.org). Network-segregate self-hosted LLMs; prefer SafeTensors over PyTorch Pickle ("prefer secure model formats such as SafeTensors over formats that use unsafe serialization" — OWASP).
4. **Rate-limit + abuse protection at gateway.** Kong: "rate limiting to prevent brute-force extraction attempts" (konghq.com). Token-bucket per key, prompt-size cap, concurrent-stream cap.
5. **mTLS between gateway ↔ sidecars, TLS1.3 externally.** Short-lived certs (cert-manager + SPIFFE/SPIRE for workload identity). Audit log every key use, config change, admin action.

## 4. Operations

Run it like the production service it is.

1. **Runbooks per top-5 incident class.** Harness AI SRE: "A runbook is a sequence of actions that runs automatically when triggered… A typical runbook for a major incident might open a Slack channel, post an update, start a Zoom bridge, notify the on-call engineers, and page the service team" (developer.harness.io). Top5 for AI gateway: provider-wide outage, eval-harness backlog, prompt-injection spam, quota exhaustion storm, sidecar OOM.
2. **On-call rotation + escalation tree.** Primary/secondary on-call, escalation to platform team after 30 min. Tie alerts to deploy events: "Deploys, flags, config changes, and infrastructure events are automatically correlated and attached at alert time" (Harness).
3. **Change management: PR + review + staged roll-out.** Every config or model-route change = PR with2 reviewers; chatops in `#deploys`; automated change-correlation in incident timeline.
4. **Rollback procedure documented and rehearsed.** One-command rollback to previous gateway version; blue/green on Kubernetes; previous artifact retained30 days.
5. **Postmortems blameless, action-tracked.** Every Sev1/Sev2 → postmortem within 5 business days, action items with owners + dates in tracker.

## 5. Testing

LLM systems need both classical and semantic test layers.

1. **Coverage thresholds.** Unit ≥ 80% on routing/policy/quotas; integration covers every provider route; E2E exercises auth → gateway → upstream → eval.
2. **Contract tests against each provider.** Pin to OpenAI/Anthropic/Ollama schema versions; reject unexpected fields; replay recorded responses against gateway to detect drift. Pairs with "OpenAI-compatible API endpoints now supported in AI Gateway" model (vercel.com).
3. **Eval harness as first-class CI stage.** Golden-set prompts with expected behavior + LLM-as-judge + deterministic metrics. Block release on regression > threshold.
4. **Chaos testing quarterly.** Kill sidecars mid-request, drop10% traffic to a provider, inject 500 ms latency, expire provider creds. Verify circuit breakers open, failovers trigger, SLOs still met.
5. **Load test to 2× expected peak.** k6/Locust hitting streaming + non-streaming endpoints; assert p95, p99, error rate, token throughput per node.

## 6. Release

Ship without breaking tenants.

1. **SemVer + deprecation policy.** Minor = additive; major = breaking (URL, header, response shape). Deprecations announced ≥ 90 days before removal, feature-flagged first.
2. **CI/CD pipeline gates.** Lint → unit → contract → integration → eval → security scan (Trivy/Snyk, gitleaks) → image build → staging deploy → smoke. No manual gate to prod.
3. **Feature flags for risky changes.** LaunchDarkly: "Using feature flags to deploy code without releasing it publicly is the original meaning of the phrase 'dark launching'" (launchdarkly.com). Flags for new providers, model swaps, routing algo changes.
4. **Canary deploys 5% → 25% → 100%.** "A canary launch allows you to roll out a feature slowly, and measure the reaction from real user 'canaries', looking for early indicators of danger" (LaunchDarkly). Auto-rollback on SLO burn.
5. **Signed, immutable artifacts.** Cosign-signed container images; SBOM generated per build; provenance via SLSA L3.

## 7. Documentation

Docs that survive the next on-call rotation.

1. **README quality bar.** One-paragraph problem statement, one-command install, one-command run,2-4 capability sections, license, status badge. Validate on every PR.
2. **C4 diagrams for the whole stack.** C4 model: "hierarchical abstractions — software systems, containers, components, and code" + "system landscape, dynamic, and deployment" diagrams (c4model.com). Maintain Level1 (context) + Level 2 (containers) always; Level 3 only where it adds value.
3. **ADRs for every consequential decision.** Use adr-tools / Nygard format. "Record decisions: adr new 'Descriptive title'" (github.com/AI4EOSC/ai4-architecture). Reference in PRs that implement the decision.
4. **API reference auto-generated from OpenAPI.** Single source of truth; published version-tagged. Include auth, rate-limit headers, error schema.
5. **Architecture includes AI-specific extensions.** RAD-AI paper notes current frameworks lack "AI-specific arc42 sections for model lifecycle, data pipelines, or drift… No C4 diagram types for ML components or non-determinism boundaries" (arxiv.org/html/2603.28735v1). Document model lifecycle, eval pipeline, drift handling as first-class.

## 8. Multi-Tenancy

Isolation + quotas + audit, or it isn't multi-tenant.

1. **Namespace isolation per tenant.** Alibaba AI Gateway: "multi-tenant Serverless edition… Consumer groups with group-level API authorization" (alibabacloud.com). Kubernetes namespace per tenant tier; network policies enforce east-west deny-by-default.
2. **Quota per tenant: RPM, TPM, daily tokens, monthly $.** Enforce at gateway, not in app — "Rate limits + token budgets enforced by the proxy at every level" (VoidLLM). Return 429 with `Retry-After` + `X-Quota-*` headers.
3. **Per-tenant logging with field-level redaction.** Tenant ID on every log line, prompt/response bodies tagged + opt-in per tenant; GDPR/SOC2 right-to-delete flows.
4. **Tenant-scoped RBAC + audit.** Admin role per tenant; cross-tenant access blocked at API + DB row-level security. Every key-create, config-change, admin action logged with actor + IP + timestamp.
5. **No cross-tenant data leak paths.** Eval results, caching (semantic cache keys), analytics — all carry tenant ID and filtered at query time.

---

**Sources:** aigateway.envoyproxy.io/docs · opentelemetry.io/blog/2026/genai-observability · datadoghq.com/blog/ai-gateways-best-practices · vercel.com/blog/ai-gateway-is-now-generally-available · developer.hashicorp.com/vault/docs/secrets/key-management · owasp.org/www-project-llm-verification-standard/LLMSVS-v2.0 · konghq.com/blog/engineering/owasp-top-10-ai-and-llm-guide · github.com/voidmind-io/voidllm · github.com/teasru/Secure-LLM-Gateway · launchdarkly.com/blog/canary-launches-how-and-why-to-canary-release · developer.harness.io/ai-sre/new-to-ai-sre/overview · c4model.com · github.com/AI4EOSC/ai4-architecture · arxiv.org/html/2603.28735v1 (RAD-AI) · alibabacloud.com AI Gateway release notes · api7.ai/learning-center/ai-gateway-guide.

---
