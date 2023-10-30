if [ ! -x "$(command -v gcloud)" ]; then
  curl -fsSL https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=${HOME}
fi

if [ ! -f ${HOME}/.zimrc ]; then
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# install powerlevel10k
# https://github.com/romkatv/powerlevel10k
echo "zmodule romkatv/powerlevel10k --use degit" >> ~/.zimrc
zsh -c "zimfw install"
