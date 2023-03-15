#!/bin/bash

status=""

show_help() {
    echo "Show notifications of status of the system"
    echo "-c                         Show cpu"
    echo "-t                         Show cpu temp"
    echo "-l                         Show load"
    echo "-m                         Show memory"
    echo "-v                         Show volume"
    echo "-w                         Show weather"
}

cpu() {
#    status="$status\nCPU = $(cpu.sh)"
    status="$status\nCPU = $(psuinfo -Ca)"
}

cpu_temp() {
    status="$status\nCPU Temp = $(psuinfo -Ct)"
}

p_load() {
    status="$status\nLoad = $(load)"
}

p_mem() {
    status="$status\nMem = $(psuinfo -CMc)"
}

p_vol() {
    status="$status\nVol = $(volume_display)"
}

weather() {
    status="$status\nWeather = $(weather.sh)"
}

print_message() {
    notify-send "status" "$status"
}

rcommand=""
option=""
while getopts "h?clmtvw" opt; do
    case "${opt}" in
    h|\?) show_help ;;
    c) cpu;;
    t) cpu_temp;;
    l) p_load;;
    m) p_mem;;
    v) p_vol;;
    w) weather;;
    i) rcommand="i";option=${OPTARG};;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "S") save "$1";;
esac
    
print_message
