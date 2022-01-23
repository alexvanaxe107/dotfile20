#!/bin/sh

monitor=$(monitors_info.sh -if | awk 'NR==2')

if [ -z "${monitor}" ]; then
    monitor=0
fi

pid=$(pidof conky)
if [ -z "$pid" ]
then
        conky -d -m ${monitor} --config ~/.config/conky/cpu.conf
        conky -d -m ${monitor} --config ~/.config/conky/process.conf
        conky -d -m ${monitor} --config ~/.config/conky/calendar.conf
    else
        killall conky
fi
