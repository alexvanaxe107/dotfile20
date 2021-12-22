#! /bin/bash

source $HOME/.config/wm/bspwm.conf

action=$(echo "" | dmenu -p "What do you want to do?" -bw 2 -y 16 -z 850 -theme ${rofi_item5})

if [ -z "${action}" ]; then
    exit 0
fi

search='*time*'
if [[ "$action" == $search ]]; then
    speach.sh -t "Now it is $(date +"%-H hours and %-M minutes.")"
    exit 0
fi

search='*creation*'
if [[ "$action" == $search ]]; then
    bspwm_desktop_manager.sh -t 
    exit 0
fi

search='*wallpaper*'
if [[ "$action" == $search ]]; then
    wallpaper_changer.sh 
    exit 0
fi

search='*read*'
if [[ "$action" == $search ]]; then
    command=$(echo "$action" | grep -e "read")

    query=$(echo $action | sed 's/read//g' | xargs)

    read_book.sh -b "${query}"

    exit 0
fi

search='*news*'
if [[ "$action" == $search ]]; then
    command=$(echo "$action" | grep -e "list")
    asaudio=$(echo "$action" | grep -e "as audio")
    live=$(echo "$action" | grep -e "live")
    from=$(echo "$action" | grep -e "from")

    query=""
    if [ ! -z "${from}" ]; then
        query=$(echo $action | sed 's/play//g' | sed 's/news//g' | sed 's/from//g' | sed 's/as audio//g' | sed 's/live//g' | sed 's/list//g' | xargs)
    fi

    if [ ! -z "${asaudio}" ]; then
        param="-a"
    fi
    
    if [ ! -z "${query}" ]; then
        if [ ! -z "${command}" ]; then
            param="${param} -m"
        fi

        echo "${param}"
        ytplay.sh ${param} -T "${query}"& 
        exit 0
    elif [ ! -z "${command}" ]; then
        param="${param} -l"
    elif [ ! -z "${live}" ]; then
        param="${param} -v"
    else
        param="${param} -t"
    fi

    echo "${param}"
     
    ytplay.sh ${param}& 
    exit 0
fi

search='*play*'
if [[ "$action" == $search ]]; then
    command=$(echo "${action}" | grep -e "as audio")
    if [ ! -z "${command}" ]; then
        playwhat="${command:5:-9 }"
        url=$(ytsearch.py "${playwhat}")
        play_radio.sh -a "${url}"&
        exit 0
    fi
    
    command=$(echo "${action}" | grep -e "play radio")
    
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
    url=$(ytsearch.py "${playwhat}")
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
    command=$(echo "${action}" | grep -e "start")
    if [ ! -z "${command}" ]; then
        pomodoro-client.sh -s
        exit 0
    fi

    pomot=$(pomodoro_stats.sh)
    if [ ! -z "${pomot}" ]; then
        speach.sh -t "Your current pomodoro has ${pomot} minutes left"
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

search='kb'
if [[ "$action" == $search ]]; then
    setkmap
    notify-send "Keyboard" "Keyboard reconfigured"
    exit 0
fi

search='*reset*'
if [[ "$action" == $search ]]; then
    reset_monitors.sh
    notify-send "Monitor" "Monitor reseted"
    exit 0
fi

search='*unhide*'
if [[ "$action" == $search ]]; then
    bspc_node_manager.sh -aI
    exit 0
fi


search='*mouse off*'
if [[ "$action" == $search ]]; then
    unclutter --timeout 5 -b
    exit 0
fi

search='*mouse on*'
if [[ "$action" == $search ]]; then
    killall unclutter
    exit 0
fi

search='*rofi*'
if [[ "$action" == $search ]]; then
    command=$(echo "${action}" | grep -e "off")
    if [[ -z "${command}" ]]; then
        sed -i "s/use_rofi=.*/use_rofi=1/" ${HOME}/.config/wm/bspwm.conf
    else
        sed -i "s/use_rofi=.*/use_rofi=0/" ${HOME}/.config/wm/bspwm.conf
    fi
    exit 0
fi

search='*cp*'
if [[ "$action" == $search ]]; then
    dmclipster
    exit 0
fi

notify-send "Sorry" "Sorry, could not do what you asked"
