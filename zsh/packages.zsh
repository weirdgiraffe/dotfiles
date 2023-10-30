# vim: ft=zsh ts=2 sw=2 sts=2 et

if [ ! -x "$(command -v gcloud)" ]; then
  furl -fsSL https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=${HOME}
  typeset -U path
  path+=(${HOME}/google-cloud-sdk/bin)
  export PATH
  gcloud component install kubectl
fi

if [ ! -f ${HOME}/.zimrc ]; then
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi
