# golang specific settings
path+=(
  ${HOME}/bin
  $(go env GOPATH)/bin
)

export GOPRIVATE=github.com/weirdgiraffe

[[ -d "${HOME}/.cargo" ]] && source "$HOME/.cargo/env"
[[ -x "$(command -v brew)" ]] && path=("$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}" path)

# needed to keep mac os version instead of the gnu one for oh-my-posh
stty() { /bin/stty $@ }

export PATH

