#!/bin/sh


confirm="$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray )"

if [ "Yes" == "$confirm" ]
then
    bspc quit
fi
