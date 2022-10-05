#! /bin/bash

export WM_RUNNING="emacs"
$HOME/.config/i3/monitor/saver.sh &
display_manager.sh -o "HDMI-1 DP-1"
display_manager.sh -p "HDMI-1"
display_manager.sh -r "HDMI-1" "left"
start_picom.sh "emacs"

#exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
