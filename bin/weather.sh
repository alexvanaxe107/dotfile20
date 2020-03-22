#!/bin/sh

weather_show(){
    temp=$(curl -Ss 'https://wttr.in?format=%c+%t+%m' 2> /dev/null)
    regex="[\+\-][0-9].*C"
    if [[ $temp =~ $regex ]]; then
        echo $temp > ~/.dwm/weather.cache
    fi
	foo="`cat ~/.dwm/weather.cache`"
	echo "$foo"
}

weather_show
