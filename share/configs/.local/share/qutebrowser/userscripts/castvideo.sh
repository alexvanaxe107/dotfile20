#!/usr/bin/env bash

URL="$QUTE_URL"

notify-send "Now playing" "$QUTE_URL"

cast.sh "${URL}"
