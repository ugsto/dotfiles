#!/usr/bin/env sh

list_workspaces() {
	hyprctl workspaces -j | jq --raw-output --indent 0 '.[]'
}

render_button() {
	local active_workspace_id="$(hyprctl activeworkspace -j | jq --raw-output '.id')"

	while read workspace; do
		local id="$(echo $workspace | jq --raw-output '.id')"
		local name="$(echo $workspace | jq --raw-output '.name')"

		if [ "$id" = "$active_workspace_id" ]; then
			cat <<-EOF
				(button :class "font-sans font-size-xs fg-green px-2 clickable"
				        :onclick "hyprctl dispatch workspace $name"
				        "$name")
			EOF
		else
			cat <<-EOF
				(button :class "font-sans font-size-xs fg-text px-2 clickable"
				        :onclick "hyprctl dispatch workspace $name"
				        "$name")
			EOF
		fi
	done
}

wrap_buttons() {
	echo $(
		cat <<-EOF
			(box :class "rounded-lg bg-surface0 px-2"
			     :space-evenly false
			     (label :class "font-material fg-text"
			            :text "workspaces")
			     (box :class "ml-1"
			          :spacing 4
			          $@))
		EOF
	)
}

handle() {
	case "$1" in
	"focusedmon>>"* | "workspace>>"* | "setup")
		wrap_buttons $(list_workspaces | render_button)
		;;
	esac
}

handle setup

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
