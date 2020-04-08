#!/bin/sh
play_local(){
    if [[ $url == *"pls"* ]]; then
        mpv -playlist $url&
    else
        mpv $url&
    fi
}

play_cast(){
    castnow --quiet $url&
}

stop_all(){
    killall mpv&
    #castnow --quiet --command s --exit&
}

play_clipboard(){
    result=$(xclip -o)
    mpv "$result"
    exit
}

play_clipboard_low_quality(){
    result=$(xclip -o)
    mpv "$result" --ytdl-format=18
    exit
}

play_clipboard_audio(){
    result=$(xclip -o)
    mpv "$result" --no-video
    exit
}

chosen_mode=$(printf "Local\\nCast\\nStop\\nClipboard\\nClipboard Audio\\nClipboard Low quality" | dmenu "$@" -i -p "Where to play?")

case "$chosen_mode" in
    "Local") radio_file="$HOME/.config/play_radio/config";;
    "Cast") radio_file="$HOME/.config/play_radio/config.cast";;
    "Clipboard") play_clipboard;;
    "Clipboard Low quality") play_clipboard_low_quality;;
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
    "Local") $(play_local)&;;
    "Cast") castnow $url&;;
esac
