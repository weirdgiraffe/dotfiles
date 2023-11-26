# vim: noet ai ts=4 sw=4

.PHONY: all
all: 
	brew bundle
	echo PATH=$(brew --prefix)"/opt/coreutils/libexec/gnubin:$$PATH" >> ~/.zshrc
    sudo dscl . -create /Users/$USER UserShell $(brew --prefix)/bin/zsh
