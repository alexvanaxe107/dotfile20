#!/bin/dash

MONITOR1=$(polybar -m | grep -v primary | cut -d":" -f1 | awk '{print $0}')

if [ -z $MONITOR1 ]; then
    MONITOR1=$(polybar -m | grep primary | cut -d":" -f1 | awk '{print $0}')
else
    MONITOR2=$(polybar -m | grep primary | cut -d":" -f1 | awk '{print $0}')
fi


TARGET=$1

toggle_full(){
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 top_padding 0
        kill $pid
    else
        bspc config -m $MONITOR1 top_padding 16
        MONITOR1=$MONITOR1 polybar -q default  >>/tmp/polybar1.log 2>&1 &
    fi
}

toggle_simple(){
    pid_simple=$(ps aux | egrep "[p]olybar.*simple" | awk '{print $2}')
    if [ ! -z "$pid_simple" ]; then
        kill $pid_simple
    else
        MONITOR2=$MONITOR2 polybar -q -c $HOME/.config/polybar/config_simple simple >>/tmp/polybar2.log 2>&1 &
    fi
}

restart_bar(){
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    pid_simple=$(ps aux | egrep "[p]olybar.*simple" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        kill ${pid}
        sleep 1
        toggle_full
    fi
    if [ ! -z "$pid_simple" ]; then
        kill ${pid_simple}
        sleep 1
        toggle_simple
    fi
}

toggle_all(){
    pid_simple=$(ps aux | egrep "[p]olybar.*simple" | awk '{print $2}')
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    if [ ! -z $pid ]; then
        bspc config top_padding 0
        kill $pid
        kill $pid_simple
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
    "--restart") restart_bar;;
    *) $(toggle_all);;
esac

