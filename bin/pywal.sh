#!/usr/bin/env bash

source $HOME/.config/wm/bspwm.conf

if [ "${wal_enabled}" == "1" ] && [ "${PY_ENABLED}" != "1" ]; then
    export PY_ENABLED="1"
    (cat ~/.cache/wal/sequences &)
fi
