#!/usr/bin/env bash

HOST_NAME="$HOSTNAME"
CHOSE=$1

ENV_DISPLAY="$AVA_DISPLAY"

if [ -z "$AVA_DISPLAY" ]; then
    echo "$AVA_DISPLAY"
    exit 0
fi


if [ "$HOST_NAME" == "persistence" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-2"
    else
        echo "DP-3"
    fi
    
    exit 0
fi

if [ "$HOST_NAME" == "Jason" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "DisplayPort-0"
    else
        echo "DP-1"
    fi
    
    exit 0
fi

if [ "$HOST_NAME" == "palauai" ]; then
    if [ "${CHOSE}" == "yes" ]; then
        echo "eDP-1"
    else
        echo "DP-1"
    fi
    
    exit 0
fi
