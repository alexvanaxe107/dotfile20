#!/bin/dash

pomodoro_status="$(pomodoro status -f '%r')"

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

if [ "${pomodoro_status}" = "0:00" ]; then
    pomodoro finish
    speach.sh -t "Its time to take a breake now, go for a walk and drink some water."
fi

status="$(pomodoro status -f '%!r⏱  %c%!g🍅')"
if [ ! -z "${status}" ]; then
    printf "%s" "${status}" 
else
    echo ""
fi
