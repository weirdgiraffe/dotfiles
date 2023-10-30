# vim: ft=zsh ts=2 sw=2 sts=2 et

if [ ! -x "$(command -v gcloud)" ]; then
  http \
     --download \
     --output /tmp/install_gcloud.sh \
     https://sdk.cloud.google.com
  bash /tmp/install_gcloud.sh \
    --disable-prompts \
    --install-dir=${HOME}
  gcloud component install kubectl
fi

if [ ! -f ${HOME}/.zimrc ]; then
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi
