#!/bin/bash

set -o errexit
# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg
show_options(){
    option=$(xrandr --listmonitors | awk 'NR>1 {print $1$2}' | (printf "All\nDownload\n" && cat) | dmenu)
    echo $option
}
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
    option=$(show_options)
    echo "$option"
}

download(){
    count=0
    monitor=$(xrandr --listmonitors | awk 'NR>1 {print $1$4}' | (printf "All\n" && cat) | dmenu)

    scene=$(printf "Cyberpunk\nFuturist\nLandscape\nNight city" | dmenu -p "Choose the scene:")

    if [ -z "$monitor" ]; then
        option=$(show_options)
        echo "$option"
    else
        if [ "$monitor" == "All" ]; then
            for n in $(xrandr --listmonitors | awk 'NR>1 {print $4}'); do
                path=$(wallfinder.py -m $n -s "$scene")
                nitrogen --head=$count --save --set-scaled $path
                count=$(($count+1))
            done
        else
                selected=$(echo $monitor | cut -d : -f 1)
                monitorS=$(echo $monitor | cut -d : -f 2)
                path=$(wallfinder.py -m $monitorS -s "$scene")
                nitrogen --head=$selected --save --set-scaled $path
        fi
        option=$(show_options)
        echo "$option"
    fi
}

change_wallpaper(){
    selected=$(echo $1 | cut -d : -f 1)

    if [ ! -z "$selected" ]; then
        wide=$(xrandr --listmonitors | grep ${selected}: | awk '{print $3}' | awk '{print $1}' FS=/)
        if [ "${wide}" -ge "2556" ]; then
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    fi

    option=$(show_options)
    echo $option
}

option=$(show_options)

while [ "true" ]; do
    case "$option" in
        "All") option=$(change_all);;
        "Download") option=$(download);;
        "") exit 0;;
        *) option=$(change_wallpaper $option);
    esac
done


