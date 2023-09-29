#!/usr/bin/env bash

mode=$1
extra_configs=$2

if [[ "${mode}" != "emacs" ]]; then
    echo "Starting normal"
    picom $2 -b >> /tmp/picom.log 3>&1 &
elif [ "${mode}" == "emacs" ]; then
    echo "Starting emacs"
    isrunning="$(ps aux | grep -E "[p]icom.*config.*emacs")"
    if [ -z "${isrunning}" ]; then
        picom $2 --config $HOME/.config/picom/picom-emacs.conf -b  >> /tmp/picom.log 2>&1 &
    fi
fi
#picom
