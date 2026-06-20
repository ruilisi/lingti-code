alias git_log_commiter_author='git log --pretty=format:"%h %ce %ae"'

# gpr-all [DIR] — git pull --rebase across every immediate subdirectory
# that is a git repo. Default DIR is the current directory.
#
# Useful in a workspace like ~/Projects/ to sync everything at once.
# Each repo is updated with --autostash so dirty trees don't block the
# rebase. Failures don't abort the loop — a summary is printed at the end.
gpr-all() {
  local root="${1:-.}"
  local total=0 ok=0 fail=0 skipped=0
  local failures=()
  local tmp_out
  tmp_out=$(mktemp -t gpr-all.XXXXXX)

  for dir in "$root"/*/; do
    if [[ ! -d "$dir/.git" ]]; then
      skipped=$((skipped + 1))
      continue
    fi
    total=$((total + 1))
    local name="${dir%/}"; name="${name##*/}"
    printf "→ %-32s " "$name"

    ( cd "$dir" && git pull --rebase --autostash ) > "$tmp_out" 2>&1
    local rc=$?

    if (( rc == 0 )); then
      if grep -q "Already up to date" "$tmp_out"; then
        echo "○ up to date"
      else
        echo "✅ updated"
      fi
      ok=$((ok + 1))
    else
      echo "❌ failed"
      failures+=("$name")
      fail=$((fail + 1))
    fi
  done
  rm -f "$tmp_out"

  echo ""
  echo "── $ok/$total ok, $fail failed, $skipped non-git skipped ──"
  if (( fail > 0 )); then
    echo "Failed repos: ${failures[*]}"
    return 1
  fi
}
