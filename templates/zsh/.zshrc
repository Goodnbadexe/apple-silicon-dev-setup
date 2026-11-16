# Apple Silicon Developer Zsh Configuration

# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Navigation & completion
setopt AUTO_CD
autoload -Uz compinit && compinit

# Editor
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# PATH additions
export PATH="${HOME}/.local/bin:${PATH}"

# Tool integrations (enabled only when installed)
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# Useful aliases
alias ll="ls -lah"
alias gs="git status -sb"
alias gl="git log --oneline -n 20"

# Machine-specific overrides (not tracked in Git)
if [[ -f "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi
