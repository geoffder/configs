# Requires powerline-fonts

# Spectrum colours
# monokai blue    -> 012
# monokai purple  -> 013
# monokai green   -> 010
# monokai magenta -> 009 | 198
# monokai orange  -> 208

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$FG[010]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[208]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

PROMPT='%{$FG[012]%}%1~%{$reset_color%}%{$FG[009]%}  %{$reset_color%}$(git_prompt_info)%{$FG[012]%}=>%{$reset_color%} '
