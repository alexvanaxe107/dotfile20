#! /bin/bash

action=$(echo "" | dmenu -p "What do you want to do?")

search='*time*'
if [[ "$action" == $search ]]; then
    speach.sh -t "The time now is $(date +"%H:%M")"
    exit 0
fi

search='*wallpaper*'
if [[ "$action" == $search ]]; then
    wallpaper_changer.sh 
    exit 0
fi

search='*favorites*'
if [[ "$action" == $search ]]; then
    command=$(grep -e "list" <<<"${action}")

    if [ ! -z "${command}" ]; then
        ytplay.sh -l&
        exit 0
    fi
    ytplay.sh -t& 
    exit 0
fi

search='*play*'
if [[ "$action" == $search ]]; then
    command=$(grep -e "as audio" <<<"${action}")
    if [ ! -z "${command}" ]; then
        playwhat="${command:5:-9 }"
        url=$(ytsearch.py -s "${playwhat}")
        play_radio.sh -a "${url}"&
        exit 0
    fi
    
    command=$(grep -e "play radio" <<<"${action}")
    
    if [ ! -z "${command}" ]; then
        playwhat="${action#play radio }"
        re='^[0-9]+$'
        if [[ "$playwhat" =~ $re ]] ; then
            play_radio.sh -r ${playwhat}&
            exit 0
        else
            radio=$(play_radio.sh -l | grep -i "${playwhat}" | head -n 1 | awk '{print $1}')
            play_radio.sh -r ${radio}&
            exit 0
        fi
    fi

    playwhat="${action#play }"
    url=$(ytsearch.py -s "${playwhat}")
    play_radio.sh -p "${url}"&
    exit 0
fi

search='*music*'
if [[ "$action" == $search ]]; then
    play_radio.sh 
    exit 0
fi

search='*pomodoro*'
if [[ "$action" == $search ]]; then
    command=$(grep -e "start" <<<"${action}")
    if [ ! -z "${command}" ]; then
        pomodoro-client.sh -s
        exit 0
    fi

    pomot=$(pomodoro status -f '%r')
    if [ ! -z "${pomot}" ]; then
        speach.sh -t "There are ${pomot} minutes left"
    else
        speach.sh -t "There is no pomodoro running."
    fi
    
    exit 0
fi

search='*light*'
if [[ "$action" == $search ]]; then
    avalight
    exit 0
fi

search='*exit*'
if [[ "$action" == $search ]]; then
    bspwmexit.sh 
    exit 0
fi
