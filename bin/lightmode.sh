#!/usr/bin/env bash

# If animations are on, turn it off

force="$1"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
if [[ "$HYPRGAMEMODE" = 1 || "$force" == 1 ]] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 3;\
        keyword decoration:rounding 0"
    exit
fi
hyprctl reload
