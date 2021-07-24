#! /bin/bash
# lxsession &
picom --experimental-backends &
nitrogen --restore &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# urxvtd -q -o -f &
# /usr/bin/emacs --daemon &
volumeicon &
nm-applet &
clipit &
blueman-applet &
redshift-gtk -t 6500:4000 &
xautolock -time 10 -locker "i3lock-fancy-rapid 5 3" &
flameshot &
xfce4-power-manager &
