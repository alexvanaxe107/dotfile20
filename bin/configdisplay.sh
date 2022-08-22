#!/bin/dash

option=$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s" "Toggle" "Primary" "Order" "Rotate" "Add Virtual" "Rm Virtual" "All On!" | dmenu -p "Setting up monitors: " -bw 2 -y 26 -z 850)

PREFERENCE_FILE="${HOME}/.config/wm/monitors.conf"

toggle() {
    monitor=$(monitors_info.sh -c | dmenu -p "What monitor will be toggled?" -bw 2 -y 16 -z 850)

    if [ -z "${monitor}" ]; then
        exit 0
    fi

    display_manager.sh -t ${monitor}
}

rotate() {
    monitor=$(monitors_info.sh -m | dmenu -p "Which monitor rotate?" -bw 2 -y 16 -z 850)
    direction=$(printf "%s\n%s\n%s" "left" "right" "normal" | dmenu -p "Which monitor rotate?" -bw 2 -y 16 -z 850)

    display_manager.sh -r "${monitor}" "${direction}"
}

set_primary() {
    monitor=$(monitors_info.sh -m | dmenu -p "What is the new primary?" -bw 2 -y 16 -z 850)

    if [ ! -z "${monitor}" ]; then
        display_manager.sh -p ${monitor}
    fi
}

restart_conky() {
    pid="$(pidof conky)"

    if [ ! -z "${pid}" ]; then
       $HOME/.config/conky/conky.sh 
       sleep 2
       $HOME/.config/conky/conky.sh 
    fi

}

set_monitors() {
    option=$(printf "%s\n%s" "Auto" "Manual" | dmenu -p "The method to use: " -bw 2 -y 16 -z 850)

    if [ "$option" = "Auto" ]; then
        preferences="$(cat $PREFERENCE_FILE)"

        list_monitor=""

        old_IFS="$IFS"
        IFS=""
        for monitor in $preferences; do
            list_monitor="${list_monitor} $(echo $monitor | awk '{print $2}' ORS=" ")"
        done
        IFS="$old_IFS"
        display_manager.sh -o "${list_monitor}"  
    fi

    if [ "$option" = "Manual" ]; then
        list_monitor=""
        count=1
        for monitor in $(monitors_info.sh -c); do
            local mon_tmp=$(monitors_info.sh -c | dmenu -p "Select the ${count}:" -bw 2 -y 16 -z 850)
            if [ -z "${mon_tmp}" ]; then
                break
            fi
            list_monitor="$list_monitor ${mon_tmp}"
            count=$((${count}+1))
        done

        list_monitor=$(echo $list_monitor | xargs)
        display_manager.sh -o "${list_monitor}"  
        #nitrogen --restore
        #restart_conky
        #reset_monitors.sh
        #toggle_bars.sh --restart
        #killall picom
        #sleep 1
        #start_picom.sh
        notify_send -u low "Ambient is ready."
    fi
}

add_virtual() {
    display_manager.sh -s
}

rm_virtual() {
    display_manager.sh -xs
}

add_virtual_old() {
    local dim="$(printf "1366x768\n1920x1080" | dmenu -p "Choose a screen dimension" -bw 2 -y 16 -z 850)"
    if [ -z "${dim}" ]; then
        exit 0
    fi
    display_manager.sh -d "${dim}" -v
}

rm_virtual_old() {
    local virtual=$(monitors_info.sh -c | grep VIRTUAL | dmenu)

    if [ -z "${virtual}" ]; then
        exit 0
    fi

    display_manager.sh -V "${virtual}"
}

case "$option" in
    "Toggle") toggle
    ;;
    "Order") set_monitors
    ;;
    "Primary") set_primary
    ;;
    "Rotate") rotate
    ;;
    "Add Virtual") add_virtual
    ;;
    "Rm Virtual") rm_virtual 
    ;;
    "All On!") display_manager.sh -a
    ;;
esac
