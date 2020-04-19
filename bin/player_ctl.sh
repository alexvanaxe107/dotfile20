#!/bin/bash

players=($(playerctl -a metadata 2> /dev/null | awk '!seen[$1] {print $1} {++seen[$1]}'))

players_len=${#players[@]}

function go_to_position() {
    time=$1
   
    goto=$(echo "${time}" | bc)
    playerctl position "${goto}"
}


if [ $players_len -gt 1 ]; then
    chosen_p=$(basename -a ${players[@]} | dmenu "$@" -i -p "Select the player:")

    if [ ! -z $chosen_p ]; then
        position=$(echo "$(playerctl position) / 60" | bc)
        chosen=$(printf "pause ⏸\\nplay ▶\\nforward ▶▶\\nback ◀◀" | dmenu "$@" -i -p "${position}Min:$(playerctl -p $chosen_p metadata artist) - $(playerctl -p $chosen_p metadata title)}")

        case "$chosen" in
            "pause ⏸") playerctl -p $chosen_p pause;;
            "play ▶") playerctl -p $chosen_p play;;
            "forward ▶▶") playerctl -p $chosen_p next;;
            "back ◀◀") playerctl -p $chosen_p previous;;
            *) go_to_position ${chosen};;
        esac
    fi


else
    position=$(echo "$(playerctl position) / 60" | bc)
    chosen=$(printf "pause ⏸\\nplay ▶\\nforward ▶▶\\nback ◀◀" | dmenu "$@" -i -p "${position}Min: $(playerctl metadata artist) - $(playerctl metadata title)")

    case "$chosen" in
        "pause ⏸") playerctl pause;;
        "play ▶") playerctl play;;
        "forward ▶▶") playerctl next;;
        "back ◀◀") playerctl previous;;
        *) go_to_position ${chosen};;
    esac
fi

