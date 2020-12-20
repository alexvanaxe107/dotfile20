#! /bin/bash

cli="0"
audio="0"
multiple="0"

CONF="$HOME/.config/wm/ytplay.conf"

CONF_CONT="$(<$CONF)"

show_help() {
    echo "Iterate with the yt"
    echo "-a             Play audio only"
    echo "-t             Find a channel by theme"
    echo "-T             Play the latest video from the search"
    echo "-l             Select the video from a list"
    echo "-v             List live streams from the list"
    echo "-m             Use multiple links"
}

play() {
    link="$1"
    if [ "${audio}" = "1" ]; then
        play_radio.sh -a "$link"&
        exit 0
    fi
    play_radio.sh -p "$link"&
    exit 0
}

search_live() {
    local lives=""
    while read -r line; do
        local search="$line"
        local search_query=$(awk '{print $1}' FS=";" <<< "${search}")
        local search_refiner=$(awk '{print $2}' FS=";"<<< "${search}")
        lives="$(ytsearch.py -to -q 3 -s "${search_query} ${search_refiner}")"
        while read -r live; do
            lives_tmp+="$(echo "$live" | grep ";Live$")\n"
        done <<<${lives}
    done < "${CONF}"

    echo -e "${lives_tmp}"
    local choosen=$(echo -e "$lives_tmp" | grep ";Live" | awk '{printf "%s-%s\n", $2,$3}' FS=";" | dmenu -bw 2 -y 16 -z 1250  -l 30 -p "What do want to watch?")

    if [ -z "${choosen}" ]; then
        exit 0
    fi
    
    echo "${choosen}"
    choosen="$(awk '{print $1}' FS="-" <<< "${choosen}")"
    echo "${choosen}"
    url=$(echo -e "${lives_tmp}" | grep "${choosen}" | awk '{printf "%s", $1}' FS=";") 
    play $url
}

get_theme() {
    local choosen_theme=""
    local filtered_content="$(awk '{print $1}' FS=";" <<< "${CONF_CONT}")"

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
        choosen_theme=$(dmenu -l 20 -bw 2 -y 16 -z 850 -p "Choose a channel/theme: " <<<  ${filtered_content})
    fi

    if [ -z "${choosen_theme}" ]; then
        exit 0
    fi

    refiner=$(grep "${choosen_theme}" <<< "${CONF_CONT}")

    echo "${refiner}"
}

play_parameter() {
    local choosen_theme="${1}"
    if [ -z "${choosen_theme}" ]; then
        exit 0
    fi

    if [ "${multiple}" = "1" ]; then
        local videos="$(ytsearch.py -to -q 5 -s "${choosen_theme}")"
        video=$(awk '{printf "%s", $1}' FS="-" <<< $(dmenu -l 15 -bw 2 -y 16 -z 1250 -p "Choose a video" <<< $(awk '{printf "%s-%s-%s\n", $2, $3, $4}' FS=";" <<< $videos)))

        if [ -z "${video}" ];then
            exit 0
        fi

        url=$(grep "${video}" <<< "${videos}" | awk '{printf "%s", $1}' FS=";")

        if [ -z "$url" ]; then
            echo "Url was empty" >&2 
            exit 1
        fi

        play "$url"

        exit 0
    fi

    local link=$(ytsearch.py -o -s "${choosen_theme}")

    play ${link}
}

play_by_list() {
    local choosen_theme=$(get_theme)
    local search_query=$(awk '{print $1}' FS=";" <<< "${choosen_theme}")
    local search_refiner=$(awk '{print $2}' FS=";"<<< "${choosen_theme}")

    if [ -z "${choosen_theme}" ];then
        exit 0
    fi
    
    videos="$(ytsearch.py -to -q 10 -s "${search_query} ${search_refiner}")"
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
        video=$(awk '{printf "%s", $1}' FS="#" <<< $(dmenu -l 15 -bw 2 -y 16 -z 1250 -p "Choose a video" <<< $(awk '{printf "%s#%s#%s\n", $2, $3, $4}' FS=";" <<< $videos)))
    fi

    
    if [ -z "${video}" ];then
        exit 0
    fi

    url=$(grep "${video}" <<< "${videos}" | awk '{printf "%s", $1}' FS=";")

    if [ -z "$url" ]; then
        echo "Url was empty" >&2 
        exit 1
    fi

    play "$url"
}

play_by_theme() {
    local choosen_theme=$(get_theme)

    local search_query=$(awk '{print $1}' FS=";" <<< "${choosen_theme}")
    local search_refiner=$(awk '{print $2}' FS=";"<<< "${choosen_theme}")

    if [ -z "${choosen_theme}" ];then
        exit 0
    fi

    local link=$(ytsearch.py -o -s "${search_query} ${search_refiner}")
    play "$link"
}

while getopts "h?mactT:lv" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        c) cli=1;;
        a) audio="1";;
        m) multiple="1";;
        t) play_by_theme;;
        l) play_by_list;;
        T) play_parameter "${OPTARG}";;
        v) search_live;;
    esac
done
