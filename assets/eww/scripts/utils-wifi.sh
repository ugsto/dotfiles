#!/usr/bin/env sh

case "$1" in
"--SSID")
	nmcli connection show --active | awk '$3 == "wifi" {print $1; exit}'
	;;
"--SIGNAL")
	nmcli --fields IN-USE,SIGNAL device wifi list | awk '$1 == "*" {print $2}'
	;;
esac
