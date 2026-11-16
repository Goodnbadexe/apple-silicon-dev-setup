#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() {
  printf '[PASS] %s\n' "$*"
  PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
  printf '[WARN] %s\n' "$*"
  WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
  printf '[FAIL] %s\n' "$*"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_link() {
  local expected_src="$1"
  local dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$expected_src" ]; then
    pass "Symlink OK: ${dest} -> ${expected_src}"
  elif [ -e "$dest" ] || [ -L "$dest" ]; then
    warn "Exists but not linked to repo template: ${dest}"
  else
    warn "Missing template target: ${dest} (run ./bootstrap.sh to link)"
  fi
}

printf '=== Apple Silicon Dev Setup Audit ===\n'

# 1. OS & Architecture
if [ "$(uname -s)" = "Darwin" ]; then
  pass "macOS detected ($(sw_vers -productVersion 2>/dev/null || echo 'Darwin'))"
else
  fail "Expected macOS (Darwin), got $(uname -s)"
fi

if [ "$(uname -m)" = "arm64" ]; then
  pass "Apple Silicon architecture (arm64)"
else
  warn "Architecture is $(uname -m), expected arm64"
fi

# 2. Xcode Command Line Tools
if xcode-select -p >/dev/null 2>&1; then
  pass "Xcode Command Line Tools installed ($(xcode-select -p))"
else
  fail "Xcode Command Line Tools missing (run: xcode-select --install)"
fi

# 3. Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  pass "Apple Silicon Homebrew installed (/opt/homebrew/bin/brew)"
  if brew bundle check --file="${REPO_DIR}/Brewfile" >/dev/null 2>&1; then
    pass "All Brewfile dependencies are satisfied"
  else
    warn "Some Brewfile packages are not installed (run: brew bundle --file=${REPO_DIR}/Brewfile)"
  fi
else
  fail "Homebrew not found at /opt/homebrew/bin/brew"
fi

# 4. Symlinks & Permissions
check_link "${REPO_DIR}/templates/zsh/.zprofile" "${HOME}/.zprofile"
check_link "${REPO_DIR}/templates/zsh/.zshrc" "${HOME}/.zshrc"
check_link "${REPO_DIR}/templates/git/.gitconfig" "${HOME}/.gitconfig"
check_link "${REPO_DIR}/templates/git/.gitignore_global" "${HOME}/.gitignore_global"
check_link "${REPO_DIR}/templates/ssh/config" "${HOME}/.ssh/config"
check_link "${REPO_DIR}/templates/mise/config.toml" "${HOME}/.config/mise/config.toml"
check_link "${REPO_DIR}/templates/ghostty/config" "${HOME}/.config/ghostty/config"

if [ -d "${HOME}/.ssh" ]; then
  ssh_perm="$(stat -f '%Lp' "${HOME}/.ssh" 2>/dev/null || echo 'unknown')"
  if [ "$ssh_perm" = "700" ]; then
    pass "~/.ssh permissions are 700"
  else
    warn "~/.ssh permissions are ${ssh_perm} (recommended: 700)"
  fi
fi

# 5. GitHub CLI auth
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    pass "GitHub CLI (gh) is authenticated"
  else
    warn "GitHub CLI (gh) installed but not authenticated (or offline)"
  fi
else
  warn "GitHub CLI (gh) not installed"
fi

# 6. Script syntax & lint
if bash -n "${REPO_DIR}/bootstrap.sh" "${REPO_DIR}/scripts/macos-defaults.sh" "${REPO_DIR}/scripts/doctor.sh"; then
  pass "Bash script syntax OK"
else
  fail "Bash syntax check failed"
fi

if command -v shellcheck >/dev/null 2>&1; then
  if shellcheck "${REPO_DIR}/bootstrap.sh" "${REPO_DIR}/scripts/macos-defaults.sh" "${REPO_DIR}/scripts/doctor.sh"; then
    pass "shellcheck passed"
  else
    fail "shellcheck reported issues"
  fi
else
  warn "shellcheck not installed locally (runs in CI)"
fi

printf '\nSummary: %d passed, %d warnings, %d failed\n' "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT"
if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
