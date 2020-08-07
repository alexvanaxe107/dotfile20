#!/bin/sh

#set -o errexit
# Exit on error inside any functions or subshells.
#set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
#set -o pipefail

radio=$(cat $HOME/.config/indicators/play_radio.ind 2> /dev/null)
light=$(cat $HOME/.config/indicators/light.ind 2> /dev/null)

desktop=$(bspwm_layout_manager.sh icon)

indicator="$desktop$radio$light"

printf $indicator
