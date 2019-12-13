#!/bin/sh

PID=$(pgrep -a conky | grep desktops | awk '{print $1}')

if [ ! -z $PID ]; then
    kill -9 $PID
    bspc config top_padding 0
else
    conky -dc $HOME/.config/conky/night/desktops.conf
    bspc config top_padding 20
fi
