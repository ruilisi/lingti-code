alias intercept-request-hosts="sudo tcpdump -i any -A -vv -s 0 |  grep -e 'Host:'"
host-ip() {
  ip route get 8.8.8.8 | awk '/8.8.8.8/ {print $7}'
}
test-port() {
  nc -z localhost $1
}

kill-port() {
  local port=$1
  if [[ -z "$port" ]]; then
    echo "Usage: kill-port <port>"
    return 1
  fi

  local info
  info=$(lsof -iTCP:$port -sTCP:LISTEN -n -P 2>/dev/null)
  if [[ -z "$info" ]]; then
    echo "No process found listening on port $port"
    return 1
  fi

  echo "$info"
  echo ""
  echo -n "Kill this process? [y/N] "
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    local pids
    pids=$(echo "$info" | awk 'NR>1 {print $2}' | sort -u)
    echo "$pids" | xargs kill -9
    echo "Killed PID(s): $pids"
  else
    echo "Aborted."
  fi
}
