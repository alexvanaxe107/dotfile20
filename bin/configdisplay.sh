#!/bin/dash

option=$(printf "%s\n%s\n%s" "Toggle" "Primary" "Order" | dmenu -p "Setting up monitors: ")

PREFERENCE_FILE="${HOME}/.config/wm/monitors.conf"

toggle() {
    monitor=$(monitors_info.sh -c | dmenu -p "What monitor will be toggled?")

    if [ -z "${monitor}" ]; then
        exit 0
    fi

    display_manager.sh -t ${monitor}
}

set_primary() {
    monitor=$(monitors_info.sh -m | dmenu -p "What is the new primary?")

    if [ ! -z "${monitor}" ]; then
        display_manager.sh -p ${monitor}
    fi
}

set_monitors() {
    option=$(printf "%s\n%s" "Auto" "Manual" | dmenu)

    if [ "$option" = "Auto" ]; then
        preferences="$(cat $PREFERENCE_FILE)"

        list_monitor=""

        for monitor in $preferences; do
           list_monitor="${list_monitor} $monitor" 
        done
        display_manager.sh -o "${list_monitor}"  
    fi

    if [ "$option" = "Manual" ]; then
        list_monitor=""
        for monitor in $(monitors_info.sh -m); do
            list_monitor="$list_monitor $(monitors_info.sh -m | dmenu)"
        done

        list_monitor=$(echo $list_monitor | xargs)
        display_manager.sh -o "${list_monitor}"  
    fi

}

case "$option" in
    "Toggle") toggle
    ;;
    "Order") set_monitors
    ;;
    "Primary") set_primary
    ;;
esac
