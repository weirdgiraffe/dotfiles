if [ ! -x "$(command -v gcloud)" ]; then
  curl -fsSL https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=${HOME}
fi

if [ ! -f ${HOME}/.zimrc ]; then
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# install powerlevel10k
# https://github.com/romkatv/powerlevel10k
echo "zmodule romkatv/powerlevel10k --use degit" >> ~/.zimrc
source ~/.zshrc
zimfw install

# set up global ignore for fd
mkdir -p ${HOME}/.config/fd
cat << EOF >| ${HOME}/.config/fd/ignore
.git
.svn
.ropeproject
.terraform
__pycache__
vendor
node_modules
EOF
fi

# set up global ignore for rg
mkdir -p ${HOME}/.config/rg
cat << EOF >| ${HOME}/.config/fd/ignore
.git
.svn
.ropeproject
.terraform
__pycache__
vendor
node_modules
EOF
fi
