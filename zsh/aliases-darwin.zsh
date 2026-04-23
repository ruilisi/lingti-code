if [[ "$(uname)" != "Darwin" ]]; then
  return
fi

alias list_identities='security find-identity -v -p codesigning'

# Chrome with CDP (remote debugging for automation/MCP)
alias chrome-cdp='open -a "Google Chrome" --args --remote-debugging-port=9222 --restore-last-session'
