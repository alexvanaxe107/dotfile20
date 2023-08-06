#!/bin/sh

source $HOME/.config/wm/bspwm.conf

if [ "${use_rofi}" = 1 ]; then
    chosen=$(printf "⏽\n⏾\n⭘\n⏻\n" | ava_dmenu -i -p "Power:" -theme ${rofi_item2})
else
    chosen=$(printf "Turnoff monitor\nSleep\nRestart\nPoweroff\nHibernate" | ava_dmenu -i -p "Power:")
fi

confirmation() {
    if [ "${use_rofi}" = 1 ]; then
        confirm="$(printf "No\nYes" | ava_dmenu -i -p "Power off?" -nb darkred -sb red -sf white -nf gray -theme ${rofi_item2} )"
    else
        confirm="$(printf "No\nYes" | ava_dmenu -i -p "Power off?" -nb darkred -sb red -sf white -nf gray )"
    fi
    echo "$confirm"
}

poweroff() { \
    confirm="$(confirmation)"
	if [ "Yes" = "$confirm" ]
	then
		systemctl poweroff
	fi
}

chibernate() { \
    confirm="$(confirmation)"
	if [ "Yes" = "$confirm" ]
	then
		lock.sh -d
        sleep 10
		systemctl hibernate
	fi
}

monitor() { \
	sleep 1 && xset dpms force off
}

csuspend() { \
	lock.sh -d
    sleep 10
	systemctl suspend -i
}

crestart() { \
    confirm="$(confirmation)"
	if [ "Yes" = "$confirm" ]
	then
		systemctl reboot
	fi
}

case "$chosen" in
	"Turnoff monitor") monitor ;;
	"⏽") monitor ;;
	"Sleep") csuspend ;;
	"⏾") csuspend ;;
	"Restart") crestart ;;
	"⭘") crestart ;;
	"Poweroff") poweroff ;;
	"⏻") poweroff ;;
	"Hibernate") chibernate ;;
	"") chibernate ;;
esac
