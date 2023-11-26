#!/usr/bin/env zsh
#
# this script assumes that brew is already installed
# and coreutils package is also installed
#

set -aU install_packages

[ -x "$(command -v psql)" ] || install_packages+=( postgresql )

export install_packages
