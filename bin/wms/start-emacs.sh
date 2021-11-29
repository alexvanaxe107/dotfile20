#! /bin/bash

export WM_RUNNING="emacs"
start_picom.sh "emacs"

exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
