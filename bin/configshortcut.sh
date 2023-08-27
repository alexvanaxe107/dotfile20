#!/usr/bin/env bash

dmenu=ava_dmenu

. ~/.config/bspwm/themes/bsp.cfg
file=$(printf "hypr\nradio\nmonitors\nytq\nytpl\nwallpaper\npolybar\neww\nconfig\nstellaris\nvim\nrss" | ${dmenu} -l 30    -p "Select config to edit")

TERMINAL_EM="alacritty -e"


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
    "hypr") wezterm start $EDITOR $HOME/.config/hypr/hyprland.conf;;
    "sxhkd") wezterm start $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "radio") wezterm start $EDITOR $HOME/.config/play_radio/config;;
    "config") wezterm start $EDITOR $HOME/.config/wm/bspwm.conf;;
    "zshrc") wezterm start $EDITOR $HOME/.zshrc;;
    "monitors") wezterm start $EDITOR $HOME/.config/wm/monitors.conf;;
    "ytpl") wezterm start $EDITOR $HOME/.config/tmp/yt_pl.txt;;
    "ytq") wezterm start $EDITOR $HOME/.confit/tmp/yt_queue.txt;;
    "sxiv") wezterm start $EDITOR $HOME/.config/sxiv/exec/key-handler;;
    "polybar")  wezterm start $EDITOR $HOME/.config/polybar/config;;
    "wallpaper") sxiv $HOME/Documents/Pictures/Wallpapers/dual/$theme_name/*;;
    "stellaris") cd $HOME/Documents/Pictures/Wallpapers/stellaris;sxiv *;;
    "vim")  wezterm start $EDITOR $HOME/.vim/configs/theme*;;
    "eww")  wezterm start $EDITOR $HOME/.config/eww/*;;
    "rss")  $TERMINAL_EM $EDITOR $HOME/.config/wm/rss $HOME/.config/newsboat/urls;;
esac

