#!/usr/bin/env bash

# Set colors for terminal output
export red="$(tput setaf 1)"
export green="$(tput setaf 2)"
export yellow="$(tput setaf 3)"
export blue="$(tput setaf 4)"
export magenta="$(tput setaf 5)"
export cyan="$(tput setaf 6)"
export white="$(tput setaf 7)"
export b="$(tput bold)"
export reset="$(tput sgr0)"

status="$(pomodoro-client.py status)"
if [ ! -z "${status}" ]; then
    printf "%s" "${status##Pomodoro }"
else
    echo ""
fi
