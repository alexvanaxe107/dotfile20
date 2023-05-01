#!/bin/bash

if [ -f $HOME/.config/wm/xorg_local.sh ]; then
    . $HOME/.config/wm/xorg_local.sh
fi

systemd --user

#exec dbus-launch --exit-with-session bspwm
exec bspwm

