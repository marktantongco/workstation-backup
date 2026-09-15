#!/usr/bin/env bash
# DESC: :8787 returns 502 "Failed to connect to upstream API: name resolution" — headroom container has stale DNS
# STEPS:
#   1. Confirm the 502 body is a DNS failure (NOT freebuff-unified — the gateway lives on :18080)
#   2. Repair /etc/resolv.conf inside the headroom container
#   3. Verify DNS inside the container and that :8787 serves a non-502 response
# CONTEXT (2026-09-16 incident):
#   - :8787 is headroom (uvicorn, Docker container "headroom-default", host network,
#     restart=unless-stopped). freebuff-unified is :18080 — a :8787 502 is ALWAYS headroom.
#   - Docker copies the host's /etc/resolv.conf into a host-network container only at
#     CREATION. This container was created while the host still pointed at the
#     systemd-resolved stub (127.0.0.53, which later stopped listening), so the container
#     kept a dead resolver -> "[Errno -3] Temporary failure in name resolution" -> 502.
#   - `docker restart` does NOT re-copy resolv.conf. A container RECREATION heals this
#     permanently (the host now uses the uplink file: nameserver 192.168.1.1). After any
#     recreation this runbook becomes a no-op verification.
#   - Note: `--dns` flags are ignored for host-network containers, so recreation (not
#     flags) is the durable fix path.

set -uo pipefail

echo "=== Step 1: confirm the 502 is headroom DNS (not the gateway) ==="
body=$(curl -s -m 8 http://127.0.0.1:8787/ || true)
echo "$body" | head -c 300; echo
if echo "$body" | grep -qi 'name resolution'; then
    echo "-> DNS failure confirmed"
elif echo "$body" | grep -qi 'connection_error\|502'; then
    echo "-> connection_error without name-resolution text: inspect headroom backend target"
fi

cid=$(sudo docker ps --format '{{.ID}} {{.Names}}' | awk 'tolower($2) ~ /headroom/ {print $1; exit}')
[[ -n "$cid" ]] || { echo "headroom container not found — is it running? (docker ps)"; exit 1; }
echo "container: $cid"

echo
echo "=== Step 2: repair DNS inside container ==="
sudo docker exec "$cid" sh -c 'printf "nameserver 192.168.1.1\nnameserver 1.1.1.1\noptions edns0 trust-ad\n" > /etc/resolv.conf && cat /etc/resolv.conf'
sudo docker exec "$cid" python3 -c "import socket; print('DNS OK:', socket.gethostbyname('api.anthropic.com'))" 2>&1 \
  || sudo docker exec "$cid" python -c "import socket; print('DNS OK:', socket.gethostbyname('api.anthropic.com'))" 2>&1

echo
echo "=== Step 3: verify :8787 ==="
code=$(curl -s -m 10 -o /tmp/8787_body.out -w '%{http_code}' http://127.0.0.1:8787/)
echo "GET / -> HTTP $code (502 = still broken; 421/401/200 = healthy, bare / is just not a route)"
head -c 200 /tmp/8787_body.out; echo
code2=$(curl -s -m 15 -o /dev/null -w '%{http_code}' -X POST http://127.0.0.1:8787/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"gpt-4o-mini","messages":[{"role":"user","content":"ping"}],"max_tokens":5}')
echo "POST /v1/chat/completions (no key) -> HTTP $code2 (expect 401 upstream auth error = request left the box = fixed)"
