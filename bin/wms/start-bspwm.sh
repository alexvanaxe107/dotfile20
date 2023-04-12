#!/bin/bash

DP="DisplayPort-2"
HDMI="HDMI-A-0"
chosen="$DESK_ENV"

display_manager.sh -o "$DP $HDMI"
if [ "${chosen}" == "Work" ]; then
    xrandr --output $DP --mode "1920x1080"
fi
if [ "${chosen}" == "Game" ]; then
    xrandr --output $DP --mode "2560x1440"
fi
display_manager.sh -p "$DP"
display_manager.sh -r "$HDMI" right
display_manager.sh -o "$DP $HDMI"

#display_manager.sh -r "HDMI-2" "left"
#xrandr --output $HDMI --scale 1.5x1.5

systemd --user

#exec dbus-launch --exit-with-session bspwm
exec bspwm

