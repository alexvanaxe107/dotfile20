#! /usr/bin/env bash

CONFIG_URL="$HOME/.config/wm/tmp"
INDICATOR_CAST_FILE=$HOME/.config/indicators/casting.ind
ICON="A"

cast_info(){
    local info="$(catt info)"

    content_id="$(echo "$info" | grep "content_id" | grep -o " .*" | xargs)"
    current_time="$(echo "$info" | grep "current_time" | grep -o " .*" | xargs)"
    content_type="$(echo "$info" | grep "content_type" | grep -o " .*" | xargs)"
    status_text="$(echo "$info" | grep "status_text" | grep -o " .*" | xargs)"

    printf "%s|%s|%s|%s" "${content_id}" "${current_time}" "${content_type}" "${status_text}"

    #awk '{print $2}' FS=':' <<< "${info}"
}

cast_url(){
    local url_to_cast="$1"

    echo "${ICON}" > "${INDICATOR_CAST_FILE}"
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
        video_rash=$(echo ${url_to_cast} | grep -Eo '[a-zA-Z0-9_-]{11}')

        if [ ! -z "${video_rash}" ]; then
            local yt_info=$(cast_info)
            local video_id=$(awk '{printf $3}' FS="|" <<< "${yt_info}")
            if [ "${video_id}" = "x-youtube/video" ]; then
                catt add "$url_to_cast"
            else
                catt cast "$url_to_cast"
            fi
        else
            catt cast "$url_to_cast"
        fi
    else
        catt cast -s "${subtitle}" "$url_to_cast"
    fi
}

record_time(){
    local info=$(cast_info)
    local time=$(awk '{printf $2}' FS="|" <<< "${info}")
    local filen=$(awk '{printf $4}' FS="|" <<< "${info}")
    filen="${filen:9}"
    if [ -z "${filen}" ]; then
        filen="tmpsave"
    fi
    echo "${time}" > "${CONFIG_URL}/${filen}"
}

cast_stop(){
    #record_time
    catt stop
    rm "${INDICATOR_CAST_FILE}"
}


go_to_location() {
    position="$1"

    if [ "${resume}" = 1 ]; then
        local info=$(cast_info)
        local time=$(awk '{printf $2}' FS="|" <<< "${info}")
        local filen=$(awk '{printf $4}' FS="|" <<< "${info}")
        filen="${filen:9}"

        if [ -z "${filen}" ]; then
            filen=tmpsave
        fi

        cur_time="$(<"$CONFIG_URL/$filen")"
        position=$cur_time
    fi

    position="$(echo "$position /1" | bc)"
    catt seek "${position}"
}

next_video() {
    catt skip
}

clear_yt_queue() {
    catt clear
}

pause_play(){
    catt play_toggle
}

show_help() {
    echo "Try to cast something to the chromecast"
    echo "s [subtitle]                  The subtitle file to load"
    echo "g [time]                      Go to location"
    echo "p                             Pause or play cast"
    echo "S                             Stop to cast"
    echo "c                             Clear the yt queue"
    echo "i                             Info of the casting"
    echo "t                             Record status"
}

subtitle=""
resume="0"

req_command=""

while getopts "h?is:Sgpncrt" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        s) subtitle="$OPTARG";;
        r) resume="1";;
        i) req_command="i";;
        S) req_command="S";;
        g) req_command="g";;
        p) req_command="p";;
        n) req_command="n";;
        c) req_command="c";;
        t) req_command="t";;
    esac
done

shift $((OPTIND-1))

case "${req_command}" in
    "S") cast_stop;;
    "i") cast_info;;
    "g") go_to_location $1;;
    "p") pause_play;;
    "n") next_video;;
    "c") clear_yt_queue;;
    "t") record_time;;
    *) cast_url "$1";;
esac

