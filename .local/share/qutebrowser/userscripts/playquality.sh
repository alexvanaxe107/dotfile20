#!/usr/bin/env bash
URL=$(echo "$QUTE_URL" | sed "s/\&.*//")

play_radio.sh -m "Play Quality" "${URL}"
