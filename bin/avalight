#!/bin/dash

# A script to use dmenu to change the light
# FOR REFERENCE: xrandr --output eDP1 --brightness 1 
GS=$(xrandr  | grep -w connected | awk 'BEGIN {printf "auto\n"} {printf "%s\n", $1} END {printf "xrandr"}' | dmenu -f -y 16 -bw 2 -z 490 -p "Monitor: (`light`)")
INDICATOR_PATH="$HOME/.config/indicators"
INDICATOR_FILE="${INDICATOR_PATH}/light.ind"

_get_soft_brigtness() {
    SOFT=$(echo $1 | awk '{print $1}')

    if [ "${SOFT}" = "s" ]; then
        BT_RETURN=$(echo $1 | awk '{print $2}')
    fi

    echo "${BT_RETURN}"
}

eDP1() {
    killall clight
    echo "" > ${INDICATOR_FILE}
    
    BT=`printf "10\n50\n100" | dmenu -f -y 16 -bw 2 -z 490 -p "Set the brightness"`

    SOFT=$(_get_soft_brigtness "$BT")

    if [ ! -z "${SOFT}" ]; then
        xrandr --output ${GS} --brightness ${SOFT}
    else
        light -S ${BT}
    fi
    notify-send -u low "Light" "Screen monitor set to $GS"
}

DP1() {
    killall clight
    echo "" > ${INDICATOR_FILE}

    BT=`printf "10\n50\n100" | dmenu -f -y 16 -bw 2 -z 490 -p "Set the brightness"`

    SOFT=$(_get_soft_brigtness "$BT")

    if [ ! -z "${SOFT}" ]; then
        xrandr --output ${GS} --brightness ${SOFT}
    else
        ddcutil setvcp -d 2 10 ${BT}
    fi
    notify-send -u low "Light" "Screen monitor set to $GS"
}

HDMI1() {
    killall clight
    echo "" > ${INDICATOR_FILE}

    BT=`printf "10\n50\n100" | dmenu -f -y 16 -bw 2 -z 490 -p "Set the brightness"`

    SOFT=$(_get_soft_brigtness "$BT")

    if [ ! -z "${SOFT}" ]; then
        xrandr --output ${GS} --brightness ${SOFT}
    else
        ddcutil setvcp -d 1 10 ${BT}
    fi
    notify-send -u low "Light" "Screen monitor set to $GS"
}

both() {
    if [ ! -z "$GS" ]; then
        killall clight
        echo "" > ${INDICATOR_FILE}

        SOFT=$(_get_soft_brigtness "$GS")

        if [ ! -z "${SOFT}" ]; then
            xrandr --output HDMI1 --brightness ${SOFT}
            xrandr --output eDP1 --brightness ${SOFT}
            xrandr --output DP1 --brightness ${SOFT}
        else
            light -S ${GS}
            ddcutil setvcp -d 1 10 ${GS}
            ddcutil setvcp -d 2 10 ${GS}
        fi

        notify-send -u low "Light" "Screen monitor set to $GS"
    fi
}

_xrandr() {
    killall clight
    echo "" > ${INDICATOR_FILE}
    
    local monitors=$(monitors_info.sh -m)

    for monitor in ${monitors}; do
        xrandr --output ${monitor} --brightness 1 
    done
    
    notify-send -u low "Light" "Xrand reseted"
}

auto() {
    killall clight
    clight&
    
    echo 🔆 > ${INDICATOR_FILE}
    notify-send -u low "Light" "Auto"
}

case "$GS" in
    "auto") auto;;
    "eDP1") eDP1;;
    "DP1") DP1;;
    "HDMI1") HDMI1;;
    "xrandr") _xrandr;;
    *) both;;
esac
