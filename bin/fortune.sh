#! /bin/dash

# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

if [  "shabbat" = "$theme_name" ]; then
    fortune ara | fold -s -w 80
else
    fortune -s
fi
