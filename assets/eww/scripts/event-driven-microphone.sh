get_volume() {
	pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print substr($5, 1, length($5) - 1); exit}'
}

get_is_muted() {
	LANG=en_US pactl get-source-mute @DEFAULT_SOURCE@ | grep --quiet 'yes$' && echo true || echo false
}

wrap_volume() {
	jq \
		--null-input \
		--compact-output \
		--argjson volume "$1" \
		--argjson is_muted "$2" \
		'{
      volume: $volume,
      is_muted: $is_muted
    }'
}

handle() {
	case "$1" in
	"Event 'change' on source"* | "setup")
		wrap_volume "$(get_volume)" "$(get_is_muted)"
		;;
	esac
}

handle setup

LANG=en_US pactl subscribe | while read -r line; do handle "$line"; done
