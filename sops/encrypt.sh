#!/usr/bin/env bash
# encrypt.sh <plaintext-file> -> <plaintext-file>.sops  (commit the .sops)
# Uses sops BINARY mode so ANY content (comments, blank lines, quotes, multiline)
# round-trips byte-for-byte exactly. The plaintext stays git-ignored.
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: $0 <file>  (e.g. .env)" >&2; exit 1; }
src="$1"; [ -f "$src" ] || { echo "no such file: $src" >&2; exit 1; }
command -v sops >/dev/null 2>&1 || { echo "sops not installed (see sops/sops_guide.md)" >&2; exit 1; }
sops -e --input-type binary --output-type binary "$src" > "$src.sops"
echo "encrypted: $src -> $src.sops"
