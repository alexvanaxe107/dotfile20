#!/bin/bash

players=($(playerctl -l | awk '!seen[$1] {print $1} {++seen[$1]}'))

players_len=${#players[@]}

function go_to_position() {
    time=$1
   
    goto=$(echo "${time}" | bc)
    playerctl position "${goto}"
}

adjust_volume(){
  player=$1

  volume=$(printf "0\n0.5\n1" | dmenu -i -p "Volume (0.0 - 1.0)")

  if [ -z $player ]; then
      playerctl volume $volume 
  else
      playerctl -p $player volume $volume 
  fi
}

if [ $players_len -gt 1 ]; then
    chosen_p=$(basename -a ${players[@]} | dmenu -i -p "Select the player:")

    if [ ! -z $chosen_p ]; then
        position=$(echo "$(playerctl -p ${chosen_p} position) / 60" | bc)
        chosen=$(printf "pause ⏸\\nplay ▶\\nforward ▶▶\\nback ◀◀\\nstop \\nvolume " | dmenu -i -p "${position}Min:$(playerctl -p $chosen_p metadata artist) - $(playerctl -p $chosen_p metadata title)}")

        case "$chosen" in
            "pause ⏸") playerctl -p $chosen_p pause;;
            "play ▶") playerctl -p $chosen_p play;;
            "forward ▶▶") playerctl -p $chosen_p next;;
            "back ◀◀") playerctl -p $chosen_p previous;;
            "stop ") playerctl -p $chosen_p stop;;
            "volume ") adjust_volume $chosen_p;;
            *) go_to_position ${chosen};;
        esac
    fi
else
    position=$(echo "$(playerctl position) / 60" | bc)
    chosen=$(printf "pause ⏸\\nplay ▶\\nforward ▶▶\\nback ◀◀\\nstop \\nvolume " | dmenu -i -p "${position}Min: $(playerctl metadata artist) - $(playerctl metadata title)")

    case "$chosen" in
        "pause ⏸") playerctl pause;;
        "play ▶") playerctl play;;
        "forward ▶▶") playerctl next;;
        "back ◀◀") playerctl previous;;
        "stop ") playerctl stop;;
        "volume ") adjust_volume "";;
        *) go_to_position ${chosen};;
    esac
fi
