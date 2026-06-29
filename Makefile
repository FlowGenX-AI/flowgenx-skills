# Makefile — added by SOPS env rollout.
.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'

# ── SOPS: encrypted env management (added by sops rollout) ──────────────────
.PHONY: encrypt decrypt sync sops-check
encrypt: ## Encrypt every plaintext .env file in the repo -> <name>.sops
	@found=0; \
	for f in $$(find . -type f \( -name '.env' -o -name '.env.*' \) \
		! -name '*.sops' ! -name '*.example' ! -name '*.sample' ! -name '*.template' \
		! -path './.git/*' ! -path '*/node_modules/*' ! -path '*/.venv/*' ! -path '*/venv/*'); do \
		./sops/encrypt.sh "$$f" || exit 1; found=1; \
	done; \
	if [ "$$found" = 0 ]; then echo "no plaintext .env files found"; \
	else echo "Done. Commit the *.sops files."; fi

decrypt: ## Decrypt every *.sops file -> its plaintext sibling
	@./sops/decrypt.sh

sync: ## Pull latest AND always decrypt (use instead of git pull)
	@git pull
	@./sops/decrypt.sh

sops-check: ## Verify sops + GCP auth are ready, list tracked .sops files
	@command -v sops >/dev/null 2>&1 && echo "✓ sops $$(sops --version 2>/dev/null | head -1)" || echo "✗ sops not installed"
	@gcloud auth application-default print-access-token >/dev/null 2>&1 \
		&& echo "✓ GCP ADC present" || echo "✗ run: gcloud auth application-default login"
	@echo "Encrypted files in git:"; git ls-files '*.sops' | sed 's/^/  /' || true
