#!/bin/bash

DP="DisplayPort-0"
HDMI="HDMI-A-0"

display_manager.sh -o "$DP $HDMI"
display_manager.sh -p "$DP"

#display_manager.sh -r "HDMI-2" "left"
xrandr --output $DP --mode "2560x1440"

systemd --user

#exec dbus-launch --exit-with-session bspwm
exec bspwm
