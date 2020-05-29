#! /bin/dash


# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

CHOSEN=$(printf "Day Original\\nNight Original\\nWasteland\\nElegant\\nElegant2\\nStock\\nWar\\nMinimalist\\nModern\\nFuturistic\\nWestern\\n80s\\nNeon\\nCyberpunk\\nPixel\\nOld Terminal\\nProgramming\\nSoft\\nBook\\nCursive\\nCartoon\\nDelirium" | dmenu -i -l 22 -p "Change the font: ")

if [ -z "${CHOSEN}" ]; then
    exit
fi

# Source the theme
. ${HOME}/.config/theme_name

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
    sed -i "s/font =.*/font = ${font_name},${style} ${size1}/" ${HOME}/.config/dunst/dunstrc

    for file in ${HOME}/.config/conky/*.conf; do
        sed -i "s/font=.*/font='${font_name}:size=${size3}',/" ${file}
    done

    update=$(printf "Yes\nNo" | dmenu -i -p "Update terminal font? (ESC go to default)")

    if [ "${update}" = "Yes" ]; then
        sed -i "s/family:.*/family: ${font_name}/" ${HOME}/.config/alacritty/alacritty.yml
        sed -i "s/#size:.*/size: ${size3}/" ${HOME}/.config/alacritty/alacritty.yml
    fi
    if [ -z "${update}" ]; then
        cp ${HOME}/.config/alacritty/alacritty.${theme_name} ${HOME}/.config/alacritty/alacritty.yml 
    fi

    killall dunst
    dunst&
    toggle_bars.sh --restart
    notify-send -u normal "${CHOSEN}" "Enjoy the ${font_name}"
}

case $CHOSEN in
    "Day Original") font "Erica Type" Bold 9 10 12 0;;
    "Night Original") font "Iceland" Regular 12 12 15 0;;
    "Old Terminal") font "VT323" Regular 11 11 14 1;;
    "Minimalist") font "Nouveau IBM Stretch" Bold 9 10 14 0;;
    "Modern") font "CQ Mono" Bold 9 10 12 1;;
    "Futuristic") font "minim" Normal 8 8 10 1;;
    "Elegant") font "Unica One" Regular 9 10 12 1;;
    "Elegant2") font "NovaMono" Normal 9 9 12 1;;
    "Neon") font "Segment14" Regular 9 9 14 1;;
    "War") font "American Stencil" Regular 9 10 12 1;;
    "Programming") font "Roboto Mono" Bold 10 10 11 1;;
    "Cursive") font "Z003" "Medium Italic" 12 11 14 1;;
    "Soft") font "mononoki" Regular 10 10 12 1;;
    "80s") font "Press Start 2P" Regular 8 8 10 2;;
    "Cyberpunk") font "Terminus (TTF)" "Bold Italic" 10 10 14 2;;
    "Pixel") font "Small Pixel7" Regular 11 11 14 1;;
    "Western") font "Graduate" Regular 9 9 11 1;;
    "Book") font "Kingthings Trypewriter 2" Regular 10 11 14 1;;
    "Stock") font "SVI Basic Manual" Bold 10 11 14 1;;
    "Wasteland") font "Beccaria" Bold 11 12 14 1;;
    "Cartoon") font "Pointfree" Bold 9 10 11 1;;
    "Delirium") font "A.D. MONO" Bold 11 11 13 2;;
    *) font "${CHOSEN}" Bold 9 10 11 0;;
esac
