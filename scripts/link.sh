#!/usr/bin/env bash


# for macos we need posix utils to be installed, so we could rely
# on the command line utilities to behave the same way as in linux
if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -z $(command -v brew) ]]; then
    # https://brew.sh/
    echo "Installing  brew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
      | bash -l
    # https://github.com/Homebrew/homebrew-bundle#usage
    brew bundle

    PATH=$(brew --prefix)"/bin:$PATH"
    PATH=$(brew --prefix)"/opt/coreutils/libexec/gnubin:$PATH"
    export PATH

    # set zsh version of zsh to be default
    # https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
    echo "setting brew version of zsh as default shell"
    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
  fi
fi
