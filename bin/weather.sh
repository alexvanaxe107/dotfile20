#!/bin/sh

weather_show(){
    #temp="$(curl -Ss 'https://wttr.in?format=%c+%t+%m'  | sed 's/\xef\xb8\x8f//')"
    temp="$(curl -Ss 'https://wttr.in?format=%c+%t+%m' 2> /dev/null)"
    if [ -z "$temp" ]
    then
        printf ":/"
    else
        printf "$temp"
    fi
}

weather_show
