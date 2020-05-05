#!/bin/sh

file=$(printf "sxhkd\nbspwm\nradio\nconfig\nzshrc\nvim" | dmenu -p "Select file to edit")

case $file in
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config /home/alexvanaxe/.config/play_radio/config.cast;;
    "config") alacritty -e $EDITOR $HOME/bin/configshortcut.sh;;
    "zshrc") alacritty -e $EDITOR $HOME/.zshrc;;
    "vim") alacritty -e $EDITOR $HOME/.vim/configs;;
esac

