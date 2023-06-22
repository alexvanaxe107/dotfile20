#!/usr/bin/env bash

DP="DisplayPort-2"
HDMI="HDMI-A-0"


#display_manager.sh -o "$DP $HDMI"
#display_manager.sh -p "$DP"
xrandr --output HDMI-A-0 --off
xrandr --output $DP --mode "1920x1080"

game="$(which $1)"
echo "starting ${game}"

