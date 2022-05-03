#!/bin/bash

is_bspc=$(bspc wm --get-status)

if [[ ! -z "$is_bspc" ]]; then
    echo "is bspc"
else
    echo "no, it is not bspc"
fi
