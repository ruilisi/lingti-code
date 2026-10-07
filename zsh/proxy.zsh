# set_proxy [port|off]
#   set_proxy          → 127.0.0.1:8668（默认口）
#   set_proxy 7891     → 换端口
#   set_proxy off      → **清掉**代理（off/clear/unset/none/no/0/- 都认）
#
# 之前想清代理只能记另一个命令名（unset_proxy / proxy off）；
# 现在 set_proxy 自己就能关，不必为了「关」去想端口号。
#
# ⚠️ 关闭词在三个函数里各写一遍，不抽公共函数。
# 抽过一个 `_proxy_is_off_arg`，结果 set_proxy 报 command not found ——
# zsh 把下划线开头的名字留给补全系统，这类函数会被 compinit 的 autoload
# 机制盖掉。而 `claude` 的 alias 里就带着 set_proxy，于是整个 claude 起不来。
# 三行重复 << 一个会把 shell 搞坏的间接层。
set_proxy() {
  case "${1:-}" in off|clear|unset|none|no|0|-) unset_proxy; return 0 ;; esac
  port=${1:-8668}
  export http_proxy=http://127.0.0.1:$port;export https_proxy=http://127.0.0.1:$port;
}
set_ss_proxy() {
  case "${1:-}" in off|clear|unset|none|no|0|-) unset_proxy; return 0 ;; esac
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
  case "${1:-}" in
    off|clear|unset|none|no|0|-) unset_proxy; echo "proxy: off"; return 0 ;;
  esac
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
