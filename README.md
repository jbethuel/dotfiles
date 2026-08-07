# Doftiles

## Prerequisites

```
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install oh-my-zsh
brew install zsh
```

## Agent skills

`.agents/` and `.claude/` hold the shared skill set. To push them into your home
directory, preview first, then sync:

```
./install-agents.sh --dry-run
./install-agents.sh
```

Existing files in `~/.agents` and `~/.claude` are replaced; anything else there
(sessions, projects, `settings.local.json`) is left untouched, and nothing is
deleted. Use `--backup` to keep copies of whatever gets replaced.
