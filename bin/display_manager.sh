#!/bin/dash

show_help() {
    echo "Manipulate the monitors."; echo ""
    echo "-p [name]                             Define wich monitor is the primary."
    echo "-t [name]                             Toggle monitor on and off"
    echo "-o [order]                            List with the order of the monitors"
    echo "-a                                    Turn on all monitors."
}

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
        dim=$(xrandr | grep ${monitor} -A 1 | grep "+" | awk '{print $1}' | tail -n 1)
        if [ ! -z "${left_of}" ]; then
            command="${command} --output ${monitor} --left-of ${left_of} --mode ${dim}"
        else
            command="${command} --output ${monitor} --mode ${dim}"
        fi
    done

    command="xrandr $command"
    ${command}
}

while getopts "h?ap:t:o:" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    p) define_primary $OPTARG
        ;;
    t) toggle_monitor $OPTARG
        ;;
    o) define_order "$OPTARG"
        ;;
    a) all_on
        ;;
    esac
done

