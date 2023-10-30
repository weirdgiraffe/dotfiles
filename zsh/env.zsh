# vim: ft=zsh ts=2 sw=2 sts=2 et

# gcloud settings and completions
export CLOUDSDK_PYTHON=python3.9
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then
  source "${HOME}/google-cloud-sdk/completion.zsh.inc"

# golang specific settings
export GOPATH=${HOME}/go
export GOPRIVATE=github.com/weirdgiraffe,gitlab.com/glassnode

typeset -U path
path+=(
  ${HOME}/bin
  ${GOPATH}/bin
  ${HOME}/.cargo/bin
  ${HOME}/google-cloud-sdk/bin
)
export PATH
