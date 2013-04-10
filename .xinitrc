#!/bin/sh

# Load resources
xrdb -merge ~/.Xresources

# Reload laptop keyboard settings
if [ -f ~/.laptop ]; then
	setxkbmap gb
	xmodmap ~/.Xmodmap
	xinput set-int-prop "ImPS/2 Generic Wheel Mouse" "Evdev Middle Button Emulation" 8 1
fi

# Start pulse audio
start-pulseaudio-x11 &

# Set the brightness of the screen
xbacklight -set 50

# Keyboard layout
setxkbmap gb

DEFAULTSESSION=herbstluftwm
case "$1" in
	"gnome" | "xfce4" | "lxde" | "awesome" | "herbstluftwm" ) SESSION=$1 ;;
	*) SESSION="$DEFAULTSESSION" ;;
esac

# Support for virtualbox
if [ -f ~/.virtualbox ]; then
	VBoxClient-all &
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
	"awesome")
		urxvtd -q -f -o &
		# Startup programs
		# xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 -f -F -S &
		urxvtd -q -f -o &
		xscreensaver -no-splash &
		exec awesome
		;;
	"dwm")
		xscreensaver -no-splash &
		exec ~/bin/dwm
		;;
	"herbstluftwm")
		xscreensaver -no-splash &
		exec herbstluftwm
		;;
esac
