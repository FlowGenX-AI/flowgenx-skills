#!/usr/bin/env bash
# install-hooks.sh — wire auto-decrypt git hooks for this repo. Run once per clone.
# Points core.hooksPath at the tracked sops/hooks dir so every dev gets the same hooks
# and they update with the repo.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
chmod +x "$ROOT/sops/"*.sh "$ROOT/sops/hooks/"* 2>/dev/null || true
git config core.hooksPath "sops/hooks"
echo "✓ core.hooksPath -> sops/hooks (auto-decrypt on pull/checkout/rebase)"
# 'git sync' = pull + ALWAYS decrypt (works even when there's nothing to pull,
# unlike the post-merge hook which only fires on an actual merge).
git config alias.sync '!f() { git pull "$@"; "$(git rev-parse --show-toplevel)/sops/decrypt.sh"; }; f'
echo "✓ 'git sync' alias -> git pull + always decrypt (use this instead of git pull)"
command -v sops >/dev/null 2>&1 && echo "✓ sops $(sops --version 2>/dev/null | head -1)" || echo "✗ sops not installed — see sops/README.md"
gcloud auth application-default print-access-token >/dev/null 2>&1 \
  && echo "✓ GCP ADC present" || echo "✗ run: gcloud auth application-default login"
echo "Test:  ./sops/decrypt.sh"
