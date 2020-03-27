#!/bin/sh

MONITOR=$(bspc query --monitor focused --monitors --names)
option=$1

if [ "$MONITOR" == "$1" ]; then
    echo 
else
    echo 
fi
