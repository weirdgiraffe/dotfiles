CURRENT_SCRIPT_DIR=${${(%):-%x}:a:h}

steps=(paths zim oh-my-posh fzf history zoxide other work)
for ((i = 1; i <= $#steps; i++)); do
    local script="${CURRENT_SCRIPT_DIR}/${steps[i]}.zsh"
    [[ -r "${script}" ]] && source "${script}"
done
