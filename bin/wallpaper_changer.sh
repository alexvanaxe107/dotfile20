#!/bin/bash

set -o errexit

change_all(){
    count=0

    for n in $(xrandr --listmonitors | awk '{print $3}' | awk '{print $1}' FS=/); do
        if [ "${n}" -ge "2560" ]; then
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
        count=$(($count+1))
    done
    option=$(xrandr --listmonitors | awk '{print $1$2}' | tail -n 2 | (echo "All" && cat && echo "OK") | dmenu)
    echo "$option"
}

change_wallpaper(){
    selected=$(echo $1 | cut -d : -f 1)


    if [ ! -z "$selected" ]; then
        wide=$(xrandr --listmonitors | grep ${selected}: | awk '{print $3}' | awk '{print $1}' FS=/)
        if [ "${wide}" -ge "2560" ]; then
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    fi

    option=$(xrandr --listmonitors | awk '{print $1$2}' | tail -n 2 | (echo "All" && cat && echo "OK") | dmenu)
    echo $option
}

option=$(xrandr --listmonitors | awk '{print $1$2}' | tail -n 2 | (echo "All" && cat && echo "OK") | dmenu)

while [ "true" ]; do
    case "$option" in
        "OK") exit 0;;
        "All") option=$(change_all);;
        *) option=$(change_wallpaper $option);
    esac
done


