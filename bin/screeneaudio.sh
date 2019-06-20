
if [[ $1 == "play" ]]; then
    ffmpeg -video_size 1366x768 -thread_queue_size 512 -framerate 25 -f x11grab -i :0 -f pulse -thread_queue_size 512 -itsoffset 0.320 -ac 2 -i default ~/Documents/output.mkv
fi

if [[ $1 == "stop" ]]; then
    killall ffmpeg
fi
