#!/usr/bin/env sh

confirm() {
	zenity --question --text="$1" --width=200 --height=100
}

case "$1" in
"logout")
	confirm "Are you sure you want to log out?" && hyprctl dispatch exit
	;;
"lock")
	confirm "Are you sure you want to lock the screen?" && swaylock
	;;
"sleep")
	confirm "Are you sure you want to sleep the system?" && systemctl suspend
	;;
"pause")
	confirm "Are you sure you want to pause the system?" && systemctl pause
	;;
"restart")
	confirm "Are you sure you want to restart?" && systemctl reboot
	;;
"shutdown")
	confirm "Are you sure you want to shut down?" && systemctl poweroff
	;;
esac
