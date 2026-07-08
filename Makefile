# Makefile — added by SOPS env rollout.
.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'


# ── SOPS: encrypted env via centralized flowgenx_sops tooling ────────────────
# Tooling lives at ~/.flowgenx-sops (install once). Onboarding & docs:
#   https://github.com/FlowGenX-AI/flowgenx_sops
FGX ?= $(HOME)/.flowgenx-sops

.PHONY: sops-init
sops-init: ## Install/refresh the central SOPS tooling and wire this repo (run once)
	@if [ -x "$(FGX)/install.sh" ]; then "$(FGX)/install.sh"; \
	else git clone git@github.com:FlowGenX-AI/flowgenx_sops.git "$(FGX)" && "$(FGX)/install.sh"; fi

.PHONY: encrypt
encrypt: ## Encrypt every plaintext .env file in the repo -> <name>.sops
	@found=0; \
	for f in $$(find . -type f \( -name '.env' -o -name '.env.*' \) \
		! -name '*.sops' ! -name '*.example' ! -name '*.sample' ! -name '*.template' \
		! -path './.git/*' ! -path '*/node_modules/*' ! -path '*/.venv/*' \
		! -path '*/venv/*'); do \
		bash "$(FGX)/scripts/encrypt.sh" "$$f" || exit 1; found=1; \
	done; \
	if [ "$$found" = 0 ]; then echo "no plaintext .env files found to encrypt"; \
	else echo "Done. Commit the *.sops files (plaintext stays git-ignored)."; fi

.PHONY: sops-commit
sops-commit: ## One-step env commit: make sops-commit m="message" (encrypts+stages+commits)
	@test -n "$(m)" || { echo 'usage: make sops-commit m="commit message"'; exit 1; }
	@bash "$(FGX)/scripts/commit.sh" -m "$(m)"

.PHONY: decrypt
decrypt: ## Decrypt every *.sops file -> its plaintext sibling
	@bash "$(FGX)/scripts/decrypt.sh"

.PHONY: sync
sync: ## Pull latest AND always decrypt (use instead of git pull)
	@git pull
	@bash "$(FGX)/scripts/decrypt.sh"

.PHONY: sops-check
sops-check: ## Verify sops + GCP auth are ready, list tracked .sops files
	@bash "$(FGX)/scripts/check.sh"

