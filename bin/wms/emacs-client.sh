#! /bin/bash

export WM_RUNNING="emacs"
$HOME/bin/saver.sh &
display_manager.sh -o "HDMI1 eDP1"
display_manager.sh -p "HDMI1"
start_picom.sh "emacs"

exec dbus-launch emacsclient -c
