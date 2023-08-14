#!/usr/bin/env bash

THEMES=$HOME/.config/wm/tmux.opt
TMUX_CONFIG=$HOME/.config/.tmux.conf

dmenu=$(which ava_dmenu)

choosen_type=$(printf "block\ndefault\ndouble" | ${dmenu} -i -p "Choose the type")

choosen_theme=$(cat $THEMES | ${dmenu} -i -l 27 -p "Choose the tmux theme")

theme="powerline/${choosen_type}/${choosen_theme}"

if [ ! -z "$theme" ]; then
    # Using two dots as delimiter because the string theme already has slashes
    sed -ri "s:(set -g @themepack).*$:\1 \'${theme}\':" $HOME/.tmux.conf
fi
