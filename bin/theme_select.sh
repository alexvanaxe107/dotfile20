#!/bin/sh

chosen=$(printf "night\\nday\\nlight\\nwallpaper" | dmenu "$@" -i -p "Change the theme: ")

if [ $chosen == "wallpaper" ]; then
    chosen_font=$(printf "Original\\nSoft" | dmenu "$@" -i -p "Chose the font kind:")
fi

if [ -z "$chosen" ]; then
    exit
fi

# Try to copy the config where is the themename

if [ "wallpaper" != "$chosen" ]; then
    cp $HOME/.config/bspwm/themes/$chosen.cfg $HOME/.config/bspwm/themes/bsp.cfg
fi
source $HOME/.config/bspwm/themes/bsp.cfg

reset_configs(){
    cp $HOME/.config/bspwm/themes/$theme_name.cfg $HOME/.config/bspwm/themes/bsp.cfg
    cp $HOME/.config/polybar/themes/$theme_name $HOME/.config/polybar/config
    cp $HOME/.config/conky/themes/$theme_name/process.conf $HOME/.config/conky/process.conf
    cp $HOME/.config/conky/themes/$theme_name/cpu.conf $HOME/.config/conky/cpu.conf
    cp $HOME/.config/conky/themes/$theme_name/clock.conf $HOME/.config/conky/clock.conf
    cp $HOME/.config/conky/themes/$theme_name/fortune.conf $HOME/.config/conky/fortune.conf
}

refresh_theme() {
    source $HOME/.config/bspwm/themes/bsp.cfg
    killall picom; picom -b &
    killall dunst; dunst &
    bspc config window_gap 6
    # Start conky according theme
    killall conky

    killall polybar
    polybar default&
    sleep 1
    $HOME/.config/conky/conky.sh
    bspc config top_padding 16
}

prepare_wallpaper(){
    killall picom
    killall conky
    killall polybar
}

startup_theme(){
    echo "starting up"
    reset_configs
    if [ "light" == "$chosen" ]; then
        killall picom
        killall conky
        killall polybar
        xsetroot -solid blue
        bspc config top_padding 0
        bspc config window_gap 0  
    else
        # Set wallpaper according theme
        nitrogen --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name

        refresh_theme
    fi
}

set_color_by_walpaper() {
    # Retrieve the background path
    prepare_wallpaper
    reset_configs
    sleep 2
    
    # This function is located on bspwm themes files
    update_files
    sleep 2

    refresh_theme
}

case "$chosen" in
    "wallpaper") set_color_by_walpaper;;
    *) startup_theme;;
esac

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
    *) echo "None";;
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
