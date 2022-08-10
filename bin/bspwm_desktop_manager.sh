#! /bin/dash

CONFIG_PATH="$HOME/.config/wm/bspwm.conf"

. "${CONFIG_PATH}"

get_name(){
    case $1 in
        1) echo "terminal";;
        2) echo "web";;
        3) echo "coding";;
        4) echo "trade";;
        5) echo "game";;
        6) echo "book";;
        7) echo "video";;
        8) echo "twitter";;
        9) echo "chat";;
        10) echo "audio";;
    esac
}

goto(){
    desk_togo="$1"
    if [ "${creation_mode}" = "auto" ]; then
        togo_name=$(get_name ${desk_togo})
        togo_code="$(bspc query --desktops --desktop ${togo_name} 2> /dev/null)"
        nodes="$(bspc query --nodes --node .leaf --desktop)"

        desktop="$(bspc query --desktops --desktop)"

        bspc desktop -f "${togo_name}"

        if [ -z "${togo_code}" ]; then
            bspc monitor focused --add-desktops "$(get_name ${desk_togo})"
            # Go to the last desktop
            bspc desktop -f "focused:^$(bspc query --desktops --monitor | wc -l)"
        fi
        if [ -z "${nodes}" ]; then
            bspc desktop "${desktop}" --remove
        fi
    fi

    if [ "${creation_mode}" = "manual" ]; then
        bspc desktop -f "focused:^${desk_togo}"
    fi

    if [ "${creation_mode}" = "mixed" ]; then
        togo_name=$(get_name ${desk_togo})
        bspc desktop -f "${togo_name}"
    fi
}

moto(){
    desk_togo="$1"
    if [ "${creation_mode}" = "auto" ]; then
        togo_name=$(get_name ${desk_togo})
        togo_code="$(bspc query --desktops --desktop ${togo_name})"
        nodes="$(bspc query --nodes --node .leaf --desktop)"

        desktop="$(bspc query --desktops --desktop)"

        bspc node -d "${togo_name}"

        if [ -z "${togo_code}" ]; then
            bspc monitor focused --add-desktops "${togo_name}"
            # Go to the last desktop
            bspc node -d "focused:^$(bspc query --desktops --monitor | wc -l)"
            nodes="$(bspc query --nodes --node .leaf --desktop)"
            #bspc desktop -f "focused:^$(bspc query --desktops --monitor | wc -l)"
        fi
        if [ -z "${nodes}" ]; then
            bspc desktop "${desktop}" --remove
        fi
    fi

    if [ "${creation_mode}" = "manual" ]; then
        bspc node -d "focused:^${desk_togo}"
    fi

    if [ "${creation_mode}" = "mixed" ]; then
        togo_name=$(get_name ${desk_togo})
        bspc node -d "${togo_name}"
    fi
}

mofoto(){
    desk_togo="$1"
    if [ "${creation_mode}" = "auto" ]; then
        togo_name=$(get_name ${desk_togo})
        togo_code="$(bspc query --desktops --desktop ${togo_name})"

        if [ -z "${togo_code}" ]; then
            bspc monitor focused --add-desktops "${togo_name}"
        fi

        bspc node -d "${togo_name}"
        goto "$1"
    fi

    if [ "${creation_mode}" = "manual" ]; then
        bspc node -d "focused:^${desk_togo}" --follow
    fi

    if [ "${creation_mode}" = "mixed" ]; then
        togo_name=$(get_name ${desk_togo})
        bspc node -d "${togo_name}" --follow
    fi
}

rename_desktop(){
    new_name=$(get_name $1)
    if [ -z "${new_name}" ]; then
        new_name="$1"
    fi
    bspc desktop --rename "${new_name}"
}

toggle_mode(){
    local chosen_mode="$1"
    sed -i "s/creation_mode=.*/creation_mode=\"${chosen_mode}\"/g" ${CONFIG_PATH}
    changed="0"

    . "${CONFIG_PATH}"
    if [ "${creation_mode}" = "manual" ]; then
        echo "" > $HOME/.config/indicators/creation.ind
        changed="1"
    fi
    if [ "${creation_mode}" = "mixed" ]; then
        echo "" > $HOME/.config/indicators/creation.ind
        changed="1"
    fi
    if [ "${creation_mode}" = "auto" ]; then
        echo "" > $HOME/.config/indicators/creation.ind
        changed="1"
    fi

    if [ ${changed} = "0" ]; then
        notify-send "Mode NOT changed" "Please select auto, mixed or manual"
    else
        notify-send "Mode changed" "Mode set to ${chosen_mode}"
    fi

    
}

show_help() {
    echo "Manipulate the monitors."; echo ""
    echo "g                             go to desktop number"
    echo "m                             move to desktop number"
    echo "f                             move and follow to desktop number"
    echo "t                             Toggle mode (manual or auto)"
    echo "r                             Rename desktop"

}

while getopts "h?g:m:t:r:f:" opt; do
    case "$opt" in
    h|\?) show_help
        ;;
    g) goto ${OPTARG}
        ;;
    m) moto ${OPTARG}
        ;;
    f) mofoto ${OPTARG}
        ;;
    t) toggle_mode ${OPTARG}
        ;;
    r) rename_desktop ${OPTARG}
        ;;
    esac
done


