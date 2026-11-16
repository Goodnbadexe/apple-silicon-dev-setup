# Apple Silicon Dev Setup

A clean, opinionated, and idempotent bootstrapper for setting up an Apple Silicon (`arm64`) Mac for software development. Includes a curated `Brewfile`, starter shell/Git/SSH templates, optional macOS developer defaults, and a GitHub Actions CI workflow running on `macos-latest`.

## What's Included

- **`bootstrap.sh`** — Idempotent setup script with `--dry-run`, `--skip-brew`, and `--with-defaults` flags. Automatically backs up existing dotfiles before linking templates.
- **`Brewfile`** — Curated Homebrew CLI tools, runtimes, and desktop apps for Apple Silicon (`/opt/homebrew`).
- **`templates/`** — Starter configuration templates:
  - `zsh/.zprofile` & `zsh/.zshrc` — Apple Silicon Homebrew initialization, clean `PATH`, Git-aware prompt, and `mise` / `fzf` / `zoxide` hooks.
  - `git/.gitconfig` & `git/.gitignore_global` — Sensible Git defaults (`main` default branch, `pull.rebase`, macOS Keychain / `gh` credential helpers).
  - `ssh/config` — macOS Keychain integration (`UseKeychain yes`, `AddKeysToAgent yes`).
- **`scripts/macos-defaults.sh`** — Optional, reversible macOS Finder, Dock, Keyboard, and Screenshot tweaks for developers.
- **`.github/workflows/ci.yml`** — Automated validation on `macos-latest` (`bash -n`, `zsh -n`, `shellcheck`, `Brewfile` syntax check, and `bootstrap.sh --dry-run`).

## Quick Start

```bash
git clone https://github.com/Goodnbadexe/apple-silicon-dev-setup.git
cd apple-silicon-dev-setup

# Preview every action without making changes
./bootstrap.sh --dry-run

# Run full setup (Xcode CLT, Homebrew, Brewfile, and starter templates)
./bootstrap.sh

# Optionally include macOS developer defaults
./bootstrap.sh --with-defaults
```

## Customization

1. **Packages**: Edit [`Brewfile`](Brewfile) to add or remove Homebrew formulae and casks before running `./bootstrap.sh`.
2. **Templates**: Customize files under [`templates/`](templates/) to match your workflow.
3. **Local Overrides**: Keep machine-specific or private settings in `~/.zshrc.local` or `~/.gitconfig.local` (automatically sourced/included if present, and never committed).

## Repository Structure

```text
.
├── .github/workflows/ci.yml   # macOS-latest CI checks
├── Brewfile                   # Curated Homebrew packages & casks
├── LICENSE                    # MIT License
├── README.md
├── bootstrap.sh               # Main idempotent setup entrypoint
├── scripts/
│   └── macos-defaults.sh      # Optional macOS system preferences
└── templates/
    ├── git/
    │   ├── .gitconfig
    │   └── .gitignore_global
    ├── ssh/
    │   └── config
    └── zsh/
        ├── .zprofile
        └── .zshrc
```

## License

Released under the [MIT License](LICENSE).
