# Don't display conda (base) env at startup
PS1="$(echo "$PS1" | sed 's/(base) //')"
