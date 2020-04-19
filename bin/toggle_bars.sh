#!/bin/sh

PID=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
PID_SIMPLE=$(ps aux | egrep "[p]olybar.*simple" | awk '{print $2}')

MONITOR1=$(polybar -m | cut -d":" -f1 | awk 'NR==1 {print $0}')
MONITOR2=$(polybar -m | cut -d":" -f1 | awk 'NR==2 {print $0}')

TARGET=$1

toggle_full(){
    if [ "$TARGET" = "--target1" ]; then
        if [ ! -z "$PID" ]; then
            bspc config -m $MONITOR1 top_padding 0
            kill $PID
        else
            bspc config -m $MONITOR1 top_padding 16
            MONITOR1=$MONITOR1 polybar -q default  >>/tmp/polybar1.log 2>&1 &
        fi
    fi
}

toggle_simple(){
    if [ "$TARGET" = "--target2" ]; then
        if [ ! -z "$PID_SIMPLE" ]; then
            kill $PID_SIMPLE
        else
            MONITOR2=$MONITOR2 polybar -q -c $HOME/.config/polybar/config_simple simple >>/tmp/polybar2.log 2>&1 &
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
        MONITOR1=$MONITOR1 polybar -q default >>/tmp/polybar1.log 2>&1 &
        MONITOR2=$MONITOR2 polybar -q -c $HOME/.config/polybar/config_simple simple >>/tmp/polybar2.log 2>&1 &
    fi
}

case "$TARGET" in
    "--target2") $(toggle_simple);;
    "--target1") $(toggle_full);;
    *) $(toggle_all);;
esac

