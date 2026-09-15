#!/usr/bin/env bash
# patch-admin-en.sh — English UI patch manager for the trefeon freebuff-proxy
# admin SPA (:3457), adapted from Kfowever/freebuff-zh-patch semantics
# (backup → marked injection → manifest → idempotent install/restore).
#
# Since v0.6.2 the patch is part of the CANONICAL build: the asset lives in
# frontend/public/assets/freebuff-en.js and the <script> tag in
# frontend/index.html. This installer is the sync/verify tool:
#   install → stage asset + inject tag + rebuild image + recreate container
#   status  → compare workspace patch vs staged vs served, show state
#   restore → remove asset + tag from the source tree and redeploy
set -euo pipefail

SRC_REPO="${SRC_REPO:-/home/x3/aiworkspace/trefeon-freebuff-proxy}"
EN_PATCH_DIR="${EN_PATCH_DIR:-/home/x3/workspace/integrations/freebuff-en-patch}"
STATE_DIR="${STATE_DIR:-$EN_PATCH_DIR/state}"
MANIFEST="$STATE_DIR/manifest.json"

INDEX="$SRC_REPO/frontend/index.html"
PUB_ASSET="$SRC_REPO/frontend/public/assets/freebuff-en.js"
PATCH_JS="$EN_PATCH_DIR/freebuff-en.js"
ASSET_URL="http://localhost:3457/admin/assets/freebuff-en.js"

MARK_START='<!-- FREEBUFF_EN_PATCH_START -->'
MARK_END='<!-- FREEBUFF_EN_PATCH_END -->'

die() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "==> $*"; }

need_repo() {
  [ -f "$INDEX" ] || die "frontend/index.html not found at $INDEX (set SRC_REPO)"
  [ -f "$PATCH_JS" ] || die "patch asset not found at $PATCH_JS (set EN_PATCH_DIR)"
}

inject_tag() {
  python3 - "$INDEX" <<'EOF'
import re, sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
tag = "<!-- FREEBUFF_EN_PATCH_START -->\n    <script src=\"/admin/assets/freebuff-en.js?v=0.6.2\" defer></script>\n    <!-- FREEBUFF_EN_PATCH_END -->\n  "
if "<!-- FREEBUFF_EN_PATCH_START -->" in s:
    s = re.sub(r"<!-- FREEBUFF_EN_PATCH_START -->.*?<!-- FREEBUFF_EN_PATCH_END -->\n?", tag, s, flags=re.S)
else:
    assert "  </head>" in s, "</head> not found"
    s = s.replace("  </head>", tag + "</head>", 1)
open(p, "w", encoding="utf-8").write(s)
EOF
}

remove_tag() {
  python3 - "$INDEX" <<'EOF'
import re, sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
s = re.sub(r"[ \t]*<!-- FREEBUFF_EN_PATCH_START -->.*?<!-- FREEBUFF_EN_PATCH_END -->\n?", "", s, flags=re.S)
open(p, "w", encoding="utf-8").write(s)
EOF
}

deploy() {
  log "Building frontend (vite -> backend/internal/dashboard/dist)"
  npm --prefix "$SRC_REPO/frontend" run build >/dev/null 2>&1
  local version
  version=$(git -C "$SRC_REPO" describe --tags 2>/dev/null || echo dev)
  log "Building container image freebuff-proxy:$version"
  (cd "$SRC_REPO" && sudo VERSION="$version" docker compose build freebuff-proxy >/dev/null)
  sudo docker tag "freebuff-proxy:$version" freebuff-proxy:latest
  log "Recreating freebuff-proxy-trefeon container"
  (cd "$SRC_REPO" && sudo docker compose up -d freebuff-proxy >/dev/null)
  sleep 8
  sudo docker ps --format '{{.Names}} {{.Status}}' | grep -q 'freebuff-proxy-trefeon.*healthy' \
    || die "container did not reach healthy state"
  log "Container healthy."
}

cmd_install() {
  need_repo
  mkdir -p "$STATE_DIR"
  log "Staging patch asset (canonical: frontend/public/assets/)"
  mkdir -p "$(dirname "$PUB_ASSET")"
  if [ ! -f "$STATE_DIR/index.html.orig" ]; then
    cp "$INDEX" "$STATE_DIR/index.html.orig"
    log "Backup saved: $STATE_DIR/index.html.orig"
  fi
  cp "$PATCH_JS" "$PUB_ASSET"
  inject_tag
  local idx_hash asset_hash
  idx_hash=$(sha256sum "$INDEX" | cut -d' ' -f1)
  asset_hash=$(sha256sum "$PUB_ASSET" | cut -d' ' -f1)
  cat > "$MANIFEST" <<EOF
{
  "patch": "freebuff-en",
  "version": "0.6.2",
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repo": "$SRC_REPO",
  "backup": "$STATE_DIR/index.html.orig",
  "index_sha256": "$idx_hash",
  "asset_sha256": "$asset_hash",
  "target": "docker:freebuff-proxy-trefeon",
  "served_url": "/admin/assets/freebuff-en.js"
}
EOF
  log "Manifest written: $MANIFEST"
  deploy
  log "Install complete."
}

cmd_status() {
  echo "=== freebuff-en patch status ==="
  [ -f "$MANIFEST" ] && { cat "$MANIFEST"; echo; } || echo "manifest: NOT INSTALLED"
  grep -q "$MARK_START" "$INDEX" 2>/dev/null && echo "index.html: tag PRESENT" || echo "index.html: tag ABSENT"
  if [ -f "$PUB_ASSET" ]; then
    echo "staged asset: $(sha256sum "$PUB_ASSET" | cut -d' ' -f1)"
    if [ -f "$PATCH_JS" ]; then
      local_want=$(sha256sum "$PATCH_JS" | cut -d' ' -f1)
      local_have=$(sha256sum "$PUB_ASSET" | cut -d' ' -f1)
      [ "$local_want" = "$local_have" ] && echo "workspace sync: MATCH" || echo "workspace sync: DRIFT (regenerate: node tools/gen-en-patch.mjs)"
    fi
  else
    echo "staged asset: ABSENT"
  fi
  code=$(curl -s -o /dev/null -w '%{http_code}' -m 5 "$ASSET_URL?v=0.6.2" 2>/dev/null || echo 000)
  served=$(curl -s -m 5 "$ASSET_URL?v=0.6.2" 2>/dev/null | sha256sum | cut -d' ' -f1)
  echo "served /admin/assets/freebuff-en.js → HTTP $code ($served)"
  echo "container: $(sudo docker ps --format '{{.Names}} {{.Status}}' 2>/dev/null | grep freebuff-proxy-trefeon || echo unknown)"
}

cmd_restore() {
  need_repo
  log "Removing patch asset + tag from source tree"
  rm -f "$PUB_ASSET"
  remove_tag
  rm -f "$MANIFEST"
  deploy
  log "Restore complete."
}

case "${1:-}" in
  install) cmd_install ;;
  status)  cmd_status ;;
  restore) cmd_restore ;;
  *) echo "Usage: $0 {install|status|restore}" >&2; exit 2 ;;
esac
