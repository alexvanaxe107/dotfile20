#!/usr/bin/env bash

# This file exists because nix somehow call dust with the full path.
# So we can't killall

kill -9 $(ps aux | grep -E "[/]bin/dunst" | awk '{print $2}')
