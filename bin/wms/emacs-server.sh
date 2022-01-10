#! /bin/bash

emacs --daemon -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
#exec dbus-launch --exit-with-session emacsclient -c
