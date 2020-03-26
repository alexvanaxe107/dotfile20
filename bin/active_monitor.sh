#!/bin/sh


MONITOR=$(bspc query --monitor focused --monitors --names)
option=$1

if [ "$1" == "simple" ]; then
    if [ "$MONITOR" == "HDMI1" ]; then
        echo 
    else
        echo 
    fi
else
    if [ "$MONITOR" == "HDMI1" ]; then
        echo 
    else
        echo 
    fi
fi
