#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

DP="DisplayPort-2"
HDMI="HDMI-A-0"

xrandr --output $DP --set TearFree on
xrandr --output $HDMI --set TearFree on

display_manager.sh -p "$DP"
display_manager.sh -r "$HDMI" "left"
display_manager.sh -o "$DP $HDMI"
