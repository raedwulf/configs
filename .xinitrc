#!/bin/sh

# Load resources
xrdb -merge ~/.Xresources

# Reload laptop key settings
if [ -f ~/.laptop ]; then
	xmodmap ~/.Xmodmap
fi

# Set the brightness of the screen
xbacklight -set 50

DEFAULTSESSION=awesome
case "$1" in
	"gnome" | "xfce4" | "lxde" | "awesome" ) SESSION=$1 ;;
	*) SESSION="awesome" ;;
esac

# Enable middle mouse button
xinput set-int-prop "ImPS/2 Generic Wheel Mouse" "Evdev Middle Button Emulation" 8 1
# Stop blasting my ears... it hurts
amixer set "Master",0 50%
# Start dvcs-autosync
if [ -f ~/.autosync ]
then
	tmux &
fi
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
	*)
		# Startup programs
		# xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 -f -F -S &
                # start-pulseaudio-x11 &
		pulseaudio --kill
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		exec awesome
		;;
esac
