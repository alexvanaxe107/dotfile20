#!/bin/sh

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
#set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

function play_local(){
    notify-send -u normal  "Playing..." "Playing your radio now. Enjoy! =)"
    echo "" > $HOME/.config/indicators/play_radio.ind

    if [[ $url == *"pls"* ]]; then
        mpv -playlist=$url
    else
        mpv $url
    fi

    notify-send -u normal  "Finished" "Media stoped. Bye."
    rm $HOME/.config/indicators/play_radio.ind
    exit
}

function play_cast(){
    castnow --quiet $url&
}

function stop_all(){
    killall mpv
    #castnow --quiet --command s --exit&
}

function play_clipboard(){
    echo "" > $HOME/.config/indicators/play_radio.ind
    notify-send -u normal  "Trying to play..." "Playing your media now the best way we can. Enjoy."

    result=$(xclip -o)
    mpv "$result"

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    rm $HOME/.config/indicators/play_radio.ind
    exit
}

function play_clipboard_quality(){
    echo "" > $HOME/.config/indicators/play_radio.ind
    result=$(xclip -o)
    local option="$(youtube-dl --list-formats "${result}" | sed -n '6,$p')"

    local chosen_p=$(basename -a "${option}" | dmenu  -l 10 -i -p "Select the player:")

    local choosen_quality=$(awk '{print $1}' <<< ${chosen_p})

    if [[ -z "${choosen_quality}" ]]; then
        notify-send -u normal  "Your choice" "None choice was made. Exiting"
        rm $HOME/.config/indicators/play_radio.ind
        exit 0
    fi

    notify-send -u normal  "Trying to play" "The media will be played soon... wait a little and enjoy."

    mpv "$result" --ytdl-format=${choosen_quality}

    notify-send -u normal  "Done" "Hopefully your media was played =/"
    rm $HOME/.config/indicators/play_radio.ind
    exit
}

function play_clipboard_audio(){
    echo "" > $HOME/.config/indicators/play_radio.ind
    notify-send -u normal  "Trying to play..." "Playing your media as audio now the best way we can. Enjoy."
    result=$(xclip -o)
    mpv "$result" --no-video --shuffle
    notify-send -u normal  "Done" "Hopefully your media was played =/"
    rm $HOME/.config/indicators/play_radio.ind
    exit
}


chosen_mode=$(printf "Local\\nCast\\nStop\\nClipboard\\nClipboard Audio\\nClipboard quality" | dmenu "$@" -i -p "Where to play?")

case "$chosen_mode" in
    "Local") radio_file="$HOME/.config/play_radio/config";;
    "Cast") radio_file="$HOME/.config/play_radio/config.cast";;
    "Clipboard") play_clipboard;;
    "Clipboard quality") play_clipboard_quality;;
    "Clipboard Audio") play_clipboard_audio;;
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
