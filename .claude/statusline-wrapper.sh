#!/bin/bash

# Read JSON input once
input=$(cat)

# Get model name
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "UNKNOWN"')

# Get git info from existing script
git_info=$(echo "$input" | bash ~/.claude/statusline-command.sh)

# Get context percentage from ccstatusline
context_pct="CONTEXT: $(echo "$input" | npx ccstatusline)"

# Combine outputs
printf 'MODEL: %s | %s | %s' "$model" "$context_pct" "$git_info"
