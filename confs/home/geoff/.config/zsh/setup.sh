#!/bin/bash

git clone https://github.com/zdharma/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions

# force rebuild of completions folder
rm -f ~/.zcompdump; compinit
