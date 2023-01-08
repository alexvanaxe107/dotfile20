#!/bin/bash

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

source $HOME/.config/wm/bspwm.conf

TMP_LOCATION=$HOME/.config/tmp
LAST_PLAYED_FILE="${TMP_LOCATION}/last_played"
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"

INDICATOR_FILE=$HOME/.config/indicators/play_radio.ind

PLAYLIST_FILE=$HOME/Documents/Dropbox/stuffs/wm/yt_pl.txt
PLAYLIST_FILE_BKP=$HOME/.config/tmp/yt_pl_bkp.ps

PLAY_BKP=$HOME/.config/tmp/play_bkp

only_sound="0"
cast="0"
exclude="0"

show_help() {
    echo "Enjoy a good music on your stylish desktop and many more!"
    echo "-r [n]           Play a radio of yout selection."
    echo "-l               Get the list of the available radios."
    echo "-L               List the stored itens on playlist"
    echo "-p [url]         Play the video supplied."
    echo "-P               Play the from your clipboard."
    echo "-a [url]         Play only the audio of the supplied video. (deprecated)"
    echo "-A               Play only the audio from your clipboard.(deprecated)"
    echo "-q [item]        Queue an item to be played later."
    echo "-Q               Play the queue [Depecrated]"
    echo "-F               Play the queue(Fila)"
    echo "-x               Delete and play the selected playlist file."
    echo "-S               Stop all"
    echo "-s               Flag to play only the sound"
    echo "-c               Resume the saved"
    echo "-C               Cast to chromecase beta"
    echo "-h               This help message."
}

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
    url="$1"
    notify-send -u normal  "Playing..." "Playing your radio now. Enjoy! =)"

    if [ "$cast" = "1" ]; then
        cast.sh "$url"
        exit 0
    fi

    set_indicator
    #if [ $url = *"pls"* ]; then
        #echo "mpv -playlist=$url" > ${PLAY_BKP};
        #mpv -playlist=$url
    #else
    echo "mpv --shuffle $url" > ${PLAY_BKP};
    mpv --shuffle "$url"
    #fi

    notify-send -u normal  "Finished" "Media stoped. Bye."
    remove_indicator
    exit 0
}

stop_all(){
    killall mpv
    sleep 1
    remove_indicator
    killall play_radio.sh
    #castnow --quiet --command s --exit&
}

stop_one(){
    pro_sel=$(ps aux | grep -E '[m]pv' | awk '{print $2,$12}' | dmenu -p "Stop what?" -l 10)
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
        result=$(xclip -o -sel clipboard)
    fi

    if [ -z "${secondcmd}" ];then
        secondcmd=$(printf "" | dmenu -p "Bookmark Comment:")
    fi

    echo  "${secondcmd},${result}" >> ${PLAYLIST_FILE}
    notify-send -u normal  "${secondcmd}" "Added ${result} to play later"
}

list_playlist() {
    cat "${PLAYLIST_FILE}" | nl
}

play_playlist_f(){
    index=$1
    if [ -z "${index}" ]; then
        chosen=$(cat "${PLAYLIST_FILE}" | awk '{print NR,$1,$2}' FS="," | dmenu -p "Choose an item from playlist:" -i -l 50)
        index=$(echo $chosen | awk '{print $1}')
    fi

    if [ -z "${index}" ];then
        notify-send -u normal "Bye" "Nothing selected. Exiting."
        exit 0
    fi
    notify-send -u normal "Playing PL" "Playing the playlist saved."
    set_indicator

    url=$(cat ${PLAYLIST_FILE} | awk -v IND=${index} 'NR==IND {print $2}' FS=",")

    if [ "${exclude}" = "1" ]; then
        sed -i "${index}d" ${PLAYLIST_FILE}
    fi
    echo "${url}"
    play "${url}"
    remove_indicator
    notify-send -u normal "End PL" "The playlist has come to the end."
}

play_playlist(){
    notify-send -u normal "Playing PL" "Playing the playlist saved."
    set_indicator
    file_ps=${PLAYLIST_FILE}
    cp ${PLAYLIST_FILE} ${PLAYLIST_FILE_BKP}
    while read line
    do
        url=$(echo ${line} | awk  '{print $2}' FS=",")
        echo "$url"
        play "$url"

#        sed -i '1d' $file_ps    #Dont exclude the file now
    done < $file_ps
    remove_indicator
    notify-send -u normal "End PL" "The playlist has come to the end."
}

play_quality(){
    set_indicator
    
    result=$1

    if [ -z "${result}" ]; then
        result="$(xclip -o -sel clipboard)"
    fi

    local option="$(yt-dlp --list-formats "${result}" | sed -n '8,$p')"

    local chosen_p=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the video quality:")
    local chosen_p_audio=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the audio quality:")

    local choosen_quality=$(echo ${chosen_p} | awk '{print $1}')
    local choosen_audio_quality=$(echo ${chosen_p_audio} | awk '{print $1}')

    if [ -z "${choosen_quality}" ]; then
        notify-send -u normal  "Your choice" "None choice was made. Exiting"
        remove_indicator
        exit 0
    fi
    if [ ! -z "${choosen_audio_quality}" ]; then
        choosen_quality="${choosen_quality}+${choosen_audio_quality}"
    fi

    notify-send -u normal  "Trying to play" "The media will be played soon... wait a little and enjoy."

    echo "mpv \"$result\" --ytdl-format=${choosen_quality}" > ${PLAY_BKP};
    mpv "$result" --ytdl-format=${choosen_quality}

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

play(){
    result=$1

    if [ -z "${result}" ]; then
        result="$(xclip -o -sel clipboard)"
    fi

    is_spotify=$(grep -o spotify <<< "${result}")

    if [ ! -z "${is_spotify}" ];then
        notify-send -u normal  "Trying to play..." "Playing a spotify link."
        spotify --uri="${result}" &
        exit 0
    fi

    if [ "${only_sound}" = "1" ]; then
        notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
        set_indicator
        if [ "${cast}" = "0" ]; then
            echo "mpv --no-video $result" > ${PLAY_BKP};
            mpv --no-video "$result"
        else
            cast.sh "$result"
        fi
    else
        notify-send -u normal  "Trying to play..." "Playing your media now the best way we can. Enjoy."
        set_indicator
        if [ "${cast}" = "0" ]; then
            echo "mpv $result" > ${PLAY_BKP};
            mpv "$result"
        else
            cast.sh "$result"
        fi

    fi

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
}

play_audio(){
    notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
    set_indicator
    result=$1

    if [ -z "${result}" ]; then
        result="$(xclip -o -sel clipboard)"
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
    if [ "${only_sound}" = "1" ]; then
        echo "mpv --no-video ${url}" > ${PLAY_BKP};
        mpv --no-video "$url"
    else
        echo "mpv ${url}" > ${PLAY_BKP};
        mpv "$url"
    fi

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
        chosen=$(cat $HOME/.config/play_radio/config | awk '{print NR,$1}' FS="," | dmenu -p "Choose a radio:" -i -l 50)
        index=$(echo $chosen | awk '{print $1}')
    else
        index=$chosen
    fi

    if [ -z "${index}" ]; then
        notify-send -u normal  "Done" "No radio selected"
        exit 0
    fi

    radio_url=$(cat $HOME/.config/play_radio/config | awk -v IND=${index} 'NR==IND {print $2}' FS=",")

    play_local "${radio_url}"
}

pl_len() {
    pl_len=$(wc -l "${PLAYLIST_FILE}" | awk '{print $1}')
    echo $pl_len
}

clear_playlist() {
    $(rm ${PLAYLIST_FILE})
}

list_radio() {
    cat $HOME/.config/play_radio/config | nl 
}

play_cast() {
    cast=1
    echo "Playing $1    Cast - $cast"
    play_radio "$1"
}

command=$1
secondcmd=$3

while getopts "hsmxlr:Pp:Aa:q:QcCSRFLo:" opt; do
    case "$opt" in
        h) command="param"; show_help;;
        s) only_sound="1";;
        x) exclude="1";;
        C) cast="1";;
        m) command="param"; chosen_mode="$2"; option=$3;;
        r) command="param"; chosen_mode="Radio"; option=$OPTARG;;
        P) command="param"; chosen_mode="Play";;
        p) command="param"; chosen_mode="Play"; option=$OPTARG;;
        o) command="param"; chosen_mode="Play Quality"; option=$OPTARG;;
        A) command="param"; chosen_mode="Play Audio";;
        a) command="param"; chosen_mode="Play Audio"; option=$OPTARG;;
        Q) command="param"; chosen_mode="PP";;
        F) command="param"; chosen_mode="Play PL";;
        q) command="param"; chosen_mode="+PL"; option=$OPTARG;;
        c) command="param"; chosen_mode="Resume";;
        R) command="param"; chosen_mode="replay";;
        S) command="param"; chosen_mode="stopall";;
        l) command="param"; chosen_mode="list";;
        L) command="param"; chosen_mode="list_playlist";;
    esac
done

if [ "$command" != "param" ]
then
    chosen_mode=$(printf "Radio\\nPlay\\nPlay Audio\\nPlay Quality\\n+PL\\nPlay PL\\nResume\\nCast" | dmenu -i -p "How to play? ($(pl_len))")
fi

case "$chosen_mode" in
    "Cast") play_cast "$option";;
    "Radio") play_radio "$option";;
    "Play") play "$option";;
    "Play Quality") play_quality "$option";;
    "Play Audio") play_audio "$option";;
    "+PL") add_playlist "$option";;
    "PP") play_playlist;;
    "Play PL") play_playlist_f "$2";;
    "Stop") $(stop_one);;
    "stopall") $(stop_all);;
    "Resume") resume;;
    "clear") clear_playlist;;
    "replay") replay;;
    "play") play_local "$option";;
    "list") list_radio;;
    "list_playlist") list_playlist "$2";;
    *) exit;;
esac

