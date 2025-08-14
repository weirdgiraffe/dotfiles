#!/usr/bin/env bash

pushd "$(dirname "$0")" || exit
source core/defer.sh
defer popd

source core/stages.sh

install_packages
install_fonts

if [[ -n "${GITHUB_RUN_ID}" ]]; then
	echo "Running in CI, skipping git-crypt unlock"
else
	# now we should have all of our desired packages installed including git-crypt
	# so now we can add our gpg keys and decrypt the sensitive information
	echo "Please import private gpg keys"
	echo ""
	echo "  gpg --armor --import private.key"
	echo "  gpg --armor --import public.key"
	echo ""
	read -rp "Press enter to continue"
	git crypt unlock
fi

setup_python
setup_nvim_python

pushd ..
defer popd

stow -t "${HOME}" .
