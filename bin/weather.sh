#!/bin/sh

weather_show(){
    temp=$(curl -Ss 'https://wttr.in?format=%c+%t+%m' 2> /dev/null)
	echo "$temp"
}

weather_show
