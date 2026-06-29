# Developer Guide — Encrypted Env with SOPS + GCP KMS

This repo keeps its environment files **encrypted in git** (`*.sops`) and **decrypts them
automatically** when you sync. No more hand-sharing `.env` files — change a value, commit,
push, and teammates get it on their next `git sync`.

---

## 1. How it works (30-second version)

For each env file there are **two files**:

| File | Contents | In git? | Who uses it |
|------|----------|---------|-------------|
| `.env` / `.env.local` | **plaintext** (readable) | ❌ git-ignored | the app |
| `.env.sops` / `.env.local.sops` | **encrypted** | ✅ committed | the source of truth everyone shares |

Encryption uses **Google Cloud KMS** — no shared password. Any `@flowgenx.ai` account can
decrypt; nobody else can. Only the *values* are encrypted (keys stay readable for clean
diffs). Git hooks do the work:
- **commit** → auto-**encrypt** changed env → `*.sops` (pre-commit)
- **`git sync` / pull / checkout** → auto-**decrypt** `*.sops` → plaintext env

---

## 2. Prerequisites

- A **`@flowgenx.ai`** Google account (personal gmail accounts are blocked by org policy).
- `gcloud` CLI installed and logged in.

---

## 3. One-time setup (per machine / clone)

```bash
# 1. install sops
#    Linux:
mkdir -p ~/.local/bin
curl -Lo ~/.local/bin/sops \
  https://github.com/getsops/sops/releases/download/v3.13.1/sops-v3.13.1.linux.amd64
chmod +x ~/.local/bin/sops      # ensure ~/.local/bin is on your PATH
#    macOS:  brew install sops

# 2. authenticate to GCP KMS (pick your @flowgenx.ai account)
gcloud auth application-default login

# 3. wire hooks + the `git sync` alias (run from the repo root)
./sops/install-hooks.sh

# 4. decrypt once (first time only)
make decrypt        # or: ./sops/decrypt.sh
```

Verify: `make sops-check` → should show ✓ sops, ✓ GCP ADC, and your `*.sops` files.

---

## 4. Daily use — getting the env

```bash
git sync
```

`git sync` = `git pull` **+ always decrypt** (works even when there's nothing to pull, e.g.
if you deleted your local env). Use it instead of `git pull`.

> Plain `git pull` decrypts only when it actually merges new commits; `git sync` has no gap.
> `git fetch` never decrypts (it doesn't touch your files). Lost your env? `make decrypt`.

---

## 5. Adding or changing an env value

**Encryption is automatic** — edit the plaintext and commit; the pre-commit hook encrypts
and stages the `*.sops` for you.

```bash
echo 'NEW_API_KEY=sk-abc123' >> .env        # or edit the env file in any editor
git commit -s -am "env: add NEW_API_KEY"    # auto-encrypts & stages .env.sops
git push
```

Teammates run `git sync` and get it, decrypted.

> Manual alternative: edit the plaintext and run `make encrypt` (re-encrypts every env
> file), then commit. Files are encrypted in binary mode, so the whole `.sops` blob changes
> on any edit — that's expected (correct round-trip for any content; values never shown in
> git).

---

## 6. Command reference

| I want to… | Command |
|---|---|
| Get the latest env (always decrypts) | `git sync` *(or `make sync`)* |
| Rebuild plaintext env on demand | `make decrypt` |
| Add / change a value | edit env → `git commit -s -am "…"` (auto-encrypts) |
| View decrypted values | `sops -d --input-type binary --output-type binary <file>.sops` |
| Encrypt every env by hand | `make encrypt` |
| Check setup is healthy | `make sops-check` |

---

## 7. Troubleshooting

| Symptom | Fix |
|---|---|
| `sops not installed` | Install sops (§3.1); ensure `~/.local/bin` is on `PATH`. |
| Decrypt fails: `PermissionDenied` / `could not find default credentials` | `gcloud auth application-default login` with your **@flowgenx.ai** account. |
| `git sync` "not a git command" | Run `./sops/install-hooks.sh`. |
| env didn't update after `git pull` | Use **`git sync`** (plain pull only decrypts on a real merge). |
| env file missing | `make decrypt`. |
| Commit blocked "FAILED to encrypt" | Not authenticated to KMS — see permission row above. |

---

## Rules
- ✅ Commit the **`*.sops`** files (the pre-commit hook stages them).
- ❌ Never commit plaintext env (`.env`, `.env.local`, … — git-ignored on purpose).
- 🔑 Change a value: edit env → commit → push. Others: `git sync`.

*KMS key: `projects/startupproject-414500/locations/global/keyRings/sops/cryptoKeys/env`.
It never leaves Google — sops only asks KMS to lock/unlock a small per-file data key.*
