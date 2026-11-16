# Apple Silicon Dev Setup

> Maintained by **Hamzah Al-Ramli (`@Goodnbad.exe`)** · **[goodnbad.info](https://www.goodnbad.info)** · [![CI](https://github.com/Goodnbadexe/apple-silicon-dev-setup/actions/workflows/ci.yml/badge.svg)](https://github.com/Goodnbadexe/apple-silicon-dev-setup/actions/workflows/ci.yml)

A clean, opinionated, and idempotent bootstrapper for setting up an Apple Silicon (`arm64`) Mac for software development, security engineering, and AI workflows. Includes a curated `Brewfile`, starter shell/Git/SSH/editor templates, optional macOS developer defaults, an environment audit script (`doctor.sh`), and a GitHub Actions CI workflow running on `macos-latest`.

## What's Included

- **`bootstrap.sh`** — Idempotent setup script with `--dry-run`, `--skip-brew`, and `--with-defaults` flags. Automatically backs up existing dotfiles before linking templates.
- **`Brewfile`** — Curated Homebrew CLI tools, runtimes, and desktop apps for Apple Silicon (`/opt/homebrew`).
- **`templates/`** — Starter configuration templates:
  - `zsh/.zprofile` & `zsh/.zshrc` — Apple Silicon Homebrew initialization, clean `PATH`, Git-aware prompt, and `mise` / `fzf` / `zoxide` hooks.
  - `git/.gitconfig` & `git/.gitignore_global` — Sensible Git defaults (`main` default branch, `pull.rebase`, macOS Keychain / `gh` credential helpers).
  - `ssh/config` — macOS Keychain integration (`UseKeychain yes`, `AddKeysToAgent yes`).
  - `mise/config.toml` — Global `mise` runtime defaults (`node`, `python`).
  - `ghostty/config` — Starter Ghostty terminal configuration.
  - `vscode/settings.json` & `vscode/extensions.txt` — Starter VS Code settings and recommended extensions.
- **`scripts/doctor.sh`** — Full environment audit checking architecture, Xcode CLT, Homebrew, `Brewfile` status, template symlinks, `~/.ssh` permissions, and script syntax.
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

## Support, Donations & Toolkit Vault

This repository is free and open-source under the MIT License. If it saved you hours setting up your Mac:

- **Donate / Sponsor**: Click the **Sponsor** button at the top of this repo or visit **[goodnbad.info](https://www.goodnbad.info)** / **[GitHub Sponsors](https://github.com/sponsors/Goodnbadexe)**.
- **Pro Toolkits & Vault**: Explore paid cybersecurity, AI, and developer toolkits on **[goodnbad.info/subscribe](https://www.goodnbad.info/subscribe)** and **[hamzahramli.gumroad.com](https://hamzahramli.gumroad.com)**.

## License & Author

Released under the [MIT License](LICENSE).  
Built by **Hamzah Al-Ramli (`@Goodnbad.exe`)** — [goodnbad.info](https://www.goodnbad.info) · [GitHub](https://github.com/Goodnbadexe)
