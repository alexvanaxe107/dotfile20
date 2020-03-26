#!/bin/sh

PID=$(pgrep -a polybar | grep "default" | awk '{print $1}')

if [ ! -z $PID ]; then
    bspc config top_padding 0
    kill $PID
else
    bspc config top_padding 16
    polybar default &
    polybar -c /home/alexvanaxe/.config/polybar/config_simple simple &
fi
