# Auto-update checker for Lingti
# Asynchronously checks for remote updates on terminal open.
# Set LINGTI_DISABLE_AUTO_UPDATE=1 in ~/.zsh.before/ to opt out.

[[ "$LINGTI_DISABLE_AUTO_UPDATE" == "1" ]] && return

typeset -g _LINGTI_DIR="${HOME}/.lingti"
typeset -g _LINGTI_CHECK_FILE="${_LINGTI_DIR}/.last-update-check"
typeset -g _LINGTI_RESULT_FILE="/tmp/.lingti-update-result-$$"
typeset -g _LINGTI_POLL_COUNT=0
typeset -g _LINGTI_MAX_POLLS=5

[[ -d "${_LINGTI_DIR}/.git" ]] || return

_lingti_should_check() {
  local now=$(date +%s)

  # Skip if last check was less than 1 hour ago
  if [[ -f "$_LINGTI_CHECK_FILE" ]]; then
    local last_check=$(<"$_LINGTI_CHECK_FILE")
    if [[ -n "$last_check" ]] && (( now - last_check < 3600 )); then
      return 1
    fi
  fi

  # Skip if last commit is less than 12 hours old
  local last_commit=$(git -C "$_LINGTI_DIR" log -1 --format=%ct 2>/dev/null)
  if [[ -n "$last_commit" ]] && (( now - last_commit < 43200 )); then
    return 1
  fi

  return 0
}

_lingti_fetch_in_background() {
  print -r -- "$(date +%s)" >! "$_LINGTI_CHECK_FILE"

  (
    local local_head=$(git -C "$_LINGTI_DIR" rev-parse HEAD 2>/dev/null)
    git -C "$_LINGTI_DIR" fetch origin main --quiet 2>/dev/null
    local remote_head=$(git -C "$_LINGTI_DIR" rev-parse origin/main 2>/dev/null)

    if [[ -n "$local_head" && -n "$remote_head" && "$local_head" != "$remote_head" ]]; then
      local ahead=$(git -C "$_LINGTI_DIR" rev-list origin/main..HEAD --count 2>/dev/null)
      local behind=$(git -C "$_LINGTI_DIR" rev-list HEAD..origin/main --count 2>/dev/null)

      if (( ahead > 0 && behind == 0 )); then
        print -r -- "local_ahead:$ahead" > "$_LINGTI_RESULT_FILE"
      else
        print -r -- "update_available" > "$_LINGTI_RESULT_FILE"
      fi
    else
      print -r -- "up_to_date" > "$_LINGTI_RESULT_FILE"
    fi
  ) &!
}

_lingti_check_precmd() {
  # Fetch hasn't completed yet — keep polling
  if [[ ! -f "$_LINGTI_RESULT_FILE" ]]; then
    (( _LINGTI_POLL_COUNT++ ))
    if (( _LINGTI_POLL_COUNT >= _LINGTI_MAX_POLLS )); then
      add-zsh-hook -d precmd _lingti_check_precmd
    fi
    return
  fi

  # One-shot: remove hook before doing anything else
  add-zsh-hook -d precmd _lingti_check_precmd

  local result=$(<"$_LINGTI_RESULT_FILE")
  rm -f "$_LINGTI_RESULT_FILE"

  # Check if local is ahead of remote (PR opportunity)
  if [[ "$result" == local_ahead:* ]]; then
    local ahead_count="${result#local_ahead:}"
    print -P "\n%F{magenta}[lingti]%f Your local branch is $ahead_count commit(s) ahead of origin/main."
    print "  You can create a pull request to share your changes."
    return
  fi

  [[ "$result" == "update_available" ]] || return

  # Determine working tree state
  local is_dirty=0
  [[ -n "$(git -C "$_LINGTI_DIR" status --porcelain 2>/dev/null)" ]] && is_dirty=1

  if (( is_dirty )); then
    # Check for conflicts using merge-tree (read-only, doesn't touch working tree)
    local has_conflict=0
    local merge_base=$(git -C "$_LINGTI_DIR" merge-base HEAD origin/main 2>/dev/null)
    if [[ -n "$merge_base" ]]; then
      if git -C "$_LINGTI_DIR" merge-tree "$merge_base" HEAD origin/main 2>/dev/null \
        | command grep -q '^<<<<<<<'; then
        has_conflict=1
      fi
    fi

    if (( has_conflict )); then
      print -P "\n%F{yellow}[lingti]%f Updates available but your working tree has conflicts with remote."
      print "  Resolve manually: cd ~/.lingti && git stash && git pull --rebase origin main && git stash pop"
    else
      print -P "\n%F{cyan}[lingti]%f Updates available (working tree has uncommitted changes)."
      printf "  Stash, pull, and pop? [y/N] "
      if read -q; then
        print ""
        if git -C "$_LINGTI_DIR" stash --quiet 2>/dev/null \
          && git -C "$_LINGTI_DIR" pull --rebase origin main --quiet 2>/dev/null; then
          if ! git -C "$_LINGTI_DIR" stash pop --quiet 2>/dev/null; then
            print -P "%F{red}[lingti]%f Pull succeeded but stash pop failed. Resolve conflicts in ~/.lingti"
            return
          fi
          print -P "%F{green}[lingti]%f Updated successfully. Restart your shell to apply changes."
        else
          # Pull failed — restore stashed changes
          git -C "$_LINGTI_DIR" stash pop --quiet 2>/dev/null
          print -P "%F{red}[lingti]%f Update failed. Check ~/.lingti for issues."
        fi
      else
        print "\n  Skipped. Run manually: cd ~/.lingti && git pull --rebase origin main"
      fi
    fi
  else
    # Clean working tree
    print -P "\n%F{cyan}[lingti]%f Updates available for ~/.lingti"
    printf "  Pull latest changes? [y/N] "
    if read -q; then
      print ""
      if git -C "$_LINGTI_DIR" pull --rebase origin main --quiet 2>/dev/null; then
        print -P "%F{green}[lingti]%f Updated successfully. Restart your shell to apply changes."
      else
        print -P "%F{red}[lingti]%f Update failed. Check ~/.lingti for issues."
      fi
    else
      print "\n  Skipped. Run manually: cd ~/.lingti && git pull --rebase origin main"
    fi
  fi
}

# Run check if needed
if _lingti_should_check; then
  autoload -Uz add-zsh-hook
  _lingti_fetch_in_background
  add-zsh-hook precmd _lingti_check_precmd
fi
