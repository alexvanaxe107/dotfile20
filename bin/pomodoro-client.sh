#!/usr/bin/env bash

source $HOME/.config/wm/bspwm.conf

dmenu=ava_dmenu

show_help() {
    echo "Manage the pomodoro"
    echo "-s               Start a pomodoro."
    echo "-f               Finish a pomodoro."
}

start_pomodoro(){
    pomodoro-client.py start
}

while getopts "hsf" opt; do
    case "$opt" in
        h) show_help;;
        s) start_pomodoro;;
        f) pomodoro finish;;
    esac
done

if [ -z "$1" ]; then
   
    if [[ $use_rofi -eq 1 ]]; then
	chosen=$(printf "▶\n⏹" | ${dmenu} -i -p "Pomodoro: $(pomodoro_stats.sh)" -theme ${rofi_item2})
    else
	chosen=$(printf "▶\n⏹" | ${dmenu} -i -p "Pomodoro: $(pomodoro_stats.sh)")
    fi

    case "$chosen" in
        "▶") $(start_pomodoro);;
        "⏹") pomodoro-client.py stop;;
    esac
fi
