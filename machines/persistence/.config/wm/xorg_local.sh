#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

DP="DisplayPort-2"
DP2="DisplayPort-0"
HDMI="HDMI-A-0"

if [ "$1" == "getgs" ]; then
    echo "DP-3"
    exit 0
fi

xrandr --output $DP --set TearFree on
xrandr --output $DP2 --set TearFree on
xrandr --output $HDMI --set TearFree on

display_manager.sh -p "$DP"
display_manager.sh -o "$HDMI $DP $DP2"
display_manager.sh -r "$HDMI" "left"
