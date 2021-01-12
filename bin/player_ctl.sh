#!/bin/bash

TMP_LOCATION=$HOME/.config/tmp
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"
PLAY_BKP=$HOME/.config/tmp/play_bkp

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
    
    if [ ! -z ${video_rash} ]; then
        echo "https://youtu.be/${video_rash}?t=${position}" > ${LAST_LOCATION_PLAYED}
    else
        yt_link=$(playerctl -p "${player}" metadata xesam:url)
        echo "${yt_link}" > ${LAST_LOCATION_PLAYED} 
    fi

    notify-send -u normal  "Saved" "Location saved"
}

invert(){
    player=$1
    asaudio=$2

    yt_link=$(playerctl -p "${player}" metadata xesam:url)
    position=$(playerctl -p ${player} position)
    
    video_rash=$(playerctl -p ${player} metadata xesam:url | grep -Eo '[a-zA-Z0-9_]{11}')
    
    if [ ! -z "${video_rash}" ]; then
        if [ "${asaudio}" = "1" ]; then
            playerctl -p $player stop;
            play_radio.sh -sp "https://youtu.be/${video_rash}?t=${position}"
        else
            playerctl -p $player stop;
            play_radio.sh -p "https://youtu.be/${video_rash}?t=${position}"
        fi
    else
        yt_link=$(playerctl -p "${player}" metadata xesam:url)

        if [ "${asaudio}" = "1" ]; then
            playerctl -p $player stop;
            play_radio.sh -sp "${yt_link}"
        else
            playerctl -p $player stop;
            play_radio.sh -p "${yt_link}"
        fi
    fi
}

adjust_volume(){
  player=$1

  volume=$(printf "0\n0.5\n1" | dmenu -i -p "Volume (0.0 - 1.0)" -y 16 -bw 2 -z 350)

  if [ -z $player ]; then
      playerctl volume $volume 
  else
      playerctl -p $player volume $volume 
  fi
}

chosen_p=$(get_titles | dmenu -i -n -l 20 -p "Select the player:" -y 16 -z 950 -bw 2)
chosen_p=$(echo $chosen_p | awk '{print $1}') 


if [ ! -z $chosen_p ]; then
    position=$(echo "$(playerctl -p ${chosen_p} position) / 60" | bc)
    title=$(playerctl -p $chosen_p metadata title)
    chosen=$(printf "play ▶⏸\\nforward ▶▶\\nback ◀◀\\nstop \\nvolume " | dmenu -i -p "${position}Min:$(playerctl -p $chosen_p metadata artist) - ${title:0:30}" -y 16 -z 950 -bw 2)

    case "$chosen" in
        "play ▶⏸") playerctl -p $chosen_p play-pause;;
        "forward ▶▶") playerctl -p $chosen_p next;;
        "back ◀◀") playerctl -p $chosen_p previous;;
        "stop ") playerctl -p $chosen_p stop;;
        "volume ") adjust_volume $chosen_p;;
        "save") save $chosen_p;;
        "asvideo") invert "$chosen_p" "0";;
        "asaudio") invert "$chosen_p" "1";;
        *) go_to_position ${chosen};;
    esac
fi
