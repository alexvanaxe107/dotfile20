#! /bin/sh

set -o errexit

function teste() {
    local cur_wallpaper=$(cat $XDG_CONFIG_HOME/nitrogen/bg-saved.cfg | grep file | awk 'BEGIN{FS="="} NR==2 {print $2}')
    local colors_wallpaper=($(convert "${cur_wallpaper}" -format %c -depth 10  histogram:info:- | grep -o "#......" | cut -d "#" -f 2))

    if [[ ${#colors_wallpaper[@]} -lt 140 ]]; then
        echo ${#colors_wallpaper[@]}
    else
        echo "TEM MAIS"
    fi
    echo ${cur_wallpaper}
    echo ${colors_wallpaper[100]}
}

teste123=$(teste)
echo ${teste123}
