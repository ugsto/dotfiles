all: config-bashrc config-nvim config-alacritty config-starship

config:
	mkdir -p ~/.config

config-bashrc:
	ln -sf "$$PWD/.bashrc" ~/.bashrc

config-nvim: config
	ln -sf "$$PWD/nvim" ~/.config

config-alacritty: config
	ln -sf "$$PWD/alacritty" ~/.config

config-starship: config
	ln -sf "$$PWD/starship.toml" ~/.config
