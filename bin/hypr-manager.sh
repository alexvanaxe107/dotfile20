#!/usr/bin/env bash 

dmenu=$(which ava_dmenu)

select_workspace() {
    desktop=$(echo "$(hyprctl workspaces -j | jq -r '.[].name')" | $dmenu -l 10)

    echo $desktop
}

go_to_workspace() {
    local go_to="$(select_workspace)"
    if [ -z "${go_to}" ]; then
        exit 0
    fi
    hyprctl dispatch workspace $go_to
}

go_to_client() {
    local client=$(echo "$(hyprctl clients -j | jq -r '.[].title' | sed '/^$/d')" | $dmenu -l 10)
    if [ -z "${client}" ]; then
        exit 0
    fi
    
    client=$(basename "${client}") # Removing the slashes and getting only the last bit
    hyprctl dispatch focuswindow title:${client}
}

show_help() {
    echo "Manipulate the desktops and hyprland configs."; echo ""
    echo "w                             list the workspaces"
}

use_dmenu="0"

while getopts "h?gc" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    d) use_dmenu="1"
        ;;
    g) go_to_workspace
        ;;
    c) go_to_client
        ;;
    esac
done



