#!/bin/dash

RED='\033[0;31m'
MONITOR=$(bspc query --monitor focused --monitors --names)
option=$1

if [ "$MONITOR" = "$1" ]; then
    printf "%s" "%{F#6BE51A}%{F-}"
else
    printf "%s" "%{F#AF2B26}%{F-}"
fi
