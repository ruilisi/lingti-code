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

echo "$status"
