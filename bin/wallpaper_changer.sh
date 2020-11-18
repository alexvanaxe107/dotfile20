#!/bin/bash

set -o errexit
# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

NITROGEN_CONFIG=$HOME/.config/nitrogen/bg-saved.cfg
WALLPAPER_ROOT=$HOME/Documents/Pictures/Wallpapers

WALLPAPER_SCENES="Any\nCyberpunk\nFuturist\nAbstract\nCity\nLandscape\nLandscape Night\nNight city\nCity Landscape\nscience fiction\nminimalism\nSpace"

show_options(){
    option=$(monitors_info.sh -m | (printf "All\nDownload\n" && cat && printf "save") | dmenu)
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
    notify-send -u normal "All wallpapers setted. Enjoy."
    option=$(show_options)
    echo "$option"
}

download(){
    count=0
    monitor=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu)

    if [ -z "$monitor" ]; then
        exit 0
        #option=$(show_options)
        #echo "$option"
    else
        scene=$(printf "${WALLPAPER_SCENES}" | dmenu -l 20 -p "Choose the scene:")
        if [ -z "${scene}" ];then
            exit 0
        fi

        if [ "Any" = "${scene}" ]; then
            scene=""
        fi

        if [ "$monitor" == "All" ]; then
            notify-send -u normal "Downloading wallpaper to all monitors"
            for monitor_all in $(monitors_info.sh -m); do
                path=$(wallfinder.py -m ${monitor_all} -s "${scene}")
                nitrogen --head=${count} --save --set-scaled ${path}
                count=$(($count+1))
            done
        else
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(wallfinder.py -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -in ${monitor})
                nitrogen --head=${selected} --save --set-scaled ${path}
        fi
    fi
    notify-send -u normal "Wallpaper downloaded. Enjoy."
    option=$(show_options)
    echo "$option"
}

change_wallpaper(){
    monitor_name=$1
    selected=$(monitors_info.sh -in ${monitor_name})

    if [ ! -z "$selected" ]; then
        is_wide=$(monitors_info.sh -iw ${selected})
        if [ "${is_wide}" = "yes" ]; then
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        else
            nitrogen --head=$selected --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    fi

    notify-send -u normal "Wallpaper ${selected} changed. Enjoy."
    option=$(show_options)
    echo $option
}

save_wallpaper(){
    count=0
    option=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu)

    if [ "$option" = "All" ]; then
        for wallpaper in $(cat ${NITROGEN_CONFIG} | grep file | cut -d = -f 2); do
            theme="$theme_name"
            is_wide=$(monitors_info.sh -iw ${count})
            count=$(($count + 1))

            if [ "${is_wide}" = "yes" ]; then
                dest="${WALLPAPER_ROOT}/ultra/${theme}/"
            else
                dest="${WALLPAPER_ROOT}/${theme}/"
            fi
            
            #cp "${wallpaper}" "${dest}"
        done
    else
        theme="$theme_name"
        is_wide=$(monitors_info.sh -w ${option})
        
        if [ "${is_wide}" = "yes" ]; then
            dest="${WALLPAPER_ROOT}/ultra/${theme}/"
        else
            dest="${WALLPAPER_ROOT}/${theme}/"
        fi

        index=$(monitors_info.sh -in ${option})
        index=$(($index + 1))
        
        wall=$(cat $HOME/.config/nitrogen/bg-saved.cfg | grep file | awk -v INDEX=$index 'NR==INDEX {print $2}' FS==)

        cp "${wall}" "${dest}"
    fi
}


option=$(show_options)

while [ "true" ]; do
    case "$option" in
        "All") option=$(change_all);;
        "Download") option=$(download);;
        "save") save_wallpaper;;
        "") exit 0;;
        *) option=$(change_wallpaper $option);
    esac
done
