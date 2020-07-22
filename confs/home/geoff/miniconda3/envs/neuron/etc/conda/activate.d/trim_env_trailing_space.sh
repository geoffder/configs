# Remove the trailing space after env (play with zsh theme)
PS1="$(echo "$PS1" | sed 's/\(^(.*)\) /\1/')"
