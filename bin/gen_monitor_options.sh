#!/usr/bin/env bash

xrandr | grep -P "\d+x\d+" | cut --output-delimiter=":" -s -d ' ' -f 1,4 | awk '{{if ($1 != "") val=$1}; {if ($1 == "") print val "x" $2}}' FS=':' | grep "${monitor}" | awk '{printf "%sx%s 1:%0.0f\n", $2,$3,$2/$3*10}' FS=x | head -n 5 > $HOME/.config/wm/monitor_options.conf
