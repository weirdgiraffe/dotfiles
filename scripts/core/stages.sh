#
# This script contains the functions for different installation stages.
# NOTE: this script should not be used directly, it is sourced by the install.sh
#

function install_packages() {(
  source core/defer.sh

  if [[ $(uname) == "Darwin" ]]; then
    pushd "darwin"
    defer popd
    source install_packages.sh
  fi
)}

function download_fonts() {(
  source core/defer.sh

  pushd "${1}"
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip | tar xzf -
  defer popd
)}

function install_fonts() {(
  source core/defer.sh

  FONTS_DOWNLOAD_DIR=$(mktemp -d)
  defer rm -rf "${FONTS_DOWNLOAD_DIR}"
  download_fonts "${FONTS_DOWNLOAD_DIR}"

  if [[ $(uname) == "Darwin" ]]; then
    pushd "darwin"
    defer popd
    source install_fonts.sh
  fi
)}

function setup_python() {(
  pyenv install 3.12.1
  pyenv global 3.12.1
  pip install --upgrade pip
)}

function setup_nvim_python() {(
  pyenv virtualenv 3.12.1 neovim
  pyenv activate neovim
  pip install pynvim
  # additional dependencies for copilot chat
  pip install python-dotenv requests prompt-toolkit
)}

function install_rust() {(
  # install rustup if not installed already
  if [[ ! -x "$(command -v rustup)" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s - -y -q
    mkdir -p ${HOME}/.local/share/zsh/completion
    rustup completions zsh >| ~/.local/share/zsh/completion/_rustup
    rustup completions zsh cargo >| ~/.local/share/zsh/completion/_cargo
  fi
)}

function configure_fzf() {(
  source core/defer.sh

  pushd ${HOME}/.config/fzf
  defer popd

  fzf --zsh > fzf.zsh
  ln -sf themes/kanagawa-wave current-theme.zsh
)}

function configure_kitty() {(
  # set initial kitty colorsheme to be light
  kitty +kitten themes \
    --config-file-name=themes.conf \
    --reload-in=all \
    Kanagawa-wave
)}

