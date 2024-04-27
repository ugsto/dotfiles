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

# Gcup

[ -f "/home/kurisu/.ghcup/env" ] && source "/home/kurisu/.ghcup/env"

## Setup default editor

export EDITOR=nvim

## Setup PATH variable

prepend_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

### Python

__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

### Haskell

[ -f "/home/kurisu/.ghcup/env" ] && . "/home/kurisu/.ghcup/env" # ghcup-env

### Global binaries

prepend_path "/bin"
prepend_path "/sbin"
prepend_path "/usr/bin"
prepend_path "/usr/sbin"
prepend_path "/usr/local/bin"
prepend_path "/usr/local/sbin"
prepend_path "/var/lib/snapd/snap/bin"
prepend_path "/snap/bin"
prepend_path "$HOME/.surrealdb"

### local binaries

prepend_path "$HOME/.local/bin"

### rust

prepend_path "$HOME/.cargo/bin"

### nodejs

PNPM_HOME="$HOME/.local/share/pnpm"
prepend_path "$PNPM_HOME"

NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
prepend_path "$BUN_INSTALL/bin"


### go

GOPATH="$HOME/go"
prepend_path "$GOPATH/bin"

### ruby

[ -d "$HOME/.local/share/gem/ruby/" ] && for RUBY_PATH in "$HOME/.local/share/gem/ruby/"*; do
    [ -d "$RUBY_PATH/bin" ] && prepend_path "$RUBY_PATH/bin"
done
prepend_path "$HOME/bin"

### java

JAVA_HOME="/usr/lib/jvm/default"
prepend_path "$JAVA_HOME/bin"

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
command -v influx &>/dev/null && . <(influx completion zsh)

## Load secrets

[ -f "$HOME/.local/bin/load-secrets.sh" ] && . "$HOME/.local/bin/load-secrets.sh"

## Export variables

export DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR
export BUN_INSTALL
export PNPM_HOME
export GOPATH
export NVM_DIR

## MOTD

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
