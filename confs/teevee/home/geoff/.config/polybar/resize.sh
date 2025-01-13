#!/usr/bin/env bash

eval $(xdotool getwindowfocus getwindowgeometry --shell)
let "w = $WIDTH + $1"
let "h = $HEIGHT + $1"

# GTK apps are not having the window borders taken into account properly
# my openbox theme has 8px borders
gtk=$(( $(xprop -id $(xdotool getwindowfocus) | grep "_GTK_MENUBAR" | wc -l) > 0 ))
b=$(( gtk > 0 ? 8 : 0 ))

if [ $2 > 0 ]; then
  # let "s = $1 / 2"
  # let "x = $X - $s"
  # let "y = $Y - $s"
  s=$(( $1 / 2 ))
  x=$(( X - b - s ))
  y=$(( Y - b - s ))
  wmctrl -r ":ACTIVE:" -e "0,$x,$y,$w,$h"
else
  wmctrl -r ":ACTIVE:" -e "0,$x,$y,-1,-1"
fi
