#!/usr/bin/env bash

#DP="DisplayPort-2"
#HDMI="HDMI-A-0"


#display_manager.sh -o "$DP $HDMI"
#display_manager.sh -p "$DP"
source $HOME/.config/wm/xorg_local.sh


game="$(which $1)"
echo "starting ${game}"
