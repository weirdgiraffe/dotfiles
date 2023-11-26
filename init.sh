#!/usr/bin/env bash


# for macos we need posix utils to be installed, so we could rely
# on the command line utilities to behave the same way as in linux
if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -z $(command -v brew) ]]; then
    # https://brew.sh/
    echo "Installing  brew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
      | bash -l
  fi
fi
