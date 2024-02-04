ZSH_CONF_DIR=${HOME}/.config/zsh
[[ -d ${ZSH_CONF_DIR} ]] || mkdir -p ${ZSH_CONF_DIR}
[[ -r ${ZSH_CONF_DIR}/init.zsh ]] && source ${ZSH_CONF_DIR}/init.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
