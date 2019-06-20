
if [[ $1 == "play" ]]; then
    ffmpeg -video_size 1366x768 -framerate 25 -f x11grab -i :0 -f pulse -ac 2 -i default ~/Documents/output.mkv
fi

if [[ $1 == "stop" ]]; then
    killall ffmpeg
fi
