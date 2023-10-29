#!/usr/bin/env bash

MONITOR_OPTIONS="$HOME/.config/wm/monitor_options.conf"

DP=$(source $HOME/.config/wm/xorg_local.sh getgs)

start_program() {
    local is_openbox=0
    if [ ! -z "$(command -v openbox)" ]; then
        is_openbox=1
    else
        echo "In case of problems in resolution or any other issues, please install openbox"
    fi

    local game="$(which $1)"
    local tmp_start=/tmp/start_tmp.sh
    cp $HOME/.nix-profile/temp/start_tmp.sh ${tmp_start}

    local dimensions="$(cat $MONITOR_OPTIONS)"
    local dim=$(printf "$dimensions" | fzf)
    local dim=$(awk '{print $1}' <<< "${dim}")

    echo "Iniciando $1 em modo $dim. Enjoy!"
    sleep 2

    echo -e "xrandr --output $DP --mode '$dim'" >> ${tmp_start}
    echo -e "xrandr --output $DP --set TearFree on" >> ${tmp_start}

    if [ ${is_openbox} == 1 ]; then
        local openbox="$(which openbox) &\n "
    fi

    if [ "$1" == "steam" ]; then
        echo -e "${openbox}gamemoderun ${game}" >> ${tmp_start}
    else
        echo -e "${openbox} ${game}" >> ${tmp_start}
    fi
    xsetroot -cursor_name left_ptr
    xinit ${tmp_start} -- :1 vt$XDG_VTNR || exit 1
}

start_xinit() {
    local game="$(which $1)"
    local tmp_start=/tmp/start_tmp.sh
    cp $HOME/.nix-profile/temp/start_tmp.sh ${tmp_start}

    local dimensions="$(cat $MONITOR_OPTIONS)"
    local dim=$(printf "$dimensions" | fzf)
    local dim=$(awk '{print $1}' <<< "${dim}")

    echo "Iniciando $1 em modo $dim. Enjoy!"
    sleep 2

    echo -e "xrandr --output $DP --mode '$dim'" >> ${tmp_start}
    echo -e "xrandr --output $DP --set TearFree on" >> ${tmp_start}

    echo -e "${game}" >> ${tmp_start}
    xsetroot -cursor_name left_ptr
    xinit ${tmp_start} -- :1 vt$XDG_VTNR || exit 1
}

start_steam_deck() {
    local program="$(which $1)"
    if [ -z "$program" ]; then
        echo "No program specified, starting steam on $DP"
        local program="steam"
        local steamintegration="-e"
    else
        echo "Starting full $1 on $DP"
    fi

    # The total screen
    local dimensions="$(cat $MONITOR_OPTIONS)"
    echo "Choose the dimension then the scale"
    local dim=$(printf "$dimensions" | (dmenu -p "Game dimension" -l 10 || fzf --height 40%))
    local dim=$(awk '{print $1}' <<< "${dim}")
    local dim="$(awk '{print $2}' FS=x <<< $dim)"

    # The rescaled dimension
    local dimensions="$(cat $MONITOR_OPTIONS)"
    local dim2=$(printf "$dimensions" | (dmenu -p "Scale to" -l 10 || fzf --height 40%))
    local dim2=$(awk '{print $1}' <<< "${dim2}")
    local dim2="$(awk '{print $2}' FS=x <<< $dim2)"

    gamescope -h $dim -H $dim2 -O $DP -U $steamintegration -- $program
}

start_embedded() {
    local program="$1"

    # The total screen
    local dimensions="$(cat $MONITOR_OPTIONS)"
    echo "Choose the dimension then the scale"
    local dim=$(printf "$dimensions" | (dmenu -p "Dimension" || fzf --height 40%))
    local dim=$(awk '{print $1}' <<< "${dim}")
    local dim="$(awk '{print $2}' FS=x <<< $dim)"

    # The rescaled dimension
    local dimensions="$(cat $MONITOR_OPTIONS)"
    local dim2=$(printf "$dimensions" | (dmenu -p "Scale to"|| fzf --height 40%))
    local dim2=$(awk '{print $1}' <<< "${dim2}")
    local dim2="$(awk '{print $2}' FS=x <<< $dim2)"

    gamescope -h $dim -H $dim2 -O $DP -r 60 -U -- $program
}

show_help() {
    echo "Start programs without a window manager"
    echo "-s                         Start the program passed in an openbox session"
    echo "-p                         Start the program passed directly on xinit"
    echo "-e                         Start a generic program emedded in a gamesession"
    echo "-E                         Start a steamdeck session"

}

rcommand="0"
soft="0"

while getopts "h?eEsp" opt; do
    case "${opt}" in
        h|\?) show_help ;;
        s) rcommand="s";;
        p) rcommand="p";;
        E) rcommand="E";;
        e) rcommand="e";;
        R) rcommand="r";;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "s") start_program $1;;
    "p") start_xinit $1;;
    "e") start_embedded $1;;
    "E") start_steam_deck $1;;
    "r") reset_lightness;;
esac
