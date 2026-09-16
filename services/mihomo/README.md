# mihomo fixes (2026-09-16)

Live config intentionally NOT mirrored here (285 nodes carry subscriber credentials).
Re-apply these diffs on a fresh restore:

1. Health checks must validate TLS, else port-80-only nodes pass while HTTPS breaks:
   `url: https://www.gstatic.com/generate_204` (was http://cp.cloudflare.com/generate_204)
2. `GrokRegister` proxy group must be `type: select` — `fallback` auto-reselects the
   first healthy node and silently overrides manual switches used by registration rotation.
3. External controller: `external-controller: 127.0.0.1:9090` + `secret:` (random 32-hex),
   consumed by grok-register/clash_rotator.py via CLASH_* env vars in grok-register/.env.
4. grok-register/.env: GROK_PROXY=http://127.0.0.1:7898, CLASH_PROXY_GROUP=GrokRegister.
