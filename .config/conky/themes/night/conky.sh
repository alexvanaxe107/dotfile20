#!/bin/sh

monitor=$(monitors_info.sh -if | awk 'NR==2')

pid=$(pidof conky)
if [ -z "$pid" ]
then
        conky -d -m ${monitor} --config ~/.config/conky/clock.conf
        conky -d -m ${monitor} --config ~/.config/conky/calendar.conf
        conky -d -m ${monitor} --config ~/.config/conky/process.conf
    else
        killall conky

fi
