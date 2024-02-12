#!/usr/bin/env bash

source $HOME/.config/wm/bspwm.conf

# If running from tmux, we don't want to enable wal (It is already enabled from 
# the bash)

is_tmux="$TMUX_PANE"

if [ "${wal_enabled}" == "1" ]; then
    if [ -z "${is_tmux}" ]; then
        (cat ~/.cache/wal/sequences &)
    fi
fi
