# Globals

DOTFILES="$HOME/.config"
ZSH_CUSTOM="$DOTFILES/zsh"

DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

export XDG_CONFIG_HOME="$DOTFILES"

autoload -Uz compinit && compinit
setopt COMPLETE_ALIASES

# Plugins

source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# User

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export FZF_TMUX_OPTS="-p 90%,70%"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"

# Device

# gitignored secrets, which may not exist
if [ -f "$ZSH_CUSTOM/environment.sh" ]; then
  source "$ZSH_CUSTOM/environment.sh"
fi;

case "$HOST" in
  Fractal)
    source "$ZSH_CUSTOM/desktop.sh"
    ;;
  Lauriss-MacBook-Pro.local)
    source "$ZSH_CUSTOM/laptop.sh"
    ;;
  Lauris-M5.local)
    source "$ZSH_CUSTOM/work.sh"
    ;;
esac

# Custom

source "$ZSH_CUSTOM/aliases.sh"
source "$ZSH_CUSTOM/functions.sh"
