#! /bin/dash


# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

CHOSEN=$(printf "Day Original\\nNight Original\\nWasteland\\nElegant\\nElegant2\\nStock\\nRock\\nWar\\nMinimalist\\nNature\\nModern\\nComputer\\nFuturistic\\nWestern\\n80s\\nNeon\\nCyberpunk\\nPixel\\nOld Terminal\\nProgramming\\nSoft\\nBook\\nCursive\\nCartoon\\nCute\\nClear\\nSpace\\nNoir\\nRussian\\nGothic\\nSteamPunk\nNM-Comix zone\nNM-80s ScyFi\nNM-Japan\nNM-Watedland\nNM-Terminator\nNM-Space\nNM-Celtic\nNM-Soft\\nNM-Softer" | dmenu -i -y 16 -bw 2 -z 550 -l 35 -p "Change the font: ")

if [ -z "${CHOSEN}" ]; then
    exit
fi

NOT_MONO=$(echo $CHOSEN | cut -d '-' -f 1)
    

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
    if [ ${NOT_MONO} != "NM" ]; then
        sed -i "s/font-1.*/font-1 = ${font_name}:style=${style}:pixelsize=${size1};${space}/" ${HOME}/.config/polybar/config
        sed -i "s/font-1.*/font-1 = ${font_name}:style=${style}:pixelsize=${size1}/" ${HOME}/.config/polybar/config_simple
    fi

    #Change the dmenu font
    sed -i "s/DMENU_FN.*/DMENU_FN=\"${font_name}:style=${style}:size=${size2}\"/" ${HOME}/.config/bspwm/themes/bsp.cfg

    #Change the dunst font
    sed -i "s/font =.*/font = ${font_name},${style} ${size1}/" ${HOME}/.config/dunst/dunstrc

    #Change the twmn font
    sed -i "s/font=.*/font=${font_name}/" ${HOME}/.config/twmn/twmn.conf
    sed -i "s/font_size=.*/font_size=${size3}/" ${HOME}/.config/twmn/twmn.conf

    #Change the tint font

    if [ ${NOT_MONO} != "NM" ]; then
        sed -i "s/font = Pomodoro.*/zont = Pomodoro 10/" ${HOME}/.config/tint2/tint2rc
        sed -i "s/font =.*/font = ${font_name} ${style} ${size1}/" ${HOME}/.config/tint2/tint2rc
        sed -i "s/zont = Pomodoro.*/font = Pomodoro 10/" ${HOME}/.config/tint2/tint2rc
    fi

    #Change the lock screen font
    sed -i "s/FONT=.*/FONT=\"${font_name}\":pixelsize=$(($size3+7))/" ${HOME}/bin/imports/lock.sh
    

    #Change the conk font
    for file in ${HOME}/.config/conky/*.conf; do
        if [ ${NOT_MONO} != "NM" ]; then
            sed -i "s/font=.*/font='${font_name}:${style}:size=${size3}',/" ${file}
        fi
        sed -i "s/TITLEFONT/${font_name}/g" ${file}
    done

    update=$(printf "Yes\nNo" | dmenu -i -y 16 -bw 2 -z 550 -p "Update terminal font? (ESC go to default)")

    if [ "${update}" = "Yes" ]; then
        sed -i "s/family:.*/family: ${font_name}/" ${HOME}/.config/alacritty/alacritty.yml
        sed -i "s/#size:.*/size: ${size3}/" ${HOME}/.config/alacritty/alacritty.yml
    fi
    if [ -z "${update}" ]; then
        cp ${HOME}/.config/alacritty/alacritty.${theme_name} ${HOME}/.config/alacritty/alacritty.yml 
    fi

    sed -i "s/font-default:.*/font-default: \"${font_name} ${style} ${size1}\";/" ${HOME}/.config/rofi/bspwm.rasi

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
    "Night Original") font "Iceland" Regular 11 11 12 0;;
    "Old Terminal") font "VT323" Regular 12 12 19 1;;
    "Minimalist") font "Nouveau IBM Stretch" Bold 12 12 15 2;;
    "Clear") font "TeX Gyre Cursor" Bold 9 9 11 1;;
    "Nature") font "CQ Mono" Bold 10 10 12 1;;
    "Modern")  font "Audimat Mono" Regular 10 10 12 1;;
    "Russian") font "Iosevka" "Bold" 10 10 13 1;;
    "Futuristic") font "Larabiefont Rg" Bold 9 9 9 2;;
    "Elegant") font "Unica One" Regular 10 10 12 1;;
    "Elegant2") font "NovaMono" Normal 9 9 12 2;;
    "Neon") font "Segment14" Regular 9 9 10 1;;
    "Rock") font "Targa MS" Regular 9 9 12 2;;
    "War") font "American Stencil" Regular 9 9 12 1;;
    "Programming") font "Roboto Mono" Bold 8 8 12 1;;
    "Cursive") font "Z003" "Medium Italic" 13 12 15 2;;
    "Soft") font "mononoki" Regular 9 9 12 2;;
    "80s") font "Press Start 2P" Regular 6 6 9 2;;
    "Cyberpunk") font "Braciola MS" "Regular Rg" 9 9 12 1;;
    "Pixel") font "Repetition Scrolling" Regular 9 10 13 1;;
    "Western") font "Graduate" Regular 9 9 11 1;;
    "Book") font "Kingthings Trypewriter 2" Regular 9 9 11 1;;
    "Stock") font "Share Tech Mono" Bold 9 9 13 1;;
    "Wasteland") font "Beccaria" Bold 11 11 13 1;;
    "Cartoon") font "Pointfree" Bold 8 8 10 1;;
    "Cute") font "Overpass Mono" Bold 9 9 12 0;;
    "Space") font "Unispace" Bold 8 8 10 2;;
    "Noir") font "Syne Mono" Regular 10 10 11 1;;
    "Computer") font "Terminus \(TTF\)" Bold 10 10 13 2;;
    "Gothic") font "NanumGothicCoding" Bold 10 10 12 1;;
    "SteamPunk") font "Roboto Condensed" Semibold 10 10 11;;
    "NM-Comix zone") font "Bangers" Bold 11 11 12 0;;
    "NM-80s ScyFi") font "Audiowide" Bold 9 9 12 0;;
    "NM-Japan") font "Shojumaru" Bold 9 9 11 0;;
    "NM-Watedland") font "Special Elite" Bold 11 11 12 0;;
    "NM-Terminator") font "01 DigitMono" Bold 9 9 12 0;;
    "NM-Celtic") font "A.D. MONO" Bold 12 12 12 0;;
    "NM-Space") font "Orbitron" Bold 9 9 10 0;;
    "NM-Soft") font "Texturina" Bold 10 10 10 0;;
    "NM-Softer") font "Lerton" Regular 10 10 13 2;;
    "teste") font "Major Mono Display" Regular 9 9 11 1;;
    *) font "${CHOSEN}" Bold 9 10 11 0;;
esac
