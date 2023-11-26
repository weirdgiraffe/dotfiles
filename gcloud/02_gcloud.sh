#!/usr/bin/env zsh
#
if [ ! -x "$(command -v gcloud)" ]; then
  curl -fsSL https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=${HOME}
fi
