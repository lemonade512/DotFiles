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

## Migration note

The older version of this repository included custom installation scripts,
templating logic, package installation helpers, and symlink management. That
approach is being retired in favor of `chezmoi`'s built-in workflow.
