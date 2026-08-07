#!/usr/bin/env bash
#
# Sync this repo's .agents/ and .claude/ into ~/.agents/ and ~/.claude/.
#
# Files that already exist at the destination are replaced. Files that exist
# only at the destination (~/.claude/settings.local.json, projects/, history,
# etc.) are left alone -- nothing is ever deleted.
#
# Symlinks are copied as symlinks, so .claude/skills/<name> keeps pointing at
# ../../.agents/skills/<name>, which resolves to ~/.agents/skills/<name>.
#
# settings.local.json is excluded: Claude Code writes it per-project, so the
# copy in this repo is not the one that belongs in ~/.claude.

set -euo pipefail

SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(.agents .claude)

DRY_RUN=false
EXISTING_ONLY=false
BACKUP=false
BACKUP_ROOT="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'EOF'
Usage: ./install-agents.sh [options]

Copies <repo>/.agents and <repo>/.claude into ~/.agents and ~/.claude.
Existing destination files are replaced; unrelated destination files are kept.
Nothing is deleted. .DS_Store and settings.local.json are never copied.

Options:
  -n, --dry-run    Show what would change without writing anything.
      --existing   Only update files that already exist in ~; skip new ones.
                   (rsync may still create the empty parent dirs.)
  -b, --backup     Save replaced files under ~/.dotfiles-backups/<timestamp>/.
  -h, --help       Show this help.

Output markers:
  new     file did not exist in ~ and was created
  update  file existed in ~ and was replaced
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)  DRY_RUN=true ;;
    --existing)    EXISTING_ONLY=true ;;
    -b|--backup)   BACKUP=true ;;
    -h|--help)     usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

sync_dir() {
  local name="$1"
  local src="$SRC_ROOT/$name"
  local dest="$HOME/$name"

  if [[ ! -d "$src" ]]; then
    echo "skip $name/ (not in repo)"
    return
  fi

  # Guard against ~/.agents already being a symlink into this repo.
  if [[ -e "$dest" ]] && [[ "$(cd "$src" && pwd -P)" == "$(cd "$dest" && pwd -P)" ]]; then
    echo "skip $name/ ($dest already resolves to the repo)"
    return
  fi

  # --checksum so files whose mtime drifted but whose contents match are left
  # alone, which keeps the report below honest.
  local args=(
    -a --checksum --itemize-changes
    --exclude '.DS_Store'
    --exclude 'settings.local.json'
  )
  $DRY_RUN       && args+=(--dry-run)
  $EXISTING_ONLY && args+=(--existing)
  if $BACKUP && ! $DRY_RUN; then
    mkdir -p "$BACKUP_ROOT/$name"
    args+=(--backup "--backup-dir=$BACKUP_ROOT/$name")
  fi

  mkdir -p "$dest"

  echo "==> $name/ -> $dest/"
  # Itemize lines starting with "." are metadata-only (usually a directory
  # mtime) and transfer nothing, so they are dropped. A "+" in column 4 means
  # the item is being created rather than replaced.
  rsync "${args[@]}" "$src/" "$dest/" | awk '
    /^[>c]/ {
      change = (substr($0, 4, 1) == "+") ? "new   " : "update"
      path = $0
      sub(/^[^ ]+ /, "", path)
      print "  " change "  " path
      seen++
    }
    END { if (!seen) print "  (already up to date)" }
  '
}

$DRY_RUN && echo "DRY RUN -- no files will be written"

for target in "${TARGETS[@]}"; do
  sync_dir "$target"
done

if $BACKUP && ! $DRY_RUN; then
  echo "Replaced files backed up to $BACKUP_ROOT/"
fi
