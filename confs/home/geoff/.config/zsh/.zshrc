# set default user for local to hide geoff@...
DEFAULT_USER="geoff"

### Completions and History ###

fpath=($ZDOTDIR/zsh-completions/src $fpath)
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files
source $ZDOTDIR/completion.zsh

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Up-Down History searching, rather than simply chronological
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Directory Stack settings
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

# `d` to get a numbered list of recent directories that can be jumped to
# by executing the matching alias from 1 to 9
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

######################

### VIM MODE ###

bindkey -v
export KEYTIMEOUT=1

cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

###########################

### Syntax Highlighting ###

source $ZDOTDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
FAST_WORK_DIR=$ZDOTDIR/fsh

###########################

### Misc Initializations ###

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/geoff/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/geoff/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/geoff/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/geoff/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Add NEURON to path
export PATH=$PATH:/home/geoff/neuron/nrn/x86_64/bin

# opam configuration
test -r /home/geoff/.opam/opam-init/init.zsh && . /home/geoff/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

source <("/bin/starship" init zsh --print-full-init)

###########################
