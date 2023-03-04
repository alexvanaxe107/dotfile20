#!/bin/bash

. $HOME/.pyenv/versions/wm/bin/activate

set -o errexit
# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

NITROGEN_CONFIG=$HOME/.config/nitrogen/bg-saved.cfg
WALLPAPER_ROOT=$HOME/Documents/Pictures/Wallpapers

WALLPAPER_SCENES="Any\nCyberpunk\nFuturist\nAbstract\nCity\nLandscape\nLandscape Night\nCity Night\nCity Landscape\nscience fiction\nMinimalism\nSpace\nWar\nApocalypse\nartwork\ndigital art\nfantasy art\nnature\ntilt shift\nindoors\noutdoors\nsimple background\nwater\ndepth of field\ndark\nlight\nWLOP"

MONITOR_NUMBER=$(monitors_info.sh -q)

show_options(){
    option=$(monitors_info.sh -m | (printf "All\nDownload\n" && cat) | dmenu    -p "How rice it?")
    echo $option
}

change_all(){
    for monitor in $(monitors_info.sh -m); do
        index=$(monitors_info.sh -ib ${monitor})
        local wallpaper="$(shuf -n1 -e ${WALLPAPER_ROOT}/dual/$theme_name/*)"
        nitrogen --head=$index --save --set-scaled $wallpaper
    done
    notify-send -u normal "All wallpapers setted. Enjoy."
    option=$(show_options)
    echo "$option"
}

get_scene() {
        scene="$(printf "${WALLPAPER_SCENES}" | dmenu -i    -l 20 -p "Choose the scene:")"
        if [ -z "${scene}" ];then
            exit 0
        fi

        if [ "Any" = "${scene}" ]; then
            scene=""
        fi

        echo "${scene}"
}

download(){
    if [ ${MONITOR_NUMBER} -ge 2 ]; then
        monitor=$(monitors_info.sh -m | (printf "All\n" && cat) | dmenu    -p "Which monitor?")
    else
        monitor=$(monitors_info.sh -p)
    fi

    if [ -z "$monitor" ]; then
        exit 0
    else
        option=$(printf "Resolution\nRatio\nLuck\nGoogle\nChromecast\nBing\nUsplash\nDual" | dmenu -i    -p "Wanna try your luck?")
        notsceneoptions="ChromecastBing"
        if [ -z "${option}" ]; then
            exit 0
        fi

        if [ "${option}" == "Dual" ]; then
            echo "Processing dual"
            local result=$(process_dual)
            echo $result
            exit 0
        fi

        if [ "$monitor" = "All" ]; then
            if [[ "$notsceneoptions" == *$option* ]]; then
                notify-send -u normal "Downloading wallpaper to all monitors"

                for monitor_all in $(monitors_info.sh -m); do
                    index=$(monitors_info.sh -ib ${monitor_all})
                    if [ "Chromecast" = "${option}" ]; then
                        path=$(python $HOME/bin/wallfinder.py -e c)
                        #nitrogen --head=${index} --save --set-zoom-fill ${path}
                        sxiv "${path}"
                    fi
                    if [ "Bing" = "${option}" ]; then
                        path=$(python $HOME/bin/wallfinder.py -e b)
                        #nitrogen --head=${index} --save --set-zoom-fill ${path}
                        sxiv "${path}"
                    fi
                done
                exit 0
            fi

            scene=$(get_scene)
            notify-send -u normal "Downloading wallpaper to all monitors"
            for monitor_all in $(monitors_info.sh -m); do
                index=$(monitors_info.sh -ib ${monitor_all})
                if [ "Luck" = "${option}" ]; then
                    path=$(python $HOME/bin/wallfinder.py -s "${scene}")
                    #nitrogen --head=${index} --save --set-zoom-fill ${path}
                    sxiv "${path}"
                fi
                if [ "Ratio" = "${option}" ]; then
                    path=$(python $HOME/bin/wallfinder.py -r -m ${monitor_all} -s "${scene}")
                    #nitrogen --head=${index} --save --set-scaled ${path}
                    sxiv "${path}"
                fi
                if [ "Resolution" = "${option}" ]; then
                    path=$(python $HOME/bin/wallfinder.py -m ${monitor_all} -s "${scene}")
                    #nitrogen --head=${index} --save --set-scaled ${path}
                    sxiv "${path}"
                fi
                if [ "Google" = "${option}" ]; then
                    path=$(python $HOME/bin/wallfinder.py -e i -m ${monitor_all} -s "${scene}")
                    #nitrogen --head=${index} --save --set-scaled ${path}
                    sxiv "${path}"
                fi
                if [ "Usplash" = "${option}" ]; then
                    path=$(python $HOME/bin/wallfinder.py -e u -m ${monitor_all} -s "${scene}")
                    #nitrogen --head=${index} --save --set-zoom-fill ${path}
                    sxiv "${path}"
                fi
            done
        else
            if [[ "$notsceneoptions" == *$option* ]]; then
                if [ "Chromecast" = "${option}" ]; then
                    notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                    path=$(python $HOME/bin/wallfinder.py -e c)
                    selected=$(monitors_info.sh -ib ${monitor})
                    #nitrogen --head=${selected} --save --set-zoom-fill ${path}
                    sxiv "${path}"
                fi
                if [ "Bing" = "${option}" ]; then
                    notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                    path=$(python $HOME/bin/wallfinder.py -e b)
                    selected=$(monitors_info.sh -ib ${monitor})
                    #nitrogen --head=${selected} --save --set-zoom-fill ${path}
                    sxiv "${path}"
                fi
                exit 0
            fi

            scene=$(get_scene)
            if [ "Luck" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(python $HOME/bin/wallfinder.py -s "${scene}")
                selected=$(monitors_info.sh -ib ${monitor})
                #nitrogen --head=${selected} --save --set-zoom-fill ${path}
                sxiv "${path}"
            fi
            if [ "Ratio" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(python $HOME/bin/wallfinder.py -r -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -ib ${monitor})
                #nitrogen --head=${selected} --save --set-scaled ${path}
                sxiv "${path}"
            fi
            if [ "Resolution" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(python $HOME/bin/wallfinder.py -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -ib ${monitor})
                #nitrogen --head=${selected} --save --set-scaled ${path}
                sxiv "${path}"
            fi
            if [ "Google" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(python $HOME/bin/wallfinder.py -e i -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -ib ${monitor})
                #nitrogen --head=${selected} --save --set-scaled ${path}
                sxiv "${path}"
            fi
            if [ "Usplash" = "${option}" ]; then
                notify-send -u normal "Downloading wallpaper to monitor ${monitor}."
                path=$(python $HOME/bin/wallfinder.py -e u -m ${monitor} -s "${scene}")
                selected=$(monitors_info.sh -ib ${monitor})
                #nitrogen --head=${selected} --save --set-zoom-fill ${path}
                sxiv "${path}"
            fi
        fi
    fi
    notify-send -u normal "Wallpaper downloaded. Enjoy."
    option=$(show_options)
    echo "$option"
}

change_wallpaper(){
    monitor_name=$1
    selected=$(monitors_info.sh -ib ${monitor_name})

    if [ ! -z "$selected" ]; then
        local wallpaper="$(shuf -n1 -e ${WALLPAPER_ROOT}/dual/$theme_name/*)"
        nitrogen --head=$selected --save --set-scaled $wallpaper
    fi

    notify-send -u normal "Wallpaper ${monitor_name} changed. Enjoy."
    option=$(show_options)
    echo $option
}

save_wallpaper(){
    count=0
    option=$(monitors_info.sh -m | dmenu    -p "What wallpaper to save?")

    theme=$(printf "day\nnight\nshabbat" | dmenu -i    -p "What theme you want this to go?")

    if [ -z "${theme}" ]; then
        exit 0
    fi
    
    dest="${WALLPAPER_ROOT}/dual/${theme}/"

    index=$(monitors_info.sh -ib ${option})
    index=$(($index + 1))

    wall=$(cat $HOME/.config/nitrogen/bg-saved.cfg | grep file | awk -v INDEX=$index 'NR==INDEX {print $2}' FS==)

    cp "${wall}" "${dest}"
    notify-send -u normal "Saved" "Wallpaper ${wall} saved to ${dest}."

    option=$(show_options)
    echo $option
}

process_dual(){
    wallpaper_dual_changer.sh -d
    option=""
    echo $option
}

option=$(show_options)

while [ "true" ]; do
    case "$option" in
        "All") option=$(change_all);;
        "Download") option=$(download);;
        "save") save_wallpaper;;
        "dual") option="$(process_dual)";;
        "") exit 0;;
        *) option=$(change_wallpaper $option);
    esac
done
