#!/bin/sh

weather_show(){
    temp=$(curl -Ss 'https://wttr.in?format=%c+%t+%m' 2> /dev/null)
    retorna=$(echo $temp | grep -i unknown)
    if [ -z "$retorna" ]
    then
        echo "$temp"
    fi
}

weather_show
