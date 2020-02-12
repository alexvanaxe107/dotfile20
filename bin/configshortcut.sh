#!/bin/sh

file=$(echo -e "sxhkd\nbspwm\nradio\nconfig" | dmenu "$@" -p "Select file to edit")

case $file in
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config /home/alexvanaxe/.config/play_radio/config.cast;;
    "config") alacritty -e $EDITOR $HOME/.config;;
esac

