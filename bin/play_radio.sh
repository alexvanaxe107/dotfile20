#!/bin/bash

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

TMP_LOCATION=$HOME/.config/tmp
LAST_PLAYED_FILE="${TMP_LOCATION}/last_played"
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"

INDICATOR_FILE=$HOME/.config/indicators/play_radio.ind

PLAYLIST_FILE=$HOME/.config/tmp/yt_pl.ps
PLAYLIST_FILE_BKP=$HOME/.config/tmp/yt_pl_bkp.ps

PLAY_BKP=$HOME/.config/tmp/play_bkp

set_indicator() {
    echo "蓼" > ${INDICATOR_FILE}
}

remove_indicator() {
    process=$(pgrep mpv)
    if [ -z "${process}" ]
    then
        rm ${INDICATOR_FILE}
    fi
}

save_last_played() {
    echo "$1" > $LAST_PLAYED_FILE
}

play_local () {
    url=$1
    notify-send -u normal  "Playing..." "Playing your radio now. Enjoy! =)"
    set_indicator

    if [ $url = *"pls"* ]; then
        echo "mpv -playlist=$url" > ${PLAY_BKP};
        mpv -playlist=$url
    else
        echo "mpv $url --no-video" > ${PLAY_BKP};
        mpv $url --no-video
    fi

    notify-send -u normal  "Finished" "Media stoped. Bye."
    remove_indicator
    exit
}

play_cast(){
    castnow --quiet $url&
}

stop_all(){
    killall mpv
    sleep 1
    remove_indicator
    killall play_radio.sh
    #castnow --quiet --command s --exit&
}

stop_one(){
    pro_sel=$(ps aux | grep -E '[m]pv' | awk '{print $2,$12}' | dmenu -l 10)
    pro_pid=$(echo ${pro_sel} | awk '{print $1}')

    kill -9 ${pro_pid}

    exists=$(pidof -s mpv)

    if [ -z "${exists}" ]; then
        remove_indicator
        killall play_radio.sh
    fi
}

add_playlist(){
    result=$1
    if [ -z "${result}" ]
    then
        result=$(clipster -o)
    fi

    echo ${result} >> ${PLAYLIST_FILE}
    notify-send -u normal  "Added" "Added ${result} to play later"
}

play_playlist(){
    notify-send -u normal "Playing PL" "Playing the playlist saved."
    set_indicator
    file_ps=${PLAYLIST_FILE}
    cp ${PLAYLIST_FILE} ${PLAYLIST_FILE_BKP}
    while read line
    do
        notify-send -u low "Playing..." "$line"
        mpv "${line}"
        sed -i '1d' $file_ps 
    done < $file_ps
    remove_indicator
    notify-send -u normal "End PL" "The playlist has come to the end."
}

play(){
    notify-send -u normal  "Trying to play..." "Playing your media now the best way we can. Enjoy."
    set_indicator
    result=$1

    if [ -z "${result}" ]; then
        result="$(clipster -o)"
    fi

    echo "mpv $result" > ${PLAY_BKP};
    mpv "$result"

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

play_quality(){
    set_indicator
    
    result=$1

    if [ -z "${result}" ]; then
        result="$(clipster -o)"
    fi

    local option="$(youtube-dl --list-formats "${result}" | sed -n '6,$p')"

    local chosen_p=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the quality:")

    local choosen_quality=$(echo ${chosen_p} | awk '{print $1}')

    if [ -z "${choosen_quality}" ]; then
        notify-send -u normal  "Your choice" "None choice was made. Exiting"
        remove_indicator
        exit 0
    fi

    notify-send -u normal  "Trying to play" "The media will be played soon... wait a little and enjoy."

    echo "mpv \"$result\" --ytdl-format=${choosen_quality}" > ${PLAY_BKP};
    mpv "$result" --ytdl-format=${choosen_quality}

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

play_audio(){
    notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
    set_indicator
    result=$1

    if [ -z "${result}" ]; then
        result="$(clipster -o)"
    fi
    echo "mpv \"$result\" --no-video --shuffle" > ${PLAY_BKP};
    mpv "$result" --no-video --shuffle
    remove_indicator
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    exit
}

resume() {
    notify-send -u normal  "Trying to resume..." "Trying to resume the last played media where it stoped..."
    set_indicator

    url=$(cat $LAST_LOCATION_PLAYED)
    echo "mpv ${url}" > ${PLAY_BKP};
    mpv "$url"

    remove_indicator
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    exit
}

replay() {
    notify-send -u normal  "Trying to replay last played..." "Trying to replay the last played media..."
    set_indicator

    cmd=$(cat $PLAY_BKP)
    eval $cmd

    remove_indicator
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    exit
}

play_radio() {
    chosen=$1

    if [ -z "$chosen" ]
    then
        chosen=$(cat $HOME/.config/play_radio/config | awk '{print NR,$1}' FS="," | dmenu -p "Choose a radio:" -i -l 20)
        index=$(echo $chosen | awk '{print $1}')
    else
        index=$(cat $HOME/.config/play_radio/config | nl | grep ${chosen} | awk '{print $1}')
    fi

    echo "SAIDA"
    echo $index

    if [ -z "${index}" ]; then
        notify-send -u normal  "Done" "No radio selected"
        exit 0
    fi

    radio_url=$(cat $HOME/.config/play_radio/config | awk -v IND=${index} 'NR==IND {print $2}' FS=",")

    play_local "${radio_url}"
}

pl_len() {
    pl_len=$(wc -l "${HOME}"/.config/tmp/yt_pl.ps | awk '{print $1}')
    echo $pl_len
}

clear_playlist() {
    $(rm ${PLAYLIST_FILE})
}

list_radio() {
    cat $HOME/.config/play_radio/config | nl
}

command=$1

if [ "$command" != "-m" ]
then
    chosen_mode=$(printf "Radio\\nPlay\\nPlay Audio\\nPlay Quality\\n+PL\\nPlay PL\\nResume\\nStop" | dmenu -i -p "How to play? ($(pl_len))")
else
    chosen_mode=$2
    option=$3
fi

case "$chosen_mode" in
    "Radio") play_radio "$option";;
    "Play") play "$option";;
    "Play Quality") play_quality "$option";;
    "Play Audio") play_audio "$option";;
    "+PL") add_playlist "$option";;
    "Play PL") play_playlist;;
    "Stop") $(stop_one);;
    "stopall") $(stop_all);;
    "Resume") resume;;
    "clear") clear_playlist;;
    "replay") replay;;
    "play") play_local "$option";;
    "list") list_radio;;
    *) exit;;
esac

