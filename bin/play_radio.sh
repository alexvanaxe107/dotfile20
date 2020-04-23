#!/bin/bash

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

source ~/.config/bspwm/themes/bsp.cfg

TMP_LOCATION=$HOME/.config/tmp
LAST_PLAYED_FILE="${TMP_LOCATION}/last_played"
LAST_LOCATION_PLAYED="${TMP_LOCATION}/last_location_played"

INDICATOR_FILE=$HOME/.config/indicators/play_radio.ind

PLAYLIST_FILE=$HOME/.config/tmp/yt_pl.ps
PLAYLIST_FILE_BKP=$HOME/.config/tmp/yt_pl_bkp.ps

set_indicator() {
    echo "" > ${INDICATOR_FILE}
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

save_location() {
    yt_link=$(ps aux | grep -E '[y]ou' | awk '{print $12}' | sed 's/\?t.*//g') # Search the playing yt video and format it
    save_last_played $yt_link
    position=$(playerctl position)
    last_played="$(cat $LAST_PLAYED_FILE)?t=${position}"
    echo $last_played > $LAST_LOCATION_PLAYED
    sed -i 's/www.youtube.com.watch.v\=/youtu.be\//g' $LAST_LOCATION_PLAYED
    notify-send -u normal  "Saved" "Location saved"
}

play_local () {
    notify-send -u normal  "Playing..." "Playing your radio now. Enjoy! =)"
    set_indicator

    if [ $url = *"pls"* ]; then
        mpv -playlist=$url
    else
        mpv $url
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
    remove_indicator
    killall play_radio.sh
    #castnow --quiet --command s --exit&
}

add_playlist(){
    result=$(xclip -o)
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

play_clipboard(){
    notify-send -u normal  "Trying to play..." "Playing your media now the best way we can. Enjoy."
    set_indicator

    result=$(xclip -o)
    mpv "$result"

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

play_clipboard_quality(){
    set_indicator
    result=$(xclip -o)
    local option="$(youtube-dl --list-formats "${result}" | sed -n '6,$p')"

    local chosen_p=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the quality:")

    local choosen_quality=$(echo ${chosen_p} | awk '{print $1}')

    if [ -z "${choosen_quality}" ]; then
        notify-send -u normal  "Your choice" "None choice was made. Exiting"
        remove_indicator
        exit 0
    fi

    notify-send -u normal  "Trying to play" "The media will be played soon... wait a little and enjoy."

    mpv "$result" --ytdl-format=${choosen_quality}

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

play_clipboard_audio(){
    notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
    set_indicator
    result=$(xclip -o)
    mpv "$result" --no-video --shuffle
    remove_indicator
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    exit
}

resume() {
    notify-send -u normal  "Trying to resume..." "Trying to resume the last played media where it stoped..."
    set_indicator

    url=$(cat $LAST_LOCATION_PLAYED)
    mpv "$url"

    remove_indicator
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    exit
}

play_radio() {
    radio_file="$HOME/.config/play_radio/config"
    if [ -z "$radio_file" ]
    then
        exit
    fi

    choosen_opts=""

    declare -A radios

    while IFS= read -r line
    do
        radio_name=$(echo $line | awk 'BEGIN {FS=","}; {print $1}')
        radio_url=$(echo $line | awk 'BEGIN {FS=","}; {print $2}')

        radios[$radio_name]=$radio_url

        choosen_opts="$choosen_opts$radio_name\\n"

    done < $radio_file

    chosen=$(printf "$choosen_opts" | dmenu -i -p "Choose radio")

    if [ -z "$chosen" ]
    then
        exit 0
    fi

    url="${radios[$chosen]}"

    play_local
}

pl_len() {
    pl_len=$(wc -l "${HOME}"/.config/tmp/yt_pl.ps | awk '{print $1}')
    echo $pl_len
}

clear_playlist() {
    $(rm ${PLAYLIST_FILE})
}

chosen_mode=$(printf "Local\\nClipboard\\nClipboard Audio\\nClipboard quality\\n+PL\\nPlay PL\\nSave\\nResume\\nStop" | dmenu -i -p "How to play? ($(pl_len))")

case "$chosen_mode" in
    "Local") play_radio;;
    "Clipboard") play_clipboard;;
    "Clipboard quality") play_clipboard_quality;;
    "Clipboard Audio") play_clipboard_audio;;
    "+PL") add_playlist;;
    "Play PL") play_playlist;;
    "Stop") $(stop_all);;
    "Save") save_location;;
    "Resume") resume;;
    "clear") clear_playlist;;
    *) exit;;
esac

