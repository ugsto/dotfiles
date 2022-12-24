#!/usr/local/bin/env bash

[[ $- != *i* ]] && return
[ "$TERM_PROGRAM" != "tmux" ] && exec tmux

preppend_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/miniconda3/etc/profile.d/conda.sh"
else
    preppend_path "$HOME/miniconda3/bin"
fi

preppend_path "$HOME/go/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"
preppend_path "$HOME/.local/bin"
preppend_path "$HOME/.cargo/bin"
preppend_path "$PNPM_HOME"
for path in "$HOME/.local/share/gem/ruby/"*; do
    [ -d "$path/bin" ] && preppend_path "$path/bin"
done

set -o vi

alias ls="exa --color=auto --icons"
#alias cat="bat"

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

command -v starship &>/dev/null && . <(starship init bash)
command -v conda &>/dev/null && conda activate dev
command -v helm &>/dev/null && . <(helm completion bash)
command -v kubectl &>/dev/null && . <(kubectl completion bash)
. "$HOME/.cargo/env"
