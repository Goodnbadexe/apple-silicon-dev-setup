# Apple Silicon Dev Setup

> Maintained by **Hamzah Al-Ramli (`@Goodnbad.exe`)** · **[goodnbad.info](https://www.goodnbad.info)** · [![CI](https://github.com/Goodnbadexe/apple-silicon-dev-setup/actions/workflows/ci.yml/badge.svg)](https://github.com/Goodnbadexe/apple-silicon-dev-setup/actions/workflows/ci.yml) [![Gumroad](https://img.shields.io/badge/Gumroad-Toolkit%20Vault-FF90E8?logo=gumroad&logoColor=white)](https://hamzahramli.gumroad.com)

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
- **`scripts/upgrade.sh`** — One-command upgrade (`brew update/upgrade/cleanup`, `mise upgrade`, `gh extension upgrade --all`, followed by `doctor.sh`, with `--dry-run` support).
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

# Open the Gumroad macOS Toolkit Vault after setup
./bootstrap.sh --vault
```

## Free Core vs. Toolkit Vault (Gumroad)

Everything in this repository is free and MIT-licensed. For ready-to-run cybersecurity, AI, and developer playbooks, pair it with the unified **Toolkit Vault** on Gumroad:

| Tier | What You Get | Link |
| :--- | :--- | :--- |
| **Open-Source Core** | `bootstrap.sh`, `Brewfile`, `doctor.sh`, `upgrade.sh`, starter templates, CI | Free (this repo) |
| **macOS All-Access Vault** | Unified paid Toolkit Vault bundle for macOS (`hamzahramli.gumroad.com`) | **[Get on Gumroad](https://hamzahramli.gumroad.com/l/all-access-macos)** |
| **Interactive Vault Funnel** | Pick your track & OS with `LAUNCH50` offer on `goodnbad.info` | **[goodnbad.info/subscribe](https://www.goodnbad.info/subscribe)** |

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
- **Pro Toolkits & Vault (Gumroad)**:
  - **Storefront**: [hamzahramli.gumroad.com](https://hamzahramli.gumroad.com)
  - **macOS All-Access Vault**: [hamzahramli.gumroad.com/l/all-access-macos](https://hamzahramli.gumroad.com/l/all-access-macos)
  - **Interactive Vault Funnel**: [goodnbad.info/subscribe](https://www.goodnbad.info/subscribe)

## License & Author

Released under the [MIT License](LICENSE).  
Built by **Hamzah Al-Ramli (`@Goodnbad.exe`)** — [goodnbad.info](https://www.goodnbad.info) · [GitHub](https://github.com/Goodnbadexe)
