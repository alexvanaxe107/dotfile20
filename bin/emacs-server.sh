#! /usr/bin/env bash
iswmmode="$1"

if [ -z "${iswmmode}" ]; then
  emacs --daemon -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
else
  emacs --daemon -bg "#000000" -fg "#ffffff" -mm --debug-init
fi
#exec dbus-launch --exit-with-session emacsclient -c
