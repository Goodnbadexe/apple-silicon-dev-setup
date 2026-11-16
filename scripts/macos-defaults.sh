#!/usr/bin/env bash
set -euo pipefail

# Opinionated, reversible macOS defaults for software development.

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'Error: macOS defaults can only be applied on Darwin.\n' >&2
  exit 1
fi

# Finder: show extensions, hidden files, path bar, and status bar
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keyboard: fast key repeat and disable press-and-hold for accents
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Dock: auto-hide and remove recent apps section
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48

# Screenshots: save PNGs to ~/Screenshots without drop shadow
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Restart affected UI services
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

printf 'Applied macOS developer defaults.\n'
