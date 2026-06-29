# sops/ — encrypted env tooling

Env files are committed **encrypted** (`*.sops`) and decrypt automatically on `git sync`.

**New here? Read [`sops_guide.md`](sops_guide.md).** TL;DR after cloning:
```bash
gcloud auth application-default login    # @flowgenx.ai account
./sops/install-hooks.sh                  # once per clone
make decrypt                             # create plaintext env
git sync                                 # get latest env anytime
```

| File | Purpose |
|------|---------|
| `sops_guide.md` | full developer guide (setup, daily use, troubleshooting) |
| `decrypt.sh` | decrypt all `*.sops` → plaintext siblings (hook engine) |
| `encrypt.sh` | `./sops/encrypt.sh <file>` → `<file>.sops` |
| `install-hooks.sh` | wire git hooks + `git sync` alias (once per clone) |
| `hooks/pre-commit` | auto-encrypt changed env on commit |
| `hooks/{post-merge,post-checkout,post-rewrite}` | auto-decrypt on pull/checkout/rebase |

KMS key: `projects/startupproject-414500/locations/global/keyRings/sops/cryptoKeys/env`
(access = any `@flowgenx.ai` account).
