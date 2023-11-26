# vim: noet ai ts=4 sw=4

.PHONY: all
all:
	echo "make [zsh]"

.PHONY: zsh
zsh:
	@sh init.sh
	@cd zsh && brew bundle
