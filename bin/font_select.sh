#! /bin/dash


# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

CHOSEN=$(printf "Day Original\\nNight Original\\nImpressive\\nElegant\\nElite\\nWestern\\n80s\\nSpaceShip\\nOld Terminal\\nProgramming\\nSoft\\nBook\\nCursive" | dmenu -i -p "Change the font: ")

if [ -z "${CHOSEN}" ]; then
    exit
fi

# Source the theme
#. ${HOME}/.config/bspwm/themes/bsp.cfg

font() {
    font_name=$1
    style=$2
    size1=$3
    size2=$4
    size3=$5
    space=$6

    sed -i "s/font-0.*/font-0 = ${font_name}:style=${style}:pixelsize=${size1};${space}/" ${HOME}/.config/polybar/config
    sed -i "s/font-0.*/font-0 = ${font_name}:style=${style}:pixelsize=${size1}/" ${HOME}/.config/polybar/config_simple
    sed -i "s/-fn \".*\"/-fn \"${font_name}:style=${style}:size=${size2}\"/" ${HOME}/.config/bspwm/themes/bsp.cfg

    for file in ${HOME}/.config/conky/*.conf; do
        sed -i "s/font=.*/font='${font_name}:size=${size3}',/" ${file}
    done

    update=$(printf "Yes\nNo" | dmenu -i -p "Update Font?")

    if [ "${update}" = "Yes" ]; then
        cp ${HOME}/.config/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty_bkp_font.yml 
        sed -i "s/family:.*/family: ${font_name}/" ${HOME}/.config/alacritty/alacritty.yml
        sed -i "s/#size:.*/size: ${size3}/" ${HOME}/.config/alacritty/alacritty.yml
    else
        cp ${HOME}/.config/alacritty/alacritty_bkp_font.yml ${HOME}/.config/alacritty/alacritty.yml 
    fi
    
}

case $CHOSEN in
    "Day Original") font "Erica Type" Bold 9 10 12 0;;
    "Night Original") font "Iceland" Regular 12 12 15 0;;
    "Old Terminal") font "VT323" Regular 11 11 13 1;;
    "Elite") font "Special Elite" Bold 10 10 12 2;;
    "Elegant") font "Unica One" Regular 9 10 12 1;;
    "Impressive") font "Yeseva One" Bold 9 10 11 0;;
    "Programming") font "Fira Code" Bold 9 10 11 0;;
    "Cursive") font "Z003" "Medium Italic" 12 11 12 1;;
    "Soft") font "Fantasque Sans Mono" Regular 10 11 12 1;;
    "80s") font "Audiowide" Regular 9 9 11 1;;
    "SpaceShip") font "Orbitron" Regular 9 9 11 1;;
    "Western") font "Graduate" Regular 9 9 11 1;;
    "Book") font "Merchant Copy Double Size" Regular 8 9 11 2;;
    *) font "${CHOSEN}" Bold 9 10 11 0;;
esac
