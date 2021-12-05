#!/bin/bash

URL="$QUTE_URL"

if [ -z "$URL" ]; then
    URL="$VIMB_URI"
fi

echo $URL

play_radio.sh -p "${URL}"
