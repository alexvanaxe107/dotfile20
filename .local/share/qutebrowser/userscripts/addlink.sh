#!/bin/bash
URL=$(echo "$QUTE_URL" | sed "s/\&.*//")
(echo "yt-dlp --cookies ~/Downloads/cookies.txt \"$URL\"" >> ~/download.sh) || exit 0

NUM=$(nl download.sh | tail -n 1 | awk '{print $1}')
notify-send -u normal  "Clip Added" "Added $NUM link!"
