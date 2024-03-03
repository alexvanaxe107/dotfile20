#!/usr/bin/env bash

HOST_NAME="$HOSTNAME"
CHOSE=$1

if [ "$HOST_NAME" == "persistence" ]; then
    xrandr --output HDMI-A-0 --off
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-2"
    else
        echo "DP-3"
    fi
    
    exit 0
fi
