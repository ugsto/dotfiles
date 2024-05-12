#!/usr/bin/env sh

set -ex

ln -sf "$PWD/assets/tmux" ~/.config/tmux
ln -sf "$PWD/assets/.tmux.conf" ~/.tmux.conf
