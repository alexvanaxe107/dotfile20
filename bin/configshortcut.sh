#!/bin/sh

source ~/.config/bspwm/themes/bsp.cfg
file=$(printf "config\nsxhkd\nbspwm\nradio\nconfig\nzshrc\nvim\nfish\nfonts\nwallpaper\nmonitors" | dmenu -y 16 -bw 2 -z 950 -p "Select config to edit")

process_wallpaper(){
    sxiv $HOME/Documents/Pictures/Wallpapers/$theme_name&

    ultra=$(xrandr | grep -w "HDMI1 connected" | grep -o 2560)
    
    if [ ! -z "$ultra" ] 
    then
        sxiv $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name&
    fi
}

case $file in
    "config") alacritty -e $EDITOR $0;;
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config;;
    "config") alacritty -e $EDITOR $HOME/bin/configshortcut.sh;;
    "zshrc") alacritty -e $EDITOR $HOME/.zshrc;;
    "vim") alacritty -e $EDITOR $HOME/.vim/configs;;
    "fish") alacritty -e $EDITOR $HOME/.config/fish/config.fish;;
    "fonts") alacritty -e $EDITOR $HOME/bin/font_select.sh;;
    "monitors") alacritty -e $EDITOR $HOME/.config/wm/monitors.conf;;
    "wallpaper") process_wallpaper;;
esac

