#!/usr/bin/env bash

declare -a _defers
defer() {
  local command="${@}"
  #printf "add defer: %s\n" "${command}"
  _defers+=("${command}")
}
on_exit() {
  for i in $(seq $((${#_defers[@]} - 1)) -1 0); do
    #printf "defer[%d]: %s\n" $i "${_defers[$i]}"
    eval "${_defers[$i]}"
  done
}
trap on_exit EXIT
