#! /bin/bash

enabled=false
rate=0
voice=""

CONFIG="$HOME/.config/wm/speach.conf"
show_help() {
    echo "Make your computer speach"
    echo "-t [text]           Send the text to be spooken"
}

read_config() {
    IFS=
    config_file=$(<${CONFIG})
    enabled=$(echo ${config_file} | grep enabled | cut -d = -f 2)
    rate=$(echo ${config_file} | grep rate | cut -d = -f 2)
    voice=$(echo ${config_file} | grep voice | cut -d = -f 2)
}

speak() {
    read_config
    if [ "${enabled}" != "true" ]; then
        exit 0
    fi

    if [ -z "${voice}" ]; then
        #speak-ng -s ${rate} "$1"
        picospeaker "$1" &> /dev/null
        exit 0
    fi

    picospeaker "$1" &> /dev/null
    #speak-ng -v ${voice} -s ${rate} -p 64 "$1"
}

while getopts "ht:" opt; do
    case "$opt" in
        h) command="param"; show_help;;
        t) speak "$OPTARG";;
    esac
done

