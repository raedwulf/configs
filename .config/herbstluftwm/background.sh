#!/bin/bash

# sets a tag defined wallpaper when tag changes
declare -A WALLPAPER

WALLPAPER=(
	# first wallpaper will be the fallback wallpaper
	[0]=background.png
	[8]=mist.png
)

herbstclient --idle tag_changed \
	| while read line ; do
		ARGS=( $line )
		TAG=${ARGS[1]}
		if ! [ -z "${WALLPAPER[$TAG]}" ] ; then
		    # there is a wallpaper for this tag
		    CUR=${WALLPAPER[$TAG]}
		else
		    # there is no wallpaper for this tag -> fall back
		    CUR=${WALLPAPER[0]}
		fi
		echo "setting wallpaper to $HOME/.config/herbstluftwm/$CUR"
		feh --bg-scale $HOME/.config/herbstluftwm/${CUR}
	done
