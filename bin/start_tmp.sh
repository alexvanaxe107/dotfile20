#!/bin/bash

DP="DisplayPort-2"
HDMI="HDMI-A-0"


#display_manager.sh -o "$DP $HDMI"
#display_manager.sh -p "$DP"
xrandr --output HDMI-A-0 --off


game="$(which $1)"
echo "starting ${game}"
