# --- ZIM
# https://github.com/zimfw/zimfw?tab=readme-ov-file#manual-installation
zstyle ':zim:zmodule' use 'degit'

ZIM_HOME=${HOME}/.local/state/zim
[[ -d ${ZIM_HOME} ]] || mkdir -p ${ZIM_HOME}

# download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# initialize zim modules.
source ${ZIM_HOME}/init.zsh
