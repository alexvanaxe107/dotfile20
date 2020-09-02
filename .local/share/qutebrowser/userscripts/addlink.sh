#!/bin/bash
URL=$(echo "$QUTE_URL" | sed "s/\&.*//")
(echo "youtube-dl --cookies ~/Downloads/cookies.txt \"$URL\"" >> ~/download.sh) || exit 0
