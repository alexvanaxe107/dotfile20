#!/usr/bin/env bash

HOST_NAME="$HOSTNAME"
CHOSE=$1

if [ "$HOST_NAME" == "persistence" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-2\nHDMI-A-0 | fzf"
    else
        echo "DP-3"
    fi
    
    exit 0
fi
