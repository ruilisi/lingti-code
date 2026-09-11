set_proxy() {
  port=${1:-8668}
  export http_proxy=http://127.0.0.1:$port;export https_proxy=http://127.0.0.1:$port;
}
set_ss_proxy() {
  port=${1:-1080}
  export https_proxy=socks5://127.0.0.1:${port}
  export http_proxy=socks5://127.0.0.1:${port}
}
unset_proxy() {
  unset http_proxy https_proxy ftp_proxy no_proxy
}

# proxy — friendly wrapper around set_proxy / unset_proxy
#   proxy              interactive: pop up current port (or 8668) to edit
#   proxy <port>       set http+https proxy to 127.0.0.1:<port>
#   proxy off          unset all proxy env vars
#   proxy status       print current state (no changes)
proxy() {
  local port
  case "${1:-}" in
    off|unset|no|"0")
      unset_proxy
      echo "proxy: off"
      return 0 ;;
    status)
      [[ -n "$http_proxy" ]] && echo "proxy: $http_proxy" || echo "proxy: off"
      return 0 ;;
    "")
      # pre-fill with the current port if set, else 8668; vared lets you
      # edit before pressing Enter
      port="${http_proxy##*:}"
      port="${port:-8668}"
      vared -p "proxy port: " port || return 1
      ;;
    *)
      port="$1" ;;
  esac
  set_proxy "$port"
  echo "proxy: http://127.0.0.1:$port"
}
