EXEC=sh

SCRIPTS=scripts
RUNNER=$(SCRIPTS)/runner.sh
CONFIG=~/.config

MANAGED=nvim kitty

.PHONY: all config-all config clean

all:

config-all:
	for program in $(MANAGED); do \
		make config target="$$program"; \
	done

config:
	$(EXEC) $(RUNNER) -t $(target) -p config

clean:
	$(EXEC) $(RUNNER) -t $(target) -p clean
