#!/bin/bash

. $HOME/.pyenv/versions/wm/bin/activate

WALLPAPER_SCENES="Any\nCyberpunk\nFuturist\nAbstract\nCity\nLandscape\nLandscape Night\nCity Night\nCity Landscape\nscience fiction\nMinimalism\nSpace\nWar\nApocalypse\nartwork\ndigital art\nfantasy art\nnature\ntilt shift\nindoors\noutdoors\nsimple background\nwater\ndepth of field\ndark\nlight\nWLOP"

file=""

crop_imgs(){
    # Rescaling to match all monitors

    rm /tmp/tmp_*
    rm /tmp/crp_*

    crop_img "HDMI-1" "0" "West" "$direction"
    crop_img "DP-1" "1" "East" "$direction"
    #crop_rimg "DP-1" "2" "East"
    #crop_rimg "HDMI-1" "3" "West"
}

crop_img(){
    wfile=$(basename "$file")
    monitor="$1"
    index="$2"
    gravity="$3"

    direction="$(printf "Center\nSouth\nNorth\nWest\nEast\nNorthWest\nSouthWest\nNorthEast\nSouthEast\nForget\nNone" | dmenu -p "Choose the direction")"
    resize="$(printf "+0\n+100\n+200\n+300" | dmenu -p "Set the vertical deviation")"

    temp_file="/tmp/tmp_$wfile"

    rescale_dim="$(monitors_info.sh -D)x$(monitors_info.sh -d "${monitor}" | awk 'BEGIN {FS="x"}; {print $2}')"

    xvalue="$(monitors_info.sh -d "${monitor}" | awk 'BEGIN {FS="x"}; {print $1}')"
    yvalue="$(monitors_info.sh -d "${monitor}" | awk 'BEGIN {FS="x"}; {print $2}')"

    convert "$file" -filter Triangle -gravity ${direction} -resize "${rescale_dim}"^ -extent "${rescale_dim}+0${resize}" -quality 100 "${temp_file}"

    # Resize to the choosen monitor
    file_location="/tmp/crp_${index}_${wfile}"
    convert "${temp_file}" -filter Triangle -resize ${xvalue}x${yvalue}^ -gravity ${gravity} -extent "${xvalue}x${yvalue}" -quality 100 "${file_location}"
    nitrogen --head=${index} --save --set-scaled "${file_location}"
}

get_scene() {
        scene="$(printf "${WALLPAPER_SCENES}" | dmenu -i -y 16 -bw 2 -z 550 -l 20 -p "Choose the scene:")"
        if [ -z "${scene}" ];then
            exit 0
        fi

        if [ "Any" = "${scene}" ]; then
            scene=""
        fi

        echo "${scene}"
}

set_wallpaper() {
    source="$(printf "wallhaven\nusplash\nalpha" | dmenu -i -y 16 -bw 2 -z 550 -p "What is the source?" )"
    scene=$(get_scene)

    $source "$scene"
}

wallhaven(){
    scene="$1"
    monitor="$(monitors_info.sh -p)"
    path=$(python $HOME/bin/wallfinder.py -e h -m ${monitor} -s "${scene}")
    file="$path"
    $(crop_imgs)
}

alpha(){
    scene="$1"
    monitor="$(monitors_info.sh -p)"
    path=$(python $HOME/bin/wallfinder.py -e a -m ${monitor} -s "${scene}")
    file="$path"
    $(crop_imgs)
}

usplash(){
    scene="$1"
    monitor="$(monitors_info.sh -p)"
    path=$(python $HOME/bin/wallfinder.py -e u -m ${monitor} -s "${scene}")
    file="$path"
    $(crop_imgs)
}

show_help() {
    echo "Set an wallpaper in dual mode choosing from a variety of sources. (dmenu required for this version)"
    echo "-h               This help message."
    echo "-d               Download the wallpaper."
}

command_origin=$1
action=$2

while getopts "hd" opt; do
    case "$opt" in
        h) command_origin="param"; show_help;;
        d) command_origin="param"; action="set_wallpaper";;
    esac
done

shift $((OPTIND-1))

case "${action}" in
    "set_wallpaper") set_wallpaper;;
esac
