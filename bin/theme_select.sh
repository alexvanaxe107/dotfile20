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

# if [ $CHOSEN == "wallpaper" ]; then
#     CHOSEN_font=$(printf "Original\\nSoft" | dmenu -i -p "Chose the font kind:")
# fi

if [[ -z "${CHOSEN}" ]]; then
    exit
fi

# Try to copy the config where is the themename

if [[  "wallpaper" != "${CHOSEN}" ]]; then
    cp ${HOME}/.config/bspwm/themes/${CHOSEN}.cfg ${HOME}/.config/bspwm/themes/bsp.cfg
fi
source ${HOME}/.config/bspwm/themes/bsp.cfg


function reset_configs(){
    cp ${HOME}/.config/bspwm/themes/${theme_name}.cfg ${HOME}/.config/bspwm/themes/bsp.cfg
    cp ${HOME}/.config/dunst/dunstrc_default ${HOME}/.config/dunst/dunstrc
    cp ${HOME}/.config/polybar/themes/${theme_name} ${HOME}/.config/polybar/config
    cp ${HOME}/.config/polybar/themes/"${theme_name}"_simple ${HOME}/.config/polybar/config_simple
    cp ${HOME}/.config/conky/themes/${theme_name}/process.conf ${HOME}/.config/conky/process.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/cpu.conf ${HOME}/.config/conky/cpu.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/clock.conf ${HOME}/.config/conky/clock.conf
    cp ${HOME}/.config/conky/themes/${theme_name}/fortune.conf ${HOME}/.config/conky/fortune.conf
    cp ${HOME}/.config/vis/colors/theme_tpl ${HOME}/.config/vis/colors/theme
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

function update_screensaver() {
    rm $HOME/Videos/*

    if [[  "${theme_name}" = "day" ]]; then
        ln -s /home/alexvanaxe/Documents/Pictures/screensavers/day/* $HOME/Videos
    else
        ln -s /home/alexvanaxe/Documents/Pictures/screensavers/futuristic/* $HOME/Videos
    fi
}

function refresh_theme() {
    source ${HOME}/.config/bspwm/themes/bsp.cfg
    $(update_screensaver)
    killall -qw picom; picom -b >> /tmp/picom.log 2>&1 &
    killall -qw dunst; dunst >> /tmp/dunst.log 2>&1 &
    bspc config window_gap 6
    # Start conky according theme
    killall -qw conky

    killall -qw polybar
    toggle_bars.sh
    ${HOME}/.config/conky/conky.sh >> /tmp/conky.log 2>&1 &
}

function prepare_wallpaper(){
    killall -qw picom
    killall -qw conky
    killall -qw polybar
}

function startup_theme(){
    echo "starting up"
    reset_configs
    if [[  "light" = "${CHOSEN}" ]]; then
        killall -qw picom
        killall -qw conky
        killall -qw polybar
        xsetroot -solid blue
        bspc config top_padding 0
        bspc config window_gap 0  
    else
        # Set wallpaper according theme
        nitrogen --head=0 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}
        nitrogen --head=1 --save --set-scaled --random ${HOME}/Documents/Pictures/Wallpapers/${theme_name}

        refresh_theme
    fi
}

function retrieve_color(){
    if [[   "$1" == "i" ]]; then
        echo "${colors_wallpaper[$((${#colors_wallpaper[@]} - $2))]}"
    else
        echo "${colors_wallpaper[$2]}"
    fi
}

function update_files(){
    echo "Getting colors"
    local chosen_font="Original"
    local cur_wallpaper=$(get_wallpaper)

    echo $cur_wallpaper > ~/wallpaper.txt

    local colors=($(convert "$cur_wallpaper" -format %c -depth 8 -colors 15 histogram:info:- | sort -n | grep -o "#......"))
    local colors_wallpaper=($(get_sorted_color $colors))

    # if [[ ${#colors_wallpaper[@]} -lt 141 ]]; then
    #     local colors_wallpaper=($(convert "${cur_wallpaper}" -format %c -depth 10  histogram:info:- | grep -o "#......" | cut -d "#" -f 2))
    # fi


    # DAY THEME
    if [[  "${theme_name}" = "day" ]]; then
        if [[  "${chosen_font}" != "Original" ]]; then
            sed -i "s/Special Elite/Hack/" ${HOME}/.config/polybar/config
            sed -i "s/Lekton/Hack/" ${HOME}/.config/bspwm/themes/bsp.cfg
            sed -i "s/Special Elite/Hack/" ${HOME}/.config/conky/process.conf
            sed -i "s/Special Elite/Hack/" ${HOME}/.config/conky/cpu.conf
        fi
                
        # Config polybar colors
        sed -i "s/^background = #.*/background = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-alt = #.*/background-alt = #$(retrieve_color n 2)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground = #.*/foreground = #$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color n 3)/" ${HOME}/.config/polybar/config #ICONS
        sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config

        sed -i "s/^background-talt0 = #.*/background-talt0 = #C5$(retrieve_color i 5)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt1 = #.*/background-talt1 = #C5$(retrieve_color i 5)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt2 = #.*/background-talt2 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt3 = #.*/background-talt3 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt4 = #.*/background-talt4 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt5 = #.*/background-talt5 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt6 = #.*/background-talt6 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt7 = #.*/background-talt7 = #C5$(retrieve_color i 4)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt8 = #.*/background-talt8 = #C5$(retrieve_color i 5)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-talt9 = #.*/background-talt9 = #C5$(retrieve_color i 5)/" ${HOME}/.config/polybar/config

        sed -i "s/^background = #.*/background = #C5$(retrieve_color i 3)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^background-alt = #.*/background-alt = #$(retrieve_color n 2)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^foreground = #.*/foreground = #$(retrieve_color n 1)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color n 3)/" ${HOME}/.config/polybar/config_simple #ICONS
        sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config_simple

        # Config dunst colors
        # Urgency low
        sed -i "s/#0B1B03/#$(retrieve_color i 1)/" ${HOME}/.config/dunst/dunstrc #background
        sed -i "s/#FFFFFF/#$(retrieve_color n 1)/" ${HOME}/.config/dunst/dunstrc #foreground
        sed -i "s/#03171B/#$(retrieve_color n 4)/" ${HOME}/.config/dunst/dunstrc # frame

        # Urgency normal
        sed -i "s/#27125B/#$(retrieve_color i 2)/" ${HOME}/.config/dunst/dunstrc
        sed -i "s/#FFFFFE/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc
        sed -i "s/#03171B/#$(retrieve_color i 10)/" ${HOME}/.config/dunst/dunstrc
        
        # Config bsp collors
        sed -i "s/#6F8E27/#$(retrieve_color n 2)/" ${HOME}/.config/bspwm/themes/bsp.cfg
        sed -i "s/#123456/#$(retrieve_color n 11)/" ${HOME}/.config/bspwm/themes/bsp.cfg

        sed -i "s/#9AB6CA/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU BCKGROUND
        sed -i "s/#3C413E/#$(retrieve_color n 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg # DMENU FONT COLOR
        sed -i "s/#48473A/#$(retrieve_color n 2)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU ALT
        sed -i "s/#9AB6CA/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU SELECTED FONT COLOR

        # Configure conky! Here we go!
        sed -i "s/777777/$(retrieve_color n 3)/" ${HOME}/.config/conky/process.conf
        sed -i "s/CBD38F/$(retrieve_color i 6)/" ${HOME}/.config/conky/process.conf
        sed -i "s/FFFFFF/$(retrieve_color i 2)/" ${HOME}/.config/conky/process.conf

        sed -i "s/777777/$(retrieve_color n 3)/" ${HOME}/.config/conky/cpu.conf
        sed -i "s/CBD38F/$(retrieve_color i 6)/" ${HOME}/.config/conky/cpu.conf
        sed -i "s/FFFFFF/$(retrieve_color i 2)/" ${HOME}/.config/conky/cpu.conf

        sed -i "s/041866/$(retrieve_color i 3)/" ${HOME}/.config/conky/clock.conf
        sed -i "s/CBD38F/$(retrieve_color i 6)/" ${HOME}/.config/conky/clock.conf
        sed -i "s/2d2d2d/$(retrieve_color i 2)/" ${HOME}/.config/conky/clock.conf

        # Configure vis color
        sed -i "s/180ECD/$(retrieve_color i 1)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/921FEF/$(retrieve_color i 5)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/EF1FE5/$(retrieve_color i 8)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/EF1F7D/$(retrieve_color i 10)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/180000/$(retrieve_color i 13)/" ${HOME}/.config/vis/colors/theme
    fi

    if [[  "${theme_name}" = "night" ]]; then
        if [[  ${chosen_font} != "Original" ]]; then
            sed -i "s/Iceland/Cantarell/" ${HOME}/.config/polybar/config
            sed -i "s/Iceland/Cantarell/" ${HOME}/.config/bspwm/themes/bsp.cfg
            sed -i "s/Iceland/Cantarell/" ${HOME}/.config/conky/process.conf
            sed -i "s/Iceland/Cantarell/" ${HOME}/.config/conky/cpu.conf
            sed -i "s/Orbitron/Cantarell/" ${HOME}/.config/conky/fortune.conf
            sed -i "s/Orbitron/Cantarell/" ${HOME}/.config/conky/clock.conf
        fi

        # Config polybar colors
        transp_level=00
        transp_level2=72
        sed -i "s/^background = #.*/background = #${transp_level}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
        sed -i "s/^background-alt = #.*/background-alt = #${transp_level}$(retrieve_color n 1)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground = #.*/foreground = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color i 1)/" ${HOME}/.config/polybar/config

        sed -i "s/^foreground-clock = #.*/foreground-clock = #${transp_level2}$(retrieve_color i 1)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-load = #.*/foreground-load = #${transp_level2}$(retrieve_color i 3)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-temp = #.*/foreground-temp = #${transp_level2}$(retrieve_color i 5)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-cpu = #.*/foreground-cpu = #${transp_level2}$(retrieve_color i 7)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-memory = #.*/foreground-memory = #${transp_level2}$(retrieve_color i 3)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-sound = #.*/foreground-sound = #${transp_level2}$(retrieve_color i 2)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-pomodoro = #.*/foreground-pomodoro = #${transp_level2}$(retrieve_color i 6)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-weather = #.*/foreground-weather = #${transp_level2}$(retrieve_color i 1)/" ${HOME}/.config/polybar/config
        sed -i "s/^foreground-torrent = #.*/foreground-torrent = #${transp_level2}$(retrieve_color i 4)/" ${HOME}/.config/polybar/config

        sed -i "s/^background = #.*/background = #87$(retrieve_color n 0)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^background-alt = #.*/background-alt = #$(retrieve_color n 1)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^foreground = #.*/foreground = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^foreground-alt = #.*/foreground-alt = #$(retrieve_color i 2)/" ${HOME}/.config/polybar/config_simple
        sed -i "s/^foreground-alt2 = #.*/foreground-alt2 = #$(retrieve_color n 4)/" ${HOME}/.config/polybar/config_simple

        # Config bsp collors
        sed -i "s/#372549/#$(retrieve_color i 1)/" ${HOME}/.config/bspwm/themes/bsp.cfg
        sed -i "s/#123456/#$(retrieve_color i 5)/" ${HOME}/.config/bspwm/themes/bsp.cfg

        sed -i "s/#05080F/#$(retrieve_color n 0)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU BCKGROUND
        sed -i "s/#EAF2EF/#$(retrieve_color i 2)/" ${HOME}/.config/bspwm/themes/bsp.cfg # DMENU FONT COLOR
        sed -i "s/#040C38/#$(retrieve_color i 2)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU ALT
        sed -i "s/#EAF2EF/#$(retrieve_color n 0)/" ${HOME}/.config/bspwm/themes/bsp.cfg #DMENU SELECTED FONT COLOR

        # Config dunst colors
        sed -i "s/#0B1B03/#$(retrieve_color n 3)/" ${HOME}/.config/dunst/dunstrc #background
        sed -i "s/#FFFFFF/#$(retrieve_color i 4)/" ${HOME}/.config/dunst/dunstrc #foreground
        sed -i "s/#03171B/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc #frame

        sed -i "s/#27125B/#$(retrieve_color n 2)/" ${HOME}/.config/dunst/dunstrc
        sed -i "s/#FFFFFE/#$(retrieve_color i 5)/" ${HOME}/.config/dunst/dunstrc
        sed -i "s/#03171B/#$(retrieve_color n 0)/" ${HOME}/.config/dunst/dunstrc

        # Configure conky! Here we go!
        sed -i "s/041866/$(retrieve_color n 2)/" ${HOME}/.config/conky/process.conf
        sed -i "s/CBD38F/$(retrieve_color i 8)/" ${HOME}/.config/conky/process.conf
        sed -i "s/FFFFFF/$(retrieve_color i 5)/" ${HOME}/.config/conky/process.conf

        sed -i "s/041866/$(retrieve_color n 2)/" ${HOME}/.config/conky/cpu.conf
        sed -i "s/CBD38F/$(retrieve_color i 8)/" ${HOME}/.config/conky/cpu.conf
        sed -i "s/FFFFFF/$(retrieve_color i 5)/" ${HOME}/.config/conky/cpu.conf

        sed -i "s/041866/$(retrieve_color n 2)/" ${HOME}/.config/conky/clock.conf
        sed -i "s/CBD38F/$(retrieve_color i 4)/" ${HOME}/.config/conky/clock.conf
        sed -i "s/2d2d2d/$(retrieve_color i 5)/" ${HOME}/.config/conky/clock.conf

        # Configure vis color
        sed -i "s/180ECD/$(retrieve_color n 1)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/921FEF/$(retrieve_color n 5)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/EF1FE5/$(retrieve_color n 8)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/EF1F7D/$(retrieve_color n 10)/" ${HOME}/.config/vis/colors/theme
        sed -i "s/180000/$(retrieve_color n 13)/" ${HOME}/.config/vis/colors/theme
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

case "${CHOSEN}" in
    "wallpaper") set_color_by_walpaper;;
    *) startup_theme;;
esac

function set_vim(){
    if [[  "day" = ${1} ]]; then
        sed -i 's/^colorscheme.*/colorscheme PaperColor/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=light/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="papercolor"/' ${HOME}/.config/nvim/personal/home.vim
    fi
    if [[  "night" = ${1} ]]; then
        sed -i 's/^colorscheme.*/colorscheme one/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="one"/' ${HOME}/.config/nvim/personal/home.vim
    fi
    if [[  "light" = ${1} ]]; then
        sed -i 's/^colorscheme.*/colorscheme default/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=dark/' ${HOME}/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="base16_vim"/' ${HOME}/.config/nvim/personal/home.vim
    fi
}

# Set vim according theme
case "${CHOSEN}" in
    "night") set_vim ${CHOSEN};;
    "day") set_vim ${CHOSEN};;
    "light") set_vim ${CHOSEN};;
    *) echo "None";;
esac

# Colors
bspc config focused_border_color            "${focused_border_color}"
bspc config active_border_color             "${active_border_color}"
bspc config normal_border_color             "${normal_border_color}"
bspc config urgent_border_color             "${urgent_border_color}"
bspc config presel_feedback_color           "${presel_feedback_color}"
bspc config normal_locked_border_color      "${normal_locked_border_color}"
bspc config focused_sticky_border_color     "${focused_sticky_border_color}"
bspc config active_sticky_border_color      "${active_sticky_border_color}"
bspc config normal_sticky_border_color      "${normal_sticky_border_color}"
bspc config focused_private_border_color    "${focused_private_border_color}"
bspc config active_private_border_color     "${active_private_border_color}"
bspc config normal_private_border_color     "${normal_private_border_color}"
