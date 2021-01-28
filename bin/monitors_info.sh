#!/bin/dash
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
PREFERENCE_FILE="${HOME}/.config/wm/monitors.conf"

# Initialize our own variables:
output_file=""
id_only=0

monitors=$(bspc query --monitors --names)
all_monitors=$(xrandr | grep -w connected | cut -d " " -f 1)

print_primary_information() {
    if [ ${id_only} -eq 0 ]; then
        xrandr --listmonitors | awk 'NR==2 {print $4}'
    else
        xrandr --listmonitors | awk 'NR==2 {print $1$2}' | cut -d ":" -f 1
    fi
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
    if [ ${id_only} -eq 0 ]; then
        m_id=$(($1+1))
        printf "${monitors}" | awk -v ID=$m_id  'NR==ID {print $0}'
    else
        printf $(($(printf "${monitors}" | nl | grep -wi $1 | xargs | cut -d " " -f 1)-1))
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
        printf "${monitors}"
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



secundary_wide() {
    sec=$(name_by_prefered 0)

    wide=$(is_wide "${sec}")
    
    echo "${wide}"
}

get_dimensions() {
    local monitor="$1"
    dim="$(xrandr | grep -A 1 -i "${monitor}" | tail -n 1 | grep -o "[[:digit:]]*x[[:digit:]]*" | head -n 1)"
    echo "${dim}" 
}

show_help() {
    echo "Get monitor information." echo ""
    echo "-m                             Get a list with the monitors name (primary first)"
    echo "-f                             Get a list of the favorite order monitors."
    echo "-a                             Get monitors info for the nitrogen."
    echo "-c                             Get a list of connected monitors"
    echo "-p                             Show the primary monitor name"
    echo "-i                             Show the selected monitor id (ip)"
    echo "-n {id}                        Get name by id"
    echo "-b {id}                        Get name by id for nitrogen"
    #echo "-r {id}                        Get resolution of id"
    echo "-in {name}                     Get name by id"
    echo "-w {[id, name, nothing}        The monitor is wide? If id is blank check any wide"
    echo "-q                             How many monitors are plugged?"
    echo "-s                             Secundary is wide?"
    echo "-t {id}                        Get Monitors acording prefered order."
    echo "-it {name}                     Get Monitors acording prefered order."
    echo "-d {name}                      Get Monitor dimension by its name"
}

while getopts "h?mcpqift:w:n:ab:sd:" opt; do
    case "$opt" in
    h|\?)
        show_help
        ;;
    i)  id_only=1
        ;;
    m)  monitors_information
        ;;
    f)  monitors_information_prefered
        ;;
    a)  monitors_information_nitrogen
        ;;
    t)  name_by_prefered $OPTARG
        ;;
    d)  get_dimensions $OPTARG
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
    s)  secundary_wide
        ;;
    esac
done
