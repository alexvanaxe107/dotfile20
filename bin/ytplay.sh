#! /bin/bash

cli=0
show_help() {
    echo "Iterate with the yt"
    echo "-t             Find a channel by theme"
    echo "-T             Play the latest video from the search"
    echo "-l             Select the video from a list"
}

get_theme() {
    local choosen_theme=""

    if [ "${cli}" = "1" ]; then
        local IFS=$'\n'
        options="$(<~/.config/wm/ytplay.conf)"
        select selected in $options
        do
            choosen_theme=$selected
            break
        done
    fi
   
    if [ "${cli}" == "0" ]; then
        choosen_theme=$(dmenu -p "Choose a channel/theme: " <<<  $(<~/.config/wm/ytplay.conf))
    fi

    if [ -z "${choosen_theme}" ]; then
        exit 0
    fi

    echo "${choosen_theme}"
}

play_parameter() {
    local choosen_theme=${1}
    local link=$(ytsearch.py -o -s "${choosen_theme}")

    play_radio.sh -p "$link"
}

play_by_list() {
    local choosen_theme=$(get_theme)
    if [ -z "${choosen_theme}" ];then
        exit 0
    fi
    
    videos="$(ytsearch.py -to -q 10 -s "${choosen_theme}")"
    video=""
    if [ "${cli}" = "1" ]; then
        local IFS=$'\n'
        select selected in $(awk '{printf "%s\n", $2}' FS=";" <<< $videos)
        do
            video=$selected
            break
        done
    fi
    if [ "${cli}" = "0" ]; then
        video=$(dmenu -l 15 -p "Choose a video" <<< $(awk '{printf "%s\n", $2}' FS=";" <<< $videos))
    fi

    
    if [ -z "${video}" ];then
        exit 0
    fi

    url=$(grep "${video}" <<< "${videos}" | awk '{printf "%s", $1}' FS=";")

    play_radio.sh -p "$url"&
}

play_by_theme() {
    local choosen_theme=$(get_theme)
    if [ -z "${choosen_theme}" ];then
        exit 0
    fi

    local link=$(ytsearch.py -o -s "${choosen_theme}")
    play_radio.sh -p "$link"&
}

while getopts "h?ctT:l" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        c) cli=1;;
        t) play_by_theme;;
        l) play_by_list;;
        T) play_parameter ${OPTARG}
    esac
done
