if [ ! -x "$(command -v gcloud)" ]; then
  curl -fsSL https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=${HOME}
fi

if [ ! -f ${HOME}/.zimrc ]; then
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi
