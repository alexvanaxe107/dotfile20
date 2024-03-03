#!/usr/bin/env bash

HOST_NAME="$HOSTNAME"
CHOSE=$1

if [ "$HOST_NAME" == "persistence" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-2"
    else
        echo "DP-3"
    fi
    xrandr --output HDMI-A-0 --off
    
    exit 0
fi
