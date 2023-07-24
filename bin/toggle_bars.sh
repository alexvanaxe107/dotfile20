#!/usr/bin/env bash

if [ -z "${PREFERENCE}" ]; then
    MONITOR1=$(monitors_info.sh -t 0)
    MONITOR2=$(monitors_info.sh -t 1)
fi

TARGET=$1

dim=$(grep ";dim-value" -w $HOME/.config/polybar/config)
dim_simple=$(grep ";dim-value" -w $HOME/.config/polybar/config_simple)

dmenu=$(which ava_dmenu)

toggle_light() {
    pid=$(ps aux | egrep "[l]emonbar" | awk '{print $2}')

    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 bottom_padding 0
        bspc config -m $MONITOR2 bottom_padding 0
        kill $pid
    else
        lemonbar.sh | lemonbar -b -o "$MONITOR2" 2>&1 &
    fi
}

toggle_tint(){
    pid=$(ps aux | egrep "[t]int2" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 right_padding 0
        bspc config -m $MONITOR2 right_padding 0
        bspc config -m $MONITOR1 left_padding 0
        bspc config -m $MONITOR2 left_padding 0
        kill $pid
    else
        sed -i "s/panel_monitor.*/panel_monitor = ${MONITOR1}/" ${HOME}/.config/tint2/tint2rc
        #bspc config -m $MONITOR1 right_padding 203
        tint2 >> /tmp/tint2.log 2>&1 &
    fi
}

toggle_tint_h(){
    pid=$(ps aux | egrep "[t]int2" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        kill $pid
        bspc config -m $MONITOR1 right_padding 0
        bspc config -m $MONITOR2 right_padding 0
        bspc config -m $MONITOR1 left_padding 0
        bspc config -m $MONITOR2 left_padding 0
        bspc config -m $MONITOR1 bottom_padding 0
        bspc config -m $MONITOR2 bottom_padding 0
    else
        sed -i "s/panel_monitor.*/panel_monitor = ${MONITOR1}/" ${HOME}/.config/tint2/tint2rc_h1
        #bspc config -m $MONITOR1 right_padding 203
        tint2 -c ${HOME}/.config/tint2/tint2rc_h1 >> /tmp/tint2.log 2>&1 &
    fi
}

toggle_full(){
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    if [ ! -z "$pid" ]; then
        bspc config -m $MONITOR1 top_padding 0
        bspc config -m $MONITOR1 bottom_padding 0
        kill $pid
    else
        if [ ! -z "${dim}" ]; then
            bspc config -m $MONITOR1 top_padding 0
            bspc config -m $MONITOR1 bottom_padding 0
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

toggle_eww() {
    local panel="$1"

    eww open --toggle $panel
}

toggle_all(){
    pid_simple=$(ps aux | egrep "[p]olybar.*simple" | awk '{print $2}')
    pid=$(ps aux | egrep "[p]olybar.*default" | awk '{print $2}')
    if [ ! -z $pid ]; then
        bspc config top_padding 0
        bspc config bottom_padding 0
        kill $pid
        kill $pid_simple
    else
        if [ ! -z "${dim}" ]; then
            bspc config -m $MONITOR1 top_padding 0
            bspc config -m $MONITOR1 bottom_padding 0
        fi
        bspc config -m $MONITOR2 top_padding 0
        bspc config -m $MONITOR2 bottom_padding 0
        MONITOR1=$MONITOR1 polybar -q default >>/tmp/polybar1.log 2>&1 &
        #if [ ! -z ${MONITOR2} ]; then
            #MONITOR2=$MONITOR2 polybar -q -c $HOME/.config/polybar/config_simple simple >>/tmp/polybar2.log 2>&1 &
        #fi
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

toggle_options () {
    local toggle=$(echo -e "eww1\neww2" | $dmenu -l 10 -p "Which bar to toggle?")
    case "$toggle" in
        "target2") $(toggle_simple);;
        "target1") $(toggle_full);;
        "tint") $(toggle_tint);;
        "eww1") $(toggle_eww "general_infos");;
        "eww2") $(toggle_eww "pc_infos");;
        "tinth") $(toggle_tint_h);;
        "light") $(toggle_light);;
        "restart") restart_bar;;
        "autohide") auto_hide;;
        "options") toggle_options;;
    esac


}

case "$TARGET" in
    "--target2") $(toggle_simple);;
    "--target1") $(toggle_full);;
    "--tint") $(toggle_tint);;
    "--eww1") $(toggle_eww "general_infos");;
    "--eww2") $(toggle_eww "pc_infos");;
    "--tinth") $(toggle_tint_h);;
    "--light") $(toggle_light);;
    "--restart") restart_bar;;
    "--autohide") auto_hide;;
    "--options") toggle_options;;
    *) $(toggle_all);;
esac

