#!/bin/dash

pomodoro_status="$(pomodoro status -f '%r')"


if [ "${pomodoro_status}" = "0:00" ]; then
    pomodoro finish
    speach.sh -t "Its time to take a breake now, go for a walk and drink some water."
fi

pomodoro status -f '%!r⏱  %c%!g🍅'
