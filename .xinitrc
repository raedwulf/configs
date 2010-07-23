#!/bin/sh

# Load resources
xrdb -merge ~/.Xresources

# Set the brightness of the screen
xbacklight -set 50

DEFAULTSESSION=awesome
case "$1" in
	"gnome" | "xfce4" | "awesome" ) SESSION=$1 ;;
	*) SESSION="awesome" ;;
esac

case "$SESSION" in
	"gnome")
		exec gnome-session
		;;
	"xfce4")
		exec startxfce4
		;;
	*)
		# Startup programs
		xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 -f -F -S &
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		exec awesome
		;;
esac
