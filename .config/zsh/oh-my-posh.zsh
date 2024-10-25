if [[ ! -f ${HOME}/.config/zsh/oh-my-posh-init.zsh ]]; then 
  oh-my-posh init zsh --config=${HOME}/.config/oh-my-posh/config.toml > ${HOME}/.config/zsh/oh-my-posh-init.zsh
fi
source ${HOME}/.config/zsh/oh-my-posh-init.zsh

