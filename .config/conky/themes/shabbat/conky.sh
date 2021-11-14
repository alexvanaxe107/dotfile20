#!/bin/sh

monitor=$(monitors_info.sh -if | awk 'NR==2')

pid=$(pidof conky)
if [ -z "$pid" ]
then
        conky -d -m ${monitor} --config ~/.config/conky/fortune.conf
        conky -d -m ${monitor} --config ~/.config/conky/cpu.conf
        conky -d -m ${monitor} --config ~/.config/conky/clock.conf
    else
        killall conky

fi
