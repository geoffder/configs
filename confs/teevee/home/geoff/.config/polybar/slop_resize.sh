#!/usr/bin/env bash

eval $(xdpyinfo | awk '/dimensions/{print "DESK_W="$1, "DESK_H="$2}' FPAT='[0-9]+')
eval $(slop -t 0 -b $1 -c $2 -f 'X=%x Y=%y W=%w H=%h')

if [[ $W > 10 && $H > 10 ]]; then
  pad=25
  ypad=60  # avoid polybar
  min_w=300
  min_h=300

  x=$(( X > pad ? X : pad ))
  y=$(( Y > (ypad + pad) ? Y : (ypad + pad) ))
  max_w=$(( DESK_W - pad - x ))  # left x pad already applied
  max_h=$(( DESK_H - pad - y ))  # extra top ypad already applied
  w=$(( x > X ? W + X - x : W))  # trim padding overlap
  h=$(( y > Y ? H + Y - y : H))
  w=$(( w > max_w ? max_w : $(( w < min_w ? min_w : w )) ))
  h=$(( h > max_h ? max_h : $(( h < min_h ? min_h : h)) ))

  wmctrl -r ":ACTIVE:" -e "0,$x,$y,$w,$h"
fi
