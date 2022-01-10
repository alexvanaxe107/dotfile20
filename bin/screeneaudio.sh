#!/bin/sh

if [ "$1" = "play" ]; then
    mv $HOME/Documents/output.mkv $HOME/Documents/output_bkp.mkv
    echo "" > $HOME/.dwm/recording
    refbar
    ffmpeg -video_size 2560x1080 -thread_queue_size 512 -framerate 25 -f x11grab -i :0 -f pulse -thread_queue_size 512 -itsoffset 0.320 -ac 2 -i default ~/Documents/output.mkv
fi

if [ "$1" = "stop" ]; then
    echo "" > $HOME/.dwm/recording
    killall ffmpeg
    refbar
fi
