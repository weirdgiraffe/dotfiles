tmux_version_config() {
  local version=${$(tmux -V)#tmux}
  case ${version# } in
    3.*)
      echo tmux3.x.conf
      ;;
    *)
      echo "unexpected tmux version ${version} !"
      exit 1
      ;;
  esac
}

mkdir -p ${HOME}/.config/tmux
touch ${HOME}/.config/tmux/tmux.conf

if [[ $(uname) == "Darwin" ]]; then
    cat os/mac/tmux.conf >> ${HOME}/.config/tmux/tmux.conf
fi

cat tmux.conf >> ${HOME}/.config/tmux/tmux.conf
cat $(tmux_version_config) >> ${HOME}/.config/tmux/tmux.conf
