#!/usr/bin/env bash
# install-omarchy.sh — Omarchy (Arch Linux) system prep + full ecosystem install.
#
# Omarchy variant of the unified installer. On a fresh Omarchy/Arch box:
#   1. System prep via pacman: base toolchain, docker, Go, Node+pnpm, Python, jq
#   2. Optional NVIDIA userspace (detected; full GPU/CUDA walkthrough: wiki/11)
#   3. opencode CLI install
#   4. Agent skills (github.com/marktantongco/ai-agent-skills → ~/.agents/skills
#      + ~/.claude/skills + ~/.opencode/skills symlinks)
#   5. Delegates to install-unified.sh (stages 1–11) as the regular user
#
# Usage:  sudo ./install-omarchy.sh
# Full hardware walkthrough (RAID, NVIDIA 580.x, CUDA): wiki/11-omarchy-installation.md

set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Target user: SUDO_USER when invoked via sudo; OMARCHY_USER override for
# root shells / containers; never root itself (stage 5 drops privileges).
REAL_USER="${OMARCHY_USER:-${SUDO_USER:-}}"
H="/home/$REAL_USER"

log()  { printf '\033[1;32m[omarchy]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; exit 1; }

[[ "$(id -u)" -eq 0 ]] || die "Run as root: sudo ./install-omarchy.sh"
[[ -n "$REAL_USER" && "$REAL_USER" != "root" ]] \
  || die "No target user resolved. Run via sudo (sudo ./install-omarchy.sh), or set one: OMARCHY_USER=<user> ./install-omarchy.sh"
[[ -d "$H" ]] || die "Home directory $H does not exist — is OMARCHY_USER=$REAL_USER correct?"
command -v pacman >/dev/null 2>&1 || die "pacman not found — this installer targets Arch/Omarchy only."
[[ -d "$BACKUP_DIR/opencode" ]] || die "Run this script from the repo root: sudo ./install-omarchy.sh"

# ── 1. System prep ─────────────────────────────────────────────────────────
log "1/5 Preparing Omarchy/Arch system…"
pacman -Syu --noconfirm --needed \
  base-devel git curl wget jq unzip tar \
  pciutils \
  docker docker-compose \
  go nodejs npm \
  python python-pip python-yaml \
  github-cli >/dev/null
log "  pacman packages installed/verified"

# pnpm via corepack (ships with nodejs). Global enable runs as ROOT (it
# writes symlink(s) next to the node binary — as user it would fail).
if ! sudo -u "$REAL_USER" pnpm --version >/dev/null 2>&1; then
  corepack enable pnpm 2>/dev/null \
    || npm install -g pnpm >/dev/null 2>&1 \
    || warn "pnpm install failed — run: corepack enable pnpm"
  sudo -u "$REAL_USER" pnpm --version >/dev/null 2>&1 \
    || warn "pnpm still not on PATH for $REAL_USER — check node install"
fi

# docker: enable + group
systemctl enable --now docker >/dev/null 2>&1 || warn "docker enable failed"
getent group docker >/dev/null && usermod -aG docker "$REAL_USER" || true
log "  docker enabled ($REAL_USER added to docker group — re-login to take effect)"

# ── 2. Optional NVIDIA userspace ───────────────────────────────────────────
if lspci 2>/dev/null | grep -qi nvidia; then
  log "2/5 NVIDIA GPU detected — installing userspace driver…"
  pacman -S --noconfirm --needed nvidia-utils >/dev/null 2>&1 \
    && log "  nvidia-utils installed" \
    || warn "nvidia-utils install failed — see wiki/11-omarchy-installation.md Phase 2"
else
  log "2/5 No NVIDIA GPU detected — skipping (CPU-only stack)"
fi

# ── 3. opencode CLI ────────────────────────────────────────────────────────
log "3/5 Installing opencode CLI…"
if sudo -u "$REAL_USER" opencode --version >/dev/null 2>&1; then
  log "  opencode already present ($(sudo -u "$REAL_USER" opencode --version 2>/dev/null | head -1))"
else
  sudo -u "$REAL_USER" bash -c 'curl -fsSL https://opencode.ai/install | bash' \
    && log "  opencode installed to ~/.opencode/bin" \
    || warn "opencode install failed — run: curl -fsSL https://opencode.ai/install | bash"
fi

# ── 4. Agent skills ────────────────────────────────────────────────────────
log "4/5 Installing agent skills (ai-agent-skills v24+)…"
SKILLS_DIR="$H/.agents/skills"
if [[ ! -d "$SKILLS_DIR/.git" ]]; then
  sudo -u "$REAL_USER" git clone --depth 1 \
    https://github.com/marktantongco/ai-agent-skills.git "$SKILLS_DIR" \
    && log "  cloned to $SKILLS_DIR" \
    || warn "skills clone failed — clone ai-agent-skills manually"
fi
for link in "$H/.claude/skills" "$H/.opencode/skills"; do
  if [[ -d "$SKILLS_DIR" && ! -e "$link" ]]; then
    mkdir -p "$(dirname "$link")"
    ln -s "$SKILLS_DIR" "$link"
    log "  symlinked $(basename "$(dirname "$link")") → skills"
  fi
done
chown -R "$REAL_USER:$REAL_USER" "$H/.agents" 2>/dev/null || true

# ── 5. Full unified install (as the regular user) ──────────────────────────
log "5/5 Handing off to install-unified.sh (stages 1–11)…"
chmod +x "$BACKUP_DIR/install.sh" "$BACKUP_DIR/install-unified.sh" 2>/dev/null || true
# -H is critical: without it $HOME stays /root and stage 1 writes into the
# wrong home (container test 2026-09-14 caught exactly this).
sudo -u "$REAL_USER" -H env "PATH=$PATH" bash "$BACKUP_DIR/install-unified.sh"

log "── omarchy install complete ──"
log "Post-install checklist:"
log "  1. Fill env placeholders:   nano $H/.env-tokens/ai-agent-tokens-full.env"
log "  2. Regenerate agent-env + restart gateway (see wiki/09-disaster-recovery.md)"
log "  3. Verify:                  opencode debug config && opencode mcp list"
log "  4. Re-login (docker group) then: docker ps   # thermoptic + trefeon containers"
log "  5. Health check next run:   systemctl list-timers freebuff-e2e-health.timer"
