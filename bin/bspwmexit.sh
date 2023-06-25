#!/usr/bin/env bash
. $HOME/.config/wm/bspwm.conf

confirm="$(printf "No\\nYes" | ava_dmenu -i -p "$2" -nb darkred -sb red -sf white -nf gray -theme ${rofi_item2})"

action=$1

if [ "Yes" = "$confirm" ]
then
    case "$action" in
        "-e") bspc quit;;
        "-r") bspc wm -r;;
        "-x") pkill -USR1 -x sxhkd;;
    esac
fi
