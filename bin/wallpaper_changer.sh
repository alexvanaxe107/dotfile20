#!/bin/bash

change_wallpaper(){
    count=0
    for n in $(xrandr --listmonitors | awk '{print $3}' | awk '{print $1}' FS=/); do
        if [ "${n}" -ge "2560" ]; then
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
        count=$(($count+1))
    done
    option=$(printf "Rerun\nApply Theme" | dmenu -i)
    echo "$option"
}

option=$(change_wallpaper)

while [ "$option" == "Rerun" ]; do
    option=$(change_wallpaper)
done
