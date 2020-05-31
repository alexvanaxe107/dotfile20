#! /bin/dash

LAYOUT=$1

if [ -z ${LAYOUT} ]
then
    LAYOUT=$(printf "tiled\nmonocle\neven\ntall\nwide\nremove" | dmenu -p "What layout you want?")
fi

LAYOUTS_DIR=$HOME/.config/tmp/layouts

set_tiled() {
    bsp-layout set tiled
    desktop=$(bspc query --desktops -d)
    echo "🧱" > ${LAYOUTS_DIR}/${desktop}
}

set_monocle() {
    bspc desktop --layout monocle
    desktop=$(bspc query --desktops -d)
    echo "◼" > ${LAYOUTS_DIR}/${desktop}
}

set_even() {
    bsp-layout set even
    desktop=$(bspc query --desktops -d)
    echo "ℹ" > ${LAYOUTS_DIR}/${desktop}
}

set_tall() {
    bsp-layout set tall
    desktop=$(bspc query --desktops -d)
    echo "↕" > ${LAYOUTS_DIR}/${desktop}
}

set_wide() {
    bsp-layout set wide
    desktop=$(bspc query --desktops -d)
    echo "↔" > ${LAYOUTS_DIR}/${desktop}
}

remove_layout() {
    bsp-layout remove
    bsp-layout set monocle

    desktop=$(bspc query --desktops -d)
    rm ${LAYOUTS_DIR}/${desktop}
}

get_icon() {
    desktop=$(bspc query --desktops -d)
    icon_path=${LAYOUTS_DIR}/${desktop}

    icon=$(cat ${icon_path} 2> /dev/null)

    if [ -z "$icon" ]
    then
        icon="💠"
    fi

    echo $icon
}

clear_icons() {
    rm ${LAYOUTS_DIR}/*
}

case "$LAYOUT" in
    "tiled") set_tiled;;
    "monocle") set_monocle;;
    "even") set_even;;
    "tall") set_tall;;
    "wide") set_wide;;
    "remove") remove_layout;;
    "icon") get_icon;;
    "clear") clear_icons;;
esac
