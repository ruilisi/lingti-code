# set_proxy [port|off]
#   set_proxy          → 127.0.0.1:8668（默认口）
#   set_proxy 7891     → 换端口
#   set_proxy off      → **清掉**代理（off/clear/unset/none/no/0/- 都认）
#
# 之前想清代理只能记另一个命令名（unset_proxy / proxy off）；
# 现在 set_proxy 自己就能关，不必为了「关」去想端口号。
_proxy_is_off_arg() {
  case "${1:-}" in
    off|clear|unset|none|no|0|-) return 0 ;;
    *) return 1 ;;
  esac
}
set_proxy() {
  if _proxy_is_off_arg "${1:-}"; then unset_proxy; return 0; fi
  port=${1:-8668}
  export http_proxy=http://127.0.0.1:$port;export https_proxy=http://127.0.0.1:$port;
}
set_ss_proxy() {
  if _proxy_is_off_arg "${1:-}"; then unset_proxy; return 0; fi
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
#   proxy off          unset all proxy env vars（clear/unset/none/no/0/- 同义）
#   proxy status       print current state (no changes)
proxy() {
  local port
  # 关闭词和 set_proxy 用同一张表，免得两边分叉（`proxy clear` 以前会被当成端口名）
  if _proxy_is_off_arg "${1:-}"; then
    unset_proxy
    echo "proxy: off"
    return 0
  fi
  case "${1:-}" in
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
