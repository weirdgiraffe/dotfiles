local function scripts_to_load() {
  local current_dir=${${(%):-%x}:a:h}
  local steps=(
    paths
    zim
    oh-my-posh
    fzf
    history
    zoxide
    other
    work
  )
  for ((i = 1; i <= $#steps; i++)); do
      local script="${current_dir}/${steps[i]}.zsh"
      [[ -r "${script}" ]] && echo "${script}"
  done
}

for script in $(scripts_to_load); do
  source "${script}"
done
