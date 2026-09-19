# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Env variables
export PATH=$PATH:$HOME/.local/bin
export EDITOR='nvim'

# Setup zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# User configuration
if [ -e $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local 
fi

# Function to send the current folder name to WezTerm as the window/tab title
update_wezterm_title() {
  # %1~ gives just the current folder name (e.g., "project-repo" or "~")
  local dir_name=$(print -P "%1~")
  
  # Zsh's print processes escapes by default, so we only need -n (no newline)
  print -n "\e]2;$dir_name\a"
}

# Function to send the current working directory to WezTerm
function __wezterm_osc7() {
  if hash wezterm 2>/dev/null; then
    # Use WezTerm's helper command to set the working directory if available
    wezterm set-working-directory 2>/dev/null && return
  fi
  # Fallback: Send the current working directory to the terminal using OSC 7
  printf "\033]7;file://%s%s\033\\" "${HOSTNAME}" "${PWD}"
}

# Zsh hooks: run this function on directory change (chpwd) and before initial prompt (precmd)
autoload -Uz add-zsh-hook
add-zsh-hook chpwd update_wezterm_title
add-zsh-hook precmd update_wezterm_title
add-zsh-hook precmd __wezterm_osc7
