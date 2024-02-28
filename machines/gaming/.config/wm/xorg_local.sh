#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

HOST_NAME="$HOST"

if [ "$HOST" == "persistence" ]; then
    echo "DP-1"
    exit 0
fi
