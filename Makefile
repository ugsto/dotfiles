CONFIG=~/.config
MODULES=$$PWD/modules

.PHONY: all nvim alacritty tmux zsh

all: nvim alacritty tmux zsh

nvim:
	@if [ -L $(CONFIG)/nvim ]; then \
		echo "nvim is already linked"; \
		exit 0; \
	fi; \
	ln -sf "$(MODULES)/nvim" $(CONFIG)/nvim

alacritty:
	@if [ -L $(CONFIG)/alacritty ]; then \
		echo "alacritty is already linked"; \
		exit 0; \
	fi; \
	ln -sf "$(MODULES)/alacritty" $(CONFIG)/alacritty

tmux:
	@git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || true
	@if [ -L ~/.tmux.conf ]; then \
		echo "tmux is already linked"; \
		exit 0; \
	fi; \
	ln -sf "$(MODULES)/tmux/tmux.conf" ~/.tmux.conf

zsh:
	@if [ -L ~/.zshrc ]; then \
		echo "zsh is already linked"; \
		exit 0; \
	fi; \
	ln -sf "$(MODULES)/zsh/zshrc" ~/.zshrc
