#!/usr/bin/env bash
# decrypt.sh — decrypt every committed *.sops -> its plaintext sibling.
#   .env.sops -> .env   ,   .env.local.sops -> .env.local
# Auto-detects encryption mode: BINARY (file starts with '{') or legacy dotenv/yaml.
# Engine for the git hooks; safe to run by hand. Never blocks a git op.
set -uo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"; cd "$ROOT" || exit 0
command -v sops >/dev/null 2>&1 || { echo "sops: not installed — skipping decrypt (see sops/sops_guide.md)" >&2; exit 0; }

mode_for() {  # $1 = the .sops file, $2 = the output name
  if [ "$(head -c1 "$1" 2>/dev/null)" = "{" ]; then echo binary; return; fi
  case "$2" in *.yaml|*.yml) echo yaml;; *.json) echo json;; *) echo dotenv;; esac
}

shopt -s globstar nullglob dotglob
count=0; failed=0
for enc in **/*.sops; do
  out="${enc%.sops}"; t="$(mode_for "$enc" "$out")"
  if sops -d --input-type "$t" --output-type "$t" "$enc" > "$out.tmp" 2>/dev/null; then
    mv "$out.tmp" "$out"; count=$((count+1))
  else
    rm -f "$out.tmp"
    echo "  ✗ decrypt failed: $enc — run 'gcloud auth application-default login' (@flowgenx.ai)" >&2
    failed=$((failed+1))
  fi
done
echo "sops: decrypted $count file(s)$( [ "$failed" -gt 0 ] && echo ", $failed failed" )"
exit 0
