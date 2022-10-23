#!/bin/bash

display_manager.sh -o "HDMI-A-0 DisplayPort-0"
display_manager.sh -p "HDMI-A-0"

#display_manager.sh -r "HDMI-2" "left"

systemd --user

#exec dbus-launch --exit-with-session bspwm
exec bspwm
