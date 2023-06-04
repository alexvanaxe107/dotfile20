#!/usr/bin/env bash

get_titles(){
    for player in $(playerctl -l | awk '!seen[$1] {print $1} {++seen[$1]}'); do
        teste="$(playerctl -p "$player" metadata title 2> /dev/null | awk -v player=$player '{print player,$0}' OFS=" - ")"
        if [ ! -z "$teste" ]; then
            printf "%s\n" "$teste"
        fi
    done

    #if [[ -f "${INDICATOR_CAST_FILE}" ]]; then
        #printf "%s\n" "casting-$(cast.sh -i)"
    #fi

    if [[ -f "${INDICATOR_CAST_FILE}" ]]; then
        printf "%s\n" "chromecast"
    fi
}

echo $(get_titles)
