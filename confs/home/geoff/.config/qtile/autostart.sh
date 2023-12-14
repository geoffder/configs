#! /bin/bash
# lxsession &
picom &
nitrogen --restore &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# urxvtd -q -o -f &
# /usr/bin/emacs --daemon &
volumeicon &
nm-applet &
clipit &
blueman-applet &
#redshift-gtk -t 6500:4000 &
xautolock -time 10 -locker "i3lock-fancy-rapid 5 3" &
flameshot &
xfce4-power-manager &
udiskie &
xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Button Scrolling Button' 9 &
xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Scroll Method Enabled' 0 0 1 &
