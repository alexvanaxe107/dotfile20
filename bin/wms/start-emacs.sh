#! /bin/bash

export WM_RUNNING="emacs"
start_picom.sh

if [ "${theme_name}" = "day" ]; then
  theme="doom-gruvbox-light"
fi


exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
