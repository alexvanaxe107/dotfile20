#!/bin/sh

file=$(printf "config\nsxhkd\nbspwm\nradio\nconfig\nzshrc\nvim\nfish\nfonts" | dmenu -p "Select file to edit")

case $file in
    "config") alacritty -e $EDITOR $0;;
    "sxhkd") alacritty -e $EDITOR $HOME/.config/sxhkd/sxhkdrc;;
    "bspwm") alacritty -e $EDITOR $HOME/.config/bspwm/bspwmrc;;
    "radio") alacritty -e $EDITOR $HOME/.config/play_radio/config /home/alexvanaxe/.config/play_radio/config.cast;;
    "config") alacritty -e $EDITOR $HOME/bin/configshortcut.sh;;
    "zshrc") alacritty -e $EDITOR $HOME/.zshrc;;
    "vim") alacritty -e $EDITOR $HOME/.vim/configs;;
    "fish") alacritty -e $EDITOR $HOME/.config/fish/config.fish;;
    "fonts") alacritty -e $EDITOR $HOME/bin/font_select.sh;;
esac

