#!/bin/sh

chosen=$(todo.sh -p | head -n -2 | dmenu -y 16 -bw 2 -z 750  -l 20 -i -p "add: ")

number=$(printf "$chosen" | awk '{print $1}')

re='^[0-9]+$'

if  [ $(echo "$number" | grep -E $re) ]; then
    chosen_sel=$(printf ""| dmenu -y 16 -bw 2 -p "Leave blank to done or A-Z to pri or - to depri: ($chosen)")
    if [ -z "$chosen_sel" ] ; then
        $(todo.sh do $number > /dev/null 2>&1)
        notify-send -u normal "Task done" "$chosen"
    elif [ "$chosen_sel" = "-" ]; then
        $(todo.sh depri $number $chosen_sel > /dev/null 2>&1)
        notify-send -u normal "Task depriorized" "$chosen"
    else
        $(todo.sh pri $number $chosen_sel > /dev/null 2>&1)
        notify-send -u normal "Task priorized" "$chosen"
    fi
else
    if [ ! -z "$chosen" ]; then
        $(todo.sh add $chosen > /dev/null 2>&1)
        notify-send -u normal "Task added" "$chosen"
    fi
fi
