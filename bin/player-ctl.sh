#!/bin/bash

TMP_LOCATION=$HOME/.config/tmp
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"

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

save() {
    player="$1"
    player=$(echo $player | awk '{print $1}')
    yt_link=$(playerctl -p "${player}" metadata xesam:url)
    position=$(playerctl -p ${player} position)

    video_rash=$(playerctl -p ${player} metadata xesam:url | grep -Eo '[a-zA-Z0-9_-]{11}')

    if [ ! -z ${video_rash} ]; then
        echo "https://youtu.be/${video_rash}?t=${position}" > ${LAST_LOCATION_PLAYED}
    else
        yt_link=$(playerctl -p "${player}" metadata xesam:url)
        echo "${yt_link}" > ${LAST_LOCATION_PLAYED}
    fi

    if [ "$chosen_p" = "chromecast" ]; then
        if [[ -f "${INDICATOR_CAST_FILE}" ]]; then
            cast.sh -t
        fi
    fi

    notify-send -u normal  "Saved" "Location saved"
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

uncast(){
    local yt_info=$(cast.sh -i)
    local video_id=$(awk '{printf $3}' FS="|" <<< "${yt_info}")
    local video_rash=$(awk '{printf $1}' FS="|" <<< "${yt_info}")

    if [ "${video_id}" = "x-youtube/video" ]; then
        local video_position=$(awk '{printf $2}' FS="|" <<< "${yt_info}")

        play_radio.sh -p "https://youtu.be/${video_rash}?t=${video_position}"&
        cast.sh -S
    else
        play_radio.sh -p "${video_rash}"&
        cast.sh -S
    fi
}

show_help() {
    echo "Control the player cool version."
    echo "-s                         Stop the selected play"
    echo "-p                         Play or Pause the player"
    echo "-i                         Invert the audio/video"
    echo "-u                         Cast the video"
    echo "-S                         Save the video to watch later"
}

rcommand=""
option=""
while getopts "h?vpsi:uS" opt; do
    case "${opt}" in
    h|\?) show_help ;;
    v) rcommand="v" ;;
    p) rcommand="p";;
    s) rcommand="s";;
    S) rcommand="S";;
    i) rcommand="i";option=${OPTARG};;
    u) rcommand="u";;
    esac
done

shift $((OPTIND-1))

case "${rcommand}" in
    "v") get_titles;;
    "p") play_pause "$1";;
    "s") stop_selected "$1";;
    "i") invert "$1";;
    "S") save "$1";;
    "u") uncast;;
esac
