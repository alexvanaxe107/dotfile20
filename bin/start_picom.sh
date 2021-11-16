#!/bin/dash

mode=$1

if [ -z ${mode} ]; then
    picom --experimental-backends -b >> /tmp/picom.log 2>&1 &
elif [ "${mode}" = "emacs" ]; then
    picom --config $HOME/.config/picom/picom-emacs.conf  >> /tmp/picom.log 2>&1 &
fi
#picom
