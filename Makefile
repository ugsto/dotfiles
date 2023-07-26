.PHONY: all install config config-nvim config-alacritty config-starship test clean

all:

install: config-zsh config-nvim config-alacritty config-starship

config:
	mkdir -p ~/.config

config-zsh:
	ln -sf "$$PWD/.zshrc" ~/.zshrc

config-nvim: config
	mv ~/.config/nvim ~/.config/nvim.bak-$$(date +%s)
	mv ~/.local/share/nvim ~/.local/share/nvim.bak-$$(date +%s) || true
	mv ~/.local/state/nvim ~/.local/state/nvim.bak-$$(date +%s) || true
	mv ~/.cache/nvim ~/.cache/nvim.bak-$$(date +%s) || true
	git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
	ln -sf "$$PWD/astronvim" ~/.config/nvim/lua/user

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
