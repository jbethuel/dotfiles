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

## Claude Code plugins

Plugins are not vendored here. `.claude/settings.json` lists them under
`enabledPlugins` and their marketplaces under `extraKnownMarketplaces`; Claude
Code downloads them into `~/.claude/plugins/`.

| Plugin   | Source                                                                                 |
| -------- | -------------------------------------------------------------------------------------- |
| pstack   | [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude)        |
| typesafe | [typesafe-ai/skills](https://github.com/typesafe-ai/skills)                            |
| vercel   | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) |

To install one by hand, run these inside Claude Code:

```
/plugin marketplace add michael-denyer/pstack-claude
/plugin install pstack@pstack-claude
```
