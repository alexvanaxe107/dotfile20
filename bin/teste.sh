#!/usr/bin/env bash

if [ -z "$(xrandr)" ]; then
    echo "Sem xrandr"
else
    echo "Com xrandr"
fi
