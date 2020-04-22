#!/bin/bash

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

set_indicator() {
    echo "" > $HOME/.config/indicators/play_radio.ind
}

remove_indicator() {
    process=$(pgrep mpv)
    if [ -z "${process}" ]
    then
        rm $HOME/.config/indicators/play_radio.ind
    fi
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
    remove_indicator
    killall mpv
    killall play_radio.sh
    #castnow --quiet --command s --exit&
}

add_playlist(){
    result=$(xclip -o)
    echo ${result} >> $HOME/.config/tmp/yt_pl.ps
}

play_playlist(){
    notify-send -u normal "Playing PL" "Playing the playlist saved."
    set_indicator
    file_ps=$HOME/.config/tmp/yt_pl.ps
    while read line
    do
        notify-send -u low "Playing..." "$line"
        mpv "${line}" --no-video --shuffle
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

    local chosen_p=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the player:")

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
    set_indicator
    notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
    result=$(xclip -o)
    mpv "$result" --no-video --shuffle
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    remove_indicator
    exit
}

PL_ITENS=$(wc -l "${HOME}"/.config/tmp/yt_pl.ps | awk '{print $1}')

chosen_mode=$(printf "Local\\nStop\\nClipboard\\nClipboard Audio\\nClipboard quality\\nAdd PL\\nPlay PL" | dmenu "$@" -i -p "Where to play? ($PL_ITENS)")

case "$chosen_mode" in
    "Local") radio_file="$HOME/.config/play_radio/config";;
    "Clipboard") play_clipboard;;
    "Clipboard quality") play_clipboard_quality;;
    "Clipboard Audio") play_clipboard_audio;;
    "Add PL") add_playlist;;
    "Play PL") play_playlist;;
    "Stop") $(stop_all);;
    *) exit;;
esac

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

chosen=$(printf "$choosen_opts" | dmenu "$@" -i -p "Choose radio")

if [ -z "$chosen" ]
then
    exit 0
fi

url="${radios[$chosen]}"

case "$chosen_mode" in
    "Local") play_local;;
    "Cast") castnow $url;;
esac
