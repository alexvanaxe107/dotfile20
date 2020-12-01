#! /bin/dash

# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

if [  "shabbat" = "$theme_name" ]; then
    fortune ara | fold -w 90
else
    fortune -n 70
fi
