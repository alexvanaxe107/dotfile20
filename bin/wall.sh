#! /usr/bin/env bash

set_wallpaper(){
    local monitor="$1"
    local file="$2"
    if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        if [ -z "$(pgrep swww-daemon)" ]; then
            # Init the daemon if not running
            swww init
        fi
        case "$monitor" in
            "0") swww img -o $(monitors_info.sh -n 0) "$file" --transition-type wave --transition-step 15 --transition-fps 120;;
            "1") swww img -o $(monitors_info.sh -n 1) "$file" --transition-type wave --transition-step 15 --transition-fps 120;;
        esac
    else
        nitrogen --head=${monitor} --save --set-scaled --random "$file"
    fi
}

restore_wallpaper() {
    local wallpapers=$(cat ~/.config/wm/wallpapers.conf | cut -d : -f 2 | xargs)
    local monitor=0
    for wallpaper in $wallpapers; do
        set_wallpaper $monitor $wallpaper
        monitor=$((monitor+1))
    done
}

restore_emacs() {
    restore_wallpaper
    start_picom.sh
    dunstctl set-paused true
}

show_help() {
    echo "Setup the wallpaper" echo ""
    echo "-w                             Restore the previous wallpaper"
    echo "-e                             Restore the emacs state"
}

while getopts "h?we" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    w) restore_wallpaper
        ;;
    e) restore_emacs
       ;;
    esac
done
