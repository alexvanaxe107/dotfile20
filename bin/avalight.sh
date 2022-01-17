#! /bin/bash

get_monitors() {
    monitors=$(monitors_info.sh -m)

    echo "$monitors"
}

reset_lightness() {
    killall clight
    local monitors="$(get_monitors)"

    for monitor in ${monitors}; do
        xrandr --output ${monitor} --brightness 1
    done
}

reset_auto() {
    killall clight
}

eDP() {
    local val="$1"
    local monitor="$2"

    case "${soft}" in
        0) light -S ${val};;
        1) xrandr --output ${monitor} --brightness $(echo "${val}/100" | bc -l);;
    esac
}

change_hdmi_font() {
    monitor="$1"

    monitor_num="$(($(monitors_info.sh -in "${monitor}") + 1))"

    ddcutil setvcp -d "${monitor_num}" 10 ${val}
}


HDMI() {
    local val="$1"
    local monitor="$2"

    case "${soft}" in
        0) $(change_hdmi_font "${monitor}");;
        1) xrandr --output ${monitor} --brightness $(echo "${val}/100" | bc -l);;
    esac
}

adjust_brightness() {
    reset_auto
    local val="$1"
    local monitors="$2"

    if [ -z "${monitors}" ]; then
        monitors="$(get_monitors)"
    fi

    for monitor in ${monitors}
    do
        case ${monitor} in
            eDP*) $(eDP $val $monitor)
            ;;
            # A principio todos os outros metodos sao os mesmos, ir testando e refazendo
            *) $(HDMI $val $monitor)
            ;;
        esac
    done
}

autob() {
    killall clight
    clight&
}

show_help() {
    echo "Adjust the brightness the best way we can"
    echo "-I [val] [:MONITOR:]       Set the brightness"
    echo "-A                         Set the auto brightness"
    echo "-R                         Reset the xrandr and turn off the auto light"
    echo "-s                         Configure to change in xrandr instead of the monitor"

}

rcommand="0"
soft="0"

while getopts "h?IARs" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        s) soft="1";;
        I) rcommand="i";;
        A) rcommand="a";;
        R) rcommand="r";;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "i") adjust_brightness "$1" "$2";;
    "a") autob;;
    "r") reset_lightness;;
esac
