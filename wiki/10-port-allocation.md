# 10 — Port Allocation

## Complete Port Map

| Port | Service | Bind Address | Protocol | Status |
|------|---------|--------------|----------|--------|
| 53 | DNS (dnsmasq) | 10.0.3.1, 127.0.0.54, 127.0.0.53 | UDP/TCP | System |
| 1455 | CDP Proxy Interceptor | 127.0.0.1 | HTTP | Active |
| 1457 | CDP Proxy Interceptor | 0.0.0.0 | HTTP | Active |
| 1234 | Thermoptic (MITM) | 127.0.0.1 | HTTPS | Active |
| 14111 | Chrome (Thermoptic) | 127.0.0.1 | HTTP | Active |
| 2019 | Headroom | 127.0.0.1 | HTTP | Active |
| 3000 | Grafana | * | HTTP | Active |
| 3001 | BlacklistedAIProxy | 0.0.0.0 | HTTP | Active |
| 3002 | AIClient2API | 0.0.0.0 | HTTP | Active |
| 3030 | OpenCode | * | HTTP | Active |
| 3100 | AIClient2API (master) | * | HTTP | Active |
| 3101 | BlacklistedAIProxy (master) | 127.0.0.1 | HTTP | Active |
| 3103 | KiroProxy | * | HTTP | Active |
| 3113 | KiroProxy (master) | 127.0.0.1 | HTTP | Active |
| 3200 | KiroProxy (alt) | 0.0.0.0 | HTTP | Active |
| 3457 | OWL API | 0.0.0.0 | HTTP | Active |
| 5000 | PhantomSignal | 0.0.0.0 | HTTP | Active |
| 6333 | Qdrant | 0.0.0.0 | HTTP | Active |
| 6334 | Qdrant (gRPC) | 0.0.0.0 | gRPC | Active |
| 7897 | AGPX-Relay | 0.0.0.0 | HTTP | Active |
| 8000 | Autoclaw | 127.0.0.1 | HTTP | Active |
| 8001 | Autoclaw (alt) | 127.0.0.1 | HTTP | Active |
| 8080 | KiroProxy / grokbuild | * | HTTP | Active |
| 8081 | Thermoptic | 0.0.0.0 | HTTP | Active |
| 8091 | Headroom (alt) | 127.0.0.1 | HTTP | Active |
| 8443 | Thermoptic (TLS) | * | HTTPS | Active |
| 8648 | OWL | 0.0.0.0 | HTTP | Active |
| 8787 | Freebuff | 127.0.0.1 | HTTP | Active |
| 8788 | Freebuff (alt) | 0.0.0.0 | HTTP | Active |
| 9000 | StepUp | 127.0.0.1 | HTTP | Active |
| 9090 | Prometheus | 0.0.0.0 | HTTP | Active |
| 9091 | OWL Prometheus | * | HTTP | Active |
| 9092 | Grafana (alt) | 127.0.0.1 | HTTP | Active |
| 9093 | Grafana (alt2) | 127.0.0.1 | HTTP | Active |
| 9094 | OWL | 0.0.0.0 | HTTP | Active |
| 9095 | OWL (alt) | 0.0.0.0 | HTTP | Active |
| 9222 | Deno CDP | 127.0.0.1 | HTTP | Active |

## Reserved for Future

| Port | Planned Service | Notes |
|------|----------------|-------|
| 8099 | grok_proxy.py (backup) | Only if grokbuild-proxy unavailable |
| 31000 | AutoClaw | Currently active |
| 11434 | Ollama | Local LLM inference |

## Conflict Rules

1. **Port 3000**: Grafana only. Never assign to another service.
2. **Port 3001/3101**: BlacklistedAIProxy. Never assign to another service.
3. **Port 3002/3100**: AIClient2API. Never assign to another service.
4. **Port 8080**: KiroProxy or grokbuild-proxy (one at a time).
5. **Port 1234**: Thermoptic only. Never assign to another service.
6. **Port 5000**: PhantomSignal only. Never assign to another service.
7. **Loopback-only ports**: Must bind to 127.0.0.1, never 0.0.0.0.
8. **Public ports**: Only services that need external access bind to 0.0.0.0.

## Detection

```bash
# Check port conflicts
ss -tlnp | awk '{print $4}' | sort -t: -k2 -n | uniq -d

# Check all listening ports
ss -tlnp | grep -v "^State" | wc -l
```
