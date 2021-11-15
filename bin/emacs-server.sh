#! /bin/bash

export WM_RUNNING="emacs"

if [ "${theme_name}" = "day" ]; then
  theme="doom-gruvbox-light"
fi


emacs --daemon -bg "#000000" -fg "#ffffff" -mm --debug-init
