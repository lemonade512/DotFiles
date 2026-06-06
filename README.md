# Dotfiles

This repository is the source of truth for my personal shell and developer
configuration.

It previously used a custom installer and symlink-based setup. The repository is
now being migrated to [chezmoi](https://www.chezmoi.io/), which is a better fit
for managing dotfiles declaratively, keeping tracked files in sync, and applying
changes safely across machines.

## What this repo is for

Use this repository to:

- version-control shell config and other personal development settings
- bootstrap a new machine with a known-good baseline
- keep config changes reproducible instead of relying on one-off setup scripts

## How `chezmoi` maps files

`chezmoi` stores files in a source-state directory instead of mirroring the home
directory exactly.

Examples:

- `dot_bash_aliases` becomes `~/.bash_aliases`
- future files like `dot_zshrc` would become `~/.zshrc`
- directories such as `private_dot_config/` would map into `~/.config/`

This repository itself is that source-state directory.

## Install with chezmoi

Bootstrap `chezmoi`, clone this repository, and apply the managed files in one
step:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:lemonade512/dotfiles.git
```

That command will:

1. clone this repository into `~/.local/share/chezmoi`
2. compute what should be installed in your home directory
3. write the managed files into place

## Day-to-day usage

After initialization, common commands are:

```sh
chezmoi add ~/.bash_aliases
chezmoi status
chezmoi diff
chezmoi apply
chezmoi edit ~/.bash_aliases
chezmoi cd
```

Useful workflow:

1. edit a managed file with `chezmoi edit <target>`
2. review the generated changes with `chezmoi diff`
3. apply them with `chezmoi apply`
4. commit the updated source files from the repo

## Keeping work / company config separate

This repo is **public**, so anything company-specific (employer-internal aliases,
env vars, infra names, secrets, AI assistant rules) is kept out of it entirely.
Instead, that config lives in a separate **private** repo managed as a *second
chezmoi source*, and this public repo only carries generic, company-agnostic
hooks that pick it up when present. Nothing here names any employer.

The hooks already wired into this repo:

- **`.zshrc`** sources every `~/.config/zsh/local/*.zsh` if that directory exists
  (a no-op on a personal machine where it doesn't):
  ```sh
  if [ -d "$HOME/.config/zsh/local" ]; then
      for f in "$HOME"/.config/zsh/local/*.zsh(N); do source "$f"; done
  fi
  ```
- **`.zsh/zsh_alias`** defines `czw`, a chezmoi wrapper pointed at the private
  source (harmless if that source isn't cloned):
  ```sh
  alias czw='chezmoi --source ~/.local/share/chezmoi-work --config ~/.config/chezmoi/chezmoi-work.toml'
  ```
- **`dot_claude/CLAUDE.md.tmpl`** holds only generic Claude rules and
  conditionally imports company rules when the machine is flagged as work:
  ```
  {{ if .work }}@work-rules.md{{ end }}
  ```
- **`.chezmoi.toml.tmpl`** prompts once per machine for the `work` flag that
  gates that import.

Because the directory is named generically (`chezmoi-work`, not any company
name), the exact same setup works for **any future employer** — just point a new
private repo at it.

### Setting it up at a new company

1. Create a **private** repo for the company config (e.g. `acme-dotfiles`).
2. Clone it to the generic local path:
   ```sh
   git clone git@github.com:<you>/acme-dotfiles.git ~/.local/share/chezmoi-work
   ```
3. Give the private source its own chezmoi config at
   `~/.config/chezmoi/chezmoi-work.toml` (add the `[age]` block only if you want
   encrypted secrets — see below):
   ```toml
   # encryption = "age"
   # [age]
   #     identity  = "~/.config/chezmoi/key.txt"
   #     recipient = "age1...."
   ```
4. Put company config in the private source, mapping to the generic targets this
   repo already loads:
   - shell: `dot_config/zsh/local/*.zsh` → `~/.config/zsh/local/*.zsh`
   - Claude rules: `dot_claude/work-rules.md` → `~/.claude/work-rules.md`
     (imported automatically by the public `CLAUDE.md` when `work=true`)
   - anything else company-specific under `~/.claude/`, etc.
5. Flag work machines: run `chezmoi init` (it now prompts "Is this a work
   device") or add `work = true` under `[data]` in `~/.config/chezmoi/chezmoi.toml`.
6. Apply both sources — generic with `chezmoi apply`, company with `czw apply`.

### Secrets (optional, via age)

Keep real secrets encrypted **in the private repo only** — never here:

```sh
brew install age
age-keygen -o ~/.config/chezmoi/key.txt   # back the key up in a password manager
# put the printed public key as `recipient` in chezmoi-work.toml, uncomment [age]
czw add --encrypt ~/.config/zsh/local/secrets.zsh
```

chezmoi stores them as `encrypted_*.age` and decrypts on `czw apply`. The key
file is the only way to decrypt them and is never committed.

## Migration note

The older version of this repository included custom installation scripts,
templating logic, package installation helpers, and symlink management. That
approach is being retired in favor of `chezmoi`'s built-in workflow.
