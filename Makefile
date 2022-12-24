all: config-bashrc config-nvim config-alacritty config-starship

config-bashrc:
	ln -sf "$$PWD/.bashrc" ~/.bashrc

config-nvim:
	ln -sf "$$PWD/nvim" ~/.config/nvim

config-alacritty:
	ln -sf "$$PWD/alacritty" ~/.config/alacritty

config-starship:
	ln -sf "$$PWD/starship.toml" ~/.config/starship.toml
