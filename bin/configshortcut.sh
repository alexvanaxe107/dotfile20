#!/bin/bash

. ~/.config/bspwm/themes/bsp.cfg
file=$(printf "config\nsxhkd\nbspwm\nradio\npl\nconfig\nzshrc\nvim\nfish\nfonts\nwallpaper\nmonitors\nsxiv\nytpl" | dmenu -l 30 -y 16 -bw 2 -z 950 -p "Select config to edit")


process_wallpaper(){

    local ultra_detected="no"
    local rotated_detected="no"
    local monitor_num="$(monitors_info.sh -q)"
    local open_options=0

    while read monitor; do
        if [ "${ultra_detected}" == "no" ]; then
            ultra_detected="$(monitors_info.sh -w "${monitor}")"
        fi
        if [ "${rotated_detected}" == "no" ]; then
            rotated_detected="$(monitors_info.sh -r "${monitor}")"
        fi
    done <<< "$(monitors_info.sh -m)"


    if [ "${rotated_detected}" == "yes" ] 
    then
        sxiv $HOME/Documents/Pictures/Wallpapers/rotated/$theme_name&
        open_options=$(($open_options + 1))
    fi

    if [ "${ultra_detected}" == "yes" ] 
    then
        sxiv $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name&
        open_options=$(($open_options + 1))
    fi

    # Se ja foi aberto para todos os monitores saia, senao abra o padrao
    if [[ "${open_options}" == "$monitor_num" ]]; then
        exit 0
    fi

    sxiv $HOME/Documents/Pictures/Wallpapers/$theme_name&
    }

case $file in
    "config") alacritty -e $EDITOR $0;;
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config;;
    "config") alacritty -e $EDITOR $HOME/bin/configshortcut.sh;;
    "zshrc") alacritty -e $EDITOR $HOME/.zshrc;;
    "vim") alacritty -e $EDITOR $HOME/.vim/configs;;
    "fish") alacritty -e $EDITOR $HOME/.config/fish/config.fish;;
    "fonts") alacritty -e $EDITOR $HOME/bin/font_select.sh;;
    "monitors") alacritty -e $EDITOR $HOME/.config/wm/monitors.conf;;
    "ytpl") alacritty -e $EDITOR $HOME/Documents/Dropbox/stuffs/wm/yt_pl.txt;;
    "sxiv") alacritty -e $EDITOR $HOME/.config/sxiv/exec/key-handler;;
    "wallpaper") process_wallpaper;;
esac

