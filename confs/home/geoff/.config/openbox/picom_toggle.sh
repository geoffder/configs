#!/bin/sh

if [ $(pgrep -c -x picom) -gt 0 ]
then
    pkill picom
else
    exec /usr/bin/picom -b
fi
