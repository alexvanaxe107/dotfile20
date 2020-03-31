#!/bin/sh

PID=$(pgrep -a polybar | grep "default" | awk '{print $1}')
PID_SIMPLE=$(pgrep -a polybar | grep "simple" | awk '{print $1}')

MONITOR1=$(polybar -m | cut -d":" -f1 | awk 'NR==1 {print $0}')
MONITOR2=$(polybar -m | cut -d":" -f1 | awk 'NR==2 {print $0}')

if [ ! -z $PID ]; then
    bspc config top_padding 0
    kill $PID
    kill $PID_SIMPLE
else
    bspc config -m $MONITOR1 top_padding 16
    bspc config -m $MONITOR2 top_padding 0
    MONITOR1=$MONITOR1 polybar default &
    MONITOR2=$MONITOR2 polybar -c $HOME/.config/polybar/config_simple simple &
fi
