#! /bin/bash

export WM_RUNNING="emacs"

if [ "${theme_name}" = "day" ]; then
  theme="doom-gruvbox-light"
fi


exec dbus-launch --exit-with-session emacs --daemon -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el 

# emacs -bg "#000000" -fg "#ffffff" --execute "(with-eval-after-load 'doom-themes (load-theme 'doom-city-lights t))"
