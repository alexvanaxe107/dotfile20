#!/usr/bin/env bash

complex="$1"

weather_show(){
    #temp="$(curl -Ss 'https://wttr.in?format=%c+%t+%m'  | sed 's/\xef\xb8\x8f//')"
    temp="$(curl -Ss 'https://wttr.in?format=j1' 2> /dev/null)"
    if [ -z "$temp" ]
    then
        printf ":/"
    else
        if [ "${complex}" == "1" ]; then
            local cur_temp="$(echo $temp | jq -r '.current_condition[0].temp_C')"
            local desc="$(echo $temp | jq -r '.current_condition[0].weatherDesc[0].value')" 
            local loc="$(echo $temp | jq -r '.nearest_area[0].areaName[0].value')"
            printf "%s - %s° %s" "$loc" "$cur_temp" "$desc"
        else
            local cur_temp="$(echo $temp | jq -r '.current_condition[0].temp_C')"
            printf "%s°" "$cur_temp"
        fi
    fi
}

weather_show
