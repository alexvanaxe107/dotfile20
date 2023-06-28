#!/usr/bin/env sh

. ~/.config/bspwm/themes/bsp.cfg

source $HOME/bin/imports/lock.sh

killall clight
background=$1
#xset s 20 20
if [ "${background}" = "-d" ]
then
    env XSECURELOCK_FONT="${FONT}" XSECURELOCK_AUTH_BACKGROUND_COLOR="#162637" XSECURELOCK_PASSWORD_PROMPT=emoticon XSECURELOCK_SAVER=${SAVER} XSECURELOCK_LIST_VIDEOS_COMMAND="find ~/Videos -type l" XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_BLANK_DPMS_STATE=off XSECURELOCK_DISCARD_FIRST_KEYPRESS=0 xsecurelock&
    #i3lock-fancy-dualmonitor&
    #betterlockscreen -l&
else
    env XSECURELOCK_FONT="${FONT}" XSECURELOCK_AUTH_BACKGROUND_COLOR="#162637" XSECURELOCK_PASSWORD_PROMPT=cursor XSECURELOCK_SAVER=${SAVER} XSECURELOCK_LIST_VIDEOS_COMMAND="find ~/Videos -type l" XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_BLANK_DPMS_STATE=off XSECURELOCK_DISCARD_FIRST_KEYPRESS=0 xsecurelock
    #i3lock-fancy-dualmonitor
    #betterlockscreen -l --off 5
fi
#xset s off

