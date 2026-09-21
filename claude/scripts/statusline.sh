#!/bin/bash

input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
style=$(echo "$input" | jq -r '.output_style.name // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
limit=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

total=$((total_in + total_out))

status="$(basename "$dir") | $model"
[ -n "$style" ] && status="$status ($style)"
[ $limit -gt 0 ] && status="$status | Tokens: $(printf "%'d/%'d" $total $limit 2>/dev/null || echo "$total/$limit")"
[ -n "$remaining" ] && status="$status ($(printf "%.1f" $remaining)% remaining)"

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
  seg="${c}Wk ${rem}% left ▕${bar}▏${rst}"
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
