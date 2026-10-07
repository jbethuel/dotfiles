# Dotfiles

## New machine setup

Install the tools first and copy the config last: the Oh My Zsh, nvm and pnpm
installers all edit `~/.zshrc`, and the copy in step 7 replaces their edits with
`.zsh/.zshrc`.

### 1. Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Put brew on PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Shell

```
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugins sourced at the end of .zshrc
brew install zsh-autosuggestions zsh-syntax-highlighting
```

### 3. Node

```
# nvm (check https://github.com/nvm-sh/nvm for the latest version)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install --lts

# pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

### 4. Git and GitHub CLI

```
brew install git-lfs gh
gh auth login
```

`.gitconfig` uses `gh` as the GitHub credential helper and has no `user.email`;
set it per repo (see `.ssh/README.md`) or with `git config --global`.

### 5. Apps

```
brew install --cask visual-studio-code iterm2

code --install-extension anthropic.claude-code \
  --install-extension esbenp.prettier-vscode \
  --install-extension firsttris.vscode-jest-runner
```

### 6. Claude Code

```
curl -fsSL https://claude.ai/install.sh | bash
claude
```

The installer puts `claude` in `~/.local/bin`, which `.zshrc` adds to `PATH`.
Running `claude` the first time signs you in.

### 7. Copy config

```
cp .zsh/.zshrc ~/.zshrc
cp .gitconfig ~/.gitconfig

mkdir -p ~/.config/git ~/.config/ccstatusline
cp .config/git/ignore ~/.config/git/ignore
cp .config/ccstatusline/settings.json ~/.config/ccstatusline/settings.json

cp vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

mkdir -p ~/.claude/hooks
cp .claude/settings.json ~/.claude/settings.json
cp .claude/hooks/block-dangerous-git.sh ~/.claude/hooks/

source ~/.zshrc
```

`.zsh/.zshrc` hard-codes `/Users/jbethuel` and sets up the Android SDK and
gcloud; drop what the machine does not have. `.ssh/config` is a sample: copy it
to `~/.ssh/config` and point `IdentityFile` at your own keys.

## Agent skills

`.agents/skills/` holds the skills and `.claude/skills/` holds symlinks that
point Claude Code at them. To get the exact versions in this repo:

```
mkdir -p ~/.agents ~/.claude
cp -R .agents/skills ~/.agents/
cp .agents/.skill-lock.json ~/.agents/
cp -R .claude/skills ~/.claude/
```

Or install the latest versions from source with the skills CLI, picking the
skills listed in `.agents/.skill-lock.json`:

```
npx skills add mattpocock/skills -g
npx skills add vercel-labs/skills -s find-skills -g
```

## Claude Code plugins

Plugins are not copied from here. `.claude/settings.json` lists them under
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

`plugins/pstack/` keeps a reference copy of pstack's skills (v0.9.74) with its
licenses. It is for reading only: none of the steps above copy it, and the
plugin is still what Claude Code loads. To refresh it after a plugin update:

```
rsync -a --delete --exclude .DS_Store \
  ~/.claude/plugins/cache/pstack-claude/pstack/<version>/skills/ plugins/pstack/skills/
```
