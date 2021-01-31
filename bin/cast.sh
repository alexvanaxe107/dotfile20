#! /bin/bash

CONFIG_URL="$HOME/.config/wm/tmp"
INDICATOR_CAST_FILE=$HOME/.config/indicators/casting.ind

cast_url(){
    local url_to_cast="$1"

    local search='*.pls'
    if [[ "$url_to_cast" == $search ]]; then
        if [[ ! -d "${CONFIG_URL}" ]]; then
            mkdir -p "${CONFIG_URL}"
        fi

        wget -O "${CONFIG_URL}/file.txt" "${url_to_cast}" 

        local url_to_cast="$(cat "${CONFIG_URL}/file.txt" | grep -o "http.*" | head -n 1)"
        
        #rm -rf "${CONFIG_URL}"
    fi

    if [ -z "${subtitle}" ]; then
        catt cast "$url_to_cast"
    else
        catt cast -s "${subtitle}" "$url_to_cast"
    fi
    echo "C" > "${INDICATOR_CAST_FILE}"
}

cast_stop(){
    catt stop
    rm "${INDICATOR_CAST_FILE}"
}

cast_info(){
    local info="$(catt info)"

    echo "$info" | grep "content_id" | grep -o " .*" | xargs

    #awk '{print $2}' FS=':' <<< "${info}"
}

show_help() {
    echo "Try to cast something to the chromecast"
    echo "s [subtitle]                  The subtitle file to load"
    echo "S                             Stop to cast"
    echo "i                             Info of the casting"
}

subtitle=""

req_command=""

while getopts "h?is:S" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        s) subtitle="$OPTARG";;
        i) req_command="i";;
        S) req_command="S";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "S") cast_stop;;
    "i") cast_info;;
    *) cast_url "$1";;
esac

