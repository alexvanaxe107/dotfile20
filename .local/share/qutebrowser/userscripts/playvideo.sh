#!/bin/bash

URL="$1"

if [ -z "$URL" ]; then
    URL="$QUTE_URL"
fi

if [ -z "$URL" ]; then
    URL="$VIMB_URI"
fi

play_radio.sh -p "${URL}"
