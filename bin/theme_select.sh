#!/bin/sh

chosen=$(printf "night\\nday\\nlight\\nwallpaper" | dmenu "$@" -i -p "Change the theme: ")

if [ -z "$chosen" ]; then
    exit
fi


cp $HOME/.config/polybar/config_bkp $HOME/.config/polybar/config
cp $HOME/.config/bspwm/themes/night.cfg $HOME/.config/bspwm/themes/bsp.cfg
cp $HOME/.config/conky/night/process.conf_tmp $HOME/.config/conky/night/process.conf
cp $HOME/.config/conky/night/cpu.conf_tmp $HOME/.config/conky/night/cpu.conf
cp $HOME/.config/conky/night/clock.conf_tmp $HOME/.config/conky/night/clock.conf
set_color_by_walpaper() {
    # Retrieve the background path

    cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | cut -d "=" -f 2)
    colors_wallpaper=($(convert $cur_wallpaper -format %c -depth 4  histogram:info:- | grep -o "#......" | cut -d "#" -f 2))

    # Config polybar colors
    sed -i "s/^background = #B7.*/background = #B7${colors_wallpaper[1]}/" $HOME/.config/polybar/config
    sed -i "s/^background-alt = #040C38/background-alt = #${colors_wallpaper[9]}/" $HOME/.config/polybar/config
    sed -i "s/^foreground = #EAF2EF/foreground = #${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/polybar/config
    sed -i "s/^foreground-alt = #6B6B6B/foreground-alt = #${colors_wallpaper[$((${#colors_wallpaper[@]} - 55))]}/" $HOME/.config/polybar/config
    sed -i "s/^foreground-alt2 = #969F63/foreground-alt2 = #${colors_wallpaper[$((${#colors_wallpaper[@]} - 75))]}/" $HOME/.config/polybar/config

    # Config bsp collors
    sed -i "s/#05080F/#${colors_wallpaper[1]}/" $HOME/.config/bspwm/themes/bsp.cfg
    sed -i "s/#372549/#${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/bspwm/themes/bsp.cfg
    sed -i "s/#EAF2EF/#${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/bspwm/themes/bsp.cfg
    sed -i "s/#040C38/#${colors_wallpaper[9]}/" $HOME/.config/bspwm/themes/bsp.cfg
    sed -i "s/#EAF2EF/#${colors_wallpaper[$((${#colors_wallpaper[@]} - 75))]}/" $HOME/.config/bspwm/themes/bsp.cfg

    # Configure conky! Here we go!
    sed -i "s/041866/${colors_wallpaper[15]}/" $HOME/.config/conky/night/process.conf
    sed -i "s/CBD38F/${colors_wallpaper[$((${#colors_wallpaper[@]} - 45))]}/" $HOME/.config/conky/night/process.conf
    sed -i "s/FFFFFF/${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/conky/night/process.conf

    sed -i "s/041866/${colors_wallpaper[15]}/" $HOME/.config/conky/night/cpu.conf
    sed -i "s/CBD38F/${colors_wallpaper[$((${#colors_wallpaper[@]} - 45))]}/" $HOME/.config/conky/night/cpu.conf
    sed -i "s/FFFFFF/${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/conky/night/cpu.conf

    sed -i "s/041866/${colors_wallpaper[1]}/" $HOME/.config/conky/night/clock.conf
    sed -i "s/CBD38F/${colors_wallpaper[$((${#colors_wallpaper[@]} - 45))]}/" $HOME/.config/conky/night/clock.conf
    sed -i "s/2d2d2d/${colors_wallpaper[$((${#colors_wallpaper[@]} - 5))]}/" $HOME/.config/conky/night/cpu.conf

    source $HOME/.config/bspwm/themes/bsp.cfg
    echo "Setting color";
}

case "$chosen" in
    "wallpaper") set_color_by_walpaper;;
    *) echo "Oii";;
esac

cp $HOME/.config/bspwm/themes/$chosen.cfg $HOME/.config/bspwm/themes/bsp.cfg
source $HOME/.config/bspwm/themes/bsp.cfg

if [ "light" == "$chosen" ]; then
    killall picom
    killall conky
    killall polybar
    xsetroot -solid blue
    bspc config top_padding 0
    bspc config window_gap 0  
else
    killall picom; picom -b &
    killall dunst; dunst &
    bspc config window_gap 6
    # Start conky according theme
    case "$chosen" in
        "night") killall conky; $HOME/.config/conky/night/conky.sh;;
        "day") killall conky; $HOME/.config/conky/day/conky.sh;;
        *) echo "Oii";;
    esac

    # Set wallpaper according theme
    case "$chosen" in
        "night") nitrogen --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/night;;
        "day") nitrogen --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/day;;
        *) echo "Oii";;
    esac

    killall polybar
    polybar $theme_name &
    sleep 1
    bspc config top_padding 16
fi

set_vim(){
    if [ "day" == $1 ]; then
        sed -i 's/^colorscheme.*/colorscheme PaperColor/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=light/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="papercolor"/' $HOME/.config/nvim/personal/home.vim
    fi
    if [ "night" == $1 ]; then
        sed -i 's/^colorscheme.*/colorscheme one/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=dark/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="one"/' $HOME/.config/nvim/personal/home.vim
    fi
    if [ "light" == $1 ]; then
        sed -i 's/^colorscheme.*/colorscheme default/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/set background.*/set background=dark/' $HOME/.config/nvim/personal/home.vim
        sed -i 's/airline_theme.*/airline_theme="base16_vim"/' $HOME/.config/nvim/personal/home.vim
    fi
}

# Set vim according theme
case "$chosen" in
    "night") set_vim $chosen;;
    "day") set_vim $chosen;;
    "light") set_vim $chosen;;
    *) echo "Oii";;
esac


# Colors
bspc config focused_border_color            "$focused_border_color"
bspc config active_border_color             "$active_border_color"
bspc config normal_border_color             "$normal_border_color"
bspc config urgent_border_color             "$urgent_border_color"
bspc config presel_feedback_color           "$presel_feedback_color"
bspc config focused_locked_border_color     "$focused_locked_border_color"
bspc config active_locked_border_color      "$active_locked_border_color"
bspc config normal_locked_border_color      "$normal_locked_border_color"
bspc config focused_sticky_border_color     "$focused_sticky_border_color"
bspc config active_sticky_border_color      "$active_sticky_border_color"
bspc config normal_sticky_border_color      "$normal_sticky_border_color"
bspc config focused_private_border_color    "$focused_private_border_color"
bspc config active_private_border_color     "$active_private_border_color"
bspc config normal_private_border_color     "$normal_private_border_color"

