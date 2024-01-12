# golang specific settings
export GOPRIVATE=github.com/weirdgiraffe

path+=(
  ${HOME}/bin
  $(go env GOPATH)/bin
  ${HOME}/.cargo/bin
)

if [ -x "$(command -v brew)" ]; then
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
  PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}"
fi

export PATH
