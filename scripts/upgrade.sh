#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Upgrade Homebrew packages, Brewfile tools, mise runtimes, and gh extensions,
then run scripts/doctor.sh to verify the environment.

Options:
  --dry-run   Print upgrade commands without modifying the system
  -h, --help  Show this help message
EOF
}

log() {
  printf '[upgrade] %s\n' "$*"
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

if command -v brew >/dev/null 2>&1; then
  log "Updating Homebrew and upgrading installed packages..."
  run brew update
  run brew upgrade
  run brew bundle --file="${REPO_DIR}/Brewfile"
  run brew cleanup
else
  log "Homebrew not found; skipping brew upgrade."
fi

if command -v mise >/dev/null 2>&1; then
  log "Upgrading mise runtimes..."
  run mise upgrade
fi

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  log "Upgrading GitHub CLI extensions..."
  run gh extension upgrade --all
fi

log "Running post-upgrade audit..."
bash "${REPO_DIR}/scripts/doctor.sh"
