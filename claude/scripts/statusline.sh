#!/bin/bash

input=$(cat)

# Debug: full input dump — lets us see every field Claude Code passes
cache="$HOME/.claude/cache"
mkdir -p "$cache" 2>/dev/null
echo "$input" | jq -c '.' > "$cache/statusline_input_debug.json" 2>/dev/null

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
style=$(echo "$input" | jq -r '.output_style.name // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
limit=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Session name — top-level .session_name in Claude Code hook input;
# fall back to short .session_id when a session hasn't been named
session_name=$(echo "$input" | jq -r '.session_name // empty' 2>/dev/null)
if [ -z "$session_name" ]; then
  sid=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)
  [ -n "$sid" ] && session_name="${sid:0:8}"
fi

total=$((total_in + total_out))

# 1M / 200k / 512 — pick the shortest human-readable form of a token limit
humanize() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    if (( n % 1000000 == 0 )); then printf '%dM' $(( n / 1000000 ))
    else printf '%.1fM' "$(echo "scale=1; $n/1000000" | bc)"
    fi
  elif [ "$n" -ge 1000 ]; then
    printf '%dk' $(( n / 1000 ))
  else
    printf '%d' "$n"
  fi
}

status="$(basename "$dir")"
[ -n "$session_name" ] && status="$status » $session_name"
status="$status | $model"
[ -n "$style" ] && status="$status ($style)"
if [ $limit -gt 0 ]; then
  # e.g. `1M T(66.6%)` — the % is REMAINING context (not used)
  tokens_seg="$(humanize $limit) T"
  if [ -n "$remaining" ]; then
    tokens_seg="$tokens_seg($(printf '%.1f' "$remaining")%)"
  fi
  status="$status | $tokens_seg"
fi

# --- Weekly usage vs limit (Pro/Max only; present after first API response) ---
# rate_limits carries used_percentage + resets_at (Unix epoch). Absent for API-key
# auth or before the first response of a session -> segment is simply skipped.
cache="$HOME/.claude/cache"
mkdir -p "$cache" 2>/dev/null
# Debug: dump the raw rate_limits block so used-% / windows can be reconciled vs /usage.
echo "$input" | jq -c '.rate_limits // "absent"' > "$cache/rate_limits_debug.json" 2>/dev/null

wk=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage // empty')
wk_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
fiveh=$(echo "$input"  | jq -r '.rate_limits.five_hour.used_percentage // empty')

if [ -n "$wk" ]; then
  wkint=${wk%.*}; wkint=${wkint:-0}
  rem=$(( 100 - wkint )); [ $rem -lt 0 ] && rem=0
  fivint=${fiveh%.*}; fivrem=""
  [ -n "$fiveh" ] && fivrem=$(( 100 - fivint ))

  # 10-cell bar shows REMAINING (fills = how much left)
  filled=$(( (rem + 5) / 10 ))
  [ $filled -gt 10 ] && filled=10
  [ $filled -lt 0 ] && filled=0
  bar=""
  i=0
  while [ $i -lt 10 ]; do
    if [ $i -lt $filled ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$((i+1))
  done

  # color by REMAINING: green plenty (>=40), amber getting low (15-39), red low (<15)
  if   [ "$rem" -lt 15 ]; then c=$'\033[31m'
  elif [ "$rem" -lt 40 ]; then c=$'\033[33m'
  else                         c=$'\033[32m'
  fi
  rst=$'\033[0m'; dim=$'\033[2m'

  # Compact so it doesn't clip: weekly-remaining + short bar + reset day. (5h kept
  # in cache/debug but not shown, to save width.)
  seg="${c}Wk ${rem}% ▕${bar}▏${rst}"
  if [ -n "$wk_reset" ]; then
    rd=$(date -r "$wk_reset" '+%a' 2>/dev/null)
    [ -n "$rd" ] && seg="$seg ${dim}↺$rd${rst}"
  fi
  status="$status | $seg"

  # cache (kept for optional future tmux use / debugging)
  {
    echo "WK_PCT=${wkint}"
    echo "WK_REMAINING=${rem}"
    echo "WK_RESET=${wk_reset}"
    echo "FIVEH_PCT=${fivint}"
    echo "TS=$(date +%s)"
  } > "$cache/usage.env" 2>/dev/null
fi

echo "$status"
