#!/bin/sh

PID=$(pgrep -a polybar | grep "default" | awk '{print $1}')
PID_SIMPLE=$(ps aux | egrep "[p]olybar.*[s]imple")

MONITOR1=$(polybar -m | cut -d":" -f1 | awk 'NR==1 {print $0}')
MONITOR2=$(polybar -m | cut -d":" -f1 | awk 'NR==2 {print $0}')

TARGET=$1

echo $PID_SIMPLE

toggle_simple(){
    notify-send "$PID_SIMPLE"
    if [[ "$TARGET" = "--target2" ]]; then
        if [[ ! -z "$PID_SIMPLE" ]]; then
            kill $PID_SIMPLE
        else
            MONITOR2=$MONITOR2 polybar -c $HOME/.config/polybar/config_simple simple &
        fi
    fi
}

toggle_all(){
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
}

case "$TARGET" in
    "--simple") $(toggle_simple);;
    *) $(toggle_all);;
esac

