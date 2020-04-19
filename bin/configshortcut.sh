#!/bin/sh

file=$(printf "sxhkd\nbspwm\nradio\nconfig\nzshrc\nvimb" | dmenu "$@" -p "Select file to edit")

case $file in
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config /home/alexvanaxe/.config/play_radio/config.cast;;
    "config") alacritty -e $EDITOR $HOME/bin/configshortcut.sh;;
    "zshrc") alacritty -e $EDITOR $HOME/.zshrc;;
    "vimb") alacritty -e $EDITOR $HOME/.config/vimb/config;;
esac

