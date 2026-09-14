#!/usr/bin/env bash
# workstation-backup installer — restores the x3 workstation opencode ecosystem.
# Safe to re-run: existing files are backed up with a timestamp suffix first.
# Secrets: env files install as TEMPLATES with <REPLACE_ME> placeholders.
#   Fill them from your password manager, then restart services (script tells you).
set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
H="${HOME}"

log()  { printf '\033[1;32m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; exit 1; }

[[ "$(id -u)" -eq 0 ]] && die "Run as the regular user (sudo is invoked internally where needed)."
[[ -d "$BACKUP_DIR/opencode" ]] || die "Run this script from the repo root: ./install.sh"

# ── 1. opencode configs (verbatim, secret-free: {env:VAR} references only) ──
log "1/7 Installing opencode configs, agents, commands, plugins…"
mkdir -p "$H/.config/opencode/agents" "$H/.config/opencode/commands" "$H/.config/opencode/plugins"
for f in opencode.jsonc opencode.json AGENTS.md; do
  [[ -f "$H/.config/opencode/$f" ]] && cp "$H/.config/opencode/$f" "$H/.config/opencode/$f.bak.$TS"
  cp "$BACKUP_DIR/opencode/$f" "$H/.config/opencode/$f"
done
cp "$BACKUP_DIR"/opencode/agents/*.md    "$H/.config/opencode/agents/"
cp "$BACKUP_DIR"/opencode/commands/*.md  "$H/.config/opencode/commands/"
cp "$BACKUP_DIR"/opencode/plugins/*.ts "$BACKUP_DIR"/opencode/plugins/*.js "$H/.config/opencode/plugins/" 2>/dev/null || true
rm -rf "$H/.config/opencode/plugins/caveman"
cp -r "$BACKUP_DIR/opencode/plugins/caveman" "$H/.config/opencode/plugins/caveman"

# ── 2. env token files (TEMPLATES — placeholders must be filled) ──
log "2/7 Installing env token files as templates…"
mkdir -p "$H/.env-tokens" && chmod 700 "$H/.env-tokens"
for pair in \
  "env/ai-agent-tokens-full.env.template:$H/.env-tokens/ai-agent-tokens-full.env" \
  "env/ai-agent-tokens.env.template:$H/.env-tokens/ai-agent-tokens.env" \
  "env/cloudflare-agents.env.template:$H/.env-tokens/cloudflare-agents.env" \
  "env/agent-env.template:$H/.config/opencode/agent-env"; do
  src="${pair%%:*}"; dst="${pair#*:}"
  [[ -f "$dst" ]] && { cp "$dst" "$dst.bak.$TS"; warn "existing $(basename "$dst") backed up"; }
  cp "$BACKUP_DIR/$src" "$dst"
  chmod 600 "$dst"
done

# ── 3. freebuff-unified gateway config ──
log "3/7 Installing freebuff-unified config template…"
mkdir -p "$H/freebuff-unified"
[[ -f "$H/freebuff-unified/config.yaml" ]] && cp "$H/freebuff-unified/config.yaml" "$H/freebuff-unified/config.yaml.bak.$TS"
cp "$BACKUP_DIR/services/freebuff-unified/config.yaml.template" "$H/freebuff-unified/config.yaml"
chmod 600 "$H/freebuff-unified/config.yaml"
mkdir -p "$H/freebuff-unified/evals"  # manual eval store (gitignored user data)

# ── 4. git pre-commit secret scanner ──
log "4/7 Installing git pre-commit secret scanner…"
mkdir -p "$H/workspace/hooks"
cp "$BACKUP_DIR/workspace/pre-commit" "$H/workspace/hooks/pre-commit"
chmod +x "$H/workspace/hooks/pre-commit"
if git -C "$H/workspace" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$H/workspace" config core.hooksPath hooks
  log "hook active for $H/workspace (core.hooksPath=hooks)"
else
  warn "$H/workspace is not a git repo yet — after git init run: git config core.hooksPath hooks"
fi

# ── 5. systemd units ──
log "5/7 Installing systemd units…"
for u in freebuff-unified freebuff-proxy freebuff2api freebuff2api-admin aiclient2api hermes-sidecar lmarena-stealth-proxy owl-agent; do
  f="$BACKUP_DIR/services/systemd/$u.service"
  [[ -f "$f" ]] && sudo install -m 644 "$f" "/etc/systemd/system/$u.service" \
    || warn "no unit for $u in backup — skipping"
done
# NOTE: autoclaw-proxy.service intentionally NOT installed (disabled
# 2026-09-14: 0 accounts, 401 on chat; re-add after Z.ai login).
# Health-probe bearer file for /health/all + /readyz (read-only key):
if [[ ! -f /etc/freebuff-unified/probe-env ]]; then
  warn "create /etc/freebuff-unified/probe-env with FREEBUFF_API_KEY=<first server key> (chmod 644)"
fi
if [[ -f "$BACKUP_DIR/services/systemd/agpx-relay.user.service" ]]; then
  mkdir -p "$H/.config/systemd/user"
  cp "$BACKUP_DIR/services/systemd/agpx-relay.user.service" "$H/.config/systemd/user/agpx-relay.service"
fi
sudo systemctl daemon-reload
sudo systemctl enable freebuff-unified.service >/dev/null 2>&1 || true

# ── 6. project pnpm workspace configs (allowBuilds / overrides) ──
log "6/7 Installing project pnpm configs…"
while IFS= read -r -d '' ws; do
  proj="${ws#projects/}"; proj="${proj%/pnpm-workspace.yaml}"
  dst="$H/workspace/$proj/pnpm-workspace.yaml"
  if [[ -d "$H/workspace/$proj" ]]; then
    [[ -f "$dst" ]] && cp "$dst" "$dst.bak.$TS"
    cp "$BACKUP_DIR/$ws" "$dst"
    log "  restored $proj/pnpm-workspace.yaml"
  else
    warn "project $proj not present — skipping"
  fi
done < <(cd "$BACKUP_DIR" && find projects -name pnpm-workspace.yaml -print0 2>/dev/null)

# ── 7. opencode history exporter ──
log "7/7 Installing opencode-history exporter…"
mkdir -p "$H/workspace/opencode-history"
[[ -f "$BACKUP_DIR/tools/export.py" ]] && cp "$BACKUP_DIR/tools/export.py" "$H/workspace/opencode-history/export.py"

# ── verification & handoff ──
log "Scanning installed env for unfilled <REPLACE_ME> placeholders…"
n=$(grep -c '<REPLACE_ME>' "$H/.env-tokens/ai-agent-tokens-full.env" || true)
if (( n > 0 )); then
  warn "$n placeholder values need real keys:"
  warn "  nano $H/.env-tokens/ai-agent-tokens-full.env"
  warn "Then regenerate agent-env and restart the gateway:"
  warn "  sudo systemctl restart freebuff-unified"
else
  log "env file is filled — restarting freebuff-unified…"
  sudo systemctl restart freebuff-unified && systemctl is-active freebuff-unified
fi

if command -v opencode >/dev/null 2>&1; then
  opencode debug config >/dev/null 2>&1 && log "opencode config parses OK" \
    || warn "opencode debug config failed — check ~/.config/opencode/opencode.jsonc"
else
  warn "opencode binary not on PATH — install it, then verify: opencode debug config"
fi

log "Done. Sessions history (if backed up) lives in ~/.local/share/opencode/opencode.db"
log "Restore transcripts anytime with: python3 ~/workspace/opencode-history/export.py"
