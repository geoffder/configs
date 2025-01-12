#!/usr/bin/env bash

eval $(xdotool getwindowfocus getwindowgeometry --shell)
let "w = $WIDTH + $1"
let "h = $HEIGHT + $1"

# xdotool getwindowfocus windowsize $w $h

if [ $2 > 0 ]; then
  let "s = $1 / 2"
  let "x = $X - $s"
  let "y = $Y - $s"
  # xdotool getwindowfocus windowmove $x $y
  wmctrl -r ":ACTIVE:" -e "0,$x,$y,$w,$h"
else
  wmctrl -r ":ACTIVE:" -e "0,$x,$y,-1,-1"
fi
