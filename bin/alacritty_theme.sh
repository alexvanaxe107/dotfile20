#!/usr/bin/env bash

# PATH=$HOME/.pyenv/versions/wm/bin/:$PATH

ALACRITTY_FILE=$HOME/.config/wm/alacritty.conf

dmenu=$(which ava_dmenu)

choosen_theme=$((printf "Theme on\nTheme off\n" && alacritty-themes -l | cut -d " " -f 2) |  ${dmenu} -i -l 27 -p "Choose the terminal theme")

choosen=$(echo $choosen_theme | cut -d '|' -f 1)

if [ "${choosen}" == "Theme on" ]; then
    alacritty-colorscheme apply theme_on.yaml
    exit
fi
if [ "${choosen}" == "Theme off" ]; then
    alacritty-colorscheme toggle
    exit
fi

if [ ! -z "$choosen" ]; then
    alacritty-themes "${choosen}"
fi
