#!/usr/bin/env sh

increase_volume() {
	pactl set-sink-volume @DEFAULT_SINK@ +5%
}

decrease_volume() {
	pactl set-sink-volume @DEFAULT_SINK@ -5%
}

toggle_mute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle
}

case "$1" in
"up")
	increase_volume
	;;
"down")
	decrease_volume
	;;
"mute")
	toggle_mute
	;;
esac
