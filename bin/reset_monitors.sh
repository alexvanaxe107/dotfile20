#!/bin/dash

monitors=$(monitors_info.sh -q)

MONITOR1="terminal web coding trade"
MONITOR2="chat audio video twitter"

MONITOR="$MONITOR1 $MONITOR2"

if [ ${monitors} -ge 2 ]; then
    for desktop1 in $MONITOR1; do
        bspc desktop ${desktop1} --to-monitor ^1
    done

    count=1
    for desktop1 in $MONITOR1; do
        echo "bspc desktop ${desktop} -s ^${count}"
        bspc desktop ${desktop1} -s ^${count} 
        count=$(($count+1))
    done

    for desktop in $MONITOR2; do
        bspc desktop ${desktop} --to-monitor ^2
    done

    for desktop in $MONITOR2; do
        echo "bspc desktop ${desktop} -s ^${count}"
        bspc desktop ${desktop} -s ^${count} 
        count=$(($count+1))
    done
    bspc monitor ^1 --reset-desktops $MONITOR1
    bspc monitor ^2 --reset-desktops $MONITOR2
else
    count=1
    for desktop in $MONITOR; do
        echo "bspc desktop ${desktop} -s ^${count}"
        bspc desktop ${desktop} -s ^${count} 
        count=$(($count+1))
    done
    bspc monitor ^1 --reset-desktops $MONITOR
fi
