export ZDOTDIR="$HOME/.config/zsh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL="emacs"

export HISTFILE="$ZDOTDIR/.zhistory"  # History filepath
export HISTSIZE=10000                      # Maximum events for internal history
export SAVEHIST=10000                      # Maximum events in history file
