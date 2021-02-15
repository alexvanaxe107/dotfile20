#!/bin/bash
. /home/alexvanaxe/.pyenv/versions/wm/bin/activate


show_help() {
    echo "Manage the pomodoro"
    echo "-s               Start a pomodoro."
    echo "-f               Finish a pomodoro."
}

start_pomodoro(){
    notify-send -u normal "Pomodoro" "Focus on your task"
    pomodoro start
}

while getopts "hsf" opt; do
    case "$opt" in
        h) show_help;;
        s) start_pomodoro;;
        f) pomodoro finish;;
    esac
done

if [ -z "$1" ]; then
    chosen=$(printf "▶\n⏹" | dmenu -i -y 16 -bw 2 -z 470 -p "Pomodoro: $(pomodoro_stats.sh) ")
    case "$chosen" in
        "▶") $(start_pomodoro);;
        "⏹") pomodoro finish;;
    esac
fi
