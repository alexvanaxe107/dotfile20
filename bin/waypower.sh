#!/usr/bin/env bash


command=$1
secondcmd=$3

screen_off() {
    hyprctl dispatch dpms off
}

screen_on() {
    hyprctl dispatch dpms on
}

while getopts "oO" opt; do
    case "$opt" in
        o) command="o";; 
        O) command="O";;
    esac
done

case "$command" in
    "o") screen_off;;
    "O") screen_on;;
    *) exit;;
esac

