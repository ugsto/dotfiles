CONFIG = $(HOME)/.config
MODULES = $(PWD)/modules
TMUX_PLUGIN_DIR = $(HOME)/.tmux/plugins/tpm
ZSH_COMPLETIONS_DIR = $(HOME)/.zsh/completions

CONFIG_FILES = \
	$(CONFIG)/nvim \
	$(CONFIG)/alacritty \
	$(CONFIG)/hypr \
	$(CONFIG)/mise \
	$(CONFIG)/starship.toml \
	$(HOME)/.tmux.conf \
	$(HOME)/.zshrc

.PHONY: all clean completions

define LINK_RULE
	@if [ -L $(1) ]; then \
		echo "$(1) is already linked"; \
	else \
		ln -sf $(2) $(1); \
		echo "Linked $(1) to $(2)"; \
	fi
endef

define CREATE_COMPLETION
	@if [ -f $(1) ]; then \
		echo "$(1) already exists"; \
	else \
		$(2) > $(1); \
		echo "Created $(1)"; \
	fi
endef

define CONFIRM_RULE
	@echo -n $(1) && read -n 1 ANSWER && echo; \
	if [ "$$ANSWER" = $(2) ]; then \
		$(3); \
	else \
		$(4); \
	fi
endef

all: $(CONFIG_FILES)

$(CONFIG):
	mkdir -p $@

$(CONFIG)/%: $(CONFIG)
	$(call LINK_RULE,$@,$(MODULES)/$*)

$(HOME)/.tmux.conf: $(CONFIG)
	@git clone https://github.com/tmux-plugins/tpm $(TMUX_PLUGIN_DIR) 2>/dev/null || true
	$(call LINK_RULE,$@,$(MODULES)/tmux/tmux.conf)

$(HOME)/.zshrc: $(CONFIG)
	$(call LINK_RULE,$@,$(MODULES)/zshrc)

completions: $(ZSH_COMPLETIONS_DIR)/_helm.zsh $(ZSH_COMPLETIONS_DIR)/_kubectl.zsh $(ZSH_COMPLETIONS_DIR)/_minikube.zsh $(ZSH_COMPLETIONS_DIR)/_kind.zsh $(ZSH_COMPLETIONS_DIR)/_karmadactl.zsh $(ZSH_COMPLETIONS_DIR)/_cilium.zsh $(ZSH_COMPLETIONS_DIR)/_arduino-cli.zsh $(ZSH_COMPLETIONS_DIR)/_mgc.zsh $(ZSH_COMPLETIONS_DIR)/_uv.zsh $(ZSH_COMPLETIONS_DIR)/_tailscale.zsh

$(ZSH_COMPLETIONS_DIR):
	mkdir -p $@

$(ZSH_COMPLETIONS_DIR)/_helm.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,helm completion zsh)

$(ZSH_COMPLETIONS_DIR)/_kubectl.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,kubectl completion zsh)

$(ZSH_COMPLETIONS_DIR)/_minikube.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,minikube completion zsh)

$(ZSH_COMPLETIONS_DIR)/_kind.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,kind completion zsh)

$(ZSH_COMPLETIONS_DIR)/_karmadactl.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,karmadactl completion zsh)

$(ZSH_COMPLETIONS_DIR)/_cilium.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,cilium completion zsh)

$(ZSH_COMPLETIONS_DIR)/_arduino-cli.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,arduino-cli completion zsh)

$(ZSH_COMPLETIONS_DIR)/_mgc.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,mgc completion zsh)

$(ZSH_COMPLETIONS_DIR)/_uv.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,uv generate-shell-completion zsh)

$(ZSH_COMPLETIONS_DIR)/_tailscale.zsh: $(ZSH_COMPLETIONS_DIR)
	$(call CREATE_COMPLETION,$@,tailscale completion zsh)

clean:
	$(call CONFIRM_RULE,'Are you sure? [y/N] ','y',rm -rf $(CONFIG_FILES),echo 'Aborting...')
