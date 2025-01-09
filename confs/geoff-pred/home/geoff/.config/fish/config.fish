set fish_greeting
set EDITOR "nvim"
set VISUAL "emacs"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/geoff/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
starship init fish | source

# opam configuration
source /home/geoff/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

set PATH ~/.npm-global/bin $PATH

alias doom="~/.emacs.d/bin/doom"
