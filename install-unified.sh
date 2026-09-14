#!/usr/bin/env bash
# install-unified.sh — COMPLETE workstation restore (v2.0).
#
# Stages 1–8: delegates to ./install.sh (opencode configs → env templates →
#             gateway config → secret scanner → systemd units → pnpm configs →
#             history exporter → ops daemons).
# Stage  9  : daily E2E health check (script + systemd service/timer, 07:15 UTC).
# Stage 10  : thermoptic JA3 escalation wiring (loopback :31280 publish).
# Stage 11  : Go proxy source restore + optional rebuild/restart.
#
# Idempotent: safe to re-run; existing files are timestamp-backed up.
# Run as the regular user (sudo is invoked internally where needed).

set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
H="${HOME}"

log()  { printf '\033[1;32m[unified]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; exit 1; }

# True only when systemd is PID 1 and usable (containers/chroot: false).
have_systemd() { command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; }

[[ "$(id -u)" -eq 0 ]] && die "Run as the regular user (sudo is invoked internally where needed)."
[[ -d "$BACKUP_DIR/opencode" ]] || die "Run this script from the repo root: ./install-unified.sh"

# ── Stages 1–8: classic installer ──────────────────────────────────────────
log "Stages 1–8: running classic installer (configs, env, units, ops)…"
bash "$BACKUP_DIR/install.sh"

# ── Stage 9: daily E2E health check ────────────────────────────────────────
log "9/11 Installing daily E2E health check…"
sudo install -d -m 755 /opt/freebuff/e2e-health
sudo install -m 755 "$BACKUP_DIR/services/e2e-health/freebuff-e2e-health.sh" \
  /opt/freebuff/e2e-health/freebuff-e2e-health.sh
sudo install -d -m 755 /var/lib/freebuff-e2e-health
for u in freebuff-e2e-health.service freebuff-e2e-health.timer; do
  [[ -f "$BACKUP_DIR/services/systemd/$u" ]] \
    && sudo install -m 644 "$BACKUP_DIR/services/systemd/$u" "/etc/systemd/system/$u" \
    || warn "no $u in backup — skipping"
done
if have_systemd; then
  sudo systemctl daemon-reload
  sudo systemctl enable --now freebuff-e2e-health.timer >/dev/null 2>&1 || true
  systemctl list-timers freebuff-e2e-health.timer --no-pager 2>/dev/null | head -3 || true
else
  warn "systemd not running — units installed; enable after boot:"
  warn "  sudo systemctl daemon-reload && sudo systemctl enable --now freebuff-e2e-health.timer"
fi
warn "health check reads live keys from /opt/freebuff/go/freebuff-proxy/.env and"
warn "  /home/$USER/freebuff-unified/config.yaml — restore those on the target host"
warn "  (or run the check manually once: sudo /opt/freebuff/e2e-health/freebuff-e2e-health.sh)"

# ── Stage 10: thermoptic JA3 escalation wiring ─────────────────────────────
log "10/11 Wiring thermoptic escalation (loopback :31280)…"
THERMO_DIR="$H/workspace/thermoptic"
if [[ -f "$THERMO_DIR/docker-compose.yml" ]]; then
  if [[ ! -f "$THERMO_DIR/docker-compose.override.yml" ]]; then
    cp "$BACKUP_DIR/services/thermoptic/docker-compose.override.yml" \
       "$THERMO_DIR/docker-compose.override.yml"
    log "  compose override installed (publishes proxyrouter to 127.0.0.1:31280)"
  else
    log "  compose override already present"
  fi
  if command -v docker >/dev/null 2>&1 && sudo docker ps --format '{{.Names}}' | grep -q thermoptic-proxyrouter; then
    ( cd "$THERMO_DIR" && sudo docker compose up -d proxyrouter >/dev/null 2>&1 ) || warn "proxyrouter recreate failed"
    code=$(curl -sS -m 12 -o /dev/null -w '%{http_code}' -x http://127.0.0.1:31280 https://www.codebuff.com/api/v1/session 2>/dev/null || true)
    case "$code" in
      200|301|307|401) log "  thermoptic egress verified (probe=$code via :31280)" ;;
      *) warn "thermoptic :31280 probe returned '$code' — escalation path may need attention" ;;
    esac
  else
    warn "thermoptic containers not running — start them (docker compose up -d in $THERMO_DIR)"
  fi
else
  warn "$THERMO_DIR not found — skip escalation wiring (health check degrades gracefully)"
fi

# ── Stage 11: Go proxy source restore + optional rebuild ───────────────────
log "11/11 Restoring Go proxy sources…"
restore_tree() {  # restore_tree <src-in-backup> <dst-dir>
  local src="$1" dst="$2"
  [[ -d "$dst" ]] || { warn "target $dst absent — skipping $(basename "$src")"; return 0; }
  # Container test 2026-09-14: the cd must NOT leak assumptions — find emits
  # ./relative paths, so resolve sources against $src explicitly and pick
  # privilege per destination (sudo only where the user cannot write).
  local use_sudo=no
  [[ -w "$dst" ]] || use_sudo=yes
  local count=0 rel
  while IFS= read -r -d '' f; do
    rel="${f#./}"
    if [[ "$use_sudo" == yes ]]; then
      sudo install -D -m 644 "$src/$rel" "$dst/$rel"
    else
      install -D -m 644 "$src/$rel" "$dst/$rel"
    fi
    count=$((count + 1))
  done < <(cd "$src" && find . -type f -print0)
  log "  restored $count files into $dst"
}

OWNER_PROXY="$(stat -c '%U:%G' /opt/freebuff/go/freebuff-proxy 2>/dev/null || true)"
restore_tree "$BACKUP_DIR/projects/freebuff-proxy" "/opt/freebuff/go/freebuff-proxy"
[[ -n "$OWNER_PROXY" ]] && sudo chown -R "$OWNER_PROXY" /opt/freebuff/go/freebuff-proxy/internal
OWNER_UNI="$(stat -c '%U:%G' "$H/freebuff-unified" 2>/dev/null || stat -c '%U:%G' /home/x3/freebuff-unified 2>/dev/null || true)"
restore_tree "$BACKUP_DIR/projects/freebuff-unified" "$H/freebuff-unified"
[[ -n "$OWNER_UNI" && "$OWNER_UNI" != "$(id -u):$(id -g)" ]] && sudo chown -R "$OWNER_UNI" "$H/freebuff-unified/internal" || true

if command -v go >/dev/null 2>&1; then
  log "Rebuilding Go proxies…"
  if [[ -d /opt/freebuff/go/freebuff-proxy ]]; then
    ( cd /opt/freebuff/go/freebuff-proxy && sudo -E env PATH="$PATH" go build -o bin/freebuff-proxy ./cmd/freebuff-proxy ) \
      && log "  freebuff-proxy built" || warn "freebuff-proxy build failed"
    if have_systemd; then
      sudo systemctl restart freebuff-proxy && systemctl is-active freebuff-proxy
    else
      warn "systemd not running — start freebuff-proxy manually after boot"
    fi
  fi
  if [[ -f "$H/freebuff-unified/go.mod" ]]; then
    ( cd "$H/freebuff-unified" && go build -o bin/freebuff-unified ./cmd/freebuff ) \
      && log "  freebuff-unified built" || warn "freebuff-unified build failed"
    if have_systemd; then
      sudo systemctl restart freebuff-unified && systemctl is-active freebuff-unified
    else
      warn "systemd not running — start freebuff-unified manually after boot"
    fi
  fi
else
  warn "Go toolchain not found — sources restored but not rebuilt (install go ≥ 1.26, then rebuild)"
fi

# ── Verification & handoff ─────────────────────────────────────────────────
log "── unified restore summary ──"
for s in freebuff-proxy freebuff-unified; do
  if have_systemd; then
    systemctl is-active "$s" >/dev/null 2>&1 && log "  $s: active" || warn "  $s: not active"
  else
    warn "  $s: systemd not running — verify after boot"
  fi
done
if have_systemd; then
  systemctl is-enabled freebuff-e2e-health.timer >/dev/null 2>&1 \
    && log "  freebuff-e2e-health.timer: enabled ($(systemctl list-timers freebuff-e2e-health.timer --no-pager 2>/dev/null | sed -n 2p | awk '{print $1, $2}'))" \
    || warn "  freebuff-e2e-health.timer: not enabled"
fi
log "Manual escalation controls:"
log "  sudo /opt/freebuff/e2e-health/freebuff-e2e-health.sh           # run health check now"
log "  sudo /opt/freebuff/e2e-health/freebuff-e2e-health.sh --revert  # back to direct egress"
log "Done."
