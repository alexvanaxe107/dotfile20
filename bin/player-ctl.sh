#!/bin/bash

get_titles(){
    for player in $(playerctl -l | awk '!seen[$1] {print $1} {++seen[$1]}'); do
        teste="$(playerctl -p "$player" metadata title 2> /dev/null | awk -v player=$player '{print player,$0}' OFS=" - ")"
	
        if [[ ! -z $teste ]]; then
            printf "%s\n" "$teste"
        fi
    done
}

play_pause() {
    chosen_p=$1
    chosen_p=$(echo $chosen_p | awk '{print $1}') 
    playerctl -p ${chosen_p} play-pause
}

stop_selected() {
    chosen_p=$1
    chosen_p=$(echo $chosen_p | awk '{print $1}') 
    playerctl -p ${chosen_p} stop
}

invert() {
    player=$1
    asaudio=${option}

    yt_link=$(playerctl -p "${player}" metadata xesam:url)
    position=$(playerctl -p ${player} position)
    
    video_rash=$(playerctl -p ${player} metadata xesam:url | grep -Eo '[a-zA-Z0-9_-]{11}')
    
    if [ ! -z "${video_rash}" ]; then
        if [ "${asaudio}" = "1" ]; then
            playerctl -p $player stop;
            play_radio.sh -sp "https://youtu.be/${video_rash}?t=${position}"&
        else
            playerctl -p $player stop;
            play_radio.sh -p "https://youtu.be/${video_rash}?t=${position}"&
        fi
    else
        yt_link=$(playerctl -p "${player}" metadata xesam:url)

        if [ "${asaudio}" = "1" ]; then
            playerctl -p $player stop;
            play_radio.sh -sp "${yt_link}"&
        else
            playerctl -p $player stop;
            play_radio.sh -p "${yt_link}"&
        fi
    fi

}

show_help() {
    echo "Control the player cool version."
    echo "-s                         Configure to change in xrandr instead of the monitor"
    echo "-p                         Play or Pause the player"
    echo "-i                         Invert the audio/video"
}

rcommand=""
option=""
while getopts "h?vpsi:" opt; do
    case "${opt}" in
        h|\?) show_help ;;
	v) rcommand="v" ;;
	p) rcommand="p";;
	s) rcommand="s";;
	i) rcommand="i";option=${OPTARG};;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "v") get_titles;;
    "p") play_pause "$1";;
    "s") stop_selected "$1";;
    "i") invert "$1";;
esac
