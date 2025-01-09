#!/bin/bash
xrandr --output HDMI-A-0 --off
xrandr --output HDMI-A-0 --auto
polybar -c /home/geoff/.config/polybar/config "main"
