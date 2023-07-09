#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

DP="DisplayPort-2"
HDMI="HDMI-A-0"

display_manager.sh -p "$DP"
display_manager.sh -r "$HDMI" right
display_manager.sh -o "$DP $HDMI"
