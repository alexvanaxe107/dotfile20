#!/usr/bin/env sh

# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

ara_file=$(dirname $(readlink -f $(which ara)))/../usr/share/fortune/ara/arafortune

if [  "shabbat" = "$theme_name" ]; then
    fortune $ara_file
else
    fortune
fi
