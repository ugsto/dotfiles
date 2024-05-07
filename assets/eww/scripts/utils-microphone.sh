#!/usr/bin/env sh

increasevolume() {
	pactl set-source-volume @DEFAULT_SOURCE@ +5%
}

decreasevolume() {
	pactl set-source-volume @DEFAULT_SOURCE@ -5%
}

togglemute() {
	pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

case "$1" in
"up")
	increasevolume
	;;
"down")
	decreasevolume
	;;
"mute")
	togglemute
	;;
esac
