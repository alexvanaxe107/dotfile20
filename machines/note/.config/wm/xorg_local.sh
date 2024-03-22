#!/usr/bin/env bash

# Configs used for the local configuragion of the specific computer

DP="eDP-1"

xrandr --output $DP --set TearFree on

display_manager.sh -p "$DP"
