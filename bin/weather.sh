#!/bin/sh

weather_show(){
    temp=$(curl -Ss 'https://wttr.in?format=%c+%t+%m'  | sed 's/\xef\xb8\x8f//' 2> /dev/null)
    retorna=$(echo $temp | grep -i unknown)
    if [ -z "$retorna" ]
    then
        printf "$temp"
    else
	printf ":/"
    fi
}

weather_show
