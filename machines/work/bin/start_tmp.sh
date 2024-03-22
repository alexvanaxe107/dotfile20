#!/usr/bin/env bash

HOST_NAME="$HOSTNAME"

if [ "$HOST_NAME" == "persistence" ]; then
    xrandr --output HDMI-A-0 --off
    xrandr --output DisplayPort-0 --off
fi

game="$(which $1)"
echo "starting ${game}"
