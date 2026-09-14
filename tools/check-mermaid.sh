#!/usr/bin/env bash
# check-mermaid.sh — extract every ```mermaid fenced block from the given
# markdown files and syntax-check each one with mermaid-cli (mmdc).
#
# Usage:
#   tools/check-mermaid.sh file1.md file2.md ...   # explicit files
#   tools/check-mermaid.sh                         # README + wiki/*.md
#
# Requires: node/npx (mmdc is fetched via npx on first use).
# Exit 0 iff every diagram compiles; failing diagrams are printed with file
# and line so CI logs point straight at the problem.

set -u

TMPDIR_LOCAL="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT
MANIFEST="$TMPDIR_LOCAL/manifest.tsv"
# mmdc renders via a browser. Prefer the system Chrome (GitHub runners
# preinstall it; also avoids the puppeteer postinstall chicken-and-egg where
# a warm npm cache suppresses the browser download). Fall back to letting
# puppeteer manage chrome-headless-shell in ~/.cache/puppeteer.
CHROME_BIN="$(command -v google-chrome-stable || command -v google-chrome || command -v chromium-browser || command -v chromium || true)"
if [[ -n "$CHROME_BIN" ]]; then
  cat > "$TMPDIR_LOCAL/puppeteer.json" <<EOF
{ "args": ["--no-sandbox", "--disable-setuid-sandbox"], "executablePath": "$CHROME_BIN" }
EOF
else
  npx --yes @puppeteer/browsers install chrome-headless-shell >/dev/null 2>&1 || true
  cat > "$TMPDIR_LOCAL/puppeteer.json" <<'EOF'
{ "args": ["--no-sandbox", "--disable-setuid-sandbox"] }
EOF
fi

files=("$@")
if [[ ${#files[@]} -eq 0 ]]; then
  files=(README.md wiki/*.md)
fi
existing=()
for f in "${files[@]}"; do
  [[ -f "$f" ]] && existing+=("$f")
done

# Extract: one temp file per diagram + manifest lines "file<TAB>start<TAB>bodyfile".
awk -v outdir="$TMPDIR_LOCAL" -v manifest="$MANIFEST" '
  /^```mermaid/ { inblock = 1; start = NR; idx++; body = outdir "/diagram-" idx ".mmd"; next }
  inblock && /^```[[:space:]]*$/ {
    inblock = 0
    print FILENAME "\t" start "\t" body >> manifest
    next
  }
  inblock { print $0 >> body }
' "${existing[@]}"

fail=0
checked=0
while IFS=$'\t' read -r src start bodyfile; do
  checked=$((checked + 1))
  errlog="$bodyfile.err"
  if ! npx --yes @mermaid-js/mermaid-cli -p "$TMPDIR_LOCAL/puppeteer.json" -i "$bodyfile" -o "$bodyfile.svg" >"$errlog" 2>&1; then
    echo "MERMAID FAIL: $src (block #$checked, starts at line $start)" >&2
    echo "--- mmdc error (tail) ---" >&2
    tail -15 "$errlog" >&2
    echo "-------------------------" >&2
    fail=1
  fi
done < "$MANIFEST"

echo "checked $checked mermaid diagram(s)"
exit "$fail"
