#!/usr/bin/env bash
# freebuff-e2e-health — daily end-to-end health check across all free models
# through both Go proxies, with automatic JA3/thermoptic escalation.
#
# Design (2026-09-14, see workstation-backup wiki 12/13):
#   1. Discover available free models from the trefeon container (:3457/v1/models,
#      no auth, live registry). Falls back to a static list if it is down.
#   2. For each (proxy, model): POST one small chat completion. Classify:
#        200                               → OK
#        429                               → QUOTA (upstream account state)
#        403 free_mode_invalid_agent_model → PERM (registry/agent pairing issue)
#        403 anything else                 → FINGERPRINT (upstream client gate) → escalate
#        400                               → MODEL (retired upstream / bad request)
#        timeout / conn refused            → DOWN (local service or egress path)
#   3. Escalation (at most once per run): inject HTTPS_PROXY=http://127.0.0.1:31280
#      (thermoptic Chrome-cloaked HTTP CONNECT egress) into each service's env
#      source, restart, re-verify. Success → keep (persisted in $STATE_DIR/escalated,
#      next runs keep the escalated egress). Failure → revert to direct egress.
#      Manual revert: freebuff-e2e-health.sh --revert
#   4. Writes $STATE_DIR/status.json + appends $STATE_DIR/health.log. Exit 0 when
#      every model is OK/QUOTA; exit 1 otherwise.
#
# Runs as root via systemd (reads key files directly; no sudo inside).

set -u

STATE_DIR=/var/lib/freebuff-e2e-health
LOG="$STATE_DIR/health.log"
STATUS="$STATE_DIR/status.json"
THERMOPTIC_PROXY="http://127.0.0.1:31280"
RUN_TIMEOUT=45
MODEL_FALLBACK="deepseek/deepseek-v4-flash mimo/mimo-v2.5 z-ai/glm-5.3-flash"

OPT_ENV=/opt/freebuff/go/freebuff-proxy/.env
UNIFIED_ENV=/etc/freebuff-unified/probe-env
UNIFIED_CFG=/home/x3/freebuff-unified/config.yaml
UNIFIED_UNIT=freebuff-unified
PROXY_UNIT=freebuff-proxy

mkdir -p "$STATE_DIR"
ts() { date -u +%Y-%m-%dT%H:%M:%SZ; }
log() { echo "[$(ts)] $*" | tee -a "$LOG"; }

# ── --revert ───────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--revert" ]]; then
  log "revert: removing thermoptic egress from both services"
  sed -i '/^HTTPS_PROXY=/d; /^NO_PROXY=/d' "$OPT_ENV" 2>/dev/null
  sed -i '/^HTTPS_PROXY=/d; /^NO_PROXY=/d' "$UNIFIED_ENV" 2>/dev/null
  rm -f "$STATE_DIR/escalated"
  systemctl restart "$PROXY_UNIT" "$UNIFIED_UNIT"
  sleep 8
  log "revert: services restarted on direct egress (proxy=$(systemctl is-active $PROXY_UNIT) unified=$(systemctl is-active $UNIFIED_UNIT))"
  exit 0
fi

# ── credentials ────────────────────────────────────────────────────────────
PK=$(grep '^FREEBUFF_PROXY_API_KEY=' "$OPT_ENV" 2>/dev/null | sed 's/^FREEBUFF_PROXY_API_KEY=//' || true)
# GK: first key from unified's server.api_keys list
GK=$(python3 -c "import yaml
try:
    d = yaml.safe_load(open('$UNIFIED_CFG'))
    keys = (d.get('server') or {}).get('api_keys') or (d.get('auth') or {}).get('api_keys') or []
    print(keys[0] if keys else '')
except Exception:
    pass" 2>/dev/null || true)

# ── model discovery ────────────────────────────────────────────────────────
MODELS=$(curl -sS -m 8 http://127.0.0.1:3457/v1/models 2>/dev/null \
  | python3 -c "import json,sys
try:
    d=json.load(sys.stdin)
    print(' '.join(m['id'] for m in d['data'] if m.get('available')))
except Exception:
    pass" 2>/dev/null)
if [[ -z "${MODELS:-}" ]]; then
  MODELS="$MODEL_FALLBACK"
  log "WARN: model discovery failed, using fallback list"
fi

declare -A RESULT
declare -A LATENCY
failures_count=0   # every cell not OK/QUOTA increments this

# fire_request <base-url> <key> <model> <outfile> → echoes HTTP code
fire_request() {
  local url="$1" key="$2" model="$3" out="$4"
  curl -sS -m "$RUN_TIMEOUT" -o "$out" -w '%{http_code}' \
    -X POST "$url/v1/chat/completions" \
    -H "Authorization: Bearer $key" -H "Content-Type: application/json" \
    -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"Reply with exactly: HEALTH-OK\"}],\"max_tokens\":60}" \
    2>/dev/null
}

classify() {  # classify <http-code> <outfile> → verdict on stdout
  local code="$1" body
  body=$(head -c 600 "$2" 2>/dev/null || true)
  case "$code" in
    200) echo OK ;;
    429) echo QUOTA ;;
    400) echo MODEL ;;
    403)
      if grep -q "free_mode_invalid_agent_model" <<<"$body"; then echo PERM
      else echo FINGERPRINT; fi ;;
    000) echo DOWN ;;
    401) echo AUTH ;;
    *)   echo "HTTP_$code" ;;
  esac
}

# ── escalation ─────────────────────────────────────────────────────────────
escalate() {
  if [[ -f "$STATE_DIR/escalated" ]]; then
    log "escalation: already active (thermoptic egress), not re-flipping"
    return 0
  fi
  log "ESCALATION: fingerprint block detected — routing both services through thermoptic ($THERMOPTIC_PROXY)"
  local probe
  probe=$(curl -sS -m 12 -o /dev/null -w '%{http_code}' -x "$THERMOPTIC_PROXY" https://www.codebuff.com/api/v1/session 2>/dev/null)
  if [[ "$probe" != "301" && "$probe" != "200" && "$probe" != "401" && "$probe" != "307" ]]; then
    log "escalation: thermoptic egress unhealthy (probe=$probe) — aborting flip"
    return 1
  fi
  grep -q '^HTTPS_PROXY=' "$OPT_ENV" 2>/dev/null || printf '\n# Added by freebuff-e2e-health (JA3 escalation 2026-09-14)\nHTTPS_PROXY=%s\nNO_PROXY=127.0.0.1,localhost\n' "$THERMOPTIC_PROXY" >> "$OPT_ENV"
  grep -q '^HTTPS_PROXY=' "$UNIFIED_ENV" 2>/dev/null || printf '\n# Added by freebuff-e2e-health (JA3 escalation)\nHTTPS_PROXY=%s\nNO_PROXY=127.0.0.1,localhost\n' "$THERMOPTIC_PROXY" >> "$UNIFIED_ENV"
  systemctl restart "$PROXY_UNIT" "$UNIFIED_UNIT"
  sleep 10
  local model code verdict
  model=${MODELS%% *}
  code=$(fire_request "http://127.0.0.1:1455" "$PK" "$model" "$STATE_DIR/.esc-check")
  verdict=$(classify "$code" "$STATE_DIR/.esc-check")
  if [[ "$verdict" == "OK" || "$verdict" == "QUOTA" ]]; then
    date -u +%s > "$STATE_DIR/escalated"
    log "escalation: SUCCESS via thermoptic ($model → $code/$verdict); keeping escalated egress"
    return 0
  fi
  log "escalation: FAILED ($model → $code/$verdict) — reverting to direct egress"
  sed -i '/^HTTPS_PROXY=/d; /^NO_PROXY=/d; /Added by freebuff-e2e-health/d' "$OPT_ENV"
  sed -i '/^HTTPS_PROXY=/d; /^NO_PROXY=/d; /Added by freebuff-e2e-health/d' "$UNIFIED_ENV"
  systemctl restart "$PROXY_UNIT" "$UNIFIED_UNIT"
  sleep 8
  return 1
}

# ── main pass ──────────────────────────────────────────────────────────────
log "=== health run start (models: $MODELS) ==="
for model in $MODELS; do
  for entry in ":1455|$PK" ":18080|$GK"; do
    port=${entry%%|*}; key=${entry#*|}
    out="$STATE_DIR/.resp"
    start=$(date +%s%N)
    code=$(fire_request "http://127.0.0.1$port" "$key" "$model" "$out")
    ms=$(( ( $(date +%s%N) - start ) / 1000000 ))
    verdict=$(classify "$code" "$out")
    RESULT["$port|$model"]="$verdict"
    LATENCY["$port|$model"]="$ms"
    log "proxy=$port model=$model http=$code latency=${ms}ms verdict=$verdict"
    if [[ "$verdict" == "FINGERPRINT" ]]; then
      failures_count=$((failures_count + 1))
      if escalate; then
        code=$(fire_request "http://127.0.0.1$port" "$key" "$model" "$out")
        verdict=$(classify "$code" "$out")
        RESULT["$port|$model"]="$verdict"
        log "proxy=$port model=$model RETEST-after-escalation http=$code verdict=$verdict"
      fi
    elif [[ "$verdict" != "OK" && "$verdict" != "QUOTA" ]]; then
      failures_count=$((failures_count + 1))
    fi
  done
done

# ── status.json ────────────────────────────────────────────────────────────
{
  echo "{"
  echo "  \"timestamp\": \"$(ts)\","
  echo "  \"escalated\": $( [[ -f $STATE_DIR/escalated ]] && echo true || echo false ),"
  first=1
  for model in $MODELS; do
    for port in ":1455" ":18080"; do
      v="${RESULT[$port|$model]:-MISSING}"; l="${LATENCY[$port|$model]:-0}"
      [[ $first -eq 0 ]] && echo ","
      first=0
      printf '  "%s|%s": {"verdict": "%s", "latency_ms": %s}' "$port" "$model" "$v" "$l"
    done
  done
  echo ""
  echo "}"
} > "$STATUS"

# ── exit code: 0 iff every cell is OK or QUOTA ─────────────────────────────
fail=0
if [[ $failures_count -gt 0 ]]; then fail=1; fi
log "=== health run end (fail=$fail; cells-failing=$failures_count; status in $STATUS) ==="
exit "$fail"
