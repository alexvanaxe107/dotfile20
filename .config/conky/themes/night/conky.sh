#!/bin/sh

pid=$(pidof conky)
if [ -z "$pid" ]
then
        conky -d --config ~/.config/conky/clock.conf
        conky -d --config ~/.config/conky/calendar.conf
        conky -d --config ~/.config/conky/process.conf
    else
        killall conky

fi
