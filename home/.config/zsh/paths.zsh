# golang specific settings
export GOPRIVATE=github.com/weirdgiraffe

path+=(
  ${HOME}/bin
  $(go env GOPATH)/bin
)

source "$HOME/.cargo/env"

if [ -x "$(command -v brew)" ]; then
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}"
fi

export PATH

