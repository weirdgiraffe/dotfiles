#!/usr/bin/env zsh
#
# this script assumes that brew is already installed
# and coreutils package is also installed
#

set -aU install_packages
[ -x "$(command -v python3.9)" ] || install_packages+=( "python@3.9" )

export install_packages
