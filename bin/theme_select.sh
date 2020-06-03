#!/bin/bash

# To call use script >>/tmp/polybar1.log 2>&1 &

#set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail

source $HOME/bin/imports/color_sort.sh

CHOSEN=$(printf "night\\nday\\nlight\\nwallpaper" | dmenu -i -p "Change the theme: ")
#Get the last to get how many monitors
MONITOR=$(xrandr --query | grep " connected" | nl | awk '{print $1}' | tail -n 1)


if [[ -z "${CHOSEN}" ]]; then
    exit
fi

# Try to copy the config where is the themename

source ${HOME}/.config/bspwm/themes/bsp.cfg

function reset_configs(){
    cp ${HOME}/.vim/configs/theme_template.vim ${HOME}/.vim/configs/theme.vim
    cp ${HOME}/.config/bspwm/themes/${theme_name}.cfg ${HOME}/.config/bspwm/themes/bsp.cfg
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
    cp ${HOME}/.config/vis/colors/theme_tpl ${HOME}/.config/vis/colors/theme
    cp ${HOME}/.config/alacritty/alacritty.${theme_name} ${HOME}/.config/alacritty/alacritty.yml
}


function get_wallpaper() {
    if [[ ${MONITOR} -gt 1 ]]; then
        local wallpaper_number=$(printf "1\\n2" | dmenu -i -p "Choose the wallpaper to use:")
        if [[  "${wallpaper_number}" -eq "1" ]]; then
            local cur_wallpaper="$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==1 {print $2}')"
        fi
        if [[  "${wallpaper_number}" -eq "2" ]]; then
            local cur_wallpaper="$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==2 {print $2}')"
        fi
    else
        local cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==1 {print $2}')
    fi

    if [[  -z ${cur_wallpaper} ]]; then
        local cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==1 {print $2}')
    fi

    echo ${cur_wallpaper}
}

function refresh_theme() {
    killall -qw picom
    killall -qw dunst
    killall -qw twmnd
    bspc config border_radius 0
    bspc config window_gap 0

    # Start conky according theme
    killall -qw conky
    killall -qw polybar
}

function prepare_wallpaper(){
    killall -qw picom
    killall -qw conky
    killall -qw polybar
}

function startup_theme(){
    reset_configs
    refresh_theme

    case "${CHOSEN}" in
        "day") configure_day;;
        "night") configure_night;;
        "light") configure_light;;
        "wallpaper") configure_wallpaper;;
    esac
}

function retrieve_color(){
    if [[   "$1" == "i" ]]; then
        echo "${colors_wallpaper[$((${#colors_wallpaper[@]} - $2))]}"
    else
        echo "${colors_wallpaper[$2]}"
    fi
}

function set_color_by_walpaper() {
    # Retrieve the background path
    echo "Changing color wallpaper"
    prepare_wallpaper
    echo "Reseting configs"
    reset_configs

    # This function is located on bspwm themes files
    echo "Updating files"
    update_files

    echo "Refreshing theme"
    refresh_theme
    echo "Ending"
}

configure_light() {
    source ${HOME}/.config/bspwm/themes/bsp.cfg
    cp ${HOME}/.vim/configs/theme_template.vim ${HOME}/.vim/configs/theme.vim
    killall -qw picom
    killall -qw conky
    killall -qw polybar
    killall -qw twmnd
    xsetroot -solid "#17241D"
    bspc config border_radius 0
    bspc config top_padding 0
    bspc config window_gap 0
    notify-send "DUNST_COMMAND_PAUSE"
}

configure_night() {
    source ${HOME}/.config/bspwm/themes/bsp.cfg

    # Configure wallpaper
    if [ "${CHOSEN}" = "night" ]
    then
        nitrogen --head=0 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}
        nitrogen --head=1 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}
    fi

    # Set the colors
    echo "Getting colors"
    local cur_wallpaper=$(get_wallpaper)

    echo $cur_wallpaper > ~/wallpaper.txt

    local colors=($(convert "$cur_wallpaper" -format %c -depth 8 -colors 15 histogram:info:- | sort -n | grep -o "#......"))
    local colors_wallpaper=($(get_sorted_color $colors))

    echo ${colors_wallpaper[@]} > ~/wallcolors.txt

    # Config polybar colors
    transp_level=00
    transp_level2=B7
    sed -i "s/^background = #.*/background = #${transp_level}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
    sed -i "s/^background-alt = #.*/background-alt = #${transp_level2}$(retrieve_color n 0)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground = #.*/foreground = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #FFFFFF/" ${HOME}/.config/polybar/config

    sed -i "s/^foreground-clock = #.*/foreground-clock = #${transp_level2}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-load = #.*/foreground-load = #${transp_level2}$(retrieve_color n 3)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-temp = #.*/foreground-temp = #${transp_level2}$(retrieve_color n 5)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-cpu = #.*/foreground-cpu = #${transp_level2}$(retrieve_color n 7)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-memory = #.*/foreground-memory = #${transp_level2}$(retrieve_color n 3)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-sound = #.*/foreground-sound = #${transp_level2}$(retrieve_color n 2)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-pomodoro = #.*/foreground-pomodoro = #${transp_level2}$(retrieve_color n 6)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-weather = #.*/foreground-weather = #${transp_level2}$(retrieve_color n 4)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-torrent = #.*/foreground-torrent = #${transp_level2}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config

    sed -i "s/^background = #.*/background = #${transp_level}$(retrieve_color n 0)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^background-alt = #.*/background-alt = #${transp_level2}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground = #.*/foreground = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #FFFFFF/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground-cpu = #.*/foreground-cpu = #${transp_level2}$(retrieve_color i 7)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground-load = #.*/foreground-load = #${transp_level2}$(retrieve_color i 3)/" ${HOME}/.config/polybar/config_simple

    # Config bsp collors
    sed -i "s/#100001/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100002/#$(retrieve_color i 5)/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100003/#$(retrieve_color n 5)/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100004/#$(retrieve_color n 3)/" ${HOME}/.config/bspwm/themes/bsp.cfg

    sed -i "s/#100005/#$(retrieve_color n 0)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU BCKGROUND
    sed -i "s/#1ffff6/#$(retrieve_color i 3)/" ${HOME}/.config/bspwm/themes/bsp.cfg # DMENU FONT COLOR
    sed -i "s/#100007/#$(retrieve_color i 3)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU ALT
    sed -i "s/#100008/#$(retrieve_color n 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU SELECTED FONT COLOR

    # Config dunst colors
    # Low
    sed -i "s/#0B1B03/#$(retrieve_color n 3)/" ${HOME}/.config/dunst/dunstrc #background low
    sed -i "s/#FFFFFF/#$(retrieve_color i 1)/" ${HOME}/.config/dunst/dunstrc #foreground
    sed -i "s/#03171B/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc #frame


    # Normal
    sed -i "s/#27125B/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc
    sed -i "s/#FFFFFE/#$(retrieve_color i 1)/" ${HOME}/.config/dunst/dunstrc
    sed -i "s/#668BC8/#$(retrieve_color n 0)/" ${HOME}/.config/dunst/dunstrc

    sed -i "s/#000000/#$(retrieve_color n 2)/" ${HOME}/.config/twmn/twmn.conf
    sed -i "s/#999999/#$(retrieve_color i 1)/" ${HOME}/.config/twmn/twmn.conf

    # Configure conky! Here we go!
    sed -i "s/768B98/$(retrieve_color i 1)/" ${HOME}/.config/conky/process.conf
    sed -i "s/5A615C/$(retrieve_color i 8)/" ${HOME}/.config/conky/process.conf

    sed -i "s/000001/$(retrieve_color i 3)/" ${HOME}/.config/conky/process.conf
    sed -i "s/000002/$(retrieve_color i 4)/" ${HOME}/.config/conky/process.conf
    sed -i "s/000003/$(retrieve_color i 5)/" ${HOME}/.config/conky/process.conf
    sed -i "s/000004/$(retrieve_color i 6)/" ${HOME}/.config/conky/process.conf
    sed -i "s/000005/$(retrieve_color i 7)/" ${HOME}/.config/conky/process.conf
    sed -i "s/000006/$(retrieve_color i 8)/" ${HOME}/.config/conky/process.conf


    sed -i "s/100000/$(retrieve_color i 3)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/200000/$(retrieve_color i 2)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/300000/$(retrieve_color i 5)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/000004/$(retrieve_color i 6)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/000005/$(retrieve_color i 7)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/000006/$(retrieve_color i 8)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/000001/$(retrieve_color i 3)/" ${HOME}/.config/conky/clock_rings.lua
    sed -i "s/000002/$(retrieve_color i 4)/" ${HOME}/.config/conky/clock_rings.lua

    sed -i "s/041866/$(retrieve_color n 2)/" ${HOME}/.config/conky/clock.conf
    sed -i "s/CBD38F/$(retrieve_color i 4)/" ${HOME}/.config/conky/clock.conf
    sed -i "s/2d2d2d/$(retrieve_color i 5)/" ${HOME}/.config/conky/clock.conf

    # Configure vis color
    sed -i "s/000001/$(retrieve_color n 1)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000002/$(retrieve_color n 2)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000003/$(retrieve_color n 3)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000004/$(retrieve_color n 4)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000005/$(retrieve_color n 5)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000006/$(retrieve_color n 6)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000007/$(retrieve_color n 7)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000008/$(retrieve_color n 8)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000009/$(retrieve_color n 9)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000010/$(retrieve_color n 10)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000011/$(retrieve_color n 11)/" ${HOME}/.config/vis/colors/theme
    # Configure vim
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=dark/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim

    # Configure lockscreen
    rm $HOME/Videos/*
    ln -s $HOME/Documents/Pictures/screensavers/futuristic/* $HOME/Videos

    # set messaging
    twmnd >> /tmp/twmn.log 2>&1 &

    # Set windows gap
    bspc config window_gap 2

    # Start conky
    ${HOME}/.config/conky/conky.sh >> /tmp/conky.log 2>&1 &

    #start the polybar
    toggle_bars.sh

    #Start transparency
    picom -b >> /tmp/picom.log 2>&1 &

    echo "Theme setup finished"
}

configure_day() {
    source ${HOME}/.config/bspwm/themes/bsp.cfg

    # Configure wallpaper
    if [ "${CHOSEN}" = "day" ]
    then
        nitrogen --head=0 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}
        nitrogen --head=1 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}
    fi

    # Configure colors
    echo "Getting colors"
    local cur_wallpaper=$(get_wallpaper)

    echo $cur_wallpaper > ~/wallpaper.txt

    local colors=($(convert "$cur_wallpaper" -format %c -depth 8 -colors 15 histogram:info:- | sort -n | grep -o "#......"))
    local colors_wallpaper=($(get_sorted_color $colors))

    echo ${colors_wallpaper[@]} > ~/wallcolors.txt

    # Config polybar colors
    sed -i "s/^background = #.*/background = #C5$(retrieve_color i 1)/" ${HOME}/.config/polybar/config
    sed -i "s/^background-alt = #.*/background-alt = #$(retrieve_color n 2)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground = #.*/foreground = #$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
    sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color n 3)/" ${HOME}/.config/polybar/config #ICONS
    sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color i 1)/" ${HOME}/.config/polybar/config

    sed -i "s/#000001/#$(retrieve_color n 2)/" ${HOME}/.config/polybar/config
    sed -i "s/#000002/#$(retrieve_color n 4)/" ${HOME}/.config/polybar/config
    sed -i "s/#000003/#$(retrieve_color n 6)/" ${HOME}/.config/polybar/config
    sed -i "s/#000004/#$(retrieve_color n 3)/" ${HOME}/.config/polybar/config
    sed -i "s/#000005/#$(retrieve_color n 5)/" ${HOME}/.config/polybar/config
    sed -i "s/#000006/#$(retrieve_color n 8)/" ${HOME}/.config/polybar/config
    sed -i "s/#000007/#$(retrieve_color n 10)/" ${HOME}/.config/polybar/config
    sed -i "s/#000008/#$(retrieve_color n 12)/" ${HOME}/.config/polybar/config
    sed -i "s/#000009/#$(retrieve_color n 9)/" ${HOME}/.config/polybar/config
    sed -i "s/#000010/#$(retrieve_color n 7)/" ${HOME}/.config/polybar/config

    sed -i "s/^background = #.*/background = #C5$(retrieve_color i 1)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^background-alt = #.*/background-alt = #$(retrieve_color n 2)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground = #.*/foreground = #$(retrieve_color n 1)/" ${HOME}/.config/polybar/config_simple
    sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color n 3)/" ${HOME}/.config/polybar/config_simple #ICONS
    sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color i 1)/" ${HOME}/.config/polybar/config_simple


    # Config dunst colors
    # Urgency low
    sed -i "s/#0B1B03/#$(retrieve_color i 1)/" ${HOME}/.config/dunst/dunstrc #background
    sed -i "s/#FFFFFF/#$(retrieve_color n 1)/" ${HOME}/.config/dunst/dunstrc #foreground
    sed -i "s/#03171B/#$(retrieve_color n 4)/" ${HOME}/.config/dunst/dunstrc # frame

    # Urgency normal
    sed -i "s/#27125B/#$(retrieve_color i 2)/" ${HOME}/.config/dunst/dunstrc
    sed -i "s/#FFFFFE/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc
    sed -i "s/#668BC8/#$(retrieve_color i 10)/" ${HOME}/.config/dunst/dunstrc

    sed -i "s/#000000/#$(retrieve_color i 2)/" ${HOME}/.config/twmn/twmn.conf
    sed -i "s/#999999/#$(retrieve_color n 2)/" ${HOME}/.config/twmn/twmn.conf

    # Config bsp collors
    sed -i "s/#100001/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100002/#$(retrieve_color i 5 )/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100003/#$(retrieve_color n 3 )/" ${HOME}/.config/bspwm/themes/bsp.cfg
    sed -i "s/#100004/#$(retrieve_color i 3 )/" ${HOME}/.config/bspwm/themes/bsp.cfg

    sed -i "s/#100005/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU BCKGROUND
    sed -i "s/#1ffff6/#$(retrieve_color n 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg # DMENU FONT COLOR
    sed -i "s/#100007/#$(retrieve_color n 2)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU ALT
    sed -i "s/#100008/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU SELECTED FONT COLOR

    # Configure conky! Here we go!
    sed -i "s/CBD38F/$(retrieve_color i 8)/" ${HOME}/.config/conky/process.conf
    sed -i "s/777777/$(retrieve_color i 6)/" ${HOME}/.config/conky/process.conf
    sed -i "s/444444/$(retrieve_color i 4)/" ${HOME}/.config/conky/process.conf
    sed -i "s/222222/$(retrieve_color i 2)/" ${HOME}/.config/conky/process.conf

    sed -i "s/CBD38F/$(retrieve_color i 8)/" ${HOME}/.config/conky/cpu.conf
    sed -i "s/777777/$(retrieve_color i 6)/" ${HOME}/.config/conky/cpu.conf
    sed -i "s/444444/$(retrieve_color i 4)/" ${HOME}/.config/conky/cpu.conf
    sed -i "s/222222/$(retrieve_color i 2)/" ${HOME}/.config/conky/cpu.conf

    # Configure vis color
    sed -i "s/000001/$(retrieve_color i 1)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000002/$(retrieve_color i 2)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000003/$(retrieve_color i 3)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000004/$(retrieve_color i 4)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000005/$(retrieve_color i 5)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000006/$(retrieve_color i 6)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000007/$(retrieve_color i 7)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000008/$(retrieve_color i 8)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000009/$(retrieve_color i 9)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000010/$(retrieve_color i 10)/" ${HOME}/.config/vis/colors/theme
    sed -i "s/000011/$(retrieve_color i 11)/" ${HOME}/.config/vis/colors/theme
    # Configure vim
    sed -i 's/^colorscheme.*/colorscheme gruvbox/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/set background.*/set background=light/' ${HOME}/.vim/configs/theme.vim
    sed -i 's/airline_theme.*/airline_theme="gruvbox"/' ${HOME}/.vim/configs/theme.vim

    # Configure lockscreen
    rm $HOME/Videos/*

    ln -s $HOME/Documents/Pictures/screensavers/day/* $HOME/Videos


    #Set messaging
    dunst >> /tmp/dunst.log 2>&1 &

    #Rounded corners
    bspc config border_radius 7

    # Set windows gap
    bspc config window_gap 6

    #Start conky
    ${HOME}/.config/conky/conky.sh >> /tmp/conky.log 2>&1 &

    #start the polybar
    toggle_bars.sh

    #Start transparency
    picom -b >> /tmp/picom.log 2>&1 &

    echo "Theme setup finished"
}

configure_wallpaper() {
    if [ "${theme_name}" = "day" ]
    then
        configure_day
    fi

    if [ "${theme_name}" = "night" ]
    then
        configure_night
    fi
}

startup_theme


# Colors
bspc config focused_border_color            "${focused_border_color}"
bspc config active_border_color             "${active_border_color}"
bspc config normal_border_color             "${normal_border_color}"
bspc config presel_feedback_color           "${presel_feedback_color}"
