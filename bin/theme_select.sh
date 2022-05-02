#!/bin/bash
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
        CHOSEN=$(retrieve_themes | dmenu -i -y 16 -bw 2 -z 850  -p "Change the theme: ")
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

    # Refresh qtile to refresh everything
    python $HOME/bin/qtile/restart.py 
}

# Try to copy the config where is the themename
function reset_configs(){
    theme_name=$1
    cp ${HOME}/.config/bspwm/themes/${theme_name}.cfg ${HOME}/.config/bspwm/themes/bsp.cfg
    cp ${HOME}/.vim/configs/theme_template.vim ${HOME}/.vim/configs/theme.vim
    cp ${HOME}/.config/dunst/dunstrc_default ${HOME}/.config/dunst/dunstrc
    cp ${HOME}/.config/twmn/twmn.conf.tmpl ${HOME}/.config/twmn/twmn.conf
    cp ${HOME}/.config/polybar/themes/${theme_name} ${HOME}/.config/polybar/config
    cp ${HOME}/.config/polybar/themes/"${theme_name}"_simple ${HOME}/.config/polybar/config_simple
    cp ${HOME}/.config/conky/themes/${theme_name}/conky.sh ${HOME}/.config/conky/conky.sh
    cp ${HOME}/.config/conky/themes/${theme_name}/process.conf ${HOME}/.config/conky/process.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/cpu.conf ${HOME}/.config/conky/cpu.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/clock.conf ${HOME}/.config/conky/clock.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/fortune.conf ${HOME}/.config/conky/fortune.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/clock_rings.lua ${HOME}/.config/conky/clock_rings.lua
    cp ${HOME}/.config/conky/themes/${theme_name}/calendar_widgets.lua ${HOME}/.config/conky/calendar_widgets.lua
    cp ${HOME}/.config/conky/themes/${theme_name}/calendar.conf ${HOME}/.config/conky/calendar.conf
    cp ${HOME}/.config/qtile/theme_tmpl_${theme_name}.py ${HOME}/.config/qtile/theme.py
    cp ${HOME}/.config/vis/colors/theme_tpl ${HOME}/.config/vis/colors/theme
    cp ${HOME}/.config/tint2/tint2rc.tpl ${HOME}/.config/tint2/tint2rc
    cp ${HOME}/bin/imports/lock.sh.tmpl ${HOME}/bin/imports/lock.sh
    if [ "${CHOSEN}" != "wallpaper" ]; then
        cp ${HOME}/.config/alacritty/alacritty.${theme_name} ${HOME}/.config/alacritty/alacritty.yml
    fi
}

function get_wallpaper() {
    selected_wallpaper=$(monitors_info.sh -a | /usr/bin/dmenu -y 16 -bw 2 -z 850 -p "Extract color from wallpaper:" -n)
    selected_wallpaper=$(monitors_info.sh -ib "${selected_wallpaper}")
    selected_wallpaper=$((${selected_wallpaper} + 1))
    cur_wallpaper=$(cat ${WALLPAPER_PATH} | grep file | awk -v SEL=$selected_wallpaper 'BEGIN {FS="="} NR==SEL {print $2}')

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
}

function startup_theme(){
    refresh_theme
    configure_$CHOSEN
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
