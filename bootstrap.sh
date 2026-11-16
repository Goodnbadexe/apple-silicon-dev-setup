#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREW_PREFIX="/opt/homebrew"
DRY_RUN=false
SKIP_BREW=false
WITH_DEFAULTS=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Idempotent Apple Silicon (arm64) macOS developer setup.

Options:
  --dry-run        Print actions without modifying the system
  --skip-brew      Skip Homebrew installation and Brewfile bundle
  --with-defaults  Apply opinionated macOS defaults after linking templates
  -h, --help       Show this help message
EOF
}

log() {
  printf '[setup] %s\n' "$*"
}

run() {
  if [ "$DRY_RUN" = true ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --skip-brew)
      SKIP_BREW=true
      ;;
    --with-defaults)
      WITH_DEFAULTS=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'Error: This script is intended for macOS (Darwin).\n' >&2
  exit 1
fi

ARCH="$(uname -m)"
if [ "$ARCH" != "arm64" ]; then
  log "Warning: Detected architecture '$ARCH' (expected 'arm64' Apple Silicon)."
fi

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed."
  else
    log "Installing Xcode Command Line Tools..."
    run xcode-select --install
  fi
}

ensure_homebrew() {
  if [ -x "${BREW_PREFIX}/bin/brew" ]; then
    log "Homebrew already installed at ${BREW_PREFIX}."
  elif command -v brew >/dev/null 2>&1; then
    BREW_PREFIX="$(brew --prefix)"
    log "Homebrew already installed at ${BREW_PREFIX}."
  else
    log "Installing Homebrew..."
    if [ "$DRY_RUN" = true ]; then
      printf '[dry-run] Install Homebrew into %s\n' "$BREW_PREFIX"
    else
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  fi

  if [ -x "${BREW_PREFIX}/bin/brew" ] && [ "$DRY_RUN" = false ]; then
    eval "$("${BREW_PREFIX}/bin/brew" shellenv)"
  fi
}

install_brewfile() {
  local brewfile="${REPO_DIR}/Brewfile"
  if [ ! -f "$brewfile" ]; then
    log "No Brewfile found at ${brewfile}; skipping."
    return
  fi

  log "Installing packages from Brewfile..."
  run brew bundle --file="$brewfile"
}

link_template() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  if [ ! -d "$dest_dir" ]; then
    run mkdir -p "$dest_dir"
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log "Already linked: ${dest}"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup
    backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    log "Backing up existing ${dest} -> ${backup}"
    run mv "$dest" "$backup"
  fi

  log "Linking ${dest} -> ${src}"
  run ln -s "$src" "$dest"
}

install_templates() {
  log "Linking starter templates..."
  link_template "${REPO_DIR}/templates/zsh/.zprofile" "${HOME}/.zprofile"
  link_template "${REPO_DIR}/templates/zsh/.zshrc" "${HOME}/.zshrc"
  link_template "${REPO_DIR}/templates/git/.gitconfig" "${HOME}/.gitconfig"
  link_template "${REPO_DIR}/templates/git/.gitignore_global" "${HOME}/.gitignore_global"
  link_template "${REPO_DIR}/templates/ssh/config" "${HOME}/.ssh/config"

  if [ -d "${HOME}/.ssh" ] && [ "$DRY_RUN" = false ]; then
    chmod 700 "${HOME}/.ssh"
  fi
}

apply_macos_defaults() {
  local defaults_script="${REPO_DIR}/scripts/macos-defaults.sh"
  if [ ! -f "$defaults_script" ]; then
    log "No macOS defaults script found; skipping."
    return
  fi
  log "Applying macOS developer defaults..."
  run bash "$defaults_script"
}

main() {
  ensure_xcode_clt

  if [ "$SKIP_BREW" = false ]; then
    ensure_homebrew
    install_brewfile
  else
    log "Skipping Homebrew steps (--skip-brew)."
  fi

  install_templates

  if [ "$WITH_DEFAULTS" = true ]; then
    apply_macos_defaults
  fi

  log "Setup complete. Restart your terminal or run 'source ~/.zshrc'."
}

main
