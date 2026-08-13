#!/bin/bash

# Read JSON input once
input=$(cat)

# Get model name
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "UNKNOWN"')

# Get git info from existing script
git_info=$(echo "$input" | bash ~/.claude/statusline-command.sh)

# Get context percentage from ccstatusline
context_pct="CONTEXT: $(echo "$input" | npx ccstatusline)"

# Get 5-hour session usage percentage
session_pct=$(echo "$input" | jq -r '
  if .rate_limits.five_hour.used_percentage != null
  then "SESSION: \(.rate_limits.five_hour.used_percentage)%"
  else "SESSION: N/A"
  end
')

# Combine outputs
printf 'MODEL: %s | %s | %s | %s\n' \
  "$model" \
  "$context_pct" \
  "$session_pct" \
  "$git_info"
