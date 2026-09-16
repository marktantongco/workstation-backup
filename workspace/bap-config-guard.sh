#!/usr/bin/env bash
# bap-config-guard.sh — revert-detection for BlacklistedAIProxy production config.
# The BAP admin Web UI can save stale in-memory settings over configs/config.json,
# silently reverting the gateway key to "123456" and resurrecting the dead PROXY_URL.
# This guard re-applies the canonical hardening and restarts the service if drifted.
# No secrets in this file: the key is read at runtime from the canonical token chain.

set -u
CONFIG="/home/x3/workspace/BlacklistedAIProxy/configs/config.json"
TOKENS="/home/x3/.env-tokens/ai-agent-tokens-full.env"
LOG="/home/x3/workspace/BlacklistedAIProxy/configs/config-guard.log"

KEY=$(grep -oP '^BAP_GATEWAY_KEY=\K.*' "$TOKENS" 2>/dev/null | head -1)
if [ -z "$KEY" ] || [ ${#KEY} -ne 64 ]; then
  echo "$(date '+%F %T') ERROR: canonical BAP_GATEWAY_KEY missing/invalid" >> "$LOG"
  exit 1
fi

need_fix=0
python3 - "$CONFIG" "$KEY" <<'EOF' || need_fix=1
import json, sys
c = json.load(open(sys.argv[1]))
want_key, want = sys.argv[2], "127.0.0.1"
if c.get("REQUIRED_API_KEY") != want_key: sys.exit(1)
if c.get("HOST") != want: sys.exit(1)
if c.get("PROXY_URL"): sys.exit(1)
EOF

if [ "$need_fix" = "1" ]; then
  cp "$CONFIG" "${CONFIG}.bak_guard_$(date +%s)"
  python3 - "$CONFIG" "$KEY" <<'EOF'
import json, sys
p, key = sys.argv[1], sys.argv[2]
c = json.load(open(p))
c["REQUIRED_API_KEY"] = key
c["HOST"] = "127.0.0.1"
c.pop("PROXY_URL", None)
json.dump(c, open(p, "w"), indent=2, ensure_ascii=False)
EOF
  chmod 600 "$CONFIG"
  systemctl restart blacklisted-api
  echo "$(date '+%F %T') FIXED: reverted config drift detected, hardening re-applied + service restarted" >> "$LOG"
fi
