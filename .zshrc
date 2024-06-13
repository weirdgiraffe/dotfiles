ZSH_CONF_DIR=${HOME}/.config/zsh
[[ -d ${ZSH_CONF_DIR} ]] || mkdir -p ${ZSH_CONF_DIR}
[[ -r ${ZSH_CONF_DIR}/init.zsh ]] && source ${ZSH_CONF_DIR}/init.zsh
