#!/bin/bash
URL=$1

if [ -z "$URL" ]; then
    URL=$(echo "$QUTE_URL" | sed "s/\&.*//")
fi

play_radio.sh -a "${URL}"

