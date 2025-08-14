#
# This script installs all needed brew packages for mac os
# NOTE: this script should not be used directly, it is sourced by the install.sh
#

# install Homebrew if it is not installed (https://brew.sh/)
if [ ! -x "$(command -v brew)" ]; then
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# adjust the place for hammerspoon config
defaults write org.hammerspoon.Hammerspoon MJConfigFile "${HOME}/.config/hammerspoon/init.lua"

brew bundle

# setting up gpg https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
if [[ ! -d ~/.gnupg ]]; then
	mkdir ~/.gnupg
	echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >|~/.gnupg/gpg-agent.conf
	echo 'use-agent' >|~/.gnupg/gpg.conf
	chmod 700 ~/.gnupg
fi
