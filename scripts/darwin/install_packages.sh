#
# This script installs all needed brew packages for mac os
# NOTE: this script should not be used directly, it is sourced by the install.sh
#

# install Homebrew if it is not installed (https://brew.sh/)
if [ ! -x "$(command -v brew)" ]; then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# adjust the place for hammerspoon config
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

brew bundle

# setting up gpg https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
if [[ ! -d ~/.gnupg ]]; then
  mkdir ~/.gnupg
  echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >| ~/.gnupg/gpg-agent.conf
  echo 'use-agent' >| ~/.gnupg/gpg.conf
  chmod 700 ~/.gnupg
fi

# completion for bitwraden-cli are not working by default
# because they just miss the activation of compdef.
BW_COMPLETION_FILE=$(brew --prefix)/share/zsh/site-functions/_bitwarden-cli
# ensure that we don't add this line twice
gsed -i '/^compdef _bw bw$/d' ${BW_COMPLETION_FILE}
# actually add the missing line
gsed -i 's/^\(#compdef _bw bw\)$/\1\n\ncompdef _bw bw\n/' ${BW_COMPLETION_FILE}

