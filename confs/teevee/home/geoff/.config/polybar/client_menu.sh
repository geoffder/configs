#!/usr/bin/env bash

eval $(xdotool getwindowfocus getwindowgeometry --shell)
if [[ $1 > 0 ]]; then
  xdotool mousemove $(($X + $WIDTH / 2)) $(($Y + $HEIGHT / 2))
else
  xdotool mousemove $X $Y
fi
xdotool keydown super+ctrl
xdotool click 3
xdotool keyup super+ctrl
