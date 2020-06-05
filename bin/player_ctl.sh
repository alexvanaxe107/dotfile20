#!/bin/sh

TMP_LOCATION=$HOME/.config/tmp
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"

get_titles(){
    for player in $(playerctl -l | awk '!seen[$1] {print $1} {++seen[$1]}'); do
        teste="$(playerctl -p "$player" metadata title 2> /dev/null | awk -v player=$player '{print player,$0}' OFS=" - ")"
        if [ ! -z $teste ]; then
            printf "%s\n" "$teste"
        fi
    done
}

IFS=$'\n'

go_to_position() {
    time=$1
   
    goto=$(echo "${time}" | bc)
    playerctl position "${goto}"
}

save() {
    player=$1
    yt_link=$(playerctl -p "${player}" metadata xesam:url)
    position=$(playerctl -p ${player} position)

    video_rash=$(playerctl -p ${player} metadata xesam:url | grep -o "v.*" | awk 'BEGIN { FS = "=" }{print $2}')
    
    echo "https://youtu.be/${video_rash}?t=${position}" > ${LAST_LOCATION_PLAYED}

    notify-send -u normal  "Saved" "Location saved"
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

chosen_p=$(get_titles | dmenu -i -n -l 20 -p "Select the player:")
chosen_p=$(echo $chosen_p | awk '{print $1}') 


if [ ! -z $chosen_p ]; then
    position=$(echo "$(playerctl -p ${chosen_p} position) / 60" | bc)
    chosen=$(printf "pause ⏸\\nplay ▶\\nforward ▶▶\\nback ◀◀\\nstop \\nvolume " | dmenu -i -p "${position}Min:$(playerctl -p $chosen_p metadata artist) - $(playerctl -p $chosen_p metadata title)")

    case "$chosen" in
        "pause ⏸") playerctl -p $chosen_p pause;;
        "play ▶") playerctl -p $chosen_p play;;
        "forward ▶▶") playerctl -p $chosen_p next;;
        "back ◀◀") playerctl -p $chosen_p previous;;
        "stop ") playerctl -p $chosen_p stop;;
        "volume ") adjust_volume $chosen_p;;
        "save") save $chosen_p;;
        *) go_to_position ${chosen};;
    esac
fi
