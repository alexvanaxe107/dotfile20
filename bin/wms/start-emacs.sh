#! /bin/bash

export WM_RUNNING="emacs"
$HOME/.config/i3/monitor/saver.sh &
display_manager.sh -o "HDMI1 eDP1"
display_manager.sh -p "HDMI1"
start_picom.sh "emacs"

exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
