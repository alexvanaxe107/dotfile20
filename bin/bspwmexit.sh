#!/bin/dash

confirm="$(printf "No\\nYes" | dmenu -i -p "$2" -nb darkred -sb red -sf white -nf gray )"

action=$1

if [ "Yes" = "$confirm" ]
then
    case "$action" in
        "-e") bspc quit;;
        "-r") bspc wm -r;;
    esac
fi
