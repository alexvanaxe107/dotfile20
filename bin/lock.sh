#!/bin/sh

. ~/.config/bspwm/themes/bsp.cfg

killall clight
background=$1
#xset s 20 20
if [ "${background}" = "-d" ]
then
    env XSECURELOCK_FONT="Iceland:pixelsize=29" XSECURELOCK_AUTH_BACKGROUND_COLOR="#162637" XSECURELOCK_PASSWORD_PROMPT=emoticon XSECURELOCK_SAVER=saver_mpv XSECURELOCK_LIST_VIDEOS_COMMAND="find ~/Videos -type l" XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_BLANK_DPMS_STATE=off xsecurelock&
    #i3lock-fancy-dualmonitor&
else
    env XSECURELOCK_FONT="Iceland:pixelsize=29" XSECURELOCK_AUTH_BACKGROUND_COLOR="#162637" XSECURELOCK_PASSWORD_PROMPT=emoticon XSECURELOCK_SAVER=saver_mpv XSECURELOCK_LIST_VIDEOS_COMMAND="find ~/Videos -type l" XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_BLANK_DPMS_STATE=off xsecurelock
    #i3lock-fancy-dualmonitor
fi
#xset s off

