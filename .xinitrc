#!/bin/sh

# Load resources
xrdb -merge ~/.Xresources

# Reload laptop key settings
if [ -f ~/.laptop ]; then
	xmodmap ~/.Xmodmap
fi

# Set the brightness of the screen
xbacklight -set 50

DEFAULTSESSION=dwm
case "$1" in
	"gnome" | "xfce4" | "lxde" | "awesome" | "dwm" ) SESSION=$1 ;;
	*) SESSION="$DEFAULTSESSION" ;;
esac

# Enable middle mouse button
xinput set-int-prop "ImPS/2 Generic Wheel Mouse" "Evdev Middle Button Emulation" 8 1
# Support for virtualbox
if [ -f ~/.virtualbox ]; then
	VBoxClient-all &
fi
# Stop blasting my ears... it hurts
amixer set "Master",0 50%
tmux &
# Start ze session
case "$SESSION" in
	"gnome")
		exec gnome-session
		;;
	"xfce4")
		exec startxfce4
		;;
	"lxde")
                #start-pulseaudio-x11 &
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		exec startlxde
		;;
	"awesome")
		urxvtd -q -f -o &
		# Startup programs
		# xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 -f -F -S &
                start-pulseaudio-x11 &
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		exec awesome
		;;
	"dwm")
		xscreensaver -no-splash &
		exec ~/bin/dwm
		;;

esac
