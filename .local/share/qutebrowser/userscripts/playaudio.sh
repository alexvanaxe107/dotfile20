#!/bin/bash
URL=$(echo "$QUTE_URL" | sed "s/\&.*//")

play_radio.sh -a "${URL}"

