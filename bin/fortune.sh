#!/usr/bin/env sh

# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

ara_file=/nix/store/jn5sj8mf9wsllamzyvbcv4rqf3w44cd3-ava-bible-1.0/usr/share/fortune/ara/arafortune

if [  "shabbat" = "$theme_name" ]; then
    fortune $ara_file
else
    fortune
fi
