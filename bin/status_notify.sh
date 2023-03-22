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
    echo "-d                         Show time"
    echo "-M                         Show top 10 memory process"
    echo "-C                         Show top 10 CPU process"
    echo "-s                         Show song status"
}

cpu() {
#    status="$status\nCPU = $(cpu.sh)"
    status="$status\nCPU = $(psuinfo -Cat)"
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

show_time() {
    status="$status\nCurrent Time = $(date +%T)"
}

show_top_10_mem() {
    local top_10="$(ps axo comm,%mem --sort -%mem | head -n 10)"
    status="$status\n$top_10"
}

show_top_10_cpu() {
    local top_10="$(ps axo comm,%cpu --sort -%cpu | head -n 10)"
    status="$status\n$top_10"
}

show_song() {
    local prompt=$(playerctl -a metadata -f "{{playerName}}: {{title}} {{status}} ({{duration(position)}}/{{duration(mpris:length)}})")

    status="$status\n$prompt"
}

print_message() {
    notify-send -t 15000 "status" "$status"
}

rcommand=""
option=""
while getopts "h?clmtvwdMCs" opt; do
    case "${opt}" in
    h|\?) show_help ;;
    c) cpu;;
    t) cpu_temp;;
    l) p_load;;
    m) p_mem;;
    v) p_vol;;
    w) weather;;
    d) show_time;;
    M) show_top_10_mem;;
    C) show_top_10_cpu;;
    s) show_song;;
    i) rcommand="i";option=${OPTARG};;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "S") save "$1";;
esac
    
print_message
