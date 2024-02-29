#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

HOST_NAME="$HOSTNAME"
CHOSE=$1

if [ "$HOST_NAME" == "persistence" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-0"
    else
        echo "DP-3"
    fi
    
    exit 0
fi
