#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

synclient VertEdgeScroll=1

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --exit-with-session --sh-syntax)
fi
systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi

#if [ -f "$userresources" ]; then
xrdb -merge "$userresources"
#fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
#setxkbmap -model abnt2 -layout br -variant abnt2
setxkbmap -option grp:alt_shift_toggle -model abnt2 -layout "br,il" -variant "abnt2,"
xsetroot -cursor_name left_ptr
alias dmenu="ava_dmenu"
source ~/.profile

export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
#exec /home/alexvanaxe/bin/startdwm
#exec i3
#exec dwm
#exec bspwm
exec tdm --xstart
#exec gnome-session
#exec dbus-launch --exit-with-session emacs -bg "#000000" -fg "#ffffff" -mm --debug-init -l $HOME/.emacs.d/desktop.el
