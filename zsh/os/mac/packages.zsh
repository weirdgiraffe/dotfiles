# vim: ft=zsh ts=2 sw=2 sts=2 et

# install Homebrew if it is not installed (https://brew.sh/)
if [ ! -x "$(command -v brew)" ]; then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

set -aU packages

[ -x "$(command -v gls)" ]    || packages+=( coreutils )
[ -x "$(command -v gsed)" ]   || packages+=( gnu-sed )
[ -x "$(command -v tree)" ]   || packages+=( tree )
[ -x "$(command -v rg)" ]     || packages+=( ripgrep )
[ -x "$(command -v fd)" ]     || packages+=( fd )
[ -x "$(command -v jq)" ]     || packages+=( jq )
[ -x "$(command -v yq)" ]     || packages+=( yq )
[ -x "$(command -v fzf)" ]    || packages+=( fzf )
[ -x "$(command -v bat)" ]    || packages+=( bat )
[ -x "$(command -v ranger)" ] || packages+=( ranger )
[ -x "$(command -v http)" ]   || packages+=( httpie )
[ -x "$(command -v tmux)" ]   || packages+=( tmux )
[ -x "$(command -v nvim)" ]   || packages+=( neovim )

# python 3.9 is required for gcloud sdk
[ -x "$(command -v python3.9)" ] || packages+=( "python@3.9" )

# next package is needed for using terminal efficiently
[ -x "$(command -v reattach-to-user-namespace)" ] || packages+=( "reattach-to-user-namespace" )

[ -x "$(command -v psql)" ]      || packages+=( postgresql )
[ -x "$(command -v terraform)" ] || packages+=( terraform )
[ -x "$(command -v helm)" ]      || packages+=( helm )
[ -x "$(command -v go)" ]        || packages+=( go )
[ -x "$(command -v rust)" ]      || packages+=( rust )

brew install "${packages[@]}"
