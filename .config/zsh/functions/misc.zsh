# needed to keep mac os version of ssty instead of the gnu one for oh-my-posh
stty() { /bin/stty $@ }

rfcdate() {
  local input=$1
  if [ -z "${input}" ];then
    TZ=UTC date
  else 
    TZ=UTC date --date='@'${input}
  fi
}

unixdate() {
  local input=$1
  if [ -z "${input}" ];then
    date +%s
  else 
    date --date=${input} +%s
  fi
}

ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# clone the repo and cd to it
gclone() {
  local binary=$(whence -p gclone)
  local dst=$(${binary} ${@})
  [[ -d "${dst}" ]] && cd ${dst}
  pre-commit install --allow-missing-config
}
