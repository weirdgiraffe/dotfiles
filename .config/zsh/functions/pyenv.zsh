() { # cleanup the path removing any possible direct shim referenct from it
  local SHIMS_PATH="${HOME}/.pyenv/shims"
  typeset -U upath
  upath+=($SHIMS_PATH)
  for p ($path) {
    case $p in
      "$SHIMS_PATH"*)
        ;;
      *)
        upath+=($p)
        ;;
    esac
  }
  path=($upath)
  export PATH
  export PYENV_SHELL=zsh
}

pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}
