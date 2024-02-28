#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

HOST_NAME="$HOSTNAME"

if [ "$HOST_NAME" == "persistence" ]; then
    echo "DP-3"
    exit 0
fi
