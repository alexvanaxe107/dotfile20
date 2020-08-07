#!/bin/sh

pid=$(pidof conky)
if [ -z "$pid" ]
then
        conky -d --config ~/.config/conky/fortune.conf
        conky -d --config ~/.config/conky/cpu.conf
        conky -d --config ~/.config/conky/process.conf
        conky -d --config ~/.config/conky/calendar.conf
    else
        killall conky

fi
