#!/bin/dash

MONITOR=$(bspc query --monitor focused --monitors --names)
option=$1

if [ "$MONITOR" = "$1" ]; then
    printf "%s" ""
else
    printf "%s" ""
fi
