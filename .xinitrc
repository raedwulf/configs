#!/bin/sh

# Load resources
xrdb -merge ~/.Xresources

# Set the brightness of the screen
xbacklight -set 50

DEFAULTSESSION=awesome
case "$1" in
        "gnome" | "kde" | "xfce4" | "icewm" | "fluxbox" | "xmonad" | "awesome" ) SESSION=$1 ;;
        *) SESSION="awesome" ;;
esac

case "$SESSION" in
        "gnome")
                exec gnome-session
                ;;
        "kde")
                exec startkde
                ;;
        "xfce4")
                exec startxfce4
                ;;
        "icewm")
                exec icewm-session
                ;;
        "fluxbox")
                exec startfluxbox
                ;;
        "xmonad")
                exec xmonad
                ;;
        *)
		# Startup programs
		xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 -f -F -S &
		conky -d
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		urxvtc -e weescreen
                exec awesome
                ;;
esac
