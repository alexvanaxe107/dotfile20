#! /bin/dash


# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

CHOSEN=$(printf "Day Original\\nNight Original\\nWasteland\\nElegant\\nElegant2\\nStock\\nRock\\nWar\\nMinimalist\\nNature\\nModern\\nFuturistic\\nWestern\\n80s\\nNeon\\nCyberpunk\\nPixel\\nOld Terminal\\nProgramming\\nSoft\\nBook\\nCursive\\nCartoon\\nCute\\nClear\\nSpace\\nNoir" | dmenu -i -l 30 -p "Change the font: ")

if [ -z "${CHOSEN}" ]; then
    exit
fi

# Source the theme
. ${HOME}/.config/bspwm/themes/bsp.cfg

font() {
    font_name=$1
    style=$2
    size1=$3
    size2=$4
    size3=$5
    space=$6

    #Change the polybar
    sed -i "s/font-1.*/font-1 = ${font_name}:style=${style}:pixelsize=${size1};${space}/" ${HOME}/.config/polybar/config
    sed -i "s/font-0.*/font-0 = ${font_name}:style=${style}:pixelsize=${size1}/" ${HOME}/.config/polybar/config_simple

    #Change the dmenu font
    sed -i "s/DMENU_FN.*/DMENU_FN=\"${font_name}:style=${style}:size=${size2}\"/" ${HOME}/.config/bspwm/themes/bsp.cfg

    #Change the dunst font
    sed -i "s/font =.*/font = ${font_name},${style} ${size1}/" ${HOME}/.config/dunst/dunstrc

    #Change the twmn font
    sed -i "s/font=.*/font=${font_name}/" ${HOME}/.config/twmn/twmn.conf
    sed -i "s/font_size=.*/font_size=${size3}/" ${HOME}/.config/twmn/twmn.conf

    #Change the tint font
    sed -i "s/font = Pomodoro.*/zont = Pomodoro 10/" ${HOME}/.config/tint2/tint2rc
    sed -i "s/font =.*/font = ${font_name} ${style} ${size1}/" ${HOME}/.config/tint2/tint2rc
    sed -i "s/zont = Pomodoro.*/font = Pomodoro 10/" ${HOME}/.config/tint2/tint2rc

    #Change the lock screen font
    sed -i "s/FONT=.*/FONT=\"${font_name}\":pixelsize=$(($size3+7))/" ${HOME}/bin/imports/lock.sh
    

    for file in ${HOME}/.config/conky/*.conf; do
        sed -i "s/font=.*/font='${font_name}:size=${size3}',/" ${file}
        sed -i "s/TITLEFONT/${font_name}/g" ${file}
    done

    update=$(printf "Yes\nNo" | dmenu -i -p "Update terminal font? (ESC go to default)")

    if [ "${update}" = "Yes" ]; then
        sed -i "s/family:.*/family: ${font_name}/" ${HOME}/.config/alacritty/alacritty.yml
        sed -i "s/#size:.*/size: ${size3}/" ${HOME}/.config/alacritty/alacritty.yml
    fi
    if [ -z "${update}" ]; then
        cp ${HOME}/.config/alacritty/alacritty.${theme_name} ${HOME}/.config/alacritty/alacritty.yml 
    fi

    killall -qw dunst
    killall -qw twmnd
    if [ "${theme_name}" = "night" ]; then
        twmnd&
    else
        dunst&
    fi
    toggle_bars.sh --restart
    notify-send -u normal "${CHOSEN}" "Enjoy the ${font_name}"
}

case $CHOSEN in
    "Day Original") font "Erica Type" Bold 9 10 12 0;;
    "Night Original") font "Iceland" Regular 12 12 15 0;;
    "Old Terminal") font "VT323" Regular 12 12 17 1;;
    "Minimalist") font "Nouveau IBM Stretch" Bold 12 12 15 2;;
    "Clear") font "TeX Gyre Cursor" Bold 9 10 14 1;;
    "Nature") font "CQ Mono" Bold 12 12 15 1;;
    "Modern") font "Iosevka" "Bold Oblique" 10 10 13 1;;
    "Futuristic") font "Larabiefont Rg" Normal 10 10 12 2;;
    "Elegant") font "Unica One" Regular 10 10 12 1;;
    "Elegant2") font "NovaMono" Normal 10 10 14 1;;
    "Neon") font "Segment14" Regular 9 9 14 1;;
    "Rock") font "Targa MS" Regular 11 11 13 2;;
    "War") font "American Stencil" Regular 9 10 12 1;;
    "Programming") font "Roboto Mono" Bold 8 8 11 1;;
    "Cursive") font "Z003" "Medium Italic" 13 12 15 2;;
    "Soft") font "mononoki" Regular 11 11 14 2;;
    "80s") font "Press Start 2P" Regular 7 7 9 2;;
    "Cyberpunk") font "Braciola MS" "Regular Rg" 11 11 13 1;;
    "Pixel") font "Repetition Scrolling" Regular 9 10 13 1;;
    "Western") font "Graduate" Regular 9 9 11 1;;
    "Book") font "Kingthings Trypewriter 2" Regular 11 11 13 1;;
    "Stock") font "Share Tech Mono" Bold 11 11 16 1;;
    "Wasteland") font "Beccaria" Bold 12 12 16 1;;
    "Cartoon") font "Pointfree" Bold 9 10 13 1;;
    "Cute") font "Overpass Mono" Bold 10 10 12 0;;
    "Space") font "Space Mono" Regular 9 10 12 3;;
    "Noir") font "SyneMono-Regular" Regular 10 10 12 1;;
    *) font "${CHOSEN}" Bold 9 10 11 0;;
esac
