#!/usr/bin/env bash
URL=$(echo "$QUTE_URL" | sed "s/\&.*//")
(echo "youtube-dl --cookies ~/Downloads/cookies.txt \"$URL\"" | clipster) || exit 0

