#!/bin/bash

display_manager.sh -o "HDMI-1 DP-1"
display_manager.sh -p "HDMI-1"
#display_manager.sh -r "HDMI-2" "left"

systemd --user

#exec dbus-launch --exit-with-session bspwm
exec bspwm
