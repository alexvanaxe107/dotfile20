#!/bin/bash

set_wallpaper()
{ 
    rm ${WALLPAPER_PATH}
    while read n; do

        local is_wide="$(monitors_info.sh -w "$n")"
        local is_rotated="$(monitors_info.sh -r "$n")"

	count="$(monitors_info.sh -ib "$n")"

        if [ "${is_wide}" = "yes" ]; then
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/ultra/$theme_name
        elif [ "${is_rotated}" = "yes" ]; then
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/rotated/$theme_name
        else
            nitrogen --head=$count --save --set-scaled --random $HOME/Documents/Pictures/Wallpapers/$theme_name
        fi
    done <<< "$(monitors_info.sh -m)"
}

set_wallpaper
