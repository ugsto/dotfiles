#!/usr/bin/env zsh

# zsh setup


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ $- != *i* ]] && return

## Set tmux if not set already

if [ "$TERM_PROGRAM" != "tmux" ]; then
    command -v tmux &>/dev/null && exec tmux
fi

## Set vi mode

set -o vi

## Setup search backward

bindkey -v
bindkey '^R' history-incremental-search-backward

## Clear screen

clear-scrollback-and-screen () {
  zle clear-screen
  tmux clear-history
}
zle -N clear-scrollback-and-screen
bindkey -v '^L' clear-scrollback-and-screen

## Z plug

[ -f /usr/share/zsh/scripts/zplug/init.zsh ] && . /usr/share/zsh/scripts/zplug/init.zsh

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

__conda_setup="$('/home/kurisu/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kurisu/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kurisu/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kurisu/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

### Global binaries

preppend_path "/bin"
preppend_path "/sbin"
preppend_path "/usr/bin"
preppend_path "/usr/sbin"
preppend_path "/usr/local/bin"
preppend_path "/usr/local/sbin"
preppend_path "/var/lib/snapd/snap/bin"
preppend_path "/snap/bin"

### local binaries

preppend_path "$HOME/.local/bin"

### rust

preppend_path "$HOME/.cargo/bin"

### nodejs

PNPM_HOME="$HOME/.local/share/pnpm"
preppend_path "$PNPM_HOME"
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### go

GOPATH="$HOME/go"
preppend_path "$GOPATH/bin"

### ruby

[ -d "$HOME/.local/share/gem/ruby/" ] && for RUBY_PATH in "$HOME/.local/share/gem/ruby/"*; do
    [ -d "$RUBY_PATH/bin" ] && preppend_path "$RUBY_PATH/bin"
done

## Setup aliases

autoload -Uz compinit
compinit

command -v exa &>/dev/null && alias ls="exa --color=auto --icons"
command -v bat &>/dev/null && alias cat="bat"
command -v shell-genie &>/dev/null && alias chat="shell-genie ask"
command -v kubectl &>/dev/null && alias k="kubectl"

command -v python3 &>/dev/null && randint() {
    python3 -c "import random; print(random.randint($1, $2))"
}

[ -f "$HOME/.local/bin/aliases.sh" ] && . "$HOME/.local/bin/aliases.sh"
[ -f "$HOME/.local/bin/functions.sh" ] && . "$HOME/.local/bin/functions.sh"

## Setup Desktop variables

DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
XDG_RUNTIME_DIR="/run/user/$(id -u)"

## Setup completions

command -v starship &>/dev/null && . <(starship init zsh)
command -v helm &>/dev/null && . <(helm completion zsh)
command -v kubectl &>/dev/null && . <(kubectl completion zsh)
command -v doctl &>/dev/null && . <(doctl completion zsh)
command -v ng &>/dev/null && . <(ng completion script)

## Load secrets

[ -f "$HOME/.local/bin/load-secrets.sh" ] && . "$HOME/.local/bin/load-secrets.sh"

## Export variables

export DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR
export PNPM_HOME
export GOPATH
export NVM_DIR

## MOTD

/usr/local/bin/update_motd
cat /etc/motd

# Powerlevel10k

source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
