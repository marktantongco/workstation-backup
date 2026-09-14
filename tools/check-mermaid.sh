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
# mmdc renders via bundled Chromium; modern distros disable unprivileged
# user namespaces, so always render with --no-sandbox (render-only check).
cat > "$TMPDIR_LOCAL/puppeteer.json" <<'EOF'
{ "args": ["--no-sandbox", "--disable-setuid-sandbox"] }
EOF

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
  if ! npx --yes @mermaid-js/mermaid-cli -p "$TMPDIR_LOCAL/puppeteer.json" -i "$bodyfile" -o "$bodyfile.svg" >/dev/null 2>&1; then
    echo "MERMAID FAIL: $src (block #$checked, starts at line $start)" >&2
    fail=1
  fi
done < "$MANIFEST"

echo "checked $checked mermaid diagram(s)"
exit "$fail"
