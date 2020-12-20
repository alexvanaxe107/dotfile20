#!/bin/bash

set -o errexit
# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

NITROGEN_CONFIG=$HOME/.config/nitrogen/bg-saved.cfg
WALLPAPER_ROOT=$HOME/Documents/Pictures/Wallpapers

WALLPAPER_SCENES="Any\nCyberpunk\nFuturist\nAbstract\nCity\nLandscape\nLandscape Night\nCity Night\nCity Landscape\nScience Fiction\nMinimalism\nSpace\nWar\nApocalypse\nartwork\ndigital art\nfantasy art\nnature"

MONITOR_NUMBER=$(monitors_info.sh -q)

show_options(){
    option=$(monitors_info.sh -m | (printf "All\nDownload\n" && cat && printf "save") | dmenu -y 16 -bw 2 -z 550 -p "How rice it?")
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

get_scene() {
        scene=$(printf "${WALLPAPER_SCENES}" | dmenu -i -y 16 -bw 2 -z 550 -l 20 -p "Choose the scene:")
        if [ -z "${scene}" ];then
            exit 0
        fi

        if [ "Any" = "${scene}" ]; then
            scene=""
        fi

        echo "${scene}"
}

download(){
    count=0

    if [ ${MONITOR_NUMBER} -ge 2 ]; then
        monitor=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu -y 16 -bw 2 -z 550 -p "Which monitor?")
    else
        monitor=$(monitors_info.sh -p)
    fi

    if [ -z "$monitor" ]; then
        exit 0
    else
        option=$(printf "Resolution\nRatio\nLuck\nChromecast\nBing" | dmenu -i -y 16 -bw 2 -z 780 -p "Wanna try your luck?")
        notsceneoptions="ChromecastBing"
        if [ -z "${option}" ]; then
            exit 0
        fi

        if [ "$monitor" = "All" ]; then
            if [[ "$notsceneoptions" == *$option* ]]; then
                notify-send -u normal "Downloading wallpaper to all monitors"

                for monitor_all in $(monitors_info.sh -m); do
                    if [ "Chromecast" = "${option}" ]; then
                        path=$(wallfinder.py -e c)
                        nitrogen --head=${count} --save --set-zoom-fill ${path}
                    fi
                    if [ "Bing" = "${option}" ]; then
                        path=$(wallfinder.py -e b)
                        nitrogen --head=${count} --save --set-zoom-fill ${path}
                    fi
                    count=$(($count+1))
                done
                exit 0
            fi

            scene=$(get_scene)
            notify-send -u normal "Downloading wallpaper to all monitors"
            for monitor_all in $(monitors_info.sh -m); do
                if [ "Luck" = "${option}" ]; then
                    path=$(wallfinder.py -s "${scene}")
                    nitrogen --head=${count} --save --set-zoom-fill ${path}
                fi
                if [ "Ratio" = "${option}" ]; then
                    path=$(wallfinder.py -r -m ${monitor_all} -s "${scene}")
                    nitrogen --head=${count} --save --set-scaled ${path}
                fi
                if [ "Resolution" = "${option}" ]; then
                    path=$(wallfinder.py -m ${monitor_all} -s "${scene}")
                    nitrogen --head=${count} --save --set-scaled ${path}
                fi
                count=$(($count+1))
            done
        else
            if [[ "$notsceneoptions" == *$option* ]]; then
                if [ "Chromecast" = "${option}" ]; then
                    notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                    path=$(wallfinder.py -e c)
                    selected=$(monitors_info.sh -in ${monitor})
                    nitrogen --head=${selected} --save --set-zoom-fill ${path}
                fi
                if [ "Bing" = "${option}" ]; then
                    notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                    path=$(wallfinder.py -e b)
                    selected=$(monitors_info.sh -in ${monitor})
                    nitrogen --head=${selected} --save --set-zoom-fill ${path}
                fi
                exit 0
            fi

            scene=$(get_scene)
            if [ "Luck" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(wallfinder.py -s "${scene}")
                selected=$(monitors_info.sh -in ${monitor})
                nitrogen --head=${selected} --save --set-zoom-fill ${path}
            fi
            if [ "Ratio" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(wallfinder.py -r -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -in ${monitor})
                nitrogen --head=${selected} --save --set-scaled ${path}
            fi
            if [ "Resolution" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(wallfinder.py -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -in ${monitor})
                nitrogen --head=${selected} --save --set-scaled ${path}
            fi
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
    option=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu -y 16 -bw 2 -z 550 -p "What wallpaper to save?")

    theme=$(printf "day\nnight\nshabbat" | dmenu -i -y 16 -bw 2 -z 550 -p "What theme you want this to go?")

    if [ -z "${theme}" ]; then
        exit 0
    fi
    

    if [ "$option" = "All" ]; then
        for wallpaper in $(cat ${NITROGEN_CONFIG} | grep file | cut -d = -f 2); do
            is_wide=$(monitors_info.sh -iw ${count})
            count=$(($count + 1))

            if [ "${is_wide}" = "yes" ]; then
                dest="${WALLPAPER_ROOT}/ultra/${theme}/"
            else
                dest="${WALLPAPER_ROOT}/${theme}/"
            fi
        done
    else
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
        notify-send -u normal "Saved" "Wallpaper ${wall} saved to ${theme}."
    fi
    option=$(show_options)
    echo $option
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
