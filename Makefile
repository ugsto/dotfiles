CONFIG = $(HOME)/.config
MODULES = $(PWD)/modules
TMUX_PLUGIN_DIR = $(HOME)/.tmux/plugins/tpm

.PHONY: all

all: $(CONFIG)/nvim $(CONFIG)/alacritty $(CONFIG)/starship.toml $(HOME)/.tmux.conf $(HOME)/.zshrc

define LINK_RULE
	@if [ -L $(1) ]; then \
		echo "$(1) is already linked"; \
	else \
		ln -sf $(2) $(1); \
		echo "Linked $(1) to $(2)"; \
	fi
endef

$(CONFIG)/nvim:
	$(call LINK_RULE,$@,$(MODULES)/nvim)

$(CONFIG)/alacritty:
	$(call LINK_RULE,$@,$(MODULES)/alacritty)

$(CONFIG)/starship.toml:
	$(call LINK_RULE,$@,$(MODULES)/starship/starship.toml)

$(HOME)/.tmux.conf:
	@git clone https://github.com/tmux-plugins/tpm $(TMUX_PLUGIN_DIR) 2>/dev/null || true
	$(call LINK_RULE,$@,$(MODULES)/tmux/tmux.conf)

$(HOME)/.zshrc:
	$(call LINK_RULE,$@,$(MODULES)/zsh/zshrc)
