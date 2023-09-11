#!/usr/bin/env sh

set -ex

mv ~/.config/nvim ~/.config/nvim.bak-$(date +%s) || true
mv ~/.local/share/nvim ~/.local/share/nvim.bak-$(date +%s) || true
mv ~/.local/state/nvim ~/.local/state/nvim.bak-$(date +%s) || true
mv ~/.cache/nvim ~/.cache/nvim.bak-$(date +%s) || true
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
ln -sf "$PWD/assets/astronvim" ~/.config/nvim/lua/user
