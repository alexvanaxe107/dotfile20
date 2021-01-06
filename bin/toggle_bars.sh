#!/bin/dash

if [ -z "${PREFERENCE}" ]; then
    MONITOR1=$(monitors_info.sh -t 0)
    MONITOR2=$(monitors_info.sh -t 1)
fi

TARGET=$1

dim=$(grep ";dim-value" -w $HOME/.config/polybar/config)
dim_simple=$(grep ";dim-value" -w $HOME/.config/polybar/config_simple)

toggle_tint(){
    pid=$(ps aux | egrep "[t]int2" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 right_padding 0
        bspc config -m $MONITOR2 right_padding 0
        kill $pid
    else
        #bspc config -m $MONITOR1 right_padding 203
        tint2 >> /tmp/tint2.log 2>&1 &
    fi
}

toggle_full(){
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 top_padding 0
        kill $pid
    else
        if [ ! -z "${dim}" ]; then
            bspc config -m $MONITOR1 top_padding 16
        fi
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
    pid_tint=$(ps aux | egrep "[t]int2" | awk '{print $2}')
    if [ ! -z "$pid_tint" ]; then
        kill ${pid_tint}
        sleep 1
        toggle_tint
    fi
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
        if [ ! -z "${dim}" ]; then
            bspc config -m $MONITOR1 top_padding 16
        fi
        bspc config -m $MONITOR2 top_padding 0
        MONITOR1=$MONITOR1 polybar -q default >>/tmp/polybar1.log 2>&1 &
        if [ ! -z ${MONITOR2} ]; then
            MONITOR2=$MONITOR2 polybar -q -c $HOME/.config/polybar/config_simple simple >>/tmp/polybar2.log 2>&1 &
        fi
    fi
}

auto_hide(){
    if [ -z "${dim_simple}" ]; then
        sed -i "s/dim-value/;dim-value/" ${HOME}/.config/polybar/config_simple
    else
        sed -i "s/;dim-value/dim-value/" ${HOME}/.config/polybar/config_simple
    fi

    if [ -z "${dim}" ]; then
        sed -i "s/dim-value/;dim-value/" ${HOME}/.config/polybar/config
        sed -i "s/;wm-restack/wm-restack/" ${HOME}/.config/polybar/config
    else
        sed -i "s/;dim-value/dim-value/" ${HOME}/.config/polybar/config
        sed -i "s/wm-restack/;wm-restack/" ${HOME}/.config/polybar/config
    fi

}

case "$TARGET" in
    "--target2") $(toggle_simple);;
    "--target1") $(toggle_full);;
    "--tint") $(toggle_tint);;
    "--restart") restart_bar;;
    "--autohide") auto_hide;;
    *) $(toggle_all);;
esac

