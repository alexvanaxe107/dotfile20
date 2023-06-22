#!/usr/bin/env bash

remoteHScreen=1366
remoteVScreen=768
refreshRate=60

dimension=""
exclude=""

define_primary() {
    primary=$1

    xrandr --output ${primary} --primary 
}

all_on() {
    monitors=$(monitors_info.sh  -c)

    for monitor in ${monitors}; do
        xrandr --output ${monitor} --auto
    done
}

toggle_monitor() {
    monitor=$1

    monitor_id=$(monitors_info.sh -in ${monitor})
    
    dim=$(xrandr | grep ${monitor} -A 1 | grep "+" | awk '{print $1}' | tail -n 1)
    if [ -z "${monitor_id}" ]; then
        xrandr --output ${monitor} --mode ${dim} --auto
        exit 0
    fi
    xrandr --output ${monitor} --off
}

define_order() {
    list="$1"
    count=2
    
    for monitor in $list; do
        left_of=$(echo "$list" | awk -v F=$count '{print $F}' FS=" ")
        count=$((${count}+1))
        #dim="$(xrandr | grep "${monitor}" | grep -Po "\b\d+x\d+" | head -n 1)"

        dim="$(xrandr | grep "${monitor}" -A 40 | grep "*" | head -n 1 | awk '{print $1}')"
        if [ -z "${dim}" ]; then
            dim="--auto"
        else
            dim="--mode ${dim}"
        fi

        if [ ! -z "${left_of}" ]; then
            command="${command} --output ${monitor} --left-of ${left_of} ${dim}"
        else
            command="${command} --output ${monitor} ${dim}"
        fi
    done

    command="xrandr $command"

    echo "$command"

    ${command}
}

rotate() {
    direction=$2
    monitor=$1

    options='leftrightinvertednormal'
    if [[ $options != *"${direction}"* ]]; then
      echo "The value must be left, right, inverted or normal" >&2
      exit 1
    fi
    
    xrandr --output "${monitor}" --rotate "${direction}"

    if [[ $direction == "left" ]]; then
        kanshi -c ~/.config/kanshi/config.rotated
    fi
    if [[ $direction == "normal" ]]; then
        kanshi -c ~/.config/kanshi/config
    fi
}

# This function adds a monitor that acts as a span. It considers multiple monitors like one.
# Make it more configurable?
manage_span() {
        local sum="$(monitors_info.sh -D)"
        if [[ ! -z "${exclude}" ]]; then
            bspc monitor SPAN -r
        else
            bspc wm -a SPAN ${sum}x1080+0+0
        fi
}

add_virtual() {
    params=$(gtf ${remoteHScreen} ${remoteVScreen} ${refreshRate} | grep Modeline | sed 's/^\s\sModeline \".*\"\s*//g')

    if [ ! -z "${dimension}" ]; then
        remoteHScreen=$(echo "${dimension}" | awk '{print $1}' FS="x") 
        remoteVScreen=$(echo "${dimension}" | awk '{print $2}' FS="x") 
    fi

    local virtual_name="$(xrandr | grep "VIRTUAL" | grep "disconnected" | cut -d " " -f 1 | head -n 1)"
    xrandr --newmode "${remoteHScreen}x${remoteVScreen}" ${params}
    xrandr --addmode "${virtual_name}" "${remoteHScreen}x${remoteVScreen}"
}

remove_virtual() {
    local virtual="$1"
    local dim="$(monitors_info.sh -d $virtual)"
    remoteHScreen=$(echo "${dim}" | awk '{print $1}' FS="x") 
    remoteVScreen=$(echo "${dim}" | awk '{print $2}' FS="x") 

    xrandr --delmode "${virtual}" "${remoteHScreen}x${remoteVScreen}"
    xrandr --rmmode "${remoteHScreen}x${remoteVScreen}"
}

set_dimension() {
    local monitor="$1"
    local dim="$2"

    if [ -z "${dim}" ]; then
        dim="--auto"
    else
        dim="--mode ${dim}"
    fi
    
    xrandr --output ${monitor} ${dim}
}

show_help() {
    echo "Manipulate the monitors."; echo ""
    echo "-p [name]                             Define wich monitor is the primary."
    echo "-t [name]                             Toggle monitor on and off"
    echo "-o [order]                            Send a list with the order of the monitors"
    echo "-r [direction]                        Rotate the monitor to the desired location - normal, left, right or inverted "
    echo "-v                                    Add virtual monitor"
    echo "-d                                    Redimension a monitor"
    echo "-V [monitor]                          remove a virtual monitor"
    echo "-s                                    Create a span monitor"
    echo "-a                                    Turn on all monitors."
    echo "-x                                    Flag to exclude the monitor"
}


while getopts "h?ap:t:o:vV:d:r:sx" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    x) exclude="1"
        ;;
    p) define_primary $OPTARG
        ;;
    t) toggle_monitor $OPTARG
        ;;
    o) define_order "$OPTARG"
        ;;
    r) rotate "$OPTARG" $3
        ;;
    V) remove_virtual "$OPTARG"
        ;;
    d) set_dimension "$OPTARG" "$3"
        ;;
    v) add_virtual
        ;;
    a) all_on
        ;;
    s) manage_span
        ;;
    esac
done

