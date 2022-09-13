#!/bin/bash

#display_manager.sh -o "HDMI1 eDP1"
#display_manager.sh -p "HDMI1"
#display_manager.sh -r "HDMI-2" "left"

systemd --user

exec dbus-launch --exit-with-session bspwm
