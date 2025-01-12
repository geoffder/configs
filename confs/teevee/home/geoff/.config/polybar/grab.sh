#!/usr/bin/env bash

eval $(xdotool getwindowfocus getwindowgeometry --shell)
xdotool mousemove $(($X + $WIDTH / 2)) $(($Y + $HEIGHT / 2))
sleep 0.2
xdotool key super+ctrl+return
