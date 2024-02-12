#!/usr/bin/env bash
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
PREFERENCE_FILE="${HOME}/.config/wm/monitors.conf"
RESOLUTION_FILE="${HOME}/.config/wm/resolution.conf"

# Initialize our own variables:
output_file=""
id_only=0
external=0
override=0

all_monitors=$(xrandr | grep -w connected | cut -d " " -f 1)

__mount_monitors__() {
    first=$(xrandr | grep -w "connected" | grep "primary" | cut -d " " -f 1)

    all_monitors_less_first=$(xrandr | grep -w connected | cut -d " " -f 1 | grep -v -w "${first}")

    if [ -z "$first" ]; then
        printf "%s\n%s" "$all_monitors_less_first"
    else
        printf "%s\n%s" "$first" "$all_monitors_less_first"
    fi
}

monitors="$(__mount_monitors__)"

print_primary_information() {
    if [ ${id_only} -eq 0 ]; then
        if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
            hyprctl monitors -j | jq -r ".[0].name"
        else
            xrandr --listmonitors | awk 'NR==2 {print $4}'
        fi
    else
        xrandr --listmonitors | awk 'NR==2 {print $1$2}' | cut -d ":" -f 1
    fi
}

emacs_string() {
    count=0
    emonitor=""
    for monitor in ${monitors}; do
        emonitor="${emonitor}${count} ${monitor} "
        count=$((count + 1))
    done

    # printf "${emonitor}" | xargs
    echo "$(__mount_monitors__)"
}

name_by_id_nitrogen(){
    if [ ${id_only} -eq 0 ]; then
        m_id=$(($1+2))
        xrandr --listmonitors | awk -v ID=$m_id  'NR==ID {print $4}'
    else
        xrandr --listmonitors | awk 'NR>1 {print $1$2}' | grep -wi $1 | cut -d : -f 1
    fi
}

name_by_id(){
    local m_id=$1
    if [ ${id_only} -eq 0 ]; then
        if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
            hyprctl monitors -j | jq -r "[.[]|{x: .x, name: .name}] | sort_by(.x) | .[$m_id].name"
        else
            m_id=$(($1+1))
            printf "${monitors}" | awk -v ID=$m_id  'NR==ID {print $0}'
        fi
    else
        if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
            monitor="$1"
            hyprctl monitors -j | jq -r ".[] | select(.name == \"${monitor}\") | .id"
        else
            printf $(($(printf "${monitors}" | nl | grep -wi $1 | xargs | cut -d " " -f 1)-1))
        fi
    fi
}

monitors_information_nitrogen() { 
    if [ ${id_only} -eq 0 ]; then
        xrandr --listmonitors | awk 'NR>1 {print $4}'
    else
        xrandr --listmonitors | awk 'NR>1 {print $1$2}' | cut -d ":" -f 1
    fi
}

monitors_information() { 
    if [ ${id_only} -eq 0 ]; then
        if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
            hyprctl monitors -j | jq -r '[.[]|{x: .x, name: .name}] | sort_by(.x) | .[].name'
        else
            printf "${monitors}"
        fi
    else
        printf "${monitors}" | nl | awk '{print $1-1}'
    fi
}

monitors_information_prefered() { 
    prefered_monitors="$(cat $PREFERENCE_FILE | sort | awk '{print $2}')"

    if [ -z "${prefered_monitors}" ]; then
        prefered_monitors=$(monitors_information)
    fi

    if [ ${id_only} -eq 0 ]; then
        printf "${prefered_monitors}"
    else
        printf "${prefered_monitors}" | nl | awk '{print $1-1}'
    fi
}

name_by_prefered() { 
    prefered_monitors="$(cat $PREFERENCE_FILE | sort)"

    if [ ${id_only} -eq 0 ]; then
        m_id=$(($1+1))
        prefered=$(printf "${prefered_monitors}" | awk -v ID=$m_id  'NR==ID {print $2}')

        if [ -z "${prefered}" ]; then
            prefered=$(name_by_id $1)
        fi
        printf "${prefered}"
    else
        prefered=$(($(printf "${prefered_monitors}" | grep -wi $1 | xargs | cut -d " " -f 1)-1))
        if [ -z "${prefered}" ]; then
            prefered=$(name_by_id $1)
        fi
        
        printf ${prefered}
    fi
}

monitors_connected() { 
    xrandr | grep -w "connected" | awk '{print $1}'
}

is_wide(){
    monitor=$1
    if [ -z ${monitor} ]; then
        for n in $(monitors_information); do
            wide=$(xrandr --listmonitors | grep -i ${n} | awk 'NR==1{print $3}' | cut -d "/" -f 1)
            if [ -z "${wide}" ]; then
                echo ""
            else
                if [ "${wide}" -gt 2559 ]; then
                    echo "yes"
                    break
                fi
            fi
        done
    else
        if [ ${id_only} -eq 0 ]; then
            wide=$(xrandr --listmonitors | grep -i ${monitor} | awk 'NR==1{print $3}' | cut -d "/" -f 1)

            if [ -z "${wide}" ]; then
                echo ""
            else
                if [ ${wide} -gt 2559 ]; then
                    echo "yes"
                else
                    echo "no"
                fi
            fi

        else
            monitor_id=$((${monitor} + 2))
            wide=$(xrandr --listmonitors | awk -v MON_ID=${monitor_id} 'NR==MON_ID{print $3}' | cut -d "/" -f 1)
            if [ -z "${wide}" ]; then
                echo ""
            else
                if [ "${wide}" -gt 2559 ]; then
                    echo "yes"
                else
                    echo "no"
                fi
            fi

        fi
    fi
}

monitors_plugged(){
    monitors=$(xrandr --listmonitors | wc -l)
    echo $(($monitors - 1))
}

is_rotated(){
    local monitor=$1
    local rotated="$(xrandr | grep "${monitor}" | grep "t (")"
if [ -z "${rotated}" ];then
        echo "no"
    else
        echo "yes"
    fi
}

secundary_wide() {
    sec=$(name_by_prefered 0)
    wide=$(is_wide "${sec}")
    echo "${wide}"
}

get_dimensions() {
    if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        local dimensions="$(hyprctl monitors -j | jq '[.[]] | sort_by(.x) | .[] | (if .transform == 1 or .transform == 3 then .name, .height, .width else .name,.width, .height end)' | xargs printf "%s %sx%s\n")"
    else
        local dimensions="$(xrandr | grep -w connected | sed 's/primary //' | cut -d " " -f 1,3 | sed 's/\+.*//')"
    fi

    if [ ${override} == 1 ]; then
        for odim in $(cat ${RESOLUTION_FILE}); do
            local omonitor="$(echo ${odim} | cut -d '=' -f 1)"
            local odim="$(echo ${odim} | cut -d '=' -f 2)"
            local dimensions="$(echo "${dimensions}" | sed -E "s/${omonitor}.*/${omonitor} ${odim}/")"
        done
    fi

    if [ -z $1 ]; then
        printf "$dimensions" | cut -d " " -f 2
    else
        local monitor="$1"
        printf "$dimensions" | grep "${monitor}" | cut -d " " -f 2
    fi
}

# Pega a soma dos monitors
get_sum_dimensions() {
    get_dimensions | cut -d 'x' -f 1 | awk '{s+=$1} END {print s}'
}

show_help() {
    echo "Get monitor information." echo ""
    echo "-m                             Get a list with the monitors name (primary first)"
    echo "-g                             Get the (g)ear names - The external monitors"
    echo "-f                             Get a list of the favorite order monitors."
    echo "-a                             Get monitors info for the nitrogen."
    echo "-c                             Get a list of connected monitors"
    echo "-p                             Show the primary monitor name"
    echo "-i                             Show the selected monitor id (ip)"
    echo "-n {id}                        Get name by id"
    echo "-b {id}                        Get name by id for nitrogen"
    #echo "-r {id}                        Get resolution of id"
    echo "r {name}                       Detect if the monitor is rotated"
    echo "-in {name}                     Get name by id"
    echo "-w {[id, name, nothing}        The monitor is wide? If id is blank check any wide"
    echo "-q                             How many monitors are plugged?"
    echo "-s                             Secundary is wide?"
    echo "-t {id}                        Get Monitors acording prefered order."
    echo "-it {name}                     Get Monitors acording prefered order."
    echo "-d {name}                      Get Monitor dimension by its name"
    echo "-D                             Get the sum of the dimensions. Used to span the windows"
    echo "-e                             Get the emacs string to configure the exwm"
}

while getopts "h?omcpqift:w:n:ab:sder:gD" opt; do
    case "$opt" in
    h|\?)
        show_help
        ;;
    i)  id_only=1
        ;;
    g)  external=1
        ;;
    o)  override=1
        ;;
    m)  monitors_information
        ;;
    f)  monitors_information_prefered
        ;;
    a)  monitors_information_nitrogen
        ;;
    t)  name_by_prefered $OPTARG
        ;;
    d)  get_dimensions $2
        ;;
    D)  get_sum_dimensions
        ;;
    c)  monitors_connected
        ;;
    q)  monitors_plugged
        ;;
    p)  print_primary_information
        ;;
    n)  name_by_id $OPTARG
        ;;
    b)  name_by_id_nitrogen $OPTARG
        ;;
    w)  is_wide $OPTARG
        ;;
    r)  is_rotated $OPTARG
        ;;
    s)  secundary_wide
        ;;
    e)  emacs_string
        ;;
    esac
done
