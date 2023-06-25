#!/usr/bin/env bash
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# To call use script >>/tmp/polybar1.log 2>&1 &

#set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail

source $HOME/bin/imports/color_sort.sh

TEMPLATES="$HOME/bin/templates/"

is_bspc=$(bspc wm --get-status)

show_help () {
    echo "Yay! Change the theme of the desktop"
    echo "-t          The theme name"
    echo "-h          This help message"
}


retrieve_themes () {
    for theme in $HOME/bin/themes/*
    do
        basename -s .cfg  $theme
    done
}


choose(){
    CHOSEN=$1
    if [ -z "$CHOSEN" ] 
    then
        CHOSEN=$(retrieve_themes | dmenu -i     -p "Change the theme: ")
    fi

    #Get the last to get how many monitors
    MONITOR=$(xrandr --query | grep "*" | nl | awk '{print $1}')

    WALLPAPER_PATH=$HOME/.config/nitrogen/bg-saved.cfg

    if [[ -z "${CHOSEN}" ]]; then
        exit
    fi
}

begin(){
    choose $1

    . $HOME/bin/themes/${CHOSEN}.cfg

    startup_theme

    . $HOME/.config/bspwm/themes/bsp.cfg

    # Colors
    bspc config focused_border_color            "${focused_border_color}"
    bspc config active_border_color             "${active_border_color}"
    bspc config normal_border_color             "${normal_border_color}"
    bspc config presel_feedback_color           "${presel_feedback_color}"
}

# Try to copy the config where is the themename
function reset_configs(){
    theme_name=$1

    if [ ! -d $HOME/.config/bspwm/themes ]; then
        mkdir -p "${HOME}/.config/bspwm/themes/bsp.cfg"
    fi
    if [ ! -d ${HOME}/.vim/configs ]; then
        mkdir -p "${HOME}/.vim/configs/"
    fi
    if [ ! -d ${HOME}/.config/dunst ]; then
        mkdir -p "${HOME}/.config/dunst/"
    fi
    if [ ! -d ${HOME}/.config/twmn ]; then
        mkdir -p "${HOME}/.config/twmn"
    fi
    if [ ! -d ${HOME}/.config/polybar ]; then
        mkdir -p "${HOME}/.config/polybar"
    fi
    if [ ! -d ${HOME}/.config/conky ]; then
        mkdir -p "${HOME}/.config/conky"
    fi
    if [ ! -d ${HOME}/.config/vis/colors ]; then
        mkdir -p "${HOME}/.config/vis/colors"
    fi
    if [ ! -d ${HOME}/.config/tint2 ]; then
        mkdir -p "${HOME}/.config/tint2"
    fi
    if [ ! -d ${HOME}/.config/wm ]; then
        mkdir -p "${HOME}/.config/wm"
    fi
    if [ ! -d ${HOME}/.config/rofi ]; then
        mkdir -p "${HOME}/.config/rofi"
    fi
    if [ ! -d ${HOME}/.config/wezterm ]; then
        mkdir -p "${HOME}/.config/wezterm"
    fi
    if [ ! -d ${HOME}/.config/eww ]; then
        mkdir -p "${HOME}/.config/eww"
    fi
    
    cp ${TEMPLATES}/bspwm/${theme_name}/bsp.cfg ${HOME}/.config/bspwm/themes/bsp.cfg
    cp ${TEMPLATES}/vim/* ${HOME}/.vim/configs/
    cp ${TEMPLATES}/dunst/dunstrc ${HOME}/.config/dunst/dunstrc
    cp ${TEMPLATES}/twmn/twmn.conf ${HOME}/.config/twmn/twmn.conf
    cp ${TEMPLATES}/polybar/${theme_name}/* ${HOME}/.config/polybar/
    cp ${TEMPLATES}/conky/${theme_name}/* ${HOME}/.config/conky/
    cp ${TEMPLATES}/vis/theme ${HOME}/.config/vis/colors/theme
    cp ${TEMPLATES}/tint2/* ${HOME}/.config/tint2/
    cp ${TEMPLATES}/lock/lock.sh ${HOME}/bin/imports/lock.sh
    cp ${TEMPLATES}/pulse/pulse.cfg ${HOME}/.config/wm/pulse.cfg
    cp ${TEMPLATES}/rofi/${theme_name}/* ${HOME}/.config/rofi/
    cp ${TEMPLATES}/wm/terminal.conf ${HOME}/.config/wm/terminal.conf
    cp ${TEMPLATES}/wm/tmux.opt ${HOME}/.config/wm/tmux.opt
    cp ${TEMPLATES}/wm/ytplay.conf ${HOME}/.config/wm/ytplay.conf
    cp ${TEMPLATES}/wezterm/extra.lua ${HOME}/.config/wezterm/
    cp ${TEMPLATES}/eww/${theme_name}/* ${HOME}/.config/eww/

    # Overwiting only if it not exists
    [ ! -f $HOME/.tmux.conf ] && cp ${TEMPLATES}/tmux/tmux.conf ${HOME}/.tmux.conf
    [ ! -f $HOME/.config/wm/bspwm.conf ] && cp ${TEMPLATES}/wm/bspwm.conf ${HOME}/.config/wm/bspwm.conf
    [ ! -f $HOME/.config/wm/monitors.conf ] && cp ${TEMPLATES}/wm/monitors.conf ${HOME}/.config/wm/monitors.conf
    [ ! -f $HOME/.config/wezterm/wezterm.lua ] && cp ${TEMPLATES}/wezterm/wezterm.lua ${HOME}/.config/wezterm/wezterm.lua
}

function get_wallpaper() {
    selected_wallpaper=$(monitors_info.sh -a | /usr/bin/dmenu -p "Extract color from wallpaper:" -n)
    selected_wallpaper=$(monitors_info.sh -ib "${selected_wallpaper}")
#    selected_wallpaper=$((${selected_wallpaper} + 1))
    cur_wallpaper=$(cat ${WALLPAPER_PATH} | grep "xin_${selected_wallpaper}" -A 1 | tail -n 1 | cut -d '=' -f 2)

    echo ${cur_wallpaper}
}

function refresh_theme() {
    killall -q picom
    killall -q dunst
    killall -q twmnd
    bspc config border_radius 0
    bspc config window_gap 0
    bspc config top_padding 0
    bspc config bottom_padding 0
    bspc config left_padding 0
    bspc config right_padding 0

    killall -q tint2
    killall -q conky
    killall -q polybar
    killall -q eww
}

function startup_theme(){
    refresh_theme
    configure_$CHOSEN
}

function finalize_theme(){
    font_select.sh
    terminal_theme.sh
}

function retrieve_color(){
    index=$((($2 * ${#colors_wallpaper[@]}) / 15))

    if [ $index -eq 0 ]; then
        index=1
    fi

    if [[   "$1" == "i" ]]; then
        echo "${colors_wallpaper[$((${#colors_wallpaper[@]} - $index))]}"
    else
        echo "${colors_wallpaper[$index]}"
    fi
}

function text_color(){
    if [[   "$1" == "i" ]]; then
        index=$((${#colors[@]} - $2))
        text=$(black_or_white $colors $index)
    else
        text=$(black_or_white $colors $2)
    fi

    if [ "$text" = "light" ]; then
        echo $(retrieve_color i 1)
    else
        echo $(retrieve_color n 1)
    fi
}

if [[ $1 == "" ]]; then
    begin
else
    while getopts "h?t:" opt; do
        case "$opt" in
        h|\?)
            show_help
            ;;
        t) begin $OPTARG
            ;;
        esac
    done
fi
