#!/usr/bin/env bash

source $HOME/.config/wm/bspwm.conf

if [ ${wal_enabled} == "1" ]; then
    (cat ~/.cache/wal/sequences &)
fi
