#!/bin/dash

mode=$1

if [ -z ${mode} ]; then
    picom --experimental-backends -b >> /tmp/picom.log 2>&1 &
elif [ "${mode}" = "emacs" ]; then
    isrunning="$(ps aux | grep -E "[p]icom.*config.*emacs")"
    if [ -z "${isrunning}" ]; then
        picom --experimental-backends --config $HOME/.config/picom/picom-emacs.conf -b  >> /tmp/picom.log 2>&1 &
    fi
fi
#picom
