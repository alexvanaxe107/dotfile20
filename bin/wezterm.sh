#!/usr/bin/env bash

###### Wrapper so wezterm can understand the env variables

source $HOME/.config/bspwm/themes/bsp.cfg

#env -u WAYLAND_DISPLAY wezterm &
env wezterm &
