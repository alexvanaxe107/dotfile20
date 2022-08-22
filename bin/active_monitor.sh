#!/bin/bash

RED='\033[0;31m'
MONITORS="$(bspc query --monitors --names)"
MONITOR="$(bspc query --monitor focused --monitors --names)"
option=$1
text=""

while read line
do
    if [[ "$line" == "${MONITOR}" ]]; then
        text="$text %{F#6BE51A}$line%{F-}"
    else
        text="$text %{F#c9718a}$line%{F-}"
    fi

done <<< $MONITORS

printf "%s" "${text}"
