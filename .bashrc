#!/usr/local/bin/env bash

# Bash setup

[[ $- != *i* ]] && return

## Set tmux if not set already

if [ "$TERM_PROGRAM" != "tmux" ]; then
    command -v tmux &>/dev/null && exec tmux
fi

## Set vi mode

set -o vi

## Setup PATH variable

preppend_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

### Python

if [ -f "/usr/etc/profile.d/conda.sh" ]; then
    . "/usr/etc/profile.d/conda.sh"  # commented out by conda initialize
else
    preppend_path "$HOME/miniconda3/bin"
fi

### local binaries
preppend_path "$HOME/.local/bin"

### rust
preppend_path "$HOME/.cargo/bin"

### nodejs
PNPM_HOME="$HOME/.local/share/pnpm"
preppend_path "$PNPM_HOME"

### go
GOPATH="$HOME/go"
preppend_path "$GOPATH/bin"

### ruby
for path in "$HOME/.local/share/gem/ruby/"*; do
    [ -d "$path/bin" ] && preppend_path "$path/bin"
done

## Setup aliases

alias ls="exa --color=auto --icons"
alias sudo="doas"

## Setup Desktop variables

DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
XDG_RUNTIME_DIR="/run/user/$(id -u)"

## Setup completions

command -v doas &>/dev/null && alias sudo="doas" && complete -cf doas
command -v conda &>/dev/null && conda activate dev
command -v starship &>/dev/null && . <(starship init bash)
command -v helm &>/dev/null && . <(helm completion bash)
command -v kubectl &>/dev/null && . <(kubectl completion bash)

## Load secrets

[ -f "$HOME/.local/bin/load-secrets.sh" ] && . "$HOME/.local/bin/load-secrets.sh"

## Export variables

export DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR
export PNPM_HOME
export GOPATH
