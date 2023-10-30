alias vi="nvim"
alias vim="nvim"
alias tf='terraform'
alias k='kubectl'
alias dc="docker compose"

alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

rfcdate() {
  local gdate=$(command -v gdate)
  local input=$1
  if [ -z ${input} ];then
    TZ=UTC ${gdate:=date} --date='@'${input}
  else 
    TZ=UTC ${gdate:=date}
  fi
}

unixddate() {
  local gdate=$(command -v gdate)
  local input=$1
  if [ -z ${input} ];then
    ${gdate:=date} --date=${input} +%s
  else 
    ${gdate:=date} +%s
  fi
}
