#!/bin/bash

display_manager.sh -o "DVI-1 HDMI-2"
display_manager.sh -p "DVI-1"
#display_manager.sh -r "HDMI-2" "left"

exec dbus-launch --exit-with-session bspwm
