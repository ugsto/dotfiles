#!/usr/local/bin/env bash

[[ $- != *i* ]] && return
[ "$TERM_PROGRAM" != "tmux" ] && exec tmux

[ -f /etc/bashrc ] && . /etc/bashrc

preppend_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

__conda_setup=$("$HOME/miniconda3/bin/conda" shell.bash hook 2>/dev/null) &&
eval "$__conda_setup"
unset __conda_setup
if [ -f "/home/kurisu/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/home/kurisu/miniconda3/etc/profile.d/conda.sh"
else
    preppend_path "$HOME/miniconda3/bin"
fi

export PNPM_HOME="$HOME/.local/share/pnpm"
preppend_path "$HOME/.local/bin"
preppend_path "$HOME/.cargo/bin"
preppend_path "$PNPM_HOME"

set -o vi

alias ls="exa --color=auto --icons"
alias cat="bat"

command -v starship &>/dev/null && . <(starship init bash)
command -v conda &>/dev/null && conda activate dev
command -v helm &>/dev/null && . <(helm completion bash)
command -v kubectl &>/dev/null && . <(kubectl completion bash)
. "$HOME/.cargo/env"
