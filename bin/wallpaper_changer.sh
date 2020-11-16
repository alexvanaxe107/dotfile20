#!/bin/bash

set -o errexit
# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg
show_options(){
    option=$(monitors_info.sh -m | (printf "All\nDownload\n" && cat) | dmenu)
    echo $option
}

change_all(){
    for monitor in $(monitors_info.sh -im); do
        is_wide="$(monitors_info.sh -iw $monitor)"
        if [ "${is_wide}" = "yes" ]; then
            nitrogen --head=$monitor --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$monitor --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    done
}

download(){
    count=0
    monitor=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu)

    if [ -z "$monitor" ]; then
        option=$(show_options)
        echo "$option"
    else
        scene=$(printf "Cyberpunk\nFuturist\nLandscape\nNight city" | dmenu -p "Choose the scene:")
        if [ "$monitor" == "All" ]; then
            for monitor_all in $(monitors_info.sh -m); do
                path=$(wallfinder.py -m $monitor_all -s "$scene")
                nitrogen --head=$count --save --set-scaled $path
                count=$(($count+1))
            done
        else
                path=$(wallfinder.py -m $monitor -s "$scene")
                selected=$(monitors_info.sh -in ${monitor})
                nitrogen --head=$selected --save --set-scaled $path
        fi
        option=$(show_options)
        echo "$option"
    fi
}

change_wallpaper(){
    monitor_name=$1
    selected=$(monitors_info.sh -in ${monitor_name})
    echo $selected

    if [ ! -z "$selected" ]; then
        is_wide=$(monitors_info.sh -iw ${selected})
        if [ "${is_wide}" = "yes" ]; then
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    fi

    #option=$(show_options)
    #echo $option
}


option=$(show_options)

#while [ "true" ]; do
    case "$option" in
        "All") option=$(change_all);;
        "Download") option=$(download);;
        "") exit 0;;
        *) option=$(change_wallpaper $option);
    esac
#done


