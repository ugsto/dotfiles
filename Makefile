.PHONY: all install config config-nvim config-alacritty config-starship test clean

all:

install: config-zsh config-nvim config-alacritty config-starship

config:
	mkdir -p ~/.config

config-zsh:
	ln -sf "$$PWD/.zshrc" ~/.zshrc

config-nvim: config
	ln -sf "$$PWD/nvim" ~/.config

config-alacritty: config
	ln -sf "$$PWD/alacritty" ~/.config

config-starship: config
	ln -sf "$$PWD/starship.toml" ~/.config

test:
	echo "@TODO"

clean:
	rm -rf ~/.config/nvim
	rm -rf ~/.config/alacritty
	rm -rf ~/.config/starship.toml
